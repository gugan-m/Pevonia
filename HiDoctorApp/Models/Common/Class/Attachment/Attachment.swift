//
//  Attachment.swift
//  HiDoctorApp
//
//  Created by Vijay on 20/04/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import Photos
import AssetsLibrary
import MobileCoreServices

@objc protocol DocumentDelegate {
    @objc optional func getDocumentResponse()
}

class Attachment: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate
{
    static let sharedInstance = Attachment()
    var delegate : DocumentDelegate?
    var selectedImages = [String]()
    
    var getVC : UIViewController!
    var isFromMessage = false
    var isFromEditDoctor = false
    var isFromChemistDay = false
    var isfromLeave = false
    var isFromtask = false
    let iCloudObserver = "iCloudObserver"
    let iCloudObserver1 = "iCloudObserverForDoctor"
    var cancel : UIBarButtonItem!
    
    var leaveTypeName : String = ""
    var startDate : Date = Date()
    var endDate : Date = Date()
    var leaveTypeCode : String = ""
    
    //MARK:- Action sheet - Camera, Photo library & Document
    func showAttachmentActionSheet(viewController: UIViewController)
    {
        getVC = viewController
        
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler:{
            (alert: UIAlertAction) -> Void in
            self.uploadImgFromCamera()
        })
        actionSheetController.addAction(cameraAction)
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            self.checkPhotoAccessEnabledStatus()
            //self.showAlert()
        })
        actionSheetController.addAction(photoLibrary)
        
        if(!isfromLeave && !isFromtask)
        {
            let documentLibrary = UIAlertAction(title: "Document", style: .default, handler: {
                (alert: UIAlertAction) -> Void in
                self.showiCloudActionSheet()
            })
            actionSheetController.addAction(documentLibrary)
        }
//        let documentLibrary = UIAlertAction(title: "Document", style: .default, handler: {
//            (alert: UIAlertAction) -> Void in
//            self.showiCloudActionSheet()
//        })
//        actionSheetController.addAction(documentLibrary)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:{
            (alert: UIAlertAction) -> Void in
            
        })
        actionSheetController.addAction(cancelAction)
        
        if SwifterSwift().isPhone
        {
            viewController.present(actionSheetController, animated: true, completion: nil)
        }
        else
        {
            if let currentPopoverpresentioncontroller = actionSheetController.popoverPresentationController{
                currentPopoverpresentioncontroller.sourceView = viewController.view
                currentPopoverpresentioncontroller.sourceRect = CGRect(x:viewController.view.frame.size.width-50,y:0, width:100,height:100)
                currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.up
                viewController.present(actionSheetController, animated: true, completion: nil)
            }
        }
    }
    
    //MARK:- Seperate iClouddrive action sheet
    private func showiCloudActionSheet()
    {
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let iCloudDrive = UIAlertAction(title: "iCloud Library", style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            self.uploadFilesFromiCloud()
        })
        actionSheetController.addAction(iCloudDrive)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:{
            (alert: UIAlertAction) -> Void in
            
        })
        actionSheetController.addAction(cancelAction)
        
        if SwifterSwift().isPhone
        {
            getVC.present(actionSheetController, animated: true, completion: nil)
        }
        else
        {
            if let currentPopoverpresentioncontroller = actionSheetController.popoverPresentationController{
                currentPopoverpresentioncontroller.sourceView = getVC.view
                currentPopoverpresentioncontroller.sourceRect = CGRect(x:getVC.view.frame.size.width-50,y:0, width:100,height:100)
                currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.up
                getVC.present(actionSheetController, animated: true, completion: nil)
            }
        }
    }
    
    //MARK:- Push the Attachment VC in the stack
    func navigateToAttachmentList()
    {
        if let vcList = getVC.navigationController?.viewControllers
        {
            if (vcList.index{$0 is AttachmentViewController}) == nil
            {
                let sb = UIStoryboard(name: Constants.StoaryBoardNames.AttachmentSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.AttachmentVCID) as! AttachmentViewController
                vc.isFromChemistDay = isFromChemistDay
                vc.isFromNotes = isFromtask
                getVC.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
    
    func navigateToLeaveAttachmentList()
    {
        if let vcList = getVC.navigationController?.viewControllers
        {
            if (vcList.index{$0 is AttachmentViewController}) == nil
            {
                let sb = UIStoryboard(name: Constants.StoaryBoardNames.AttachmentSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.AttachmentVCID) as! AttachmentViewController
                vc.isfromLeave = isfromLeave
                getVC.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
    
    
    //MARK:- Get Image using Camera
    private func uploadImgFromCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        {
            let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerControllerSourceType.camera
            image.allowsEditing = false
            
            getVC.present(image, animated: true, completion: nil)
        }
    }
    
    //MARK:- Image picker delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        getVC.dismiss(animated: true, completion: nil)
        var fileCount = Int()
        if(self.isFromMessage)
        {
            if(BL_Mail_Message.sharedInstance.forwardImage == 0)
            {
                fileCount = BL_Mail_Message.sharedInstance.selectedImage.count
            }
            else
            {
                fileCount = BL_Mail_Message.sharedInstance.forwardImage + BL_Mail_Message.sharedInstance.selectedImage.count
            }
        }
        else if(self.isFromEditDoctor)
        {
            fileCount = BL_DoctorList.sharedInstance.selectedImage.count
        }
        else if(self.isFromChemistDay)
        {
            fileCount = Bl_Attachment.sharedInstance.getChemistAttachmentCount()
        }
        else if(self.isfromLeave)
        {
            fileCount = Bl_Attachment.sharedInstance.getLeaveAttachmentCount()
        }
        else if (self.isFromtask)
        {
            fileCount = 0
        }
        else
        {
            fileCount = Bl_Attachment.sharedInstance.getAttachmentCount()
        }
        if fileCount < maxFileUploadCount
        {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
            {
                if let resizedImg = Bl_Attachment.sharedInstance.imageResize(imageObj: image)
                {
                    if let imgData = UIImagePNGRepresentation(resizedImg)
                    {
                        //Transform into Megabytes
                        var imageSize = Float(imgData.count)
                        imageSize = imageSize/(1024*1024)
                        
                        if imageSize > maxFileSize
                        {
                            AlertView.showAlertView(title: alertTitle, message: "File size should not exceed \(maxFileSize) MB")
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
//                                let _ =  BL_DoctorList.sharedInstance.writeFile(fileData: imgData, msgCode: Constants.DoctorProfile.newImage, blobUrl: fileName)
                                
                                BL_DoctorList.sharedInstance.selectedImageData = NSData()
                                BL_DoctorList.sharedInstance.selectedImageData = imgData as NSData
                                self.selectedImages.append(fileName)
                            }
                            else
                            {
                                // Save the attachment in the document directory
                                Bl_Attachment.sharedInstance.saveAttachmentFile(fileData: imgData, fileName: fileName)
                                // Save the attachment in the DB
                                if(isFromChemistDay)
                                {
                                    Bl_Attachment.sharedInstance.insertChemistAttachment(attachmentName: fileName, attachmentSize: fileSize)
                                }
                                else if(isfromLeave)
                                {
                                    //Bl_Attachment.sharedInstance.insertLeaveAttachment(attachmentName: fileName, attachmentSize: fileSize)
                                    Bl_Attachment.sharedInstance.insertLeaveAttachment(attachmentName: fileName, attachmentSize: fileSize, fromDate: self.startDate, toDate: self.endDate, leaveTypeCode: self.leaveTypeCode, leaveTypeName: self.leaveTypeName)
                                    
                                }
                                else if(isFromtask)
                                {
                                    let dict: NSDictionary = [:]
                                    var notes : [NotesAttachment] = []
                                    //notes.append()
                                    let note : NotesAttachment? = NotesAttachment(dict:dict)
                                    note?.AttachmentName = fileName
                                    notes.append(note!)
                                    DBHelper.sharedInstance.insertNotesAttachmentDetail(dcrAttachmentModel: note!)
                                }
                                else
                                {
                                    Bl_Attachment.sharedInstance.insertAttachment(attachmentName: fileName, attachmentSize: fileSize)
                                }
                            }
                        }
                    }
                }
            }
        }
        else
        {
            AlertView.showAlertView(title: alertTitle, message: "You can not upload more than \(maxFileUploadCount) files")
        }
        
        if(isFromMessage)
        {
            self.messageAttactmentNotification()
        }
        else if(isFromEditDoctor)
        {
            self.messageAttactmentNotification()
        }
        else if(isfromLeave)
        {
            navigateToLeaveAttachmentList()
        }
           
        else if(isFromtask)
        {
            picker.dismiss(animated: false)
            //etVC.navigationController?.popViewController( animated: false)
        }
        else
        {
            navigateToAttachmentList()
        }
    }
    
    //MARK:- Determine the Photo access
    private func checkPhotoAccessEnabledStatus()
    {
        let status = PHPhotoLibrary.authorizationStatus()
        
        if (status == PHAuthorizationStatus.authorized)
        {
            // Access has been granted.
            self.presentAlbumVC()
        }
        else if (status == PHAuthorizationStatus.denied)
        {
            // Access has been denied.
            AlertView.showAlertToEnablePhotoAccess()
        }
        else if (status == PHAuthorizationStatus.notDetermined)
        {
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if (newStatus == PHAuthorizationStatus.authorized)
                {
                    self.getVC.view.isUserInteractionEnabled = false
                    delayWithSeconds(0.5)
                    {
                        self.presentAlbumVC()
                        self.getVC.view.isUserInteractionEnabled = true
                    }
                } else
                {
                    AlertView.showAlertToEnablePhotoAccess()
                }
            })
        }
        else if (status == PHAuthorizationStatus.restricted)
        {
            // Restricted access - normally won't happen.
            AlertView.showAlertToEnablePhotoAccess()
        }
        else
        {
            AlertView.showAlertToEnablePhotoAccess()
        }
    }
    
    //MARK:- Get Image using Custom Image Library
    private func presentAlbumVC()
    {
        let sb = UIStoryboard(name: Constants.StoaryBoardNames.CustomImgLib, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.CustomImgLibPhotoVCID) as! PhotosViewController
        vc.selectedDirectory = nil
        vc.isFromMessage = self.isFromMessage
        vc.isFromChemistDay = self.isFromChemistDay
        vc.isfromLeave = self.isfromLeave
        vc.isFromNotes = self.isFromtask
        vc.isFromEditDoctor = self.isFromEditDoctor
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromTop
        getVC.navigationController?.view.layer.add(transition, forKey: kCATransition)
        getVC.navigationController?.pushViewController(vc, animated: false)
        
        if let navigationController = getVC.navigationController
        {
            let stackCount = navigationController.viewControllers.count
            let addIndex = stackCount - 1
            let sb = UIStoryboard(name: Constants.StoaryBoardNames.CustomImgLib, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.CustomImgLibAlbumVCID) as! AlbumListController
            vc.isFromMessage = self.isFromMessage
            vc.isFromEditDoctor = self.isFromEditDoctor
            vc.isFromChemistDay = self.isFromChemistDay
            vc.isfromLeave = self.isfromLeave
            vc.isFromNotes = self.isFromtask
            navigationController.viewControllers.insert(vc, at: addIndex)
        }
    }
    
    //MARK:- Get Image using iCloud Drive
    private func uploadFilesFromiCloud()
    {
        let value1 = [String(kUTTypePDF),String(kUTTypeImage),String(kUTTypeSpreadsheet), String(kUTTypeBMP)]
        let value2 = [String(kUTTypeTIFF), String(kUTTypeZipArchive),String(kUTTypeText),docxTypeId,docTypeId]
        var valueType: [String] = []
        valueType.append(contentsOf: value1)
        valueType.append(contentsOf: value2)
        
        let documentPickerController = UIDocumentPickerViewController(documentTypes:valueType, in: .import)
        documentPickerController.delegate = self
        documentPickerController.navigationController?.navigationBar.topItem?.title = " "
        
        getVC.present(documentPickerController, animated: true, completion: nil)
            }
    
    

    //MARK:- Document picker delegates
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL)
    {
        var fileCount = Int()
        if(self.isFromMessage)
        {
            if(BL_Mail_Message.sharedInstance.forwardImage == 0)
            {
                fileCount = BL_Mail_Message.sharedInstance.selectedImage.count
            }
                
            else
            {
                fileCount = BL_Mail_Message.sharedInstance.forwardImage + BL_Mail_Message.sharedInstance.selectedImage.count
            }
        }
        else if(self.isFromEditDoctor)
        {
            fileCount = BL_DoctorList.sharedInstance.selectedImage.count
        }
        else if(isFromChemistDay)
        {
            fileCount = Bl_Attachment.sharedInstance.getChemistAttachmentCount()
        }
        
        else if(isfromLeave)
        {
            fileCount = Bl_Attachment.sharedInstance.getLeaveAttachmentCount()
        }
        else if (isFromtask)
        {
            fileCount = 0
        }
        else
        {
           fileCount = Bl_Attachment.sharedInstance.getAttachmentCount()
        }
        if fileCount < maxFileUploadCount
        {
            if let getData = NSData(contentsOf: url)
            {
                var fileSize = Float(getData.length)
                fileSize = fileSize/(1024*1024)
                
                if fileSize > maxFileSize
                {
                    AlertView.showAlertView(title: "Alert", message: "File size should not exceed \(maxFileSize) MB")
                }
                else
                {
                    let urlPath = url.path
                    let fileSplittedString = urlPath.components(separatedBy: "/")
                    if fileSplittedString.count > 0
                    {
                        let fileName = fileSplittedString.last!
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "ddMMyyyyhhmmssSSS"
                        let timestamp:String = formatter.string(from: getCurrentDateAndTime())
                        let modifiedFileName = "\(timestamp)-\(fileName)"
                        let fileSize = Bl_Attachment.sharedInstance.convertToBytes(number: fileSize)
                        
                        if(self.isFromMessage)
                        {
                            self.selectedImages.append(modifiedFileName)
                        }
                        else if(self.isFromEditDoctor)
                        {
                            self.selectedImages = []
                            self.selectedImages.append(modifiedFileName)
                        }
                        else
                        {
                            // Save the attachment in the document directory
                            Bl_Attachment.sharedInstance.saveAttachmentFile(fileData: getData as Data, fileName: modifiedFileName)
                            
                            // Save the attachment in the DB
                            if(isFromChemistDay)
                            {
                                Bl_Attachment.sharedInstance.insertChemistAttachment(attachmentName: modifiedFileName, attachmentSize: fileSize)
                            }
                                
                            else if(isfromLeave)
                            {
                                //Bl_Attachment.sharedInstance.insertLeaveAttachment(attachmentName: modifiedFileName, attachmentSize: fileSize)
                                Bl_Attachment.sharedInstance.insertLeaveAttachment(attachmentName: fileName, attachmentSize: fileSize, fromDate: self.startDate, toDate: self.endDate, leaveTypeCode: self.leaveTypeCode, leaveTypeName: self.leaveTypeName)
                            }
                            else if (isFromtask)
                            {
                                let dict: NSDictionary = [:]
                                var notes : [NotesAttachment] = []
                                //notes.append()
                                let note : NotesAttachment? = NotesAttachment(dict:dict)
                                note?.AttachmentName = fileName
                                notes.append(note!)
                                DBHelper.sharedInstance.insertNotesAttachmentDetail(dcrAttachmentModel: note!)
                            }
                            else
                            {
                                Bl_Attachment.sharedInstance.insertAttachment(attachmentName: modifiedFileName, attachmentSize: fileSize)
                            }
                        }
                    }
                }
                
            }
        }
        else
        {
            AlertView.showAlertView(title: alertTitle, message: "You can not upload more than \(maxFileUploadCount) files")
        }
        if(!isFromMessage)
        {
            //        if delegate != nil
            //        {
            //            delegate?.getDocumentResponse!()
            //        }
        }
        if(isFromMessage)
        {
            self.messageAttactmentNotification()
        }
        else if(isFromEditDoctor)
        {
            self.doctorProfileNotification()
        }
         
        else if(isfromLeave)
        {
            navigateToLeaveAttachmentList()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AttachmentViewRefresh"), object: nil)
        }
        else if(isFromtask)
        {
            controller.dismiss(animated: true)
        }
            
        else
        {
            navigateToAttachmentList()
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AttachmentViewRefresh"), object: nil)
        }
    }
    func messageAttactmentNotification()
    {
        if(BL_Mail_Message.sharedInstance.selectedImage.count == 0)
        {
            BL_Mail_Message.sharedInstance.selectedImage = self.selectedImages
            selectedImages.removeAll()
        }
        else
        {
            for i in 0..<self.selectedImages.count
            {
                BL_Mail_Message.sharedInstance.selectedImage.append(self.selectedImages[i])
            }
            selectedImages.removeAll()
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: iCloudObserver), object: nil)
    }
    func doctorProfileNotification()
    {
        if(BL_DoctorList.sharedInstance.selectedImage.count == 0)
        {
            BL_DoctorList.sharedInstance.selectedImage = self.selectedImages
            selectedImages.removeAll()
        }
        else
        {
            for i in 0..<self.selectedImages.count
            {
                BL_DoctorList.sharedInstance.selectedImage.append(self.selectedImages[i])
            }
            selectedImages.removeAll()
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: iCloudObserver1), object: nil)

        
    }
    
}
