//
//  MessageDetailViewController.swift
//  HiDoctorApp
//
//  Created by Vijay on 12/09/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class MessageDetailViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    //MARK:- IBOutlet
    @IBOutlet weak var attachmentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var toLblHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var toLbl: UILabel!
    @IBOutlet weak var hideDetailsLbl: UIButton!
    @IBOutlet weak var subjectLbl: UILabel!
    @IBOutlet weak var msgBodyTextView: UITextView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var attachmentCollectionView: UICollectionView!
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    //MARK:- Variable
    var messageData : MailMessageWrapperModel!
    var attachmentList : [MailMessageAttachment] = []
    var toText = ""
    var content  = ""
    var height:CGFloat = 0
    var toLblHeight:CGFloat = 18
    var textViewHeight:CGFloat = 0
    var attachmentHeight:CGFloat = 0
    var messageType = Int()
    
    //MARK:- ViewController Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = messageData.objMailMessageContent.Subject
        hideDetailsLbl.setTitle("Show", for: .normal)
        self.updateViews()
        self.updateMailAsRead()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 100, height: attachmentHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return attachmentList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = attachmentCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionViewIdentifier.MessageAttachmentCollectionCell, for: indexPath) as! MessageAttachmentCollectionViewCell
        
        cell.activityIndicator.isHidden = true
        
        if(attachmentList[indexPath.item].AttachmentType == Constants.AttachmentType.image)
        {
            cell.imageView.image = UIImage(named: "icon-image")
            cell.fileNameLbl.text = attachmentList[indexPath.item].FileName
            self.downloadImage(objAttachment: attachmentList[indexPath.item], imageView: cell.imageView, fileNameLbl: cell.fileNameLbl)
        }
        else if(attachmentList[indexPath.item].AttachmentType == Constants.AttachmentType.excel)
        {
            cell.imageView.image = UIImage(named: "icon-excel")
            cell.fileNameLbl.text = attachmentList[indexPath.item].FileName
        }
        else if(attachmentList[indexPath.item].AttachmentType == Constants.AttachmentType.word)
        {
            cell.imageView.image = UIImage(named: "icon-word")
            cell.fileNameLbl.text = attachmentList[indexPath.item].FileName
        }
        else if(attachmentList[indexPath.item].AttachmentType == Constants.AttachmentType.pdf)
        {
            cell.imageView.image = UIImage(named: "icon-pdf")
            cell.fileNameLbl.text = attachmentList[indexPath.item].FileName
        }
        else if(attachmentList[indexPath.item].AttachmentType == Constants.AttachmentType.zip)
        {
            cell.imageView.image = UIImage(named: "icon-zip")
            cell.fileNameLbl.text = attachmentList[indexPath.item].FileName
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let localPath =  attachmentList[indexPath.item].Blob_Url
        navigateTowebView(siteUrl: localPath!,title:attachmentList[indexPath.item].FileName)
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
    
    //MARK:- Functions to update views
    func updateViews()
    {
        if(self.messageType == Constants.MessageType.sent)
        {
            let userDetails = getUserModelObj()
            fromLbl.text = userDetails?.Employee_name
        }
        else
        {
            fromLbl.text = messageData.objMailMessageHeader.Sender_Employee_Name
        }
        dateLbl.text  = convertDateIntoString(date: messageData.objMailMessageHeader.Date_From) as String
        var toUser = [String]()
        var ccUser = [String]()
        
        for i in 0..<self.messageData.lstMailMessageAgents.count
        {
            if(self.messageData.lstMailMessageAgents[i].Address_Type == "TO")
            {
                toUser.append(self.messageData.lstMailMessageAgents[i].Target_Employee_Name)
            }
            else
            {
                ccUser.append(self.messageData.lstMailMessageAgents[i].Target_Employee_Name)
            }
        }
        
        let attributedBoldString = NSMutableAttributedString()
        let attrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15)]
        let toBoldStr = NSMutableAttributedString(string:"To: ", attributes:attrs)
        let ccBoldStr = NSMutableAttributedString(string:"Cc: ", attributes:attrs)
        
        let toUserString = toUser.joined(separator: ", ")
        let ccUserString = ccUser.joined(separator: ", ")
        
        let toNormalStr = NSMutableAttributedString(string:toUserString , attributes:nil)
        let newLine = NSMutableAttributedString(string:"\n" , attributes:nil)
        let ccNormalStr = NSMutableAttributedString(string:ccUserString, attributes:nil)
        
        toText = "To:  " + toUserString + "\n" + "Cc:  " + ccUserString
        attributedBoldString.append(toBoldStr)
        attributedBoldString.append(toNormalStr)
        if(ccUser.count > 0)
        {
            attributedBoldString.append(newLine)
            attributedBoldString.append(ccBoldStr)
            attributedBoldString.append(ccNormalStr)
        }
        toLbl.attributedText = attributedBoldString
        
        if self.messageData.lstMailMessageAgents.count <= 2
        {
            hideDetailsLbl.isHidden = true
        }
        else
        {
            hideDetailsLbl.isHidden = false
        }
        
        if self.messageData.objMailMessageContent.Content != nil && self.messageData.objMailMessageContent.Content != EMPTY
        {
            content = messageData.objMailMessageContent.Content
            
            msgBodyTextView.textColor = UIColor.lightGray
            let attrStr = try! NSAttributedString(
                data: content.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil)
            let textView = UITextView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-32, height: self.view.frame.height))
            textView.font = UIFont(name:fontRegular, size: 13)
            textView.isScrollEnabled = true
            textView.isEditable = true
            textView.attributedText = attrStr
            textViewHeight = textView.contentSize.height + 150
            msgBodyTextView.allowsEditingTextAttributes = true
            msgBodyTextView.attributedText = attrStr
            msgBodyTextView.font = UIFont(name:fontRegular, size: 13)
            
            textViewHeightConstraint.constant = getAttributedTextSize(text: attrStr, fontName:  fontRegular, fontSize:  13, constrainedWidth:  SCREEN_WIDTH-32).height + 20
            textViewHeight = textViewHeightConstraint.constant
            //getTextSize(text: String(describing: attrStr), fontName: fontRegular, fontSize: 16, constrainedWidth: SCREEN_WIDTH - 32).height
            //textViewHeight + 30
            msgBodyTextView.isScrollEnabled = false
            msgBodyTextView.isEditable = false
        }
        else
        {
            content = EMPTY
            textViewHeightConstraint.constant = textViewHeight
        }
        
        if self.messageData.objMailMessageContent.Subject != nil
        {
            subjectLbl.text = self.messageData.objMailMessageContent.Subject
        }
        else
        {
            subjectLbl.text = "[No Subject]"
        }
        
        if(messageData.lstMailMessageAttachments.count > 0)
        {
            attachmentList = messageData.lstMailMessageAttachments
            attachmentHeight = 80
            attachmentHeightConstraint?.constant = 80
            bottomViewHeight.constant = 130
            attachmentCollectionView.reloadData()
        }
        else
        {
            attachmentList = []
            attachmentHeight = 0
            attachmentHeightConstraint?.constant = 0
            bottomViewHeight.constant = 50
        }
        
        height = 64 + 54 + 20 + 50 + textViewHeightConstraint.constant
        mainViewHeight?.constant = height
    }
    
    //MARK:- Navigation to webview
    func navigateTowebView(siteUrl:String, title:String)
    {
        let sb = UIStoryboard(name: mainSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: webViewVCID) as! WebViewController
        vc.siteURL = siteUrl
        vc.title = title
        getAppDelegate().root_navigation.pushViewController(vc, animated: true)
    }
    
    //MARK:- Function for show and hide recepients
    @IBAction func showAndHideAction(_ sender: Any)
    {
        self.updateToLblText()
    }
    
    //MARK:- Functions for reply and forward action
    @IBAction func replyOrForwardAction(_ sender: Any)
    {
        let messageMoreMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let replyAction = UIAlertAction(title: "Reply", style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            let sb = UIStoryboard(name:Constants.StoaryBoardNames.MessageSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.MessageComposeVCID) as! MessageComposeViewController
            vc.messageDataFromDetail = self.messageData
            vc.composeType = Constants.ComposeType.reply
            vc.replyUserList = BL_Mail_Message.sharedInstance.convertToUserMasterWrapperModelarray(messageHeader: self.messageData.objMailMessageHeader)
            vc.isReplyAll = false
            self.navigationController?.pushViewController(vc, animated: true)
            
        })
        messageMoreMenu.addAction(replyAction)
        
        let replyAllAction = UIAlertAction(title: "Reply All", style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            let sb = UIStoryboard(name:Constants.StoaryBoardNames.MessageSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.MessageComposeVCID) as! MessageComposeViewController
            vc.messageDataFromDetail = self.messageData
            vc.composeType = Constants.ComposeType.reply
            vc.replyUserList = BL_Mail_Message.sharedInstance.convertToUserMasterWrapperModelarray(messageHeader: self.messageData.objMailMessageHeader)
            vc.isReplyAll = true
             self.navigationController?.pushViewController(vc, animated: true)
            
        })
        messageMoreMenu.addAction(replyAllAction)
        
        let forwardAction = UIAlertAction(title: "Forward", style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            let sb = UIStoryboard(name:Constants.StoaryBoardNames.MessageSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.MessageComposeVCID) as! MessageComposeViewController
            vc.messageDataFromDetail = self.messageData
            vc.composeType = Constants.ComposeType.forward
            self.navigationController?.pushViewController(vc, animated: true)
        })
        messageMoreMenu.addAction(forwardAction)
        
        let cancelAction = UIAlertAction(title: CANCEL, style: .cancel, handler:{
            (alert: UIAlertAction) -> Void in
            
            _=self.dismiss(animated: false, completion: nil)
            
        })
        messageMoreMenu.addAction(cancelAction)
        
        if SwifterSwift().isPhone
        {
            self.present(messageMoreMenu, animated: true, completion: nil)
        }
        else
        {
            if let currentPopoverpresentioncontroller = messageMoreMenu.popoverPresentationController{
                currentPopoverpresentioncontroller.sourceView = self.view
                currentPopoverpresentioncontroller.sourceRect = CGRect(x:self.view.frame.size.width-50,y:0, width:100,height:100)
                currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.up
                self.present(messageMoreMenu, animated: true, completion: nil)
            }
        }
        
    }
    
    //MARK:- Delete message
    @IBAction func deleteAction(_ sender: Any)
    {
        let initialAlert = "Are you sure to Delete"
        
        let alertViewController = UIAlertController(title: alertTitle, message: initialAlert, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { alertAction in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
            self.deleteMessage()
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    func deleteMessage()
    {
        var messageDeleteData :[MailMessageWrapperModel] = []
        messageDeleteData.append(messageData)
        if checkInternetConnectivity()
        {
            BL_Mail_Message.sharedInstance.deleteMessage(msgList: messageDeleteData, messageType: messageType) { (objApiResponse) in
                if(objApiResponse.Status == SERVER_SUCCESS_CODE)
                {
                    let _ = self.navigationController?.popViewController(animated: true)
                }
                else
                {
                    showToastView(toastText: objApiResponse.Message)
                }
            }
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
        
    }
        
    func updateToLblText()
    {
        if hideDetailsLbl.title(for: .normal) == "Show"
        {
            toLblHeight = getTextSize(text: toText, fontName: fontRegular, fontSize: 14, constrainedWidth: (SCREEN_WIDTH - (49 + 8))).height
            toLblHeightConstraint.constant = toLblHeight+17
            mainViewHeight?.constant = height - 18 + toLblHeight
            hideDetailsLbl.setTitle("Hide", for: .normal)
            
        }
        else if hideDetailsLbl.title(for: .normal) == "Hide"
        {
            toLblHeightConstraint.constant = 18
            mainViewHeight?.constant = height
            hideDetailsLbl.setTitle("Show", for: .normal)
        }
        
    }
    
    @IBAction func hideAction(_ sender: Any)
    {
        self.updateToLblText()
    }
    
    private func updateMailAsRead()
    {
        if (checkInternetConnectivity())
        {
            let filtered = messageData.lstMailMessageAgents.filter{
                $0.Target_UserCode == getUserCode() && $0.Is_Read == 0
            }
            
            if (filtered.count > 0)
            {
                BL_Mail_Message.sharedInstance.updateMessageAsRead(messageCode: messageData.objMailMessageHeader.Msg_Code!, completion: { (apiResponseObj) in
                    print(apiResponseObj.Status)
                })
            }
        }
    }
    
}

