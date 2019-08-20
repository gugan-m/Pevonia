//
//  NoticeBoardViewController.swift
//  HiDoctorApp
//
//  Created by Kanchana on 8/4/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class NoticeBoardViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var emptyStateView: UIView!
    @IBOutlet var emptyStateLabel: UILabel!
    @IBOutlet var emptyStateRefreshBtn: UIButton!
    
    var noticeList:[NoticeBoardModel] = []
    var refreshControl: UIRefreshControl!
    var bottomRefresh: Bool = false
    var bottomRefreshView:UIActivityIndicatorView = UIActivityIndicatorView()
    var pageNumber : Int = 2
    
    //MARK:- View ControllerLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noticeList = DAL_NoticeBoard.sharedInstance.getNoticeBoardDetail()!
        self.pullDownRefresh()
        self.refresh()
        self.bottomRefreshView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44.0)
        self.bottomRefreshView.color = UIColor.gray
        
    }
    override func viewWillAppear(_ animated: Bool) {
       
      //  self.refresh()
        tableView.reloadData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK:- Tableview Datasource and Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return(noticeList.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.NoticeBoardCell, for: indexPath) as! NoticeBoardTableViewCell
        let celldata = noticeList[indexPath.row]
        
        cell.noticeTitle.text = celldata.Msg_Title as String
        cell.noticeMSg.text = celldata.Msg_Body as String
        let startDate = convertDateIntoString(dateString: celldata.Msg_Valid_From)
        let endDate = convertDateIntoString(dateString: celldata.Msg_Valid_To)
        cell.fromDatetoDate.text = "\(convertDateIntoString(date: startDate)) to \(convertDateIntoString(date: endDate))"
        cell.msgDistributionType.text = celldata.Msg_Distribution_Type as String
        
        if celldata.Msg_Priority == 0
        {
            cell.msgPriorityView.backgroundColor = MessagePriorityColor.messagePriorityHighBgColor.color
            cell.msgPriorityLbl.text = Constants.MessageConstants.High
            cell.Msgpriority.image = #imageLiteral(resourceName: "ic_high@1,5x")
        }
        else if celldata.Msg_Priority == 1
        {
            cell.msgPriorityView.backgroundColor = MessagePriorityColor.messagePriorityMediumBgColor.color
            cell.msgPriorityLbl.text = Constants.MessageConstants.Medium
            cell.Msgpriority.image = #imageLiteral(resourceName: "ic_medium@1,5x")
        }
        else
        {
            cell.msgPriorityView.backgroundColor = MessagePriorityColor.messagePriorityLowBgColor.color
            cell.msgPriorityLbl.text = Constants.MessageConstants.Low
            cell.Msgpriority.image = #imageLiteral(resourceName: "ic_low@1,5x")
        }
        if celldata.Is_Read == Constants.MessageConstants.N
        {
            cell.msgView.backgroundColor = MessageReadColor.messageUnReadBgColor.color
        }
        else
        {
            cell.msgView.backgroundColor = MessageReadColor.messageReadBgColor.color
        }
        
        
        return(cell)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if checkInternetConnectivity()
        {
            let cellData = noticeList[indexPath.row]
            BL_NoticeBoard.sharedInstance.postNoticeBoardDetail(msgCode: cellData.Msg_Code)
            noticeList[indexPath.row].Is_Read = Constants.MessageConstants.Y
            
            let vc2 = storyboard?.instantiateViewController(withIdentifier: Constants.ViewControllerNames.NoticeDetailVCID) as! NoticeDetailViewController
            vc2.noticeobj = noticeList[indexPath.row]
            
            self.navigationController?.pushViewController(vc2, animated: true)
        }
        else
        {
            AlertView.showAlertView(title: internetOfflineTitle, message: internetOfflineMessage, viewController: self)
        }
    }
    
    //MARK:- Refresh EmptyStateView
    @IBAction func emptyStateRefreshbutton(_ sender: UIButton) {
        refresh()
    }
    
    
    //MARK:- Refresh Control Functions
    private func pullDownRefresh()
    {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self,action: #selector(NoticeBoardViewController.pullDownRefreshAction), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)
        
    }
    private func endRefresh()
    {
        if self.refreshControl.isRefreshing
        {
            self.refreshControl.endRefreshing()
        }
    }
    //MARK:- Show views
    private func showEmptyStateView()
    {
        self.emptyStateView.isHidden = false
        self.tableView.isHidden = true
    }
    private func showTableView()
    {
        self.tableView.isHidden = false
        self.tableView.reloadData()
        self.emptyStateView.isHidden = true
    }
    private func updateViews()
    {
        if noticeList.count > 0
        {
            self.showTableView()
        }
        else
        {
            self.showEmptyStateView()
        }
    }
    func refresh()
    {
        
        if checkInternetConnectivity()
        {
            BL_MenuAccess.sharedInstance.getCheckUserExist(viewController: self, completion: { (objApiResponse) in
                if self.refreshControl.isRefreshing == false
                {
                    self.showActivityIndicator()
                }
                BL_NoticeBoard.sharedInstance.getNoticeBoardDetail{(StatusMsg,Status,list) in
                    removeCustomActivityView()
                    self.endRefresh()
                    if Status == SERVER_SUCCESS_CODE
                    {
                        if list.count > 0
                        {
                            self.noticeList = DAL_NoticeBoard.sharedInstance.getNoticeBoardDetail()!
                            self.updateViews()
                        }
                        else
                        {
                            self.emptyStateLabel.text = "No Notices Found"
                            self.showEmptyStateView()
                        }
                        
                    }
                    else
                    {
                        self.emptyStateLabel.text = StatusMsg
                        self.showEmptyStateView()
                    }
                }
            })
        }
        else
        {
            self.noticeList = []
            self.emptyStateLabel.text = internetOfflineMessage
            self.updateViews()
        }
    }
    //MARK:- Custom Activity Indicator
    func showActivityIndicator()
    {
        if self.tableView.isHidden == false
        {
            self.tableView.isHidden = true
        }
        
        if emptyStateView.isHidden == false
        {
            emptyStateView.isHidden = true
        }
        
        showCustomActivityIndicatorView(loadingText: "Loading the Noticeboard data..")
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if allowBottomRefresh() == true
        {
            let scrollOffset : CGFloat = scrollView.contentOffset.y
            let scrollHeight : CGFloat = scrollView.frame.size.height
            
            let scrollContentSizeHeight : CGFloat = scrollView.contentSize.height + scrollView.contentInset.bottom
            if Int(scrollOffset + scrollHeight) >= Int(scrollContentSizeHeight)
            {
                if checkInternetConnectivity()
                {
                    self.tableView.tableFooterView?.isHidden = false
                    self.tableView.tableFooterView = bottomRefreshView
                    self.bottomRefreshView.startAnimating()
                    
                    BL_NoticeBoard.sharedInstance.updateNoticeBoardDetail(pageNo: pageNumber){(StatusMsg,Status,list) in
                        self.bottomRefreshView.stopAnimating()
                        if Status == SERVER_SUCCESS_CODE
                        {
                            self.noticeList = DAL_NoticeBoard.sharedInstance.getNoticeBoardDetail()!
                            self.updateViews()
                            
                            if list.count > 0
                            {
                                self.pageNumber = self.pageNumber+1
                            }
                        }
                        else
                        {
                            self.emptyStateLabel.text = StatusMsg
                            self.showEmptyStateView()
                        }
                    }
                    
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
        
        if noticeList.count % 10 == 0
        {
            bottomRefresh = true
        }
        else
        {
            bottomRefresh = false
        }
        return bottomRefresh
    }
    @objc func pullDownRefreshAction()
    {
        if checkInternetConnectivity()
        {
            refresh()
        }
        else
        {
            self.endRefresh()
            showToastView(toastText: internetOfflineMessage)
        }
    }
}
