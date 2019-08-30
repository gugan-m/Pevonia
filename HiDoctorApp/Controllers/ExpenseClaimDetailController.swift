//
//  ExpenseClaimDetailController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 18/04/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class ExpenseClaimDetailController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {


    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var employeeName: UILabel!
    @IBOutlet weak var employeeDetail: UILabel!
    @IBOutlet weak var FromToLbl: UILabel!
    @IBOutlet weak var levelDetail: UILabel!
    @IBOutlet weak var approveBut: UIButton!
    @IBOutlet weak var unApproveBut: UIButton!
    
    var claimCode = String()
    var userCode = String()
    var fromDate = String()
    var toDate = String()
    var cycleCode = String()
    var moveOrderCode = String()
    var expenseMode = String()
    var expenseApprovalData = ExpenseApproval()
    var expenseDetailList:[ExpenseDetailSectionList] = []
    var expenseAttachmentList : [ExpenseAttachmentList] = []
    var expenseDCRDetailList : [ExpenseViewDCRWiseDetailList] = []
    var paymentRemark = String()
    var approvalRemarks = String()
    var paymentMode = String()
    var orderNo = String()
    let picker = UIPickerView()
    var paymentPickerValue = ["Cheque or DD","Cash","Others"]
     var selectedIndex = Int()
     var doneToolbar = UIToolbar()
    var statusCode = String()
    var approveStatusCode = String()
    var unapproveStatusCode = String()
    var approveMoveOrder = String()
    var unapproveMoveOrder = String()
    var otherDeduction = Float()
    var doneButtonTouched = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButtonView()
        self.title = "Expense Detail"
        NotificationCenter.default.addObserver(self, selector: #selector(ActivityListRemarkController.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ActivityListRemarkController.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
      
        self.hideKeyboardWhenTappedAround()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.picker.delegate = self
        
        let dateFromValue = convertDateIntoString(dateString: expenseApprovalData.Date_From)
        let dateToValue = convertDateIntoString(dateString: expenseApprovalData.Date_To)
        let appFormatModifiyFromDate = convertDateIntoString(date: dateFromValue)
        let appFormatModifiyToDate = convertDateIntoString(date: dateToValue)
        FromToLbl.text = appFormatModifiyFromDate + " to " + appFormatModifiyToDate
        
        employeeDetail.text = expenseApprovalData.User_Type_Name + " | " + expenseApprovalData.Region_Name
        employeeName.text = expenseApprovalData.User_Name
        levelDetail.text = "Level \(expenseApprovalData.Order_No!) Approval Stage"
        BL_ExpenseClaim.sharedInstance.otherDeduction = 0.0
        getExpenseviewDetailDcrWise()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.expenseDetailList = BL_ExpenseClaim.sharedInstance.expenseDetailSectionList
        
        if(self.expenseDetailList.count > 0)
        {
            let expenseDCRWiseData = self.expenseDetailList[1].rowValueList as! [ExpenseClaimTypeList]
            let expenseAdditionalData = self.expenseDetailList[3].rowValueList as! [ExpenseClaimTypeList]
            let expenseDCRWiseDataList = BL_ExpenseClaim.sharedInstance.expenseDCRDetailList
            let expenseAdditionalList = BL_ExpenseClaim.sharedInstance.expenseAdditionalDetailList
            var overAllDeduction = Float()
            var dcrDeduction = Float()
            
            for expenseData in expenseDCRWiseData
            {
                let filterValue = expenseDCRWiseDataList.filter
                {
                    $0.Expense_Type_Code == expenseData.Expense_Type_Code
                        //&& $0.isEdited == true
                }
                let filterValue1 = expenseAdditionalList.filter
                {
                    $0.Expense_Type_Code == expenseData.Expense_Type_Code
                    //&& $0.isEdited == true
                }
                var totalValue = Float()
                var aditionalTotalValue = Float()
                
                for filterData in filterValue
                {
                    totalValue += filterData.Deduction_Amount
                }
                for filterData in filterValue1
                {
                    aditionalTotalValue += filterData.Deduction_Amount
                }
                
                if(filterValue1.count > 0)
                {
                    expenseData.Total_Deduction = aditionalTotalValue
                }
                else
                {
                    expenseData.Total_Deduction = totalValue
                }
                overAllDeduction += totalValue
                let dcrAddDec = totalValue + aditionalTotalValue
                dcrDeduction += dcrAddDec
            }
//            let claimDetail = BL_ExpenseClaim.sharedInstance.expenseDetailSectionList[2].rowValueList as![ExpenseClaimDetail]
//             claimDetail[2].value = "\(overAllDeduction)"
//            //let deductionAmount = Float(claimDetail[2].value)! + overAllDeduction
//            let intialTotalDeduction = 0
//            let claimedAmount = Float(claimDetail[1].value)
//          //  claimDetail[2].value = "\(intialTotalDeduction + overAllDeduction)"
//            claimDetail[3].value = "\(claimedAmount! - Float(claimDetail[2].value)!)"
            
            for expenseData in expenseAdditionalData
            {
                let filterValue = expenseAdditionalList.filter
                {
                    $0.Expense_Type_Name == expenseData.Expense_Type_Name
                        //&& $0.isEdited == true
                }
                var totalValue = Float()
                
                for filterData in filterValue
                {
                    totalValue += filterData.Deduction_Amount
                }
                expenseData.Total_Deduction = totalValue
                overAllDeduction += totalValue
            }
            let claimDetail = BL_ExpenseClaim.sharedInstance.expenseDetailSectionList[2].rowValueList as![ExpenseClaimDetail]
            claimDetail[2].value = "\(overAllDeduction)"
            //let deductionAmount = Float(claimDetail[2].value)! + overAllDeduction
            let intialTotalDeduction = 0
            let claimedAmount = Float(claimDetail[1].value)
            //  claimDetail[2].value = "\(intialTotalDeduction + overAllDeduction)"
            claimDetail[3].value = "\(claimedAmount! - Float(claimDetail[2].value)!)"
            
            let otherClaimDetail = BL_ExpenseClaim.sharedInstance.expenseDetailSectionList[4].rowValueList as![ExpenseClaimDetail]
            let otherClaimedAmount = Float(otherClaimDetail[1].value)
            otherClaimDetail[2].value = "\(overAllDeduction + BL_ExpenseClaim.sharedInstance.otherDeduction)"
            otherClaimDetail[3].value = "\(otherClaimedAmount! - Float(otherClaimDetail[2].value)!)"
            
            self.tableView.reloadData();
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getExpenceDataList()
    {
        if(checkInternetConnectivity())
        {
            WebServiceHelper.sharedInstance.getExpenseApprovalAttachmentList(claimCode: claimCode, completion: { (apiObj) in
                if(apiObj.Status == SERVER_SUCCESS_CODE)
                {
                    if(apiObj.list.count > 0)
                    {
                        let getAttachExpenseList = apiObj.list as! [NSDictionary]
                        self.expenseAttachmentList = []
                        for expenseObj in getAttachExpenseList
                        {
                            let expenseData = ExpenseAttachmentList()
                            
                            expenseData.File_Name = checkNullAndNilValueForString(stringData: expenseObj.value(forKey: "File_Name") as? String)
                            expenseData.Claim_Code = checkNullAndNilValueForString(stringData:expenseObj.value(forKey: "Claim_Code") as? String)
                            expenseData.Image_File_Path = checkNullAndNilValueForString(stringData:expenseObj.value(forKey: "Image_File_Path") as? String)
                            self.expenseAttachmentList.append(expenseData)
                        }
                    }
                    WebServiceHelper.sharedInstance.getExpenseApprovalDetailList(userCode: self.userCode, claimCode: self.claimCode, fromDate: self.fromDate, toDate: self.toDate, cycleCode: self.cycleCode, moveOrder: self.moveOrderCode, completion: { (apiObj) in
                        if(apiObj.Status == SERVER_SUCCESS_CODE)
                        {
                            removeCustomActivityView()
                            self.expenseDetailList = []
                            var otherDetails : [ExpenseClaimDetail] = []
                            if(apiObj.list.count > 0)
                            {
                                
                                //lstAdditionalClaimSummary
                                //lstStatusbtn - Status_Code, Status_Name
                                
                                
                                
                                let expenseData = apiObj.list[0] as! NSDictionary
                                let montlyWiseList = expenseData.value(forKey: "lstMonthwiseExpense") as! NSDictionary
                               // let montlyWiseList = mothlyWise[0] as! NSDictionary
                                let section1 = expenseData.value(forKey: "lstExpenseUserDetails") as! NSArray
                                let section2 = expenseData.value(forKey: "lstExpenseTypeWiseAmount") as! NSArray
                                let section12 = expenseData.value(forKey: "lstAdditionalClaimSummary") as! NSArray
                                let section3 = expenseData.value(forKey: "lstClaimDetails") as! NSArray
                                let section4 = expenseData.value(forKey: "lstAdditionalClaimDetails") as! NSArray
                                let section5 = expenseData.value(forKey: "lstOtherDeduction") as! NSArray
                                let section6 = montlyWiseList.value(forKey: "lstMonthlySFCDetails") as! NSArray
                                let calandarField = montlyWiseList.value(forKey: "lstFieldCount") as! NSArray
                                let calandarAttendence = montlyWiseList.value(forKey: "lstAttendanceDays") as! NSArray
                                let calandarWeekend = montlyWiseList.value(forKey: "lstExpenseWeekendList") as! NSArray
                                let calandarHoliday = montlyWiseList.value(forKey: "lstHolidayList") as! NSArray
                                let section8 = montlyWiseList.value(forKey: "lstExpenseMonthwise") as! NSArray
                                let section9 = expenseData.value(forKey: "lstRemarks") as! NSArray
                                let section10 = expenseData.value(forKey: "lstStatushistory") as! NSArray
                                
                                let buttonStatus = expenseData.value(forKey: "lstStatusbtn") as! NSArray
                                if(buttonStatus.count == 2)
                                {
                                    let approveButName = (buttonStatus[0] as AnyObject).value(forKey: "Status_Name")
                                    let unApproveButName = (buttonStatus[1] as AnyObject).value(forKey: "Status_Name")
                                    self.approveStatusCode = (buttonStatus[0] as AnyObject).value(forKey: "Status_Code") as! String
                                    self.unapproveStatusCode = (buttonStatus[1] as AnyObject).value(forKey: "Status_Code") as! String
                                    self.approveMoveOrder = (buttonStatus[0] as AnyObject).value(forKey: "Move_Order") as! String
                                    self.unapproveMoveOrder = (buttonStatus[1] as AnyObject).value(forKey: "Move_Order") as! String
                                    self.approveBut.setTitle(approveButName as? String, for: .normal)
                                    self.unApproveBut.setTitle(unApproveButName as? String, for: .normal)
                                }
                                else if(buttonStatus.count == 1)
                                {
                                    let approveButName = buttonStatus[0] as! NSDictionary
                                    self.approveBut.setTitle(approveButName.value(forKey: "Status_Name") as? String, for: .normal)
                                    self.approveStatusCode = (buttonStatus[0] as AnyObject).value(forKey: "Status_Code") as! String
                                    self.approveMoveOrder = (buttonStatus[0] as AnyObject).value(forKey: "Move_Order") as! String
                                }
                                
                                
                                var expenseDetailobj = ExpenseDetailSectionList()
                                var otherDetailObj = ExpenseClaimDetail()
                                var expenseTypeObj = ExpenseClaimAdditionalTypeList()
                                var expenseTypeList : [ExpenseClaimAdditionalTypeList] = []
                                var expenseDcrTypeObj = ExpenseClaimTypeList()
                                var expenseDcrTypeList : [ExpenseClaimTypeList] = []
                                var expenseSFCObj = ExpenseClaimSFC()
                                var expenseSFCList : [ExpenseClaimSFC] = []
                                var expenseEligibilityObj = ExpenseClaimEligibility()
                                var expenseEligibilityList : [ExpenseClaimEligibility] = []
                                var expenseClaimRemarkObj = ExpenseRemarks()
                                var expenseClaimRemarkList : [ExpenseRemarks] = []
                                var expenseStatusHistoryObj = ExpenseStatusHistory()
                                var expenseStatusHistoryList:[ExpenseStatusHistory] = []
                                var calendarEventList = [NSArray]()
                                
                                calendarEventList.append(calandarField)
                                calendarEventList.append(calandarAttendence)
                                calendarEventList.append(calandarWeekend)
                                calendarEventList.append(calandarHoliday)
                                
                               otherDetailObj = ExpenseClaimDetail()
                                otherDetailObj.title = "Reporting Manager"
                                otherDetailObj.value = (section1[0] as AnyObject).value(forKey: "Reporting_Manager_Name") as! String
                                otherDetails.append(otherDetailObj)
                                
                                otherDetailObj = ExpenseClaimDetail()
                                otherDetailObj.title = "Reporting Region"
                                otherDetailObj.value = (section1[0] as AnyObject).value(forKey: "Reporting_Manager_Region_Name") as! String
                                 otherDetails.append(otherDetailObj)
                                
                               otherDetailObj = ExpenseClaimDetail()
                                otherDetailObj.title = "Bank Account No"
                                otherDetailObj.value = (section1[0] as AnyObject).value(forKey: "Acc_No") as! String
                                 otherDetails.append(otherDetailObj)
                                
                                otherDetailObj = ExpenseClaimDetail()
                                otherDetailObj.title = "Mobile No"
                                otherDetailObj.value = (section1[0] as AnyObject).value(forKey: "User_Mobile_Number") as! String
                                 otherDetails.append(otherDetailObj)
                                
                                //section 1 append
                                expenseDetailobj.sectioTitle = "Other Details"
                                expenseDetailobj.emptyMessage = ""
                                expenseDetailobj.isSectionVisible = true
                                expenseDetailobj.rowCount = otherDetails.count
                                expenseDetailobj.rowValueList = otherDetails as [Any]
                                expenseDetailobj.isVisible = true
                                expenseDetailobj.rowHeight = 32
                                
                                self.expenseDetailList.append(expenseDetailobj)
                                
                                
                                for expenseObj in section2
                                {
                                    expenseDcrTypeObj = ExpenseClaimTypeList()
                                    expenseDcrTypeObj.Expense_Type_Name = (expenseObj as AnyObject).value(forKey: "Expense_Type_Name") as! String
                                    expenseDcrTypeObj.Expense_Type_Code = (expenseObj as AnyObject).value(forKey: "Expense_Type_Code") as! String
                                    if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Expense_Amount") as? Float
                                    {
                                        expenseDcrTypeObj.Expense_Amount = expenseAmount
                                    }
                                    else if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Expense_Amount") as? Double
                                    {
                                        expenseDcrTypeObj.Expense_Amount = Float(expenseAmount)
                                    }
                                    //expenseDcrTypeObj.Expense_Amount = (expenseObj as AnyObject).value(forKey: "Expense_Amount") as! Float
                                    if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Approved_Amount") as? Float
                                    {
                                        expenseDcrTypeObj.Approved_Amount = expenseAmount
                                    }
                                    else if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Approved_Amount") as? Double
                                    {
                                        expenseDcrTypeObj.Approved_Amount = Float(expenseAmount)
                                    }
                                  //  expenseDcrTypeObj.Approved_Amount = (expenseObj as AnyObject).value(forKey: "Approved_Amount") as! Float
                                    if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Total_Deduction") as? Float
                                    {
                                        expenseDcrTypeObj.Total_Deduction = expenseAmount
                                    }
                                    else if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Total_Deduction") as? Double
                                    {
                                        expenseDcrTypeObj.Total_Deduction = Float(expenseAmount)
                                    }
                                   // expenseDcrTypeObj.Total_Deduction = (expenseObj as AnyObject).value(forKey: "Total_Deduction") as! Float
                                    
                                    expenseDcrTypeList.append(expenseDcrTypeObj)
                                }
                                
                                //section 2 append
                                expenseDetailobj = ExpenseDetailSectionList()
                                expenseDetailobj.sectioTitle = "Expense Type"
                                expenseDetailobj.emptyMessage = ""
                                expenseDetailobj.isSectionVisible = true
                                expenseDetailobj.rowCount = expenseDcrTypeList.count
                                expenseDetailobj.rowValueList = expenseDcrTypeList as [Any]
                                expenseDetailobj.isVisible = true
                                expenseDetailobj.rowHeight = 58
                                self.expenseDetailList.append(expenseDetailobj)
                                
                                otherDetails = []
                                otherDetailObj = ExpenseClaimDetail()
                                otherDetailObj.title = "Claim Id"
                                otherDetailObj.value = (section3[0] as AnyObject).value(forKey: "Claim_Code") as! String
                                otherDetails.append(otherDetailObj)
                                
                                
                                if let expenseAmount = (section3[0] as AnyObject).value(forKey: "Other_Deduction") as? Float
                                {
                                    BL_ExpenseClaim.sharedInstance.otherDeduction = expenseAmount
                                }
                                else if let expenseAmount = (section3[0] as AnyObject).value(forKey: "Other_Deduction") as? Double
                                {
                                    BL_ExpenseClaim.sharedInstance.otherDeduction = Float(expenseAmount)
                                }
                              //  BL_ExpenseClaim.sharedInstance.otherDeduction = (section3[0] as AnyObject).value(forKey: "Other_Deduction") as! Float
                                
                                if let expenseAmount = (section3[0] as AnyObject).value(forKey: "Other_Deduction") as? Float
                                {
                                    BL_ExpenseClaim.sharedInstance.tempOtherDeduction = expenseAmount
                                }
                                else if let expenseAmount = (section3[0] as AnyObject).value(forKey: "Other_Deduction") as? Double
                                {
                                    BL_ExpenseClaim.sharedInstance.tempOtherDeduction = Float(expenseAmount)
                                }
                            //    BL_ExpenseClaim.sharedInstance.tempOtherDeduction = (section3[0] as AnyObject).value(forKey: "Other_Deduction") as! Float

                                otherDetailObj = ExpenseClaimDetail()
                                otherDetailObj.title = "Claim Amount"
                                if let expenseAmount = (section3[0] as AnyObject).value(forKey: "Actual_Amount") as? Float
                                {
                                     otherDetailObj.value = "\(expenseAmount)"
                                }
                                else if let expenseAmount = (section3[0] as AnyObject).value(forKey: "Actual_Amount") as? Double
                                {
                                     otherDetailObj.value = "\(expenseAmount)"
                                }
                               // otherDetailObj.value = "\((section3[0] as AnyObject).value(forKey: "Actual_Amount") as! Float)"
                                otherDetails.append(otherDetailObj)

                                otherDetailObj = ExpenseClaimDetail()
                                otherDetailObj.title = "DVR + Addl Deduction"
                                
                                var totalDed = Float()
                                if let expenseAmount = (section3[0] as AnyObject).value(forKey: "Total_Deduction") as? Float
                                {
                                    totalDed = expenseAmount
                                }
                                else if let expenseAmount = (section3[0] as AnyObject).value(forKey: "Total_Deduction") as? Double
                                {
                                    totalDed = Float(expenseAmount)
                                }
                               // let totalDed = (section3[0] as AnyObject).value(forKey: "Total_Deduction") as! Float
                                
                                otherDetailObj.value = "\(totalDed - BL_ExpenseClaim.sharedInstance.otherDeduction)"
                                otherDetails.append(otherDetailObj)

                                
                                otherDetailObj = ExpenseClaimDetail()
                                otherDetailObj.title = "Approved Amount"
                                var approvedAmount = Float()
                                
                                if let expenseAmount = (section3[0] as AnyObject).value(forKey: "Approved_Amount") as? Float
                                {
                                    approvedAmount = expenseAmount
                                }
                                else if let expenseAmount = (section3[0] as AnyObject).value(forKey: "Approved_Amount") as? Double
                                {
                                    approvedAmount = Float(expenseAmount)
                                }
                                //let approvedAmount = (section3[0] as AnyObject).value(forKey: "Approved_Amount") as! Float
                                otherDetailObj.value = "\(approvedAmount + BL_ExpenseClaim.sharedInstance.otherDeduction)"
                                otherDetails.append(otherDetailObj)

                                //section 3 append
                                 expenseDetailobj = ExpenseDetailSectionList()
                                expenseDetailobj.sectioTitle = "DVR Claim Details"
                                expenseDetailobj.emptyMessage = ""
                                expenseDetailobj.isSectionVisible = true
                                expenseDetailobj.rowCount = otherDetails.count
                                expenseDetailobj.rowValueList = otherDetails as [Any]
                                expenseDetailobj.isVisible = true
                                expenseDetailobj.rowHeight = 32

                                self.expenseDetailList.append(expenseDetailobj)
                                
                                expenseDcrTypeList = []
                                for expenseObj in section12
                                {
                                    expenseDcrTypeObj = ExpenseClaimTypeList()
                                    expenseDcrTypeObj.Expense_Type_Name = (expenseObj as AnyObject).value(forKey: "Expense_Type_Name") as! String
                                    expenseDcrTypeObj.Expense_Type_Code = (expenseObj as AnyObject).value(forKey: "Expense_Type_Code") as! String
                                    if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Expense_Amount") as? Float
                                    {
                                        expenseDcrTypeObj.Expense_Amount = expenseAmount
                                    }
                                    else if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Expense_Amount") as? Double
                                    {
                                        expenseDcrTypeObj.Expense_Amount = Float(expenseAmount)
                                    }
                                  //  expenseDcrTypeObj.Expense_Amount = (expenseObj as AnyObject).value(forKey: "Expense_Amount") as! Float
                                    if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Approved_Amount") as? Float
                                    {
                                        expenseDcrTypeObj.Approved_Amount = expenseAmount
                                    }
                                    else if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Approved_Amount") as? Double
                                    {
                                        expenseDcrTypeObj.Approved_Amount = Float(expenseAmount)
                                    }
                                    //expenseDcrTypeObj.Approved_Amount = (expenseObj as AnyObject).value(forKey: "Approved_Amount") as! Float
                                    
                                    if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Deduction_Amount") as? Float
                                    {
                                        expenseDcrTypeObj.Total_Deduction = expenseAmount
                                    }
                                    else if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Deduction_Amount") as? Double
                                    {
                                        expenseDcrTypeObj.Total_Deduction = Float(expenseAmount)
                                    }
                                  //  expenseDcrTypeObj.Total_Deduction = (expenseObj as AnyObject).value(forKey: "Deduction_Amount") as! Float
                                    
                                    expenseDcrTypeList.append(expenseDcrTypeObj)
                                }
                                
                                for expenseObj in section4
                                {
                                    expenseTypeObj = ExpenseClaimAdditionalTypeList()
                                    expenseTypeObj.Dcr_Actual_Date = checkNullAndNilValueForString(stringData:(expenseObj as AnyObject).value(forKey: "Dcr_Actual_Date") as? String)
                                    expenseTypeObj.Category = checkNullAndNilValueForString(stringData:(expenseObj as AnyObject).value(forKey: "Category") as? String)
                                    expenseTypeObj.Dcr_Activity_Flag = checkNullAndNilValueForString(stringData:(expenseObj as AnyObject).value(forKey: "Dcr_Activity_Flag") as? String)
                                    expenseTypeObj.Claim_Detail_Code = checkNullAndNilValueForString(stringData:(expenseObj as AnyObject).value(forKey: "Claim_Detail_Code") as? String)
                                    expenseTypeObj.Expense_Type_Name = checkNullAndNilValueForString(stringData:(expenseObj as AnyObject).value(forKey: "Expense_Type_Name") as? String)
                                    
                                    if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Expense_Amount") as? Float
                                    {
                                        expenseTypeObj.Expense_Amount = expenseAmount
                                    }
                                    else if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Expense_Amount") as? Double
                                    {
                                        expenseTypeObj.Expense_Amount = Float(expenseAmount)
                                    }
                                     //expenseTypeObj.Expense_Amount = (expenseObj as AnyObject).value(forKey: "Expense_Amount") as! Float
                                    
                                    if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Approved_Amount") as? Float
                                    {
                                        expenseTypeObj.Approved_Amount = expenseAmount
                                    }
                                    else if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Approved_Amount") as? Double
                                    {
                                        expenseTypeObj.Approved_Amount = Float(expenseAmount)
                                    }
                                  //   expenseTypeObj.Approved_Amount = (expenseObj as AnyObject).value(forKey: "Approved_Amount") as! Float
                                    
                                    if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Deduction_Amount") as? Float
                                    {
                                        expenseTypeObj.Deduction_Amount = expenseAmount
                                    }
                                    else if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Deduction_Amount") as? Double
                                    {
                                        expenseTypeObj.Deduction_Amount = Float(expenseAmount)
                                    }
                                    // expenseTypeObj.Deduction_Amount = (expenseObj as AnyObject).value(forKey: "Deduction_Amount") as! Float
                                    
                                    if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Deduction_Amount") as? Float
                                    {
                                        expenseTypeObj.previousDeduction = expenseAmount
                                    }
                                    else if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Deduction_Amount") as? Double
                                    {
                                        expenseTypeObj.previousDeduction = Float(expenseAmount)
                                    }
                                  //  expenseTypeObj.previousDeduction = (expenseObj as AnyObject).value(forKey: "Deduction_Amount") as! Float
                                    expenseTypeObj.Remarks_By_User = checkNullAndNilValueForString(stringData:(expenseObj as AnyObject).value(forKey: "Remarks_By_User") as? String)
                                    expenseTypeObj.Managers_Approval_Remark = checkNullAndNilValueForString(stringData:(expenseObj as AnyObject).value(forKey: "Managers_Approval_Remark") as? String)
                                     expenseTypeObj.Favouring_User_Code = checkNullAndNilValueForString(stringData:(expenseObj as AnyObject).value(forKey: "Favouring_User_Code") as? String)
                                    expenseTypeObj.Expense_Type_Code = checkNullAndNilValueForString(stringData:(expenseObj as AnyObject).value(forKey: "Expense_Type_Code") as? String)
                                    expenseTypeObj.Bill_Number = checkNullAndNilValueForString(stringData: (expenseObj as AnyObject).value(forKey: "Bill_Number") as? String)
                                    expenseTypeList.append(expenseTypeObj)
                                    
                                }
                                BL_ExpenseClaim.sharedInstance.expenseAdditionalDetailList = expenseTypeList
                                
                                //section 4 append
                                expenseDetailobj = ExpenseDetailSectionList()
                                expenseDetailobj.sectioTitle = "Aditional Type"
                                expenseDetailobj.emptyMessage = ""
                                if(expenseTypeList.count > 0)
                                {
                                   expenseDetailobj.isSectionVisible = true
                                    expenseDetailobj.rowCount = expenseDcrTypeList.count
                                    expenseDetailobj.isVisible = true
                                }
                                else
                                {
                                    expenseDetailobj.isSectionVisible = false
                                    expenseDetailobj.rowCount = 0
                                    expenseDetailobj.isVisible = false
                                }
                                
                                
                                expenseDetailobj.rowValueList = expenseDcrTypeList as [Any]
                                expenseDetailobj.rowHeight = 58
                                self.expenseDetailList.append(expenseDetailobj)
                                
                                
                                otherDetails = []
                                otherDetailObj = ExpenseClaimDetail()
                                otherDetailObj.title = "Deduction"
                                otherDetailObj.value = "0.0"
                                otherDetails.append(otherDetailObj)
                                
                                otherDetailObj = ExpenseClaimDetail()
                                otherDetailObj.title = "Total Claimed"
                                if let expenseAmount = (section5[0] as AnyObject).value(forKey: "Actual_Amount") as? Float
                                {
                                   otherDetailObj.value = "\(expenseAmount)"
                                }
                                else if let expenseAmount = (section5[0] as AnyObject).value(forKey: "Actual_Amount")  as? Double
                                {
                                    otherDetailObj.value = "\(expenseAmount)"
                                }
                            //    otherDetailObj.value = "\((section5[0] as AnyObject).value(forKey: "Actual_Amount") as! Float)"
                                otherDetails.append(otherDetailObj)
                                
                                otherDetailObj = ExpenseClaimDetail()
                                otherDetailObj.title = "Total Deduction"
                                
                                var totalDeduction = Float()
                                if let expenseAmount = (section5[0] as AnyObject).value(forKey: "Total_Deduction") as? Float
                                {
                                    otherDetailObj.value = "\(expenseAmount)"
                                    BL_ExpenseClaim.sharedInstance.previousDeduction = expenseAmount
                                    totalDeduction = expenseAmount
                                }
                                else if let expenseAmount = (section5[0] as AnyObject).value(forKey: "Total_Deduction")  as? Double
                                {
                                    otherDetailObj.value = "\(expenseAmount)"
                                    BL_ExpenseClaim.sharedInstance.previousDeduction = Float(expenseAmount)
                                    totalDeduction = Float(expenseAmount)
                                }
                              //  otherDetailObj.value = "\((section5[0] as AnyObject).value(forKey: "Total_Deduction") as! Float)"
                              //  BL_ExpenseClaim.sharedInstance.previousDeduction = totalDeduction
                                otherDetails.append(otherDetailObj)
                                
                                otherDetailObj = ExpenseClaimDetail()
                                otherDetailObj.title = "Final Amount"
                                if let expenseAmount = (section5[0] as AnyObject).value(forKey: "Actual_Amount") as? Float
                                {
                                    otherDetailObj.value = "\(expenseAmount - totalDeduction)"
                                }
                                else if let expenseAmount = (section5[0] as AnyObject).value(forKey: "Actual_Amount")  as? Double
                                {
                                    otherDetailObj.value = "\(Float(expenseAmount) - totalDeduction)"
                                }
                               // let totalAmount = (section5[0] as AnyObject).value(forKey: "Actual_Amount") as! Float
                              //  otherDetailObj.value = "\(totalAmount - totalDeduction)"
                                otherDetails.append(otherDetailObj)
                                
                                //section 5 append
                                expenseDetailobj = ExpenseDetailSectionList()
                                expenseDetailobj.sectioTitle = "Other Deduction"
                                expenseDetailobj.emptyMessage = ""
                                expenseDetailobj.isSectionVisible = true
                                expenseDetailobj.rowCount = otherDetails.count
                                expenseDetailobj.rowValueList = otherDetails as [Any]
                                expenseDetailobj.isVisible = true
                                expenseDetailobj.rowHeight = 32
                                self.expenseDetailList.append(expenseDetailobj)
                                
                                
                                for expenseObj in section6
                                {
                                    
                                    expenseSFCObj = ExpenseClaimSFC()
                                    expenseSFCObj.SFC_Visit_Count = (expenseObj as AnyObject).value(forKey: "SFC_Visit_Count") as! Int
                                    expenseSFCObj.Distance = (expenseObj as AnyObject).value(forKey: "Distance") as! Int
                                        expenseSFCObj.Actual_Visit_Count = (expenseObj as AnyObject).value(forKey: "Actual_Visit_Count") as! Int
                                    expenseSFCObj.Category = checkNullAndNilValueForString(stringData: (expenseObj as AnyObject).value(forKey: "Category") as? String)
                                    expenseSFCObj.Distance_Fare_Code = checkNullAndNilValueForString(stringData: (expenseObj as AnyObject).value(forKey: "Distance_Fare_Code") as? String)
                                    expenseSFCObj.From_Place = checkNullAndNilValueForString(stringData: (expenseObj as AnyObject).value(forKey: "From_Place") as? String)
                                    expenseSFCObj.To_Place = checkNullAndNilValueForString(stringData: (expenseObj as AnyObject).value(forKey: "To_Place") as? String)
                                    expenseSFCObj.Sfc_Version_No = checkNullAndNilValueForString(stringData: (expenseObj as AnyObject).value(forKey: "Sfc_Version_No") as? String)
                                    expenseSFCObj.Trend = checkNullAndNilValueForString(stringData: (expenseObj as AnyObject).value(forKey: "Trend") as? String)
                                    expenseSFCObj.Region_Name = checkNullAndNilValueForString(stringData: (expenseObj as AnyObject).value(forKey: "Region_Name") as? String)
                                   
                                    
                                    expenseSFCList.append(expenseSFCObj)
                                }
                                
                                //section 6 append
                                expenseDetailobj = ExpenseDetailSectionList()
                                expenseDetailobj.sectioTitle = "Expense SFC"
                                expenseDetailobj.emptyMessage = ""
                                expenseDetailobj.isSectionVisible = false
                                expenseDetailobj.rowCount = 1
                                expenseDetailobj.rowValueList = expenseSFCList as [Any]
                                
                                if(self.expenseMode == "MONTHLY")
                                {
                                    expenseDetailobj.isVisible = true
                                }
                                else
                                {
                                    expenseDetailobj.isVisible = false
                                }
                                expenseDetailobj.rowHeight = 40
                                self.expenseDetailList.append(expenseDetailobj)
                                
                                //section 7 append
                                expenseDetailobj = ExpenseDetailSectionList()
                                expenseDetailobj.sectioTitle = "Expense Calendar"
                                expenseDetailobj.emptyMessage = ""
                                expenseDetailobj.isSectionVisible = false
                                expenseDetailobj.rowCount = 1
                                expenseDetailobj.rowValueList = calendarEventList as [Any]
                                if(self.expenseMode == "MONTHLY")
                                {
                                    expenseDetailobj.isVisible = true
                                }
                                else
                                {
                                    expenseDetailobj.isVisible = false
                                }
                                expenseDetailobj.rowHeight = 40
                                self.expenseDetailList.append(expenseDetailobj)
                                
                                
                                for expenseObj in section8
                                {
                                    expenseEligibilityObj = ExpenseClaimEligibility()
                                    expenseEligibilityObj.Expense_Mode = (expenseObj as AnyObject).value(forKey: "Expense_Mode") as! String
                                    if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Eligibility_Amount") as? Float
                                    {
                                        expenseEligibilityObj.Eligibility_Amount = expenseAmount
                                    }
                                    else if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Eligibility_Amount")  as? Double
                                    {
                                        expenseEligibilityObj.Eligibility_Amount = Float(expenseAmount)
                                    }
                                    //expenseEligibilityObj.Eligibility_Amount = (expenseObj as AnyObject).value(forKey: "Eligibility_Amount") as! Float
                                    
                                    if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Approved_Amount") as? Float
                                    {
                                        expenseEligibilityObj.Approved_Amount = expenseAmount
                                    }
                                    else if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Approved_Amount")  as? Double
                                    {
                                        expenseEligibilityObj.Approved_Amount = Float(expenseAmount)
                                    }
                                    //expenseEligibilityObj.Approved_Amount = (expenseObj as AnyObject).value(forKey: "Approved_Amount") as! Float
                                    
                                    
                                    expenseEligibilityObj.Expense_Type_Name = (expenseObj as AnyObject).value(forKey: "Expense_Type_Name") as! String
                                    if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Expense_Amount") as? Float
                                    {
                                        expenseEligibilityObj.Expense_Amount = expenseAmount
                                    }
                                    else if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Expense_Amount")  as? Double
                                    {
                                        expenseEligibilityObj.Expense_Amount = Float(expenseAmount)
                                    }
                                  //  expenseEligibilityObj.Expense_Amount = (expenseObj as AnyObject).value(forKey: "Expense_Amount") as! Float
                                    expenseEligibilityObj.Eligible_Amount_Per_Num_Of_Applicable_Days = (expenseObj as AnyObject).value(forKey: "Eligible_Amount_Per_Num_Of_Applicable_Days") as! Double
                                    
                                    expenseEligibilityList.append(expenseEligibilityObj)
                                }
                                
                                //section 8 append
                                expenseDetailobj = ExpenseDetailSectionList()
                                expenseDetailobj.sectioTitle = "Expense Eligibility"
                                expenseDetailobj.emptyMessage = ""
                                expenseDetailobj.isSectionVisible = false
                                expenseDetailobj.rowCount = 1
                                expenseDetailobj.rowValueList = expenseEligibilityList as [Any]
                                if(self.expenseMode == "MONTHLY")
                                {
                                    expenseDetailobj.isVisible = true
                                }
                                else
                                {
                                    expenseDetailobj.isVisible = false
                                }
                                expenseDetailobj.rowHeight = 40
                                self.expenseDetailList.append(expenseDetailobj)
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                if(self.expenseAttachmentList.count > 0)
                                {
                                    expenseDetailobj = ExpenseDetailSectionList()
                                    expenseDetailobj.sectioTitle = "Attachment"
                                    expenseDetailobj.emptyMessage = ""
                                    expenseDetailobj.isSectionVisible = false
                                    expenseDetailobj.rowCount = 1
                                    expenseDetailobj.rowValueList = self.expenseAttachmentList as [Any]
                                    expenseDetailobj.isVisible = true
                                    expenseDetailobj.rowHeight = 164
                                    self.expenseDetailList.append(expenseDetailobj)
                                }
                                else
                                {
                                    expenseDetailobj = ExpenseDetailSectionList()
                                    expenseDetailobj.sectioTitle = "No Attachment"
                                    expenseDetailobj.emptyMessage = ""
                                    expenseDetailobj.isSectionVisible = false
                                    expenseDetailobj.rowCount = 1
                                    expenseDetailobj.rowValueList = self.expenseAttachmentList as [Any]
                                    expenseDetailobj.isVisible = true
                                    expenseDetailobj.rowHeight = 48
                                    self.expenseDetailList.append(expenseDetailobj)
                                }
                                
                                //section 8 append
                                expenseDetailobj = ExpenseDetailSectionList()
                                expenseDetailobj.sectioTitle = "Payment Mode"
                                expenseDetailobj.emptyMessage = ""
                                expenseDetailobj.isSectionVisible = false

                                if(Int(self.expenseApprovalData.Max_Order) == Int(self.expenseApprovalData.Move_Order))
                                {
                                    expenseDetailobj.rowCount = 1
                                    expenseDetailobj.rowValueList = []
                                    expenseDetailobj.isVisible = true
                                    expenseDetailobj.rowHeight = 188
                                    self.expenseDetailList.append(expenseDetailobj)
                                }
                                else
                                {
                                    expenseDetailobj.rowCount = 0
                                    expenseDetailobj.rowValueList = []
                                    expenseDetailobj.isVisible = false
                                    expenseDetailobj.rowHeight = 0
                                    self.expenseDetailList.append(expenseDetailobj)
                                }
                                
                                for expenseObj in section9
                                {
                                    expenseClaimRemarkObj = ExpenseRemarks()
                                    expenseClaimRemarkObj.Remarks_By_User = (expenseObj as AnyObject).value(forKey: "Remarks_By_User") as! String
                                    expenseClaimRemarkObj.Updated_Date = (expenseObj as AnyObject).value(forKey: "Updated_Date") as! String
                                    expenseClaimRemarkObj.User_Name = (expenseObj as AnyObject).value(forKey: "User_Name") as! String
                                    
                                    expenseClaimRemarkList.append(expenseClaimRemarkObj)
                                }
                                
                                //section 10 append
                                expenseDetailobj = ExpenseDetailSectionList()
                                expenseDetailobj.sectioTitle = "Remarks"
                                expenseDetailobj.emptyMessage = ""
                                expenseDetailobj.isSectionVisible = true
                                expenseDetailobj.rowCount = expenseClaimRemarkList.count+1
                                expenseDetailobj.rowValueList = expenseClaimRemarkList as [Any]
                                expenseDetailobj.isVisible = true
                                expenseDetailobj.rowHeight = 40
                                self.expenseDetailList.append(expenseDetailobj)
                                
                                for expenseObj in section10
                                {
                                    expenseStatusHistoryObj = ExpenseStatusHistory()
                                    expenseStatusHistoryObj.Status_Name = (expenseObj as AnyObject).value(forKey: "Status_Name") as! String
                                    expenseStatusHistoryObj.Updated_Date = (expenseObj as AnyObject).value(forKey: "Updated_Date") as! String
                                    expenseStatusHistoryObj.Updated_By = (expenseObj as AnyObject).value(forKey: "Updated_By") as! String
                                    expenseStatusHistoryObj.User_Type_Name = (expenseObj as AnyObject).value(forKey: "User_Type_Name") as! String
                                    
                                    expenseStatusHistoryList.append(expenseStatusHistoryObj)
                                }
                                
                                //section 11 append
                                expenseDetailobj = ExpenseDetailSectionList()
                                expenseDetailobj.sectioTitle = "Status History"
                                expenseDetailobj.emptyMessage = ""
                                if(expenseStatusHistoryList.count > 0)
                                {
                                    expenseDetailobj.isSectionVisible = true
                                    expenseDetailobj.rowCount = expenseStatusHistoryList.count
                                    expenseDetailobj.rowValueList = expenseStatusHistoryList as [Any]
                                    expenseDetailobj.isVisible = true
                                    expenseDetailobj.rowHeight = 76
                                }
                                else
                                {
                                    expenseDetailobj.isSectionVisible = false
                                    expenseDetailobj.rowCount = 0
                                    expenseDetailobj.rowValueList = []
                                    expenseDetailobj.isVisible = false
                                    expenseDetailobj.rowHeight = 0
                                }
                                
                                
                                self.expenseDetailList.append(expenseDetailobj)
                                BL_ExpenseClaim.sharedInstance.expenseDetailSectionList = self.expenseDetailList
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
            })
        }
        else
        {
            AlertView.showAlertView(title: internetOfflineTitle, message: internetOfflineMessage, viewController: self)
        }
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return expenseDetailList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(expenseDetailList[section].isVisible)
        {
           return expenseDetailList[section].rowCount
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(self.expenseDetailList[section].isVisible)
        {
            if(section == 0 || section == 2 || section == 4 || section == 9 || section == 10 || section == 11)
            {
                let cell1 = self.tableView.dequeueReusableCell(withIdentifier: "ExpenseClaimSectionCellID") as! ExpenseClaimSectionCell
                cell1.titleLbl.text = self.expenseDetailList[section].sectioTitle
                
                return cell1
            }
            else if(section == 1 || section == 3)
            {
                let cell2 = self.tableView.dequeueReusableCell(withIdentifier: "ExpenseClaimTypeListTableViewSectionID") as! ExpenseClaimTypeListTableViewCell
                cell2.titleLbl.text = self.expenseDetailList[section].sectioTitle
                return cell2
            }
            else
            {
                return UIView()
            }
        }
        else
        {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if(self.expenseDetailList[section].isVisible)
        {
            if(section == 2)
            {
                let cell2 = self.tableView.dequeueReusableCell(withIdentifier: "ButtonCell") as? UITableViewCell
                let but = cell2?.viewWithTag(1) as! UIButton
                but.setTitle("VIEW CLAIM DETAILS", for: .normal)
                but.addTarget(self, action: #selector(navigateToClaimDetail(sender:)), for: .touchUpInside)
                return cell2
            }
            if(section == 3)
            {
                let cell2 = self.tableView.dequeueReusableCell(withIdentifier: "ButtonCell") as? UITableViewCell
                let but = cell2?.viewWithTag(1) as! UIButton
                but.setTitle("MODIFY", for: .normal)
                but.addTarget(self, action: #selector(navigateToModifyAdditionalClaim(sender:)), for: .touchUpInside)
                return cell2
            }
            else
            {
                return UIView()
            }
        }
        else
        {
            return UIView()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0 || indexPath.section == 2||indexPath.section == 4)
        {
           let cell1 = self.tableView.dequeueReusableCell(withIdentifier: "ExpenseClaimDetailTableViewCellID") as! ExpenseClaimDetailTableViewCell
            let expenseClaimDetail = self.expenseDetailList[indexPath.section].rowValueList as! [ExpenseClaimDetail]
            cell1.valueLbl.isHidden = false
            cell1.valueTxt.isHidden = true
            if(indexPath.section == 4 && indexPath.row == 0)
            {
                doneToolbar = UIToolbar()
                let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
                doneToolbar.sizeToFit()
                var done: UIBarButtonItem = UIBarButtonItem()
                
                done = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.fromTextfieldDoneAction(sender:)))
                let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.cancelBtnClicked))
                
                done.tag = indexPath.section * 1000 + indexPath.row
                
                doneToolbar.items = [flexSpace, done, cancel]
                cell1.valueTxt.inputAccessoryView = doneToolbar
                cell1.valueLbl.isHidden = true
                cell1.valueTxt.isHidden = false
                cell1.valueTxt.delegate = self
                cell1.valueTxt.text = "\(BL_ExpenseClaim.sharedInstance.otherDeduction!)"
            }
            cell1.valueLbl.text = expenseClaimDetail[indexPath.row].value
            cell1.titleLbl.text = expenseClaimDetail[indexPath.row].title
            return cell1
        }
        else if(indexPath.section == 1 || indexPath.section == 3)
        {
            let cell2 = self.tableView.dequeueReusableCell(withIdentifier: "ExpenseClaimTypeListTableViewCellID") as! ExpenseClaimTypeListTableViewCell
            let expenseClaimDetail = self.expenseDetailList[indexPath.section].rowValueList as! [ExpenseClaimTypeList]
            cell2.approvedAmountLbl.text = "\(expenseClaimDetail[indexPath.row].Approved_Amount!)"
            cell2.claimAmountLbl.text = "\(expenseClaimDetail[indexPath.row].Expense_Amount!)"
            cell2.claimAmountDet.text = "\(expenseClaimDetail[indexPath.row].Total_Deduction!)"
            cell2.titleLbl.text = expenseClaimDetail[indexPath.row].Expense_Type_Name
            return cell2
        }
        else if( indexPath.section == -3)
        {
            let cell2 = self.tableView.dequeueReusableCell(withIdentifier: "ExpenseClaimTypeListTableViewCellID") as! ExpenseClaimTypeListTableViewCell
            let expenseClaimDetail = self.expenseDetailList[indexPath.section].rowValueList as! [ExpenseClaimAdditionalTypeList]
            cell2.approvedAmountLbl.text = "\(expenseClaimDetail[indexPath.row].Approved_Amount!)"
            cell2.claimAmountLbl.text = "\(expenseClaimDetail[indexPath.row].Expense_Amount!)"
            cell2.claimAmountDet.text = "\(expenseClaimDetail[indexPath.row].Deduction_Amount!)"
            cell2.titleLbl.text = expenseClaimDetail[indexPath.row].Expense_Type_Name
            return cell2
        }
        else if(indexPath.section == 5 )
        {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "ExpenseClaimAttachmentCellID") as! ExpenseClaimAttachmentCell
            cell.showAllBut.isHidden = false
            let expenseClaimDetail = self.expenseDetailList[indexPath.section].rowValueList as! [ExpenseClaimSFC]
            cell.showAllBut.isHidden = false
            if(expenseClaimDetail.count > 0)
            {
                cell.showAllBut.isHidden = false
                cell.showAllBut.setTitle("SHOW", for: .normal)
                cell.title.text = self.expenseDetailList[indexPath.section].sectioTitle
            }
            else
            {
                cell.showAllBut.isHidden = true
                cell.showAllBut.setTitle("", for: .normal)
            }
            cell.showAllBut.tag = indexPath.section * 1000 + indexPath.row
            cell.showAllBut.addTarget(self, action: #selector(navigateToSFCDetail(sender:)), for: .touchUpInside)
            return cell
        }
        else if(indexPath.section == 6)
        {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "ExpenseClaimAttachmentCellID") as! ExpenseClaimAttachmentCell
            let expenseClaimDetail = self.expenseDetailList[indexPath.section].rowValueList as! [NSArray]
            cell.showAllBut.isHidden = false
            if(expenseClaimDetail.count > 0)
            {
                cell.showAllBut.isHidden = false
                cell.showAllBut.setTitle("SHOW", for: .normal)
                cell.title.text = self.expenseDetailList[indexPath.section].sectioTitle
            }
            else
            {
                cell.showAllBut.isHidden = true
                cell.showAllBut.setTitle("", for: .normal)
            }
            cell.showAllBut.tag = indexPath.section * 1000 + indexPath.row
            cell.showAllBut.addTarget(self, action: #selector(navigateToCalenderDetail(sender:)), for: .touchUpInside)
            return cell
        }
        else if(indexPath.section == 7)
        {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "ExpenseClaimAttachmentCellID") as! ExpenseClaimAttachmentCell
            let expenseClaimDetail = self.expenseDetailList[indexPath.section].rowValueList as! [ExpenseClaimEligibility]
            cell.showAllBut.isHidden = false
            cell.title.text = self.expenseDetailList[indexPath.section].sectioTitle
            if(expenseClaimDetail.count > 0)
            {
                cell.showAllBut.isHidden = false
                cell.showAllBut.setTitle("SHOW", for: .normal)
                
            }
            else
            {
                cell.showAllBut.isHidden = true
                cell.showAllBut.setTitle("", for: .normal)
            }
           cell.showAllBut.tag = indexPath.section * 1000 + indexPath.row
            cell.showAllBut.addTarget(self, action: #selector(navigatoToEligibility(sender:)), for: .touchUpInside)
            return cell
        }
        else if(indexPath.section == 8)
        {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "ExpenseClaimAttachmentCellID") as! ExpenseClaimAttachmentCell
            let expenseClaimDetail = self.expenseDetailList[indexPath.section].rowValueList as! [ExpenseAttachmentList]
            if(expenseClaimDetail.count > 0)
            {
                cell.showAllBut.isHidden = false
                cell.showAllBut.setTitle("SHOW ALL", for: .normal)
                cell.expenseAttachmentList = []
                cell.expenseAttachmentList  = self.expenseAttachmentList
                cell.collectionView.reloadData()
            }
            else
            {
                cell.showAllBut.isHidden = true
                cell.showAllBut.setTitle("", for: .normal)
            }
            cell.title.text = self.expenseDetailList[indexPath.section].sectioTitle
            cell.showAllBut.setTitle("SHOW ALL", for: .normal)
            cell.showAllBut.addTarget(self, action: #selector(navigatoToExpenseAttachment(sender:)), for: .touchUpInside)
            return cell
        }
        else if(indexPath.section == 9)
        {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "PaymentCell") as! UITableViewCell
            let textViewValue = cell.viewWithTag(30) as! UITextView
            let editTxtField = cell.viewWithTag(31) as! UITextField
            
            doneToolbar = UIToolbar()
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            doneToolbar.sizeToFit()
            var done: UIBarButtonItem = UIBarButtonItem()
            
            done = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.fromPickerDoneAction(sender:)))
            let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.cancelBtnClicked))
            
            
            doneToolbar.items = [flexSpace, done, cancel]
            
            editTxtField.inputView = picker
            editTxtField.inputAccessoryView = doneToolbar
            textViewValue.delegate = self
            textViewValue.addHideinputAccessoryView()
            textViewValue.layer.cornerRadius = 5
            textViewValue.layer.masksToBounds = true
            textViewValue.layer.borderWidth = 0.8
            textViewValue.layer.borderColor = UIColor.gray.cgColor
            textViewValue.text = paymentRemark
            editTxtField.text = paymentMode
            return cell
            
            
        }
        else if(indexPath.section == 10)
        {
             let expenseClaimDetail = self.expenseDetailList[indexPath.section].rowValueList as! [ExpenseRemarks]
            
            if(indexPath.row ==  self.expenseDetailList[indexPath.section].rowCount-1 )
            {
                 let cell = self.tableView.dequeueReusableCell(withIdentifier: "remarkCell") as! UITableViewCell
                let remarkLabel =  cell.viewWithTag(1) as! UILabel
                let textViewValue = cell.viewWithTag(2) as! UITextView
                textViewValue.delegate = self
                textViewValue.addHideinputAccessoryView()
                textViewValue.layer.cornerRadius = 5
                textViewValue.layer.masksToBounds = true
                textViewValue.layer.borderWidth = 0.8
                textViewValue.layer.borderColor = UIColor.gray.cgColor
                textViewValue.text = approvalRemarks
               return cell
                
                
            }
            else
            {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "CommonCell") as! UITableViewCell
                let label1 = cell.viewWithTag(1) as! UILabel
                let label2 = cell.viewWithTag(2) as! UILabel
                
                let userName = expenseClaimDetail[indexPath.row].User_Name.components(separatedBy: "|")
                if(userName.count>0)
                {
                    label1.text = userName[0]
                }
                label2.text = expenseClaimDetail[indexPath.row].Remarks_By_User
                
                return cell
            }
            
        }
        else if(indexPath.section == 11)
        {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "CommonCell") as! UITableViewCell
            
            let expenseClaimDetail = self.expenseDetailList[indexPath.section].rowValueList as! [ExpenseStatusHistory]
            let label1 = cell.viewWithTag(1) as! UILabel
            let label2 = cell.viewWithTag(2) as! UILabel
            
            label1.text = expenseClaimDetail[indexPath.row].Updated_By
            let datevalue = expenseClaimDetail[indexPath.row].Updated_Date.components(separatedBy: " ")
            if(datevalue.count > 0)
            {
            let dateFromValue = convertDateIntoString(dateString: datevalue[0])
            let appFormatDate = convertDateIntoString(date: dateFromValue)
            label2.text = expenseClaimDetail[indexPath.row].Status_Name + " | " + appFormatDate + " " + datevalue[1] + " " + datevalue[2]
            }
            else
            {
                label2.text = expenseClaimDetail[indexPath.row].Status_Name
            }
            
           
            return cell
        }
        else
        {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(expenseDetailList[indexPath.section].isVisible)
        {
            if(indexPath.section == 10)
            {
                let expenseClaimDetail = self.expenseDetailList[indexPath.section].rowValueList as! [ExpenseRemarks]
                
                if(indexPath.row == self.expenseDetailList[indexPath.section].rowCount - 1)
                {
                    return 100
                }
                else
                {
                    let getRemarkSize = getTextSize(text: expenseClaimDetail[indexPath.row].Remarks_By_User, fontName: fontRegular, fontSize: 15, constrainedWidth: SCREEN_WIDTH - 28).height
                    return 40 + getRemarkSize
                }
                
            }
            else
            {
                return expenseDetailList[indexPath.section].rowHeight
            }
        }
        else
        {
            return 0
        }
        
//        if(indexPath.section == 5)
//        {
//            return 164
//        }
//        else if(indexPath.section == 0 || indexPath.section == 2||indexPath.section == 4)
//        {
//            return 32
//        }
//        else if(indexPath.section == 1 || indexPath.section == 3)
//        {
//            return 58
//        }
//        else
//        {
//            return 0
//        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(expenseDetailList[section].isVisible)
        {
            if(expenseDetailList[section].isSectionVisible)
            {
                return 40
            }
            else
            {
                return 0
            }
        }
        else
        {
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(expenseDetailList[section].isVisible)
        {
            if(section == 2 || section == 3)
            {
                return 40
            }
            return 0
        }
        return 0
    }
    @objc func navigatoToExpenseAttachment(sender:UIButton)
    {
        let storyBoard = UIStoryboard(name: ApprovalSb, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ExpenseAttachmentViewControllerID") as! ExpenseAttachmentListController
        vc.claimCode = claimCode
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func navigateToClaimDetail(sender:UIButton)
    {
        let storyBoard = UIStoryboard(name: ApprovalSb, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ExpenseDetailsViewControllerID") as!  ExpenseDetailsViewController
        vc.isComingAdditionalView = false
        vc.expenseApprovalData = expenseApprovalData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func navigateToModifyAdditionalClaim(sender:UIButton)
    {
        let storyBoard = UIStoryboard(name: ApprovalSb, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ExpenseDetailsViewControllerID") as!  ExpenseDetailsViewController
        vc.isComingAdditionalView = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func navigatoToEligibility(sender:UIButton)
    {
        let section = sender.tag/1000
        let row = sender.tag%1000
        
        if(section == 7)
        {
        let storyBoard = UIStoryboard(name: ApprovalSb, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ExpenseClaimEligibilityListControllerID") as! ExpenseClaimEligibilityListController
        vc.expenseEligibilityList = self.expenseDetailList[7].rowValueList as! [ExpenseClaimEligibility]
        self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    @objc func navigateToSFCDetail(sender:UIButton)
    {
        let section = sender.tag/1000
        let row = sender.tag%1000

        if(section == 5)
        {
        let storyBoard = UIStoryboard(name: ApprovalSb, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ExpenseClaimSFCListViewControllerID") as! ExpenseClaimSFCListViewController
        vc.expenseSFCList = self.expenseDetailList[5].rowValueList as! [ExpenseClaimSFC]
        self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    @objc func navigateToCalenderDetail(sender:UIButton)
    {
        let section = sender.tag/1000
        let row = sender.tag%1000
        
        if(section == 6)
        {
        let storyBoard = UIStoryboard(name: ApprovalSb, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ExpenseClaimCalandarListControllerID") as! ExpenseClaimCalandarListController
        vc.expenseCalandarEventList = self.expenseDetailList[6].rowValueList as! [NSArray]
        self.navigationController?.pushViewController(vc, animated: true)
        }
        
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(string == "-")
        {
            if(textField.text?.contains("-"))!
            {
                return false
            }
        }
        if(string == ".")
        {
            if(textField.text?.contains("."))!
            {
                return false
            }
        }
        let aSet = NSCharacterSet(charactersIn:"0123456789-.").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(doneButtonTouched)
        {
            if(textField.text!.count > 0 && textField.text! != "-")
            {
                 let deductionAmount = Float(textField.text!)!
                let claimDetail = BL_ExpenseClaim.sharedInstance.expenseDetailSectionList[2].rowValueList as![ExpenseClaimDetail]
                let otherClaimDetail = BL_ExpenseClaim.sharedInstance.expenseDetailSectionList[4].rowValueList as![ExpenseClaimDetail]
                
                let claimedAmount = Float(claimDetail[1].value)
                let otherClaimedAmount = Float(otherClaimDetail[1].value)
                if(otherClaimedAmount! >= Float(otherClaimDetail[2].value)! + Float(textField.text!)!)
                {
                    
//                    let alertViewController = UIAlertController(title: alertTitle, message: "Total Other Deduction is \(deductionAmount)", preferredStyle: UIAlertControllerStyle.alert)
//
//
//                        //\(Float(otherClaimDetail[2].value)! + Float(textField.text!)!)", preferredStyle: UIAlertControllerStyle.alert)
//
//                    alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
                    
                        // claimDetail[2].value = "\(Float(claimDetail[2].value)! + Float(textField.text!)!)"
                    otherClaimDetail[2].value = "\(Float(deductionAmount) + Float(claimDetail[2].value)! + BL_ExpenseClaim.sharedInstance.tempOtherDeduction)"
                        otherClaimDetail[3].value = "\(otherClaimedAmount! - Float(otherClaimDetail[2].value)!)"
                        
                        // claimDetail[3].value = "\(claimedAmount! - Float(claimDetail[2].value)!)"
                       
                        BL_ExpenseClaim.sharedInstance.otherDeduction   = deductionAmount + BL_ExpenseClaim.sharedInstance.tempOtherDeduction
                        self.tableView.reloadData()
                        self.doneButtonTouched = false
//                        alertViewController.dismiss(animated: true, completion: nil)
//                    }))
//
//                    alertViewController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { alertAction in
//                        self.doneButtonTouched = false
//                        alertViewController.dismiss(animated: true, completion: nil)
//                    }))
//
//                    self.present(alertViewController, animated: true, completion: nil)
                   
                }
                else
                {
                    AlertView.showAlertView(title: errorTitle, message: "Deduction Amount cannot greater then Actual Expense Amount", viewController: self)
                }
                
                self.tableView.reloadData()
                doneButtonTouched = false
            }
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        //        let pointInTable:CGPoint = (tableView.superview?.convert(textView.frame.origin, to: self.tableView))!
        //        var contentOffset:CGPoint = tableView.contentOffset
        //        contentOffset.y  = pointInTable.y
        //        if let accessoryView = textView.inputAccessoryView {
        //            contentOffset.y -= accessoryView.frame.size.height
        //        }
        //        tableView.contentOffset = contentOffset
        //        return true
        
        let pointInTable:CGPoint = textView.superview!.convert(textView.frame.origin, to: tableView)
        var contentOffset:CGPoint = tableView.contentOffset
        contentOffset.y  = pointInTable.y
        if let accessoryView = textView.inputAccessoryView
        {
            contentOffset.y -= accessoryView.frame.size.height + 100
        }
        tableView.contentOffset = contentOffset
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if(textView.tag == 2)
        {
            approvalRemarks = textView.text
        }
        else if(textView.tag == 30)
        {
            paymentRemark = textView.text
        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let index = textView.tag
        
    }
    func getExpenseviewDetailDcrWise()
    {
        if(checkInternetConnectivity())
        {
            showCustomActivityIndicatorView(loadingText: "Loading Expense data...")
            WebServiceHelper.sharedInstance.getExpenseViewDetailList(userCode: self.userCode, claimCode: self.claimCode, claimDate: "", flag: "F", completion: { (apiObj) in
                if(apiObj.Status == SERVER_SUCCESS_CODE)
                {
                   
                    if(apiObj.list.count > 0)
                    {
                        let expenseViewData = apiObj.list[0] as! NSDictionary
                        let dcrSfcExpense = expenseViewData.value(forKey: "lstDcrSfcExpense") as! NSArray
                        self.expenseDCRDetailList = []
                        var expenseDetailObj = ExpenseViewDCRWiseDetailList()
                        for expenseObj in dcrSfcExpense
                        {
                            expenseDetailObj = ExpenseViewDCRWiseDetailList()
                            expenseDetailObj.DCR_Actual_Date = (expenseObj as AnyObject).value(forKey: "DCR_Actual_Date") as! String
                            if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Deduction_Amount") as? Float
                            {
                                expenseDetailObj.Deduction_Amount = expenseAmount
                            }
                            else if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Deduction_Amount")  as? Double
                            {
                                expenseDetailObj.Deduction_Amount = Float(expenseAmount)
                            }
                          //  expenseDetailObj.Deduction_Amount = (expenseObj as AnyObject).value(forKey: "Deduction_Amount") as! Float
                           
                            if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Deduction_Amount") as? Float
                            {
                                expenseDetailObj.previousDeduction = expenseAmount
                            }
                            else if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Deduction_Amount")  as? Double
                            {
                                expenseDetailObj.previousDeduction = Float(expenseAmount)
                            }
                          //  expenseDetailObj.previousDeduction = (expenseObj as AnyObject).value(forKey: "Deduction_Amount") as! Float
                            
                            if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Approved_Amount") as? Float
                            {
                                expenseDetailObj.Approved_Amount = expenseAmount
                            }
                            else if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Approved_Amount")  as? Double
                            {
                                expenseDetailObj.Approved_Amount = Float(expenseAmount)
                            }
                          //  expenseDetailObj.Approved_Amount = (expenseObj as AnyObject).value(forKey: "Approved_Amount") as! Float
                            
                            if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Expense_Amount") as? Float
                            {
                                expenseDetailObj.Expense_Amount = expenseAmount
                            }
                            else if let expenseAmount = (expenseObj as AnyObject).value(forKey: "Expense_Amount")  as? Double
                            {
                                expenseDetailObj.Expense_Amount = Float(expenseAmount)
                            }
                           // expenseDetailObj.Expense_Amount = (expenseObj as AnyObject).value(forKey: "Expense_Amount") as! Float
                            expenseDetailObj.Doctor_Visit_Count = (expenseObj as AnyObject).value(forKey: "Doctor_Visit_Count") as! Int
                             expenseDetailObj.Claim_Code = checkNullAndNilValueForString(stringData: (expenseObj as AnyObject).value(forKey: "Claim_Code") as? String)
                            expenseDetailObj.Expense_Type_Name = checkNullAndNilValueForString(stringData: (expenseObj as AnyObject).value(forKey: "Expense_Type_Name") as? String)
                             expenseDetailObj.DCR_Activity_Flag = checkNullAndNilValueForString(stringData: (expenseObj as AnyObject).value(forKey: "DCR_Activity_Flag") as? String)
                            expenseDetailObj.Category = checkNullAndNilValueForString(stringData: (expenseObj as AnyObject).value(forKey: "Category") as? String)
                            expenseDetailObj.DCR_Status = checkNullAndNilValueForString(stringData: (expenseObj as AnyObject).value(forKey: "DCR_Status") as? String)
                            expenseDetailObj.Remarks_By_User = checkNullAndNilValueForString(stringData: (expenseObj as AnyObject).value(forKey: "Remarks_By_User") as? String)
                            expenseDetailObj.Managers_Approval_Remark = checkNullAndNilValueForString(stringData: (expenseObj as AnyObject).value(forKey: "Managers_Approval_Remark") as? String)
                            expenseDetailObj.User_Code = checkNullAndNilValueForString(stringData: (expenseObj as AnyObject).value(forKey: "User_Code") as? String)
                            expenseDetailObj.DCR_Expense_Code = checkNullAndNilValueForString(stringData: (expenseObj as AnyObject).value(forKey: "DCR_Expense_Code") as? String)
                            expenseDetailObj.Expense_Mode = checkNullAndNilValueForString(stringData: (expenseObj as AnyObject).value(forKey: "Expense_Mode") as? String)
                            expenseDetailObj.Expense_Type_Code = checkNullAndNilValueForString(stringData: (expenseObj as AnyObject).value(forKey: "Expense_Type_Code") as? String)
                            expenseDetailObj.Claim_Detail_Code = checkNullAndNilValueForString(stringData: (expenseObj as AnyObject).value(forKey: "Claim_Detail_Code") as? String)
                            expenseDetailObj.DCR_Date = checkNullAndNilValueForString(stringData: (expenseObj as AnyObject).value(forKey: "DCR_Date") as? String)
                            expenseDetailObj.Expense_Remarks = checkNullAndNilValueForString(stringData: (expenseObj as AnyObject).value(forKey: "Expense_Remarks") as? String)
                            expenseDetailObj.Bill_Number = checkNullAndNilValueForString(stringData: (expenseObj as AnyObject).value(forKey: "Bill_Number") as? String)
                            
                            self.expenseDCRDetailList.append(expenseDetailObj)
                        }
                        
                        BL_ExpenseClaim.sharedInstance.expenseDCRDetailList = []
                        BL_ExpenseClaim.sharedInstance.expenseDCRDetailList = self.expenseDCRDetailList
                        
                    }
                    self.getExpenceDataList()
                }
            })
        }
        else
        {
            AlertView.showAlertView(title: internetOfflineTitle, message: internetOfflineMessage, viewController: self)
        }
        
    }
    @IBAction func approveButtonAction()
    {
        let restrictedCharacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
        if(isSpecialCharacterExist(remarks: approvalRemarks))
        {
            AlertView.showSpecialCharacterAlertview(title: alertTitle, subject: "Remarks", restrictedVal: restrictedCharacter, viewController: self)
        }
        else if(isSpecialCharacterExist(remarks: paymentRemark))
        {
            AlertView.showSpecialCharacterAlertview(title: alertTitle, subject: "Payment Remarks", restrictedVal: restrictedCharacter, viewController: self)
        }
        else if(Int(self.expenseApprovalData.Max_Order) == Int(self.expenseApprovalData.Move_Order))
        {
            if(paymentMode == "")
            {
                AlertView.showAlertView(title: alertTitle, message: "Select Payment Mode", viewController: self)
               
            }
            else
            {
                orderNo = approveMoveOrder
                statusCode = approveStatusCode
                approveExpense()
            }
        }
        else
        {
            orderNo = approveMoveOrder
            statusCode = approveStatusCode
            approveExpense()
        }
    }
    
    @IBAction func unApproveButtonAction()
    {
        let restrictedCharacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
        if(isSpecialCharacterExist(remarks: approvalRemarks))
        {
            AlertView.showSpecialCharacterAlertview(title: alertTitle, subject: "Remarks", restrictedVal: restrictedCharacter, viewController: self)
        }
        else if(isSpecialCharacterExist(remarks: paymentRemark))
        {
            AlertView.showSpecialCharacterAlertview(title: alertTitle, subject: "Payment Remarks", restrictedVal: restrictedCharacter, viewController: self)
        }
        else if(approvalRemarks == "")
        {
            AlertView.showAlertView(title: alertTitle, message: "Please Enter Remarks", viewController: self)
        }
        else if(Int(self.expenseApprovalData.Max_Order) == Int(self.expenseApprovalData.Move_Order))
        {
            if(approvalRemarks == "")
            {
                AlertView.showAlertView(title: alertTitle, message: "Please Enter Remarks", viewController: self)
                
            }
            else
            {
                orderNo = unapproveMoveOrder
                statusCode = unapproveStatusCode
                approveExpense()
            }
        }
        else
        {
            orderNo = unapproveMoveOrder
            statusCode = unapproveStatusCode
            approveExpense()
        }
        
    }
    
    func approveExpense()
    {
    
        let claimDetail = BL_ExpenseClaim.sharedInstance.expenseDetailSectionList[4].rowValueList as![ExpenseClaimDetail]
        let approvedAmount = Float(claimDetail[3].value)
        let deductionAmount = Float(claimDetail[2].value)
        let actualAmount = Float(claimDetail[1].value)
        
        
        let claimDetailList = NSMutableArray()
        for claimData in BL_ExpenseClaim.sharedInstance.expenseDCRDetailList
        {
            let claimDict = ["Claim_Code":claimData.Claim_Code,"Claim_Detail_Code":claimData.Claim_Detail_Code,"Expense_Type_Code":claimData.Expense_Type_Code,"Expense_Amount":claimData.Expense_Amount,"Present_Contribution":0.0,"Potential_Contribution":0.0,"Bill_Number":claimData.Bill_Number,"Remarks_By_User":claimData.Remarks_By_User,"DCR_Actual_Date":claimData.DCR_Actual_Date,"Approved_Amount":claimData.Approved_Amount,"Managers_Approval_Remark":claimData.Managers_Approval_Remark,"DCR_Activity_Flag":claimData.DCR_Activity_Flag,"Expense_Type_Name":claimData.Expense_Type_Name,"Deduction_Amount":claimData.Deduction_Amount,"DCR_Expense_Code":claimData.DCR_Expense_Code,"Region_Name":"","Expense_Remarks":claimData.Remarks_By_User,"Expense_Mode":claimData.Expense_Mode,"Updated_By":getUserName(),"Record_Status":"1"] as [String : Any]
            claimDetailList.add(claimDict)
        }
        
        for claimData in BL_ExpenseClaim.sharedInstance.expenseAdditionalDetailList
        {
            let claimDict = ["Claim_Code":"","Claim_Detail_Code":claimData.Claim_Detail_Code,"Expense_Type_Code":claimData.Expense_Type_Code,"Expense_Amount":claimData.Expense_Amount,"Present_Contribution":0.0,"Potential_Contribution":0.0,"Bill_Number":claimData.Bill_Number,"Remarks_By_User":claimData.Remarks_By_User,"DCR_Actual_Date":"","Approved_Amount":claimData.Approved_Amount,"Managers_Approval_Remark":claimData.Managers_Approval_Remark,"DCR_Activity_Flag":"","Expense_Type_Name":claimData.Expense_Type_Name,"Deduction_Amount":claimData.Deduction_Amount,"DCR_Expense_Code":"","Region_Name":"","Expense_Remarks":claimData.Remarks_By_User,"Expense_Mode":"Manual","Updated_By":getUserName(),"Record_Status":"1"] as [String : Any]
            claimDetailList.add(claimDict)
        }
        
        
        
        let postData = ["Remarks":"","CompanyCode":getCompanyCode(),"Region_Code":getRegionCode(),"claim_Code":self.claimCode,"User_Code":getUserName(),"statusCode":statusCode,"Approved_Amount":approvedAmount!,"Admin_Remarks":approvalRemarks,"Order_No":self.expenseApprovalData.Move_Order,"Other_Deduction":BL_ExpenseClaim.sharedInstance.otherDeduction,"Actual_Amount":actualAmount!,"Expense_Type":"","Expense_Privilege_value":self.expenseMode,"claim_User_Type_Name":expenseApprovalData.User_Type_Name,"Favoring_User_Code":self.userCode,"payment_Mode":paymentMode,"payment_Remarks":paymentRemark,"User_Type_Code":"","Search_Key":"","lstExpenseClaimDetailsModel":claimDetailList] as [String : Any]
        
        
        if(checkInternetConnectivity())
        {
            showCustomActivityIndicatorView(loadingText: "Loading Expense data...")
            WebServiceHelper.sharedInstance.approveExpenseClaim(postData: postData, completion: { (apiObj) in
                if(apiObj.Status == SERVER_SUCCESS_CODE)
                {
                    removeCustomActivityView()
                    _ = self.navigationController?.popViewController(animated: true)
                }
                else
                {
                    removeCustomActivityView()
                    AlertView.showAlertView(title: "Sorry", message: "Problem While Uploading", viewController: self)
                }
            })
        }
        else
        {
            AlertView.showAlertView(title: internetOfflineTitle, message: internetOfflineMessage, viewController: self)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return paymentPickerValue.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
       return paymentPickerValue[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.selectedIndex = row
    }
    
    @objc func fromPickerDoneAction(sender: UIBarButtonItem)
    {
        paymentMode = paymentPickerValue[selectedIndex] as! String
        self.tableView.reloadData()
    }
    @objc func fromTextfieldDoneAction(sender: UIBarButtonItem)
    {
        self.doneButtonTouched = true
        self.view.endEditing(true)
    }
    
    @objc func cancelBtnClicked()
    {
        self.view.endEditing(true)
    }
    
    func isSpecialCharacterExist(remarks:String) -> Bool
    {
        let restrictedChatacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
        
        if (remarks.count) > 0
        {
            if restrictedChatacter != ""
            {
                return checkIfSpecialCharacterFound(restrictedCharacter: restrictedChatacter, remarkTxt: remarks)
            }
        }
        
        return false
    }
}


