//
//  MessageTableViewCell.swift
//  HiDoctorApp
//
//  Created by Vijay on 01/09/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var attachmentcellHeight: NSLayoutConstraint!
    @IBOutlet weak var messageSenderName: UILabel!
    @IBOutlet weak var messageDateandTime: UILabel!
    @IBOutlet weak var messageSubject: UILabel!
    @IBOutlet weak var messageContent: UILabel!
    @IBOutlet weak var readLabel: UILabel!
    @IBOutlet weak var fileLabel: UILabel!
    
    override func awakeFromNib() {
        
        //set corner radius for read label
        readLabel.layer.cornerRadius = 5
        readLabel.layer.masksToBounds = true
        
        //collection View Delegates
        self.attachementCollectionView.delegate = self
        self.attachementCollectionView.dataSource = self
        super.awakeFromNib()
        
    }
    
    @IBOutlet weak var attachementCollectionView: UICollectionView!
    var attachmentList : [MailMessageAttachment] = []
    var selectedIndex: Int!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       self.attachementCollectionView.collectionViewLayout.invalidateLayout()
        return attachmentList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = attachementCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionViewIdentifier.MessageAttachmentCollectionCell, for: indexPath) as! MessageAttachmentCollectionViewCell
        
        cell.activityIndicator.isHidden = false
        
        if(attachmentList[indexPath.item].AttachmentType == Constants.AttachmentType.image)
        {
            cell.fileNameLbl.text = ""
            
            cell.activityIndicator.isHidden = true
            cell.imageView.image = UIImage(named: "icon-image")
            cell.fileNameLbl.text = attachmentList[indexPath.item].FileName
            self.downloadImage(objAttachment: attachmentList[indexPath.item], imageView: cell.imageView, fileNameLbl: cell.fileNameLbl)
        }
        else if(attachmentList[indexPath.item].AttachmentType == Constants.AttachmentType.excel)
        {
            cell.activityIndicator.isHidden = true
            cell.imageView.image = UIImage(named: "icon-excel")
            cell.fileNameLbl.text = attachmentList[indexPath.item].FileName
        }
        else if(attachmentList[indexPath.item].AttachmentType == Constants.AttachmentType.word)
        {
            cell.activityIndicator.isHidden = true
            cell.imageView.image = UIImage(named: "icon-word")
            cell.fileNameLbl.text = attachmentList[indexPath.item].FileName
        }
        else if(attachmentList[indexPath.item].AttachmentType == Constants.AttachmentType.pdf)
        {
            cell.activityIndicator.isHidden = true
            cell.imageView.image = UIImage(named: "icon-pdf")
            cell.fileNameLbl.text = attachmentList[indexPath.item].FileName
        }
        else if(attachmentList[indexPath.item].AttachmentType == Constants.AttachmentType.zip)
        {
            cell.activityIndicator.isHidden = true
            cell.imageView.image = UIImage(named: "icon-zip")
            cell.fileNameLbl.text = attachmentList[indexPath.item].FileName
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let localPath =  attachmentList[indexPath.item].Blob_Url
        navigateTowebView(siteUrl: localPath!,title:attachmentList[indexPath.item].FileName)
    }
    
    func navigateTowebView(siteUrl:String, title:String)
    {
        let sb = UIStoryboard(name: mainSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: webViewVCID) as! WebViewController
        vc.siteURL = siteUrl
        vc.title = title
        getAppDelegate().root_navigation.pushViewController(vc, animated: true)
    }
    
    private func downloadImage(objAttachment: MailMessageAttachment, imageView: UIImageView, fileNameLbl: UILabel)
    {
        let imageView = imageView
        
        if (checkNullAndNilValueForString(stringData: objAttachment.Blob_Url) != EMPTY)
        {
//            DownloadManager.sharedInstance.downLoadImageForUrl(urlString: objAttachment.Blob_Url, additionalDetail: imageView, completionHandler: { (downloadedImage, url) in
//                if (downloadedImage != nil)
//                {
//                    imageView.image = downloadedImage! //Bl_Attachment.sharedInstance.imageResize(imageObj: downloadedImage!)
//                    fileNameLbl.text = EMPTY
//                }
//            })
            
            ImageLoadingWithCache.sharedInstance.getImage(url: objAttachment.Blob_Url, imageView: imageView, textLabel: fileNameLbl)
        }
    }
}
