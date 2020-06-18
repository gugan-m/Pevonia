//
//  PhotosViewController.swift
//  HiDoctorApp
//
//  Created by Vijay on 19/04/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import Photos

class PhotosViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionViewWrapper: UIView!
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var emptyStateWrapper: UIView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    
    var selectedDirectory : PhotoModel!
    var albumList : [PhotoCollectionModel] = []
    var selectedAssetList : [PHAsset] = []
    var tempImageList: [Int: UIImage] = [Int: UIImage]()
    var skippedImgCount = 0
    var isFromMessage = false
    var isFromChemistDay = false
    var isfromLeave = false
    var isFromEditDoctor = false
    var isFromNotes = false
    var isFromTP = false
    var selectedImages = [String]()
    var maxFileUploadCountValue = Int()
    var tpDoctor_Regioncode = ""
     var tpDoctor_code: String = ""
    var leaveTypeName : String = ""
    var startDate : Date = Date()
    var endDate : Date = Date()
    var leaveTypeCode : String = ""
    
    //MARK:- Controller Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(isFromEditDoctor)
        {
            maxFileUploadCountValue = 1
        }
        else
        {
            maxFileUploadCountValue = maxFileUploadCount
        }
        // Do any additional setup after loading the view.
        if selectedDirectory != nil
        {
            addCustomLblToNavigationBar(mainTitle: selectedDirectory.albumTitle)
            albumList = BL_Assets.sharedInstance.getImageAccordingToAlbum(localIdentifier : selectedDirectory.localIdentifier)
        }
        else
        {
            let model = BL_Assets.sharedInstance.getCameraRollModel()
            if model != nil
            {
                addCustomLblToNavigationBar(mainTitle: (model?.albumTitle)!)
                albumList = BL_Assets.sharedInstance.getImageAccordingToAlbum(localIdentifier : (model?.localIdentifier)!)
            }
            else
            {
                addCustomLblToNavigationBar(mainTitle: "Camera Roll")
                albumList = []
            }
        }
        showHideViews(imgArr: albumList)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeCustomLblFromNavBar()
    }
    
    //MARK:- Show/Hide views
    func showHideViews(imgArr: [PhotoCollectionModel])
    {
        if imgArr.count > 0
        {
            collectionViewWrapper.isHidden = false
            collectionView.reloadData()
            
            self.view.layoutIfNeeded()
            let contentSize = collectionView.collectionViewLayout.collectionViewContentSize
            if contentSize.height > collectionView.bounds.size.height
            {
                let targetContentOffset = CGPoint(x: 0.0, y: contentSize.height - collectionView.bounds.size.height)
                collectionView.contentOffset = targetContentOffset
            }
            emptyStateWrapper.isHidden = true
        }
        else
        {
            collectionViewWrapper.isHidden = true
            emptyStateWrapper.isHidden = false
            emptyStateLbl.text = photoEmptyMsg
        }
    }
    
    //MARK:- Collection view delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return albumList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionViewIdentifier.CustomImageLibPhotoCell, for: indexPath) as! PhotoViewCellCollectionViewCell
        
        let obj = albumList[indexPath.row]
        
        if let getImage = tempImageList[indexPath.row]
        {
            cell.img.image = getImage
        }
        else
        {
            cell.img.image = UIImage(named: "placeholder")
            getThumbnailImg(index: indexPath.row)
        }
        
        if obj.isSelectedCount > 0
        {
            cell.view.backgroundColor = UIColor.blue
            cell.lblHgtConst.constant = 30
            cell.countLbl.text = "\(obj.isSelectedCount)"
        }
        else
        {
            cell.view.backgroundColor = UIColor.clear
            cell.lblHgtConst.constant = 0
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        return CGSize(width: (SCREEN_WIDTH/3) , height: (SCREEN_WIDTH/3))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let obj = albumList[indexPath.row]
        
        if obj.isSelectedCount == 0
        {
            let filteredArray = albumList.filter {
                $0.isSelectedCount > 0
            }
            var fileArrayCount = Int()
            if(isFromMessage)
            {
                if(BL_Mail_Message.sharedInstance.forwardImage == 0)
                {
                    fileArrayCount = BL_Mail_Message.sharedInstance.selectedImage.count
                }
                else
                {
                    fileArrayCount = BL_Mail_Message.sharedInstance.forwardImage + BL_Mail_Message.sharedInstance.selectedImage.count
                }
            }
            else if(isFromEditDoctor)
            {
                fileArrayCount = BL_DoctorList.sharedInstance.selectedImage.count
   
            }
            else if(isFromChemistDay)
            {
                fileArrayCount = Bl_Attachment.sharedInstance.getChemistAttachmentCount()
            }
            else if(isfromLeave)
            {
                fileArrayCount = Bl_Attachment.sharedInstance.getLeaveAttachmentCount()
            }
            else if (isFromNotes)
            {
                fileArrayCount = 0
            }
            else if (isFromTP)
            {
                fileArrayCount = Bl_Attachment.sharedInstance.getTPAttachmentCount()
            }
            else
            {
                fileArrayCount = Bl_Attachment.sharedInstance.getAttachmentCount()
            }
            if (fileArrayCount + filteredArray.count) < maxFileUploadCountValue
            {
                obj.isSelectedCount = filteredArray.count + 1
            }
            else
            {
                showToastView(toastText: "You can not upload more than \(maxFileUploadCountValue) files")
            }
        }
        else
        {
            obj.isSelectedCount = 0
            reloadSelectionCount()
        }
        
        self.collectionView.reloadData()
    }
    
    //MARK:- Get thumbnail image
    func getThumbnailImg(index: Int)
    {
        let obj = albumList[index]
        
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.resizeMode = .exact
        options.deliveryMode = .highQualityFormat
        
        let assetWidth = CGFloat(obj.asset.pixelWidth)
        let assetHeight = CGFloat(obj.asset.pixelHeight)
        let cropLength = assetWidth < assetHeight ? assetWidth : assetHeight
        
        let cropWidthRatio = cropLength / assetWidth
        let cropHeightRatio = cropLength / assetHeight
        let cropRect = CGRect(x: (1 - cropWidthRatio) / 2, y: (1 - cropHeightRatio) / 2, width: cropWidthRatio, height: cropHeightRatio)
        options.normalizedCropRect = cropRect
        
        let targetWidth = 150
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            manager.requestImage(for: obj.asset, targetSize: CGSize(width: targetWidth, height: targetWidth), contentMode: .default, options: options, resultHandler: {(result, info) -> Void in
                DispatchQueue.main.async(execute: {
                    if let getResult = result
                    {
                        self.tempImageList[index] = getResult
                        self.collectionView.reloadData()
                    }
                })
            })
        }
    }
    
    //MARK:- Multiple items selection methods
    func reloadSelectionCount()
    {
        var selectionCount : Int = 0
        
        for obj in albumList
        {
            if obj.isSelectedCount > 0
            {
                selectionCount = selectionCount + 1
                obj.isSelectedCount = selectionCount
            }
        }
        self.collectionView.reloadData()
    }
    
    func getSelectedAsset()
    {
        if selectedAssetList.count > 0
        {
            selectedAssetList = []
        }
        
        let filteredAsset = albumList.filter {
            $0.isSelectedCount > 0
        }
        
        for obj in filteredAsset
        {
            selectedAssetList.append(obj.asset)
        }
    }
    
    //MARK:- Image task methods
    @objc func doneBtnClicked()
    {
        getSelectedAsset()
        
        if selectedAssetList.count > 0
        {
            showCustomActivityIndicatorView(loadingText: "Saving the Images..")
            initiateImgTask()
        }
        else
        {
            popPhotoAlbumControllers()
        }
    }
    
    func initiateImgTask()
    {
        if selectedAssetList.count > 0
        {
            let firstAsset = selectedAssetList.first
            
            let manager = PHImageManager.default()
            let options = PHImageRequestOptions()
            options.version = .original
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async
                {
                    manager.requestImageData(for: firstAsset!, options: options) { data, _, _, _ in
                        
                        DispatchQueue.main.async(execute:
                            {
                                if let getData = data
                                {
                                    if let getImg = UIImage(data: getData)
                                    {
                                        if let resizedImg = Bl_Attachment.sharedInstance.imageResize(imageObj: getImg)
                                        {
                                            if let imgData = UIImagePNGRepresentation(resizedImg)
                                            {
                                                //Transform into Megabytes
                                                var imageSize = Float(imgData.count)
                                                imageSize = imageSize/(1024*1024)
                                                
                                                if imageSize > maxFileSize
                                                {
                                                    self.skippedImgCount = self.skippedImgCount + 1
                                                }
                                                else
                                                {
                                                    let formatter = DateFormatter()
                                                    formatter.dateFormat = "ddMMyyyyhhmmssSSS"
                                                    let timestamp:String = formatter.string(from: getCurrentDateAndTime())
                                                    let fileName = "\(timestamp).\(png)"
                                                    let fileSize = Bl_Attachment.sharedInstance.convertToBytes(number: imageSize)
                                                    
                                                    if(self.isFromMessage)
                                                    {
                                                       let _ =  BL_Mail_Message.sharedInstance.writeFile(fileData: imgData, msgCode: Constants.MessageConstants.newAttachment, blobUrl: fileName)
                                    
                                                        self.selectedImages.append(fileName)
                                                    }
                                                        else if(self.isFromEditDoctor)
                                                    {
                                                        self.selectedImages = []
//                                                         let _ =  BL_DoctorList.sharedInstance.writeFile(fileData: imgData, msgCode: Constants.DoctorProfile.newImage, blobUrl: fileName)
                                                        BL_DoctorList.sharedInstance.selectedImageData = NSData()
                                                        BL_DoctorList.sharedInstance.selectedImageData = imgData as NSData
                                                            self.selectedImages.append(fileName)
                                                      
                                                    }
                                                    else
                                                    {
                                                        // Save the attachment in the document directory
                                                        Bl_Attachment.sharedInstance.saveAttachmentFile(fileData: imgData, fileName: fileName)
                                                        if (self.isFromChemistDay)
                                                        {
                                                           Bl_Attachment.sharedInstance.insertChemistAttachment(attachmentName: fileName, attachmentSize: fileSize)
                                                        }
                                                        else if(self.isfromLeave)
                                                        {
                                                            //Bl_Attachment.sharedInstance.insertLeaveAttachment(attachmentName: fileName, attachmentSize: fileSize)
                                                            
                                                            Bl_Attachment.sharedInstance.insertLeaveAttachment(attachmentName: fileName, attachmentSize: fileSize, fromDate: self.startDate, toDate: self.endDate, leaveTypeCode: self.leaveTypeCode, leaveTypeName: self.leaveTypeName)
                                                        }
                                                        else if(self.isFromNotes)
                                                        {
                                                            let dict: NSDictionary = [:]
                                                            var notes : [NotesAttachment] = []
                                                            //notes.append()
                                                            let note : NotesAttachment? = NotesAttachment(dict:dict)
                                                            note?.AttachmentName = fileName
                                                            notes.append(note!)
                                                            //let note : NotesAttachment?
                                                            //note?.AttachmentName = fileName
                                                            // notes.insert(note, at: 0)
                                                            
                                                            DBHelper.sharedInstance.insertNotesAttachmentDetail(dcrAttachmentModel: note!)
                                                        }
                                                        else if (self.isFromTP)
                                                        {
                                                            Bl_Attachment.sharedInstance.insertTPAttachment(attachmentName: fileName, doctor_Id: 0, doctor_Code:  self.tpDoctor_code, doctor_Regioncode: self.tpDoctor_Regioncode)
                                                        }
                                                        else
                                                        {
                                                            // Save the attachment in the DB
                                                            Bl_Attachment.sharedInstance.insertAttachment(attachmentName: fileName, attachmentSize: fileSize)
                                                        }
                                                    }
                                                }
                                                
                                                self.getNextImgTask()
                                            }
                                            else
                                            {
                                                self.getNextImgTask()
                                            }
                                        }
                                        else
                                        {
                                            self.getNextImgTask()
                                        }
                                    }
                                    else
                                    {
                                        self.getNextImgTask()
                                    }
                                }
                                else
                                {
                                    self.getNextImgTask()
                                }
                        })
                    }
            }
        }
        else
        {
            removeCustomActivityView()
            
            if skippedImgCount > 0
            {
                skippedImgCount = 0
                if skippedImgCount != selectedAssetList.count
                {
                    AlertView.showAlertView(title: alertTitle, message: "File size should not exceed \(maxFileSize) MB. Any of the \(skippedImgCount) images in your selected list exceeded \(maxFileSize) MB")
                }
                else
                {
                    AlertView.showAlertView(title: alertTitle, message: "File size should not exceed \(maxFileSize) MB. All images in your selected list exceeded \(maxFileSize) MB")
                }
            }
            else
            {
                if(isFromMessage)
                {
                    if(BL_Mail_Message.sharedInstance.selectedImage.count == 0)
                    {
                    BL_Mail_Message.sharedInstance.selectedImage = self.selectedImages
                    }
                    else
                    {
                        for i in 0..<self.selectedImages.count
                        {
                         BL_Mail_Message.sharedInstance.selectedImage.append(self.selectedImages[i])
                        }
                    }
                    let vcList = navigationController?.viewControllers
                    
                    for currentVC: UIViewController in vcList!
                    {
                        if (currentVC is MessageComposeViewController)
                        {
                        removeCustomLblFromNavBar()
                        self.navigationController?.popToViewController(currentVC, animated: true)
                        }
                    }
   
                }
                    else if(isFromEditDoctor)
                {
                    if(BL_DoctorList.sharedInstance.selectedImage.count == 0)
                    {
                        BL_DoctorList.sharedInstance.selectedImage = self.selectedImages
                        selectedImages.removeAll()
                    }
                    else
                    {
                        
                        BL_DoctorList.sharedInstance.selectedImage.append(self.selectedImages[0])
                        selectedImages.removeAll()
                    }
                    
                    let vcList = navigationController?.viewControllers
                    
                    for currentVC: UIViewController in vcList!
                    {
                        if (currentVC is DoctorDetailsEditViewController)
                        {
                            removeCustomLblFromNavBar()
                            self.navigationController?.popToViewController(currentVC, animated: true)
                        }
                    }
                    
                    
                }
                else if (isFromNotes)
                {
                    
                    // get file
                    let vcList = navigationController?.viewControllers
                    
                    for currentVC: UIViewController in vcList!
                    {
                        if (currentVC is NotesTaskViewController)
                        {
                            removeCustomLblFromNavBar()
                            self.navigationController?.popToViewController(currentVC, animated: true)
                        }
                    }
                }
                    
                else if(isfromLeave)
                {
                    addLeaveAttachmentController()
                    popPhotoAlbumControllers()
                }
                else if isFromTP
                {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AttachmentViewRefresh"), object: nil)
                        popPhotoAlbumControllers()
                }
                else
                {
                //addAttachmentController()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AttachmentViewRefresh"), object: nil)
                popPhotoAlbumControllers()
                }
            }
        }
    }
    
    func getNextImgTask()
    {
        if selectedAssetList.count > 0
        {
            selectedAssetList.removeFirst()
        }
        
        initiateImgTask()
    }
    
    //MARK:- Custom Nav bar methods
    func addCustomLblToNavigationBar(mainTitle: String)
    {
        let cancelButton = UIButton(type: UIButtonType.custom)
        cancelButton.addTarget(self, action: #selector(self.cancelButtonClicked), for: .touchUpInside)
        cancelButton.setTitle(nbCancelTitle, for: .normal)
        cancelButton.sizeToFit()
        let leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let doneButton = UIButton(type: UIButtonType.custom)
        doneButton.addTarget(self, action: #selector(doneBtnClicked), for: .touchUpInside)
        doneButton.setTitle(nbDoneTitle, for: .normal)
        doneButton.sizeToFit()
        let rightBarButtonItem = UIBarButtonItem(customView: doneButton)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        let lblLeading : CGFloat = 75.0
        let lblTrailing : CGFloat = 70.0
        let lblWidth : CGFloat = SCREEN_WIDTH - lblLeading - lblTrailing
        
        if let navigationBar = self.navigationController?.navigationBar
        {
            if(!isFromEditDoctor)
            {
                let firstFrame = CGRect(x: lblLeading, y: 0, width: lblWidth, height: 28)
                let firstLabel = UILabel(frame: firstFrame)
                firstLabel.textAlignment = .center
                firstLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
                firstLabel.tag = 200
                firstLabel.textColor = UIColor.white
                firstLabel.text = mainTitle
                
                let secondFrame = CGRect(x: lblLeading, y: firstLabel.frame.origin.y + firstLabel.frame.size.height, width: lblWidth, height: 16)
                let secondLabel = UILabel(frame: secondFrame)
                secondLabel.textAlignment = .center
                secondLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
                secondLabel.tag = 201
                secondLabel.textColor = UIColor.white
                secondLabel.text = "Tap here to change the album"
                
                let buttonFrame = CGRect(x: lblLeading , y: 0, width: lblWidth, height: navigationBar.frame.size.height)
                let button = UIButton(frame: buttonFrame)
                button.backgroundColor = UIColor.clear
                button.tag = 202
                button.addTarget(self, action: #selector(animatePopController), for: .touchUpInside)
                
                navigationBar.addSubview(firstLabel)
                navigationBar.addSubview(secondLabel)
                navigationBar.addSubview(button)
            }
        }
    }
    
    func removeCustomLblFromNavBar()
    {
        if let navigationBar = self.navigationController?.navigationBar
        {
            if let getFirstLabel = navigationBar.viewWithTag(200) as? UILabel
            {
                getFirstLabel.removeFromSuperview()
            }
            
            if let getSecondLabel = navigationBar.viewWithTag(201) as? UILabel
            {
                getSecondLabel.removeFromSuperview()
            }
            if let getButton = navigationBar.viewWithTag(202) as? UIButton
            {
                getButton.removeFromSuperview()
            }
        }
    }
    
    @objc func cancelButtonClicked()
    {
        popPhotoAlbumControllers()
    }
    
    //MARK:- Insert/Pop Controller methods
    func addAttachmentController()
    {
        if let vcList = self.navigationController?.viewControllers
        {
            if (vcList.index{$0 is AttachmentViewController}) == nil
            {
                if let navigationController = navigationController
                {
                    let stackCount = navigationController.viewControllers.count
                    let addIndex = stackCount - 2
                    let sb = UIStoryboard(name: Constants.StoaryBoardNames.AttachmentSb, bundle: nil)
                    let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.AttachmentVCID) as! AttachmentViewController
                    vc.isFromChemistDay = self.isFromChemistDay
                    vc.isFromNotes = self.isFromNotes
                    navigationController.viewControllers.insert(vc, at: addIndex)
                }
            }
        }
    }
    func addLeaveAttachmentController()
    {
        if let vcList = self.navigationController?.viewControllers
        {
            if (vcList.index{$0 is AttachmentViewController}) == nil
            {
                if let navigationController = navigationController
                {
                    let stackCount = navigationController.viewControllers.count
                    let addIndex = stackCount - 2
                    let sb = UIStoryboard(name: Constants.StoaryBoardNames.AttachmentSb, bundle: nil)
                    let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.AttachmentVCID) as! AttachmentViewController
                    vc.isfromLeave = self.isfromLeave
                    navigationController.viewControllers.insert(vc, at: addIndex)
                }
            }
        }
    }
    
    func popPhotoAlbumControllers()
    {
        if let vcList = self.navigationController?.viewControllers
        {
            if (vcList.index{$0 is AlbumListController}) != nil
            {
                let vcIndex = vcList.index{$0 is AlbumListController}
                var modifiedVcList = self.navigationController?.viewControllers
                modifiedVcList?.remove(at: vcIndex!)
                self.navigationController?.setViewControllers(modifiedVcList!, animated: false)
                animatePopController()
            }
            else
            {
                animatePopController()
            }
        }
    }
    
    @objc func animatePopController()
    {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromBottom
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        _ = navigationController?.popViewController(animated: false)
    }
}
