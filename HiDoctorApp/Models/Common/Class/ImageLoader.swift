//
//  ImageLoader.swift
//  HiDoctorApp
//
//  Created by swaasuser on 20/02/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class ImageLoader
{
    let cache = NSCache<NSString, NSData>()
    
    class var sharedLoader : ImageLoader {
        struct Static {
            static let instance : ImageLoader = ImageLoader()
        }
        return Static.instance
    }
    
    func imageForUrl(urlString : String , completion : @escaping(_ image : UIImage?) -> ())
    {
        let data = self.cache.object(forKey: urlString as NSString)
        if let goodData = data
        {
            let image = UIImage(data: goodData as Data)
            completion(image)
            return
        }
        else
        {
            if let encodedUrl  = urlString.addingPercentEncoding(withAllowedCharacters: getCharacterSet())
            {
                if let url = URL(string: encodedUrl)
                {
                    if checkInternetConnectivity(){
                    WebServiceWrapper.sharedInstance.getDataFromUrl(url: url)
                    { (data) in
                        
                        if data != nil
                        {
                            if let data = data
                            {
                                let image = UIImage(data: data)
                                self.cache.setObject(data as NSData, forKey: urlString as NSString)
                                completion(image)
                                return
                            }
                            
                        }
                        else
                        {
                            completion(nil)
                            return
                        }
                        
                    }
                }
                }
                else
                {
                    completion(nil)
                    return
                }
            }
            else
            {
                completion(nil)
                return
            }
        }
    }
    
    func gifForUrl(urlString : String , completion : @escaping(_ data : Data?) -> ())
    {
        let data = self.cache.object(forKey: urlString as NSString)
        if let goodData = data
        {
            completion(goodData as Data)
            return
        }
        else
        {
            if let encodedUrl  = urlString.addingPercentEncoding(withAllowedCharacters: getCharacterSet())
            {
                if let url = URL(string: encodedUrl)
                {
                    WebServiceWrapper.sharedInstance.getDataFromUrl(url: url)
                    { (data) in
                        
                        if data != nil
                        {
                            if let data = data
                            {
                                self.cache.setObject(data as NSData, forKey: urlString as NSString)
                                completion(data)
                                return
                            }
                            
                        }
                        else
                        {
                            completion(nil)
                            return
                        }
                        
                    }
                }
                else
                {
                    completion(nil)
                    return
                }
            }
            else
            {
                completion(nil)
                return
            }
        }
    }
    
    //MARK:- Create thumbnail image from video url
    
    func createImageFromVideo(videoUrl : String, additionalDetail : Any, completionHandler: @escaping(_ image: UIImage?,_ url: String, _ additionalDetail : Any ) -> ()  )
    {
         DispatchQueue.global(qos: .background).async
         { () in
            
            let data: NSData? = self.cache.object(forKey: videoUrl as NSString)
            if let goodData = data {
                let image = UIImage(data: goodData as Data)
                DispatchQueue.main.async(execute: {() in
                    completionHandler(image, videoUrl, additionalDetail)
                })
                return
            }
            
            if let encodedUrl  = videoUrl.addingPercentEncoding(withAllowedCharacters: getCharacterSet())
                {
                
                if let videoURLString =  URL(string: encodedUrl)
                {
                    let asset = AVAsset(url: videoURLString)
                    let assetImgGenerate = AVAssetImageGenerator(asset: asset)
                    assetImgGenerate.appliesPreferredTrackTransform = true
                    var time = asset.duration
                    time.value = min(time.value, 2)
                    do
                    {
                        let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                        let frameImg = UIImage(cgImage: img)
                        if let imageData = UIImagePNGRepresentation(frameImg)
                        {
                            self.cache.setObject(imageData as NSData, forKey: videoUrl as NSString)
                        }
                        DispatchQueue.main.async(execute: {() in
                            completionHandler(frameImg, videoUrl, additionalDetail)
                        })
                        return
                    }
                    catch
                    {
                        DispatchQueue.main.async(execute: {() in
                            completionHandler(nil, videoUrl, additionalDetail)
                        })
                        return
                    }
                }
                else
                {
                    DispatchQueue.main.async(execute: {() in
                        completionHandler(nil, videoUrl, additionalDetail)
                    })
                    return
                }
            }
            else
            {
                DispatchQueue.main.async(execute: {() in
                    completionHandler(nil, videoUrl, additionalDetail)
                })
                return
            }
        }
    }
    
    
}
