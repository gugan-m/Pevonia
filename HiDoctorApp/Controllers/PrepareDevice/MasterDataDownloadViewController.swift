//
//  MasterDataDownloadViewController.swift
//  HiDoctorApp
//
//  Created by Vignaya on 11/8/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class MasterDataDownloadViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var tableView : UITableView!
    
    var masterDataList : NSMutableArray = []
    var lastSyncDateTimeList : [ApiDownloadDetailModel]?
    var autoDownloadMasterData : Bool = false
    
    struct MasterDataDownloadName
    {
        static let DownloadAllMasterData = "Download all Master Data"
        static let SystemSettings = "System Settings"
        static let HolidayData = "Holiday Data"
        static let DoctorData = "Doctor/Customer Data" //"\(appDoctor) Data"
        static let ExpenseData = "Expense data"
        static let ProductData = "Product data"
        static let CpTpDetails = "Cp & Tp Details"//"\(appCp) Details"
        static let SFCAccompanistData = "SFC & Accompanist Data"
        static let MenuData = "Menu Data"
        static let DigitalAssets = PEV_DIGITAL_ASSETS
        static let MarketContent = "Market Content"
    }
    
    struct apiStatus
    {
        static let DownloadAllMasterData = " All data"
        static let SystemSettings = "System Settings"
        static let HolidayData = "Holiday Data"
        static let DoctorData = "\(appDoctor) Data"
        static let ExpenseData = "Expense data"
        static let ProductData = "Product data"
        static let CpTpDetails = "\(appCp) Details"
        static let SFCAccompanistData = "SFC & Accompanist Data"
        static let MenuData = "Menu Data"
        static let DigitalAssets = "Digital Assets"
        static let MarketContent = "Market Content"
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Master Data Download"
        addCustomBackButtonToNavigationBar()
        setMasterDataList()
        self.reloadTableView()
        self.autoDownloadAllMasterData()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return masterDataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MasterDataCell", for: indexPath) as! MasterDataTableViewCell
        let detailDict = masterDataList.object(at: indexPath.row) as? NSDictionary
        let apiName = detailDict?["title"] as? String
        
        if (apiName == "Doctor/Customer Data")
        {
            cell.titleLbl.text = "\(appDoctor) Data"
        }
        else if (apiName == "Cp & Tp Details")
        {
            cell.titleLbl.text = "\(appCp) Data"
        }
        else
        {
            cell.titleLbl.text = apiName
        }
        
        let lastSynTime = getLastSyncDataTime(groupName: apiName!)
        if lastSynTime != ""
        {
            cell.detailLbl.text = "Last Sync Date : \(lastSynTime)"
        }
        else
        {
            cell.detailLbl.text = detailDict?["date"] as? String
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if checkInternetConnectivity()
        {
            self.sendApiCalls(indexPath: indexPath.row)
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    
    func setMasterDataList()
    {
        masterDataList = [
            [
                "title":MasterDataDownloadName.DownloadAllMasterData,
                "date":"Last Sync Date : 12-11-2016 17:11:82"
            ],
            [
                "title":MasterDataDownloadName.SystemSettings,
                "date":"Last Sync Date : 12-11-2016 17:11:82"
            ],
            [
                "title":MasterDataDownloadName.HolidayData,
                "date":"Last Sync Date : 12-11-2016 17:11:82"
            ],
            [
                "title":MasterDataDownloadName.DoctorData,
                "date":"Last Sync Date : 12-11-2016 17:11:82"
            ],
            [
                "title":MasterDataDownloadName.ExpenseData,
                "date":"Last Sync Date : 12-11-2016 17:11:82"
            ],
            [
                "title":MasterDataDownloadName.ProductData,
                "date":"Last Sync Date : 12-11-2016 17:11:82"
            ],
            [
                "title":MasterDataDownloadName.CpTpDetails,
                "date":"Last Sync Date : 12-11-2016 17:11:82"
            ],
            [
                "title":MasterDataDownloadName.SFCAccompanistData,
                "date":"Last Sync Date : 12-11-2016 17:11:82"
            ],
            [
                "title":MasterDataDownloadName.MenuData,
                "date":"Last Sync Date : 12-11-2016 17:11:82"
            ]
        ]
        if BL_DCR_Doctor_Visit.sharedInstance.geteDetailingConfigVal().lowercased() == ConfigValues.YES.rawValue.lowercased()
        {
            masterDataList.add([
                "title":MasterDataDownloadName.DigitalAssets,
                "date":"Last Sync Date : 12-11-2016 17:11:82"
                ])
        }
        if BL_DCR_Doctor_Visit.sharedInstance.getStoryEnabledPrivVal().lowercased() == PrivilegeValues.YES.rawValue.lowercased()
        {
            masterDataList.add([
                "title":MasterDataDownloadName.MarketContent,
                "date":"Last Sync Date : 12-11-2016 17:11:82"
                ])
        }
    }
    
    func sendApiCalls(indexPath : Int)
    {
        switch indexPath
        {
        case 0:
            self.downloadAllMasterData()
            break
        case 1:
            self.downloadSystemSettings()
            break
        case 2:
            self.downloadHolidayData()
            break
        case 3:
            self.downloadDoctorData()
            break
        case 4:
            self.downloadExpenseData()
            break
        case 5:
            self.downloadProductData()
            break
        case 6:
            self.downloadCpData()
            break
        case 7:
            self.downloadSFCData()
            break
        case 8 :
            self.downloadMenuData()
            break
        case 9:
            if BL_DCR_Doctor_Visit.sharedInstance.geteDetailingConfigVal().lowercased() == ConfigValues.YES.rawValue.lowercased()
            {
                self.downloadDigitalAssetsData()
            }
            else if BL_DCR_Doctor_Visit.sharedInstance.getStoryEnabledPrivVal().lowercased() == PrivilegeValues.YES.rawValue.lowercased()
            {
                self.downloadMarketContentData()
            }
            break
        case 10:
            self.downloadMarketContentData()
        default:
            print("")
            break
        }
    }
    
    func getPostData(sectionName: String) -> [String: Any]
    {
        let postData :[String:Any] = ["Company_Code":getCompanyCode(),"User_Code":getUserCode(),"Section_Name":"Download" + sectionName + "From MasterData","Download_Date":getCurrentDateAndTimeString(),"Downloaded_Acc_Region_Codes":BL_PrepareMyDeviceAccompanist.sharedInstance.getRegionCodeStringWithOutQuotes()]
        
        return postData
    }
    
    //MARK: - Api Calls
    
    func downloadAllMasterData()
    {
        showCustomActivityIndicatorView(loadingText: "Downloading \(apiStatus.DownloadAllMasterData)...")
//        CustomActivityIndicator.sharedInstance.loadingText = "Downloading \(apiStatus.DownloadAllMasterData.rawValue)..."
//       CustomActivityIndicator.sharedInstance.showCustomActivityIndicatorView()
        BL_MasterDataDownload.sharedInstance.dowloadAllData(masterDataGroupName: masterDataGroupName.DownloadAllMasterData.rawValue, completion: { (status) in
            if(status == SERVER_SUCCESS_CODE)
            {
                BL_MasterDataDownload.sharedInstance.autoDownload = false
                WebServiceHelper.sharedInstance.syncMasterDataDownloadDetails(postData: self.getPostData(sectionName: apiStatus.DownloadAllMasterData), completion: { (apiObj) in
                   self.showToast(toastText: self.getErrorMessageForStatus(statusCode: status, dataName: apiStatus.DownloadAllMasterData))
                    
                })
            }
        })

    }
    
    func downloadSystemSettings()
    {
        showCustomActivityIndicatorView(loadingText: "Downloading \(apiStatus.SystemSettings)...")
        BL_MasterDataDownload.sharedInstance.downloadSystemSettings(masterDataGroupName: masterDataGroupName.SystemSettings.rawValue, completion: { (status) in
            if(status == SERVER_SUCCESS_CODE)
            {
                WebServiceHelper.sharedInstance.syncMasterDataDownloadDetails(postData: self.getPostData(sectionName: apiStatus.SystemSettings), completion: { (apiObj) in
                    self.showToast(toastText: self.getErrorMessageForStatus(statusCode: status, dataName: apiStatus.SystemSettings))
                    
                })
            }

//             self.showToast(toastText: self.getErrorMessageForStatus(statusCode: status, dataName: apiStatus.SystemSettings))
        })
    }
    
    func downloadHolidayData()
    {
         showCustomActivityIndicatorView(loadingText: "Downloading \(apiStatus.HolidayData)...")
        BL_MasterDataDownload.sharedInstance.downloadHolidayData(masterDataGroupName: masterDataGroupName.HolidayData.rawValue, completion: { (status) in
            if(status == SERVER_SUCCESS_CODE)
            {
                WebServiceHelper.sharedInstance.syncMasterDataDownloadDetails(postData: self.getPostData(sectionName: apiStatus.HolidayData), completion: { (apiObj) in
                    self.showToast(toastText: self.getErrorMessageForStatus(statusCode: status, dataName: apiStatus.HolidayData))
   
                })
            }
           //  self.showToast(toastText: self.getErrorMessageForStatus(statusCode: status, dataName: apiStatus.HolidayData))
        })

    }
    
    func downloadDoctorData()
    {
        showCustomActivityIndicatorView(loadingText: "Downloading \(apiStatus.DoctorData)...")
        BL_MasterDataDownload.sharedInstance.downloadCustomerData(masterDataGroupName: masterDataGroupName.DoctorData.rawValue, completion: { (status) in
            if(status == SERVER_SUCCESS_CODE)
            {
                WebServiceHelper.sharedInstance.syncMasterDataDownloadDetails(postData: self.getPostData(sectionName: apiStatus.DoctorData), completion: { (apiObj) in
                    self.showToast(toastText: self.getErrorMessageForStatus(statusCode: status, dataName: apiStatus.DoctorData))
                })
            }
//             self.showToast(toastText: self.getErrorMessageForStatus(statusCode: status, dataName: apiStatus.DoctorData))
            
        })
    }
    
    func downloadExpenseData()
    {
        showCustomActivityIndicatorView(loadingText: "Downloading \(apiStatus.ExpenseData)...")
        BL_MasterDataDownload.sharedInstance.downloadExpenseData(masterDataGroupName: masterDataGroupName.ExpenseData.rawValue, completion: { (status) in
            if(status == SERVER_SUCCESS_CODE)
            {
                WebServiceHelper.sharedInstance.syncMasterDataDownloadDetails(postData: self.getPostData(sectionName: apiStatus.ExpenseData), completion: { (apiObj) in
                    self.showToast(toastText: self.getErrorMessageForStatus(statusCode: status, dataName: apiStatus.ExpenseData))
                })
            }
            // self.showToast(toastText: self.getErrorMessageForStatus(statusCode: status, dataName: apiStatus.ExpenseData))
        })
    }
    
    func downloadProductData()
    {
        showCustomActivityIndicatorView(loadingText: "Downloading \(apiStatus.ProductData)...")
        BL_MasterDataDownload.sharedInstance.downloadProductData(masterDataGroupName: masterDataGroupName.ProductData.rawValue, completion: { (status) in
            if(status == SERVER_SUCCESS_CODE)
            {
                WebServiceHelper.sharedInstance.syncMasterDataDownloadDetails(postData: self.getPostData(sectionName: apiStatus.ProductData), completion: { (apiObj) in
                    self.showToast(toastText: self.getErrorMessageForStatus(statusCode: status, dataName: apiStatus.ProductData))
                })
            }
         //  self.showToast(toastText: self.getErrorMessageForStatus(statusCode: status, dataName: apiStatus.ProductData))
        })
    }
    
    func downloadCpData()
    {
        showCustomActivityIndicatorView(loadingText: "Downloading \(apiStatus.CpTpDetails)...")
        BL_MasterDataDownload.sharedInstance.downloadCPTPData(masterDataGroupName: masterDataGroupName.CpTpDetails.rawValue, completion: { (status) in
            if(status == SERVER_SUCCESS_CODE)
            {
                WebServiceHelper.sharedInstance.syncMasterDataDownloadDetails(postData: self.getPostData(sectionName: apiStatus.CpTpDetails), completion: { (apiObj) in
                    self.showToast(toastText: self.getErrorMessageForStatus(statusCode: status, dataName: apiStatus.CpTpDetails))

                })
            }
            //  self.showToast(toastText: self.getErrorMessageForStatus(statusCode: status, dataName: apiStatus.CpTpDetails))
        })
    }
    
    func downloadSFCData()
    {
        showCustomActivityIndicatorView(loadingText: "Downloading \(apiStatus.SFCAccompanistData)...")
        BL_MasterDataDownload.sharedInstance.downloadSFCAndAccompanistData(masterDataGroupName: masterDataGroupName.SFCAccompanistData.rawValue, completion: { (status) in
            if(status == SERVER_SUCCESS_CODE)
            {
                WebServiceHelper.sharedInstance.syncMasterDataDownloadDetails(postData: self.getPostData(sectionName: apiStatus.SFCAccompanistData), completion: { (apiObj) in
                    self.showToast(toastText: self.getErrorMessageForStatus(statusCode: status, dataName: apiStatus.SFCAccompanistData))
                })
            }
           // self.showToast(toastText: self.getErrorMessageForStatus(statusCode: status, dataName: apiStatus.SFCAccompanistData))
        })
    }
    
    func downloadMenuData()
    {
        showCustomActivityIndicatorView(loadingText: "Downloading \(apiStatus.MenuData)...")
        
        BL_MasterDataDownload.sharedInstance.getUserTypeMenuAccess(masterDataGroupName: masterDataGroupName.MenuData.rawValue, completion: { (status) in
            if(status == SERVER_SUCCESS_CODE)
            {
                WebServiceHelper.sharedInstance.syncMasterDataDownloadDetails(postData: self.getPostData(sectionName: apiStatus.MenuData), completion: { (apiObj) in
                    self.showToast(toastText: self.getErrorMessageForStatus(statusCode: status, dataName: apiStatus.MenuData))
                })
            }
          //  self.showToast(toastText: self.getErrorMessageForStatus(statusCode: status, dataName: apiStatus.MenuData))
        })

    }
    
    func downloadDigitalAssetsData()
    {
        showCustomActivityIndicatorView(loadingText: "Downloading \(apiStatus.DigitalAssets)...")
        
        BL_MasterDataDownload.sharedInstance.getDigitalAssetsData(masterDataGroupName: masterDataGroupName.DigitalAssets.rawValue, completion: { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                UserDefaults.standard.set(true, forKey: "PlayList")
                
                if BL_DCR_Doctor_Visit.sharedInstance.getStoryEnabledPrivVal().lowercased() == PrivilegeValues.YES.rawValue.lowercased()
                {
                    BL_MasterDataDownload.sharedInstance.getStoryData(masterDataGroupName: masterDataGroupName.DigitalAssets.rawValue, completion: { (status) in
                        self.showToast(toastText: self.getErrorMessageForStatus(statusCode: status, dataName: apiStatus.DigitalAssets))
                    })
                }
                else
                {
                    self.showToast(toastText: self.getErrorMessageForStatus(statusCode: status, dataName: apiStatus.DigitalAssets))
                }
                WebServiceHelper.sharedInstance.syncMasterDataDownloadDetails(postData: self.getPostData(sectionName: apiStatus.DigitalAssets), completion: { (apiObj) in
                })
            }
            else
            {
                self.showToast(toastText: self.getErrorMessageForStatus(statusCode: status, dataName: apiStatus.DigitalAssets))
            }
        })
    }
    
    func downloadMarketContentData()
    {
        showCustomActivityIndicatorView(loadingText: "Downloading \(apiStatus.MarketContent)...")
        
        BL_MasterDataDownload.sharedInstance.getStoryData(masterDataGroupName: masterDataGroupName.MarketContent.rawValue, completion: { (status) in
            if(status == SERVER_SUCCESS_CODE)
            {
                WebServiceHelper.sharedInstance.syncMasterDataDownloadDetails(postData: self.getPostData(sectionName: apiStatus.MarketContent), completion: { (apiObj) in
                    self.showToast(toastText: self.getErrorMessageForStatus(statusCode: status, dataName: apiStatus.MarketContent))
                })
            }
           // self.showToast(toastText: self.getErrorMessageForStatus(statusCode: status, dataName: apiStatus.MarketContent))
        })
    }
    
    func getErrorMessageForStatus(statusCode: Int, dataName: String) -> String
    {
        removeCustomActivityView()
        if (statusCode == SERVER_SUCCESS_CODE)
        {
            self.reloadTableView()
            return "\(dataName) downloaded"
        }
        else if (statusCode == SERVER_ERROR_CODE)
        {
            return "Server error while downloading \(dataName) data. Please try again"
        }
        else if (statusCode == NO_INTERNET_ERROR_CODE)
        {
            return "Internet connection error. Please try again"
        }
        else if (statusCode == LOCAL_ERROR_CODE)
        {
            return "Unable to process \(dataName) data. Please try again"
        }
        else
        {
            return ""
        }
    }
    
    
    func showToast(toastText: String)
    {
        showToastView(toastText: toastText)
    }
    
    func reloadTableView()
    {
        lastSyncDateTimeList = BL_MasterDataDownload.sharedInstance.masterDataDownloadTime()
        
        self.tableView.reloadData()
    }
    
    private func getLastSyncDataTime(groupName: String) -> String
    {
        var lastSyncTime: String = ""
        
        if (lastSyncDateTimeList != nil && lastSyncDateTimeList!.count > 0)
        {
            var filteredArray = lastSyncDateTimeList!.filter{
                $0.Master_Data_Group_Name == groupName
            }
            
            var syncDate: Date!
            
            if (filteredArray.count > 0)
            {
                syncDate = filteredArray[0].Download_Date
            }
            else
            {
                filteredArray = lastSyncDateTimeList!.filter{
                    $0.Master_Data_Group_Name == masterDataGroupName.prepareMyDevice.rawValue
                }
                
                if (filteredArray.count > 0)
                {
                    syncDate = filteredArray[0].Download_Date
                }
                else
                {
                    syncDate = getCurrentDateAndTime()
                }
            }
            
            let date = convertDateIntoLocalDateString(date: syncDate)
            let time = stringFromDate(date1: syncDate)
            lastSyncTime = "\(date) \(time)"
        }
        
        return lastSyncTime
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
    
    func autoDownloadAllMasterData()
    {
        if self.autoDownloadMasterData == true
        {
            self.downloadAllMasterData()
            self.reloadTableView()
        }
    }
}

