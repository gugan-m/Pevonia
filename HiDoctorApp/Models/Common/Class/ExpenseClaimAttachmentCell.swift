//
//  ExpenseClaimAttachmentCell.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 18/04/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class ExpenseClaimAttachmentCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource {

    
    @IBOutlet weak var title:UILabel!
    @IBOutlet weak var showAllBut:UIButton!
    @IBOutlet weak var collectionView:UICollectionView!
    var expenseAttachmentList : [ExpenseAttachmentList] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
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
        return expenseAttachmentList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "ClaimAttachmentCell", for: indexPath) as! UICollectionViewCell
        let getAttachmentData = expenseAttachmentList[indexPath.row]
        let attachmentName = cell.viewWithTag(1) as! UILabel
        let attachmentImage = cell.viewWithTag(2) as! UIImageView
        
        attachmentName.text = getAttachmentData.File_Name
        //        // .jpeg, .jpg, .gif, .tif, .png, .pdf
        if(getAttachmentData.Image_File_Path.contains("png")||getAttachmentData.Image_File_Path.contains("jpg")||getAttachmentData.Image_File_Path.contains("jpeg"))
        {
            attachmentImage.image = #imageLiteral(resourceName: "image-placeholder")
        }
        else if(getAttachmentData.Image_File_Path.contains("pdf"))
        {
            attachmentImage.image = #imageLiteral(resourceName: "icon-pdf-thumbnail")
        }
        else
        {
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let getAttachmentData = self.expenseAttachmentList[indexPath.row]
        if let url = URL(string: getAttachmentData.Image_File_Path) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:])
            } else {
                // Fallback on earlier versions
            }
        }
    }

}
