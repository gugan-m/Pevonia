//
//  MessageComposeViewController.swift
//  HiDoctorApp
//
//  Created by Vijay on 01/09/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class MessageComposeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,DocumentDelegate,SelectedMessageUserListDelegate,UITextFieldDelegate
{
    
    var messageDataFromDetail : MailMessageWrapperModel!
    var replyUserList :[UserMasterWrapperModel] = []
    var replyCcUserList :[UserMasterWrapperModel] = []
    //reply or forward
    var composeType = String()
    var rowCount = Int()
    var cellHeight1 : CGFloat = 60
    var cellHeight2 : CGFloat = 60
    var cellHeight : CGFloat = 0
    var attachmentHeight : CGFloat = 0
    var composeTextView = UITextView()
    var forwardTextView = UITextView()
    var toLabel = UILabel()
    var sendBut : UIBarButtonItem!
    var attachBut : UIBarButtonItem!
    var isSelected : Bool = false
    var toText = String()
    var ccText = String()
    var toTempText = String()
    var ccTempText = String()
    var subjectTextField = UITextField()
    var attachmentFiles = [String]()
    @IBOutlet var tableView: UITableView!
    let iCloudObserver = "iCloudObserver"
    var isPaste : Bool = false
    var replyData = NSAttributedString()
    var toREplyUserName = String()
    var ccREplyUserName = String()
    var toSelectedList : [UserMasterWrapperModel] = []
    var ccSelectedList : [UserMasterWrapperModel] = []
    var index = Int()//attachement Index
    var attachementBlodUrl :[String] = []
    var forwardAttachementBlodUrl :[String] = []
    var draftImage : Int = 0
    var isReplyAll = Bool()
    var constantCellHeight : CGFloat = 125
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.keyboardDismissMode = .interactive
        BL_Mail_Message.sharedInstance.composeText = NSMutableAttributedString(string: "")
        self.index = 0
        BL_Mail_Message.sharedInstance.selectedImage = []
        BL_Mail_Message.sharedInstance.forwardImage = 0
        BL_Mail_Message.sharedInstance.subjectText = ""
        self.hideKeyboardWhenTappedAround()
        self.iCloudAttachObserver()
        self.addSendBtn()
        self.setDefaults()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.attachmentFiles = BL_Mail_Message.sharedInstance.selectedImage
        self.attachmentHeight = 100
        self.tableView.reloadData()
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func setDefaults()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(MessageComposeViewController.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MessageComposeViewController.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        switch composeType
        {
        case Constants.ComposeType.compose:
            rowCount = 2
            self.tableView.reloadData()
            
        case Constants.ComposeType.forward:
            rowCount = 3
            BL_Mail_Message.sharedInstance.subjectText = "Fw: " + messageDataFromDetail.objMailMessageContent.Subject
            if(self.messageDataFromDetail.lstMailMessageAttachments.count > 0)
            {
                for forwardAttachment in self.messageDataFromDetail.lstMailMessageAttachments
                {
                    let blobUrl = forwardAttachment.Blob_Url
                    let urlName = blobUrl?.components(separatedBy: "/")
                    self.forwardAttachementBlodUrl.append((urlName?.last)!)
                }
            }
            getTouserformReply()
            getreplyTetViewSize()
            
        case Constants.ComposeType.draft:
            rowCount = 2
            replyUserList = BL_Mail_Message.sharedInstance.convertToUserMasterWrapperModelarray(messageHeader: messageDataFromDetail.objMailMessageHeader)
            self.toSelectedList = replyUserList
            BL_Mail_Message.sharedInstance.subjectText = messageDataFromDetail.objMailMessageContent.Subject
            if(self.messageDataFromDetail.lstMailMessageAttachments.count > 0)
            {
                self.downloadImageforDraft()
                
            }
            //            toTempText = replyUserList[0].userObj.Employee_name
            //            toText = replyUserList[0].userObj.Employee_name
            getTouserformArray(accompanistObj: replyUserList)
            getTouserformReply()
            getreplyTetViewSize()
            
            
        case Constants.ComposeType.reply:
            rowCount = 3
            if(isReplyAll)
            {
                var messagetoUserList = messageDataFromDetail.lstMailMessageAgents.filter{
                    $0.Target_UserCode != getUserCode() && $0.Address_Type == "TO"
                }
                
                var messageCcUserList = messageDataFromDetail.lstMailMessageAgents.filter{
                    $0.Target_UserCode != getUserCode() && $0.Address_Type == "CC"
                }
                messagetoUserList = messagetoUserList.unique{$0.Target_UserCode}
                messageCcUserList = messageCcUserList.unique{$0.Target_UserCode}
                
                self.toSelectedList = BL_Mail_Message.sharedInstance.convertToUserMasterWrapperModelagent(agentList: (messagetoUserList))
                self.ccSelectedList = BL_Mail_Message.sharedInstance.convertToUserMasterWrapperModelagent(agentList: (messageCcUserList))
                if(replyUserList[0].userObj.User_Code != getUserCode())
                {
                self.toSelectedList.append(replyUserList[0])
                }
                self.ccSelectedList = self.ccSelectedList.unique{$0.userObj.User_Code}
                self.toSelectedList = self.toSelectedList.unique{$0.userObj.User_Code}
                // self.toSelectedList = self.toSelectedList.unique{$0.userObj.Employee_name}
                
                
                //BL_Mail_Message.sharedInstance.convertToUserMasterWrapperModelagent(agentList: messageDataFromDetail.lstMailMessageAgents)
            }
            else
            {
                self.toSelectedList = replyUserList
            }
            BL_Mail_Message.sharedInstance.subjectText = "Re: " + messageDataFromDetail.objMailMessageContent.Subject
            if(!isReplyAll)
            {
                toTempText = replyUserList[0].userObj.Employee_name
                toText = replyUserList[0].userObj.Employee_name
            }
            else
            {
                getTouserformArray(accompanistObj: self.toSelectedList)
                getCcuserformArray(accompanistObj: self.ccSelectedList)
            }
            getTouserformReply()
            getreplyTetViewSize()
            
        default:
            rowCount = 0
        }
    }
    func downloadImageforDraft()
    {
        if(draftImage < self.messageDataFromDetail.lstMailMessageAttachments.count)
        {
            let draftImageUrl = self.messageDataFromDetail.lstMailMessageAttachments[draftImage].Blob_Url
            BL_Mail_Message.sharedInstance.downloadAttachment(blobUrl: draftImageUrl!, msgCode: Constants.MessageConstants.newAttachment, msgIndex: 0, attachmentIndex: 0, completion: { (msgIndex,attachmentIndex, localpath) in
                if(localpath != EMPTY)
                {
                    let blobUrl = draftImageUrl
                    let urlName = blobUrl?.components(separatedBy: "/")
                    BL_Mail_Message.sharedInstance.selectedImage.append((urlName?.last)!)
                    self.draftImage += 1
                    self.tableView.reloadData()
                    self.downloadImageforDraft()
                    
                }
            })
        }
        else
        {
            self.attachmentFiles = BL_Mail_Message.sharedInstance.selectedImage
            self.tableView.reloadData()
        }
        
    }
    
    func getreplyTetViewSize()//reply and forward
    {
        self.messageDataFromDetail.objMailMessageContent.Content = self.messageDataFromDetail.objMailMessageContent.Content.replacingOccurrences(of: "19", with: "13")
        replyData = try! NSAttributedString(
            data: self.messageDataFromDetail.objMailMessageContent.Content.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil)
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        textView.font = UIFont(name:fontRegular, size: 13)
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.attributedText = replyData
        if(composeType == Constants.ComposeType.draft)
        {
            self.cellHeight1 = getAttributedTextSize(text: replyData, fontName:  fontRegular, fontSize:  13, constrainedWidth:  SCREEN_WIDTH-8).height
        }
        else
        {
            self.cellHeight2 = getAttributedTextSize(text: replyData, fontName:  fontRegular, fontSize:  13, constrainedWidth:  SCREEN_WIDTH-8).height
        }
        self.tableView.reloadData()
        
    }
    //MARK:- TableView delegates
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MessageComposeCell
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1") as! MessageSubjectCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2") as! MessageReplyCell
        
        if(indexPath.row == 0)
        {
            cell1.toLabel.text = toTempText
            cell1.ccLabel.text = ccTempText
            self.toLabel = cell1.toLabel
            cell1.subjectTextField.delegate = self
            cell1.subjectTextField.resignFirstResponder()
            cell1.subjectTextField.text = BL_Mail_Message.sharedInstance.subjectText
            self.subjectTextField = cell1.subjectTextField
            cell1.subjectTextField.autocorrectionType = .no
            cell1.labelBut.addTarget(self,action:#selector(labelButton(sender:)), for: .touchUpInside)
            cell1.labelCcBut.addTarget(self,action:#selector(labelButton(sender:)), for: .touchUpInside)
            cell1.addToUser.addTarget(self,action:#selector(addUser(sender:)), for: .touchUpInside)
            cell1.addCcUser.addTarget(self,action:#selector(addCcUser(sender:)), for: .touchUpInside)
            
            if(isSelected)
            {
                cell1.toLabelHeightConstraint.constant = cellHeight+17
                cell1.toLabel.text = toText
                cell1.ccLabelHeightConstraint.constant = cellHeight+17
                cell1.ccLabel.text = ccText
            }
            else
            {
                cell1.toLabelHeightConstraint.constant = 25
                cell1.ccLabelHeightConstraint.constant = 25
            }
            
            
            return cell1
        }
        else if indexPath.row == 1
        {
            self.composeTextView = cell.viewWithTag(1) as! UITextView
            self.composeTextView.delegate = self
            self.composeTextView.addHideinputAccessoryView()
            
            if(composeType == Constants.ComposeType.draft)
            {
                self.forwardTextView.allowsEditingTextAttributes = true
                self.composeTextView.attributedText = replyData
            }
            else
            {
                self.composeTextView.attributedText = BL_Mail_Message.sharedInstance.composeText
                self.composeTextView.allowsEditingTextAttributes = true
            }
            
            if(attachmentFiles.count == 0)
            {
                cell.attachmentHeightConstraint.constant = 0
                cell.attachmentList = attachmentFiles
            }
            else
            {
                cell.attachmentHeightConstraint.constant = 100
                cell.attachmentList = attachmentFiles
                
            }
            cell.attachmentCollectionView.reloadData()
            return cell
        }
        
        if(indexPath.row == 2)
        {
            self.forwardTextView = cell2.viewWithTag(2) as! UITextView
            self.forwardTextView.delegate = self
            self.forwardTextView.addHideinputAccessoryView()
            self.forwardTextView.allowsEditingTextAttributes = true
            self.forwardTextView.attributedText = replyData
            self.forwardTextView.font = UIFont(name:fontRegular, size: 13)
            if(self.messageDataFromDetail.lstMailMessageAttachments.count > 0 )
            {
                cell2.attachmentList = self.messageDataFromDetail.lstMailMessageAttachments
                if(composeType == Constants.ComposeType.forward)
                {
                    BL_Mail_Message.sharedInstance.forwardImage = self.messageDataFromDetail.lstMailMessageAttachments.count
                }
                cell2.attachmentHeightConstraint.constant = 80
                cell2.attachmentCollectionView.reloadData()
            }
            else
            {
                cell2.attachmentHeightConstraint.constant = 0
                if(composeType == Constants.ComposeType.forward)
                {
                    
                    BL_Mail_Message.sharedInstance.forwardImage = self.messageDataFromDetail.lstMailMessageAttachments.count
                }
                cell2.attachmentList = []
            }
            cell2.fromLbl.attributedText = attributedStringWithBold(boldText: "FROM: ", normalText: self.messageDataFromDetail.objMailMessageHeader.Sender_Employee_Name)
            cell2.dateLbl.attributedText = attributedStringWithBold(boldText: "DATE: ", normalText: convertDateIntoString(date: self.messageDataFromDetail.objMailMessageHeader.Date_From))
            cell2.subjectLbl.attributedText = attributedStringWithBold(boldText: "SUBJECT: ", normalText: self.messageDataFromDetail.objMailMessageContent.Subject)
            let toCcUserList = NSMutableAttributedString()
            toCcUserList.append(attributedStringWithBold(boldText: "TO: ", normalText: toREplyUserName))
            if(ccREplyUserName.count>0)
            {
                let newLine = NSMutableAttributedString(string:"\n" , attributes:nil)
                toCcUserList.append(newLine)
                toCcUserList.append(attributedStringWithBold(boldText: "CC: ", normalText: ccREplyUserName))
            }
            cell2.toLbl.attributedText = toCcUserList
            cell2.subjectViewHeightConstraint.constant = 60 + getToTextSize()
            
            return cell2
        }
        
        return cell1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(indexPath.row == 0)
        {
            if(isSelected)
            {
                return CGFloat(cellHeight)+constantCellHeight + CGFloat(cellHeight)
            }
            else
            {
                return constantCellHeight
            }
        }
        else if indexPath.row == 1
        {
            if(attachmentFiles.count == 0)
            {
                return CGFloat(cellHeight1)
            }
            else
            {
                return CGFloat(cellHeight1)+attachmentHeight
            }
        }
        else if(indexPath.row == 2)
        {
            if(self.messageDataFromDetail.lstMailMessageAttachments.count > 0 )
            {
                let getSubjectViewHeight :CGFloat = getToTextSize()
                return CGFloat(cellHeight2) + getSubjectViewHeight + attachmentHeight + 80
            }
            else
            {
                let getSubjectViewHeight :CGFloat = getToTextSize()
                return CGFloat(cellHeight2) + getSubjectViewHeight + 80
            }
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(indexPath.row == 0)
        {
            
            isSelected = !isSelected
            cellHeight = getTextSize(text: toText, fontName: fontRegular, fontSize: 13, constrainedWidth: SCREEN_WIDTH-70).height
            loadFirstRow(selected: isSelected)
        }
    }
    
    func getToTextSize()-> CGFloat
    {
        var ccHeight = CGFloat()
        if(ccREplyUserName.count>0)
        {
            ccHeight = getTextSize(text: ccREplyUserName, fontName: fontRegular, fontSize: 14, constrainedWidth: SCREEN_WIDTH - 20).height+20
        }
        return getTextSize(text: toREplyUserName, fontName: fontRegular, fontSize: 14, constrainedWidth: SCREEN_WIDTH - 20).height+20+ccHeight
    }
    
    //MARK:- TextView delegates
    func textViewDidChange(_ textView: UITextView)
    {
        self.tableView.beginUpdates()
        
        if(textView.tag == 1)
        {
            textView.isScrollEnabled = true
            self.cellHeight1 = textView.contentSize.height + 80
            //getTextSize(text: textView.text, fontName: fontRegular, fontSize: 14, constrainedWidth: SCREEN_WIDTH - 40).height+220
        }
        else if(textView.tag == 2)
        {
            textView.isScrollEnabled = true
            self.cellHeight2 = textView.contentSize.height + 80
        }
        
        self.tableView.endUpdates()
        if(textView.tag == 1)
        {
            textView.scrollRangeToVisible(NSMakeRange(textView.text.count-1,0))
            BL_Mail_Message.sharedInstance.composeText = textView.attributedText
        }
        else
        {
            textView.scrollRangeToVisible(NSMakeRange(textView.text.count-1,0))
            replyData = textView.attributedText
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
    }
    
    func addSendBtn()
    {
        attachBut = UIBarButtonItem(image: UIImage(named: "icon-attach"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(attachAction))
        sendBut = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(sendAction))
        self.navigationItem.rightBarButtonItems = [sendBut,attachBut]
    }
    
    //MARK:- Upload Attachment
    private func uploadAttachment()
    {
        let imageURL = BL_Mail_Message.sharedInstance.getFileUrlFromDocumentsDirectory(fileName: attachmentFiles[index], subFolder: Constants.MessageConstants.newAttachment)
        
        showCustomActivityIndicatorView(loadingText: "Uploading attachment. Please wait...")
        
        BL_Mail_Message.sharedInstance.sendAttachment(filePath: imageURL, completion: { (apiResponseObj) in
            self.uploadAttachmentCallBack(apiResponseObj: apiResponseObj)
        })
    }
    
    private func uploadAttachmentCallBack(apiResponseObj: String)
    {
        // uploadList[index].Upload_Status = apiResponseObj.Status
        // uploadList[index].Upload_Msg = apiResponseObj.Message
        
        if(apiResponseObj == EMPTY)
        {
            removeCustomActivityView()
            showToastView(toastText: "Sorry. Unable to upload attachment")
        }
        else
        {
            self.attachementBlodUrl.append(apiResponseObj)
            
            if (self.index + 1 < attachmentFiles.count)
            {
                self.index += 1
                
                uploadAttachment()
            }
            else if( self.index + 1 == attachmentFiles.count)
            {
                self.isNewmessage()
            }
        }
    }
    
    @objc func sendAction()
    {
        if(attachmentFiles.count==0)
        {
            self.isNewmessage()
        }
        else
        {
            attachementBlodUrl.removeAll()
            if(self.toSelectedList.count == 0)
            {
                AlertView.showAlertView(title: errorTitle, message: "Please select at least one user to send mail", viewController: self)
            }
            else
            {
                self.uploadAttachment()
            }
            
        }
    }
    
    func isNewmessage()
    {
        if(self.forwardAttachementBlodUrl.count > 0)
        {
            for forwardAttachment in self.forwardAttachementBlodUrl
            {
                self.attachementBlodUrl.append(forwardAttachment)
            }
        }
        if(self.rowCount == 2)
        {
            let msgContent = convertToHtml(content: self.composeTextView.attributedText!)
            
            if(composeType ==  Constants.ComposeType.draft)
            {
                self.sendMesaage(msgType: false, msgContent: String(describing: msgContent), msgId:0, lstAgent: nil)
            }
            else
            {
                self.sendMesaage(msgType: true, msgContent: String(describing: msgContent), msgId: 0, lstAgent: nil)
            }
        }
        else
        {
            self.appendReplyDetails()
        }
        
    }
    
    func appendReplyDetails()//reply and forward
    {
        let messageDetails = "<html><body><p><br>FROM: \(self.messageDataFromDetail.objMailMessageHeader.Sender_Employee_Name)<br>DATE:  \(convertDateIntoString(date:self.messageDataFromDetail.objMailMessageHeader.Date_From!))<br>Subject: \(self.messageDataFromDetail.objMailMessageContent.Subject!)<br>TO: \(toREplyUserName)<br>TO: \(ccREplyUserName)<br></p></body></html>"
        _ = convertStringToHtml(content: messageDetails)
        let messageContent = convertToHtml(content: self.composeTextView.attributedText!) + messageDetails + convertToHtml(content:self.forwardTextView.attributedText!)
        //     let _ : NSAttributedString = NSMutableAttributedString(string: messageContent)
        self.sendMesaage(msgType: false, msgContent: messageContent, msgId: 0, lstAgent: self.messageDataFromDetail.lstMailMessageAgents)
    }
    
    
    func convertStringToHtml(content:String)-> String
    {
        var outPutString = ""
        let textView = UITextView()
        textView.attributedText = NSAttributedString(string: content, attributes: [NSAttributedStringKey.font: UIFont(name: fontRegular, size: 5)!])
        
        if let attributedText = textView.attributedText
        {
            do
            {
                let htmlData = try attributedText.data(from: NSRange(location: 0, length: attributedText.length), documentAttributes: [NSAttributedString.DocumentAttributeKey.documentType:NSAttributedString.DocumentType.html])
                let htmlString = String(data: htmlData, encoding: .utf8) ?? ""
                outPutString = htmlString
            }
            catch
            {
                print(error)
            }
        }
        return outPutString
    }
    
    func convertToHtml(content:NSAttributedString)-> String
    {
        var outPutString = ""
        do
        {
            let htmlData = try content.data(from: NSRange(location: 0, length: content.length), documentAttributes: [NSAttributedString.DocumentAttributeKey.documentType:NSAttributedString.DocumentType.html])
            let htmlString = String(data: htmlData, encoding: .utf8) ?? ""
            outPutString = htmlString
        }
        catch
        {
            print(error)
        }
        return outPutString
    }
    
    @objc func attachAction()
    {
        self.view.endEditing(true)
        BL_Mail_Message.sharedInstance.composeText = self.composeTextView.attributedText
        BL_Mail_Message.sharedInstance.subjectText = self.subjectTextField.text!
        Attachment.sharedInstance.showAttachmentActionSheet(viewController: self)
        Attachment.sharedInstance.delegate = self
        Attachment.sharedInstance.isFromMessage = true
    }
    
    //MARK:- Label height and load 1st Row
    @objc func labelButton(sender:UIButton)
    {
        BL_Mail_Message.sharedInstance.subjectText = self.subjectTextField.text!
        isSelected = !isSelected
        cellHeight = getTextSize(text: toText, fontName: fontRegular, fontSize: 13, constrainedWidth: SCREEN_WIDTH-45).height
        cellHeight += getTextSize(text: ccText, fontName: fontRegular, fontSize: 13, constrainedWidth: SCREEN_WIDTH-45).height
        loadFirstRow(selected: isSelected)
    }
    
    func loadFirstRow(selected : Bool)
    {
        let indexpath = IndexPath(row: 0, section: 0)
        isSelected = selected
        tableView.reloadRows(at: [indexpath], with: UITableViewRowAnimation.none)
    }
    
    @objc func addUser(sender:UIButton)
    {
        if(self.replyUserList.count != 0)
        {
            toSelectedList.append(self.replyUserList[0])
        }
        
        retainMessageData(isFromCC:false,userList: toSelectedList)
        
    }
    
    @objc func addCcUser(sender:UIButton)
    {
        
        if(self.replyCcUserList.count != 0)
        {
            for ccData in replyCcUserList
            {
                ccSelectedList.append(ccData)
            }
        }
        retainMessageData(isFromCC:true,userList: ccSelectedList)
        
    }
    
    private func retainMessageData(isFromCC:Bool,userList:[UserMasterWrapperModel])
    {
        BL_Mail_Message.sharedInstance.composeText = self.composeTextView.attributedText
        BL_Mail_Message.sharedInstance.subjectText = self.subjectTextField.text!
        loadFirstRow(selected: false)
        let accom_sb = UIStoryboard(name: commonListSb, bundle: nil)
        let accom_vc = accom_sb.instantiateViewController(withIdentifier: userListVcID) as! UserListViewController
        accom_vc.navigationScreenName = "MessageUserList"
        accom_vc.navigationTitle = "User List"
        accom_vc.messageUserListDelegate = self
        accom_vc.toUserList = userList
        accom_vc.isFromCC = isFromCC
        self.navigationController?.pushViewController(accom_vc, animated: false)
    }
    //MARK:- Get user list from UseViewController
    func setSelectedMessageUserList(accompanistObj: [UserMasterWrapperModel],isFromCc:Bool)
    {
        if(isFromCc)
        {
            ccSelectedList = accompanistObj
            getCcuserformArray(accompanistObj: accompanistObj)
        }
        else
        {
            toSelectedList = accompanistObj
            getTouserformArray(accompanistObj: accompanistObj)
        }
    }
    
    
    func getCcuserformArray(accompanistObj: [UserMasterWrapperModel])
    {
        var ccUser = [String]()
        
        for i in 0..<accompanistObj.count
        {
            ccUser.append(accompanistObj[i].userObj.Employee_name)
        }
        
        if(ccUser.count == 1)
        {
            ccText = ccUser[0]
        }
        else
        {
            ccText = ccUser.joined(separator: ", ")
        }
        
        if(accompanistObj.count >= 3)
        {
            ccTempText = accompanistObj[0].userObj.Employee_name + " \(accompanistObj.count-1)" + " more..."
        }
        else
        {
            ccTempText = ccText
        }
        
        self.tableView.reloadData()
    }
    
    func getTouserformArray(accompanistObj: [UserMasterWrapperModel])
    {
        var toUser = [String]()
        
        for i in 0..<accompanistObj.count
        {
            toUser.append(accompanistObj[i].userObj.Employee_name)
        }
        
        if(toUser.count == 1)
        {
            toText = toUser[0]
        }
        else
        {
            toText = toUser.joined(separator: ", ")
        }
        
        if(accompanistObj.count >= 3)
        {
            toTempText = accompanistObj[0].userObj.Employee_name + " \(accompanistObj.count-1)" + " more..."
        }
        else
        {
            toTempText = toText
        }
        
        self.tableView.reloadData()
    }
    
    func getTouserformReply()
    {
        var toUser = [String]()
        var ccUser = [String]()
        for i in 0..<self.messageDataFromDetail.lstMailMessageAgents.count
        {
            if(self.messageDataFromDetail.lstMailMessageAgents[i].Address_Type == "TO")
            {
                toUser.append(self.messageDataFromDetail.lstMailMessageAgents[i].Target_Employee_Name)
            }
            else
            {
                ccUser.append(self.messageDataFromDetail.lstMailMessageAgents[i].Target_Employee_Name)
            }
        }
        toREplyUserName = toUser.joined(separator: ", ")
        ccREplyUserName = ccUser.joined(separator: ", ")
    }
    
    //MARK:- TextField delegates
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        self.subjectTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return false
    }
    
    //MARK:- Cloud Attachment
    func iCloudAttachObserver()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(MessageComposeViewController.iCloudObserverAction(_:)), name: NSNotification.Name(rawValue: iCloudObserver), object: nil)
    }
    
    @objc func iCloudObserverAction(_ notification: NSNotification)
    {
        self.attachmentFiles = BL_Mail_Message.sharedInstance.selectedImage
        self.attachmentHeight = 100
        self.tableView.reloadData()
    }
    
    //MARK:- Keyboard Action
    @objc func keyboardWillShow(notification: NSNotification)
    {
        if ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil
        {
            //self.view.frame.origin.y -= keyboardSize.height
            var userInfo = notification.userInfo!
            var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            keyboardFrame = self.view.convert(keyboardFrame, from: nil)
            
            var contentInset:UIEdgeInsets = self.tableView.contentInset
            contentInset.bottom = keyboardFrame.size.height
            self.tableView.contentInset = contentInset
            
            //get indexpath
            // let indexpath = IndexPath(row: 1, section: 0)
            //  self.tableView.scrollToRow(at: indexpath, at: UITableViewScrollPosition.top, animated: true)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        let contentInsets = UIEdgeInsets.zero
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
    }
    
    //MARK:- String to attributed string
    func attributedStringWithBold(boldText: String, normalText: String)->NSAttributedString
    {
        let boldText  = boldText
        let attrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
        
        let normalText = normalText
        let normalString = NSMutableAttributedString(string:normalText)
        
        attributedString.append(normalString)
        return attributedString
    }
    
    func sendMesaage(msgType:Bool, msgContent:String, msgId: Int,  lstAgent:[MailMessageAgent]?)
    {
        if(self.toSelectedList.count == 0)
        {
            AlertView.showAlertView(title: errorTitle, message: "Please select at least one user to send mail", viewController: self)
        }
            //        else if (checkNullAndNilValueForString(stringData: self.subjectTextField.text) == EMPTY)
            //        {
            //            AlertView.showAlertView(title: errorTitle, message: "Please enter subject", viewController: self)
            //        }
        else
        {
            showCustomActivityIndicatorView(loadingText: "Sending message. Please wait...")
            
            for toSelecteedUser in toSelectedList
            {
                ccSelectedList = self.ccSelectedList.filter
                    {
                        $0.userObj.User_Code != toSelecteedUser.userObj.User_Code
                }
            }
            
            BL_Mail_Message.sharedInstance.sendMail(messageSubject: self.subjectTextField.text!, messageContent: msgContent, lstAgent: lstAgent, targetUserList: self.toSelectedList,targetCcUserList:self.ccSelectedList, isNewMail: msgType, msgId: msgId, attachmentBlobUrlList: self.attachementBlodUrl, completion: { (apiObjResponse) in
                
                removeCustomActivityView()
                
                if apiObjResponse.Status == SERVER_SUCCESS_CODE
                {
                    self.navigationController?.popViewController(animated: true)
                }
                else
                {
                    if (apiObjResponse.Message != EMPTY && apiObjResponse.Message.uppercased() != errorTitle.uppercased())
                    {
                        showToastView(toastText: apiObjResponse.Message)
                    }
                    else
                    {
                        showToastView(toastText: "Sorry. Unable to send message")
                    }
                }
            })
        }
    }
}

//MARK:- ResignFirstResponder inside tableview textview
extension UITextView
{
    func addHideinputAccessoryView()
    {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let item = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done,
                                   target: self, action: #selector(self.resignFirstResponder))
        toolbar.setItems([flexBarButton , item], animated: true)
        self.inputAccessoryView = toolbar
    }
}

extension UITextField
{
    func addHideinputAccessoryView()
    {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let item = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done,
                                   target: self, action: #selector(self.resignFirstResponder))
        toolbar.setItems([flexBarButton , item], animated: true)
        self.inputAccessoryView = toolbar
    }
}

extension UIViewController
{
    func hideKeyboardWhenTappedAround()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
extension Array {
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }
        
        return arrayOrdered
    }
}
