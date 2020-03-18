import UIKit
import Foundation

//MARK:- Production Configuration Keys
//let wsRootUrl: String = "https://hdwebapi.hidoctor.me/"
let wsRootUrl: String = "https://demowebapi.hidoctor.me/"
//MARK:- Development QA Configuration Keys
//let wsRootUrl: String = "https://hdwebapi-qa.hidoctor.me/"
//let wsRootUrl: String = "https://hdwebapi-dev.hidoctor.me/"
let dashboardBaseUrl : String = "http://hdreports.hidoctor.me/?Lid="

//MARK:- Development DEV Configuration Keys
// use this url for production but not for live.
//let wsRootUrl: String = "https://dev-webapi-ios.hidoctor.me/"
//let wsRootUrl: String = "http://hdwedev1.hidoctor.me/"

//MARK:- Development  email issue
//let supportEmail : String = "Pevonia.support@swaas.net"


let helpFilesURL = "https://helpfiles.hdsfa.com"
//MARK:- Testing issue email
let supportEmail : String = "Pevonia.support@swaas.net"

//MARK:- App Name
let appName = "Pevonia CRM"

//MARK:- Screen Measurements
var SCREEN_WIDTH =  UIScreen.main.bounds.size.width
var SCREEN_HEIGHT = UIScreen.main.bounds.height

//MARK :- Source of entry

let Source_Of_Entry = 2

//MARK :- Common
let ForeUpdateRequired = "ForeUpdateRequired"
let MasterDataDownloadMessage = "MasterDataDownloadMessage"
let applicationituneUrl = "https://itunes.apple.com/in/app/hidoctor-sfa/id1219172659?mt=8"

let kennectToken = "KennectToken"
let kennectUserDetails = "kennectUserDetails"

//MARK :-- Kennect Url
let kennectAuthUrl = "https://api.betkennect.xyz/tenant/v0.1/user/get-auth"
let kennectUserInfo = "https://api.betkennect.xyz/twsa/v0.1/invoke/omkar_dusane-t12-wlc/datastorage"

//MARK:- Storyboard names
let mainSb = "Main"
let commonListSb = "CommonListViewController"
let onBoardViewSb = "OnBoardViewController"
let prepareMyDeviceSb = "PrepareDeviceViewController"
let DCRCalenderSb = "DCRCalendar"
let landingViewSb = "LandingViewController"
let workPlaceDetailsSb = "WorkPlaceDetailsViewController"
let addExpenseDetailsSb = "ExpenseViewController"
let sampleProductListSb = "SampleDetailsViewController"
let accompanistDetailsSb = "AccompanistDetailsViewController"
let addTravelDetailSb = "AddTravelDetails"
let travelDetailListSb = "TravelledDetailList"
let stockiestsSb = "StockiestsViewController"
let detailProductSb = "DetailedProductViewController"
let leaveEntrySb = "LeaveEntryViewController"
let chemistsSb = "ChemistsViewController"
let dcrStepperSb = "DCRStepperViewController"
let doctorMasterSb = "DoctorMasterController"
let attendanceStepperSb = "AttendanceViewController"
let attendanceActivitySb = "AttendanceActivityViewController"
let docotorVisitSb = "DoctorVisitViewController"
let MoreViewMasterSb = "MoreViewController"
let ApprovalSb = "ApprovalViewController"
let AssetsPlaySb = "AssetsPlayViewController"
let TPStepperSb = "TPStepperViewController"
let TPMeetingPointVCID = "TPMeetingPointVCID"
let CustomerFBSB = "CustomerFeedbackController"
let TourPlannerSB = "TourPlanner"
let ChemistDaySB = "ChemistDay"


//MARK:- Collection view cell identifier
let landingCellIdentifier = "landingItem"
let AssetsPlayerCellIdentifier = "AssetsPlayerCell"
let MultipleWorkPlaceCell = "MultipleWorkPlaceCell"
let TPMultipleWorkPlaceCell = "TPMultipleWorkPlaceCell"

//MARK:- Tableview cell identifier
let dropdownCellIdentifier = "dropdownCell"
let CampaignPlannerListCell = "CampaignPlannerListCell"
let expensesListCell = "ExpensesListCell"
let expenseTypeListCell = "ExpenseTypeListCell"
let SampleDCRListCell = "SampleDCRListCell"
let sampleProductListCell = "sampleProductListCell"
let DeleteSampleListCell = "DeleteSampleListCell"
let AccompanistModifyListCell = "AccompanistModifyListCell"
let StockiestsModifyListCell = "StockiestsModifyListCell"
let StockiestsListCell = "StockiestsListCell"
let detailProductCell = "DetailedProductsTableViewCell"
let detailProductListCell = "detailProductListCell"
let doctorAccompanistListCell = "doctorAccompanistListCell"
let chemistsListCell = "ChemistsListCell"
let AddFlexiChemistCell = "AddFlexiChemistCell"
let AddFlexiSectionCell = "AddFlexiSectionCell"
let ChemistsRCPAHeaderCell = "ChemistsRCPAHeaderCell"
let ChemistsRCPAListsCell = "ChemistsRCPAListsCell"
let AddRCPAListCell = "AddRCPAListCell"
let AddRCPAHeaderCell = "AddRCPAHeaderCell"
let competitorListCell = "competitorListCell"
let ModifyRCPAListCell = "ModifyRCPAListCell"
let ModifyChemistListCell = "ModifyChemistListCell"
let LeaveEntryDropDownCell = "LeaveEntryDropDownCell"
let AttendanceMainCell = "AttendanceMainCell"
let AttendanceSubCell = "AttendanceSubCell"
let AttendanceSFCCell = "AttendanceSFCCell"
let ModifyActivityListCell = "ModifyActivityListCell"
let AttendanceActivityListCell = "AttendanceActivityListCell"
let AddFlexiWorkPlaceSectionCell = "AddFlexiWorkPlaceSectionCell"
let AddFlexiWorkPlaceCell = "AddFlexiWorkPlaceCell"
let MoreSectionCell = "MoreSectionCell"
let MoreContentCell = "MoreContentCell"
let DeleteAccompanistListCell = "DeleteAccompanistListCell"
let ApprovalCell = "ApprovalCell"
let ApprovalSectionCell = "ApprovalSectionCell"
let ApprovalUserContentCell = "ApprovalUserContentCell"
let ApprovalUserSectionCell = "ApprovalUserSectionCell"
let UnApprovalListCell = "UnApprovalListCell"
let deleteDCRFilterCell = "deleteDCRFilterCell"
let dashboardAssetCell = "dashboardAssetCell"
let dashboardAssetDoctorCell = "dashboardAssetDoctorCell"
let MST_CUSTOMER_MASTER_PERSONAL_INFO = "mst_Customer_Master_Personal_Info"
let TPAccompanistCell = "TPAccompanistCell"
let DoctorSampleTVCell = "doctorSampleTVCell"
let TPAttendanceTVCell = "TPAttendanceTableViewCell"
let NotesCellVcID = "NotesCellVcID"
let TPFieldHeaderCell = "TPFieldHeaderCell"
let TPFieldFooterCell = "TPFieldFooterCell"
let TPField_MeetingObjectiveCell = "TPFieldMeetingObjectiveCell"
let TPField_RideAlongcell = "TPFieldRideAlongCell"
let TPField_WorkCategoryCell = "TPFieldWorkCategoryCell"
let TPRemarkCell = "TPRemarkCell"


//MARK:- View controller Ids
let companyVC = "companyVC"
let loginVC = "loginVC"
let forgotPwdVC = "forgotPwdVC"
let placeListVcID = "placeListVcID"
let onboardViewVcID = "onboardViewVcID"
let PrepareDeviceVcID = "PrepareDeviceVcID"
let CodeOfConductViewControllerID = "CodeOfConductViewControllerID"
let landingVcID = "landingVC"
let DCRVcID = "dcrVC"
let userListVcID = "userListVcID"
let masterDataVcID = "masterDataVcID"
let AccompanistVcID = "AccompanistVcID"
let DCRHeaderVcID = "DCRHeaderVcID"
let CampaignListVcID = "CampaignListVcID"
let AddExpenseVcID = "AddExpenseVcID"
let ExpenseTypeListVcID = "ExpenseTypeListVcID"
let ExpenseListVcID = "ExpenseListVcID"
let sampleProductListVcID = "sampleProductListVcID"
let sampleDCRListVcID = "sampleDCRListVcID"
let TPsampleDCRListVcID = "TPsampleDCRListVcID"
let DeleteSampleVcID = "DeleteSampleVcID"
let AccompanistModifyListVcID = "AccompanistModifyListVcID"
let AddAccompanistVcID = "AddAccompanistVcID"
let addTravelDetailVcId = "addTravelDetailVcId"
let StockiestsModifyListVcID = "StockiestsModifyListVcID"
let StockiestsListVcID = "StockiestsListVcID"
let AddStockiestsVcID = "AddStockiestsVcID"
let DetailProductVcID = "DetailProductVcID"
let DoctorAccompanistVcID = "DoctorAccompanistVcID"
let LeaveEntryVcID = "LeaveEntryVcID"
let ChemistsListVcID = "ChemistsListVcID"
let AddFlexiChemistVcID = "AddFlexiChemistVcID"
let dcrStepperVcID = "DCRMainStepper"
let travelDetailListVcID = "travelListVcId"
let AddChemistsVisitVcID = "AddChemistsVisitVcID"
let travelSuggestionVcID = "travelSuggestionVcID"
let AddChemsistRCPAVcID = "AddChemsistRCPAVcID"
let competitorProductListVcID = "competitorProductListVcID"
let ModifyRCPAVcID = "ModifyRCPAVcID"
let doctorMasterVcID = "doctorMasterVcID"
let ModifyChemistListVcID = "ModifyChemistListVcID"
let AddCompetitorProductVcID = "AddCompetitorProductVcID"
let LeaveEntryDropDownVcID = "LeaveEntryDropDownVcID"
let doctorVisitStepperVcID = "doctorVisitStepperVcId"
let AttendanceStepperVcID = "AttendanceStepperVcID"
let AddAttendanceActivityVcID = "AddAttendanceActivityVcID"
let ActivityListVcID = "ActivityListVcID"
let ModifyActivityListVcID = "ModifyActivityListVcID"
let RefreshPopupVcID = "refreshPopupVcID"
let RefreshVcID = "refreshVcID"
let DCRUploadVcID = "dcrUploadVcID"
let DCRGeneralRemarksVcID = "DCRGeneralRemarksVcID"
let doctorVisitVcID = "doctorVisitVcID"
let AddFlexiWorkPlaceVcID = "AddFlexiWorkPlaceVcID"
let doctorVisitModifyVcID = "doctorVisitModifyVcID"
let KYCalendarVcID = "KYCalendarVcID"
let TPKYCalendarVcID = "TPKYCalendarVcID"
let MoreViewControllerVcID = "MoreViewControllerVcID"
let UserIndexListVcID = "UserIndexListVcID"
let DeleteAccompanistVcID = "DeleteAccompanistVcID"
let ApprovalVcID = "ApprovalVcID"
let ApprovalUserListVcID = "ApprovalUserListVcID"
let ApprovalRegionListVcID = "ApprovalRegionListVcID"
let ExpenseApprovalViewControllerID = "ExpenseApprovalViewControllerID"
let DoctorApproveErrorVcID = "DoctorApproveErrorVcID"
let UnApprovalListVcID = "UnApprovalListVcID"
let ChangePasswordVcID = "ChangePasswordVcID"
let PasswordLockVCID = "PasswordLockVCID"
let ConfirmPasswordVCID = "ConfirmPasswordVCID"
let LogoutVcID = "LogoutVcID"
let AboutUsVcID = "AboutUsVcID"
let AccompanistPopUpVcID = "AccompanistPopUpVcID"
let deleteDCRFilterVcID = "deleteDCRFilterVcID"
let webViewVCID = "webViewVCID"
let AssetsPlayVCID = "AssetsPlayVCID"
let TPStepperVCID = "TPStepperVCID"
let TPAccompanistVCID = "TPAccompanistVCID"
let TPWorkPlaceDetailVCID = "TPWorkPlaceDetailVCID"
let TPTravelDetailsVCID = "TPTravelDetailsVCID"
let TPDoctorMasterVCID = "TPDoctorMasterVCID"
let CustomerFBVCID = "CustomerFBVCID"
let TPSampleListVCID = "TPSampleListVCID"
let AssetParentVCID = "AssetParentVCID"
let TPAttendanceStepperVCID = "TPAttendanceStepperVCID"
let TPAttendanceActivityVCID = "TPAttendanceActivityVCID"
let TPLeaveEntryVcID = "TPLeaveEntryVcID"
let TPTravelListVcId = "TPTravelListVcId"
let AssetShowListVcID = "AssetShowListVcID"
let ChemistDayVcID = "ChemistDayVcID"
let ChemistDayVisitVcID = "ChemistDayVisitVcID"
let ActivityListRemarkControllerID = "ActivityListRemarkControllerID"
let MCListViewControllerID = "MCListViewControllerID"
let InwardAccknowledgementID = "InwardAccknowledgementID"
let InwardChalanDetailViewControllerID = "InwardChalanDetailViewControllerID"
let InwardRemarksViewControllerID = "InwardRemarksViewControllerID"
let ExpenseAttachmentViewControllerID = "ExpenseAttachmentViewControllerID"
let ComplaintCustomerListViewControllerID = "ComplaintCustomerListViewControllerID"
let ComplaintListViewControllerID = "ComplaintListViewControllerID"
let ComplaintDetailViewControllerID = "ComplaintDetailViewControllerID"
let IceDatesListViewControllerID = "IceDatesListViewControllerID"
let IceFeedbackHistoryViewControllerID = "IceFeedbackHistoryViewControllerID"
let IceHistoryViewControllerID = "IceHistoryViewControllerID"
let TaskListViewControllerID = "TaskListViewControllerID"
let TaskDetailsViewControllerID = "TaskDetailsViewControllerID"
let CreateTaskViewControllerID = "CreateTaskViewControllerID"
let TaskHistoryViewControllerID = "TaskHistoryViewControllerID"
let CompetitorProductDetailViewControllerID = "CompetitorProductDetailViewControllerID"
let AddDetailedCompetitorProductControllerID = "AddDetailedCompetitorProductControllerID"
let CompetitorListViewControllerID = "CompetitorListViewControllerID"
let CreateCpmpetitorProductControllerID = "CreateCpmpetitorProductControllerID"
let LockReleaseFormControllerID = "LockReleaseFormControllerID"
let AttendanceDoctorStepperControllerID = "AttendanceDoctorStepperControllerID"
let NotesCalendarVcID = "NotesCalendarVcID"

// Add Travel From place & To place button tags
let addTravelFromPlace = "addTravelFromPlace"
let addTravelToPlace = "addTravelToPlace"
let addTPTravelFromPlace = "addTPTravelFromPlace"
let addTPTravelToPlace = "addTPTravelToPlace"

//MARK:- Font names
let fontRegular = "SFUIText-Regular"
let fontSemiBold = "SFUIText-Semibold"
let fontBold = "SFUIText-Bold"

//MARK:- Web Services Constants
let wsGET: String = "GET"
let wsPOST: String = "POST"
let wsTimeOutInterval = 300.0
//let companySubDomain: String = ".hidoctor.me"
let wsUserApi: String = "UserApi/"
let wsUser: String = "User/"
let wsCompanyApi: String = "CompanyApi/"
let wsWorkCategoriesApi: String = "WorkCategoriesApi/"
let wsSpecialityApi: String = "SpecialityApi/"
let wsLeaveTypeApi: String = "LeaveTypeApi/"
let wsTravelModeApi: String = "TravelModeApi/"
let wsProjectActivityApi: String = "ProjectActivityApi/"
let wsProductApi: String = "ProductApi/"
let wsCampaignPlannerApi: String = "CampaignPlannerApi/"
let wsDCRExpenseApi: String = "DCRExpenseApi/"
let wsTourPlannerApi: String = "TourPlannerApi/"
let wsTourPlan: String = "TourPlan/"
let wsDFCApi: String = "DFCApi/"
let wsDCRHeaderApi: String = "DCRHeaderApi/"
let wsDCRCalenderApi: String = "DCRCalenderApi/"
let wsDCRDoctorVisitApi:String = "DCRDoctorVisitApi/"
let wsSFCApi: String = "SFCApi/"
let wsCustomerApi: String = "CustomerApi/"
let wsDCRStockiestVisitApi: String = "DCRStockiestVisitApi/"
let wsHolidayApi: String = "HolidayApi/"
let wsDCRUploadApi: String = "DCRUploadApi/"
let wsUserPerdayReportAPI : String = "UserPerdayReportAPI/"
let wsDashboardApi: String = "DashboardApi/"
let wsHDReportsApi : String = "HDReports/"
let wsDCR : String = "DCR/"
let wsDoctorVisit : String = "DoctorVisit/"
let wsUserperday : String = "Userperday/"
let wsDoctor : String = "Doctor/"
let wsAttachments : String = "Attachments/"
let wsNoticeBoardListV1:String = "NoticeBoard/List/V1"
let wsNoticeBoardReadV1:String = "NoticeBoard/Read/V1"
let wsTourPlannerAccUserTPHeaderDetails:String = "TourPlanner/AccUser/TPHeaderDetails"
let wsTourPlannerAccUserTPSFCDetails :String = "TourPlanner/AccUser/TPSFCDetails"
let wsTourPlannerAccUserTPDoctorsDetails :String = "TourPlanner/AccUser/TPDoctorsDetails"
let wsTP: String = "TP/"
let wsMails: String = "Mails/"
let wsMessaging: String = "MessageApi/GetUsersForMessaging_V61/"
let wsUpdateMessageStatus_V61: String = "UpdateMessageStatus_V61/"
let wsMessagingApi: String = "MessageApi/"
let wsAssetProductMappingDetails :String = "Asset/Product/MappingDetails/"
let wsParentHierarchy : String = "ParentHierarchy/Users/"
let wsLeaveApproval : String = "DCRHeaderApi/Leave/"
let wsLeaveAppoveAndReject : String = "DCRHeaderApi/"

//MARK:-- Kennect Authorization Key
//let authorizationKey = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0eXBlIjoyMCwib3duZXIiOiJhZG1pbiIsImlkIjoiNWJjMGY0ZTVkYjcxZjE3NDgzZTc0MGI3IiwidXNlcm5hbWUiOiJ3YWxsYWNlQGtlbm5lY3QuaW4iLCJpYXQiOjE1NDIxNzkxNTYsImV4cCI6MTU2ODA5OTE1Nn0.nh1OhL2IVBfTgRMHtYbCOmkVLnR8uNQ9CeumGciU7Kr8wIRpleywzjIOF9997rZWTCNHWt1y_jv2ePeyHoKN86BVGiw18Qx52u1yQZlbNS5MjS1FiiywJnOM3ynTzGnZgi_Zd1BRap0w2QzQiIH6iKh7BD2610WkaxtjxRuXf2CaaeP4--TDlT3JbFE2t_CEWebEBnPtJnjhVExSjSKFWlJ0P0J27LjjpWCUBsuCsSkIi7O_9ss9jbW4NEQhT9ks2c7OiFM4BbZ0dvuq2NsBnqkoAPskLoD-zHryYggmBAbaWzihxHSflCKTFfR930YFno803cVF5jPQ1kZn3f3Eew"


let authorizationKey = BL_DCR_Doctor_Visit.sharedInstance.getMoneyTree()




//"eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0eXBlIjoyMCwib3duZXIiOiJhZG1pbiIsImlkIjoiNWJjMGY0ZTVkYjcxZjE3NDgzZTc0MGI3IiwidXNlcm5hbWUiOiJ3YWxsYWNlIiwidXNlckRhdGEiOnsibmFtZSI6IldhbGxhY2UgUGhhcm1hY2V1dGljYWxzIiwiZW1haWwiOiJ3YWxsYWNlQGtlbm5lY3QuaW4ifSwidGVuYW50IjoiNWJjMGY0ZTVkYjcxZjE3NDgzZTc0MGI3IiwiaWF0IjoxNTQ3NzkzOTYyLCJleHAiOjE1NzM3MTM5NjJ9.Utpmyk3nN74Wo51c_on94vjCtbP1yLa0Qiijg3f3ndM7CNcDYVGCJDT_1uSxh2b9ynkk1CGHHr-nbaFLFKOIUEK5ByxBUA917fQPcidrb6T_1RWpk_GHZ_PMMKYZNhS20MuFnIPjg9GKON1-Mo-T5GbI2Me4F90fBRXgL-KGgM2tEGsZGlqpbJnTHq5VI1OEeNc9TVZoCp0BfL-j2TsPbKG4K12yMyJLAmlEl-bTZOZmBRiMes6CtJtZLDzkTzy4ma7FbJJnMaFr7-u1yS3h6Y5ZpvdEh0QA-tWwj-1oRUMIThXz9LRPVY56N0WlNoVYC2RMrsG12UxSdhAygR_ZSQ"

//MARK:-- Login screen
let wsGetCompanyDetails: String = "GetCompanyDetailsV2/"
let wsGetUserAuthentication: String = "Authentication/V2/"
let wsRequestPassword: String = "GetandSendPassWord/"
let wsGetActivity: String = "GetActivity/"

// MARK:-- Prepare My Device
let wsGetUserPrivileges: String = "GetUserPrivileges/"
let wsGetConfigSettings: String = "GetConfigSettings/"
let wsGetWorkCategories: String = "GetWorkCategories/"
let wsGetSpeciality: String = "GetSpeciality/"
let wsGetLeaveTypeMaster: String = "GetLeaveTypeMaster/"
let wsGetTravelModes: String = "GetTravelModes/"
let wsGetSaleProducts: String = "GetSaleProducts/"
let wsGetSaleProductsForSKU: String = "GetSaleProductsForSKU/"
let wsGetCampaignPlannerHeader: String = "GetCampaignPlannerHeader/"
let wsGetCampaignPlannerSFC: String = "GetCampaignPlannerSFC/"
let wsGetCampaignPlannerDoctors: String = "GetCampaignPlannerDoctors/"
let wsGetExpenseTypeWithGroup: String = "GetExpenseTypeWithGroup/"
let wsGetTPHeaderDetailsV61: String = "GetTPHeaderDetailsV61"
let wsGetTPAccompanistDetailsForDCR: String = "GetTPAccompanistDetailsForDCR"
let wsGetTPSFCDetailsV61: String = "GetTPSFCDetailsV61"
let wsGetTPDoctorsDetailsV61: String = "GetTPDoctorsDetailsV61"
let wsGetTPAccompanistDetails: String = "GetTPAccompanistDetails"
let wsGetTPProducts: String = "GetTPProducts"
let wsUnfreeze: String = "Unfreeze/"
let wsDates: String = "Dates"
let wsGetDFC: String = "GetDFC/"
let wsGetUserProducts_V59: String = "GetUserProducts_V59/"
let wsGetAccompanistData: String = "GetAccompanistData_V62/"
let wsGetDCRCalenderDetails: String = "GetDCRCalenderDetails/"
let wsGetDCRHeaderDetails: String = "GetDCRHeaderDetails/"
let wsGetDCRTravelledPlaces: String = "GetDCRTravelledPlaces/"
let wsGetDCRAccomapnists: String = "GetDCRAccomapnists/"
let wsGetDCRDoctorVisitDetails: String = "GetDCRDoctorVisitDetails/"
let wsGetDCRSampleDetails: String = "GetDCRSampleDetails/"
let wsGetDCRDetailedProductsDetails: String = "GetDCRDetailedProductsDetails/"
let wsGetDCRChemistVisitDetails: String = "GetDCRChemistVisitDetails/"
let wsGetDCRRCPADetails: String = "GetDCRRCPADetails/"
let wsGetDCRExpenseDetails: String = "GetDCRExpenseDetails/"
let wsGetSFCData: String = "GetSFCData/"
let wsGetCustomerData: String = "GetCustomerData_V59/"
let wsGetCustomerData60: String = "GetCustomerData_V60/"
let wsGetDCRStockiestVisitDetails: String = "GetDCRStockiestVisitDetails/"
let wsGetAccompanistCustomerData: String = "GetAccCustomerData/"
let wsGetAccompanistSFCData: String = "GetSFCData_V61/"
let wsGetAccompanistCPHeader: String = "getCampaignPlannerHeader_V61/"
let wsGetAccompanistCPSFC: String = "getCampaignPlannerSFC_V61/"
let wsGetAccompanistCPDoctor: String = "getCampaignPlannerDoctors_V61/"
let wsGetHolidayDetails: String = "GetHolidayDetials/"
let wsGetDcrTimesheetEntry: String = "GetDcrTimesheetEntry/"
let wsGetCompetitor: String = "GetCompetitor/"
let wsGetDCRDoctorAccompanist: String = "GetDCRDoctorAccompanist/"
let wsOnlineInsertLeave: String = "OnlineInsertLeave/"
let wsGetDCRCalenderDetailsV59: String = "GetDCRCalenderDetailsV59"
let wsGetDCRHeaderDetailsV59: String = "GetDCRHeaderDetailsV59"
let wsGetDCRAccompanistV59: String = "GetDCRAccompanistV59"
let wsGetDCRTravelledPlacesV59: String = "GetDCRTravelledPlacesV59"
let wsGetDCRTimeSheetEntryV59: String = "GetDCRTimeSheetEntryV59"
let wsGetDCRDoctorVisitDetailsV59: String = "GetDCRDoctorVisitDetailsV59"
let wsGetDCRDoctorAccompanistV59: String = "GetDCRDoctorAccompanistV59"
let wsGetDCRSampleDetailsV59: String = "GetDCRSampleDetailsV59"
let wsGetDCRDetailedProductsDetailsV59: String = "GetDCRDetailedProductsDetailsV59"
let wsGetDCRChemistVisitDetailsV59: String = "GetDCRChemistVisitDetailsV59"
let wsGetDCRRCPADetailsV59: String = "GetDCRRCPADetailsV59"
let wsAttachment :  String = "Attachments"
let wsGetDCRStockiestVisitDetailsV59: String = "GetDCRStockiestVisitDetailsV59"
let wsGetDCRExpenseDetailsV59: String = "GetDCRExpenseDetailsV59"
let wsGetLockLeaves: String = "GetLockLeaves/V2/"
let wsUploadDCRStagingV59: String = "UploadDCRStagingV66"
let wsGetUserTypeMenuAccess: String = "GetUserTypeMenuAccess/"
let wsGetDCRMenuAccess: String = "GetDCRATotalAppliedCount/"
let wsGetTPMenuAccess: String = "GetTPTotalAppliedCount/"
let wsGetLockedDataAccess: String = "GetLockedDataCount/"
let wsGetActivityLockedDataAccess: String = "ActivityLockedDataCount/"
let wsGetTPUserWiseAppliedList: String = "GetTPUserWiseAppliedCount_V77/"
let wsGetDCRUserWiseAppliedList: String = "GetDCRUserWiseAppliedCount_V77/"
//let wsGetTPUserWiseAppliedList: String = "GetTPUserWiseAppliedCount/"
//let wsGetDCRUserWiseAppliedList: String = "GetDCRUserWiseAppliedCount/"
let wsGetLockRealseUserWiseList: String = "GetLockedUniqueUserList/"
let wsActivityLockedUniqueUserList = "ActivityLockedUniqueUserList/"
let wsGetAppliedTPlistforPerUser: String = "GetAppliedTPlistforPerUser/"
let wsUpdateDCRLockToRelease: String = "UpdateDCRLockToRelease/"
let wsUpdateDCRActivityLockToRelease: String = "DCRActivityLockRelease/"
let wsGetSelectedUserDCRDetails: String = "GetSelectedUserDCRDetails/"

//MARK:- Approval
let wsGetDCRMonthWiseCount : String = "GetDCRMonthWiseCount/"
let wsCheckUserExist : String = "CheckUserExist/"
let wsCheckUserExistWithSessionId : String = "CheckUserExistsWithSessionID/V2"
let wsGetTPMonthWiseCount : String = "GetTPMonthWiseCount/"
let wsPendingApprovalLeave : String = "ApprovalPendingUserDetails/"


//MARK:-DCR Approval
let wsGetDCRAccompanistForUserPerdayReport : String = "GetDCRAccompanistForUserPerdayReport/"
let wsGetDCRADoctorVisitDetails : String = "GetDCRADoctorVisitDetails/"
let wsGetDCRDoctorAccompanistForADoctorVisit : String = "GetDCRDoctorAccompanistForADoctorVisit/"
let wsGetDCRSampleDetailsForADoctorVisit : String = "GetDCRSampleDetailsForADoctorVisit/"
let wsGetDCRDetailedProductsDetailsForADoctorVisit : String = "GetDCRDetailedProductsDetailsForADoctorVisit/"
let wsGetDCRChemistVisitDetailsForADoctorVisit : String = "GetDCRChemistVisitDetailsForADoctorVisit/"
let wsGetDCRRCPADetailsForADoctorAndChemistVisit : String = "GetDCRRCPADetailsForADoctorAndChemistVisit/"

//MARK:-Field

let wsGetDCRAccompanistForUserPerday:String = "GetDCRAccompanistForUserPerday"
let wsGetDCRHeaderDetailsForUserPerdayReport : String = "GetDCRHeaderDetailsForUserPerdayReportV64"
let wsGetDCRTravelledPlacesForUserPerday : String = "GetDCRTravelledPlacesForUserPerdayV64"
let wsGetDCRDoctorVisitDetailsForUserPerday : String  = "GetDCRDoctorVisitDetailsForUserPerday"
let wsGetDCRStockiestVisitDetailsForUserPerday : String = "GetDCRStockiestVisitDetailsForUserPerday"
let wsGetDCRExpenseDetailsUserPerday : String = "GetDCRExpenseDetailsUserPerdayV64"
let wsFollowups : String = "Followups/"

//MARK:-ORDER

let wsOrder : String = "Order/"
let wsOrderList : String = "OrderList"
let wsOrderListV63 :String = "OrderListV63"

//MARK:-Attendance

let wsGetDCRTimeSheetEntryForUserPerday : String = "GetDCRTimeSheetEntryForUserPerday"

//MARK :-Approval Status Update

//let wsUpdateDCRStatus : String = "UpdateDCRStatusV66/"
let wsUpdateDCRStatus : String = "UpdateDCRStatusV68/"
let wsUpdateTPStatus : String = "UpdateTPStatus68/"
let wsUpdateLeaveDCRStatus : String = "UpdateLeaveDCRStatus/"

//MARK:- Lock Release
let wsgetLockedDetailsForPeruser: String = "getLockedDetailsForPeruser/"
let wsGetReleaseHistoryDetails : String  = "GetReleaseHistoryDetails/"

//MARK:- Dashboard
let wsGetDashboardDetails: String = "GetDashboardDetails/"
let wsGetAppliedDCRDates: String = "GetAppliedDCRDates/"
let wsGetMissedDoctors: String = "GetMissedDoctors/"
let wsGetDashboardDetails_V61: String = "GetDashboardDetails_V61/"
let wsGetDocumentType : String = "DocumentType/List/V1"
let wsDashboard : String = "Dashboard/"
let wsGetDashboardPSValues = "PSValues"
let wsGetDashboardPSProductValues : String = "PSProductValues"
let wsDashboardCollectionValues : String = "CollectionValues"
let wsUsage : String = "Usage/"
let wsCount : String = "Count/"
let wsDashboardAssetDetails: String = "ReadUnread/Details"
let wsTop10Asset : String = "Top10Asset/"
let wsTop10Doctor : String = "Top10Doctor/"

//MARK:- TP
let wsTPUploadV61: String = "TPUploadV61/"
let wsTPUploadV62: String = "TPUploadV62/"
let wsGetTPDoctorAttachment: String = "GetTPDoctorAttachments"

//MARK:- Change Password
let wsUpdateResetPassword : String = "UpdateResetPassword/V2/"

//MARK:- Delete DCR
let wsCheckDCRExist : String = "CheckDCRExist/"

//MARK:- Doctor Visit Tracker
let wsInsertDoctorVisitTracker: String = "InsertDoctorVisitTracker/"
let wsUploadDCRAttachment: String = "DCRDoctorVisit/Attachment/Upload/"
let wsUploadTPAttachment: String = "TP/DoctorAttachment/Upload/"
let wsUploadChemistAttachment: String = "DCRChemistVisit/Attachment/Upload/"
let wsUploadLeaveAttachment: String = "DCRDoctorVisit/UploadLeaveAttachment/"

//MARK:- HourlyReport
let wsGethourlyRpt : String = "HourlyRptDetails/"
let wsGethourlyRptSummary : String = "HourlyReport/Summary/"
let wsGetTravelTrackReportSummary : String = "CustomerApi/CustomerTrack/"

//MARK:- Edetailing
let wsAsset : String = "Asset/"
let wsHeader : String = "Header/"
let wsList : String = "List/"
let wsV1 : String = "V1"
let wsDetails : String = "Details/"
let wsImages : String = "Images/"
let wsUpload : String = "Upload/"
let wsCustomerwiseAnalyticsDetails :String = "CustomerwiseAnalyticsDetails/"
let wsCustomer : String = "Customer/"
let wsDAAnalytics : String = "DA/Analytics/"
let wsDAFeedback: String = "DA/Feedback/"
let wsStory: String = "MC/Story"
let liked : String = "Liked"
let disLiked : String = "Disliked"
let average : String = "Average"
let invalid : String = "Invalid"
let firstAssetToast = "you're at the first Digital Resource"
let lastAssetToast = "you're at the last Digital Resource"
let wsVisitFeedback = "Visit/Feedback"

//MARK:- ChemistDay
let chemistVisitPerDay = "ChemistVisit/Perday/"
let userperdayChemistVisitAccompanist = "Userperday/ChemistVisit/Accompanist/"
let userperdayChemistVisitAttachments = "Userperday/ChemistVisit/Attachments/"
let userperdayChemistVisitFollowups = "Userperday/ChemistVisit/Followups/"
let userperdayChemistVisitSamplePromotion = "Userperday/ChemistVisit/SamplePromotion/"
let userperdayChemistVisitDetailedProducts = "Userperday/ChemistVisit/DetailedProducts/"
let userperdayChemistVisitRCPAOwnProducts = "Userperday/ChemistVisit/RCPAOwnProducts/"
let userperdayChemistVisitRCPACompetitorProducts = "Userperday/ChemistVisit/RCPACompetitorProducts/"
let userApiModuleWiseAccess = "UserApi/ModuleWiseAccess/"
let dcrDoctorVisitAPIGetDCRChemistAccompanist = "DCRDoctorVisitAPI/GetDCRChemistAccompanistV59/"
let dcrDoctorVisitAPIGetDCRChemistSamplePromotion = "DCRDoctorVisitAPI/GetDCRChemistSamplePromotion/"
let dcrDoctorVisitAPIGetDCRChemistDetailedProductsDetails = "DCRDoctorVisitAPI/GetDCRChemistDetailedProductsDetails/"
let dcrDoctorVisitAPIGetDCRChemistRCPAOwnProductDetails = "DCRDoctorVisitAPI/GetDCRChemistRCPAOwnProductDetails/"
let dcrDoctorVisitAPIGetDCRChemistRCPACompetitorProductDetails = "DCRDoctorVisitAPI/GetDCRChemistRCPACompetitorProductDetails/"
let dcrChemistDayFollowups = "DCR/ChemistDay/Followups/"
let dcrChemistDayAttachments = "DCR/ChemistDay/Attachments/"
let userperdayChemistVisitDetails = "DCRDoctorVisitAPI/ChemistVisitDetailsForDate"
let wsCustomerSpeciality = "CustomerSpeciality/"
let wsCustomerCategory = "CustomerCategory/"

//MARK:- Story
let storyPendingAssetDownloadAlert: String = "Some of the digital resources are yet to download."
let storyProgressAssetDownloadAlert: String = "Some of the digital resources are downloading. Please wait.."

enum customerEntityInt : Int
{
    case Doctor = 1
    
}

enum sampleBatchEntity : String
{
    case Doctor = "Field_Doctor"
    case Chemist = "Field_Chemist"
    case Attendance = "Attendance_Doctor"
    
}

enum customerEntityDescribtion : String
{
    case Doctor = "DOCTOR"
    
}

enum LandingAlertValue : String
{
    case NOTICEBOARD = "NOTICEBOARD"
    case INWARD = "INWARD"
    case MESSAGE = "MESSAGE"
    case TASK = "TASK"
}

enum ActivityFlag: String
{
    case Field = "F"
}


enum isFileDownloaded : Int
{
    case pending = 0
    case progress = 1
    case completed = 2
}

enum ScreenName: String
{
    case Empty = ""
}

//MARK :- Format
var defaultDateFomat = String()
let defaultDateAndTimeFormat = "dd/MM/yyyy HH:mm a"
let defaultDataAndTimeServerFormat = "yyyy-MM-dd HH:mm:ss.SSS"
let dateTimeWithoutMilliSec = "yyyy-MM-dd HH:mm:ss"
let dateTimeForAssets = "yyyy-MM-dd HH:mm:ss"
let defaultTimeZone = "UTC"
let defaultServerDateFormat = "yyyy-MM-dd"
let displayDateAndTimeFormat = defaultDateFomat + " \(timeFormat)"
let timeFormat = "hh:mm a"
let timeFormat24Hour = "HH:mm"
let utcTimeZone = NSTimeZone(abbreviation: defaultTimeZone)! as TimeZone
let localTimeZone = NSTimeZone.local
let usLocale =  NSLocale(localeIdentifier: "en_US") as Locale

//MARK:-Db Constants

enum DatabaseMigrationString : String
{
    case version1 = "migrationV1"
    case version2 = "migrationV2"
    case eDetailingVersion = "migrationV3"
    case eDetailingVersion2 = "migrationV4"
    case eDetailingVersion3 = "migrationV5"
    case TPVersion = "TPVersion"
    case FDC_Pilot = "FDCPilot"
    case ChemistDay = "ChemistDay"
    case DOCTOR_MASTER = "DOCTOR_MASTER"
    case AlertBuild = "AlertBuild"
    case PasswordPolicy = "PasswordPolicy"
    case DOCTORPOB = "DoctorPOB"
    case DOCTORINHERITANCE = "DoctorInheritance"
    case ICE = "Ice"
    case HOURLY_REPORT_CHANGE = "HourlyReportChange"
    case SAMPLEBATCH = "SampleBatch"
    case INWARDBATCH = "InwardBatch"
    case ATTENDANCEACTIVITY = "AttendanceActivity"
    case ACCOMPANISTCHANGE = "AccompanistLogicChange"
    case MCINDOCTORVISIT = "MCInDoctorVisit"
    case BUSSINESSPOTENTIAL = "BussinessPotential"
    case MENUCUSTOMIZATION = "MenuCustomization"
    case STOCKIST = "STOCKIST"
    case ENTITYTYPE = "EntityType"
    case HOSPITALNAME = "HospitalName"
    case TRAVELTRACKINGREPRT = "TravelTrackingReport"
    case HOURLYREPORTVISIT = "HourlyReportVisit"
    case HOSPITAL = "Hospital"
    case ADDRESS = "Address"
    case ATTACHMENT = "Attachment"
    case ACCOUNTNUMBER = "AccountNumber"
    case TPATTACHMENT = "TPAttachment"
}

enum masterDataGroupName : String
{
    case prepareMyDevice = "prepareMyDevice"
    case DownloadAllMasterData = "Download all Master Data"
    case SystemSettings = "System Settings"
    case HolidayData = "Holiday Data"
    case DoctorData = "Doctor/Customer Data"
    case ExpenseData = "Expense data"
    case ProductData = "Product data"
    case CpTpDetails = "Cp & Tp Details"
    case SFCAccompanistData = "SFC & Accompanist Data"
    case MenuData = "Menu Data"
    case DigitalAssets = "Digital Assets"
    case MarketContent = "Market Content"
}

enum DCR_Stepper_Entity_Id: Int
{
    case Accompanist = 0
    case WorkPLace = 1
    case SFC = 2
    case Doctor = 3
    case Chemist = 4
    case Stockist = 5
    case Expense = 6
    case GeneralRemarks = 7
    case Work_Time = 8
}

let MST_COMP_DETAILS = "mst_Company_Details"
let MST_USER_DETAILS = "mst_User_Details"
let MST_PRIVILEGES = "mst_Privileges"
let TRAN_CONFIG_SETTINGS = "tran_Config_Settings"
let MST_WORK_CATEGORY = "mst_Work_Category"
let MST_SPECIALTIES = "mst_Speciality"
let TRAN_LEAVE_TYPE_MASTER = "tran_Leave_Type"
let ONBOARDSHOWN = "Onboard_Shown"
let TRAN_TRAVEL_MODE_MASTER = "tran_Travel_Mode"
let MST_PROJECT_ACTIVITY = "mst_Project_Activity"
let MST_DETAIL_PRODUCTS = "mst_Detail_Products"
let MST_CP_HEADER = "mst_CP_Header"
let MST_CP_SFC = "mst_CP_SFC"
let MST_CP_DOCTORS = "mst_CP_Doctors"
let MST_EXPENSE_GROUP_MAPPING = "mst_Expense_Groups"
let TRAN_TP_HEADER = "tran_TP_Header"
let TRAN_TP_SFC = "tran_TP_SFC"
let TRAN_TP_DOCTOR = "tran_TP_Doctors"
let TRAN_TP_ACCOMPANIST = "tran_TP_Accompanists"
let TRAN_TP_PRODUCT = "tran_TP_Products"
let TRAN_TP_UNFREEZE_DATES = "tran_TP_Unfreeze_Dates"
let MST_DFC = "mst_DFC"
let MST_USER_PRODUCT = "mst_User_Products"
let MST_SAMPLE_BATCH_MAPPING = "mst_Sample_Batch_Mapping"
//let MST_API_DOWNLOAD_DETAIL = "mst_API_Download_Details"
let MST_ACCOMPANIST = "mst_Accompanist"
let TRAN_DCR_CALENDAR_HEADER = "tran_DCR_Calendar_Header"
let TRAN_DCR_HEADER = "tran_DCR_Header"
let TRAN_DCR_TRAVELLED_PLACES = "tran_DCR_Travelled_Places"
let TRAN_DCR_ACCOMPANIST = "tran_DCR_Accompanist"
let TRAN_DCR_DOCTOR_ACCOMPANIST = "tran_DCR_Doctor_Accompanist"
let TRAN_DCR_DOCTOR_VISIT = "tran_DCR_Doctor_visit"
let TRAN_DCR_SAMPLE_DETAILS = "tran_DCR_Sample_Details"
let TRAN_DCR_SAMPLE_DETAILS_MAPPING = "tran_DCR_Sample_Details_Mapping"
let TRAN_DCR_DETAILED_PRODUCTS = "tran_DCR_Detailed_Products"
let TRAN_DCR_CHEMISTS_VISIT = "tran_DCR_Chemists_Visit"
let TRAN_DCR_RCPA_DETAILS = "tran_DCR_RCPA_Details"
let TRAN_DCR_STOCKIST_VISIT = "tran_DCR_Stcokiest_Visit"
let TRAN_DCR_EXPENSE_DETAILS = "tran_DCR_Expense_Details"
let MST_API_DOWNLOAD_DETAILS = "mst_API_Download_Details"
let MST_APP_STATUS = "mst_App_Status"
let MST_ACCOMPANIST_DATA_DOWNLOAD_DETAILS = "mst_Accompanist_Data_Download_Details"
let MST_SFC_MASTER = "mst_SFC_Master"
let MST_CUSTOMER_MASTER = "mst_Customer_Master"
let MST_HOLIDAY_MASTER = "mst_Holiday_Master"
let TRAN_DCR_ATTENDANCE_ACTIVITIES = "tran_DCR_Attendance_Activities"
let MST_FLEXI_DOCTOR = "mst_Flexi_Doctor"
let MST_FLEXI_CHEMIST = "mst_Flexi_Chemist"
let MST_FLEXI_PLACE = "mst_Flexi_Place"
let MST_COMPETITOR_PRODUCT = "mst_Competitor_Products"
let MST_COMPETITOR_PRODUCT_MASTER = "mst_Competitor_Products_master"
let MST_MENU_MASTER = "mst_Menu_Master"
let MST_DASHBOARD_HEADER = "mst_Dashboard_Header"
let MST_DASHBOARD_DETAILS = "mst_Dashboard_Details"
let MST_DASHBOARD_DATE_DETAILS = "mst_Dashboard_Date_Details"
let MST_DASHBOARD_MISSED_DOCTOR = "mst_Dashboard_Missed_Doctor"
let TRAN_DCR_DOCTOR_VISIT_TRACKER = "tran_DCR_Doctor_Visit_Tracker"
let TRAN_DCR_CUSTOMER_FOLLOW_UPS  = "tran_DCR_Customer_Follow_Ups"
let MST_VERSION_UPGRADE_INFO = "mst_Version_Upgrade_Info"
let TRAN_DCR_DOCTOR_VISIT_POB_DETAILS = "tran_DCR_Doctor_Visit_POB_Details"
let TRAN_DCR_DOCTOR_VISIT_POB_HEADER = "tran_DCR_Doctor_Visit_POB_Header"
let TRAN_DCR_DOCTOR_VISIT_POB_REMARKS = "tran_DCR_Doctor_Visit_POB_Remarks"
let TRAN_DCR_DOCTOR_VISIT_ATTACHMENT = "tran_DCR_Doctor_Visit_Attachment"
let TRAN_TP_DOCTOR_VISIT_ATTACHMENT = "tran_TP_Doctor_Visit_Attachment"
let TRAN_PS_Header = "tran_PS_Header"
let TRAN_PS_ProductDetails = "tran_PS_Product_Details"
let TRAN_PS_Collection_Values = "tran_PS_Collection_Values"
let NOTICEBOARD_DETAIL = "NOTICEBOARD_DETAIL"
let NOTICEBOARD_DOWNLOAD = "NOTICEBOARD_DOWNLOAD"
let TRAN_ED_ASSET_PRODUCT_MAPPING = "tran_ED_Asset_Product_Mapping"
let TRAN_DAY_WISE_ASSETS_DETAILED = "tran_Day_Wise_Assets_Detailed"
let MST_DOCTOR_PRODUCT_MAPPING = "mst_Doctor_Product_Mapping"
let TRAN_ED_DOCTOR_LOCATION_INFO = "Tran_ED_Doctor_Location_Info"
let MST_CUSTOMER_MASTER_EDIT = "mst_Customer_Master_Edit"
let MST_CUSOMTER_MASTER_PERSONAL_INFO_EDIT = "mst_Customer_Master_Personal_Info_Edit"
let MST_MC_DOCTOR_PRODUCT_MAPPING = "mst_MC_Doctor_Product_Mapping"
let MST_CUSTOMER_ADDRESS = "mst_Customer_Address"
let TRAN_DCR_ATTENDANCE_DOCTOR_VISIT = "tran_DCR_Attendance_Doctor_Visit"
let TRAN_DCR_ATTENDANCE_SAMPLES_DETAILS = "tran_DCR_Attendance_Samples_Details"
let MST_MC_DETAILS = "mst_MC_Details"
let MST_DIVISION_MAPPING_DETAILS = "mst_Division_Mapping_Details"
let BUSINESS_STATUS_POTENTIAL = "business_Status_Potential"
let Travel_Tracking_Report = "TravelTrackingReport"
let Hourly_Report_Visit = "Hourly_Report_Visit"
let TRAN_DCR_LEAVE_ATTACHMENT = "tran_DCR_Leave_Attachment"
let Notes_Attachment = "Notes_Attachment"
let TRAN_CUSTOMER_HOSPITAL_INFO = "tran_Customer_Hospital_Info"

// message tables
let TRAN_MAIL_MESSAGE_HEADER = "tran_Mail_Message_Header"
let TRAN_MAIL_MSG_CONTENT = "tran_Mail_Msg_Content"
let TRAN_MAIL_MSG_ATTACHMENT = "tran_Mail_Msg_Attachments"
let TRAN_MAIL_MSG_AGENT = "tran_Mail_Msg_Agent"

// Acticity tables
let TRAN_DCR_CALL_ACTIVITY = "TRAN_DCR_CALL_ACTIVITY"
let TRAN_DCR_MC_ACTIVITY = "TRAN_DCR_MC_ACTIVITY"
let MST_CALL_ACTIVITY = "MST_CALL_ACTIVITY"
let MST_BUSINESS_STATUS = "mst_Business_Status"
let MST_MC_HEADER = "MST_MC_HEADER"
let MST_MC_MAPPED_REGION_TYPES = "MST_MC_MAPPED_REGION_TYPES"
let MST_MC_CATEGORY = "MST_MC_CATEGORY"
let MST_MC_SPECIALITY = "MST_MC_SPECIALITY"
let MST_MC_ACTIVITY = "MST_MC_ACTIVITY"
let MST_CALL_OBJECTIVE = "mst_Call_Objective"
let MST_REGION_ENTITY_COUNT = "mst_Region_Entity_Count"
let MST_CUSTOMER_FIELD_MAPPING = "mst_Customer_Field_Mapping"
let TRAN_ERROR_LOG = "tran_Error_Log"
let TRAN_DCR_EDETAIL_DOCTOR_DELETE_AUDIT = "tran_DCR_EDetail_Doctor_Delete_Audit"
let TRAN_DCR_COMPETITOR_DETAILS = "tran_DCR_Competitor_Details"
let MST_COMPETITOR_MAPPING = "mst_Competitor_Mapping"

// chemistDay tables
let TRAN_DCR_CHEMIST_VISIT_DETAIL = TRAN_DCR_CHEMISTS_VISIT
let TRAN_DCR_CHEMIST_ACCOMPANIST = "tran_DCR_Chemist_Accompanist"
let TRAN_DCR_CHEMIST_SAMPLE_PROMOTION  = "tran_DCR_Chemist_Sample_Promotion"
let TRAN_DCR_CHEMIST_DETAILED_PRODUCT = "tran_DCR_Chemist_Detailed_Product"
let TRAN_DCR_CHEMIST_RCPA_OWN = "tran_DCR_Chemist_RCPA_Own"
let TRAN_DCR_CHEMIST_RCPA_COMPETITOR = "tran_DCR_Chemist_RCPA_Competitor"
let TRAN_DCR_CHEMIST_ATTACHMENT = "tran_DCR_Chemist_Attachement"
let TRAN_DCR_CHEMIST_FOLLOWUP = "tran_DCR_Chemist_Followup"
let TRAN_DCR_CHEMIST_DAY_VISIT = "tran_DCR_Chemist_Day_visit"

// eDetailing tables
let MST_ASSET_HEADER = "mst_Asset_Header"
let MST_ASSET_TAG_DETAILS = "mst_Asset_Tag_Details"
let MST_ASSET_PARTS = "mst_Asset_Parts"
let MST_VIDEO_FILE_DOWNLOAD_INFO = "mst_Video_File_Download_Info"
let MST_ASSET_PRESET = "mst_Asset_Preset"
let TRAN_ASSET_ANALYTICS_SUMMARY = "tran_Asset_Analytics_Summary"
let TRAN_ASSET_ANALYTICS_DETAILS = "tran_Asset_Analytics_Details"
let TRAN_DOWNLOADED_ASSET = "tran_Downloaded_Asset"
let TRAN_DCR_DA_DATA = "tran_DCR_DA_Data"
let TBL_EL_CUSTOMER_DA_FEEDBACK = "tbl_EL_Customer_DA_Feedback"
let TBL_CUSTOMER_TEMP_SHOWLIST = "tbl_Customer_Temp_Showlist"
let MST_MC_STORY_HEADER = "mst_MC_Story_Header"
let MST_MC_STORY_CATEGORIES = "mst_MC_Story_Categories"
let MST_MC_STORY_SPECIALITIES = "mst_MC_Story_Specialities"
let MST_MC_STORY_ASSETS = "mst_MC_Story_Assets"
let TRAN_MC_STORY_ASSET_LOG = "tran_MC_Story_Asset_Log"
let MST_LOCAL_STORY_HEADER = "mst_Local_Story_Header"
let MST_LOCAL_STORY_ASSETS = "mst_Local_Story_Assets"
let TRAN_LOCAL_STORY_ASSET_LOG = "tran_Local_Story_Asset_Log"
let TBL_ED_DOCTOR_VISIT_FEEDBACK = "tbl_ED_Doctor_Visit_Feedback"
let TRAN_MASTER_DATA_DOWNLOAD_CHECK_API_INFO = "tran_Master_Data_Download_Check_API_Info"
let TRAN_PASSWORD_EXPIRY_NOTIFICATION_REMINDER = "tran_Password_Expiry_Notification_Reminder"

//MARK:-Internet Connection Constants
var networkStatus : Bool = false
let internetOfflineTitle : String = "Can't Connect"
let internetOfflineMessage : String = "Your are offline. Check your network and try again"
let serverSideError : String = "Problem connecting to the server"
let yes = "YES"
let no = "NO"

//MARK:- Alert Title
let infoTitle = "Info"
let errorTitle = "Error"
let successTitle = "Success"
let alertTitle = "Alert"
let filterTitle = "Apply Filter changes"
let filterMsg = "Would you like to apply the changes?"
let filterErrorMsg = "Please select atleast one option"
let ok = "OK"
let skip = "SKIP"
let exit = "Exit"
let apply = "Apply"
let PREPARE_MY_DEVICE = "PREPARE_MY_DEVICE"
let networkDisabledTitle = "Location Services"
let networkDisabledMessage  = "Location services are disabled. Please enable location services for \(appName) and proceed further"
let networkCaptureMessage = "Unable to capture location"
let cancel = "CANCEL"
let settings = "SETTINGS"
let retry = "RETRY"
let defaultBusinessStatusName: String = "Select Business Status"
let defaultBusineessStatusId: Int = 0
let defaultBusinessStatusActviveStatus: Int = 1
let defaultCallObjectiveName: String = "Select Call Objective"
let defaultCallObjectiveId: Int = 0
let defaultCallObjectiveActviveStatus: Int = 1
let defaultCampaignName: String = "Select Campaign"
let defaultCampaignId: Int = 0
let defaultCampaignActviveStatus: Int = 1
let defaultBusinessPotential: String = "-1.0"

//MARK:- Navigation bar button titles
let nbCancelTitle = "Cancel"
let nbDoneTitle = "Done"

//MARK:- Aunthentication Title
let authenticationTxt = "Checking user Authentication"
let authenticationMsg = "Dear User, Your Authentication was failed. Please contact your sales administrator"

//MARK:- Color Values
let brandColor = UIColor(red: 42.0/255.0, green: 92.0/255.0, blue: 165.0/255.0, alpha: 1.0)
let navigationBarText = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)

//MARK:- Onboard
enum OnBoardScreenName : String
{
    case whatsNew = "whatsNew"
}

//MARK:- DCR Calendar
let fieldRcpa : String = "Field"
let attendance : String = "Office"
let leave : String = "Not Working"
let applied : String = "Applied"
let approved : String = "Approved"
let drafted : String = "Drafted"
let unApproved : String = "Unapproved"
let holiday : String = "Holiday"
let lockLeave : String = "Locked leave"

//MARK: - Time Picker Constant

let timePickerHeight : CGFloat = 150

//MARK: - Add Work Details

let defaultWorkCategoryType = "SELECT WORK CATEGORY"
let defaultWorkCategoryCode = "0"

//MARK:- DCR Label name based on privileges
var appDoctor:  String = ""
var appChemist: String = ""
var appStockiest: String = ""
var appDoctorPlural: String = ""
var appChemistPlural: String = ""
var appStockiestPlural: String = ""
var appCp: String = "Saved Routing Name"

//MARK:- DCR Calendar validation messages
let activityConfigErrorMsg : String = "You are not allowed to enter more than one activity"
let seqValidPrefixErrorMsg : String = "You have missed dvr entry for the date"
let seqValidSuffixErrorMsg : String = "Please fill and proceed."
let seqDCRStatusValidPrefixErrorMsg : String = "You have drafted/unapproved dvr entry for the date"
let seqDCRStatusValidSuffixErrorMsg : String = "Please submit and proceed."
let lockDcrErrorMsg : String = "Your DVR date is locked"
let addDCRErrorMsg: String = "Not allowed to enter DVR before your joining date"

// MARK: - DCR Upload status messages
let pendingStatus : String = "Pending"
let skippedStatus : String = "Skipped"
let successStatus : String = "Success"
let progressStatus : String = "IN PROGRESS"
let failedStatus : String = "FAILED"
let completedStatus : String = "COMPLETED"
let retryStatus : String = "RETRY"
let refreshStatus : String = "REFRESHING DVR"
let dcrUploadSeqValMsg : String = "You have Draft or unapproved DVR for previous dates. Please complete that DVR first. Tap on PROCEED button to refreh DVR"
let dcrRefreshErrorMsg : String = "All your Server(main site) data as on date will get downloaded into app. By proceeding.. if any Draft/Applied offline DVRs(not uploaded), then those DVRs will be removed from app. Click Proceed to continue OR click Cancel."

//MARK:- Add travel details error messages
let fromPlaceErrorMsg : String = "Please fill the From place"
let toPlaceErrorMsg : String = "Please fill the To place"
let travelModeErrorMsg : String = "Please select the travel mode"
let distanceErrorMsg : String = "Please enter the Distance"
let sfcValidationErrorMsg : String = "Your entered route is not available in your SFC master or may be expired."
let sfcMineValMsg: String = "Your entered route is not available for your selected category"
let circularValidationCheck : String = "Please complete your travelled places."
let sfcDuplicationErrorMsg : String = "You have entered more than one same travelled Places. Please remove one."
let sfcIntermediateErrorMsg: String = "Intermediate route is not applied for selected work category. Hence cannot add a route"
let sfcCircularRouteErrorMsg: String = "Circle route is enabled. Hence cannot add a route"
let sfcUpdateToastMsg: String = "Your SFC gets updated"
let sfcAutoCompleteText: String = "System created auto complete route"

//MARK:- Work place error messages
let workCategoryValErrorMsg = "Selected work category does not belong to selected CP"

//MARK:- Webview error messages
let webTryAgainMsg = "Couldn't load the content. Please check the url"
let attachWebTryAgainMsg = "Couldn't load the attachment. Please try again"

//MARK:- DCR Doctor visit validation messages
let accompMissedPrefixErrorMsg : String = "You are missed to select the 'Accompanied Call' for MR."
let accompMissedSuffixErrorMsg : String = ". Please select any one of the options"

//MARK:- DCR Doctor visit asset details
let assetName: String = "Digital Resource name: "
let assetType: String = "Digital Resource type: "
let viewedPages: String = "Viewed pages: "
let uniquePages: String = "Unique pages: "
let viewedDuration: String = "Viewed duration: "

//MARK:- Doctor details
let defaultTagCount = 4

//MARK:- EDetailing Message

let assetDownloadMessage = "Downloading Digital Resource(s)"
let htmlDownloadMessage = "Selected digital resource can be viewed in offline only"
let ratingSelectMessage = "Please give rating for the Digital Resource"

//MARK:- Maximum length
let flexiPlaceMaxLength = 100
let flexiChemistMaxLength = 50
let flexiDoctorMaxLength = 50
let doctorRemarksMaxLength = 500
let chemistRemarksMaxLength = 500
let stockiestRemarksMaxLength = 255
let expenseRemarksMaxLength = 255
let leaveReasonMaxLength = 500
let compProdMaxLength = 50
let attendanceRemarksLength = 500
let generalRemarksLength = 255
let followUpRemarksLength = 250
let meetingPlaceLength = 30
let tpRemarksLength = 500
let tpLeaveReasonLength = 250
let pobRemarksLength = 500
let attendanceActivityRemarksLength = 500

//MARK:- Maximum value
let sfcMaxVal : Float = 9999
let doctorPOBMaxVal : Float = 99999999999
let chemistPOBMaxVal : Float = 99999999999
let rcpaOwnProdMaxVal : Float = 999
let rcpaCompProdMaxVal : Float = 999 
let stockiestPOBMaxVal : Float = 99999999999
let stockiestCollMaxVal : Float = 99999999999
let expenseMaxVal : Float = 99999

//MARK:- Custom Image library - Empty state messages
let albumEmptyMsg = "No Albums found"
let photoEmptyMsg = "No Photos found"
let photoDisabledMsg = "\(appName) does not have access to your photos. To enable access, tap Settings and turn on Photos."
let attachmentEmptyMsg = "No Attachments found"

//MARK:- Operation Queue - Concurrent task count
let maxConcurrentOperationCount = 1
let maxAssetsConcuurentOperationCount = 1
let uploadAnalyticsMaxConcOperationCount = 1
let uploadFeedbackMaxConcOperationCount = 1

//MARK:- Document Type Identifier
let docTypeId = "com.microsoft.word.doc"
let docxTypeId = "org.openxmlformats.wordprocessingml.document"

//MARK:- Dashboard
let assetsEmptyMsg = "No digital resource found"
let doctorsEmptyMsg = "No Contact's found"

//MARK:- Tour Planner
let meetingPoint = "Meeting Point"
let meetingTime = "Meeting Time"
let workCategory = "Work Category"
let workPlace = "Work Place"
let yetToPlan = "Yet to plan"
let noTourAvailable = "No Partner routing is available for this day. Tap + to add an entry"
let weekendOff = "Weekend Off"
let tpDraftYetToApplied = "Draft - Yet to be applied"
let tpApplied = "Applied"
let tpApproved = "Approved"
let tpUnApplied = "Unapproved"

//MARK:- Attachment - Maximum file size
var maxFileSize : Float = 3.0
var maxFileUploadCount: Int = 5

//MARK:- File Type names
let png = "png"
let jpg = "jpg"
let jpeg = "jpeg"
let bmp = "bmp"
let gif = "gif"
let tif = "tif"
let tiff = "tiff"
let pdf = "pdf"
let doc = "doc"
let docx = "docx"
let xls = "xls"
let xlsx = "xlsx"
let zip = "zip"

//MARK:- Dashboard weblink
let dashboardWebLink = "http://sanmed.hidoctor.me//DashBoardV2Mobile/DashBoardV2MoblieMasterPage/administrator/sanmed.hidoctor.me"

//MARK:- Attachment Toast view
var showToastFlag : Bool = false
let attachmentInternetDropOffMsg : String = "Unable to upload attachments now. Please check your network"
let attachmentFailedMsg : String = "Some of the attachments uploaded failed. Please try again"

//MARK:- Notification names
let attachmentNotification : String = "attachmentNotification"
let chemistAttachmentNotification : String = "chemistAttachmentNotification"
let assetNotification: String = "assetNotification"
let leaveAttachmentNotification : String = "leaveAttachmentNotification"

//MARK:- Common Error messages
let validNumberMsg = "Please enter the valid number"

//MARK :- ImageFileName
enum ImageFileName : String
{
    case companyLogo = "companyLogo"
}

// Keyboard characters
let ACCEPTABLE_CHARACTERS = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_.()"

//MARK:- Customer List
let notAssignedSection = "NOT ASSIGNED"
let ccmNumberCaption = "MDL Number"
let ccmNumberPrefix = ""
let others = "Others"

//MARK:- eDetailing Assets
let assetInternetDropOffMsg : String = "Unable to download digital resource now. Please check your network"
let assetDownloadFailedMsg : String = "Some of the digital resource downloaded failed. Please try again"
var uploadAnalyticsDuringDCRRefresh: Bool = false
var navigateToAttachmentUpload: Bool = false

//MARK:- Asset analytics
let assetAnalyticsInternetDropOffMsg : String = "Unable to upload digital resource analytics now. Please check your network"
let feedbackAnalyticsInternetDropOffMsg: String = "Unable to upload contact feedback analytics now. Please check your network"
let docVisitFeedbackAnalyticsInternetDropOffMsg: String = "Unable to upload contact visit feedback analytics now. Please check your network"

let privilegeKeyName = "Privilege_Name"
let privilegeValueName = "Privilege_Value"

enum PrivilegeNames: String
{
    case DCR_ACCOMPANIST_MANDATORY = "DCR_ACCOMPANIST_MANDATORY"
    case CAMPAIGN_PLANNER = "CAMPAIGN_PLANNER"
    case RIGID_DOCTOR_ENTRY = "RIGID_DOCTOR_ENTRY"
    case RIGID_ATTENDANCE_DOCTOR_ENTRY = "RIGID_ATTENDANCE_DOCTOR_ENTRY"
    case DCR_WORK_TIME_MANDATORY = "DCR_WORK_TIME_MANDATORY"
    case INTERMEDIATE_PLACES = "INTERMEDIATE_PLACES"
    case DAILY_ALLOWANCE_TO_HIDE_FOR_ACTIVITIES = "DAILY_ALLOWANCE_TO_HIDE_FOR_ACTIVITIES"
    case DCR_AUTO_APPROVAL = "DCR_AUTO_APPROVAL"
    case DCR_CHEMIST_MANDATORY_NUMBER = "DCR_CHEMIST_MANDATORY_NUMBER"
    case DCR_DETAILING_MANDATORY_NUMBER = "DCR_DETAILING_MANDATORY_NUMBER"
    case DCR_CHEMIST_DETAILING_MANDATORY_NUMBER  = "DCR_CHEMIST_DETAILING_MANDATORY_NUMBER"
    case DCR_DOCTOR_POB_AMOUNT = "DCR_DOCTOR_POB_AMOUNT"
    case DCR_DOCTOR_VISIT_MODE = "DCR_DOCTOR_VISIT_MODE"
    case DCR_CHEMIST_VISIT_MODE  = "DCR_CHEMIST_VISIT_MODE"
    case DCR_CHEMIST_INPUT_MANDATORY_NUMBER = "DCR_CHEMIST_INPUT_MANDATORY_NUMBER"
    case RIGID_CHEMIST_ENTRY = "RIGID_CHEMIST_ENTRY"
    case ACCOMPANISTS_VALID_IN_CHEMIST_VISITS = "ACCOMPANISTS_VALID_IN_CHEMIST_VISITS"
    case LEAVE_ENTRY_VALIDATION_REQUIRED_LEAVES = "LEAVE_ENTRY_VALIDATION_REQUIRED_LEAVES"
    case RCPA_MANDATORY_DOCTOR_CATEGORY = "RCPA_MANDATORY_DOCTOR_CATEGORY"
    case SEQUENTIAL_DCR_ENTRY = "SEQUENTIAL_DCR_ENTRY"
    case SFC_VALIDATION = "SFC_VALIDATION"
    case SFC_CATEGORY_DONT_CHECK = "SFC_CATEGORY_DONT_CHECK"
    case SHOW_ACCOMPANISTS_DATA = "SHOW_ACCOMPANISTS_DATA"
    case TOUR_PLANNER = "TOUR_PLANNER"
    case DCR_INPUT_MANDATORY_NUMBER = "DCR_INPUT_MANDATORY_NUMBER"
    case APP_GEO_LOCATION_MANDATORY = "APP_GEO_LOCATION_MANDATORY"
    case HDAPP_REQUIRED_MARK_DOCTOR_LOCATION = "HDAPP_REQUIRED_MARK_DOCTOR_LOCATION"
    case HD_APP_MARK_DOCTOR_USING_MAP = "HD_APP_MARK_DOCTOR_USING_MAP"
    case ACCOMPANISTS_VALID_IN_DOC_VISITS = "ACCOMPANISTS_VALID_IN_DOC_VISITS"
    case CIRCLE_ROUTE_APPLICABLE_CATEGORY = "CIRCLE_ROUTE_APPLICABLE_CATEGORY"
    case DCR_ENTRY_OPTIONS = "DCR_ENTRY_OPTIONS"
    case CAN_UNAPPROVE_AN_APPROVED_ENTRY_OF = "CAN_UNAPPROVE_AN_APPROVED_ENTRY_OF"
    case FARE_DAILY_ALLOWANCE = "FARE_DAILY_ALLOWANCE"
    case TP_LOCK_DAY = "TP_LOCK_DAY"
    case HOURLY_REPORT_ENABLED = "HOURLY_REPORT_ENABLED"
    case BULK_DCR_APPROVAL = "BULK_DCR_APPROVAL"
    case SINGLE_ACTIVITY_PER_DAY = "SINGLE_ACTIVITY_PER_DAY"
    case LEAVE_ENTRY_MODE = "LEAVE_ENTRY_MODE"
    case APPDOCTOR_CAPTION = "DOCTOR_CAPTION_DISPLAY_NAME"
    case APPCHEMIST_CAPTION = "CHEMIST_CAPTION_DISPLAY_NAME"
    case APPSTOCKIEST_CAPTION = "STOCKIEST_CAPTION_DISPLAY_NAME"
    case PS_DASHBOARD_IN_APP = "PS_DASHBOARD_IN_APP"
    case IS_MC_STORY_ENABLED = "IS_MC_STORY_ENABLED"
    case TP_ACC_MAND_DOC_MAND_VALUES = "TP_ACC_MAND_DOC_MAND_VALUES"
    case TP_ENTRY_OPTIONS = "TP_ENTRY_OPTIONS"
    case TP_MEETING_PLACE_TIME_MANDATORY = "TP_MEETING_PLACE_TIME_MANDATORY"
    case GEO_FENCING_DEVIATION_LIMIT_IN_KM = "GEO_FENCING_DEVIATION_LIMIT_IN_KM"
    case AUTO_SYNC_ENABLED_FOR = "AUTO_SYNC_ENABLED_FOR"
    case NUMBER_OF_OFFLINE_DCR_ALLOWED = "NUMBER_OF_OFFLINE_DCR_ALLOWED"
    case CHEMIST_VISITS_CAPTURE_CONTROLS = "CHEMIST_VISITS_CAPTURE_CONTROLS"
    case DOCTOR_VISITS_CAPTURE_CONTROLS = "DOCTOR_VISITS_CAPTURE_CONTROLS"
    case DOCTOR_MANDATORY_FIELD_MODIFICATION = "DOCTOR_MANDATORY_FIELD_MODIFICATION"
    case CAN_CHANGE_CUSTOMER_NAME = "CAN_CHANGE_CUSTOMER_NAME"
    case DOCTOR_CATEGORY = "DOCTOR_CATEGORY"
    case DCR_ENTRY_TP_APPROVAL_NEEDED = "DCR_ENTRY_TP_APPROVAL_NEEDED"
    case APPROVED_FIELD_TP_CAN_BE_DEVIATED = "APPROVED_FIELD_TP_CAN_BE_DEVIATED"
    case PASSWORD_POLICY = "PASSWORD_POLICY"
    case PASSWORD_LOCK_RELEASE_DURATION = "PASSWORD_LOCK_RELEASE_DURATION"
    case PASSWORD_EXPIRY_DAYS = "PASSWORD_EXPIRY_DAYS"
    case PASSWORD_EXPIRY_NOTIFICATION_DAYS = "PASSWORD_EXPIRY_NOTIFICATION_DAYS"
    case APP_PASSWORD_EXPIRED_ALERT_MAX_SKIP_COUNT = "APP_PASSWORD_EXPIRED_ALERT_MAX_SKIP_COUNT"
    case GEO_FENCING_VALIDATION_MODE = "GEO_FENCING_VALIDATION_MODE"
    case CAN_EDIT_CUSTOMER_LOCATION = "CAN_EDIT_CUSTOMER_LOCATION"
    case INWARD_ACKNOWLEDGEMENT_NEEDED = "INWARD_ACKNOWLEDGEMENT_NEEDED"
    case DCR_INHERITANCE = "DCR_INHERITANCE"
    case IS_DCR_INHERITANCE_EDITABLE = "IS_DCR_INHERITANCE_EDITABLE"
    case ADD_DOCTOR_FROM_DCR = "ADD_DOCTOR_FROM_DCR"
    case EDETAILING_MC_STORY_AND_ASSET_SWAP = "EDETAILING_MC_STORY_AND_ASSET_SWAP"
    case DELETE_EDETAILED_DOCTOR_IN_DCR_DOCTOR_VISIT = "IS_E_DETAILING_CUSTOMER_DELETE"
    case COLLECT_RETAIL_COMPETITOR_INFO = "COLLECT_RETAIL_COMPETITOR_INFO"
    case SHOW_SAMPLE_IN_DCR_ATTENDANCE = "SHOW_SAMPLE_IN_DCR_ATTENDANCE"
    case CP_VISIT_FREQENCY_IN_TP = "CP_VISIT_FREQENCY_IN_TP"
    case SFC_MINCOUNTVALID_IN_TP = "SFC_MINCOUNTVALID_IN_TP"
    case ALERT_LANDING_PAGE_REDIRECT = "ALERT_LANDING_PAGE_REDIRECT"
    case FUTURE_LEAVE_ALLOW_IN_DCR = "FUTURE_LEAVE_ALLOW_IN_DCR"
    case INWARD_ACKNOWLEDGEMENT_ENFORCEMENT = "INWARD_ACKNOWLEDGEMENT_ENFORCEMENT"
    case CAN_CHECK_MASTER_DATA_DOWNLOAD_IN_DAYS = "CAN_CHECK_MASTER_DATA_DOWNLOAD_IN_DAYS"
    case SHOW_DETAILED_PRODUCTS_WITH_TAGS = "SHOW_DETAILED_PRODUCTS_WITH_TAGS"
    case CAN_PLAY_ASSETS_IN_SEQUENCE = "CAN_PLAY_ASSETS_IN_SEQUENCE"
    case DCR_STOCKIEST_VISIT_TIME = "DCR_STOCKIEST_VISIT_TIME"
    case LEAVE_POLICY = "LEAVE_POLICY"
    case IS_DCR_PUNCH_IN_OUT_ENABLED = "IS_DCR_PUNCH_IN_OUT_ENABLED"
    case SHOW_ORGANISATION_IN_CUSTOMER = "SHOW_ORGANISATION_IN_CUSTOMER"
    // New Privilege
    case DCR_FIELD_CAPTURE_CONTROLS = "DCR_FIELD_CAPTURE_CONTROLS"
    case DCR_ATTENDANCE_CAPTURE_CONTROLS = "DCR_ATTENDANCE_CAPTURE_CONTROLS"
     case DOCTOR_VISITS_CAPTURE_CONTROLS_IN_ATTENDANCE = "DOCTOR_VISITS_CAPTURE_CONTROLS_IN_ATTENDANCE"
    case TP_FIELD_CAPTURE_CONTROLS = "TP_FIELD_CAPTURE_CONTROLS"
    case TP_ATTENDANCE_CAPTURE_CONTROLS = "TP_ATTENDANCE_CAPTURE_CONTROLS"
    case ALLOW_GROUP_EDETAILING = "ALLOW_GROUP_EDETAILING"
}

enum PrivilegeValues: String
{
    case ZERO = "0"
    case ONE = "1"
    case TWO = "2"
    case THREE = "3"
    case FOUR = "4"
    case YES = "YES"
    case NO = "NO"
    case OPTIONAL = "OPTIONAL"
    case MANDATORY = "MANDATORY"
    case AM_PM = "AM_PM"
    case VISIT_TIME = "VISIT_TIME"
    case VISIT_TIME_MANDATORY = "VISIT_TIME_MANDATORY"
    case MONTH_CHECK = "MONTH_CHECK"
    case DRAFTED_DCR = "DRAFTED_DCR"
    case CP = "CP"
    case TP = "TP"
    case DCR = "DCR"
    case DOCTOR = "DOCTOR"
    case CHEMIST = "CHEMIST"
    case SFC = "SFC"
    case HQ = "HQ"
    case EMPTY = ""
    case FIELD_RCPA = "FIELD_RCPA"
    case ATTENDANCE = "ATTENDANCE"
    case LEAVE = "LEAVE"
    case FIELD_RCPA_ATTENDANCE_LEAVE = "FIELD_RCPA,ATTENDANCE,LEAVE"
    case SINGLE = "SINGLE"
    case MULTIPLE = "MULTIPLE"
    case RESTRICTED = "RESTRICTED"
    case HALF_A_DAY = "HALF_A_DAY"
    case FULL_DAY = "FULL_DAY"
    case APPDOCTOR_DEFAULT = "Doctor"
    case APPCHEMIST_DEFAULT = "Chemist"
    case APPSTOCKIEST_DEFAULT = "Stockist"
    case ACC_MAND_NO_DOC_MAND_NUM_0 = "ACC_MAND_NO_DOC_MAND_NUM_0"
    case TEN = "10"
    case CHEMIST_VISITS_CAPTURE_VALUE = "ACCOMPANIST,SAMPLES,DETAILING,RCPA,POB,FOLLOW-UP,ATTACHMENTS"
    case DOCTOR_VISITS_CAPTURE_VALUE = "ACCOMPANIST,ACTIVITY,DETAILING,SAMPLES,POB,RCPA,ATTACHMENTS,FOLLOW-UP"
    case ENABLED = "ENABLED"
    case DISABLED = "DISABLED"
    case RIGID = "RIGID"
    case FLEXI = "FLEXI"
    
    // New Privilege values
    case DCR_FIELD_CAPTURE_VALUE =  "DOCTOR_ACCOMPANIST,DOCTOR_ACTIVITY,DETAILING,DOCTOR_SAMPLES,DOCTOR_POB,RCPA,DOCTOR_ATTACHMENTS,DOCTOR_FOLLOW_UP,TRAVEL_DETAILS,EXPENSE_DETAILS,FIELD_STOCKIST_VISITS"
    case DCR_ATTENDANCE_CAPTURE_VALUE = "TRAVEL_DETAILS,DOCTOR_SAMPLES,DOCTOR_ACTIVITY,EXPENSE_DETAILS"
    case DOCTOR_VISITS_CAPTURE_CONTROLS_IN_ATTENDANCE_VALUE = "DOCTOR_SAMPLES,DOCTOR_ACTIVITY,ATTENDANCE_EXPENSE_DETAILS"
    case TP_FIELD_CAPTURE_VALUE = "TRAVEL_DETAILS"
    
}

enum ConfigNames: String
{
    case DATE_DISPLAY_FORMAT = "DATE_DISPLAY_FORMAT"
    case DCR_DOCTOR_SUFIX_COLUMNS = "DCR_DOCTOR_SUFIX_COLUMNS"
    case DCR_DOCTOR_VISIT_TIME_ENTRY_MODE = "DCR_DOCTOR_VISIT_TIME_ENTRY_MODE"
    case DCR_ENTRY_TIME_GAP = "DCR_ENTRY_TIME_GAP"
    case DCR_NO_PREFIL_EXPENSE_VALUE = "DCR_NO_PREFIL_EXPENSE_VALUE"
    case DCR_UNAPPROVED_INCLUDE_IN_SEQ = "DCR_UNAPPROVED_INCLUDE_IN_SEQ"
    case SPECIAL_CHARACTERS_TO_BE_RESTRICTED = "SPECIAL_CHARACTERS_TO_BE_RESTRICTED"
    case MAX_ACCOMPANIST_FOR_A_DAY = "MAX_ACCOMPANIST_FOR_A_DAY"
    case IsPayRollIntegrated = "IsPayRollIntegrated"
    case ALLOW_OTHER_HIERARCHY_IN_ACCOMPANIST_IN_APP = "ALLOW_OTHER_HIERARCHY_IN_ACCOMPANIST_IN_APP"
    case DCR_DOCTOR_ATTACHMENT_PER_FILE_SIZE = "DCR_DOCTOR_ATTACHMENT_PER_FILE_SIZE"
    case DCR_DOCTOR_ATTACHMENTS_FILES_COUNT = "DCR_DOCTOR_ATTACHMENTS_FILES_COUNT"
    case IS_EDetailing_Enabled = "IS_EDetailing_Enabled"
    case IS_SINGLE_DEVICE_LOGIN_ENABLED = "IS_SINGLE_DEVICE_LOGIN_ENABLED"
    case CHEMIST_DAY = "CHEMIST_DAY"
    case DOCTOR_MASTER_MANDATORY_COLUMNS = "DOCTOR_MASTER_MANDATORY_COLUMNS"
    case MASTER_DATA_DOWNLOAD_ALERT_MAX_SKIP = "MASTER_DATA_DOWNLOAD_ALERT_MAX_SKIP"
    
    case MONEY_TREE_KEY = "MONEY_TREE_KEY"
    
}

enum ConfigValues: String
{
    case ZERO = "0"
    case ONE = "1"
    case TWO = "2"
    case THREE = "3"
    case FOUR = "4"
    case YES = "YES"
    case NO = "NO"
    case dd_mm_yyyy = "dd/MM/yyyy"
    case mm_dd_yyyy = "MM/dd/yyyy"
    case SUR_NAME = "SUR_NAME"
    case LOCAL_AREA = "LOCAL_AREA"
    case SERVER_TIME = "SERVER_TIME"
    case MANUAL = "MANUAL"
    case FIVE = "5"
    case TEN = "10"
    case FIFTEEN = "15"
    case TWENTY = "20"
    case THIRTY = "30"
    case EMPTY = ""
    case SPL_CHARS = ",/\"'@();"
    case REGISTRATION_NO = "REGISTRATION_NO"
    case HOSPITAL_NAME = "HOSPITAL_NAME"
    case MOBILE = "MOBILE"
    
//    case MONEY = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0eXBlIjoyMCwib3duZXIiOiJhZG1pbiIsImlkIjoiNWJjMGY0ZTVkYjcxZjE3NDgzZTc0MGI3IiwidXNlcm5hbWUiOiJ3YWxsYWNlIiwidXNlckRhdGEiOnsibmFtZSI6IldhbGxhY2UgUGhhcm1hY2V1dGljYWxzIiwiZW1haWwiOiJ3YWxsYWNlQGtlbm5lY3QuaW4ifSwidGVuYW50IjoiNWJjMGY0ZTVkYjcxZjE3NDgzZTc0MGI3IiwiaWF0IjoxNTQ3NzkzOTYyLCJleHAiOjE1NzM3MTM5NjJ9.Utpmyk3nN74Wo51c_on94vjCtbP1yLa0Qiijg3f3ndM7CNcDYVGCJDT_1uSxh2b9ynkk1CGHHr-nbaFLFKOIUEK5ByxBUA917fQPcidrb6T_1RWpk_GHZ_PMMKYZNhS20MuFnIPjg9GKON1-Mo-T5GbI2Me4F90fBRXgL-KGgM2tEGsZGlqpbJnTHq5VI1OEeNc9TVZoCp0BfL-j2TsPbKG4K12yMyJLAmlEl-bTZOZmBRiMes6CtJtZLDzkTzy4ma7FbJJnMaFr7-u1yS3h6Y5ZpvdEh0QA-tWwj-1oRUMIThXz9LRPVY56N0WlNoVYC2RMrsG12UxSdhAygR_ZSQ"
}

enum AppStatusEnum: String
{
    case Login = "Login"
    case PMD = "PMD"
    case PMD_ACCOMPANIST = "PMD_ACCOMPANIST"
    case HOME = "HOME"
    case PMD_PENDING = "PMD_PENDING"
}

enum DCRStatus: Int
{
    case newDCR = -1
    case unApproved = 0
    case applied = 1
    case approved = 2
    case drafted = 3
    case notEntered = 90
}
enum CellColor
{
    case textSelectedColor
    case prevMonthTextColor
    case todayTextColor
    case todayBgColor
    case normalTextColor
    case appliedBgColor
    case approvedBgColor
    case draftedBgColor
    case unApprovedBgColor
    case lockedBgColor
    case holidayBgColor
    
    var color: UIColor
    {
        switch self
        {
        case .textSelectedColor: return UIColor.black
        case .prevMonthTextColor: return UIColor.lightGray
        case .todayTextColor: return UIColor.black
        case .todayBgColor: return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 102.0/255.0, alpha: 1.0)
        case .normalTextColor: return UIColor.white
        case .appliedBgColor: return UIColor(red: 96.0/255.0, green: 119.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        case .approvedBgColor: return UIColor(red: 0.0/255.0, green: 105.0/255.0, blue: 92.0/255.0, alpha: 1.0)
        case .draftedBgColor: return UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 1.0)
        case .unApprovedBgColor: return UIColor(red: 220.0/255.0, green: 68.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        case .lockedBgColor: return UIColor.orange
        case .holidayBgColor: return UIColor(red: 186.0/255.0, green: 85.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        }
    }
}

enum TPCellColor
{
    case textSelectedBgColor
    case weekEndBgColor
    case normalTextColor
    case selectedTextColor
    case todayBgColor
    case todayTextColor
    case unApprovedBgColor
    case holidayBgColor
    case draftedBgColor
    case appliedBgColor
    case approvedBgColor
    
    var color: UIColor
    {
        switch self
        {
        case .textSelectedBgColor: return UIColor(red: 30.0/255.0, green: 39.0/255.0, blue: 76.0/255.0, alpha: 1.0)
        case .weekEndBgColor: return UIColor(red: 84.0/255.0, green: 110.0/255.0, blue: 122.0/255.0, alpha: 1.0)
        case .normalTextColor: return UIColor.black
        case .selectedTextColor: return UIColor.white
        case .todayTextColor: return UIColor.black
        case .todayBgColor: return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 102.0/255.0, alpha: 1.0)
        case .unApprovedBgColor: return UIColor(red: 220.0/255.0, green: 68.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        case .holidayBgColor: return UIColor(red: 186.0/255.0, green: 85.0/255.0, blue: 211.0/255.0, alpha: 1.0)
        case .draftedBgColor: return UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 1.0)
        case .appliedBgColor: return UIColor(red: 96.0/255.0, green: 119.0/255.0, blue: 247.0/255.0, alpha: 1.0)
        case .approvedBgColor: return UIColor(red: 0.0/255.0, green: 105.0/255.0, blue: 92.0/255.0, alpha: 1.0)
        }
    }
}

enum MessageReadColor{
    case messageReadBgColor
    case messageUnReadBgColor
    var color: UIColor
    {
        switch self
        {
        case .messageReadBgColor: return UIColor(red: 223.0/255.0, green: 223.0/255.0, blue: 223.0/255.0, alpha: 1.0)
        case .messageUnReadBgColor: return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }
    }
}
enum MessagePriorityColor{
    case messagePriorityHighBgColor
    case messagePriorityMediumBgColor
    case messagePriorityLowBgColor
    var color: UIColor
    {
        switch self
        {
        case .messagePriorityHighBgColor: return UIColor(red: 220.0/255.0, green: 51.0/255.0, blue: 74.0/255.0, alpha: 1.0)
        case .messagePriorityMediumBgColor: return UIColor(red: 27.0/255.0, green: 94.0/255.0, blue: 32.0/255.0, alpha: 1.0)
        case .messagePriorityLowBgColor: return UIColor(red: 249.0/255.0, green: 139.0/255.0, blue: 33.0/255.0, alpha: 1.0)
            
        }
    }
}

enum DCRFlag : Int
{
    case fieldRcpa = 1
    case attendance
    case leave
}

enum TPFlag : Int
{
    case fieldRcpa = 1
    case attendance 
    case leave
}

enum DCRActivityName : String
{
    case fieldRcpa = "Field"
    case attendance = "Office"
    case leave = "Not Working"
    case prospect = "Prospecting"
}

enum TPActivityName : String
{
    case fieldRcpa = "Field_RCPA"
    case attendance = "Office"
    case leave = "Not Working"
}

enum TPMoreName : String
{
    case refresh = "Routing Refresh"
    case upload = "Routing Upload"
}

enum DCRActivity : Int
{
    case fieldRcpa = 1
    case attendance
}
//MARK:- Tp Flag
enum TPStatus : Int
{
    case newTP = -1
    case unapproved = 0
    case approved = 1
    case applied = 2
    case drafted = 3
}

let NO_INTERNET_ERROR_CODE: Int = -3843878
let LOCAL_ERROR_CODE: Int = -999
let SERVER_ERROR_CODE: Int = 0
let SERVER_SUCCESS_CODE: Int = 1
let EXPENSE_GROUP_ELIGIBILITY = "E"
let EXPENSE_FLEXI = "F"
let EXPENSE_RIGID = "R"
let DCR_FIELD = 1
let TP_FIELD = 1
let VACANT = "VACANT"
let NOT_ASSIGNED = "NOT ASSIGNED"
let NOT_ASSIGNED_VALUE = "NOT_ASSIGNED"
let NOT_APPLICABLE = "N/A"
let NA = "NA"
let EMPTY = ""
let INDEPENDENTENT_CALL = "Independent Call"
let CHEMIST = "CHEMIST"
let DOCTOR = "DOCTOR"
let MAX_ACCOMPANIST_DATA_DOWNLOAD_COUNT: Int = 12
let TOUR_PLAN = PEV_TOUR_PLAN
let AlertLocationCaptureCount = 0
let GENERAL_REMARKS_API_SPLIT_CHAR = "^"
let GENERAL_REMARKS_LOCAL_SPLIT_CHAR = "~"
let AM = "AM"
let PM = "PM"
let DAILY = "DAILY"
let SECONDS = "sec"
let MINUTES = "min"
let HOURS = "hrs"
let CANCEL = "Cancel"
let specialityDefaults = "Select Position Name"
let categoryDefaults = "Select Category Name"
let SERVER_PASSWORD_CHANGE_CODE: Int = 2

enum DCRRefreshMode: String
{
    case TAKE_SERVER_DATA = "TAKE_SERVER_DATA"
    case MERGE_LOCAL_AND_SERVER_DATA = "MERGE_LOCAL_AND_SERVER_DATA"
    case MERGE_DRAFT_AND_UNAPPROVED_DATA = "MERGE_DRAFT_AND_UNAPPROVED_DATA"
    case EMPTY = ""
}

var currentLat: String = ""
var currentLong: String = ""

enum MenuIDs: Int
{
    case Entry = 1
    case Approval = 2
    case Reports = 3
    case Others = 4
    case DCR_Entry = 5
    case TP_Entry = 6
    case Expense_Claim_Entry = 7
    case DCR_Approval = 8
    case TP_Approval = 9
    case DCR_Leave_Approval = 10
    case DCR_Lock_Release = 11
    case Region_DCR_TP = 12//
    case Tour_Planner_Report = 13//
    case User_Per_day_report = 14//
    case Customer_List = 15 //
    case Mark_Doctor_List = 16//
    case Change_Password = 17//
    case Hourly_Report = 18
    case GEO_Location_Report = 19
    case Customer_Master_Screen = 20
    case DoctorApproval = 21
    case LiveTrackingChartManager = 22
    case Customer_Complaints = 23
    case ExpenseApproval = 24
    case InChamberEffectiviness = 25
    case Task = 26
    case Doctor_Product_Mapping = 27
    case DCR_ActivityLock_Release = 28
    case TP_Freeze_Lock = 29
    case Kennect = 31
    case MyDocument = 33
    case traveltrackingreport = 34
   // case QuickNotes = 35
    case QuickNotes = 36
}


enum MenuSectionName: String
{
    case Activity = "Activity"
    case Plan = "Plan"
    case Customer = "Customer"
    case Others = "Others"
}
let productDefaultPriorityOrder = 999999

struct Constants
{
    struct TableViewCellIdentifier
    {
        static let ApprovalSectionHeaderCell : String = "approvalSectionHeaderCell"
        static let ApprovalLoadingCell : String = "approvalLoadingCell"
        static let ApprovalInnerTableCell : String = "approvalInnerTableCell"
        static let ApprovalEmptyStateCell : String = "approvalEmptyStateCell"
        static let ApprovalAccompanistsCell : String = "approvalAccompanistsCell"
        static let ApprovalSFCCell : String = "approvalSFCCell"
        static let ApprovalDoctorVisitCell : String = "approvalDoctorVisitCell"
        static let ApprovalEmptyStateRetryCell : String = "approvalEmptyStateRetryCell"
        static let AttendanceInnerTableCell : String = "attendanceInnerTableCell"
        static let AttendanceLoadingCell : String = "attendanceLoadingCell"
        static let AttendanceEmptyStateCell : String = "attendanceEmptyStateCell"
        static let AttendanceEmptyStateRetryCell : String = "attendanceEmptyStateRetryCell"
        static let AttendanceSectionHeaderCell : String = "attendanceSectionHeaderCell"
        static let AttendanceCommonCell : String = "attendanceCommonCell"
        static let AttendanceSFCCell : String = "attendanceSFCCell"
        static let ApprovalDoctorDetailMainCell : String = "approvalDoctorDetailMainCell"
        static let ApprovalDoctorDetailSubCell : String = "approvalDoctorDetailSubCell"
        static let DoctorDetailsEmptyStateCell : String = "doctorDetailsEmptyStateCell"
        static let DoctorDetailsSectionCell : String = "DoctorDetailsSectionCell"
        static let ApprovalRCPACell : String = "approvalRCPACell"
        static let DoctorVisitEmptyStateRetryCell : String = "DoctorVisitEmptyStateRetryCell"
        static let DoctorVisitLoadingCell : String = "DoctorVisitLoadingCell"
        static let ReportsCell : String = "ReportsCell"
        static let TpReportDetailInnerCell : String = "TpReportDetailInnerCell"
        static let TpReportCommonCell : String = "tpReportCommonCell"
        static let TpReportSFCCell : String = "tpReportSFCCell"
        static let TpReportDoctorVisitCell : String = "tpReportDoctorVisitCell"
        static let TpReportEmptyStateCell : String = "tpReportEmptyStateCell"
        static let TpReportSectionHeaderCell : String = "tpReportSectionHeaderCell"
        static let AccompanistPopUpCell : String = "accompanistPopUpCell"
        static let DoctorListCell : String = "DoctorListCell"
        static let TPDoctorListCell : String = "TPDoctorListCell"
        static let DoctorListDetailsSectionCell : String = "DoctorListDetailsSectionCell"
        static let DoctorListDetailsCell : String = "DoctorListDetailsCell"
        static let DashBoardUserListCell : String = "DashBoardUserListCell"
        static let DashboardUserSectionCell : String = "DashboardUserSectionCell"
        static let DCRRejectCell : String = "DCRRejectCell"
        static let DeleteDCRListCell : String = "DeleteDCRListCell"
        static let HourlyReportDoctorListCell : String = "HourlyReportDoctorListCell"
        static let HourlyReportDoctorVisitCell : String = "HourlyReportDoctorVisitCell"
        static let ApprovalPendingMonthListCell : String = "ApprovalPendingMonthListCell"
        static let AttendanceStepperRemarksCell : String = "AttendanceStepperRemarksCell"
        static let DCRDoctorVisitFollowUpCell : String = "DCRDoctorVisitFollowUpCell"
        static let CustomImageLibAlbumCell : String = "CustomImageLibAlbumCell"
        static let POBStepperSubCell : String = "POBStepperSubCell"
        static let POBStepperMainCell : String = "POBStepperMainCell"
        static let POBStepperRemarksCell : String = "POBStepperRemarksCell"
        static let AttachmentCell : String = "AttachmentCell"
        static let POBSalesProductModifyCell : String = "POBSalesProductModifyCell"
        static let POBSalesProductCell : String = "POBSalesProductCell"
        static let DoctorVisitAccompanistCell : String = "DoctorVisitAccompanistCell"
        static let DCRAttachmentUploadCell: String = "DCRAttachmentUploadCell"
        static let DashboardSalesProductCell : String = "DashboardSalesProductCell"
        static let DashboardSalesSubProductCell : String = "DashboardSalesProductSubCell"
        static let AssetsListCell : String = "AssetsListCell"
        static let AssetsSectionCell : String = "AssetsSectionCell"
        static let SortCell : String = "sortCell"
        static let AssetsMenuListCell : String = "AssetsMenuListCell"
        static let DoctorVisitAssetCell : String = "doctorVisitAssetCell"
        static let AssetsPlayerChildCell : String = "AssetsPlayerChildCell"
        static let DoctorAssetCell : String = "DoctorAssetCell"
        static let DashboardHeaderAssetCell : String = "DashboardHeaderAssetCell"
        static let DashboardHeaderAssetSubCell  : String = "DashboardHeaderAssetSubCell"
        static let DashboardCustomerWiseAssetCell : String = "DashboardCustomerWiseAssetCell"
        static let DasboardAssetCustomerWiseSectionCell : String = "DasboardAssetCustomerWiseSectionCell"
        static let AssetMenuSectionCell : String = "AssetMenuSectionCell"
        static let AssetsStoryListCell : String = "AssetsStoryListCell"
        static let DoctorTagCell : String = "DoctorTagCell"
        static let TopDoctorAssetCell: String = "TopDoctorAssetCell"
        static let TPDetailCell: String = "TPDetailCell"
        static let TPActivityCell: String = "TPActivityCell"
        static let TPAccompDetailCell: String = "TPAccompDetailCell"
        static let TPPlaceDetailCell: String = "TPPlaceDetailCell"
        static let TPDoctorDetailCell: String = "TPDoctorDetailCell"
        static let AssetStorySectionCell : String = "AssetsStorySectionCell"
        static let AssetStoryMainCell : String = "AssetStoryMainCell"
        static let NoticeBoardCell : String = "NoticeBoardCell"
        static let TPUploadSelectCell : String = "TPUploadSelectCell"
        static let TPUploadDetailCell : String = "TPUploadDetailCell"
        static let TPCopyTourPlanMainCell : String = "TPCopyTourPlanMainCell"
        static let TPCopyTourPlanAccListMainCell : String = "copyTPAccCell"
        static let MessageCell : String = "MessageCell"
        static let LandingAlertDetailCell: String = "landingAlertDetailCell"
        static let ChemistListSectionCell : String = "ChemistListSectionCell"
        static let ChemsitListSectionContentCell : String = "ChemsitListSectionContentCell"
        static let StepperMainCell : String = "StepperMainCell"
        static let CommonCell : String = "doctorVisitSample"
        static let CommonCell1 : String = "doctorVisitCommon"
        static let DoctorListEditDetailsCell : String = "DoctorListEditDetailsCell"
        static let AccompanistCommonCell : String = "DoctorVisitAccompanistCell"
        static let VisitCell : String =  "doctorVisitDetailCell"
        static let POBSectionHeaderCell : String = "sectionTableViewCell"
        static let POBDetailCell : String = "detailTableViewCell"
        static let POBAmountDetailsCell :String = "AmountDetailsTableViewCell"
        static let RCPAListCell :String = "rcpaListCell"
        static let GroupeDetailingCell : String = "groupEdetailCell"
        }
    
    struct CollectionViewIdentifier
    {
        static let TpCalendarCell : String = "tpCalendarCell"
        static let CustomImageLibPhotoCell : String = "CustomImageLibPhotoCell"
        static let AssetsStoryCollectionCell : String = "AssetsStoryCollectionCell"
        static let MessageAttachmentCollectionCell : String = "MessageAttachmentCollectionCell"
    }
    
    struct NibNames {
        static let AssetsPlayerCollectionViewCell = "AssetsPlayerCollectionViewCell"
        static let AssetsChildTableViewCell = "AssetsChildTableViewCell"
        static let StepperTableViewCell = "ChemistDayStepperCell"
        static let CommonTableViewCell = "CommonCell"
        static let CommonSelectCell = "CommonSelectCell"
        static let CommonDoubleLineCell = "CommonDoubleLineCell"
        static let CommonSingleLineTableViewCell = "CommonSingleLineCell"
        static let AccompanistCommonTableViewCell = "AccompanistCommonCell"
        static let VisitCell = "VisitCell"
        static let DoctorDetailEditCell = "DoctorDetailEditCell"
    }
    
    struct StoaryBoardNames
    {
        static let commonApprovalDetailsSb : String = "CommonApprovalViewController"
        static let ReportsSb : String = "ReportViewController"
        static let TpReportSb : String = "TourPlannerViewController"
        static let DashboardSb = "Dashboard"
        static let RejectViewControllerSb = "RejectViewController"
        static let FileViewSb = "FileViewController"
        static let HourlyReportSb = "HourlyReportViewController"
        static let FollowUpSb = "FollowsUpsViewController"
        static let CustomImgLib = "CustomImageLibrary"
        static let POBSb = "POBViewController"
        static let AttachmentSb = "AttachmentController"
        static let SplitViewSb = "SplitViewController"
        static let AssetsListSb = "AssetListViewController"
        static let DashboardAssetSb = "DashboardAsset"
        static let TPCalendarSb = "TPCalendar"
        static let NoticeBoardSb = "NoticeBoardViewController"
        static let TPUploadSb = "TPUploadViewController"
        static let TPCopyTourPlanSb = "CopyTourPlannerViewController"
        static let MessageSb = "MessageViewController"
    }
    
    struct ViewControllerNames
    {
        static let commonApprovalDetailsVcID :String = "commonApprovalDetailsVcID"
        static let commonAttendanceDetailsVcID : String = "commonAttendanceDetailsVcID"
        static let commonLeaveApprovalVcID : String = "commonLeaveApprovalVcID"
        static let ApprovalDoctorDetailVcID : String = "ApprovalDoctorDetailVcID"
        static let ApprovalRCPAVcID : String = "ApprovalRCPAVcID"
        static let ReportsVcID : String = "ReportsVcID"
        static let ReportsUserListVcID : String = "ReportsUserListVcID"
        static let UserPerDayReportsVcID : String = "UserPerDayReportsVcID"
        static let TpReportDetailsVcID : String = "TpReportDetailsVcID"
        static let DashBoardPendingApprovalVcID : String = "DashBoardPendingApprovalVcID"
        static let DashBoardPendingMonthApprovalViewControllerID: String = "DashBoardPendingMonthApprovalViewControllerID"
        static let DashboardUserListViewControllerID :String = "DashboardUserListViewControllerID"
        static let DashboardDoctorMissedRegionVcID : String = "DashboardDoctorMissedRegionVcID"
        static let DashboardDoctorMissedDetailsVcID : String = "DashboardDoctorMissedDetailsVcID"
        static let AccompanistPopUpVcID : String = "AccompanistPopUpVcID"
        static let DoctorListVcID : String = "DoctorListVcID"
        static let DoctorDetailsVcID : String = "DoctorDetailsVcID"
        static let DoctorDetailsEditVcID : String = "DoctorDetailsEditVcID"
        static let DashBoardPendingUserListVcID : String = "DashBoardPendingUserListVcID"
        static let DCRRejectVcID : String = "DCRRejectVcID"
        static let DeleteDCRVcID : String = "DeleteDCRVcID"
        static let ImageViewVcID : String = "ImageViewVcID"
        static let HourlyReportVcID : String = "HourlyReportVcID"
        static let HourlyReportDoctorListVcID : String = "HourlyReportDoctorListVcID"
        static let HourlyReportDoctorVisitVcID : String = "HourlyReportDoctorVisitVcID"
        static let HourlyReportDoctorDetailVcID: String = "HourlyReportDetailViewSb"
        static let HourlyReportMapViewVc: String = "HourlyReportMapViewVc"
        static let HourlyReportGoogleMapViewVc: String = "HourlyReportGoogleMapViewVc"
        static let HourlyTravelTrackingReportGoogleMapViewVc: String = "TravelTrackingReportMapViewVc"
        static let HourlyReportDateVcID : String = "HourlyReportDateVcID"
        static let TravelTrackingReportDateVcID : String = "TravelTrackingReportVcID"
        static let GeoReportDateVcID : String = "GeoReportDateVcID"
        static let ChartReportDataVcID : String = "ChartReportDataVcID"
        static let ApprovalMonthListVcID : String = "ApprovalMonthListVCID"
        static let AddFollowUpVcID : String = "AddFollowUpVcID"
        static let ModifyFollowUpListVcID : String = "ModifyFollowUpListVcID"
        static let CustomImgLibAlbumVCID : String = "CustomImgLibAlbumVCID"
        static let CustomImgLibPhotoVCID : String = "CustomImgLibPhotoVCID"
        static let POBStepperVcID : String = "POBStepperVcID"
        static let AttachmentVCID : String = "AttachmentVCID"
        static let POBSalesProductModifyVcID : String = "POBSalesProductModifyVcID"
        static let POBSalesProductVcID : String = "POBSalesProductVcID"
        static let POBRemarksVCID : String = "POBRemarksVCID"
        static let PreparePendingDeviceVcID : String = "PreparePendingDeviceVcID"
        static let RemoveAccompanistPopUpVcID : String = "RemoveAccompanistPopUpVcID"
        static let AttachmentUploadVCID : String = "AttachmentUploadVCID"
        static let FileViewVCID : String = "fileViewVCID"
        static let SplitViewVCID : String = "globalSplitVCID"
        static let CustomerVCID : String = "customerVCID"
        static let CustomerDetailVCID : String = "customerDetailVCID"
        static let AssetsListVcID : String = "AssetsListVcID"
        static let SortVCID : String = "sortVCID"
        static let AssetInfoVCID : String = "assetInfoVCID"
        static let AssetsMenuListVcID : String = "AssetsMenuListVcID"
        static let DashboardAssetDetailsVCID : String = "DashboardAssetDetailsVCID"
        static let DashboardAssetDoctorDetailsVCID : String = "DashboardAssetDoctorDetailsVCID"
        static let DashboardAssetCustomerWiseVcID : String = "DashboardAssetCustomerWiseVcID"
        static let AssetsStoryListVcID : String = "AssetsStoryListVcID"
        static let DoctorTagVCID : String = "DoctorTagVCID"
        static let TopAssetVCID : String = "TopAssetVCID"
        static let TopDoctorsVCID : String = "TopDoctorsVCID"
        static let TopDoctorAssetVCID: String = "TopDoctorAssetVCID"
        static let TPCalendarVCID: String = "TPCalendarVCID"
        static let AssetsMainStoryVcID = "AssetsMainStoryVcID"
        static let NoticeBoardVCID = "NoticeBoardVCID"
        static let NoticeDetailVCID = "noticeDetailVCID"
        static let TPGeneralRemarksVCID = "TPGeneralRemarksVCID"
        static let TPUploadSelectVCID = "TPUploadSelectVCID"
        static let TPUploadDetailsVCID = "TPUploadDetailsVCID"
        static let TPCopyTourPlanVCID = "TPCopyTourPlanVCID"
        static let TPCopyTourPlanAccompanistListVCID = "accompanistListVCID"
        //static let MessageVCID = "MessageTabbarVCID"
        static let MessageVCID = "MessageVCID"
        static let MessageComposeVCID = "MessageComposeVCID"
        static let MessageComposeVC = "MessageComposeViewController"
        static let TPRefreshVCID = "TPRefreshVCID"
        static let MessageDetailID = "MessageDetailVCID"
        static let LandingAlertVCId = "LandingAlertVCID"
        static let LandingAlertDetailVCID = "LandingAlertDetailVCID"
        static let ChemistListSectionVCID = "ChemistListSectionVCID"
        static let EDetailVC = "EDetailVC"
        static let SearchApprovalVCID = "SearchApprovalVCID"
        static let POBDetailsVCID = "POBDetailsVCID"
        static let RcpaListVCID :String = "RcpaListVCID"
        static let WorkTimeViewVCID: String = "WorkTimeViewVCID"
        static let OnBoardMasterDataAlertVCID : String = "onboardMasterDataAlertVcID"
        static let OnBoardSplashScreenAlertVCID : String = "onboardSplashScreenAlertVcID"
        static let ChartDoctorListVCID : String = "ChartDoctorListVCID"
        static let GeoFencingSkipRemarksVCId: String = "GeoFencingSkipRemarksVCId"
        static let ActivityStepperViewControllerID: String = "ActivityStepperViewControllerID"
        static let CustomerAddressVCId: String = "CustomerAddressVCId"
        static let BusinessStatusVcId: String = "BusinessStatusVcId"
        static let ComplaintViewControllerID: String = "ComplaintViewControllerID"
        static let ComplaintFormViewControllerID: String = "ComplaintFormViewControllerID"
        static let IceFeedbackViewControllerID: String = "IceFeedbackViewControllerID"
        static let AllTaskViewControllerID = "AllTaskViewControllerID"
        static let AttendanceAccompanistListVCID = "AttendanceAccompanistListVCID"
        static let AttendanceReportVCID = "attendanceSampleReportVC"
    }
    
    struct DashboardEntityIDs
    {
        static let All_Entities: Int = 100
        static let Doctor_Missed: Int = 1
        static let Doctor_Call_Avg: Int = 2
        static let Chemist_Call_Avg: Int = 3
        static let My_DCR_Pending_For_Approval: Int = 4
        static let Team_DCR_Pending_For_Approval: Int = 5
        static let My_TP_Pending_For_Approval: Int = 6
        static let Team_TP_Pending_For_Approval: Int = 7
    }
    
    struct DoctorVisitTrackerEntityIDs
    {
        static let Doctor_Modified: Int = 0
        static let Accompanist_Modified: Int = 1
        static let Sample_Modified: Int = 2
        static let Detailed_Product_Modified: Int = 3
        static let Chemist_Modified: Int = 4
        static let Chemist_RCPA_Modified: Int = 5
    }
    
    struct HelpURLs
    {
        static let ManagerUrl: String = "https://api1.mywealthcloud.com/data/viewer/web/viewer.php?file=downloads/15288828076341249183113/152888280731133113.enc.pdf&token=NzMyNzlmMjM5NGE2NTM0OGJiMDc2OWY3YjMzMTdhNTgzNWRhZGNkMg==&print=0" //"http://hdioshelp.hidoctor.me/startapp-mgr.html"
        static let RepUrl: String = "https://api1.mywealthcloud.com/data/viewer/web/viewer.php?file=downloads/15288828076341249183113/152888280731133113.enc.pdf&token=NzMyNzlmMjM5NGE2NTM0OGJiMDc2OWY3YjMzMTdhNTgzNWRhZGNkMg==&print=0" //"http://hdioshelp.hidoctor.me/startapp.html"
        static let LoginHelpUrl: String = "http://hdioshelp.hidoctor.me/details/loginhelp.html"
        //srl: String = "http://hdioshelp.hidoctor.me/details/loginhelp.html"
    }
    
    struct CharSet
    {
        static let Alphabet: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ"
        static let Numeric: String = "0123456789"
    }
    
    struct DirectoryFolders
    {
        static let attachmentFolder: String = "Attachment"
        static let assetFolder: String = "Asset"
        static let noticeboardAttachmentFolder:String = "NoticeBoard"
        static let mailAttachmentFolder:String = "Mail"
        static let doctorProfileFolder:String = "DoctorProfile"
    }
    
    struct SubDirectories
    {
        static let PDFCache: String = "PDFCache"
        static let newImage: String = "DOCTORProfile"
    }
    
    struct DocType
    {
        static let image : String = "Image"
        static let video: String = "Video"
        static let audio: String = "Audio"
        static let document: String = "Document"
        static let zip : String = "HTML"
    }
    
    struct DocTypeIds
    {
        static let image: Int = 1
        static let video: Int = 2
        static let audio: Int = 3
        static let document: Int = 4
        static let zip: Int = 5
    }
    struct MessageConstants
    {
        static let Low: String = "Low"
        static let Medium: String = "Medium"
        static let High: String = "High"
        static let N: String = "N"
        static let Y: String = "Y"
        static let newAttachment: String = "NEW_MAIL"
    }
    struct NoticeBoardPageConstants
    {
        static let pageSize: Int = 10
    }
    
    struct MessageType
    {
        static let inbox : Int = 1
        static let sent : Int = 3
        static let draft : Int = 2
        static let trash : Int = 4
    }
    struct MessageList
    {
        static let inbox : String = "Inbox"
        static let sent : String = "Sent"
        static let draft : String = "Draft"
        static let trash : String = "Trash"
    }
    
    struct AttachmentType
    {
        static let image: String = "Image"
        static let excel: String = "Excel"
        static let pdf: String = "PDF"
        static let word: String = "Word"
        static let zip: String = "Zip"
    }
    struct ComposeType
    {
        static let compose: String = "Compose"
        static let forward: String = "Forward"
        static let reply: String = "Reply"
        static let draft: String = "Draft"
    }
    struct OrderStatus
    {
        static let cancelled : Int = 0
        static let inprogress : Int = 1
        static let complete : Int = 2
        static let draft : Int = 3
    }
    struct CustomerEntityType
    {
        static let chemist : String = "C"
        static let doctor : String = "D"
        static let stockist : String = "S"
    }
    
    struct ChemistDayCaptureValue {
        
        static let visit : String = "VISIT"
        static let chemist_accompanist : String = "ACCOMPANIST"
        static let chemist_samples : String = "SAMPLES"
        static let chemist_detailing : String = "DETAILING"
        static let chemist_RCPA : String = "RCPA"
        static let chemist_pob : String = "POB"
        static let chemist_followUp : String = "FOLLOW-UP"
        static let chemist_attachment : String = "ATTACHMENTS"
        static let chemist_activity : String = "ACTIVITY"
        static let chemist_assets : String = "ASSET"
        
        // New values
        
        static let accompanist : String = "DOCTOR_ACCOMPANIST"
        static let samples : String = "DOCTOR_SAMPLES"
        static let detailing : String = "DETAILING"
        static let RCPA : String = "RCPA"
        static let pob : String = "DOCTOR_POB"
        static let followUp : String = "DOCTOR_FOLLOW_UP"
        static let attachment : String = "DOCTOR_ATTACHMENTS"
        static let activity : String = "DOCTOR_ACTIVITY"
        static let assets : String = "ASSET"
        static let expenses : String = "EXPENSE_DETAILS"
        static let stockiest : String = "FIELD_STOCKIST_VISITS"
        static let travel_details : String = "TRAVEL_DETAILS"
        // News values end
        static let attendance_expenses : String = "EXPENSE_DETAILS"
    }
    
    struct Customer_Status
    {
        static let Applied: Int = 2
        static let Approved: Int = 1
        static let Unapproved: Int = 0
    }
    
    struct Validation_Type
    {
        static let Alphabet_Only: Int = 1
        static let Alphabet_And_Space: Int = 2
        static let AlphaNumeric: Int = 3
        static let AlphaNumeric_And_Space: Int = 4
        static let Email: Int = 5
        static let Numeric_Only: Int = 6
        static let Phone_Number: Int = 7
        static let All_Except_Spl_Chars: Int = 8
    }
    
    struct Doctor_List_Page_Ids
    {
        static let Customer_List: Int = 1
        static let Mark_Doctor_Location: Int = 2
        static let Doctor_Master_Edit: Int = 3
    }
    
    struct Geo_Fencing_Page_Names
    {
        static let DCR = "DCR"
        static let EDETAILING = "EDETAILING"
        static let MARK_DOCTOR_LOCATION = "MARK_DOCTOR_LOCATION"
    }
    
    struct Business_Status_Entity_Type_Ids
    {
        static let Doctor: Int = 1
        static let Detailed_Products: Int = 2
    }
    
    struct Business_Status_Page__Ids
    {
        static let DCR_Doctor_Visit: Int = 1
        static let Detailed_Products: Int = 2
    }
    
    struct Doctor_Product_Mapping_Ref_Types
    {
        static let Marketing_Campaign = "MARKETING_CAMPAIGN"
        static let TARGET_MAPPING = "TARGET_MAPPING"
        static let GENERAL = "MAPPING"
    }
    
    struct Call_Objective_Entity_Type_Ids
    {
        static let Doctor: Int = 1
        static let Detailed_Products: Int = 2
    }
    
    struct DCR_Inheritance_Status_Codes
    {
        static let PROCEED: Int = 1
        static let ACCOMPANIST_NOT_ENTERED_ERROR: Int = 2
        static let ACCOMPANIST_NOT_ENTERED_CONFIRMATION: Int = 3
        static let INTERNET_MANDATORY_ERROR: Int = 4
        static let INTERNET_OPTIONAL_ERROR: Int = 5
        static let MAKE_API_CALL: Int = 6
        static let ALL_ACCOMPANIST_ARE_INDEPENDENT_ERROR: Int = 7
        static let ACC_DATA_NOT_DOWNLOADED_ERROR: Int = 8
    }
    
    struct DCR_Inheritance_API_Error_Types
    {
        static let LOCK: String = "LOCK"
        static let NO_DCR: String = "NO_DCR_FOUND"
        static let NO_APPROVED_DCR: String = "NO_APPROVED_DCR_FOUND"
    }
    
    struct DCR_Inheritance_Acc_Data_Downloaded_IDs
    {
        static let Download_Success: Int = 2
        static let Download_Error: Int = 1
        static let Yet_To_Download: Int = 0
        static let Lock_Status: Int = 3
    }
    
    struct Module_Names
    {
        static let DCR: String = "DCR"
        static let PREPARE_MY_DEVICE = "PREPARE_MY_DEVICE"
        static let CODEOFCONDUCT: String = "DCR"
    }
    
    struct Screen_Names
    {
        static let UPLOAD_DCR: String = "UPLOAD_DCR"
        static let PREPARE_MY_DEVICE = "PREPARE_MY_DEVICE"
        static let CODE_OF_CONDUCT = "CODE_OF_CONDUCT"
    }
    
    struct Asset_Tag_Codes
    {
        static let UDTAGS: String = "UDTAGS"
        static let CATEGORY: String = "CUSCATEGORY"
        static let SPECIALTY: String = "CUSSPECIALITY"
    }
}

struct Display_Messages
{
    struct DCR_Inheritance_Messages
    {
        static let ACCOMPANIST_MANDATORY_ERROR_MESSAGE: String = "You have opted for DVR inheritance and you have not entered any Ride Along in this DVR. Please add all the Ride Along that you have worked and then try again"
        static let ACCOMPANIST_OPTIONAL_ERROR_MESSAGE: String = "You have opted for DVR inheritance and you have not entered any Ride Along in this DVR.\n\nStill do you want to add \(appDoctorPlural) without adding any Ride Along?\n\n Tap on YES button to add \(appDoctorPlural) and proceed further"
        static let INTERNET_MANDATORY_ERROR_MESSAGE: String = "You have opted for DVR inheritance. But you are not connected internet.\n\n Tap on GO TO SETTINGS button and enable the internet connection"
        static let INTERNET_OPTIONAL_ERROR_MESSAGE: String = "You have opted for DVR inheritance. But you are not connected internet.\n\n Still do you want to add \(appDoctorPlural) without downloading Ride Along' DVR?\n\nTap on YES button to add \(appDoctorPlural) and proceed further"
        static let API_CALL_LOADING_MESSAGE: String = "Downloading DVR of selected Ride Along. Please wait..."
        static let ALL_ACCOMPANIST_INDEPENDENT_ERROR_MESSAGE: String = "All the Ride Along are maked as independent call. Hence unable to inherit any DVR \(appDoctorPlural) of selected Ride Along(s)"
        static let API_CALL_SUCCESS_MESSAGE: String = "DVR \(appDoctor) visit details inherited successfully"
        static let NEW_ACCOMPANIST_ADD_MESSAGE: String = "Since you have opted for DVR inheritance, all the \(appDoctor) visit of this DVR will be marked as 'Independent Call' with this Ride Along name"
        static let ADD_DOCTOR_RESTRICTION_MESSAGE: String = "You can't add any \(appDoctor) of this accompanist. You can do only DVR inheritance"
        static let ACCOMPANIST_DATA_MANDATORY_ERROR_MESSAGE: String = "The @ACC_USERS data are not downloaded. Please download the Ride Along's data and proceed further"
        static let ACCOMPANIST_VALIDATION_ERROR_MESSAGE: String = "@ACC_USER has entered DVR and marked you as Ride Along in \(appDoctor) visits. Hence you can't mark this Ride Along for independent call"
        static let ACCOMPANIST_VALIDATION_USER_OFFLINE_MESSAGE: String = "You are offline. Please turn on internet, hence system can validate the chosen Ride Along DVR for DVR inheritance"
        static let ACCOMPANIST_VALIDATION_API_ERROR_MESSAGE: String = "Sorry. Unable to validate the Ride Along. Please try again later."
        static let NO_INHERITED_DOCTOR_SUBMIT_DCR_VALIDATION: String = "You have added @ACC_USER as Ride Along. But you have not inherited any of the Contacts."
        static let APP_FORCE_UPDATE_MESSAGE: String = "New version is available in app store. Please download and try again."
    }
    
    struct Error_Log
    {
        static let UPLOAD_LOADER_TEXT: String = "Please wait..."
        static let UPLOAD_SUCCESS_MSG: String = "Errors uploaded sucessfully"
        static let UPLOAD_ERROR_MSG: String = "Unable to upload error. Please try again later"
        static let NO_ERROR_FOUND: String = "No errors found to upload"
        static let ERROR_OCCURED_ALERT: String = "Sorry an error occured. Please upload the error from 'Upload Error' option available inside the more menu."
    }
    
    struct DCR_DOCTOR_VISIT
    {
        static let EDETAILED_DOCTOR_REMOVE_BUT_ANALYTICS_SYNCED: String = "The contact record is already synched up and cannot be deleted"
    }
    
    struct LOGIN_DATA_DOWNLOAD
    {
       static let DATA_DOWNLOAD_ALERT: String = "Since Pevonia CRM SFA is a CRM tool, the app needs to download all the contact related data, partner routing details and other related information. This will require additional 5MB of data download. Please tap on OK button to proceed."
    }
    
    struct Landing_Alert_Message
    {
       static let NOTICEBOARD: String = " You have still pending message in Notice Board to read.  Please open 'Alert' menu on home page and read pending messages first."
        static let INWARD: String = "You have pending inward acknowledgement"
        static let MESSAGE: String = "You have unread message in your list please read"
        static let TASK: String = "You have pending task list"
    }
}

enum UserDefaultsValues: String
{
    case NoticeBoard = "NoticeBoard"
    case Inward = "Inward"
    case Message = "Message"
    case Task = "Task"
}

