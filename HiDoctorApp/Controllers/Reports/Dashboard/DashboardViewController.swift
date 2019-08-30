//
//  DashboardViewController.swift
//  HiDoctorApp
//
//  Created by SwaaS on 10/01/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,SelectedAssetOptionInDashboard
{
    //MARK:- Outlet Variables
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lastSyncDateTimeLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var emptyStateTitleLabel: UILabel!
    @IBOutlet weak var segmentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeLableViewHeightConstraint: NSLayoutConstraint!
    
    //MARK:- Private Variables
    let segmentSelfIndex = 0
    let segmentTeamIndex = 1
    var dashboardList: [DashboardModel] = []
    var dashBoardCollectionList : [DashboardCollectionValuesModel] = []
    var dashboardPSList : [DashboardPSHeaderModel] = []
    var dashboardPSDetailsList : [DashboardPSDetailsModel] = []
    var dashboardAssetList : [DashboardHeaderAssetModel] = []
    var dashBoardCustomerWiseList : [DashboardHeaderAssetModel] = []
    var refreshControl:UIRefreshControl = UIRefreshControl()
    
    struct Index
    {
        static let salesIndex : Int = 0
        static let productIndex : Int = 1
        static let assetWise  : Int = 2
        static let customerWise : Int = 3
    }
    
    
    //MARK:- Life Cycle Events
    override func viewDidLoad()
    {
        super.viewDidLoad()
        doInitialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
         self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Private Functions
    //MARK:-- API Functions
    private func segmentChanged(isCalledFromRefreshControl: Bool)
    {
        if (segmentControl.selectedSegmentIndex == segmentSelfIndex)
        {
            getDashboardDataForSelf(isCalledFromRefreshControl: isCalledFromRefreshControl)
        }
        else
        {
            getDashboardDataForTeam(isCalledFromRefreshControl: isCalledFromRefreshControl)
        }
    }
    
    private func getDashboardDataForSelf(isCalledFromRefreshControl: Bool)
    {
        if (!isCalledFromRefreshControl)
        {
            clearList()
        }
        
        if (checkInternetConnectivity())
        {
            showLoader(isCalledFromRefreshControl: isCalledFromRefreshControl)
            
            BL_Dashboard.sharedInstance.callAllAPI(type: 0 , completion: { (apiResponseObj) in
                self.getDashboardDataForSelfCallBack(apiResponseObj: apiResponseObj)
            })
        }
        else
        {
            getSelfDataFromLocal()
            if isCalledFromRefreshControl
            {
                hideLoader()
                showToastView(toastText: "No Internet Connection. Please try again.")
            }
        }
    }
    
    private func getDashboardDataForTeam(isCalledFromRefreshControl: Bool)
    {
        if (checkInternetConnectivity())
        {
            showLoader(isCalledFromRefreshControl: isCalledFromRefreshControl)
            
            BL_Dashboard.sharedInstance.callAllAPI(type: 1, completion: { (apiResponseObj) in
                self.getDashboardDataForTeamCallBack(apiResponseObj: apiResponseObj)
            })
        }
        else
        {
            if isCalledFromRefreshControl
            {
                hideLoader()
                showToastView(toastText: "No Internet Connection. Please try again.")
            }
            else
            {
                showEmptyStateView(emptyStateText: "You are offline. Please enable internet connection and try again")
            }
        }
    }
    
    private func getDashboardDataForSelfCallBack(apiResponseObj: ApiResponseModel)
    {
        hideLoader()
        
        if (apiResponseObj.Status == SERVER_SUCCESS_CODE)
        {
            getAssetWiseCount()
            getSelfDataFromLocal()
            setPSDetails()
        }
        else
        {
            if (apiResponseObj.Message != EMPTY && apiResponseObj.Message.uppercased() != errorTitle.uppercased())
            {
                showEmptyStateView(emptyStateText: apiResponseObj.Message)
            }
            else
            {
                showEmptyStateView(emptyStateText: "Sorry. Unable to get dashboard details")
            }
        }
    }
    
    private func getDashboardDataForTeamCallBack(apiResponseObj: ApiResponseModel)
    {
        hideLoader()
        
        if (apiResponseObj.Status == SERVER_SUCCESS_CODE)
        {
            dashboardList = BL_Dashboard.sharedInstance.getDashboardDetailOnlinTeam()
            
            //BL_Dashboard.sharedInstance.getDashbordDetailFromLocal(userCode: getUserCode(), regionCode: getRegionCode())
            
            if(checkInternetConnectivity())
            {
                BL_Dashboard.sharedInstance.getDashboardAllTeamDetails(dashBoardList: dashboardList) { (dashboard, status) in
                    if(status == 1)
                    {
                        removeCustomActivityView()
                        if(dashboard.count > 0)
                        {
                            BL_Dashboard.sharedInstance.dashBoardAssetCountListValues = apiResponseObj.list
                            self.getAssetWiseCount()
                            self.setPSDetails()
                            self.reloadTableView()
                        }
                        else
                        {
                            self.showEmptyStateView(emptyStateText: "No Dashboard details found. Please enable internet connection and try again")
                        }
                    }
                    else
                    {
                        AlertView.showAlertView(title: internetOfflineTitle, message: internetOfflineMessage, viewController: self)
                    }
                }
            }
            else
            {
                removeCustomActivityView()
                AlertView.showAlertView(title: internetOfflineTitle, message: internetOfflineMessage, viewController: self)
            }
//            dashboardList = BL_Dashboard.sharedInstance.convertDashboardModelForTeam(dashboardDetails: BL_Dashboard.sharedInstance.dashboardTeamDetails)
//            BL_Dashboard.sharedInstance.dashBoardAssetCountListValues = apiResponseObj.list
//            getAssetWiseCount()
//            setPSDetails()
//            reloadTableView()
        }
        else
        {
            if (apiResponseObj.Message != EMPTY && apiResponseObj.Message != errorTitle.uppercased())
            {
                showEmptyStateView(emptyStateText: apiResponseObj.Message)
            }
            else
            {
                showEmptyStateView(emptyStateText: "Sorry. Unable to get dashboard details")
            }
        }
    }
    
    private func getSelfDataFromLocal()
    {
        let objDashboardHeader = BL_Dashboard.sharedInstance.getDashbordHeaderFromLocal(userCode: getUserCode(), regionCode: getRegionCode())
        
        if (objDashboardHeader != nil)
        {
            lastSyncDateTimeLabel.text = getDateAndTimeInDisplayFormat(date: objDashboardHeader!.Last_Update_Date)
        }
        
        dashboardList = BL_Dashboard.sharedInstance.getDashboardDetailOnline()
        
        //BL_Dashboard.sharedInstance.getDashbordDetailFromLocal(userCode: getUserCode(), regionCode: getRegionCode())
        
        if(checkInternetConnectivity())
        {
            BL_Dashboard.sharedInstance.getDashboardAllSelfDetails(dashBoardList: dashboardList) { (dashboard, status) in
                if(status == 1)
                {
                    removeCustomActivityView()
                    if(dashboard.count > 0)
                    {
                        self.setPSDetails()
                        
                        if (self.dashboardList.count > 0) || self.dashboardPSList.count > 0 || self.dashboardPSDetailsList.count > 0 || self.dashBoardCollectionList.count > 0 || self.dashboardAssetList.count > 0
                        {
                            self.reloadTableView()
                            self.showMainView()
                        }
                        else
                        {
                            self.showEmptyStateView(emptyStateText: "No Dashboard details found. Please enable internet connection and try again")
                        }
                    }
                    else
                    {
                        self.showEmptyStateView(emptyStateText: "No Dashboard details found. Please enable internet connection and try again")
                    }
                }
                else
                {
                    AlertView.showAlertView(title: internetOfflineTitle, message: internetOfflineMessage, viewController: self)
                }
            }
        }
        else
        {
            removeCustomActivityView()
            AlertView.showAlertView(title: internetOfflineTitle, message: internetOfflineMessage, viewController: self)
        }
    }
    
    private func setPSDetails()
    {
        if BL_Dashboard.sharedInstance.checkIsToShowPSDetails()
        {
            self.dashboardPSList = BL_Dashboard.sharedInstance.getDashBoardPSDetails()
            self.dashBoardCollectionList = BL_Dashboard.sharedInstance.getDashBoardCollectionValues()
            self.dashboardPSDetailsList = BL_Dashboard.sharedInstance.getDashboardPSProductDetails()
        }
    }
    
    private func getAssetWiseCount()
    {
        let dashboardAssets = BL_Dashboard.sharedInstance.dashBoardAssetCountListValues
        if dashboardAssets.count > 0 && segmentControl.selectedSegmentIndex == segmentSelfIndex
        {
            self.dashboardAssetList = BL_Dashboard.sharedInstance.getDashboardSelfAssetList(assetsCountList: dashboardAssets)
        }
        else if dashboardAssets.count > 0
        {
            self.dashboardAssetList = BL_Dashboard.sharedInstance.getDashboardTeamAssetList(assetsCountList: dashboardAssets)
        }
    }
    
    private func reloadTableView()
    {
        if (dashboardList.count > 0) || dashboardPSList.count > 0 || dashboardPSDetailsList.count > 0 || dashBoardCollectionList.count > 0
        {
            tableView.reloadData()
            
            if (segmentControl.selectedSegmentIndex == segmentSelfIndex)
            {
                showTimeLabel()
            }
            else
            {
                hideTimeLabel()
            }
            
            showSegmentControl()
            showMainView()
        }
        else
        {
            showEmptyStateView(emptyStateText: "No Dashboard details found")
        }
    }
    
    //MARK:-- Show/Hide Functions
    private func showLoader(isCalledFromRefreshControl: Bool)
    {
        if (isCalledFromRefreshControl)
        {
            refreshControl.beginRefreshing()
        }
        else
        {
            showCustomActivityIndicatorView(loadingText: "Loading...")
        }
    }
    
    private func hideLoader()
    {
        if (refreshControl.isRefreshing)
        {
            refreshControl.endRefreshing()
        }
        else
        {
            removeCustomActivityView()
        }
    }
    
    private func showTimeLabel()
    {
        lastSyncDateTimeLabel.isHidden = false
        timeLableViewHeightConstraint.constant = 25
    }
    
    private func hideTimeLabel()
    {
        lastSyncDateTimeLabel.isHidden = true
        timeLableViewHeightConstraint.constant = 0
    }
    
    private func showSegmentControl()
    {
        if (isManager())
        {
            segmentControl.isHidden = false
            segmentViewHeightConstraint.constant = 40
        }
        else
        {
            hideSegmentControl()
        }
    }
    
    private func hideSegmentControl()
    {
        segmentControl.isHidden = true
        segmentViewHeightConstraint.constant = 0
    }
    
    private func showErrorToast(apiResponseObj: ApiResponseModel)
    {
        showToastView(toastText: apiResponseObj.Message)
    }
    
    private func showMainView()
    {
        mainView.isHidden = false
        emptyStateView.isHidden = true
    }
    
    private func showEmptyStateView(emptyStateText: String)
    {
        mainView.isHidden = true
        emptyStateView.isHidden = false
        emptyStateTitleLabel.text = emptyStateText
        hideTimeLabel()
    }
    
    //MARK:-- Initial Setup Functions
    private func doInitialSetup()
    {
        self.title = "Dashboard"
        
        addBackButtonView()
        addRefreshControl()
        hideSegmentControl()
        hideTimeLabel()
        showMainView()
        segmentChanged(isCalledFromRefreshControl: false)
    }
    
//    private func addBackButtonView()
//    {
//        let backButton = UIButton(type: UIButtonType.custom)
//        
//        backButton.addTarget(self, action: #selector(self.backButtonAction), for: UIControlEvents.touchUpInside)
//        backButton.setImage(UIImage(named: "navigation-arrow"), for: .normal)
//        backButton.sizeToFit()
//        
//        let backButtonItem = UIBarButtonItem(customView: backButton)
//        
//        self.navigationItem.leftBarButtonItem = backButtonItem
//    }
//    
//    @objc func backButtonAction()
//    {
//        _ = navigationController?.popViewController(animated: false)
//    }
    
    //MARK: - Pull to refresh
    func addRefreshControl()
    {
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh()
    {
        segmentChanged(isCalledFromRefreshControl: true)
    }
    
    //MARK:- Table View Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if BL_Dashboard.sharedInstance.checkIsToShowPSDetails()
        {
            if dashboardList.count > 0
            {
                if BL_DCR_Doctor_Visit.sharedInstance.geteDetailingConfigVal().lowercased() == ConfigValues.YES.rawValue.lowercased()
                {
                    return dashboardList.count + 4
                }
                return dashboardList.count + 2
            }
            else
            {
                return 0
            }
        }
        if dashboardList.count > 0
        {
            if BL_DCR_Doctor_Visit.sharedInstance.geteDetailingConfigVal().lowercased() == ConfigValues.YES.rawValue.lowercased()
            {
                return dashboardList.count + 2
            }
            return dashboardList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let index = indexPath.row
        
        if BL_Dashboard.sharedInstance.checkIsToShowPSDetails()
        {
            if index == Index.salesIndex
            {
                return BL_Dashboard.sharedInstance.getSalesMainCellHeight(array: dashboardPSList)
            }
            else if index == Index.productIndex
            {
                return BL_Dashboard.sharedInstance.getProductMainCellHeight(array: dashboardPSDetailsList)
            }
            else if index == Index.assetWise && BL_DCR_Doctor_Visit.sharedInstance.geteDetailingConfigVal().lowercased() == ConfigValues.YES.rawValue.lowercased()
            {
                return BL_Dashboard.sharedInstance.getDashboardEdetailingHeight()
            }
            else if(index == 3)
            {
                return 0
            }
            else
            {
                return BL_Dashboard.sharedInstance.getDashboardCellHeight()
            }
        }
        else if !BL_Dashboard.sharedInstance.checkIsToShowPSDetails()
        {
            if index == 0 && BL_DCR_Doctor_Visit.sharedInstance.geteDetailingConfigVal().lowercased() == ConfigValues.YES.rawValue.lowercased()
            {
                 return BL_Dashboard.sharedInstance.getDashboardEdetailingHeight()
            }
            else if(index == 1)
            {
                return 0
            }
            else
            {
                return BL_Dashboard.sharedInstance.getDashboardCellHeight()
            }
        }
        return BL_Dashboard.sharedInstance.getDashboardCellHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let index = indexPath.row
        let salesObj = dashboardPSList.first
        
        if (index == Index.salesIndex || index == Index.productIndex) && BL_Dashboard.sharedInstance.checkIsToShowPSDetails()
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.DashboardSalesProductCell) as! DashBoardProductTableViewCell
            
            cell.totalSalesHgtConst.constant = 0
            var headerLbl : String = EMPTY
            var titleLbl : String = EMPTY
            var titleImg : String = EMPTY
            var date : Date?
            var detailsTxt:String = EMPTY
            cell.emptyStateView.isHidden = true
            cell.dataView.isHidden = true
            
            if index == Index.salesIndex
            {
                if dashboardPSList.count > 0
                {
                    var collectionValue : String = "0.00"
                    var outStandingValue : String = "0.00"
                    var collectionDateTime : String = NOT_APPLICABLE
                    
                    if dashBoardCollectionList.count > 0
                    {
                        let collectionObj = dashBoardCollectionList.first
                        if collectionObj?.Collection_Value != nil
                        {
                            collectionValue = BL_Dashboard.sharedInstance.getAmountInThousand(amount: (collectionObj?.Collection_Value)!)
                        }
                        if collectionObj?.OutStanding_Value != nil
                        {
                            outStandingValue = BL_Dashboard.sharedInstance.getAmountInThousand(amount: (collectionObj?.OutStanding_Value)!)
                        }
                        if collectionObj?.Processed_Date != nil
                        {
                            let date = convertDateIntoString(date: (collectionObj?.Processed_Date)!)
                            let time = getTimeIn12HrFormat(date: (collectionObj?.Processed_Date)!, timeZone: utcTimeZone)
                            collectionDateTime = "\(date) \(time)"
                        }
                    }
                    
                    if salesObj?.Processed_Date != nil
                    {
                        date = salesObj?.Processed_Date
                    }
                    
                    
                    cell.collectionDateLbl.text = "Collection as of  \(collectionDateTime)"
                    cell.collectionLbl.text = collectionValue
                    cell.outstandingLbl.text = outStandingValue
                    cell.totalSalesHgtConst.constant = 80
                    cell.leftHeaderLblWidthConst.constant = 0
                    cell.collectionSalesView.isHidden = false
                    cell.dataView.isHidden = false
                    headerLbl = "Total"
                    titleLbl = "Sales Details"
                    titleImg = "icon-PS-Sales"
                    detailsTxt = "Sales"
                }
                else
                {
                    cell.emptyStateView.isHidden = false
                    cell.emptyStateLbl.text = "No Sales Details Available"
                }
            }
            else if index == Index.productIndex
            {
                titleLbl = "Product Details"
                titleImg = "icon-PS-Products"
                detailsTxt = "Products"
                
                if dashboardPSDetailsList.count > 0
                {
                    let productObj = dashboardPSDetailsList.first
                    date = productObj?.Processed_Date
                    cell.leftHeaderLblWidthConst.constant = 100
                    cell.collectionSalesView.isHidden = true
                    headerLbl = "Product Name"
                    cell.dataView.isHidden = false
                }
                else
                {
                    cell.emptyStateView.isHidden = false
                    cell.emptyStateLbl.text = "No Product Details Available"
                }
            }
            
            cell.wrapperView.layer.cornerRadius = 3
            cell.wrapperView.layer.masksToBounds = true
            cell.wrapperView.layer.borderWidth = 1
            cell.wrapperView.layer.borderColor = UIColor.lightGray.cgColor
            cell.headerLbl.text = headerLbl
            cell.titleLbl.text = titleLbl
            cell.titleImg.image = UIImage(named: titleImg)
            
            var dateTime = NOT_APPLICABLE
            
            if date != nil
            {
                let formattedDate = convertDateIntoString(date: date!)
                let time = getTimeIn12HrFormat(date: date!, timeZone:utcTimeZone)
                dateTime = "\(formattedDate) \(time)"
            }
            
            cell.salesDetailsLbl.text = "\(detailsTxt) as of \(dateTime)"
            cell.productList = dashboardPSDetailsList
            cell.salesList = dashboardPSList
            cell.selectedIndex = index
            cell.tableView.reloadData()
            
            return cell
        }
        else if ((index == Index.assetWise || index == Index.customerWise) && BL_Dashboard.sharedInstance.checkIsToShowPSDetails() && BL_DCR_Doctor_Visit.sharedInstance.geteDetailingConfigVal().lowercased() == ConfigValues.YES.rawValue.lowercased()) || ((index == 0 || index == 1) && !BL_Dashboard.sharedInstance.checkIsToShowPSDetails() && BL_DCR_Doctor_Visit.sharedInstance.geteDetailingConfigVal().lowercased() == ConfigValues.YES.rawValue.lowercased())
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.DashboardHeaderAssetCell) as! DashboardDigitalAssetTableViewCell
            cell.dataView.isHidden = true
            cell.emptyStateView.isHidden = true
            var headerTitle : String = "eDetailing"
            if (index == Index.customerWise ||  index == 1)
            {
                cell.dashboardAssetList = dashBoardCustomerWiseList
                headerTitle = "Customer Wise"
            }
            cell.headerTitle.text = headerTitle
            
            if ((dashboardAssetList.count == 0 && (index == Index.assetWise || index == 0)) || (dashBoardCustomerWiseList.count == 0 && (index == Index.customerWise || index == 1))) && checkInternetConnectivity()
            {
                cell.emptyStateView.isHidden = false
                var emptyStateText = "No Resource Details Found"
                if (index == Index.customerWise ||  index == 1)
                {
                    emptyStateText = "No Customer Details Found"
                }
                cell.emptyStateLbl.text = emptyStateText
            }
            else
            {
                if checkInternetConnectivity()
                {
                    cell.dataView.isHidden = false
                    if ((index == Index.assetWise) || (index == 0))
                    {
                        let firstObj = dashboardAssetList[0]
                        let secondObj = dashboardAssetList[1]
                        
                        cell.top10AssetsLbl.text = "Top\n10\nResources"
                        cell.top10DoctorLbl.text = "Top\n10\n\(appDoctorPlural)"
                        cell.detailedAssetsLbl.text = "\(firstObj.assetHeaderType!)\n\(firstObj.assetCount!)"
                        cell.nonDetailedAssetsLbl.text = "\(secondObj.assetHeaderType!)\n\(secondObj.assetCount!)"
                    }
                    else
                    {
                        var headerCountText : String = String(describing: BL_Dashboard.sharedInstance.totalAssetCount!)
                        if segmentControl.selectedSegmentIndex == segmentTeamIndex
                        {
                            headerCountText += "(\(dashboardAssetList.count) Users)"
                        }
                        cell.dashboardAssetList = dashboardAssetList
                        cell.delegate = self
                    }
                }
                else
                {
                    cell.emptyStateView.isHidden = false
                    cell.emptyStateLbl.text = internetOfflineMessage
                }
            }
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardCell") as! DashboardTableViewCell
            var objDashBoard : DashboardModel!
            
            if (BL_Dashboard.sharedInstance.checkIsToShowPSDetails()) && (BL_DCR_Doctor_Visit.sharedInstance.geteDetailingConfigVal().lowercased() == ConfigValues.YES.rawValue.lowercased())
            {
                objDashBoard = dashboardList[indexPath.row - 4]
                cell.coverButton.tag = indexPath.row - 4
            }
            else if (BL_Dashboard.sharedInstance.checkIsToShowPSDetails()) && (BL_DCR_Doctor_Visit.sharedInstance.geteDetailingConfigVal().lowercased() != ConfigValues.YES.rawValue.lowercased())
            {
                objDashBoard = dashboardList[indexPath.row - 2]
                cell.coverButton.tag = indexPath.row - 2
            }
            else if (BL_DCR_Doctor_Visit.sharedInstance.geteDetailingConfigVal().lowercased() == ConfigValues.YES.rawValue.lowercased()) && (!BL_Dashboard.sharedInstance.checkIsToShowPSDetails())
            {
                objDashBoard = dashboardList[indexPath.row - 2]
                cell.coverButton.tag = indexPath.row - 2
            }
            else
            {
                objDashBoard = dashboardList[indexPath.row]
                cell.coverButton.tag = indexPath.row
            }
            
            cell.entityNameLabel.text = objDashBoard.entityName
            if(objDashBoard.entityId == 3)
            {
                cell.entityValueLabel.text = "\(objDashBoard.currentCallAverage)(" + "\(objDashBoard.priviousCallAverage))"
            }
            else
            {
               cell.entityValueLabel.text = "\(objDashBoard.dashboardAppliedList.count)"
            }
            cell.iconImageView.image = UIImage(named: objDashBoard.iconName)
            
            cell.wrapperView.layer.cornerRadius = 3
            cell.wrapperView.layer.masksToBounds = true
            cell.wrapperView.layer.borderWidth = 1
            cell.wrapperView.layer.borderColor = UIColor.lightGray.cgColor
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    //MARK:- IB Actions
    @IBAction func segmentedControlValueChanged(sender: AnyObject)
    {
        segmentChanged(isCalledFromRefreshControl: false)
    }
    
    @IBAction func retryAction()
    {
        segmentChanged(isCalledFromRefreshControl: false)
    }
    
    @IBAction func coverButtonAction(sender: AnyObject)
    {
        let objDasboard = dashboardList[sender.tag!]
        if (objDasboard.isDrillDownRequired)
        {
            let entityId = objDasboard.entityId
            
            if (entityId == Constants.DashboardEntityIDs.Doctor_Missed)
            {
                navigateToMissedDoctorsPage()
            }
            else if (entityId == Constants.DashboardEntityIDs.My_DCR_Pending_For_Approval)
            {
                navigateToMyDCRPendingForApproval(dashboardAppliedList: objDasboard.dashboardAppliedList)
            }
            else if (entityId == Constants.DashboardEntityIDs.My_TP_Pending_For_Approval)
            {
                navigateToMyDCRPendingForApproval(dashboardAppliedList: objDasboard.dashboardAppliedList)
            }
            else if (entityId == Constants.DashboardEntityIDs.Team_DCR_Pending_For_Approval)
            {
                navigateToMyDCRPendingForApprovalTeam(dashboardAppliedList: objDasboard.dashboardAppliedList)
            }
            else if (entityId == Constants.DashboardEntityIDs.Team_TP_Pending_For_Approval)
            {
                navigateToMyDCRPendingForApprovalTeam(dashboardAppliedList: objDasboard.dashboardAppliedList)
            }
        }
    }
    
    func getSelectedAssetOption(type: Int,assetObj : DashboardHeaderAssetModel)
    {
        var isDetailed : Bool = false
        
        if type == SelectedAssetOption.NoOfDetailedAssets
        {
            isDetailed = true
        }
        
        if segmentControl.selectedSegmentIndex == segmentSelfIndex
        {
            let sb = UIStoryboard(name: Constants.StoaryBoardNames.DashboardAssetSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.DashboardAssetDetailsVCID) as! DashboardAssetDetails
            vc.isDetailed = isDetailed
            vc.userCode = getUserCode()
            vc.userName = getUserName()
            vc.count = Int(assetObj.assetCount)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let sb = UIStoryboard(name: Constants.StoaryBoardNames.DashboardAssetSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.DashboardAssetDoctorDetailsVCID) as! DashboardAssetDoctorDetails
            vc.isDetailed = isDetailed
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK:- Navigation Functions
    private func navigateToMissedDoctorsPage()
    {
        if (segmentControl.selectedSegmentIndex == segmentSelfIndex)
        {
            let currentList : ApprovalUserMasterModel = ApprovalUserMasterModel()
            let sb = UIStoryboard(name: "Dashboard", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.DashboardDoctorMissedDetailsVcID) as! DashboardDoctorMissedDetailsViewController
            currentList.User_Code = getUserCode()
            currentList.Region_Code = getRegionCode()
            vc.userObj = currentList
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let sb = UIStoryboard(name: "Dashboard", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.DashboardDoctorMissedRegionVcID) as! DashboardDoctorMissedRegionsViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func navigateToMyDCRPendingForApproval(dashboardAppliedList:[DashBoardAppliedCount])
    {
        
        let sb = UIStoryboard(name: "Dashboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.DashBoardPendingMonthApprovalViewControllerID) as! DashBoardPendingMonthApprovalViewController
        vc.dashboardAppliedList = dashboardAppliedList
        self.navigationController?.pushViewController(vc, animated: true)
        
        //        let sb = UIStoryboard(name: "Dashboard", bundle: nil)
        //        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.DashBoardPendingApprovalVcID) as! DashBoardPendingApprovalViewController
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToMyDCRPendingForApprovalTeam(dashboardAppliedList:[DashBoardAppliedCount])
    {
        
        let sb = UIStoryboard(name: "Dashboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.DashboardUserListViewControllerID) as! DashboardUserListViewController
        vc.dashboardAppliedList = dashboardAppliedList
        self.navigationController?.pushViewController(vc, animated: true)
        
        //        let sb = UIStoryboard(name: "Dashboard", bundle: nil)
        //        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.DashBoardPendingApprovalVcID) as! DashBoardPendingApprovalViewController
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToTeamDCRPendingForApproval()
    {
        if (segmentControl.selectedSegmentIndex == segmentTeamIndex)
        {
            self.navigateFunc(type: 0)
        }
    }
    
    private func navigateToMyTPPendingForApproval()
    {
        
    }
    
    private func navigateToTeamTPPendingForApproval()
    {
        if (segmentControl.selectedSegmentIndex == segmentTeamIndex)
        {
            self.navigateFunc(type: 1)
        }
    }
    
    private func navigateFunc(type : Int)
    {
        if checkInternetConnectivity()
        {
            let sb = UIStoryboard(name: Constants.StoaryBoardNames.DashboardSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.DashBoardPendingUserListVcID) as! DashboardPendingUserListViewController
            if type == 1
            {
                vc.isComingFromTpPage = true
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    
    
    private func clearList()
    {
        self.dashboardList = []
        self.dashboardPSDetailsList = []
        self.dashboardPSList = []
        self.dashBoardCollectionList = []
    }
    
    @IBAction func dashboardEdetailingBtnAction(_ sender: UIButton)
    {
        let tag = sender.tag
        var lblArray : [UILabel]!
        
        if (sender.isHighlighted) {
            if let cell = sender.superview?.superview?.superview?.superview?.superview as? DashboardDigitalAssetTableViewCell
            {
                lblArray  = [cell.top10AssetsLbl,cell.top10DoctorLbl,cell.detailedAssetsLbl,cell.nonDetailedAssetsLbl]
                let edetailingLbl  = lblArray[sender.tag - 1]
                if sender.tag == 2 || sender.tag == 3
                {
                    sender.backgroundColor = UIColor.white
                    edetailingLbl.textColor = UIColor.darkGray
                }
                else
                {
                    sender.backgroundColor = brandColor
                    edetailingLbl.textColor = UIColor.white
                }
            }
        }
        
        let delayTime = DispatchTime.now() + 0.1
        
        DispatchQueue.main.asyncAfter(deadline: delayTime)
        {
            let edetailingLbl  = lblArray[sender.tag
                - 1]
            if sender.tag == 2 || sender.tag == 3
            {
                sender.backgroundColor = brandColor
                edetailingLbl.textColor = UIColor.white
            }
            else
            {
                sender.backgroundColor = UIColor.white
                edetailingLbl.textColor = UIColor.darkGray
            }
            
            if tag == 3 || tag == 4
            {
                var assetObj : DashboardHeaderAssetModel!
                var type  = 1
                if sender.tag == 3
                {
                    assetObj = self.dashboardAssetList[0]
                    type = SelectedAssetOption.NoOfDetailedAssets
                }
                else if sender.tag == 4
                {
                    assetObj = self.dashboardAssetList[1]
                }
                self.getSelectedAssetOption(type: type, assetObj: assetObj)
            }
            else if tag == 1
            {
                let sb = UIStoryboard(name: Constants.StoaryBoardNames.DashboardSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.TopAssetVCID) as! TopAssetViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if tag == 2
            {
                let sb = UIStoryboard(name: Constants.StoaryBoardNames.DashboardSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier:Constants.ViewControllerNames.TopDoctorsVCID) as! TopDoctorsViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}
