//
//  MessageComposeCell.swift
//  HiDoctorApp
//
//  Created by Vijay on 27/09/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class MessageComposeCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var attachmentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var attachmentCollectionView: UICollectionView!
    var attachmentList : [String] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        attachmentCollectionView.delegate = self
        attachmentCollectionView.dataSource = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attachmentList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = attachmentCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionViewIdentifier.MessageAttachmentCollectionCell, for: indexPath) as! MessageAttachmentCollectionViewCell
        
        cell.activityIndicator.isHidden = true
        cell.closeBut.tag = indexPath.item
        cell.closeBut.addTarget(self, action: #selector(closeBut(sender:)), for: .touchUpInside)
        
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("\("Mail/"+Constants.MessageConstants.newAttachment)/"+attachmentList[indexPath.row])
            let documentType = attachmentList[indexPath.row].components(separatedBy: ".")
            let document = documentType[documentType.count-1]
            if(document == png || document == jpg || document == jpeg || document == gif || document == tif || document == tiff)
            {
            cell.imageView.image = UIImage(contentsOfFile: imageURL.path)
                cell.fileNameLbl.text = ""
            }
            else if(document == zip)
            {
               cell.imageView.image = UIImage(named: "icon-zip")
                cell.fileNameLbl.text = attachmentList[indexPath.row]
            }
            else if(document == doc || document == docx)
            {
                cell.imageView.image = UIImage(named: "icon-word")
                cell.fileNameLbl.text = attachmentList[indexPath.row]
            }
            else if(document == xls || document == xlsx)
            {
                cell.imageView.image = UIImage(named: "icon-excel")
                cell.fileNameLbl.text = attachmentList[indexPath.row]
            }
            else if(document == pdf)
            {
                cell.imageView.image = UIImage(named: "icon-pdf")
                cell.fileNameLbl.text = attachmentList[indexPath.row]
            }
        }
        
        
        return cell
    }
    @objc func closeBut(sender:UIButton)
    {
        let indexpath = sender.tag
        BL_Mail_Message.sharedInstance.selectedImage.remove(at: indexpath)
        self.attachmentList = BL_Mail_Message.sharedInstance.selectedImage
        self.attachmentCollectionView.reloadData()
        if(self.attachmentList.count == 0)
        {
           self.attachmentHeightConstraint.constant = 0
        }
    }
    func navigateTowebView(siteUrl:String, title:String)
    {
        let sb = UIStoryboard(name: mainSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: webViewVCID) as! WebViewController
        vc.siteURL = siteUrl
        vc.title = title
        getAppDelegate().root_navigation.pushViewController(vc, animated: true)
        
    }

}
