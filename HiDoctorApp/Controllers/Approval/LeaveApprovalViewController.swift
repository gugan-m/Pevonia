//
//  LeaveApprovalViewController.swift
//  HiDoctorApp
//
//  Created by User on 23/07/19.
//  Copyright © 2019 swaas. All rights reserved.
//

import UIKit

class LeaveApprovalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var lblTypeName: UILabel!
    
    @IBOutlet weak var tableviewLeaveApproval: UITableView!
    
    @IBOutlet weak var emptyStateLabel: UILabel!
    var selectedUserCode:String!
    var selectedRegionCode:String!
    var selectedName:String!
    var userTypeName:String!
    var refreshControl: UIRefreshControl!
    var leaveApprovalList: [LeaveApprovalModel] = []
    var answerList :[LeaveAttachmentData] = []
  //  var approvalList : ApprovalUserMasterModel!
    var addBtn : UIBarButtonItem!
    var isLeaveAPI: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if BL_DCRReject.sharedInstance.checkIsRejectPrevilegeEnabled()
        {
        let rightBarButton = UIButton(type: UIButtonType.custom)
        rightBarButton.addTarget(self, action: #selector(ActionRightBarButton), for: UIControlEvents.touchUpInside)
        rightBarButton.setImage(UIImage(named: "icon-filter"), for: .normal)
        rightBarButton.sizeToFit()
        addBtn = UIBarButtonItem(customView: rightBarButton)
        self.navigationItem.rightBarButtonItem = addBtn
        }
        
        self.tableviewLeaveApproval.dataSource = self
        self.tableviewLeaveApproval.delegate = self
        self.tableviewLeaveApproval.tableFooterView = UIView()
        //LeaveApprovalVCID
        
        self.lblTypeName.text = selectedName + "(" + userTypeName + ")"
        self.startLeavePedingApiCall()
        self.pullDownRefresh()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
 
        let strCheck = UserDefaults.standard.string(forKey: "IsAppliedAndApproved")
        
        if (strCheck == "0")
        {
            self.startLeavePedingApiCall()
            self.navigationItem.title = "Applied"
        }
        else
        {
            self.startLeavePedingApiCallForApproved()
        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.endRefresh()
    }
    private func startLeavePedingApiCall()
    {
        if checkInternetConnectivity()
        {
           showCustomActivityIndicatorView(loadingText: "Loading...")
            BL_DCR_Leave.sharedInstance.LeavePendingApproval(userCode: selectedUserCode, status: 1)
            { (apiResponseObject) in
                removeCustomActivityView()
                if apiResponseObject.Status == SERVER_SUCCESS_CODE
                {
                    self.isLeaveAPI = true
                    self.emptyStateLabel.text = ""
                    self.tableviewLeaveApproval.isHidden = false
                    if apiResponseObject.list.count > 0
                    {
                        self.leaveApprovalList = []
                        
                        for obj in apiResponseObject.list{
                            
                            let dict = obj as! [String:Any]
                            let responseObj = LeaveApprovalModel()
                           // let responseLeaveObj = LeaveAttachmentData()
                            responseObj.Attachment_Id = dict["Attachment_Id"] as? Int ?? 0
                            responseObj.From_Date = dict["From_Date"] as? String ?? ""
                            responseObj.To_Date = dict["To_Date"] as? String ?? ""
                            responseObj.Leave_Type_Name = dict["Leave_Type_Name"] as? String ?? ""
                            responseObj.Reason = dict["Reason"] as? String ?? ""
                            responseObj.DCR_ENTRY_UNAPPROVED_ACTIVITY_LOCK = dict["DCR_ENTRY_UNAPPROVED_ACTIVITY_LOCK"] as? String ?? ""
                            responseObj.Status = dict["Status"] as? String ?? ""
                            responseObj.leaveUnapprovedReason = dict["Unapprove_Reason"] as? String ?? ""
                            
                            let iceQueAnsData = obj as! NSDictionary
                            let iceAnsList = iceQueAnsData.value(forKey: "lstLeaveAttachmentData") as! NSArray
                          //  var answerList :[LeaveAttachmentData] = []
                            self.answerList = []
                            for iceAnswerObj in  iceAnsList
                            {
                                let iceAnsObj = LeaveAttachmentData()
                                let iceAnsData = iceAnswerObj as! NSDictionary
                                
                                iceAnsObj.Attachment_Id = iceAnsData.value(forKey: "Attachment_Id") as! Int
                                iceAnsObj.Attachment_Url = iceAnsData.value(forKey: "Attachment_Url") as! String
                                iceAnsObj.Attachment_Name = iceAnsData.value(forKey: "Attachment_Name") as! String
                                
                                self.answerList.append(iceAnsObj)
                            }
                            
                            responseObj.answerList = self.answerList
                            
                            self.leaveApprovalList.append(responseObj)
                        }
                        self.tableviewLeaveApproval.isHidden = false
                        self.endRefresh()
                        self.tableviewLeaveApproval.reloadData()
                    }
                    else
                    {
                        self.endRefresh()
                        self.tableviewLeaveApproval.isHidden = true
                        self.emptyStateLabel.text = "No Leave data found"
                    }
                    
                }
                else
                {
                    AlertView.showAlertView(title: errorTitle, message: apiResponseObject.Message)
                }
            }
        }
        else
        {
            AlertView.showNoInternetAlert()
            self.tableviewLeaveApproval.isHidden = true
            self.emptyStateLabel.text = "Please check your network connection"
        }
    
    }
    
    private func startLeavePedingApiCallForApproved()
    {
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: "Loading...")
            BL_DCR_Leave.sharedInstance.LeavePendingApproval(userCode: selectedUserCode, status: 2)
            { (apiResponseObject) in
                removeCustomActivityView()
                if apiResponseObject.Status == SERVER_SUCCESS_CODE
                {
                    
                    self.isLeaveAPI = false
                    self.emptyStateLabel.text = ""
                    self.tableviewLeaveApproval.isHidden = false
                    if apiResponseObject.list.count > 0
                    {
                        self.leaveApprovalList = []
                        
                        for obj in apiResponseObject.list{
                            
                            let dict = obj as! [String:Any]
                            let responseObj = LeaveApprovalModel()
                            // let responseLeaveObj = LeaveAttachmentData()
                            responseObj.Attachment_Id = dict["Attachment_Id"] as? Int ?? 0
                            responseObj.From_Date = dict["From_Date"] as? String ?? ""
                            responseObj.To_Date = dict["To_Date"] as? String ?? ""
                            responseObj.Leave_Type_Name = dict["Leave_Type_Name"] as? String ?? ""
                            responseObj.Reason = dict["Reason"] as? String ?? ""
                            responseObj.DCR_ENTRY_UNAPPROVED_ACTIVITY_LOCK = dict["DCR_ENTRY_UNAPPROVED_ACTIVITY_LOCK"] as? String ?? ""
                            responseObj.Status = dict["Status"] as? String ?? ""
                            responseObj.leaveUnapprovedReason = dict["Unapprove_Reason"] as? String ?? ""
                            
                            let iceQueAnsData = obj as! NSDictionary
                            let iceAnsList = iceQueAnsData.value(forKey: "lstLeaveAttachmentData") as! NSArray
                            //  var answerList :[LeaveAttachmentData] = []
                            self.answerList = []
                            for iceAnswerObj in  iceAnsList
                            {
                                let iceAnsObj = LeaveAttachmentData()
                                let iceAnsData = iceAnswerObj as! NSDictionary
                                
                                iceAnsObj.Attachment_Id = iceAnsData.value(forKey: "Attachment_Id") as! Int
                                iceAnsObj.Attachment_Url = iceAnsData.value(forKey: "Attachment_Url") as! String
                                iceAnsObj.Attachment_Name = iceAnsData.value(forKey: "Attachment_Name") as! String
                                
                                self.answerList.append(iceAnsObj)
                            }
                            
                            responseObj.answerList = self.answerList
                            
                            self.leaveApprovalList.append(responseObj)
                        }
                        self.tableviewLeaveApproval.isHidden = false
                        self.endRefresh()
                        self.tableviewLeaveApproval.reloadData()
                    }
                    else
                    {
                        self.endRefresh()
                        self.tableviewLeaveApproval.isHidden = true
                        self.emptyStateLabel.text = "No Leave data found"
                    }
                    
                }
                else
                {
                    AlertView.showAlertView(title: errorTitle, message: apiResponseObject.Message)
                }
            }
            
        }
        else
        {
            AlertView.showNoInternetAlert()
            self.tableviewLeaveApproval.isHidden = true
            self.emptyStateLabel.text = "Please check your network connection"
        }
    }

    
    private func pullDownRefresh()
    {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        tableviewLeaveApproval.addSubview(refreshControl)
    }
    
    func endRefresh()
    {
        if self.refreshControl.isRefreshing
        {
            refreshControl.endRefreshing()
        }
    }
    
    @objc func refresh()
    {
        if(self.isLeaveAPI == true)
        {
            self.startLeavePedingApiCall()
        }
        else
        {
            self.startLeavePedingApiCallForApproved()
        }
        
    }
    //MARK:-  Tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaveApprovalList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! UITableViewCell
        let leaveObj = self.leaveApprovalList[indexPath.row]
        let lblFromToDate = cell.viewWithTag(1) as! UILabel
        let lblLeaveType = cell.viewWithTag(2) as! UILabel
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let fromDate = inputFormatter.date(from: leaveObj.From_Date!)
        inputFormatter.dateFormat = "dd/MM/yyyy"
        let resultFromString = inputFormatter.string(from: fromDate!)
        
        let inputFormatterToDate = DateFormatter()
        inputFormatterToDate.dateFormat = "yyyy-MM-dd"
        let toDate = inputFormatterToDate.date(from: leaveObj.To_Date!)
        inputFormatterToDate.dateFormat = "dd/MM/yyyy"
        let resultToString = inputFormatterToDate.string(from: toDate!)
        
        
        lblFromToDate.text = resultFromString + " - " + resultToString
        lblLeaveType.text = leaveObj.Leave_Type_Name
        
        let btnCheck = cell.viewWithTag(3) as! UIButton
        btnCheck.addTarget(self, action: #selector(ActionCheckMark), for: .touchUpInside)
        
        if leaveObj.DCR_ENTRY_UNAPPROVED_ACTIVITY_LOCK == "ENABLED"
        {
            btnCheck.isHidden = false
        }
        else
        {
            btnCheck.isHidden = true
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sb = UIStoryboard(name:ApprovalSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "LeaveApproveRejectVCID") as! LeaveApproveAndRejectViewController
        //vc.navigationTitle = ""
        //let leaveValueObj = self.leaveApprovalList[indexPath.row].answerList.enumerated()
        let leaveObj = leaveApprovalList[indexPath.row]
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let fromDate = inputFormatter.date(from: leaveObj.From_Date!)
        inputFormatter.dateFormat = "dd/MM/yyyy"
        let resultFromString = inputFormatter.string(from: fromDate!)
        
        let inputFormatterToDate = DateFormatter()
        inputFormatterToDate.dateFormat = "yyyy-MM-dd"
        let toDate = inputFormatterToDate.date(from: leaveObj.To_Date!)
        inputFormatterToDate.dateFormat = "dd/MM/yyyy"
        let resultToString = inputFormatterToDate.string(from: toDate!)
        
        vc.leaveEntryDate = resultFromString + " - " + resultToString
        vc.leaveType = leaveObj.Leave_Type_Name
        vc.leaveReason = leaveObj.Reason
        vc.leaveUnapprovedReason =  leaveObj.leaveUnapprovedReason
        vc.selectedUserName = selectedName + "(" + userTypeName + ")"
        vc.arrAttachmentList = (leaveObj.answerList as NSArray?)!
        vc.userLeaveObj = leaveObj
        vc.selectedUserCode = selectedUserCode
        vc.selectedRegionCode = selectedRegionCode

        if(self.isLeaveAPI == true)
        {
            vc.appliedAndApproved = true
        }
        else
        {
            vc.appliedAndApproved = false
        }
        
        
        UserDefaults.standard.set("0", forKey: "IsFromLeaveApprovalCheckBox")
        UserDefaults.standard.synchronize()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 59
    }
    
    //MARK:- Action
    @objc private func ActionCheckMark(){
        
    }
    
    // Mark :- Action
    
    @objc private func ActionRightBarButton(){
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let Applied: UIAlertAction = UIAlertAction(title: "Applied", style: .default) { action -> Void in
         self.startLeavePedingApiCall()

            UserDefaults.standard.set("0", forKey: "IsAppliedAndApproved")
            UserDefaults.standard.synchronize()
            //self.navigationItem.title = self.selectedName + "(" + self.userTypeName + ")" + "-" + "Applied"
            self.navigationItem.title = "Applied"
        }
        let Approved: UIAlertAction = UIAlertAction(title: "Approved", style: .default) { action -> Void in
           self.startLeavePedingApiCallForApproved()
            UserDefaults.standard.set("", forKey: "IsAppliedAndApproved")
            UserDefaults.standard.synchronize()
            //self.navigationItem.title = self.selectedName + "(" + self.userTypeName + ")" + "-" + "Approved"
             self.navigationItem.title = "Approved"
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        actionSheetController.addAction(Applied)
        actionSheetController.addAction(Approved)
        actionSheetController.addAction(cancelAction)
        
        present(actionSheetController, animated: true, completion: nil)

    }
    
}

class LeaveApprovalModel:NSObject
{
    var Attachment_Id: Int!
    var From_Date: String?
    var To_Date: String?
    var Leave_Type_Name: String?
    var Reason: String?
    var DCR_ENTRY_UNAPPROVED_ACTIVITY_LOCK: String?
    var Status: String?
    var leaveUnapprovedReason: String?
    // var lstLeaveAttachmentData = LeaveAttachmentData()
    var answerList : [LeaveAttachmentData]!
    var IsChecked : Int!
    var approvalStatus: Int!
    var userCode: String?
    var regionCode: String?
}

class LeaveAttachmentData:NSObject
{
    var Attachment_Id: Int!
    var Attachment_Url: String?
    var Attachment_Name: String?
}





