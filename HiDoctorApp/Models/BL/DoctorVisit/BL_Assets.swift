//
//  BL_Assets.swift
//  HiDoctorApp
//
//  Created by Vijay on 19/04/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import Photos

class BL_Assets: NSObject
{
    static let sharedInstance : BL_Assets = BL_Assets()
    
    func fetchCustomAlbumPhotos(albumType : PHAssetCollectionType, predicate : PHFetchOptions?) ->  PHFetchResult<PHAssetCollection>
    {
        let resultCollections = PHAssetCollection.fetchAssetCollections(with: albumType, subtype: .any, options: predicate)
        return resultCollections
    }
    
    func fetchPhotoAccordingToLocalIdentifier(localIdentifier : String) -> PHFetchResult<PHAssetCollection>
    {
        let resultCollection = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [localIdentifier], options: nil)
        return resultCollection
    }
    
    func getCameraRollModel() -> PhotoModel?
    {
        var model : PhotoModel?
        
        let resultCollection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        
        for i in 0..<resultCollection.count
        {
            let collection = resultCollection[i]
            let assets = PHAsset.fetchAssets(in:collection, options: nil)
            
            if assets.count > 0
            {
                let photoModelObj = PhotoModel()
                photoModelObj.albumTitle = collection.localizedTitle
                photoModelObj.albumCount = assets.count
                photoModelObj.thumbnail = getAssetThumbnail(asset: assets.lastObject!, assetSize: CGSize(width: 100, height: 100))
                photoModelObj.localIdentifier = collection.localIdentifier
                model = photoModelObj
            }
        }
        
        return model
    }
    
    func generateAlbumArray() -> [PhotoModel]
    {
        var albumArray : [PhotoModel] = []
        
        let resultCollection = fetchCustomAlbumPhotos(albumType: .album, predicate: nil)
        
        for i in 0..<resultCollection.count
        {
            let collection = resultCollection[i]
            let assets = PHAsset.fetchAssets(in:collection, options: nil)
            
            if assets.count > 0
            {
                let photoModelObj = PhotoModel()
                photoModelObj.albumTitle = collection.localizedTitle
                photoModelObj.albumCount = assets.count
                photoModelObj.thumbnail = getAssetThumbnail(asset: assets.lastObject!, assetSize: CGSize(width: 100, height: 100))
                photoModelObj.localIdentifier = collection.localIdentifier
                albumArray.append(photoModelObj)
            }
        }
        return albumArray
    }
    
    func generateDefaultArray() -> [PhotoModel]
    {
        var albumArray : [PhotoModel] = []
        
        let resultCollection = fetchCustomAlbumPhotos(albumType: .smartAlbum, predicate: nil)
        
        for i in 0..<resultCollection.count
        {
            let collection = resultCollection[i]
            let assets = PHAsset.fetchAssets(in:collection, options: nil)
            
            if assets.count > 0
            {
                let photoModelObj = PhotoModel()
                photoModelObj.albumTitle = collection.localizedTitle
                photoModelObj.albumCount = assets.count
                photoModelObj.thumbnail = getAssetThumbnail(asset: assets.lastObject!, assetSize: CGSize(width: 100, height: 100))
                photoModelObj.localIdentifier = collection.localIdentifier
                albumArray.append(photoModelObj)
            }
        }
        return albumArray
    }
    
    func getCurrentArray() -> [PhotoModel]
    {
        let defaultArray = generateAlbumArray()
        
        var currentArray = generateDefaultArray()
        
        for obj in defaultArray
        {
            currentArray.append(obj)
        }
        return currentArray
    }
    
    func getImageAccordingToAlbum(localIdentifier : String) -> [PhotoCollectionModel]
    {
        var assetArray : [PHAsset] = []
        let resultCollection =  fetchPhotoAccordingToLocalIdentifier(localIdentifier: localIdentifier)
        for i in 0..<resultCollection.count
        {
            let collection = resultCollection[i]
            let assets = PHAsset.fetchAssets(in:collection, options: nil)
            
            for i in 0..<assets.count
            {
                assetArray.append(assets[i])
            }
        }
        let array = convertToAssetModel(assetArr: assetArray)
        return array
    }
    
    
    func convertToPhotoModel(imageArray : [UIImage]) -> [PhotoCollectionModel]
    {
        var list : [PhotoCollectionModel] = []
        
        for img in imageArray
        {
            let obj = PhotoCollectionModel()
            obj.img = img
            obj.isSelectedCount = 0
            list.append(obj)
        }
        return list
    }
    
    func convertToAssetModel(assetArr: [PHAsset]) -> [PhotoCollectionModel]
    {
        var list : [PhotoCollectionModel] = []
        
        for asset in assetArr
        {
            let obj = PhotoCollectionModel()
            obj.asset = asset
            obj.isSelectedCount = 0
            list.append(obj)
        }
        
        return list
    }
    
    func getAssetThumbnail(asset: PHAsset, assetSize: CGSize) -> UIImage
    {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        
        manager.requestImage(for: asset, targetSize: assetSize, contentMode: .aspectFit, options: option, resultHandler: {(result, info) -> Void in
            if let getResult = result
            {
                thumbnail = getResult
            }
        })
        return thumbnail
    }
    
    func getUIImage(asset: PHAsset) -> UIImage? {
        
        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            manager.requestImageData(for: asset, options: options) { data, _, _, _ in
                
                DispatchQueue.main.async(execute: {
                    if let data = data {
                        img = UIImage(data: data)
                    }
                })
            }
        }
        return img
    }
    
}

class PhotoModel: NSObject
{
    var albumTitle : String!
    var albumCount : Int!
    var thumbnail : UIImage!
    var localIdentifier : String!
    var albumType : PHAssetCollectionType = PHAssetCollectionType.album
}

class PhotoCollectionModel : NSObject
{
    var asset : PHAsset!
    var img : UIImage!
    var isSelectedCount : Int = 0
}
