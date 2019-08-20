//
//  ExpenseApprovalViewController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 12/04/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class ExpenseApprovalViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
    
    @IBOutlet weak var retryBut: UIButton!
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet var paymentButton: [UIButton]!
    @IBOutlet weak var approveButton: UIButton!
    
    
    var deleteBtn : UIBarButtonItem!
    var cancelBtn : UIBarButtonItem!
    var islongPress : Bool = false
    var menuId = Int()
    var expenseDataList: [ExpenseApproval] = []
    var tempExpenseDataList: [ExpenseApproval] = []
    
    var statusCode = String()
    var approveStatusCode = String()
    var unapproveStatusCode = String()
    
    var paymentPickerValue = ["Cheque","Cash","Others"]
    var selectedIndex = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        longPress()
        self.emptyStateLabel.isHidden = true
        self.retryBut.isHidden = true
        addBackButtonView()
        self.tableView.tableFooterView = UIView()
        paymentView.layer.cornerRadius = 0
        paymentView.layer.masksToBounds = true
        
        self.title = "Expense Approval"
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.paymentView.isHidden = true
        self.addRefreshBtn()
        getExpenceDataList()
       
        
    }
    @IBAction func paymentSelectBut(_ sender: UIButton) {
        selectedIndex = sender.tag - 1
        for button in paymentButton {
            if button.tag == sender.tag {
                button.backgroundColor = UIColor.lightGray
            } else {
                button.backgroundColor = UIColor.white
            }
        }
    }
    @IBAction func paymentApproveAction(_ sender: UIButton) {
        self.approveAll(paymentMode: paymentPickerValue[selectedIndex])
        self.paymentView.zoomOut(duration: 0.2)
        self.paymentView.isHidden = true
        islongPress = false
        
    }
    @IBAction func paymentCancel(_ sender: UIButton) {
        self.paymentView.zoomOut(duration: 0.2)
        self.paymentView.isHidden = true
         cancelAction()
        
    }
    @IBAction func retryAction(_ sender: UIButton) {
        self.getExpenceDataList()
    }
    
    func longPress()
    {
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap(_:)))
        self.tableView.addGestureRecognizer(longGesture)
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
                if(Int(expenseDataList[indexPath.row].Max_Order) == Int(expenseDataList[indexPath.row].Move_Order))
                {
                    expenseDataList[indexPath.row].isSelected = true
                    tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                    self.deleteButAction()
                }
                else
                {
                    islongPress = false
                }
            }
        }
    }
    
    func deleteButAction()
    {
        self.navigationItem.rightBarButtonItems = [deleteBtn]
        self.navigationItem.leftBarButtonItems = [cancelBtn]
    }
    
    func addRefreshBtn()
    {
        deleteBtn = UIBarButtonItem(title: "Approve", style: .plain, target: self, action: #selector(deleteAction))
        cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAction))
    }
    
    @objc func deleteAction()
    {
        islongPress = false
        self.navigationItem.rightBarButtonItems = nil
        self.navigationItem.leftBarButtonItems = nil
        addBackButtonView()
        self.paymentView.isHidden = false
        self.paymentView.zoomIn(duration: 0.2)
       
    }
    
    @objc func cancelAction()
    {
        islongPress = false
        for expenseData in self.expenseDataList
        {
            expenseData.isSelected = false
            
        }
        self.tableView.reloadData()
        self.navigationItem.rightBarButtonItem = nil
        addBackButtonView()
    }
    
    func approveAll(paymentMode:String)
    {
        
            let postData = NSMutableArray()
            for expenseData in self.expenseDataList
            {
                if(expenseData.isSelected)
                {
                    let dict = ["Claim_Code":expenseData.Claim_Code,"User_Code":getUserName(),"Request_Name":expenseData.Request_Name,"Favoring_User_Code":expenseData.Favouring_User_Code,"Status_Code":expenseData.Status_Code,"Move_Order_No":expenseData.Move_Order,"Cycle_Code":expenseData.Cylce_Code,"Request_Code":expenseData.Request_Code,"User_Type_Name":expenseData.User_Type_Name,"DateTo":expenseData.Date_To,"ExpenseMode":expenseData.Expense_Claim_Screen_Mode,"Current_Status_Code":approveStatusCode,"Order_No":expenseData.Move_Order] as [String : Any]
                    postData.add(dict)
                }
                
            }
        if(checkInternetConnectivity())
        {
            showCustomActivityIndicatorView(loadingText: "Approve Expense data...")
            WebServiceHelper.sharedInstance.bulkApproveExpenseClaim(paymentMode:paymentMode,postData: postData, completion: { (apiObj) in
                if(apiObj.Status == SERVER_SUCCESS_CODE)
                {
                    removeCustomActivityView()
                    self.getExpenceDataList()
                }
            })
        }
        else
        {
            AlertView.showAlertView(title: internetOfflineTitle, message: internetOfflineMessage, viewController: self)
        }
    }
    func getExpenceDataList()
    {
        if(checkInternetConnectivity())
        {
            showCustomActivityIndicatorView(loadingText: "Loading Expense data...")
            WebServiceHelper.sharedInstance.getExpenseApproval(completion: { (apiObj) in
                if(apiObj.Status == SERVER_SUCCESS_CODE)
                {
                    removeCustomActivityView()
                    if(apiObj.list.count > 0)
                    {
                        let getExpenseList = apiObj.list as! [NSDictionary]
                        self.expenseDataList = []
                        
                        let buttonStatus = getExpenseList[0].value(forKey: "lstStatusbtn") as! NSArray
                        if(buttonStatus.count == 2)
                        {
                            let approveButName = (buttonStatus[0] as AnyObject).value(forKey: "Status_Name")
                            self.approveStatusCode = (buttonStatus[0] as AnyObject).value(forKey: "Status_Code") as! String
                            self.unapproveStatusCode = (buttonStatus[1] as AnyObject).value(forKey: "Status_Code") as! String
                            self.approveButton.setTitle(approveButName as? String, for: .normal)
                           
                        }
                        else if(buttonStatus.count == 1)
                        {
                            let approveButName = buttonStatus[0] as! NSDictionary
                            self.approveButton.setTitle(approveButName.value(forKey: "Status_Name") as? String, for: .normal)
                            self.approveStatusCode = (buttonStatus[0] as AnyObject).value(forKey: "Status_Code") as! String
                            
                        }
                        
                        for expenseObj in getExpenseList
                        {
                            let expenseData = ExpenseApproval()
                            
                            expenseData.Date_To = checkNullAndNilValueForString(stringData: expenseObj.value(forKey: "Date_To") as? String)
                            expenseData.Status_Code = checkNullAndNilValueForString(stringData:expenseObj.value(forKey: "Status_Code") as? String)
                            if(expenseObj.value(forKey: "Approved_Amount") != nil)
                            {
                                if let approvedAmount = expenseObj.value(forKey: "Approved_Amount") as? Float
                                {
                                    expenseData.Approved_Amount = approvedAmount
                                }
                                else if let approvedAmount = expenseObj.value(forKey: "Approved_Amount") as? Double
                                {
                                    expenseData.Approved_Amount = Float(approvedAmount)
                                }
                                //expenseData.Approved_Amount = expenseObj.value(forKey: "Approved_Amount") as! Float
                            }
                            else
                            {
                                expenseData.Approved_Amount = 0
                            }
                            expenseData.Request_Name = checkNullAndNilValueForString(stringData:expenseObj.value(forKey: "Request_Name") as? String)
                            expenseData.Region_Name = checkNullAndNilValueForString(stringData:expenseObj.value(forKey: "Region_Name") as? String)
                            expenseData.Entered_DateTime = checkNullAndNilValueForString(stringData:expenseObj.value(forKey: "Entered_DateTime") as? String)
                            expenseData.User_Code = checkNullAndNilValueForString(stringData:expenseObj.value(forKey: "User_Code") as? String)
                            expenseData.Favouring_User_Code = checkNullAndNilValueForString(stringData:expenseObj.value(forKey: "Favouring_User_Code") as? String)
                            if(expenseObj.value(forKey: "Order_No") != nil)
                            {
                                expenseData.Order_No = expenseObj.value(forKey: "Order_No") as! Int
                            }
                            else
                            {
                                expenseData.Order_No = 0
                            }
                           
                           expenseData.Max_Order = expenseObj.value(forKey: "Next_Move_Order") as! String
                            expenseData.Expense_Claim_Screen_Mode = checkNullAndNilValueForString(stringData:expenseObj.value(forKey: "Expense_Claim_Screen_Mode") as? String)
                            expenseData.Cylce_Code = checkNullAndNilValueForString(stringData:expenseObj.value(forKey: "Cylce_Code") as? String)
                            expenseData.User_Name = checkNullAndNilValueForString(stringData:expenseObj.value(forKey: "User_Name") as? String)
                            expenseData.Move_Order = checkNullAndNilValueForString(stringData:expenseObj.value(forKey: "Move_Order") as? String)
                            expenseData.Remarks_By_Admin = checkNullAndNilValueForString(stringData:expenseObj.value(forKey: "Remarks_By_Admin") as? String)
                            expenseData.Request_Entity = checkNullAndNilValueForString(stringData:expenseObj.value(forKey: "Request_Entity") as? String)
                            expenseData.Status_Owner_Type = checkNullAndNilValueForString(stringData:expenseObj.value(forKey: "Status_Owner_Type") as? String)
                            expenseData.Remarks_By_User = checkNullAndNilValueForString(stringData:expenseObj.value(forKey: "Remarks_By_User") as? String)
                            expenseData.User_Type_Name = checkNullAndNilValueForString(stringData:expenseObj.value(forKey: "User_Type_Name") as? String)
                            expenseData.Request_Code = checkNullAndNilValueForString(stringData:expenseObj.value(forKey: "Request_Code") as? String)
                            expenseData.Date_From = checkNullAndNilValueForString(stringData:expenseObj.value(forKey: "Date_From") as? String)
                            if(expenseObj.value(forKey: "Remarks_Count") != nil)
                            {
                                expenseData.Remarks_Count = expenseObj.value(forKey: "Remarks_Count") as! Int
                            }
                            else
                            {
                                expenseData.Remarks_Count = 0
                            }
                            if(expenseObj.value(forKey: "Attachment_Count") != nil)
                            {
                                expenseData.Attachment_Count = expenseObj.value(forKey: "Attachment_Count") as! Int
                            }
                            else
                            {
                                expenseData.Attachment_Count = 0
                            }
                            expenseData.Claim_Code = checkNullAndNilValueForString(stringData:expenseObj.value(forKey: "Claim_Code") as? String)
                            if(expenseObj.value(forKey: "Actual_Amount") != nil)
                            {
                                if let actualAmount = expenseObj.value(forKey: "Actual_Amount") as? Float
                                {
                                    expenseData.Actual_Amount = actualAmount
                                }
                                else if let actualAmount = expenseObj.value(forKey: "Actual_Amount") as? Double
                                {
                                    expenseData.Actual_Amount = Float(actualAmount)
                                }
//                                expenseData.Actual_Amount = expenseObj.value(forKey: "Actual_Amount") as! Float
                            }
                            else
                            {
                                expenseData.Actual_Amount = 0
                            }
                            expenseData.Status_Name = checkNullAndNilValueForString(stringData:expenseObj.value(forKey: "Status_Name") as? String)
                            
                            self.expenseDataList.append(expenseData)
                        }
                        self.tempExpenseDataList = self.expenseDataList
                        self.retryBut.isHidden = true
                        self.emptyStateLabel.isHidden = true
                        self.tableView.isHidden = false
                       // BL_ExpenseClaim.sharedInstance.expensePendingList = self.expenseDataList
                        self.tableView.reloadData()
                    }
                    else
                    {
                        //show empty state as no data
                        self.retryBut.isHidden = true
                        self.emptyStateLabel.isHidden = false
                        self.tableView.isHidden = true
                        self.emptyStateLabel.text = "No Pending claim approvals"
                    }
                }
                else
                {
                    //show empty state
                    //alert for error
                    //Sorry unable to get pending claim approvals
                    self.retryBut.isHidden = true
                    self.emptyStateLabel.isHidden = false
                    self.tableView.isHidden = true
                    self.emptyStateLabel.text = "Sorry unable to get pending claim approvals"
                }
            })
        }
        else
        {
            //show empty state
            //No Internet connection
            //retry button
            self.retryBut.isHidden = false
            self.emptyStateLabel.isHidden = false
            self.tableView.isHidden = true
            self.emptyStateLabel.text = "No Internet connection"
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenseDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseApprovalViewControllerID") as! ExpenseApprovalTableViewCell
        let expenseData = self.expenseDataList[indexPath.row]
        cell.actualAmountLbl.text = "\(expenseData.Actual_Amount!)"
        cell.appliedAmountLbl.text = "\(expenseData.Approved_Amount!)"
        if(expenseData.Approved_Amount > 0)
        {
           cell.appliedAmountLbl.textColor = UIColor.black
        }
        else
        {
            cell.appliedAmountLbl.textColor = UIColor.gray
        }
        cell.requestIDLbl.text = expenseData.Claim_Code
        cell.levelNumLbl.text = "Level-\(expenseData.Order_No!)"
        let dateValue = convertDateIntoString(dateString: expenseData.Entered_DateTime)
        let appFormatModifiyDate = convertDateIntoString(date: dateValue)
        cell.dateLbl.text = appFormatModifiyDate
        cell.statusLbl.text = expenseData.Status_Name
        cell.userNameRoleLbl.text = expenseData.User_Name + "(" + expenseData.User_Type_Name + ")"
        cell.locationLbl.text = expenseData.Region_Name
        let dateFromValue = convertDateIntoString(dateString: expenseData.Date_From)
        let dateToValue = convertDateIntoString(dateString: expenseData.Date_To)
        let appFormatModifiyFromDate = convertDateIntoString(date: dateFromValue)
        let appFormatModifiyToDate = convertDateIntoString(date: dateToValue)
        cell.fromToLbl.text = appFormatModifiyFromDate + " to " + appFormatModifiyToDate
        cell.showAttachmentBut.tag = indexPath.row
        cell.showAttachmentBut.addTarget(self, action: #selector(navigatoToExpenseAttachment(sender:)), for: .touchUpInside)
        if(expenseData.Attachment_Count > 0)
        {
            cell.attachmentView.isHidden = false
            cell.attachmentCountLbl.text = "\(expenseData.Attachment_Count!)"
        }
        else
        {
            cell.attachmentView.isHidden = true
        }
        if(expenseData.isSelected)
        {
            cell.accessoryType = .checkmark
        }
        else
        {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(!islongPress)
        {
            
            let expenseData = self.expenseDataList[indexPath.row]
            let storyBoard = UIStoryboard(name: ApprovalSb, bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ExpenseClaimDetailControllerID") as! ExpenseClaimDetailController
            vc.claimCode = expenseData.Claim_Code
            vc.userCode = expenseData.Favouring_User_Code
            vc.fromDate = expenseData.Date_From
            vc.toDate = expenseData.Date_To
            vc.cycleCode = expenseData.Cylce_Code
            vc.moveOrderCode = expenseData.Move_Order
            vc.expenseMode = expenseData.Expense_Claim_Screen_Mode
            vc.expenseApprovalData = expenseData
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            if(Int(expenseDataList[indexPath.row].Max_Order) == Int(expenseDataList[indexPath.row].Move_Order))
            {
                let expenseData = self.expenseDataList[indexPath.row]
                if(expenseData.isSelected == false)
                {
                    self.expenseDataList[indexPath.row].isSelected = true
                }
                else if(expenseData.isSelected == true)
                {
                    self.expenseDataList[indexPath.row].isSelected = false
                }
                tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
            }
        }
        
    }
    
    @objc func navigatoToExpenseAttachment(sender:UIButton)
    {
        let expenseData = self.expenseDataList[sender.tag]
        let storyBoard = UIStoryboard(name: ApprovalSb, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ExpenseAttachmentViewControllerID") as! ExpenseAttachmentListController
        vc.claimCode = expenseData.Claim_Code
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //Mark:- Back Button
//    private func addBackButtonView()
//    {
//
//        let backbutton = UIButton(type: .custom)
//        backbutton.setImage(UIImage(named: "navigation-arrow"), for: .normal) // Image can be downloaded from here below link
//        backbutton.setTitle("Back", for: .normal)
//        backbutton.setTitleColor(UIColor.white, for: .normal) // You can change the TitleColor
//        backbutton.addTarget(self, action: #selector(ExpenseApprovalViewController.backAction), for: .touchUpInside)
//
//       // self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
//    }
//
//    @objc func backAction() -> Void {
//        self.navigationController?.popViewController(animated: true)
//    }
    
    //MARK:-Search Bar Delegate
    
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
        self.expenseDataList = self.tempExpenseDataList
        
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if (searchBar.text?.count)! > 0
        {
            sortCurrentList(searchText: searchBar.text!)
        }
        else if (searchBar.text?.count == 0 || searchText == EMPTY)
        {
            
            self.expenseDataList = self.tempExpenseDataList
            self.retryBut.isHidden = true
            self.emptyStateLabel.isHidden = true
            self.tableView.isHidden = false
            self.emptyStateLabel.text = ""
            tableView.reloadData()
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func sortCurrentList(searchText:String)
    {
        
        let filteredData = self.tempExpenseDataList.filter {
            (obj) -> Bool in
            let lowerCaseText = searchText.lowercased()
            let empName  = (obj.Claim_Code).lowercased()
            let empCode = (obj.Cylce_Code).lowercased()
            let speciality = (obj.Expense_Claim_Screen_Mode).lowercased()
            let category = (obj.Region_Name).lowercased()
            let mdlNum = (obj.Status_Name).lowercased()
            if (empName.contains(lowerCaseText)) || (empCode.contains(lowerCaseText)) || (speciality.contains(lowerCaseText)) || (category.contains(lowerCaseText) || (mdlNum.contains(lowerCaseText)))
            {
                return true
            }
            
            return false
        }
        self.expenseDataList = filteredData
        tableView.reloadData()
        self.emptyStateLabel.text = "Sorry no pending claim approvals"
        if(self.expenseDataList.count>0)
        {
            self.retryBut.isHidden = true
            self.emptyStateLabel.isHidden = true
            self.tableView.isHidden = false
            self.emptyStateLabel.text = "No Pending claim approvals"
            tableView.reloadData()
        }
        else
        {
            self.retryBut.isHidden = true
            self.emptyStateLabel.isHidden = false
            self.tableView.isHidden = true
            self.emptyStateLabel.text = "No Pending claim approvals"
            tableView.reloadData()
        }
        
    }

}
extension UIViewController {
    
    func addBackButtonView() {
//        let btnLeftMenu = UIButton(frame: CGRect(x: -30, y: 0, width: 30, height: 30))
//        let image = UIImage(named: "navigation-arrow");
//        btnLeftMenu.setImage(image, for: .normal)
//        btnLeftMenu.setTitle("   ", for: .normal);
//        btnLeftMenu.imageEdgeInsets = UIEdgeInsetsMake(-12, 0, 0, 0);
//
//       // btnLeftMenu.sizeToFit()
//       // btnLeftMenu.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0);
//        btnLeftMenu.addTarget(self, action: #selector (backButtonClick(sender:)), for: .touchUpInside)
//        let barButton = UIBarButtonItem(customView: btnLeftMenu)
//        let leftSpacerBarButton = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//        leftSpacerBarButton.width = -50
//        //navigationItem.leftBarButtonItems = [leftSpacerBarButton, backBarItem]
//
//        self.navigationItem.leftBarButtonItems = [leftSpacerBarButton, barButton]
        
        
        let backButton = UIButton(type: UIButtonType.custom)
        
        backButton.addTarget(self, action: #selector(self.backButtonClick), for: UIControlEvents.touchUpInside)
        backButton.setImage(UIImage(named: "back-ic"), for: .normal)
        //backButton.setBackgroundImage(UIImage(named: "navigation-arrow"), for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.sizeToFit()
        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
    
    }
    
    @objc func backButtonClick(sender : UIButton) {
        self.navigationController?.popViewController(animated: true);
    }
}
extension UIView {
    
    /**
     Simply zooming in of a view: set view scale to 0 and zoom to Identity on 'duration' time interval.
     - parameter duration: animation duration
     */
    func zoomIn(duration: TimeInterval = 0.2) {
        self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            self.transform = CGAffineTransform.identity
        }) { (animationCompleted: Bool) -> Void in
        }
    }
    
    /**
     Simply zooming out of a view: set view scale to Identity and zoom out to 0 on 'duration' time interval.
     - parameter duration: animation duration
     */
    func zoomOut(duration: TimeInterval = 0.2) {
        self.transform = CGAffineTransform.identity
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        }) { (animationCompleted: Bool) -> Void in
        }
    }
}

