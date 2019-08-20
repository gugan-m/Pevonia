//
//  MessageViewController.swift
//  HiDoctorApp
//
//  Created by Vijay on 31/08/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
class MessageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var deleteBtn : UIBarButtonItem!
    var cancelBtn : UIBarButtonItem!
    
    @IBOutlet var tabBt: [UIView]!
    @IBOutlet var tabbarLabel: [UILabel]!
    @IBOutlet var tabbarImage: [UIImageView]!
    
    var messageList : [MailMessageWrapperModel] = []
    var refreshControl: UIRefreshControl!
    var bottomRefresh: Bool = false
    var bottomRefreshView:UIActivityIndicatorView = UIActivityIndicatorView()
    var messageType = Int()
    var pageNumber = Int()
    var islongPress : Bool = false
    var refreshBtn : UIBarButtonItem!
    var searchString : String = "NA"
    var titleString :[String] = [Constants.MessageList.inbox, Constants.MessageList.draft, Constants.MessageList.sent,Constants.MessageList.trash]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        bottomRefreshView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44.0)
        bottomRefreshView.color = UIColor.gray
        pageNumber = 1
        searchBar.layer.borderWidth = 1;
        searchBar.layer.borderColor = (UIColor.white).cgColor
        searchBar.placeholder = "Search..."
        self.longPress()
        self.pullDownRefresh()
        self.addRefreshBtn()
        self.changeTabState(tabIndex: 0)
        self.addComposeButtonToNavigate(show: true)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.messageList.removeAll()
        setDefaults()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setDefaults()
    {
        pageNumber = 1
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.messageList.removeAll()
        self.getData(refreshData:0)
    }
    
    func longPress()
    {
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap(_:)))
        self.tableView.addGestureRecognizer(longGesture)
    }
    
    private func updateViews()
    {
        if messageList.count > 0
        {
            showTableView()
        }
        else
        {
            showEmptyStateView()
        }
    }
    
    private func showEmptyStateView()
    {
        emptyStateView.isHidden = false
        tableView.isHidden = true
    }
    
    private func showTableView()
    {
        tableView.isHidden = false
        tableView.reloadData()
        emptyStateView.isHidden = true
    }
    
    //MARK:- Custom Activity Indicator
    func showActivityIndicator()
    {
        if tableView.isHidden == false
        {
            tableView.isHidden = true
        }
        
        if emptyStateView.isHidden == false
        {
            emptyStateView.isHidden = true
        }
        
        showCustomActivityIndicatorView(loadingText: "Getting messages. Please wait...")
    }
    
    //MARK:- tableView Delegates
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.MessageCell, for: indexPath) as! MessageTableViewCell
        if(messageList.count > 0)
        {
            
            let messageData = messageList[indexPath.row]
            
            cell.attachmentList.removeAll()
            cell.attachmentList = messageData.lstMailMessageAttachments
            
            if(messageData.lstMailMessageAttachments.count == 0)
            {
                cell.attachmentcellHeight.constant = 0
            }
            else
            {
                cell.attachmentcellHeight.constant = 80
            }
            
            cell.attachementCollectionView.reloadData()
            var messageContent =  self.trimContent(messageContent: messageData.objMailMessageContent.Content)
            var message = try! NSAttributedString(
                data: messageContent.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil)
            
            if(message.string.count == 0 || message.string == EMPTY){
                let splitString = messageData.objMailMessageContent.Content.components(separatedBy: "<body>")
                if(splitString.count >= 2)
                {
                    messageContent =  self.trimContent(messageContent:splitString[1])
                    message = try! NSAttributedString(
                        data: messageContent.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                        options: [ .documentType: NSAttributedString.DocumentType.html],
                        documentAttributes: nil)
                }
            }
            
            cell.messageContent.text = "\(message)"
            
            //cell.messageContent.text = stringFromHtml(string: messageData.objMailMessageContent.Content as String)
            cell.messageSubject.text = messageData.objMailMessageContent.Subject as String
            if(self.messageType == Constants.MessageType.draft || self.messageType == Constants.MessageType.sent)
            {
                    var toUser = [String]()
                    var alltoUser = String()
                    for i in 0..<messageData.lstMailMessageAgents.count
                    {
                        toUser.append(messageData.lstMailMessageAgents[i].Target_Employee_Name)
                    }
                    alltoUser = toUser.joined(separator: ", ")

                cell.messageSenderName.text = alltoUser
            }
            else
            {
                cell.messageSenderName.text = messageData.objMailMessageHeader.Sender_Employee_Name as String
            }
            cell.messageDateandTime.text = convertDateIntoString(date: messageData.objMailMessageHeader.Date_From) as String
            
            if(Constants.MessageType.inbox == messageType)
            {
                let filteredContent = messageData.lstMailMessageAgents.filter{
                    $0.Target_UserCode == getUserCode() && $0.Is_Read == 0
                }
                
                if(filteredContent.count > 0)
                {
                    cell.readLabel.isHidden = false
                }
                else
                {
                    cell.readLabel.isHidden = true
                }
            }
            else
            {
                cell.readLabel.isHidden = true
                
            }
            
            if(messageData.isSelected)
            {
                cell.accessoryType = .checkmark
                cell.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
            }
            else
            {
                cell.accessoryType = .none
                cell.backgroundColor = UIColor.white
            }
            
            return cell
        }
        else
        {
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(messageList.count > 0)
        {
        let messageAttachmentData = messageList[indexPath.row]
        
        if(messageAttachmentData.lstMailMessageAttachments.count==0)
        {
            return 80
        }
        
        return 166
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(islongPress)
        {
            let messageData = self.messageList[indexPath.row]
            if(messageData.isSelected == false)
            {
                messageList[indexPath.row].isSelected = true
            }
            else if(messageData.isSelected == true)
            {
                messageList[indexPath.row].isSelected = false
            }
            tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
        }
        else
        {
            if(messageType == 2)
            {
                let sb = UIStoryboard(name:Constants.StoaryBoardNames.MessageSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.MessageComposeVCID) as! MessageComposeViewController
                let messageData = self.messageList[indexPath.row]
                vc.messageDataFromDetail = messageData
                vc.composeType = Constants.ComposeType.draft
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
            let messageData = messageList[indexPath.row]
            let sb = UIStoryboard(name:Constants.StoaryBoardNames.TPCopyTourPlanSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.MessageDetailID) as! MessageDetailViewController
            vc.messageData = messageData
            vc.messageType = messageType
            self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if (editingStyle == UITableViewCellEditingStyle.delete)
        {
            let initialAlert = "Are you sure to Delete"
            
            let alertViewController = UIAlertController(title: alertTitle, message: initialAlert, preferredStyle: UIAlertControllerStyle.alert)
            
            alertViewController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { alertAction in
                alertViewController.dismiss(animated: true, completion: nil)
            }))
            
            alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
                var messageDeleteData :[MailMessageWrapperModel] = []
                messageDeleteData.append(self.messageList[indexPath.row])
                if checkInternetConnectivity()
                {
                    BL_Mail_Message.sharedInstance.deleteMessage(msgList: messageDeleteData, messageType: self.messageType) { (objApiResponse) in
                        if(objApiResponse.Status == SERVER_SUCCESS_CODE)
                        {
                            self.messageList.remove(at: indexPath.row)
                            self.tableView.reloadData()
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
                
            }))
            
            self.present(alertViewController, animated: true, completion: nil)
        }
    }
    
    //MARK:- Refresh Function
    private func endRefresh()
    {
        if self.refreshControl.isRefreshing
        {
            refreshControl.endRefreshing()
        }
    }
    
    //MARK :-Get Message Data from api
    func getData(refreshData:Int)
    {
        if checkInternetConnectivity()
        {
            if refreshData == 0 //normal
            {
                if self.refreshControl.isRefreshing == false
                {
                    self.showActivityIndicator()
                }
            }
            else if refreshData == 1 //bottom refresh
            {
                self.bottomRefreshView.startAnimating()
            }
            
            BL_MenuAccess.sharedInstance.getCheckUserExist(viewController: self, completion: { (objApiResponse) in
                if (objApiResponse.list.count > 0)
                {
                    BL_Mail_Message.sharedInstance.messageList.removeAll()
                    
                    BL_Mail_Message.sharedInstance.getMailMessages(messageType: self.messageType, pageNumber: self.pageNumber, searchText: self.searchString) { (objResponse) in
                        if refreshData == 0 //normal
                        {
                            removeCustomActivityView()
                            self.endRefresh()
                        }
                        else if refreshData == 1 //bottom refresh
                        {
                            self.bottomRefreshView.stopAnimating()
                        }
                        
                        if objResponse.Status == SERVER_SUCCESS_CODE
                        {
                            if (self.pageNumber > 1)
                            {
                                let messageData = BL_Mail_Message.sharedInstance.processMailMessageResponse(messageType: self.messageType, lstMail: objResponse.list, pageNumber: self.pageNumber, searchText: self.searchString)
                                
                                for tempMessageList in messageData
                                {
                                    self.messageList.append(tempMessageList)
                                }
                            }
                            else
                            {
                                self.messageList.removeAll()
                                self.messageList = BL_Mail_Message.sharedInstance.processMailMessageResponse(messageType: self.messageType, lstMail: objResponse.list, pageNumber: self.pageNumber, searchText: self.searchString)
                            }
                            
                            BL_Mail_Message.sharedInstance.messageList = self.messageList
                            
                            if self.messageList.count > 0
                            {
                                self.tableView.reloadData()
                                self.updateViews()
                            }
                            else
                            {
                                self.emptyStateLabel.text = "No messages available"
                                self.showEmptyStateView()
                            }
                        }
                        else
                        {
                            self.emptyStateLabel.text = objResponse.Message
                            self.showEmptyStateView()
                        }
                    }
                }
//                else
//                {
//                    AlertView.showAlertView(title: errorTitle, message: authenticationMsg, viewController: self)
//                }
            })
        }
        else
        {
            if(self.messageType == Constants.MessageType.inbox)
            {
                self.messageList = BL_Mail_Message.sharedInstance.getMailMessageFromLocal(messageType: self.messageType)
                if self.messageList.count > 0
                {
                    self.updateViews()
                }
                else
                {
                    self.emptyStateLabel.text = "No Message Available"
                    self.showEmptyStateView()
                }
            }
            else
            {
                self.emptyStateLabel.text = internetOfflineMessage
                self.updateViews()
            }
        }
    }
    
    //MARK :-Pull Down Refresh
    private func pullDownRefresh()
    {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self,action: #selector(MessageViewController.pullDownRefreshAction), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func pullDownRefreshAction()
    {
        if checkInternetConnectivity()
        {
            self.getData(refreshData: 0)
        }
        else
        {
            self.endRefresh()
            showToastView(toastText: internetOfflineMessage)
        }
    }
    
    //MARK :-Bottom Refresh
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if allowBottomRefresh() == true
        {
            let scrollOffset : CGFloat = scrollView.contentOffset.y
            let scrollHeight : CGFloat = scrollView.frame.size.height
            
            let scrollContentSizeHeight : CGFloat = scrollView.contentSize.height + scrollView.contentInset.bottom
            if Int(scrollOffset + scrollHeight) >= Int(scrollContentSizeHeight)
            {
                if checkInternetConnectivity()
                {
                    tableView.tableFooterView?.isHidden = false
                    tableView.tableFooterView = bottomRefreshView
                    bottomRefreshView.startAnimating()
                    self.getData(refreshData: 1)
                }
                else
                {
                    showToastView(toastText: internetOfflineMessage)
                }
            }
        }
    }
    
    func allowBottomRefresh() -> Bool
    {
        if messageList.count % 10 == 0
        {
            bottomRefresh = true
            pageNumber += 1
        }
        else
        {
            bottomRefresh = false
        }
        return bottomRefresh
    }
    
    //MARK :-Delete Message
    @objc func longTap(_ sender: UIGestureRecognizer)
    {
        islongPress = true
        if sender.state == UIGestureRecognizerState.began
        {
            let touchPoint = sender.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint)
            {
                let messageData = BL_Mail_Message.sharedInstance.messageList[indexPath.row]
                messageData.isSelected = true
                tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
            }
            self.deleteButAction()
        }
    }
    
    func addRefreshBtn()
    {
        deleteBtn = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteAction))
        cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAction))
    }
    
    func deleteButAction()
    {
        self.navigationItem.rightBarButtonItems = [deleteBtn]
        self.navigationItem.leftBarButtonItems = [cancelBtn]
    }
    
    @objc func deleteAction()
    {
        islongPress = false
        
        let initialAlert = "Are you sure you want to Delete selected Messages"
        
        let alertViewController = UIAlertController(title: alertTitle, message: initialAlert, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { alertAction in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
            var messageDeleteData :[MailMessageWrapperModel] = []
            for i in 0..<BL_Mail_Message.sharedInstance.messageList.count
            {
                if(BL_Mail_Message.sharedInstance.messageList[i].isSelected == true)
                {
                    messageDeleteData.append(BL_Mail_Message.sharedInstance.messageList[i])
                }
                
            }
            
            self.deleteMessages(messageDeleteData: messageDeleteData)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func deleteMessages(messageDeleteData:[MailMessageWrapperModel])
    {
        if checkInternetConnectivity()
        {
            BL_Mail_Message.sharedInstance.deleteMessage(msgList: messageDeleteData, messageType: messageType) { (objApiResponse) in
                if(objApiResponse.Status == SERVER_SUCCESS_CODE)
                {
                    self.cancelAction()
                    self.setDefaults()
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
    
    func stringFromHtml(string: String) -> String?
    {
        do
        {
            let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
            if let d = data
            {
                let str = try NSAttributedString(data: d,
                                                 options: [.documentType: NSAttributedString.DocumentType.html],
                                                 documentAttributes: nil)
                return str.string
            }
        }
        catch
        {
        }
        return nil
    }
    
    //MARK :-Search Bar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if let text = searchBar.text
        {
            searchString = text
            self.pageNumber = 1
            self.getData(refreshData: 0)
            // searchListContent(text: text)
        }
        else
        {
            searchString = "NA"
            self.pageNumber = 1
            self.getData(refreshData: 0)
            // searchListContent(text: "")
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool
    {
        self.searchBar.showsCancelButton = true
        enableCancelButtonForSearchBar(searchBar:searchBar)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        
        self.searchBar.showsCancelButton = false
        self.searchBar.text = nil
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.resignFirstResponder()
    }
    
    func trimContent(messageContent: String) -> String
    {
        var message = String()
        if (messageContent.count > 150)
        {
            let index = messageContent.index(messageContent.startIndex, offsetBy: 150)
            message = messageContent.substring(to: index)
        }
        else
        {
            message = messageContent
        }
        
        return message
    }
    
    @IBAction func inbox(_ sender: Any)
    {
        changeTabState(tabIndex: 0)
        self.addComposeButtonToNavigate(show: true)
    }
    
    @IBAction func draft(_ sender: Any)
    {
        changeTabState(tabIndex: 1)
        self.addComposeButtonToNavigate(show: false)
    }
    
    @IBAction func sent(_ sender: Any)
    {
        changeTabState(tabIndex: 2)
        self.addComposeButtonToNavigate(show: false)
    }
    
    @IBAction func trash(_ sender: Any)
    {
        changeTabState(tabIndex: 3)
        self.addComposeButtonToNavigate(show: false)
    }
    
    func changeTabState(tabIndex:Int)
    {
        self.messageType = tabIndex + 1
        for i in 0...3
        {
            if(i == tabIndex)
            {
                self.title = titleString[i]
                self.tabbarLabel[i].textColor = UIColor(red: 22/255, green: 122/255, blue: 255/255, alpha: 1.0)
                self.tabbarImage[i].tintColor = UIColor(red: 22/255, green: 122/255, blue: 255/255, alpha: 1.0)
            }
            else
            {
                self.tabbarLabel[i].textColor = UIColor.gray
                self.tabbarImage[i].tintColor = UIColor.gray
            }
        }
        self.setDefaults()
    }
    
    private func addComposeButtonToNavigate(show:Bool)
    {
        if(show == true)
        {
            let backButton = UIButton(type: UIButtonType.custom)
            
            backButton.addTarget(self, action: #selector(self.composeButtonClicked), for: UIControlEvents.touchUpInside)
            backButton.setImage(UIImage(named: "icon-plus"), for: .normal)
            backButton.sizeToFit()
            
            let rightBarButtonItem = UIBarButtonItem(customView: backButton)
            
            self.navigationItem.rightBarButtonItem = rightBarButtonItem
        }
        else
        {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc func composeButtonClicked()
    {
        let sb = UIStoryboard(name:Constants.StoaryBoardNames.MessageSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.MessageComposeVCID) as! MessageComposeViewController
        vc.composeType = Constants.ComposeType.compose
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func cancelAction()
    {
        islongPress = false
        addComposeButtonToNavigate(show: true)
        let backButton = UIButton(type: UIButtonType.custom)
        backButton.addTarget(self, action: #selector(self.bacButAction), for: UIControlEvents.touchUpInside)
        backButton.setImage(UIImage(named: "navigation-arrow"), for: .normal)
        backButton.sizeToFit()
        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        leftBarButtonItem.title = "More"
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        for messageData in messageList
        {
            messageData.isSelected = false
        }
        self.tableView.reloadData()
    }
    
    @objc func bacButAction()
    {
        _ = navigationController?.popViewController(animated: false)
    }
}


