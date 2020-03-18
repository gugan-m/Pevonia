//
//  PrepareMyDeviceViewController.swift
//  HiDoctorApp
//
//  Created by Vignaya on 11/4/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

protocol AccompanistDownloadSuccessDelegate
{
    func showToastViewForAccompanistDownload()
}

enum ApiName : String
{
    case UserPrivileges = "getUserPrivileges"
    case companyConfiguration = "getCompanyConfiguration"
    case Accompanists = "getAccompanists"
    case WorkCategories = "getWorkCategories"
    case Specialties  = "getSpecialties"
    case LeaveTypeMaster = "getLeaveTypeMaster"
    case TravelModeMaster = "getTravelModeMaster"
    case ExpenseGroupMapping = "getExpenseGroupMapping"
    case ProjectActivityMaster = "getProjectActivityMaster"
    case DetailProdcutMaster = "getDetailProdcutMaster"
    case UserProductMapping = "getUserProductMapping"
    case DFCMaster  = "getDFCMaster"
    case SFCData = "getSFCData"
    case CustomerData = "getCustomerData"
    case CampaignPlannerHeader = "getCampaignPlannerHeader"
    case CampaignPlannerSFC = "getCampaignPlannerSFC"
    case CampaignPlannerDoctors = "getCampaignPlannerDoctors"
    case TourPlannerHeader = "getTourPlannerHeader"
    case TourPlannerSFC = "getTourPlannerSFC"
    case TourPlannerDoctor = "getTourPlannerDoctor"
    case TourPlannerAccompanist = "getTourPlannerAccompanist"
    case TourPlannerProduct = "getTourPlannerProduct"
    case TourPlannerUnfreezeDate = "getTourPlannerUnfreezeDates"
    case GetTPDoctorAttachments = "GetTPDoctorAttachments"
    case DCRCalendarDetails = "getDCRCalendarDetails"
    case DCRLockDetails = "getDCRLockDetails"
    case DCRHeaderDetails = "getDCRHeaderDetails"
    case DCRTravelledPlacesDetails = "DCRTravelledPlacesDetails"
    case DCRAccompanistDetails = "getDCRAccompanistDetails"
    case DCRDoctorVisitDetails = "getDCRDoctorVisitDetails"
    case DCRDoctorVisitOrderDetails = "getDCRDoctorVisitOrderDetails"
    case DCRChemistVisitOrderDetails = "getDCRChemistVisitOrderDetails"
    case DCRSampleDetails = "getDCRSampleDetails"
    case DCRDetailedProducts = "getDCRDetailedProducts"
    case DCRChemistVisitDetails = "getDCRChemistVisitDetails"
    case DCRRCPADetails = "getDCRRCPADetails"
    case DCRCustomerFollowUpDetails = "getDCRCustomerFollowUpDetails"
    case DCRAttachmentDetails = "getDCRAttachmentDetails"
    case DCRStockistVisitDetails = "getDCRStockistVisitDetails"
    case DCRExpenseDetails = "getDCRExpenseDetails"
    case HolidayMaster = "getHolidayMaster"
    case AttendanceActivities = "getAttendanceActivities"
    case AccompanistCampaignPlannerDoctor = "getAccompanistCampaignPlannerDoctor"
    case AccompanistData = "getAccompanistData"
    case AccompanistSFCData = "getAccompanistSFCData"
    case AccopmanistCampaignPlannerHeader = "getAccopmanistCampaignPlannerHeader"
    case AccompanistCampaignPlannerSFC = "getAccompanistCampaignPlannerSFC"
    case CompetitorProducts = "getCompetitorProducts"
    case DCRDoctorAccompanist = "getDCRDoctorAccompanist"
    case UserTypeMenuAccess  = "getUserTypeMenuAccess"
    case AssetMasterDetails = "getAssetMasterDetails"
    case AssetTagDetails = "getAssetTagDetails"
    case AssetsPartsDetails = "getAssetsPartsDetails"
    case AssetAnalyticsDetails = "getAssetAnalyticsDetails"
    case StoryDetails = "getStoryDetails"
    case AssetProductMappingDetails = "getAssetProductMappingDetails"
    case DoctorProductMappingDetails = "getDoctorProductMapping"
    case AllMCDetails = "getAllMCDetails"
    case DivisionMappingDetails = "getDivisionMappingDetails"
    case MCDoctorProductMappingDetails = "getMCDoctorProductMapping"
    case DCRDoctorVisitAPIGetDCRChemistAccompanist = "getDCRChemistAccomapanist"
    case DCRDoctorVisitAPIGetDCRChemistSamplePromotion = "getDCRChemistSamplePromotion"
    case DCRDoctorVisitAPIGetDCRChemistDetailedProductsDetails = "getDCRChemistDetailedProductDetails"
    case DCRDoctorVisitAPIGetDCRChemistRCPAOwnProductDetails = "getDCRChemistRCPAOwnProductDetails"
    case DCRDoctorVisitAPIGetDCRChemistRCPACompetitorProductDetails = "getDCRChemistRCPACompetitorProductDetails"
    case DCRChemistDayFollowups = "getDCRChemistDayFollowups"
    case DCRChemistDayAttachments = "getDCRChemistDayAttachments"
    case UserModuleAccess = "getUserModuleAccess"
    case UpdateMasterDataDownloadedAlert = "updateMasterDataDownloadedAlert"
    case CustomerAddressDetails = "getCustomerAddress"
    case CustomerActivity = "getCallActivityDetails"
    case CustomerMarketingActivity = "getDCRMCActivityDetails"
    case CustomerAttendanceActivity = "getAttendanceDCRActivityDetails"
    case CustomerAttendanceMarketingActivity = "getAttendanceDCRMCActivityDetails"
    case AllCompetitorProducts = "getAllCompetitorProducts"
    case GetDCRCompetitorDetails = "getDCRCompetitorDetails"
    case AllProductCompetitor = "getAllProductsCompetitor"
    case GetDCRAttendanceSampleDetails = "getDCRAttendanceSampleDetails"
}

class PrepareMyDeviceViewController: UIViewController
{
    @IBOutlet weak var userNameLbl : UILabel!
    @IBOutlet weak var userTypeLbl : UILabel!
    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var ErrorBtnHeightConst: NSLayoutConstraint!
    @IBOutlet weak var companyNameLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var apiStatusLbl: UILabel!
    @IBOutlet weak var loadingLbl: UILabel!
    @IBOutlet var mainView: UIView!
    
    var accompanistDataDownloadList : [UserMasterModel] = []
    var isComingFromAccompanistPage : Bool = false
    var isComingFromAppDelegate : Bool = false
    var isComingFromManageAccompanist : Bool = false
    var isComingFromCompanyLogin : Bool = false
    var delegate : AccompanistDownloadSuccessDelegate?
    
    struct apiMessageName
    {
        static let UserPrivileges = "Privileges"
        static let companyConfiguration = "Configuration Settings"
        static let userModuleAccess = "User Module Access"
        static let Accompanists = "Ride Along"
        static let WorkCategories = "Work Categories"
        static let Specialties  = "position"
        static let LeaveTypeMaster = "Not Working Types"
        static let TravelModeMaster = "Travel Modes"
        static let ExpenseGroupMapping = "Expense Group"
        static let ProjectActivityMaster = "Project Activities"
        static let DetailProdcutMaster = "Sale Prodcuts"
        static let UserProductMapping = "User Products"
        static let DFCMaster = "DFC Master"
        static let SFCData = "SFC"
        static let CustomerData = "\(appDoctor)"
        static let CampaignPlannerHeader = "\(appCp)"
        static let CampaignPlannerSFC = "\(appCp) SFC"
        static let CampaignPlannerDoctors = "\(appCp) \(appDoctorPlural)"
        static let TourPlannerHeader = "Partner Routing "
        static let TourPlannerSFC = "Partner Routing SFC"
        static let TourPlannerDoctor = "Partner Routing  \(appDoctorPlural)"
        static let TourPlannerAccompanist = "Partner Routing Ride Along"
        static let TourPlannerProduct = "Partner Routing  Products"
        static let DCRCalendarDetails = "DVR Calendar Details"
        static let DCRLockDetails = "DVR Lock Details"
        static let DCRHeaderDetails = "DVR Details"
        static let DCRTravelledPlacesDetails = "DVR SFC"
        static let DCRAccompanistDetails = "DVR Ride Along"
        static let DCRDoctorVisitDetails = "DVR \(appDoctor) Visit"
        static let DCRDoctorVisitOrderDetails = "DVR \(appDoctor) Visit Order Details"
        static let DCRChemistVisitOrderDetails = "DVR \(appChemist) Visit Order Details"
        static let DCRSampleDetails = "DVR Sample Details"
        static let DCRDetailedProducts = "DVR Detailed Products"
        static let DCRChemistVisitDetails = "DVR \(appChemist) Visit"
        static let DCRRCPADetails = "DVR RCPA"
        static let DCRCustomerFollowUpDetails = "DVR Contact Follow-Up"
        static let DCRAttachmentDetails = "DVR Attachment"
        static let DCRStockistVisitDetails = "DVR \(appStockiest) Visit"
        static let DCRExpenseDetails = "DVR Expense"
        static let CampaignPlannerDoctor = "Ride Along's \(appCp) \(appDoctor)"
        static let AccompanistCampaignPlannerSFC = "Ride Along's \(appCp) SFC"
        static let AccopmanistCampaignPlannerHeader = "Ride Along's \(appCp)"
        static let AccompanistSFCData = "Ride Along's SFC"
        static let AccompanistData = "Ride Along's \(appDoctor) Data"
        static let HolidayMaster = "Holiday Master"
        static let AttendanceActivities = "Office Details"
        static let CompetitorProducts = "Competitor Products"
        static let DoctorAccompanist = "\(appDoctor) Ride Along"
        static let UserTypeMenuAccess = "Menu Access"
        static let AssetMasterDetails = "Digital Resource Master Details"
        static let AssetTagDetails = "Digital Resource Tag Details"
        static let AssetsPartsDetails = "Digital Resources Parts Details"
        static let AssetsAnalyticsDetails = "Digital Resources Analytics Details"
        static let StoryDetails = "Story Details"
        static let AssetProductMapping = "Digital Resource Product Details"
        static let DoctorProductMapping = "\(appDoctor) Product Mapping"
        static let MCDoctorProductMapping = "MC \(appDoctor) Product Mapping"
        static let DCRChemistAccompanist = "DVR \(appChemist) Ride Along"
        static let DCRChemistSamplePromotion = "DVR \(appChemist) SamplePromotion"
        static let DCRChemistDetailedProductsDetails = "DVR \(appChemist) DetailedProductsDetails"
        static let DCRChemistRCPAOwnProductDetails = "DVR \(appChemist) RCPA Own Product Details"
        static let DCRChemistRCPACompetitorProductDetails = "DVR \(appChemist) RCPA Competitor Product Details"
        static let DCRChemistDayFollowups = "DVR \(appChemist) Followups"
        static let DCRChemistDayAttachments = "DVR \(appChemist) Attachments"
        static let CustomerAddress = "Contact Address Details"
        static let UpdatemasterDataDownloaded = "All MasterData"
        static let CustomerActivity = "Contact Activity"
        static let CustomerMarketingActivity = "Contact Marketing Campaign Activity"
        static let DCRMCActivity = "DVR Activity Details"
        static let CustomerAttendanceMarketingActivity = "Contact Marketing Campaign Activity"
        static let DCRAttendanceMCActivity = "DVR Activity Details"
        static let DCRCOMPETITOR = "DVR Competitor Details"
        static let COMPETITOR = "Competitor"
        static let COMPETITORPRODUCT = "Competitor Products"
        static let AttendanceSample = "Office Samples"
        static let MCDetails = "Marketing Campaign Details"
        static let DivisionMappingDetails = "Division Mapping Details"
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        showIndicatorView(show: true)
        self.setDetails()
        showVersionToastView(textColor : UIColor.white)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.checkNavigationType()
        if isComingFromManageAccompanist
        {
            self.loadingLbl.text = "Downloading Ride Along data..."
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    func showIndicatorView(show:Bool)
    {
        if show
        {
            self.activityIndicator.startAnimating()
        }
        else
        {
            self.activityIndicator.stopAnimating()
        }
    }
    
    func setDetails()
    {
        var userName : String = ""
        var regionName : String = ""
        var userTypeName : String = ""
        var companyName : String = ""
        
        let userObj = DBHelper.sharedInstance.getUserDetail()
        
        if userObj != nil
        {
            userName = (userObj?.userName)!
            regionName = (userObj?.regionName)!
            userTypeName = (userObj?.userTypeName)!
        }
        
        let companyObj = DBHelper.sharedInstance.getCompanyDetails()
        companyName = (companyObj?.companyName)!
        
        self.userTypeLbl.text = "\(regionName)(\(userTypeName))"
        self.userNameLbl.text = userName.uppercased()
        self.companyNameLbl.text = companyName
        
        setCompanyLogo()
    }
    
    func setCompanyLogo()
    {
        let filePath = fileInDocumentsDirectory(filename: ImageFileName.companyLogo.rawValue)
        if let loadedImage = loadImageFromPath(path: filePath)
        {
            self.companyLogo.image = loadedImage
        }
    }
    
    @IBAction func errorBtnAction(_ sender: AnyObject)
    {
        if checkInternetConnectivity()
        {
            showErrorBtn(show : false)
            setApiStatusLbl(statusMsg : "")
            checkRemainingApiCalls()
        }
        else
        {
            showNoInternetAlert()
        }
    }
    
    //MARK: - Api Calls
    
    func checkRemainingApiCalls()
    {
        if checkInternetConnectivity()
        {
            if isComingFromAccompanistPage
            {
                checkWhetherUserAuthenticationToDownload()
            }
            else if isComingFromManageAccompanist
            {
                getAccompanistData()
            }
            else
            {
                let remainingApiName  =  BL_PrepareMyDevice.sharedInstance.getLastIncompleteApiDetails()
                if remainingApiName != nil
                {
                    let apiName = remainingApiName
                    let methodName = NSSelectorFromString(apiName!)
                    
                    self.perform(methodName)
                }
                else
                {
                    let extProp = getErrorLogDefaultExtProperty(functionName: #function, className: #file, lineNo: #line)
                    
                    BL_Error_Log.sharedInstance.LogError(moduleName: Constants.Module_Names.PREPARE_MY_DEVICE, subModuleName: Constants.Module_Names.PREPARE_MY_DEVICE, screenName: Constants.Screen_Names.PREPARE_MY_DEVICE, controlName: #file, additionalInfo: extProp, exception: NSException(name: .genericException, reason: nil))
                    
                    self.getUserPrivileges()
                }
            }
        }
        else
        {
            showNoInternetAlert()
            self.showErrorBtn(show: true)
        }
    }
    
    func getUserPrivileges()
    {
        if checkInternetConnectivity()
        {
            BL_PrepareMyDevice.sharedInstance.startPrepareMyDevice()
            BL_PrepareMyDevice.sharedInstance.getUserPrivileges(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
                
                if status == 1
                {
                    self.getCompanyConfiguration()
                }
                else
                {
                    self.showErrorBtn(show: true)
                }
                
                let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.UserPrivileges)
                self.setApiStatusLbl(statusMsg: statusMsg)
            }
        }
        else
        {
            self.showNoInternetAlert()
        }
    }
    
    @objc func getCompanyConfiguration()
    {
        BL_PrepareMyDevice.sharedInstance.getCompanyConfigSettings(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getUserModuleAccess()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.companyConfiguration)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getUserModuleAccess()
    {
        BL_PrepareMyDevice.sharedInstance.getUserModuleAccess(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getAccompanists()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.userModuleAccess)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getAccompanists()
    {
        BL_PrepareMyDevice.sharedInstance.getAccompanists(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getWorkCategories()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.Accompanists)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getWorkCategories()
    {
        BL_PrepareMyDevice.sharedInstance.getWorkCategories(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getSpecialties()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.WorkCategories)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getSpecialties()
    {
        BL_PrepareMyDevice.sharedInstance.getSpecialties(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getLeaveTypeMaster()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.Specialties)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getLeaveTypeMaster()
    {
        BL_PrepareMyDevice.sharedInstance.getLeaveTypeMaster(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue)
        { (status) in
            if status == 1
            {
                self.getTravelModeMaster()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.LeaveTypeMaster)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getTravelModeMaster()
    {
        BL_PrepareMyDevice.sharedInstance.getTravelModeMaster(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getExpenseGroupMapping()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.TravelModeMaster)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getExpenseGroupMapping()
    {
        BL_PrepareMyDevice.sharedInstance.getExpenseGroupMapping(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getProjectActivityMaster()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.ExpenseGroupMapping)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getProjectActivityMaster()
    {
        BL_PrepareMyDevice.sharedInstance.getProjectActivityMaster(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getDetailProdcutMaster()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.ProjectActivityMaster)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getDetailProdcutMaster()
    {
        BL_PrepareMyDevice.sharedInstance.getDetailProdcutMaster(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getUserProductMapping()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DetailProdcutMaster)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getUserProductMapping()
    {
        BL_PrepareMyDevice.sharedInstance.getUserProductMapping(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getAllProductsCompetitor()
                //  self.getAllCompetitorProducts()
                // self.getDFCMaster()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.UserProductMapping)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getAllProductsCompetitor()
    {
        BL_PrepareMyDevice.sharedInstance.getAllProductsCompetitor { (status) in
            if status == 1
            {
                self.getAllCompetitorProducts()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.COMPETITORPRODUCT)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
        
        
    }
    
    func getAllCompetitorProducts()
    {
        BL_PrepareMyDevice.sharedInstance.getAllCompetitorProducts { (status) in
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.COMPETITOR)
            self.setApiStatusLbl(statusMsg: statusMsg)
            if status == SERVER_SUCCESS_CODE
            {
                self.getDCRCompetitorDetails()
            }
            else
            {
                self.setApiStatusLbl(statusMsg: statusMsg)
            }
        }
        
    }
    
    func getDCRCompetitorDetails()
    {
        BL_DCR_Refresh.sharedInstance.getDCRCompetitorDetailsInPrepare{ (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.getDCRAttendanceSampleDetails()
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRCOMPETITOR)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getDCRAttendanceSampleDetails()
    {
        BL_DCR_Refresh.sharedInstance.getDCRAttendanceSampleDetailsInPrepare{ (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.getDFCMaster()
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.AttendanceSample)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    
    
    func getDFCMaster()
    {
        BL_PrepareMyDevice.sharedInstance.getDFCMaster(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getSFCData()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DFCMaster)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getSFCData()
    {
        BL_PrepareMyDevice.sharedInstance.getSFCData(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getCustomerData()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.SFCData)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getCustomerData()
    {
        BL_PrepareMyDevice.sharedInstance.getCustomerData(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getCampaignPlannerHeader()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.CustomerData)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getCampaignPlannerHeader()
    {
        BL_PrepareMyDevice.sharedInstance.getCampaignPlannerHeader(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getCampaignPlannerSFC()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.CampaignPlannerHeader)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getCampaignPlannerSFC()
    {
        BL_PrepareMyDevice.sharedInstance.getCampaignPlannerSFC(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getCampaignPlannerDoctors()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.CampaignPlannerSFC)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getCampaignPlannerDoctors()
    {
        BL_PrepareMyDevice.sharedInstance.getCampaignPlannerDoctors(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getTourPlannerHeader()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.CampaignPlannerDoctors)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getTourPlannerHeader()
    {
        BL_PrepareMyDevice.sharedInstance.getTourPlannerHeader(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getTourPlannerSFC()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.TourPlannerHeader)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getTourPlannerSFC()
    {
        BL_PrepareMyDevice.sharedInstance.getTourPlannerSFC(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getTourPlannerDoctor()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.TourPlannerSFC)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getTourPlannerDoctor()
    {
        BL_PrepareMyDevice.sharedInstance.getTourPlannerDoctor(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getTourPlannerAccompanist()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.TourPlannerDoctor)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getTourPlannerAccompanist()
    {
        BL_PrepareMyDevice.sharedInstance.getTourPlannerAccompanist(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getTourPlannerProduct()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.TourPlannerAccompanist)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getTourPlannerProduct()
    {
        BL_PrepareMyDevice.sharedInstance.getTourPlannerProduct(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getTourPlannerUnfreezeDates()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.TourPlannerProduct)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getTourPlannerUnfreezeDates()
    {
        BL_PrepareMyDevice.sharedInstance.getTourPlannerUnfreezeDates(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getDCRCalendarDetails()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.TourPlannerProduct)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getDCRCalendarDetails()
    {
        BL_PrepareMyDevice.sharedInstance.getDCRCalendarDetails(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getDCRLockDetails()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRCalendarDetails)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getDCRLockDetails()
    {
        BL_PrepareMyDevice.sharedInstance.getDCRLockDetails(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getDCRHeaderDetails()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRLockDetails)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    @objc func getDCRHeaderDetails()
    {
        BL_PrepareMyDevice.sharedInstance.getDCRHeaderDetails(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getDCRTravelledPlacesDetails()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRHeaderDetails)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getDCRTravelledPlacesDetails()
    {
        BL_PrepareMyDevice.sharedInstance.getDCRTravelledPlacesDetails(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getDCRAccompanistDetails()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRTravelledPlacesDetails)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getDCRAccompanistDetails()
    {
        BL_PrepareMyDevice.sharedInstance.getDCRAccompanistDetails(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getDCRDoctorVisitDetails()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRAccompanistDetails)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getDCRDoctorVisitDetails()
    {
        BL_PrepareMyDevice.sharedInstance.getDCRDoctorVistiDetails(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getDCRSampleDetails()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRDoctorVisitDetails)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getDCRSampleDetails()
    {
        BL_PrepareMyDevice.sharedInstance.getDCRSampleDetails(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getDCRDetailedProducts()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRSampleDetails)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getDCRDetailedProducts()
    {
        BL_PrepareMyDevice.sharedInstance.getDCRDetailedProducts(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getDCRChemistVisitDetails()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRDetailedProducts)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getDCRChemistVisitDetails()
    {
        BL_PrepareMyDevice.sharedInstance.getDCRChemistVisitDetails(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getDCRRCPADetails()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRChemistVisitDetails)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getDCRRCPADetails()
    {
        BL_PrepareMyDevice.sharedInstance.getDCRRCPADetails(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getDCRCustomerFollowUpDetails()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRRCPADetails)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getDCRCustomerFollowUpDetails()
    {
        BL_PrepareMyDevice.sharedInstance.getDCRCustomerFollowUpDetails(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.getDCRAttachmentDetails()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRCustomerFollowUpDetails)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getDCRAttachmentDetails()
    {
        BL_PrepareMyDevice.sharedInstance.getDCRAttachmentDetails(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.getDCRStockistVisitDetails()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRAttachmentDetails)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getDCRStockistVisitDetails()
    {
        BL_PrepareMyDevice.sharedInstance.getDCRStockistVisitDetails(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getDCRExpenseDetails()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRStockistVisitDetails)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getDCRExpenseDetails()
    {
        BL_PrepareMyDevice.sharedInstance.getDCRExpenseDetails(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getHolidayMaster()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRExpenseDetails)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getHolidayMaster()
    {
        BL_PrepareMyDevice.sharedInstance.getHolidayMaster(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == 1
            {
                self.getAttendanceActivities()
            }
            else
            {
                self.showErrorBtn(show: true)
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.HolidayMaster)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getAttendanceActivities()
    {
        BL_PrepareMyDevice.sharedInstance.getDCRAttendanceActivities(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            
            if status == 1
            {
                self.getCompetitorProducts()
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.AttendanceActivities)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getCompetitorProducts()
    {
        BL_PrepareMyDevice.sharedInstance.getCompetitorProducts(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            
            if status == 1
            {
                self.getDCRDoctorAccompanist()
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.CompetitorProducts)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getDCRDoctorAccompanist()
    {
        BL_PrepareMyDevice.sharedInstance.getDCRDoctorAccompanist(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.getUserTypeMenuAccess()
            }
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DoctorAccompanist)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getUserTypeMenuAccess()
    {
        BL_PrepareMyDevice.sharedInstance.getUserTypeMenuAccess(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            
            if status == SERVER_SUCCESS_CODE
            {
                self.getAssetMasterDetails()
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.UserTypeMenuAccess)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
        
        BL_PrepareMyDevice.sharedInstance.getbussinessStatusPotential()
    }
    
    //MARK:-Edetailing
    
    @objc func getAssetMasterDetails()
    {
        BL_PrepareMyDevice.sharedInstance.getAssetHeaderDetails(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.getAssetAnalyticsDetails()
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.AssetMasterDetails)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getAssetAnalyticsDetails()
    {
        BL_PrepareMyDevice.sharedInstance.getAssetAnalyticsDetails(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.getAssetTagDetails()
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.AssetsAnalyticsDetails)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getAssetTagDetails()
    {
        BL_PrepareMyDevice.sharedInstance.getAssetTagDetails(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.getAssetProductMappingDetails()
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.AssetTagDetails)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getAssetProductMappingDetails()
    {
        BL_PrepareMyDevice.sharedInstance.getAssetProductMapping(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.getDoctorProductMapping(selectedRegionCode: EMPTY)
                //                self.getStoryDetails()
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.AssetProductMapping)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getDoctorProductMapping(selectedRegionCode: String)
    {
        BL_PrepareMyDevice.sharedInstance.getDoctorProductMapping(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue,selectedRegionCode: selectedRegionCode) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.getCustomerAddress(selectedRegionCode: selectedRegionCode)
                
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DoctorProductMapping)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getAllMCDetails()
    {
        BL_PrepareMyDevice.sharedInstance.getAllMCDetails(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.getDivisionMappingDetails()
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.MCDetails)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getDivisionMappingDetails()
    {
        BL_PrepareMyDevice.sharedInstance.getDivisionMappingDetails(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.getCallActivityDetails()
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DivisionMappingDetails)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getCustomerAddress(selectedRegionCode: String)
    {
        BL_PrepareMyDevice.sharedInstance.getCustomerAddress(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue, selectedRegionCode: selectedRegionCode) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.getAllMCDetails()
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.CustomerAddress)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getCallActivityDetails()
    {
        BL_PrepareMyDevice.sharedInstance.getCallActivityAndMCActivity { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.getDCRActivityDetails()
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.CustomerActivity)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getDCRActivityDetails()
    {
        BL_DCR_Refresh.sharedInstance.getDCRCallActivitesInPrepare{ (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.getDCRMCActivityDetails()
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRMCActivity)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getDCRMCActivityDetails()
    {
        BL_DCR_Refresh.sharedInstance.getDCRMCActivitesInPrepare{ (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.getAttendanceDCRActivityDetails()
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.CustomerMarketingActivity)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getAttendanceDCRActivityDetails()
    {
        BL_DCR_Refresh.sharedInstance.getAttendanceDCRCallActivitesInPrepare{ (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.getAttendanceDCRMCActivityDetails()
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRAttendanceMCActivity)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getAttendanceDCRMCActivityDetails()
    {
        BL_DCR_Refresh.sharedInstance.getAttendanceDCRMCActivitesInPrepare{ (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.getStoryDetails()
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.CustomerAttendanceMarketingActivity)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getStoryDetails()
    {
        if BL_DCR_Doctor_Visit.sharedInstance.getStoryEnabledPrivVal().lowercased() == PrivilegeValues.YES.rawValue.lowercased()
        {
            BL_PrepareMyDevice.sharedInstance.getStoryDetails(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
                let statusMsg = self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.StoryDetails)
                self.setApiStatusLbl(statusMsg: statusMsg)
                
                if status == SERVER_SUCCESS_CODE
                {
                    self.getDCRChemistAccomapanist()
                    //                    self.navigateToNextScreen()
                    //                    self.setApiStatusLbl(statusMsg: "All data Downloaded successfully")
                }
            }
        }
        else
        {
            self.getDCRChemistAccomapanist()
            //            self.navigateToNextScreen()
            //            self.setApiStatusLbl(statusMsg: "All data Downloaded successfully")
        }
    }
    
    func getAssetsPartsDetails()
    {
        BL_PrepareMyDevice.sharedInstance.getAssetPartDetails(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.AssetsPartsDetails)
            self.setApiStatusLbl(statusMsg: statusMsg)
            
            if status == 0
            {
                self.navigateToNextScreen()
                self.setApiStatusLbl(statusMsg: "All data Downloaded successfully")
            }
        }
    }
    
    //MARK:- ChemistDay
    func getDCRChemistAccomapanist()
    {
        BL_PrepareMyDevice.sharedInstance.getDCRDoctorVisitChemistAccompanist(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            
            if status == SERVER_SUCCESS_CODE
            {
                self.getDCRChemistSamplePromotion()
            }
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRChemistAccompanist)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getDCRChemistSamplePromotion()
    {
        BL_PrepareMyDevice.sharedInstance.getDCRDoctorVisitChemistSamplePromotion(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            
            if status == SERVER_SUCCESS_CODE
            {
                self.getDCRChemistDetailedProductDetails()
            }
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRChemistSamplePromotion)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getDCRChemistRCPAOwnProductDetails()
    {
        BL_PrepareMyDevice.sharedInstance.getDCRDoctorVisitChemistRCPAOwnProductDetails(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            
            if status == SERVER_SUCCESS_CODE
            {
                self.getDCRChemistRCPACompetitorProductDetails()
            }
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRChemistRCPAOwnProductDetails)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getDCRChemistRCPACompetitorProductDetails()
    {
        BL_PrepareMyDevice.sharedInstance.getDCRDoctorVisitChemistRCPACompetitorProductDetails(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            
            if status == SERVER_SUCCESS_CODE
            {
                self.getDCRChemistDayFollowups()
            }
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRChemistRCPACompetitorProductDetails)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getDCRChemistDetailedProductDetails()
    {
        BL_PrepareMyDevice.sharedInstance.getDCRDoctorVisitChemistDetailedProductDetails(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            
            if status == SERVER_SUCCESS_CODE
            {
                self.getDCRChemistRCPAOwnProductDetails()
            }
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRChemistDetailedProductsDetails)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getDCRChemistDayFollowups()
    {
        BL_PrepareMyDevice.sharedInstance.getDCRDoctorVisitChemistDayFollowups(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            
            if status == SERVER_SUCCESS_CODE
            {
                self.getDCRChemistDayAttachments()
            }
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRChemistDayFollowups)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getDCRChemistDayAttachments()
    {
        BL_PrepareMyDevice.sharedInstance.getDCRDoctorVisitChemistDayAttachments(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.getDCRPOBOrder()
            }
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRChemistDayAttachments)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getDCRPOBOrder()
    {
        BL_PrepareMyDevice.sharedInstance.getDCRDoctorVisitOrderDetails(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.getDCRPOBChemistOrder()
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRDoctorVisitOrderDetails)
            self.setApiStatusLbl(statusMsg: statusMsg)
        }
    }
    
    func getDCRPOBChemistOrder()
    {
        BL_PrepareMyDevice.sharedInstance.getDCRChemistVisitOrderDetails(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.DCRChemistVisitOrderDetails)
            self.setApiStatusLbl(statusMsg: statusMsg)
            
            if status == SERVER_SUCCESS_CODE
            {
                self.getMCDoctorProductMapping(selectedRegionCode: EMPTY)
            }
            else
            {
                self.setApiStatusLbl(statusMsg: statusMsg)
            }
        }
    }
    
    //MARK: - Status
    func getErrorMessageForStatus(statusCode: Int, dataName: String) -> String
    {
        if (statusCode == SERVER_SUCCESS_CODE)
        {
            return "\(dataName) downloaded"
        }
        else if (statusCode == SERVER_ERROR_CODE)
        {
            self.showErrorBtn(show: true)
            return "Server error while downloading \(dataName) data. Please try again"
        }
        else if (statusCode == NO_INTERNET_ERROR_CODE)
        {
            self.showErrorBtn(show: true)
            return internetOfflineMessage
        }
        else if (statusCode == LOCAL_ERROR_CODE)
        {
            self.showErrorBtn(show: true)
            return "Unable to process \(dataName) data. Please try again"
        }
        else
        {
            return ""
        }
    }
    
    func setApiStatusLbl(statusMsg : String)
    {
        self.apiStatusLbl.text = statusMsg
    }
    
    func showNoInternetAlert()
    {
        AlertView.showNoInternetAlert()
    }
    
    func showErrorBtn(show:Bool)
    {
        if show
        {
            self.ErrorBtnHeightConst.constant = 50
            self.loadingLbl.text = ""
        }
        else
        {
            self.ErrorBtnHeightConst.constant = 0
            if isComingFromManageAccompanist
            {
                self.loadingLbl.text = "Downloading Ride Along data..."
            }
            else
            {
                self.loadingLbl.text = "Preparing your device please wait..."
            }
        }
        
        hideActivityIndicator(hide: show)
    }
    
    func hideActivityIndicator(hide : Bool)
    {
        self.activityIndicator.isHidden = hide
    }
    
    private func moveToHomePage()
    {
        if (!BL_Password.sharedInstance.isPasswordPolicyEnabled())
        {
            let delayTime = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.navigationController?.isNavigationBarHidden = false
                let appDelegate = getAppDelegate()
                appDelegate.allocateRootViewController(sbName: landingViewSb, vcName: landingVcID)
            }
        }
        else
        {
            BL_Password.sharedInstance.getUserAccountDetailsForPMD(viewController: self, completion: { (serverTime) in
                if (serverTime != EMPTY)
                {
                    BL_Password.sharedInstance.checkPasswordStatusForPMD(viewController: self, serverTime: serverTime)
                }
            })
        }
    }
    
    private func moveToAccompanistPage()
    {
        let main_sb = UIStoryboard(name:prepareMyDeviceSb, bundle: nil)
        let main_vc = main_sb.instantiateViewController(withIdentifier: AccompanistVcID) as! IntermediateAccompanistListViewController
        self.navigationController?.pushViewController(main_vc, animated: true)
    }
    
    func checkNavigationType()
    {
        
        if isComingFromAccompanistPage
        {
            if accompanistDataDownloadList.count > 0 ||  self.isComingFromAppDelegate
            {
                self.checkWhetherUserAuthenticationToDownload()
            }
        }
        else
        {
            self.checkRemainingApiCalls()
        }
    }
    
    //MARK: - Accompanist Page Api calls
    func checkWhetherUserAuthenticationToDownload()
    {
        let accompanistDownloadObj = BL_PrepareMyDeviceAccompanist.sharedInstance.getIncompleteAccompanistDataDownloadDetail()
        if (accompanistDownloadObj == nil) // First time call. Not stopped before
        {
            if BL_PrepareMyDeviceAccompanist.sharedInstance.canDownloadAccompanistData()
            {
                self.getAccompanistData()
            }
            else
            {
                BL_PrepareMyDeviceAccompanist.sharedInstance.endAccomapnistDataDownload()
            }
        }
        else if (accompanistDownloadObj?.Is_Doctor_Data_Downloaded == 0 || accompanistDownloadObj?.Is_Chemist_Data_Downloaded == 0)
        {
            self.getAccompanistData()
        }
        else if (accompanistDownloadObj?.Is_SFC_Data_Downloaded == 0)
        {
            self.getAccompanistSFCData()
        }
        else if (accompanistDownloadObj?.Is_CP_Data_Downloaded == 0)
        {
            self.getCampaignPlannerHeader()
        }
    }
    
    func getAccompanistData()
    {
        BL_PrepareMyDeviceAccompanist.sharedInstance.beginAccompanistDataDownload(selectedAccompanists: accompanistDataDownloadList)
        
        BL_PrepareMyDevice.sharedInstance.getDoctorProductMapping(masterDataGroupName: EMPTY, selectedRegionCode: EMPTY, completion: { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                
                BL_PrepareMyDeviceAccompanist.sharedInstance.getAccDetailedProductData(completion: { (status) in
                    if (status == SERVER_SUCCESS_CODE)
                    {
                        BL_PrepareMyDeviceAccompanist.sharedInstance.getCustomerData(isCalledFromMasterDataDownload: false, completion: { (status) in
                            if status == 1
                            {
                                self.getAccopmanistCampaignPlannerHeader()
                            }
                            
                            
                            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.AccompanistData)
                            self.setApiStatusLbl(statusMsg: statusMsg)
                        })
                    }
                })
            }
        })
    }
    
    func getAccopmanistCampaignPlannerHeader()
    {
        BL_PrepareMyDeviceAccompanist.sharedInstance.getCampaignPlannerHeader(isCalledFromMasterDataDownload: false, completion:{(status) in
            if status == 1
            {
                self.getAccompanistSFCData()
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.AccopmanistCampaignPlannerHeader)
            self.setApiStatusLbl(statusMsg: statusMsg)
        })
    }
    
    func getAccompanistSFCData()
    {
        BL_PrepareMyDeviceAccompanist.sharedInstance.getSFCData(isCalledFromMasterDataDownload: false, completion: {(status) in
            if status == 1
            {
                self.getAccompanistCampaignPlannerSFC()
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.AccompanistSFCData)
            self.setApiStatusLbl(statusMsg: statusMsg)
        })
    }
    
    func getAccompanistCampaignPlannerSFC()
    {
        BL_PrepareMyDeviceAccompanist.sharedInstance.getCampaignPlannerSFC(isCalledFromMasterDataDownload: false, completion: {(status) in
            if status == 1
            {
                self.getAccompanistCampaignPlannerDoctor()
            }
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.AccompanistCampaignPlannerSFC)
            self.setApiStatusLbl(statusMsg: statusMsg)
        })
    }
    
    func getAccompanistCampaignPlannerDoctor()
    {
        BL_PrepareMyDeviceAccompanist.sharedInstance.getCampaignPlannerDoctor(isCalledFromMasterDataDownload: false, completion: {(status) in
            
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.CampaignPlannerDoctor)
            self.setApiStatusLbl(statusMsg: statusMsg)
            
            if status == 1
            {
                BL_PrepareMyDeviceAccompanist.sharedInstance.endAccomapnistDataDownload()
                self.setApiStatusLbl(statusMsg: "All data Downloaded successfully")
                
                if self.isComingFromManageAccompanist
                {
                    WebServiceHelper.sharedInstance.syncMasterDataDownloadDetails(postData: self.getPostData(sectionName: "Download Accompanist from Manage Accompanist"), completion: { (apiObj) in
                        self.delegate?.showToastViewForAccompanistDownload()
                        removeVersionToastView()
                        self.navigationController?.isNavigationBarHidden = false
                        _ = self.navigationController?.popViewController(animated: false)
                    })
                }
                else
                {
                    self.moveToHomePage()
                }
            }
        })
    }
    
    private func getPostData(sectionName: String) -> [String: Any]
    {
        let postData :[String:Any] = ["Company_Code":getCompanyCode(),"User_Code":getUserCode(),"Section_Name":sectionName,"Download_Date":getCurrentDateAndTimeString(),"Downloaded_Acc_Region_Codes":BL_PrepareMyDeviceAccompanist.sharedInstance.getRegionCodeStringWithOutQuotes()]
        
        return postData
    }
    
    func getMCDoctorProductMapping(selectedRegionCode: String)
    {
        BL_PrepareMyDevice.sharedInstance.getMCDoctorProductMapping(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue, selectedRegionCode: selectedRegionCode) { (status) in
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.MCDoctorProductMapping)
            self.setApiStatusLbl(statusMsg: statusMsg)
            if status == SERVER_SUCCESS_CODE
            {
                self.updateMasterDataDownloadedAlert()
            }
            else
            {
                self.setApiStatusLbl(statusMsg: statusMsg)
            }
        }
    }
    
    
    
    func updateMasterDataDownloadedAlert()
    {
        BL_PrepareMyDevice.sharedInstance.updateMasterDataDownloadedAlert(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            let statusMsg =  self.getErrorMessageForStatus(statusCode: status, dataName: apiMessageName.UpdatemasterDataDownloaded)
            self.setApiStatusLbl(statusMsg: statusMsg)
            if status == SERVER_SUCCESS_CODE
            {
                self.navigateToNextScreen()
                self.setApiStatusLbl(statusMsg: statusMsg)
            }
            else
            {
                self.setApiStatusLbl(statusMsg: statusMsg)
            }
        }
    }
    
    //MARK: - Navigate
    func navigateToNextScreen()
    {
        BL_PrepareMyDevice.sharedInstance.endPrepareMyDevice()
        if BL_PrepareMyDeviceAccompanist.sharedInstance.canDownloadAccompanistData()
        {
            moveToAccompanistPage()
        }
        else
        {
            BL_PrepareMyDeviceAccompanist.sharedInstance.endAccomapnistDataDownload()
            self.moveToHomePage()
        }
    }
}
