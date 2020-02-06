//
//  CommonApprovalAttendanceControllerViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 07/01/17.
//  Copyright © 2017 swaas. All rights reserved.
//import UIKit

class CommonApprovalAttendanceControllerViewController: UIViewController,UITableViewDelegate , UITableViewDataSource , ApprovalPopUpDelegate
{
    //MARK:-- Outlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var lowerHeaderLbl: UILabel!
    @IBOutlet weak var lowerHeaderLblHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var headerViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var bottomViewHgtConst: NSLayoutConstraint!
    @IBOutlet weak var approveBtnWidth: NSLayoutConstraint!
    
    //MARK:- Variable Declaration
    var approvalDataList : [ApprovalAttendanceListModel] = []
    var userObj : ApprovalUserMasterModel!
    var tpUserObj : ApprovalUserMasterModel!
    var ifIsComingFromTpPage : Bool = false
    var popUpView : ApprovalPoPUp!
    var isCmngFromReportPage : Bool = false
    var isMine : Bool = false
    var isCmngFromRejectPage : Bool = false
    var delegate : SaveActionToastDelegate?
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.setHeaderDetails()
        addBackButtonView()
        if ifIsComingFromTpPage == false && isCmngFromReportPage == false && isCmngFromRejectPage == false
        {
            self.addCustomViewTPButtonToNavigationBar()
        }
        
        let strCheckForLeave = UserDefaults.standard.string(forKey: "IsFromLeaveApprovalCheckBox")
        
        if (strCheckForLeave == "0")
        {
            UserDefaults.standard.set("", forKey: "IsFromLeaveApprovalCheckBox")
            UserDefaults.standard.synchronize()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.approvalDataList = []
        self.startApiCall()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Setting Header Details
    func setHeaderDetails()
    {
        var activityType = ""
        var actualDate : String = userObj.Actual_Date
        var headerText = ""
        
        if actualDate == ""
        {
            actualDate = NOT_APPLICABLE
        }
        else
        {
            let  entryDate = getStringInFormatDate(dateString: actualDate)
            actualDate = convertDateIntoString(date: entryDate)
        }
    
        if isCmngFromRejectPage
        {
            self.approveBtnWidth.constant = 0
        }
        
        let employeeName = userObj.Employee_Name as String
        if isCmngFromReportPage
        {
            self.bottomViewHgtConst.constant = 0
            self.bottomView.isHidden = true
        }
        else
        {
            self.bottomViewHgtConst.constant = 45
            self.bottomView.isHidden = false
        }
        
        if !isCmngFromReportPage && !isCmngFromRejectPage
        {
            activityType = applied
        }
        else if isCmngFromReportPage && isMine
        {
            activityType = BL_Approval.sharedInstance.getDCRStatus(dcrStatus: userObj.DCR_Status)
        }
        
        if activityType != ""
        {
            headerText = "Office - \(actualDate) | \(activityType)"
        }
        else
        {
            headerText = "Office - \(actualDate)"
        }
        if ifIsComingFromTpPage == false && isCmngFromReportPage == false && isCmngFromRejectPage == false
        {
            self.title = "\(PEV_DCR) Approval"
            self.headerLbl.text = "\(employeeName)"
            self.lowerHeaderLbl.text = headerText
            self.lowerHeaderLblHeightConstant.constant = 18
            self.headerViewHeightConstant.constant = 60
        }
        else
        {
            self.title = "\(employeeName)"
            self.headerLbl.text = headerText
            self.lowerHeaderLblHeightConstant.constant = 0
            self.headerViewHeightConstant.constant = 30
        }
        
    }
    
    //MARK:- TableView delegate
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return approvalDataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if ifIsComingFromTpPage
        {
        } else {
            
        }
        
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.AttendanceSectionHeaderCell) as! ApprovalSectionHeaderCell
        let approvalObj = approvalDataList[section]
        cell.titleLabel.text = approvalObj.sectionTitle
        let icon = approvalObj.titleImage
        cell.imgView.image = UIImage(named:icon)
        
        if ifIsComingFromTpPage
        {
            if section == 1 {
                cell.titleLabel.isHidden = true
                cell.imgView.isHidden = true
            } else {
                cell.titleLabel.isHidden = false
                cell.imgView.isHidden = false
            }
        } else {
            if section == 1 || section == 4 {
                cell.titleLabel.isHidden = true
                cell.imgView.isHidden = true
            } else {
                cell.titleLabel.isHidden = false
                cell.imgView.isHidden = false
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let approvalDetail = approvalDataList[indexPath.section]
        let dataList = approvalDetail.dataList
        let defaultHeight : CGFloat = 6
        
        
        if approvalDetail.currentAPIStatus == APIStatus.Loading
        {
            return BL_Approval.sharedInstance.getLoadingCellHeight()
        }
        else if approvalDetail.currentAPIStatus == APIStatus.Failed
        {
            
            return BL_Approval.sharedInstance.getEmptyStateRetryCellHeight()
        }
        else if approvalDetail.dataList.count == 0
        {
            if ifIsComingFromTpPage
            {
                if indexPath.section == 1 {
                    return 0
                } else {
                    return BL_Approval.sharedInstance.getEmptyStateCellHeight()
                }
            } else {
                if indexPath.section == 1 || indexPath.section == 4 {
                     return 0
                } else {
                    return BL_Approval.sharedInstance.getEmptyStateCellHeight()
                }
            }
        }
        else
        {
            if approvalDetail.sectionViewType == AttendanceHeaderType.Travel
            {
                return BL_Approval.sharedInstance.getSFCCellHeight(dataList: dataList) + defaultHeight
            }
            else if approvalDetail.sectionViewType == AttendanceHeaderType.WorkPlace
            {
                let dataList  = getWorkPlaceListModel(dict: dataList.firstObject as! NSDictionary)
                return BL_Approval.sharedInstance.getCommonHeightforWorkPlaceDetails(dataList: dataList)  + defaultHeight + 6
            }
            else if approvalDetail.sectionViewType == AttendanceHeaderType.Doctor{
                    
                    return BL_TpReport.sharedInstance.getDoctorVisitCellHeight(dataList: dataList, type: 1) + defaultHeight
                
            }
            else if approvalDetail.sectionViewType == AttendanceHeaderType.Expenses
            {
                return BL_Approval.sharedInstance.getCommonCellHeight(dataList: dataList, sectionType: 5) + defaultHeight
            }
            else
            {
                return  BL_Approval.sharedInstance.getCommonCellHeight(dataList: dataList, sectionType: 8) + defaultHeight
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let approvalDetail = approvalDataList[indexPath.section]
        if approvalDetail.currentAPIStatus == APIStatus.Loading
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.AttendanceLoadingCell, for: indexPath) as!  ApprovalLoadingTableViewCell
            cell.activityIndicator.startAnimating()
            return cell
        }
        else if approvalDetail.currentAPIStatus == APIStatus.Failed
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.AttendanceEmptyStateRetryCell, for: indexPath)
            return cell
        }
        else if approvalDetail.dataList.count == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.AttendanceEmptyStateCell, for: indexPath) as! ApprovalEmptyStateTableViewCell
            cell.emptyStateTiltleLbl.text = approvalDetail.emptyStateText
            if ifIsComingFromTpPage
            {
                 if indexPath.section == 1 {
                    cell.emptyStateTiltleLbl.isHidden = true
                 } else {
                    cell.emptyStateTiltleLbl.isHidden = false
                }
            } else {
                if indexPath.section == 1 || indexPath.section == 4 {
                    cell.emptyStateTiltleLbl.isHidden = true
                } else {
                    cell.emptyStateTiltleLbl.isHidden = false
                }
            }
            
            return cell
        }
        else
        {
            let approvalCell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.AttendanceInnerTableCell, for: indexPath) as! AttendanceInnerTableViewCell
            approvalCell.dataList = approvalDetail.dataList
            approvalCell.sectionType = approvalDetail.sectionViewType
            approvalCell.isComingFromTpPage = ifIsComingFromTpPage
            approvalCell.isMine = isMine
            approvalCell.userObj = userObj
            if approvalDetail.sectionViewType == AttendanceHeaderType.WorkPlace
            {
                approvalCell.workPlaceList = getWorkPlaceListModel(dict: approvalCell.dataList.firstObject as! NSDictionary)
            }
            approvalCell.tableView.reloadData()
            if indexPath.section == approvalDataList.count
            {
                approvalCell.sepViewHgtConst.constant = 0
            }
            return approvalCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var approvalDetail = approvalDataList[indexPath.section]
        
        if approvalDetail.currentAPIStatus == APIStatus.Failed
        {
            approvalDetail.currentAPIStatus = APIStatus.Loading
            self.tableView.reloadData()
            
            if ifIsComingFromTpPage
            {
                self.setTpApiCall(indexPath: indexPath.section)
            }
            else
            {
                self.setDCRApiCall(indexPath: indexPath.section)
            }
        }
    }
    
    //MARK:- StartAPICall
    func startApiCall()
    {
        if ifIsComingFromTpPage
        {
            self.setTpApiCall()
        }
        else
        {
            self.setDCRDetails()
            if ifIsComingFromTpPage == false && isCmngFromReportPage == false
            {
                self.getUserTpList()
            }
        }
    }
    
    //MARK:- Offline Details
    func setDCROfflineDetails()
    {
        self.approvalDataList[0].dataList = BL_Reports.sharedInstance.getWorkPlaceDetails()
        self.approvalDataList[1].dataList = BL_Reports.sharedInstance.getDCRSFCDetails()
        self.approvalDataList[2].dataList = BL_Reports.sharedInstance.getDCRActivityDetails()
        self.approvalDataList[3].dataList = BL_Reports.sharedInstance.getDCRAttendanceDoctorDetails()
        self.approvalDataList[4].dataList = BL_Reports.sharedInstance.getDCRExpenseDetails()
        self.approvalDataList[0].currentAPIStatus = APIStatus.Success
        self.approvalDataList[1].currentAPIStatus = APIStatus.Success
        self.approvalDataList[2].currentAPIStatus = APIStatus.Success
        self.approvalDataList[3].currentAPIStatus = APIStatus.Success
        self.approvalDataList[4].currentAPIStatus = APIStatus.Success
        
        self.tableView.reloadData()
    }
    
    //MARK:- Set DCR and TP API Calls
    func setDCRApiCall(indexPath : Int)
    {
        switch indexPath
        {
        case 0:
            getDCRWorkPlaceDetails()
        case 1:
            getDCRTravelledDetails()
        case 2:
            getDCRActivityDetails()
        case 3:
            getDCRDoctordetails()
        case 4:
            getDCRExpenseDetails()
        default:
            print("")
        }
    }
    
    func setTpApiCall(indexPath : Int)
    {
        switch indexPath
        {
        case 0:
            getTpWorkPlaceDetails()
        case 1:
            getTpTravelledDetails()
        case 2:
            getTpActivityDetails()
        default:
            print("")
        }
    }
    
    //MARK:- DCR Attendance
    func setDCRDetails()
    {
        setDcrApprovalList()
        if isMine
        {
            self.setDCROfflineDetails()
        }
        else
        {
            setDCRApiCall()
        }
    }
    
    func setDCRApiCall()
    {
        getDCRWorkPlaceDetails()
        getDCRTravelledDetails()
        getDCRActivityDetails()
        getDCRDoctordetails()
        getDCRExpenseDetails()
    }
    
    func setDcrApprovalList()
    {
        approvalDataList = BL_Approval.sharedInstance.getDCRAttendanceDataList()
    }
    
    func getDCRWorkPlaceDetails()
    {
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getDCRWorkPlaceDetails(userObj:userObj) { (apiResponseObject) in
                if apiResponseObject.Status == SERVER_SUCCESS_CODE
                {
                    self.approvalDataList[0].currentAPIStatus = APIStatus.Success
                    if apiResponseObject.list.count > 0
                    {
                        self.approvalDataList[0].dataList = apiResponseObject.list
                        if self.isCmngFromReportPage || self.isCmngFromRejectPage
                        {
                            let dict = apiResponseObject.list.firstObject as! NSDictionary
                            let dcrStatus = BL_Approval.sharedInstance.getDCRStatus(dcrStatus: checkNullAndNilValueForString(stringData: dict.object(forKey: "DCR_Status") as! String?))
                            var headerText = self.headerLbl.text! as String
                            headerText = "\(headerText)" + " | \(dcrStatus)"
                            self.headerLbl.text = headerText
                        }
                    }
                }
                else
                {
                    self.approvalDataList[0].currentAPIStatus = APIStatus.Failed
                }
                self.reloadTableView()
            }
        }
        else
        {
            setToastText(sectionType: 0)
        }
        
    }
    
    func getDCRTravelledDetails()
    {
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getDCRTravelledDetails(userObj:userObj) { (apiResponseObject) in
                if apiResponseObject.Status == SERVER_SUCCESS_CODE
                {
                    self.approvalDataList[1].currentAPIStatus = APIStatus.Success
                    if apiResponseObject.list.count > 0
                    {
                        self.approvalDataList[1].dataList = apiResponseObject.list
                    }
                }
                else
                {
                    self.approvalDataList[1].currentAPIStatus = APIStatus.Failed
                }
                self.reloadTableView()
            }
        }
        else
        {
            setToastText(sectionType: 1)
        }
        
    }
    
    func getDCRActivityDetails()
    {
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getDCRActivityDetails(userObj:userObj) { (apiResponseObject) in
                if apiResponseObject.Status == SERVER_SUCCESS_CODE
                {
                    self.approvalDataList[2].currentAPIStatus = APIStatus.Success
                    if apiResponseObject.list.count > 0
                    {
                        self.approvalDataList[2].dataList = apiResponseObject.list
                    }
                }
                else
                {
                    self.approvalDataList[2].currentAPIStatus = APIStatus.Failed
                }
                self.reloadTableView()
            }
        }
        else
        {
            self.setToastText(sectionType: 2)
        }
    }
    func getDCRDoctordetails(){
        
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getDCRAttendanceSamples(userObj:userObj) { (apiResponseObject) in
                if apiResponseObject.Status == SERVER_SUCCESS_CODE
                {
                    self.approvalDataList[3].currentAPIStatus = APIStatus.Success
                    if apiResponseObject.list.count > 0
                    {
                         let list : NSMutableArray = []
                        let batchObjList : NSMutableArray = []
                        for apiobj in apiResponseObject.list {
                            let doctordetails = apiobj as! NSDictionary
                            
                            var sampleList :[DCRAttendanceSampleDetailsModel] = []
                            var dcrDoctorProductList : NSArray = []
                            
                            let sampleListObj = doctordetails.value(forKey: "lstAttendanceSamplesDetails") as! NSArray
//                            for obj in sampleListObj
//                            {
                            
                                //let list : NSMutableArray = []
                                let newLine = "\n"
                                
                                for (_,element) in sampleListObj.enumerated()
                                {
                                    let sampleObj = element as! NSDictionary
                                    let batchList = sampleObj.value(forKey: "lstuserproductbatch") as! NSArray
                                    var productName = String()
                                    var quantity = Int()
                                    
                                    
                                    if(batchList.count > 0)
                                    {
                                        for (index,obj) in batchList.enumerated()
                                        {
                                            let batchObj = obj as! NSDictionary
                                            if(index == 0)
                                            {
                                                let prodName = sampleObj.value(forKey:"Product_Name") as! String
                                                let batchName = batchObj.value(forKey: "Batch_Number") as! String
                                                productName = prodName + newLine + batchName
                                            }
                                            else
                                            {
                                                productName = batchObj.value(forKey: "Batch_Number") as! String
                                            }
                                            quantity = batchObj.value(forKey: "Batch_Quantity_Provided") as! Int
                                            let dict = ["Product_Name":productName,"Quantity_Provided":quantity] as [String : Any]
                                            
                                            batchObjList.add(dict)
                                        }
                                    }
                                    else
                                    {
                                        productName = sampleObj.value(forKey:"Product_Name") as! String
                                        quantity = sampleObj.value(forKey: "Quantity_Provided") as! Int
                                        let dict = ["Product_Name":productName,"Quantity_Provided":quantity] as [String : Any]
                                        batchObjList.add(dict)
                                    }
                                }
                                dcrDoctorProductList = NSArray(array: batchObjList)
                              //  return dcrDoctorProductList
                                
                                
                                
                                
                                
                                
//                                let sampleDict = obj as! NSDictionary
//                                let dict = ["DCR_Id":0,
//                                            "DCR_Code":"",
//                                            "DCR_Doctor_Visit_Id":0,
//                                            "DCR_Doctor_Visit_Code":"",
//                                            "Product_Code":checkNullAndNilValueForString(stringData: sampleDict.value(forKey: "Product_Code") as? String),
//                                            "Product_Name":checkNullAndNilValueForString(stringData: sampleDict.value(forKey: "Product_Name") as? String),
//                                            "Quantity_Provided":sampleDict.value(forKey: "Quantity_Provided") as! Int,
//                                            "Remark":EMPTY] as [String : Any]
//                                let sampleObj = DCRAttendanceSampleDetailsModel(dict: dict as NSDictionary)
//
//                                sampleList.append(sampleObj)
                        
                          //  }
                            
                            let dict = [
                                "Doctor_Name" : checkNullAndNilValueForString(stringData: doctordetails.value(forKey:"Doctor_Name") as? String),
                                "MDL_Number" : checkNullAndNilValueForString(stringData: doctordetails.value(forKey: "MDL_Number") as? String),
                                "Hospital_Name" : checkNullAndNilValueForString(stringData: doctordetails.value(forKey: "Hospital_Name") as? String),
                                "Speciality_Name" : checkNullAndNilValueForString(stringData: doctordetails.value(forKey: "Speciality_Name") as? String),
                                "Category_Name" : checkNullAndNilValueForString(stringData: doctordetails.value(forKey: "Category_Name") as? String),
                                "Region_Name" : checkNullAndNilValueForString(stringData: doctordetails.value(forKey: "Region_Name") as? String),
                                "Sample_List" : dcrDoctorProductList,"DCR_Code":checkNullAndNilValueForString(stringData: doctordetails.value(forKey: "DCR_Code") as? String),    "DCR_Visit_Code" : doctordetails.value(forKey: "DCR_Doctor_Visit_Code") as? Int ?? 0] as [String : Any]
                            list.add(dict)
                            
                            
                            
                        }
                       self.approvalDataList[3].dataList = list
                    }
                }
                else
                {
                    self.approvalDataList[3].currentAPIStatus = APIStatus.Failed
                }
                self.reloadTableView()
            }
        }
        else
        {
            self.setToastText(sectionType: 3)
        }
    }
    func getDCRExpenseDetails()
    {
        
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getDCRExpenseDetails(userObj:userObj) { (apiResponseObject) in
                if apiResponseObject.Status == SERVER_SUCCESS_CODE
                {
                    self.approvalDataList[4].currentAPIStatus = APIStatus.Success
                    if apiResponseObject.list.count > 0
                    {
                        self.approvalDataList[4].dataList = apiResponseObject.list
                    }
                }
                else
                {
                    self.approvalDataList[4].currentAPIStatus = APIStatus.Failed
                }
                self.reloadTableView()
            }
        }
        else
        {
            setToastText(sectionType: 4)
        }
        
    }
    
    //MARK:- Tp Attendance
    func setTpApprovalList()
    {
        approvalDataList = BL_Approval.sharedInstance.getTpAttendanceDataList()
    }
    
    func setTpApiCall()
    {
        setTpApprovalList()
        if checkInternetConnectivity()
        {
            getTpWorkPlaceDetails()
            getTpTravelledDetails()
            getTpActivityDetails()
        }
        else
        {
            showToastView(toastText: "Problem in getting details")
        }
    }
    
    func getTpWorkPlaceDetails()
    {
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getTpWorkPlaceDetailsData(userObj:userObj) { (apiResponseObject) in
                if apiResponseObject.Status == SERVER_SUCCESS_CODE
                {
                    self.approvalDataList[0].currentAPIStatus = APIStatus.Success
                    if apiResponseObject.list.count > 0
                    {
                        self.approvalDataList[0].dataList = apiResponseObject.list
                    }
                }
                else
                {
                    self.approvalDataList[0].currentAPIStatus = APIStatus.Failed
                }
                self.reloadTableView()
            }
        }
        else
        {
            setToastText(sectionType: 0)
        }
    }
    
    func getTpTravelledDetails()
    {
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getTpTravelledDetails(userObj:userObj) { (apiResponseObject) in
                if apiResponseObject.Status == SERVER_SUCCESS_CODE
                {
                    self.approvalDataList[1].currentAPIStatus = APIStatus.Success
                    if apiResponseObject.list.count > 0
                    {
                        self.approvalDataList[1].dataList = apiResponseObject.list
                    }
                }
                else
                {
                    self.approvalDataList[1].currentAPIStatus = APIStatus.Failed
                }
                self.reloadTableView()
            }
        }
            
        else
        {
            setToastText(sectionType: 1)
        }
        
    }
    
    func getTpActivityDetails()
    {
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getTpWorkPlaceDetailsData(userObj:userObj) { (apiResponseObject) in
                if apiResponseObject.Status == SERVER_SUCCESS_CODE
                {
                    self.approvalDataList[2].currentAPIStatus = APIStatus.Success
                    if apiResponseObject.list.count > 0
                    {
                        self.approvalDataList[2].dataList = apiResponseObject.list
                    }
                }
                else
                {
                    self.approvalDataList[2].currentAPIStatus = APIStatus.Failed
                }
                self.reloadTableView()
            }
        }
        else
        {
            setToastText(sectionType: 2)
        }
    }
    
    //MARK:- TableView Reload data
    func reloadTableView()
    {
        self.tableView.reloadData()
    }
    
    //MARK:- Setting Toast text
    private func setToastText(sectionType : Int)
    {
        switch sectionType
        {
        case AttendanceHeaderType.WorkPlace.rawValue:
            showToastView(toastText: "Problem in getting WorkPlace Details")
            
        case AttendanceHeaderType.Travel.rawValue :
            showToastView(toastText: "Problem in getting Travel Details")
            
        case AttendanceHeaderType.Activity.rawValue :
            showToastView(toastText: "Problem in getting Activity Details")
            
        case AttendanceHeaderType.Doctor.rawValue :
            showToastView(toastText: "Problem in getting Contact Sample Details")
            
        case SectionHeaderType.Expense.rawValue :
            
            showToastView(toastText: "Problem in getting Expenses Details")
        default :
            showToastView(toastText: "Problem in getting Details.")
        }
    }
    
    //MARK:- Update Status
    @IBAction func rejectBtnAction(_ sender: Any)
    {
        self.addKeyBoardObserver()
        self.showPopUpView(type: ApprovalButtonType.reject)
    }
    
    
    @IBAction func approveBtnAction(_ sender: Any)
    {
        self.addKeyBoardObserver()
        self.showPopUpView(type: ApprovalButtonType.approval)
    }
    
    //MARK:- Pop Up View
    private func showPopUpView(type : ApprovalButtonType)
    {
        popUpView = ApprovalPoPUp.loadNib()
        
        popUpView.frame = CGRect(x: (SCREEN_WIDTH - 250)/2 ,  y:  SCREEN_HEIGHT, width: 250, height: popUpView.approvalPopUpHeight)
        popUpView.delegate = self
        popUpView.tag = 9000
        popUpView.userObj = userObj
        
        popUpView.statusButtonType = type
        popUpView.setDefaultDetails()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let blackScreen : UIView = UIView(frame: appDelegate.window!.bounds)
        blackScreen.backgroundColor = UIColor.black
        blackScreen.alpha = 0.6
        blackScreen.tag = 3000
        appDelegate.window!.addSubview(blackScreen)
        appDelegate.window!.addSubview(popUpView)
        
        UIView.animate(withDuration: 0.3) { () -> Void in
            self.popUpView.frame.origin.y = (SCREEN_HEIGHT - self.popUpView.approvalPopUpHeight)/2
        }
    }
    
    func hidePopUpView()
    {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.popUpView.frame.origin.y = SCREEN_HEIGHT
        }) { (value) -> Void in
            self.popUpView.removeFromSuperview()
            let appDelegate = getAppDelegate()
            let blackScreen = appDelegate.window?.viewWithTag(3000)
            blackScreen?.removeFromSuperview()
        }
    }
    
    //MARK:- KeyBoard function
    private func addKeyBoardObserver()
    {
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(keyboardDidShow(_:)),
                           name: .UIKeyboardDidShow,
                           object: nil)
        
        center.addObserver(self,
                           selector: #selector(keyboardWillHide(_:)),
                           name: .UIKeyboardWillHide,
                           object: nil)
    }
    
    private func removeKeyBoardObserver()
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardDidShow(_ notification: NSNotification)
    {
        if let userInfo = notification.userInfo
        {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            {
                let remainingHeight = SCREEN_HEIGHT - keyboardSize.height
                self.popUpView.frame.origin.y = (remainingHeight - self.popUpView.approvalPopUpHeight)/2
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification)
    {
        self.popUpView.frame.origin.y = (SCREEN_HEIGHT - self.popUpView.approvalPopUpHeight)/2
    }
    
    //MARK:- Setting pop up button action
    func setPopUpBtnAction(type : ApprovalButtonType)
    {
        removeKeyBoardObserver()
        if type == ApprovalButtonType.approval
        {
            if ifIsComingFromTpPage
            {
                updateTPStatus(approvalStatus : 1)
            }
            else
            {
                updateDCRStatus(approvalStatus : 2)
            }
        }
        else if type == ApprovalButtonType.reject
        {
            if ifIsComingFromTpPage
            {
                updateTPStatus(approvalStatus : 0)
            }
            else
            {
                updateDCRStatus(approvalStatus : 0)
            }
        }
        hidePopUpView()
    }
    
    //MARK:- Updating DCR and TP approval Status
    private func updateDCRStatus(approvalStatus : Int)
    {
        userObj.approvalStatus = approvalStatus
        let strCheck = UserDefaults.standard.string(forKey: "ApprovalENABLED")
        
        if (strCheck == "0"){
            userObj.IsChecked = 0
        }else{
            userObj.IsChecked = 1
        }
        
        BL_Approval.sharedInstance.updateDCRStatus(userList : [userObj] ,userObj: userObj, reason: condenseWhitespace(stringValue: popUpView.reasonTxtView.text)) { (apiResponseObject) in
            if apiResponseObject.Status == SERVER_SUCCESS_CODE
            {
                var toastText = getPopUpMsg(Flag: DCRFlag.attendance.rawValue, status: DCRStatus.approved.rawValue , type : "DVR")
                if approvalStatus == 0
                {
                    toastText = getPopUpMsg(Flag: DCRFlag.attendance.rawValue, status: DCRStatus.unApproved.rawValue, type : "DVR")
                }
                showToastView(toastText: toastText)
                _ = self.navigationController?.popViewController(animated: false)
            }
            else if apiResponseObject.Status == 2
            {
                showToastView(toastText: apiResponseObject.Message)
                _ = self.navigationController?.popViewController(animated: false)
            }
            else
            {
                var toastText = getPopUpMsg(Flag: DCRFlag.attendance.rawValue, status: 4, type : "DVR")
                if approvalStatus == 0
                {
                    toastText = getPopUpMsg(Flag: DCRFlag.attendance.rawValue, status: 5, type : "DVR")
                }
                showToastView(toastText: toastText)
            }
        }
    }
    
    private func updateTPStatus(approvalStatus : Int)
    {
        userObj.approvalStatus = approvalStatus
        
       
        BL_Approval.sharedInstance.updateTpStatus(userList : [userObj] ,userObj: userObj, reason: condenseWhitespace(stringValue: popUpView.reasonTxtView.text)) { (apiResponseObject) in
            if apiResponseObject.Status == SERVER_SUCCESS_CODE
            {
                var toastText = getPopUpMsg(Flag: DCRFlag.attendance.rawValue, status: DCRStatus.approved.rawValue, type : "PR")
                if approvalStatus == 0
                {
                    toastText = getPopUpMsg(Flag: DCRFlag.attendance.rawValue, status: DCRStatus.unApproved.rawValue, type : "PR")
                }
                showToastView(toastText: toastText)
                _ = self.navigationController?.popViewController(animated: false)
            }
            else
            {
                var toastText = getPopUpMsg(Flag: DCRFlag.attendance.rawValue, status: 4, type : "PR")
                if approvalStatus == 0
                {
                    toastText = getPopUpMsg(Flag: DCRFlag.attendance.rawValue, status: 5, type : "PR")
                }
                showToastView(toastText: toastText)
            }
        }
    }
    
    func getWorkPlaceListModel(dict : NSDictionary) -> [StepperWorkPlaceModel]
    {
        var workPlaceObj : StepperWorkPlaceModel  = StepperWorkPlaceModel()
        var workPlaceList : [StepperWorkPlaceModel] = []
        var workCategory : String = ""
        var workPlace : String = ""
        var workStartTime : String = ""
        var workToTime : String = ""
        
        workPlaceObj.key = "Work Category"
        
        workCategory = checkNullAndNilValueForString(stringData: dict.object(forKey: "Category_Name") as? String)
        
        if ifIsComingFromTpPage
        {
            workCategory = checkNullAndNilValueForString(stringData: dict.object(forKey: "Category") as? String)
        }
        
        if workCategory == ""
        {
            workCategory = NOT_APPLICABLE
        }
        
        workPlaceObj.value = workCategory
        workPlaceList.append(workPlaceObj)
        
        workPlaceObj = StepperWorkPlaceModel()
        workPlaceObj.key = "Work Place"
        
        workPlace = checkNullAndNilValueForString(stringData: dict.object(forKey: "Place_Worked") as? String)
        
        if ifIsComingFromTpPage
        {
            workPlace = checkNullAndNilValueForString(stringData: dict.object(forKey: "Work_Area") as? String)
        }
        
        
        if workPlace == ""
        {
            workPlace = NOT_APPLICABLE
        }
        
        workPlaceObj.value = workPlace
        workPlaceList.append(workPlaceObj)
        
        if !ifIsComingFromTpPage
        {
            workPlaceObj = StepperWorkPlaceModel()
            workPlaceObj.key = "Work Time"
            
            workStartTime = checkNullAndNilValueForString(stringData: dict.object(forKey: "Start_Time") as? String)
            
            if workStartTime == ""
            {
                workStartTime = NOT_APPLICABLE
            }
            
            workToTime = checkNullAndNilValueForString(stringData: dict.object(forKey: "End_Time") as? String)
            
            if workToTime == ""
            {
                workToTime = NOT_APPLICABLE
            }
            
            workPlaceObj.value = "\(workStartTime) - \(workToTime)"
            workPlaceList.append(workPlaceObj)
            
            //unapproveReason
            workPlaceObj = StepperWorkPlaceModel()
            workPlaceObj.key = BL_Approval.getTextForReason()
            
            var unapproveReason = checkNullAndNilValueForString(stringData: dict.object(forKey: "Unapprove_Reason") as? String)
            
            if unapproveReason == ""
            {
                unapproveReason = NOT_APPLICABLE
            }
            else
            {
                unapproveReason = BL_Approval.sharedInstance.getTrimmedTextForUnapproveReason(reason: unapproveReason)
            }
            
            workPlaceObj.value = unapproveReason
            workPlaceList.append(workPlaceObj)
            
            //Remarks
            workPlaceObj = StepperWorkPlaceModel()
            workPlaceObj.key = "General Remarks"
            
            var generalRemarks : String = checkNullAndNilValueForString(stringData: dict.object(forKey: "DCR_General_Remarks") as? String)
            
            if generalRemarks == ""
            {
                generalRemarks = NOT_APPLICABLE
            }
            else
            {
                generalRemarks = BL_Approval.sharedInstance.getTrimmedTextForGeneralRemarks(text: generalRemarks)
            }
            
            workPlaceObj.value = generalRemarks
            workPlaceList.append(workPlaceObj)
        }
        
        return workPlaceList
    }
    
    private func addCustomBackButtonToNavigationBar()
    {
        let backButton = UIButton(type: UIButtonType.custom)
        
        backButton.addTarget(self, action: #selector(self.backButtonClicked), for: UIControlEvents.touchUpInside)
        backButton.setImage(UIImage(named: "navigation-arrow"), for: .normal)
        backButton.sizeToFit()
        
        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func backButtonClicked()
    {
        _ = navigationController?.popViewController(animated: false)
    }
    
    //MARK:- Adding Custom View Tour Planner button
    private func addCustomViewTPButtonToNavigationBar()
    {
        let ViewTPButton = UIButton(type: UIButtonType.custom)
        
        ViewTPButton.addTarget(self, action: #selector(self.ViewTPButtonClicked), for: UIControlEvents.touchUpInside)
        ViewTPButton.titleLabel?.font = UIFont(name: fontSemiBold, size: 15.0)
        ViewTPButton.setTitle("View PR", for: .normal)
        
        ViewTPButton.sizeToFit()
        
        let rightBarButtonItem = UIBarButtonItem(customView: ViewTPButton)
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func ViewTPButtonClicked()
    {
        if tpUserObj != nil
        {
            self.setNavigationToTpReport(detailObj: tpUserObj)
        }
        else
        {
            showToastView(toastText: "No PR(s) available")
        }
    }
    
    //MARK:- Navigate To TP Reports
    func setNavigationToTpReport(detailObj : ApprovalUserMasterModel)
    {
        let date = convertDateIntoString(dateString: detailObj.Actual_Date)
        BL_TpReport.sharedInstance.tpDate = date
        BL_TpReport.sharedInstance.tpId = 0
        BL_TpReport.sharedInstance.tpId = userObj.Activity_Id
        
        //Setting HeaderDetails in UserObj
        userObj.Entered_Date = convertDateIntoDisplayFormat(date: getDateStringInFormatDate(dateString: detailObj.Entered_Date , dateFormat: defaultServerDateFormat))
        userObj.Actual_Date = convertDateIntoDisplayFormat(date: getDateStringInFormatDate(dateString: detailObj.Actual_Date , dateFormat: defaultServerDateFormat))
        userObj.Activity = detailObj.Activity
        userObj.approvalStatus = detailObj.approvalStatus
        userObj.Activity = detailObj.Activity
        
        let sb = UIStoryboard(name: Constants.StoaryBoardNames.TpReportSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.TpReportDetailsVcID) as! TpReportDetailsViewController
        vc.userObj = userObj
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Get TP for DCR date
    func getUserTpList()
    {
        var userPerDayList : [ApprovalUserMasterModel] = []
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: "Loading...")
            BL_Reports.sharedInstance.getTpHeaderDetailsDataForDCRApproval(userObj: userObj, completion: { (apiResponseObj) in
                removeCustomActivityView()
                if apiResponseObj.Status == SERVER_SUCCESS_CODE
                {
                    if apiResponseObj.list.count > 0
                    {
                        userPerDayList = BL_Approval.sharedInstance.convertTPHeaderToCommonModel(list: apiResponseObj.list)
                        if userPerDayList.count > 0
                        {
                            self.tpUserObj = userPerDayList[0]
                        }
                    }
                }
                else
                {
                    showToastView(toastText: "Check your network and try again")
                    
                }
            })
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
}
