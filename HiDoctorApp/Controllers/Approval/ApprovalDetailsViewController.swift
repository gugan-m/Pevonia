//
//  ApprovalDetailsViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 31/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

protocol SelectedDoctorDetailsDelegate
{
    func getSelectedDoctorDetails(dcrCode : String , doctorVisitCode : String, entityType : String)
}


class ApprovalDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,ApprovalPopUpDelegate,SelectedDoctorDetailsDelegate
{
    
    //MARK:-- Outlet
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var lowerHeaderLbl: UILabel!
    @IBOutlet weak var lowerLblHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var headerViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var bottomViewHgtConst: NSLayoutConstraint!
    @IBOutlet weak var bottomView: CornerRadiusWithShadowView!
    @IBOutlet weak var approveBtnWidthConst: NSLayoutConstraint!
    
    //MARK:-- Variable Declaration
    var approvalDataList : [ApprovalTableListModel] = []
    var userObj : ApprovalUserMasterModel!
    var tpUserObj : ApprovalUserMasterModel!
    var ifIsComingFromTpPage : Bool = false
    var isCmngFromReportPage : Bool = false
    var isCmngFromRejectPage : Bool = false
    var isMine : Bool = false
    var isCmngFromApprovalPage : Bool = false
    var popUpView : ApprovalPoPUp!
    var delegate : SaveActionToastDelegate?
    var convertedToHourlyReport : [HourlyReportDoctorVisitModel] = []
    var convertedChemistToHourlyReport : [HourlyReportDoctorVisitModel] = []
    var convertedStockistToHourlyReport : [HourlyReportDoctorVisitModel] = []
    
    //MARK:- Viewcontroller LifeCycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.setHeaderDetails()
        addBackButtonView()
        if isCmngFromApprovalPage && ifIsComingFromTpPage == false
        {
            self.addCustomViewTPButtonToNavigationBar()
        }
        self.approvalDataList = []
        self.startApiCall()
        let strCheckForLeave = UserDefaults.standard.string(forKey: "IsFromLeaveApprovalCheckBox")
        
        if (strCheckForLeave == "0")
        {
        
        UserDefaults.standard.set("", forKey: "IsFromLeaveApprovalCheckBox")
        UserDefaults.standard.synchronize()
        
        }
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func dismissKeyboard()
    {
        self.view.endEditing(true)
    }

    //MARK:- Setting header details
    func setHeaderDetails()
    {
        let activityType = "Field"
        var dcrStatus : String = ""
        var actualDate : String = userObj.Actual_Date
        var headerText : String = ""
        
        if actualDate == ""
        {
            actualDate = NOT_APPLICABLE
        }
        else
        {
            var entryDate : Date = Date()
            if !ifIsComingFromTpPage
            {
                entryDate = getDateStringInFormatDate(dateString: actualDate , dateFormat : "dd-MMM-yyyy")
            }
            else
            {
                entryDate = getStringInFormatDate(dateString: actualDate)
            }
            
            actualDate = convertDateIntoString(date: entryDate)
        }
        
        if !isCmngFromReportPage && !isCmngFromRejectPage
        {
            dcrStatus = applied
        }
        else if isCmngFromReportPage && isMine
        {
            dcrStatus = BL_Approval.sharedInstance.getDCRStatus(dcrStatus: userObj.DCR_Status)
        }
        
        
        if isCmngFromRejectPage
        {
            self.approveBtnWidthConst.constant = 0
        }
        
        if dcrStatus != ""
        {
            headerText = "\(activityType) - \(actualDate) | \(dcrStatus)"
        }
        else
        {
            headerText = "\(activityType) - \(actualDate)"
        }
        let employeeName = userObj.Employee_Name as String
        if isCmngFromApprovalPage && ifIsComingFromTpPage == false
        {
            self.title = "\(PEV_DCR) Approval"
            self.headerLbl.text = "\(employeeName)"
            self.lowerHeaderLbl.text = headerText
            self.lowerLblHeightConstant.constant = 18
            self.headerViewHeightConstant.constant = 60
        }
        else
        {
            self.headerLbl.text = headerText
            self.lowerLblHeightConstant.constant = 0
            self.headerViewHeightConstant.constant = 30
            self.title = "\(employeeName)"
        }
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
        
    }
    
    //MARK:- TableView delegate
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return approvalDataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        let approvalObj = approvalDataList[section]
        
        if approvalObj.dataList.count > 0
        {
            if approvalObj.sectionViewType == SectionHeaderType.DoctorVisit || approvalObj.sectionType == TpSectionHeaderType.DoctorVisit || approvalObj.sectionViewType == SectionHeaderType.ChemistVisit || approvalObj.sectionViewType == SectionHeaderType.Stockiest
            {
                return 47
            }
        }
        return 38
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.ApprovalSectionHeaderCell) as! ApprovalSectionHeaderCell
        let approvalObj = approvalDataList[section]
        cell.titleLabel.text = approvalObj.sectionTitle
        cell.subTitleLabel.text = ""
        cell.sectionImgWidthConst.constant = 30
        cell.viewOnMap.isHidden = true
        if(isCmngFromApprovalPage)
        {
            if approvalObj.dataList.count > 0
            {
                if approvalObj.sectionViewType == SectionHeaderType.DoctorVisit || approvalObj.sectionType == TpSectionHeaderType.DoctorVisit
                {
                    cell.subTitleLabel.text = "\(approvalObj.dataList.count) \(appDoctor) Visits"
                    if(self.convertedToHourlyReport.count > 0)
                    {
                        cell.viewOnMap.isHidden = false
                        cell.viewOnMap.addTarget(self, action: #selector(self.viewOnDoctorMap), for: .touchUpInside)
                    }
                }
                else if approvalObj.sectionViewType == SectionHeaderType.ChemistVisit
                {
                    cell.subTitleLabel.text = "\(approvalObj.dataList.count) \(appChemist) Visits"
                    if(self.convertedChemistToHourlyReport.count > 0)
                    {
                        cell.viewOnMap.isHidden = false
                        cell.viewOnMap.addTarget(self, action: #selector(self.viewOnChemistMap), for: .touchUpInside)
                    }

                }
                else if approvalObj.sectionViewType == SectionHeaderType.Stockiest
                {
                    cell.subTitleLabel.text = "\(approvalObj.dataList.count) \(appStockiest) Visits"
                    if(self.convertedStockistToHourlyReport.count > 0)
                    {
                        cell.viewOnMap.isHidden = false
                        cell.viewOnMap.addTarget(self, action: #selector(self.viewOnStockistMap), for: .touchUpInside)
                    }
                    
                }
                
                
                
            }
            
        }
        let icon = approvalObj.titleImage
        cell.imgView.image = UIImage(named:icon)
        
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
        let defaultHeight : CGFloat = 10
        
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
            return BL_Approval.sharedInstance.getEmptyStateCellHeight()
        }
        else
        {
            if approvalDetail.sectionViewType == SectionHeaderType.Travel || approvalDetail.sectionType == TpSectionHeaderType.Travel
            {
                return BL_Approval.sharedInstance.getSFCCellHeight(dataList: dataList) + defaultHeight
            }
            else if approvalDetail.sectionViewType == SectionHeaderType.DoctorVisit
            {
                return BL_Approval.sharedInstance.getDoctorVisitCellHeight(dataList: dataList, type: 1) + defaultHeight
            }
            else if approvalDetail.sectionViewType == SectionHeaderType.ChemistVisit
            {
                return BL_Approval.sharedInstance.geChemistVisitCellHeight(dataList: dataList, type: 1) + defaultHeight
            }
            else if approvalDetail.sectionViewType == SectionHeaderType.Stockiest
            {
                return BL_Approval.sharedInstance.geStockistVisitCellHeight(dataList: dataList, type: 1) + defaultHeight
            }
            else if approvalDetail.sectionType == TpSectionHeaderType.DoctorVisit
            {
                return BL_Approval.sharedInstance.getDoctorVisitCellHeight(dataList: dataList, type: 2) + defaultHeight
            }
            else if approvalDetail.sectionViewType == SectionHeaderType.WorkPlace || approvalDetail.sectionType == TpSectionHeaderType.WorkPlace
            {
                
                let dataList  = getWorkPlaceListModel(dict: approvalDetail.dataList.firstObject as! NSDictionary)
                return BL_Approval.sharedInstance.getCommonHeightforWorkPlaceDetails(dataList: dataList) + defaultHeight
            }
            else
            {
                var sectionType : Int = 0
                
                if ifIsComingFromTpPage
                {
                    sectionType = approvalDetail.sectionType.rawValue
                }
                else
                {
                    sectionType = approvalDetail.sectionViewType.rawValue
                }
                
                
                if approvalDetail.sectionType == TpSectionHeaderType.Product
                {
                    sectionType = 7
                }
                
                return BL_Approval.sharedInstance.getCommonCellHeight(dataList: approvalDetail.dataList , sectionType:sectionType) + defaultHeight
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let approvalDetail = approvalDataList[indexPath.section]
        
        if approvalDetail.currentAPIStatus == APIStatus.Loading && !isMine
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.ApprovalLoadingCell, for: indexPath) as!  ApprovalLoadingTableViewCell
            cell.activityIndicator.startAnimating()
            return cell
        }
        else if approvalDetail.currentAPIStatus == APIStatus.Failed
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.ApprovalEmptyStateRetryCell, for: indexPath)
            return cell
        }
        else if approvalDetail.dataList.count == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.ApprovalEmptyStateCell, for: indexPath) as! ApprovalEmptyStateTableViewCell
            cell.emptyStateTiltleLbl.text = approvalDetail.emptyStateText
            return cell
        }
        else
        {
            let approvalCell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.ApprovalInnerTableCell, for: indexPath) as! ApprovalInnerTableViewCell
            approvalCell.dataList = approvalDetail.dataList
            
            if approvalDetail.sectionViewType == SectionHeaderType.WorkPlace || approvalDetail.sectionType == TpSectionHeaderType.WorkPlace
            {
                approvalCell.workPlaceList = getWorkPlaceListModel(dict: approvalCell.dataList.firstObject as! NSDictionary)
            }
            
            approvalCell.sectionType = approvalDetail.sectionViewType
            approvalCell.isCmngFromReportPage = isCmngFromReportPage
            approvalCell.isMine = isMine
            
            if ifIsComingFromTpPage
            {
                approvalCell.tpSectionType = approvalDetail.sectionType
            }
            
            approvalCell.tableView.layer.cornerRadius = 0
            approvalCell.shadowView.isHidden = true
            
            if approvalDetail.sectionViewType == SectionHeaderType.DoctorVisit || approvalDetail.sectionType == TpSectionHeaderType.DoctorVisit || approvalDetail.sectionViewType == SectionHeaderType.ChemistVisit || approvalDetail.sectionViewType == SectionHeaderType.Stockiest
            {
                approvalCell.tableView.layer.cornerRadius = 4
                approvalCell.shadowView.isHidden = false
            }
            
            if indexPath.section == approvalDataList.count
            {
                approvalCell.sepHeightConst.constant = 0
            }
            
            approvalCell.delegate = self
            approvalCell.tableView.reloadData()
            
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
                self.setTpApiCall(indexPath:indexPath.section)
            }
            else
            {
                self.setDCRApiCall(indexPath: indexPath.section)
            }
        }
    }
    
    //MARK:- Set DCR and TP API Calls
    func setDCRApiCall(indexPath : Int)
    {
        switch indexPath
        {
        case 0:
            getDCRAccompanistData()
        case 1:
            getDCRWorkPlaceDetails()
        case 2:
            getDCRTravelledDetails()
        case 3:
            getDCRDoctorVisitDetailsForUserPerday()
        case 4:
            getDCRChemistVisitDetailsForUserPerday()
        case 5:
            getDCRStockiestsVisitDetails()
        case 6:
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
            getTpAccompanistData()
        case 1:
            getTpWorkPlaceDetails()
        case 2:
            getTpTravelledDetails()
        case 3:
            getTpDoctorVisitDetailsForUserPerday()
        case 4:
            getTpProducts()
        default:
            print("")
        }
    }
    
    //MARK:- Reload tableView
    func reloadTableView()
    {
        self.tableView.reloadData()
    }
    
    //MARK:- Setting DCR and TP ApprovalList
    func setDCRApprovalList()
    {
        self.approvalDataList = BL_Approval().getDCRApprovalDataList()
    }
    
    func setTpApprovalList()
    {
        self.approvalDataList = BL_Approval.sharedInstance.getTpApprovalDataList()
    }
    
    //MARK:- StartAPICall
    func startApiCall()
    {
        if ifIsComingFromTpPage
        {
            self.tpApprovalApiCall()
        }
        else
        {
            dcrApprovalApiCall()
            if isCmngFromApprovalPage && ifIsComingFromTpPage == false
            {
                getUserTpList()
            }
        }
    }
    
    //MARK:- DCR Approval Api Calls
    func dcrApprovalApiCall()
    {
        setDCRApprovalList()
        
        if isMine && isCmngFromReportPage
        {
            self.setDCRAppliedList()
        }
        else
        {
            if checkInternetConnectivity()
            {
                getDCRAccompanistData()
                getDCRWorkPlaceDetails()
                getDCRTravelledDetails()
                getDCRDoctorVisitDetailsForUserPerday()
                getDCRChemistVisitDetailsForUserPerday()
                getDCRStockiestsVisitDetails()
                getDCRExpenseDetails()
            }
            else
            {
                self.setToastText(sectionType: -1)
            }
        }
    }
    
    func getDCRAccompanistData()
    {
        self.approvalDataList[0].dataList = []
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getDCRAccompanistsDetails(userObj:userObj) { (apiResponseObject) in
                if apiResponseObject.Status == SERVER_SUCCESS_CODE
                {
                    self.approvalDataList[0].currentAPIStatus = APIStatus.Success
                    if apiResponseObject.list.count > 0
                    {
//                        let predicate = NSPredicate(format: "Is_Only_For_Doctor == %@","0")
//                        let filteredArray = apiResponseObject.list.filtered(using: predicate)
//                        if filteredArray.count > 0
//                        {
//                            self.approvalDataList[0].dataList = filteredArray as NSArray
//                        }
                        if apiResponseObject.list.count > 0
                        {
                            self.approvalDataList[0].dataList = apiResponseObject.list as NSArray
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
            self.setToastText(sectionType: SectionHeaderType.Accompanists.rawValue)
        }
    }
    
    func getDCRWorkPlaceDetails()
    {
        self.approvalDataList[1].dataList = []
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getDCRWorkPlaceDetails(userObj:userObj) { (apiResponseObject) in
                if apiResponseObject.Status == SERVER_SUCCESS_CODE
                {
                    self.approvalDataList[1].currentAPIStatus = APIStatus.Success
                    if apiResponseObject.list.count > 0
                    {
                        self.approvalDataList[1].dataList = apiResponseObject.list
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
                    self.approvalDataList[1].currentAPIStatus = APIStatus.Failed
                }
                self.reloadTableView()
            }
        }
        else
        {
            self.setToastText(sectionType: SectionHeaderType.WorkPlace.rawValue)
        }
    }
    
    func getDCRTravelledDetails()
    {
        self.approvalDataList[2].dataList = []
        
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getDCRTravelledDetails(userObj:userObj) { (apiResponseObject) in
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
            self.setToastText(sectionType: SectionHeaderType.Travel.rawValue)
        }
    }
    
    func getDCRDoctorVisitDetailsForUserPerday()
    {
        
        self.approvalDataList[3].dataList = []
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getDCRDoctorVisitDetailsForUserPerday(userObj:userObj) { (apiResponseObject) in
                if apiResponseObject.Status == SERVER_SUCCESS_CODE
                {
                    self.approvalDataList[3].currentAPIStatus = APIStatus.Success
                    if apiResponseObject.list.count > 0
                    {
                        self.approvalDataList[3].dataList = apiResponseObject.list
                        self.approvalDataList[3].rowHeight = BL_Approval.sharedInstance.getDoctorVisitCellHeight(dataList: self.approvalDataList[3].dataList, type : 1)
                    }
                }
                else
                {
                    self.approvalDataList[3].currentAPIStatus = APIStatus.Failed
                }
                self.HourlyReportConvert(entityName:Constants.CustomerEntityType.doctor)
                self.reloadTableView()
            }
        }
        else
        {
            self.setToastText(sectionType: SectionHeaderType.DoctorVisit.rawValue)
        }
    }
    func getDCRChemistVisitDetailsForUserPerday()
    {
        self.approvalDataList[4].dataList = []
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getDCRChemistVisitDetailsForUserPerday(userObj:userObj) { (apiResponseObject) in
                if apiResponseObject.Status == SERVER_SUCCESS_CODE
                {
                    self.approvalDataList[4].currentAPIStatus = APIStatus.Success
                    if apiResponseObject.list.count > 0
                    {
                        self.approvalDataList[4].dataList = BL_Reports.sharedInstance.getCombinedChemistVisitDetails(responseList: apiResponseObject.list) //apiResponseObject.list
                        self.approvalDataList[4].rowHeight = BL_Approval.sharedInstance.geChemistVisitCellHeight(dataList: self.approvalDataList[4].dataList, type : 1)
                    }
                }
                else
                {
                    self.approvalDataList[4].currentAPIStatus = APIStatus.Failed
                }
               if self.userObj.actualDate != nil
               {
                BL_HourlyReport.sharedInstance.getGeoDCRChemistVisitDetailsApproval(userObj:self.userObj, status: "ALL", completion: { (objApiResponse) in
                    if (objApiResponse.Status == SERVER_SUCCESS_CODE)
                    {
                        self.chemistHourlyReportConvert(arrayList: objApiResponse.list)
                    }
                    self.reloadTableView()
                })
                
                }
                
            }
        }
        else
        {
            self.setToastText(sectionType: SectionHeaderType.DoctorVisit.rawValue)
        }
 
    }
    func getDCRStockiestsVisitDetails()
    {
        self.approvalDataList[5].dataList = []
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getDCRStockiestsVisitDetails(userObj:userObj) { (apiResponseObject) in
                if apiResponseObject.Status == SERVER_SUCCESS_CODE
                {
                    self.approvalDataList[5].currentAPIStatus = APIStatus.Success
                    if apiResponseObject.list.count > 0
                    {
                        self.approvalDataList[5].dataList = apiResponseObject.list
                    }
                }
                else
                {
                    self.approvalDataList[5].currentAPIStatus = APIStatus.Failed
                }
                if self.userObj.actualDate != nil
                {
                    BL_HourlyReport.sharedInstance.getGeoDCRStockistVisitDetailsApproval(userObj:self.userObj, status: "ALL", completion: { (objApiResponse) in
                        if (objApiResponse.Status == SERVER_SUCCESS_CODE)
                        {
                            self.stockistHourlyReportConvert(arrayList: objApiResponse.list)
                        }
                    })
                }
                self.reloadTableView()
            }
        }
        else
        {
            self.setToastText(sectionType: SectionHeaderType.Stockiest
                .rawValue)
        }
    }
    
    func getDCRExpenseDetails()
    {
        self.approvalDataList[6].dataList = []
        
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getDCRExpenseDetails(userObj:userObj) { (apiResponseObject) in
                if apiResponseObject.Status == SERVER_SUCCESS_CODE
                {
                    self.approvalDataList[6].currentAPIStatus = APIStatus.Success
                    if apiResponseObject.list.count > 0
                    {
                        self.approvalDataList[6].dataList = apiResponseObject.list
                    }
                }
                else
                {
                    self.approvalDataList[6].currentAPIStatus = APIStatus.Failed
                }
                self.reloadTableView()
            }
        }
        else
        {
            self.setToastText(sectionType: SectionHeaderType.Expense.rawValue)
        }
    }
    
    
    //MARK:- Tp Approval Api Calls
    func tpApprovalApiCall()
    {
        setTpApprovalList()
        
        if checkInternetConnectivity()
        {
            getTpAccompanistData()
            getTpWorkPlaceDetails()
            getTpTravelledDetails()
            getTpDoctorVisitDetailsForUserPerday()
            getTpProducts()
        }
        else
        {
            self.setToastText(sectionType: -1)
        }
    }
    
    func getTpAccompanistData()
    {
        self.approvalDataList[0].dataList = []
        
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getTpAccompanistData(userObj:userObj) { (apiResponseObject) in
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
            self.setToastText(sectionType: SectionHeaderType.Accompanists.rawValue)
        }
    }
    
    func getTpWorkPlaceDetails()
    {
        self.approvalDataList[1].dataList = []
        
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getTpWorkPlaceDetailsData(userObj:userObj) { (apiResponseObject) in
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
            self.setToastText(sectionType: SectionHeaderType.WorkPlace.rawValue)
        }
        
    }
    
    func getTpTravelledDetails()
    {
        self.approvalDataList[2].dataList = []
        
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getTpTravelledDetails(userObj:userObj) { (apiResponseObject) in
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
            self.setToastText(sectionType: SectionHeaderType.Travel.rawValue)
        }
        
    }
    
    func getTpDoctorVisitDetailsForUserPerday()
    {
        self.approvalDataList[3].dataList = []
        
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getDoctorVisitDetailsData(userObj:userObj) { (apiResponseObject) in
                if apiResponseObject.Status == SERVER_SUCCESS_CODE
                {
                    self.approvalDataList[3].currentAPIStatus = APIStatus.Success
                    if apiResponseObject.list.count > 0
                    {
                        self.approvalDataList[3].dataList = apiResponseObject.list
                        self.approvalDataList[3].rowHeight = BL_Approval.sharedInstance.getDoctorVisitCellHeight(dataList: self.approvalDataList[3].dataList, type :2)
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
            self.setToastText(sectionType: SectionHeaderType.DoctorVisit.rawValue)
        }
        
    }
    
    func getTpProducts()
    {
        self.approvalDataList[4].dataList = []
        
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getTourPlannerProduct(userObj:userObj) { (apiResponseObject) in
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
            showToastView(toastText: "Problem in getting product details")
        }
    }
    
    
    func getDoctorVisitDetails(dict : NSDictionary) -> CGFloat
    {
        var doctorDetails : String  = ""
        var lblHeight : CGFloat = 0
        let mdlNumber = checkNullAndNilValueForString(stringData: dict.object(forKey: "MDL_Number") as? String)
        if mdlNumber != ""
        {
           // doctorDetails = "MDL NO : \(mdlNumber)"
        }
        
        let hospitalName : String = checkNullAndNilValueForString(stringData: dict.object(forKey: "Hospital_Name") as? String)
        if hospitalName != ""
        {
            doctorDetails = doctorDetails + "|" + hospitalName
        }
        
        let specialityName : String = checkNullAndNilValueForString(stringData: dict.object(forKey: "Speciality_Name") as? String)
        if specialityName != ""
        {
            doctorDetails = doctorDetails + "|" + specialityName
        }
        
        let categoryName : String = checkNullAndNilValueForString(stringData: dict.object(forKey: "Category_Name") as? String)
        if categoryName != ""
        {
            doctorDetails = doctorDetails + "|" + categoryName
        }
        
        let regionName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Region_Name") as? String)
        if regionName != ""
        {
            doctorDetails = doctorDetails + "|" + regionName
        }
        
        lblHeight = getTextSize(text: doctorDetails, fontName: fontRegular, fontSize: 12, constrainedWidth: SCREEN_WIDTH - 80).height
        
        return lblHeight
    }
    
    //MARK:- Offline List
    func setDCRAppliedList()
    {
        self.approvalDataList[0].dataList = BL_Reports.sharedInstance.getAccompanistDetails()
        self.approvalDataList[1].dataList = BL_Reports.sharedInstance.getWorkPlaceDetails()
        self.approvalDataList[2].dataList = BL_Reports.sharedInstance.getDCRSFCDetails()
        self.approvalDataList[3].dataList = BL_Reports.sharedInstance.getDCRDoctorDetails()
        self.approvalDataList[4].dataList = BL_Reports.sharedInstance.getDCRChemistsDetails()
        self.approvalDataList[5].dataList = BL_Reports.sharedInstance.getDCRStockiestsDetails()
        self.approvalDataList[6].dataList = BL_Reports.sharedInstance.getDCRExpenseDetails()
        self.approvalDataList[0].currentAPIStatus = APIStatus.Success
        self.approvalDataList[1].currentAPIStatus = APIStatus.Success
        self.approvalDataList[2].currentAPIStatus = APIStatus.Success
        self.approvalDataList[3].currentAPIStatus = APIStatus.Success
        self.approvalDataList[4].currentAPIStatus = APIStatus.Success
        self.approvalDataList[5].currentAPIStatus = APIStatus.Success
        self.approvalDataList[6].currentAPIStatus = APIStatus.Success
        
        self.tableView.reloadData()
    }
    
    //MARK:- Update Status
    @objc func viewOnChemistMap() {
        
        let sb = UIStoryboard(name: Constants.StoaryBoardNames.HourlyReportSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.HourlyReportGoogleMapViewVc) as! HourlyReportGoogleMapViewController
        vc.doctorListWithLocations = convertedChemistToHourlyReport
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func viewOnStockistMap() {
        
        let sb = UIStoryboard(name: Constants.StoaryBoardNames.HourlyReportSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.HourlyReportGoogleMapViewVc) as! HourlyReportGoogleMapViewController
        vc.doctorListWithLocations = convertedStockistToHourlyReport
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func viewOnDoctorMap() {
        
        let sb = UIStoryboard(name: Constants.StoaryBoardNames.HourlyReportSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.HourlyReportGoogleMapViewVc) as! HourlyReportGoogleMapViewController
        vc.doctorListWithLocations = convertedToHourlyReport
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func chemistHourlyReportConvert(arrayList:NSArray)
    {
        self.convertedChemistToHourlyReport = convertToHourlyReport2(chemistDatas: arrayList)
    }
    
    func stockistHourlyReportConvert(arrayList:NSArray)
    {
        self.convertedStockistToHourlyReport = convertToHourlyReport1(stockistDatas: arrayList)
    }
    
    
    func HourlyReportConvert(entityName : String)
    {
        if entityName == Constants.CustomerEntityType.doctor
        {
            self.convertedToHourlyReport =  convertToHourlyReport(doctorDatas: approvalDataList[3].dataList)
        }
        else if entityName == Constants.CustomerEntityType.chemist
        {
            self.convertedChemistToHourlyReport = convertToHourlyReport2(chemistDatas: approvalDataList[4].dataList)
        }
        else if entityName == Constants.CustomerEntityType.stockist
        {
            self.convertedStockistToHourlyReport = convertToHourlyReport1(stockistDatas: approvalDataList[5].dataList)
        }
    }
    
    func convertToHourlyReport(doctorDatas : NSArray)->[HourlyReportDoctorVisitModel]
    {
        
        var hourlyObjs : [HourlyReportDoctorVisitModel] = []
        for doctorData in doctorDatas
        {
            let hourlyObj : HourlyReportDoctorVisitModel = HourlyReportDoctorVisitModel()
            hourlyObj.Doctor_Name = checkNullAndNilValueForString(stringData: (doctorData as AnyObject).value(forKey: "Doctor_Name") as? String)
            hourlyObj.Doctor_Code = checkNullAndNilValueForString(stringData: (doctorData as AnyObject).value(forKey: "Doctor_Code") as? String)
            hourlyObj.Speciality_Name = checkNullAndNilValueForString(stringData: (doctorData as AnyObject).value(forKey: "Speciality_Name") as? String)
            hourlyObj.MDL_Number = checkNullAndNilValueForString(stringData: (doctorData as AnyObject).value(forKey: "MDL_Number") as? String)
            hourlyObj.Category_Name = checkNullAndNilValueForString(stringData: (doctorData as AnyObject).value(forKey: "Category_Name") as? String)
            hourlyObj.Doctor_Region_Name = checkNullAndNilValueForString(stringData: (doctorData as AnyObject).value(forKey: "Doctor_Region_Name")as? String)
            hourlyObj.Local_Area = checkNullAndNilValueForString(stringData: (doctorData as AnyObject).value(forKey: "Local_Area") as? String)
            hourlyObj.Doctor_Name = checkNullAndNilValueForString(stringData: (doctorData as AnyObject).value(forKey: "Hospital_Name") as? String)
            
            hourlyObj.Customer_Entity_Type = "D"
            let latitude = checkNullAndNilValueForString(stringData: (doctorData as AnyObject).value(forKey: "Lattitude")as? String)
            if (latitude != EMPTY)
            {
                hourlyObj.Lattitude = Double(latitude)!
            }
            let longitude = checkNullAndNilValueForString(stringData:(doctorData as AnyObject).value(forKey: "Longitude") as? String)
            if (longitude != EMPTY)
            {
                hourlyObj.Longitude = Double(longitude)!
            }
            var visitTime = checkNullAndNilValueForString(stringData: (doctorData as AnyObject).value(forKey: "Visit_Time") as? String)
            
            
            if (visitTime != EMPTY)
            {
                let time = visitTime.components(separatedBy: ":")
                if(Int(time[0])! <= 12)
                {
                    if (visitTime.range(of:"PM") == nil)  && (visitTime.range(of:"AM") == nil) && (visitTime.range(of:"am") == nil)  && (visitTime.range(of:"pm") == nil)
                    {
                        visitTime = visitTime + " " + checkNullAndNilValueForString(stringData: (doctorData as AnyObject).value(forKey: "Visit_Mode") as? String)
                    }
                }
                let dcrDate = convertDateIntoString(dateString: ((doctorData as AnyObject).value(forKey: "DCR_Actual_Date") as? String)!)
                let date = convertDateIntoString(date: dcrDate)
                let TwentyFourHrTime = convert12HrTo24Hr(timeString: visitTime)
                let enteredDateTime = date + " " + visitTime
                
                hourlyObj.Entered_DateTime = enteredDateTime
                hourlyObj.Time = getDateAndTimeInFormat(dateString: ((doctorData as AnyObject).value(forKey: "DCR_Actual_Date") as? String)! + " " + TwentyFourHrTime + ":00.000")
            }
            else
            {
                hourlyObj.Entered_DateTime = NOT_APPLICABLE
                hourlyObj.Time = nil
            }
            hourlyObj.SyncUp_DateTime = EMPTY
            hourlyObj.Doctor_Address = EMPTY
            hourlyObj.Doctor_Region_Code = checkNullAndNilValueForString(stringData:doctorDatas.value(forKey: "Doctor_Region_Code") as? String)
            if(hourlyObj.Lattitude != 0.0 || hourlyObj.Lattitude != 0 || hourlyObj.Longitude != 0.0 || hourlyObj.Longitude != 0 )
            {
                hourlyObjs.append(hourlyObj)
            }
        }
        
        return hourlyObjs
    }
    
   
    func convertToHourlyReport2(chemistDatas : NSArray)->[HourlyReportDoctorVisitModel]
    {
        var hourlyObjs : [HourlyReportDoctorVisitModel] = []
        for chemsitData in chemistDatas
        {
            let hourlyObj : HourlyReportDoctorVisitModel = HourlyReportDoctorVisitModel()
            hourlyObj.Doctor_Name = checkNullAndNilValueForString(stringData: (chemsitData as AnyObject).value(forKey: "Chemist_Name") as? String)
            hourlyObj.Doctor_Code = checkNullAndNilValueForString(stringData: (chemsitData as AnyObject).value(forKey: "Chemist_Code") as? String)
            hourlyObj.MDL_Number = checkNullAndNilValueForString(stringData: (chemsitData as AnyObject).value(forKey: "Chemists_MDL_Number") as? String)
            hourlyObj.Doctor_Region_Name = checkNullAndNilValueForString(stringData: (chemsitData as AnyObject).value(forKey: "Region_Name")as? String)
            hourlyObj.Customer_Entity_Type = "C"
            let latitude = checkNullAndNilValueForString(stringData: (chemsitData as AnyObject).value(forKey: "Chemists_Visit_latitude")as? String)
            if (latitude != EMPTY)
            {
                hourlyObj.Lattitude = Double(latitude)!
            }
            let longitude = checkNullAndNilValueForString(stringData:(chemsitData as AnyObject).value(forKey: "Chemists_Visit_Longitude") as? String)
            if (longitude != EMPTY)
            {
                hourlyObj.Longitude = Double(longitude)!
            }
            var visitTime = checkNullAndNilValueForString(stringData: (chemsitData as AnyObject).value(forKey: "Visit_Time") as? String)
            
            
            if (visitTime != EMPTY)
            {
                let time = visitTime.components(separatedBy: ":")
                if(Int(time[0])! <= 12)
                {
                    if (visitTime.range(of:"PM") == nil)  && (visitTime.range(of:"AM") == nil)
                    {
                        visitTime = visitTime + " " + checkNullAndNilValueForString(stringData: (chemsitData as AnyObject).value(forKey: "Visit_Mode") as? String)
                    }
                }
                let dcrDate = convertDateIntoString(dateString: ((chemsitData as AnyObject).value(forKey: "DCR_Actual_Date") as? String)!)
                let date = convertDateIntoString(date: dcrDate)
                let TwentyFourHrTime = convert12HrTo24Hr(timeString: visitTime)
                let enteredDateTime = date + " " + visitTime
                
                hourlyObj.Entered_DateTime = enteredDateTime
                hourlyObj.Time = getDateAndTimeInFormat(dateString: ((chemsitData as AnyObject).value(forKey: "DCR_Actual_Date") as? String)! + " " + TwentyFourHrTime + ":00.000")
            }
            else
            {
                hourlyObj.Entered_DateTime = NOT_APPLICABLE
                hourlyObj.Time = nil
            }
            hourlyObj.SyncUp_DateTime = EMPTY
            hourlyObj.Doctor_Address = EMPTY
            if(hourlyObj.Lattitude != 0.0 || hourlyObj.Lattitude != 0 || hourlyObj.Longitude != 0.0 || hourlyObj.Longitude != 0 )
            {
                hourlyObjs.append(hourlyObj)
            }
        }
        return hourlyObjs
    }

    func convertToHourlyReport1(stockistDatas : NSArray)->[HourlyReportDoctorVisitModel]
    {
        var hourlyObjs : [HourlyReportDoctorVisitModel] = []
        for stockisttData in stockistDatas
        {
            let hourlyObj : HourlyReportDoctorVisitModel = HourlyReportDoctorVisitModel()
            hourlyObj.Doctor_Name = checkNullAndNilValueForString(stringData: (stockisttData as AnyObject).value(forKey: "Stockiest_Name") as? String)
            hourlyObj.Doctor_Code = checkNullAndNilValueForString(stringData: (stockisttData as AnyObject).value(forKey: "Stockiest_Code") as? String)
            hourlyObj.Customer_Entity_Type = "S"
//            hourlyObj.MDL_Number = checkNullAndNilValueForString(stringData: (chemsitData as AnyObject).value(forKey: "Chemists_MDL_Number") as? String)
//            hourlyObj.Doctor_Region_Name = checkNullAndNilValueForString(stringData: (chemsitData as AnyObject).value(forKey: "Region_Name")as? String)
            let latitude = checkNullAndNilValueForString(stringData: (stockisttData as AnyObject).value(forKey: "Latitude")as? String)
            if (latitude != EMPTY)
            {
                hourlyObj.Lattitude = Double(latitude)!
            }
            let longitude = checkNullAndNilValueForString(stringData:(stockisttData as AnyObject).value(forKey: "Longitude") as? String)
            if (longitude != EMPTY)
            {
                hourlyObj.Longitude = Double(longitude)!
            }
            var visitTime = checkNullAndNilValueForString(stringData: (stockisttData as AnyObject).value(forKey: "Visit_Time") as? String)
            
            
            if (visitTime != EMPTY)
            {
                let time = visitTime.components(separatedBy: ":")
                if(Int(time[0])! <= 12)
                {
                    if (visitTime.range(of:"PM") == nil)  && (visitTime.range(of:"AM") == nil)
                    {
                        visitTime = visitTime + " " + checkNullAndNilValueForString(stringData: (stockisttData as AnyObject).value(forKey: "Visit_Mode") as? String)
                    }
                }
                let dcrDate = convertDateIntoString(dateString: ((stockisttData as AnyObject).value(forKey: "DCR_Actual_Date") as? String)!)
                let date = convertDateIntoString(date: dcrDate)
                let TwentyFourHrTime = convert12HrTo24Hr(timeString: visitTime)
                let enteredDateTime = date + " " + visitTime
                
                hourlyObj.Entered_DateTime = enteredDateTime
                hourlyObj.Time = getDateAndTimeInFormat(dateString: ((stockisttData as AnyObject).value(forKey: "DCR_Actual_Date") as? String)! + " " + TwentyFourHrTime + ":00.000")
            }
            else
            {
                hourlyObj.Entered_DateTime = NOT_APPLICABLE
                hourlyObj.Time = nil
            }
            hourlyObj.SyncUp_DateTime = EMPTY
            hourlyObj.Doctor_Address = EMPTY
            if(hourlyObj.Lattitude != 0.0 || hourlyObj.Lattitude != 0 || hourlyObj.Longitude != 0.0 || hourlyObj.Longitude != 0 )
            {
                hourlyObjs.append(hourlyObj)
            }
        }
        return hourlyObjs
    }
    
    
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
        
       // var StrApproval : String = userObj.UnapprovalActivity
        popUpView = ApprovalPoPUp.loadNib()
        
        popUpView.frame = CGRect(x: (SCREEN_WIDTH - 250)/2 ,  y:  SCREEN_HEIGHT, width: 250, height: popUpView.approvalPopUpHeight)
        popUpView.delegate = self
        popUpView.tag = 9000
        popUpView.statusButtonType = type
        popUpView.userObj = userObj
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
    func addKeyBoardObserver()
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
    
    
    func setPopUpBtnAction(type : ApprovalButtonType)
    {
        self.removeKeyBoardObserver()
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
    
    private func updateDCRStatus(approvalStatus : Int)
    {
        userObj.approvalStatus = approvalStatus
        let strCheck = UserDefaults.standard.string(forKey: "ApprovalENABLED")
        
        if (strCheck == "0"){
            userObj.IsChecked = 0
        }else{
            userObj.IsChecked = 1
        }
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: "Updating..")
            BL_Approval.sharedInstance.updateDCRStatus(userList : [userObj] ,userObj: userObj, reason: condenseWhitespace(stringValue: popUpView.reasonTxtView.text)) { (apiResponseObject) in
                removeCustomActivityView()
                
                if apiResponseObject.Status == SERVER_SUCCESS_CODE
                {
                    var toastText = getPopUpMsg(Flag: DCRFlag.fieldRcpa.rawValue, status: DCRStatus.approved.rawValue , type : "DCR")
                    
                    if approvalStatus == 0
                    {
                        toastText = getPopUpMsg(Flag: DCRFlag.fieldRcpa.rawValue, status: DCRStatus.unApproved.rawValue , type : "DCR")
                    }
                    
                    showToastView(toastText: toastText)
                    _ = self.navigationController?.popViewController(animated: false)
                    
                }
                else if apiResponseObject.Status == 2
                {
                    showToastView(toastText: apiResponseObject.Message)
                }
                else
                {
                    showToastView(toastText: apiResponseObject.Message)
//                    var toastText = getPopUpMsg(Flag: DCRFlag.fieldRcpa.rawValue, status: 4 , type : "DCR")
//
//                    if approvalStatus == 0
//                    {
//                        toastText = getPopUpMsg(Flag: DCRFlag.fieldRcpa.rawValue, status: 5, type : "DCR")
//                    }
//                    showToastView(toastText: toastText)
                }
            }
        }
        else
        {
            showToastView(toastText: "No Internet Connection")
        }
    }
    
    private func updateTPStatus(approvalStatus : Int)
    {
        userObj.approvalStatus = approvalStatus
       
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: "Updating..")
            BL_Approval.sharedInstance.updateTpStatus(userList : [userObj] ,userObj: userObj, reason:condenseWhitespace(stringValue: popUpView.reasonTxtView.text)) { (apiResponseObject) in
                removeCustomActivityView()
                if apiResponseObject.Status == SERVER_SUCCESS_CODE
                {
                    var toastText = getPopUpMsg(Flag: DCRFlag.fieldRcpa.rawValue, status: DCRStatus.approved.rawValue, type : "TP")
                    if approvalStatus == 0
                    {
                        toastText = getPopUpMsg(Flag: DCRFlag.fieldRcpa.rawValue, status: DCRStatus.unApproved.rawValue, type : "TP")
                    }
                    showToastView(toastText: toastText)
                    _ = self.navigationController?.popViewController(animated: false)
                }
                else
                {
                    var toastText = getPopUpMsg(Flag: DCRFlag.fieldRcpa.rawValue, status: 4, type : "TP")
                    if approvalStatus == 0
                    {
                        toastText = getPopUpMsg(Flag: DCRFlag.fieldRcpa.rawValue, status: 5, type : "TP")
                    }
                    showToastView(toastText: toastText)
                }
            }
        }
        else
        {
            showToastView(toastText: "No internet Connection")
        }
    }
    
    //MARK:- Toast View
    private func setToastText(sectionType : Int)
    {
        switch sectionType
        {
        case SectionHeaderType.Accompanists.rawValue:
            showToastView(toastText: "Problem in getting Ride Along Details")
            
        case SectionHeaderType.WorkPlace.rawValue:
            showToastView(toastText: "Problem in getting WorkPlace Details")
            
            
        case SectionHeaderType.DoctorVisit.rawValue:
            
            showToastView(toastText: "Problem in getting \(appDoctor) Visit Details ")
            
        case SectionHeaderType.ChemistVisit.rawValue:
            
            showToastView(toastText: "Problem in getting \(appChemist) Visit Details ")

            
        case SectionHeaderType.Travel.rawValue :
            showToastView(toastText: "Problem in getting Travel Details")
            
        case SectionHeaderType.Stockiest.rawValue :
            showToastView(toastText: "Problem in getting \(appStockiest) Details")
            
        case SectionHeaderType.Expense.rawValue :
            
            showToastView(toastText: "Problem in getting Expenses Details")
        default :
            showToastView(toastText: "Problem in getting Details.")
        }
    }
    
    func getWorkPlaceListModel(dict : NSDictionary) -> [StepperWorkPlaceModel]
    {
        var workPlaceObj : StepperWorkPlaceModel  = StepperWorkPlaceModel()
        var workPlaceList : [StepperWorkPlaceModel] = []
        var campaignName : String = ""
        var workCategory : String = ""
        var workPlace : String = ""
        var workStartTime : String = ""
        var workToTime : String = ""
        
        workPlaceObj.key = "Beat/Patch Name"
        
        campaignName = checkNullAndNilValueForString(stringData: dict.object(forKey: "CP_Name") as? String)
        if campaignName == ""
        {
            campaignName = NOT_APPLICABLE
        }
        
        workPlaceObj.value = campaignName
        workPlaceList.append(workPlaceObj)
        
        workPlaceObj = StepperWorkPlaceModel()
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
                generalRemarks  = BL_Approval.sharedInstance.getTrimmedTextForGeneralRemarks(text: generalRemarks)
            }
            
            workPlaceObj.value = generalRemarks
            workPlaceList.append(workPlaceObj)
        }
        
        return workPlaceList
    }
    
    func getSelectedDoctorDetails(dcrCode : String , doctorVisitCode : String , entityType : String)
    {
        if(entityType == Constants.CustomerEntityType.doctor)
        {
            if !checkInternetConnectivity() && dcrCode != ""
            {
                showToastView(toastText: "No internet connection. Please try again")
            }
            else
            {
                
                BL_Reports.sharedInstance.doctorVisitId = DCRModel.sharedInstance.doctorVisitId
                let sb = UIStoryboard(name: ApprovalSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.ApprovalDoctorDetailVcID) as! ApprovalDoctorDetailsViewController
                vc.doctorVisitCode = doctorVisitCode
                vc.DCRCode = dcrCode
                vc.userCode = userObj.User_Code
                vc.dcrDate = userObj.Actual_Date
                vc.doctorVisitId = DCRModel.sharedInstance.doctorVisitId
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if(entityType == Constants.CustomerEntityType.chemist)
        {
            if !checkInternetConnectivity() && dcrCode != ""
            {
                showToastView(toastText: "No internet connection. Please try again")
            }
            else
            {
                 BL_Reports.sharedInstance.doctorVisitId = DCRModel.sharedInstance.doctorVisitId
                let sb = UIStoryboard(name: ApprovalSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.ApprovalDoctorDetailVcID) as! ApprovalDoctorDetailsViewController
                vc.doctorVisitCode = doctorVisitCode
                vc.DCRCode = dcrCode
                vc.userCode = userObj.User_Code
                vc.dcrDate = userObj.Actual_Date
                vc.isFromChemistDay = true
                vc.doctorVisitId = DCRModel.sharedInstance.doctorVisitId
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if(entityType == Constants.CustomerEntityType.stockist)
        {
            if !checkInternetConnectivity() && dcrCode != ""
            {
                showToastView(toastText: "No internet connection. Please try again")
            }
            else
            {
                BL_Reports.sharedInstance.doctorVisitId = DCRModel.sharedInstance.doctorVisitId
                let sb = UIStoryboard(name: ApprovalSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.ApprovalDoctorDetailVcID) as! ApprovalDoctorDetailsViewController
                vc.doctorVisitCode = doctorVisitCode
                vc.DCRCode = dcrCode
                vc.userCode = userObj.User_Code
                vc.dcrDate = userObj.Actual_Date
                vc.isFromChemistDay = true
                vc.doctorVisitId = DCRModel.sharedInstance.doctorVisitId
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func getSelectedChemistDetails(dcrCode : String , chemsitVisitCode : String)
    {
        if !checkInternetConnectivity() && dcrCode != ""
        {
            showToastView(toastText: "No internet connection. Please try again")
        }
        else
        {
            
        }
    }
    
    //MARK:- Adding Custom Back Button
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
    
    private func addTapGesture()
    {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
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
