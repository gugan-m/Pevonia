//
//  BL_Version_Upgrade.swift
//  HiDoctorApp
//
//  Created by SwaaS on 21/04/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class BL_Version_Upgrade: NSObject
{
    static let sharedInstance = BL_Version_Upgrade()
    
    func insertVersionUpgradeInfo(versionNumber: String, isVersionUpdateCompleted: Int)
    {
        let dict: NSDictionary = ["Version_Number": versionNumber, "Is_Version_Update_Completed": isVersionUpdateCompleted]
        let objVersionUpgrde: VersionUpgradeModel = VersionUpgradeModel(dict: dict)
        
        DBHelper.sharedInstance.insertVersionUpgradeInfo(objVersionUpgradeModel: objVersionUpgrde)
    }
    
    func updateAllVersionUpgradeAsCompleted()
    {
        DBHelper.sharedInstance.updateAllVersionUpgrade(status: 1)
    }
    
    func getIncompleteVersionUpgrades() -> [VersionUpgradeModel]
    {
        return DBHelper.sharedInstance.getIncompleteVersionUpgrades()
    }
    
    func doVersionUpgradeForV2(versionNumber: String, completion: @escaping (Int) -> ())
    {
        BL_PrepareMyDevice.sharedInstance.getDCRCustomerFollowUpDetails(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                BL_PrepareMyDevice.sharedInstance.getDCRAttachmentDetails(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
                    if status == SERVER_SUCCESS_CODE
                    {
                        BL_PrepareMyDevice.sharedInstance.getExpenseGroupMapping(masterDataGroupName: "", completion: { (status) in
                            if status == SERVER_SUCCESS_CODE
                            {
                                
                                self.updateVersionUpgradeCompleted(versionNumber: versionNumber)
                                
                                
                            }
                            completion(status)
                        })
                    }
                    else
                    {
                        completion(status)
                    }
                }
            }
            else
            {
                completion(status)
            }
        }
    }
    
    func doVersionUpgradeForV3(versionNumber: String, completion: @escaping (Int) -> ())
    {
        getCompanyDetails() { (status) in
            if status == SERVER_SUCCESS_CODE
            {
                self.getAssetData(versionNumber: versionNumber) { (status) in
                    completion(status)
                }
            }
            else
            {
                completion(status)
            }
        }
    }
    
    func doVersionUpgradeForV4(versionNumber: String, completion: @escaping (Int) -> ())
    {
        getStoryData(versionNumber: versionNumber) { (status) in
            completion(status)
        }
    }
    
    func doVersionUpgradeForTPVersion(versionNumber: String, completion: @escaping (Int) -> ())
    {
        BL_TPRefresh.sharedInstance.downloadTpData(startDate: EMPTY, endDate: EMPTY) { (status) in
            if (status == SERVER_SUCCESS_CODE)
            {
                BL_MasterDataDownload.sharedInstance.downloadCustomerData(masterDataGroupName: EMPTY, completion: { (status) in
                    completion(status)
                })
            }
            else
            {
                completion(status)
            }
        }
    }
    
    func doVersionUpgradeForFDCPilotVersion(versionNumber: String, completion: @escaping (Int) -> ())
    {
        BL_PrepareMyDevice.sharedInstance.getUserPrivileges(masterDataGroupName: EMPTY, completion: { (status) in
            if (status == SERVER_SUCCESS_CODE)
            {
                BL_PrepareMyDevice.sharedInstance.getCompanyConfigSettings(masterDataGroupName: EMPTY, completion: { (status) in
                    if (status == SERVER_SUCCESS_CODE)
                    {
                        BL_PrepareMyDevice.sharedInstance.getAssetProductMapping(masterDataGroupName: EMPTY, completion: { (status) in
                            if (status == SERVER_SUCCESS_CODE)
                            {
                                BL_PrepareMyDevice.sharedInstance.getDoctorProductMapping(masterDataGroupName: EMPTY, selectedRegionCode: EMPTY, completion: { (status) in
                                    
                                    completion(status)
                                })
                            }
                            else
                            {
                                completion(status)
                            }
                        })
                    }
                    else
                    {
                        completion(status)
                    }
                })
            }
            else
            {
                completion(status)
            }
        })
    }
    
    func doVersionUpgradeForChemistDayVersion(versionNumber: String, completion: @escaping (Int) -> ())
    {
        BL_MasterDataDownload.sharedInstance.downloadSystemSettings(masterDataGroupName: EMPTY) { (status) in
            if (status == SERVER_SUCCESS_CODE)
            {
                BL_PrepareMyDevice.sharedInstance.getDetailProdcutMaster(masterDataGroupName: EMPTY, completion: { (status) in
                    if status == SERVER_SUCCESS_CODE
                    {
                        BL_PrepareMyDevice.sharedInstance.getUserTypeMenuAccess(masterDataGroupName: EMPTY) { (status) in
                            if status == SERVER_SUCCESS_CODE
                            {
                                self.updateVersionUpgradeCompleted(versionNumber: versionNumber)
                            }
                            completion(status)
                        }
                    }
                    else
                    {
                        completion(status)
                    }
                })
            }
            else
            {
                completion(status)
            }
        }
    }
    
    func doVersionUpgradeForAlertBuildVersion(versionNumber: String, completion: @escaping (Int) -> ())
    {
        //completion(1)
        DBHelper.sharedInstance.updateDCRFreezeForAll()
        DBHelper.sharedInstance.updateIsTPSFCForAll()
        BL_MasterDataDownload.sharedInstance.downloadSystemSettings(masterDataGroupName: EMPTY) { (status) in
            if (status == SERVER_SUCCESS_CODE)
            {
                BL_PrepareMyDevice.sharedInstance.getDoctorProductMapping(masterDataGroupName: EMPTY, selectedRegionCode: EMPTY, completion: { (status) in
                    if status == SERVER_SUCCESS_CODE
                    {
                        BL_PrepareMyDevice.sharedInstance.getMCDoctorProductMapping(masterDataGroupName: EMPTY, selectedRegionCode: EMPTY) { (status) in
                            if status == SERVER_SUCCESS_CODE
                            {
                                self.updateVersionUpgradeCompleted(versionNumber: versionNumber)
                            }
                            completion(status)
                        }
                    }
                    else
                    {
                        completion(status)
                    }
                })
            }
            else
            {
                completion(status)
            }
        }
    }
    
    func versionUpgradeForPasswordPolicyBuild(versionNumber: String, completion: @escaping (Int) -> ())
    {
        BL_MasterDataDownload.sharedInstance.downloadSystemSettings(masterDataGroupName: EMPTY) { (status) in
            if (status == SERVER_SUCCESS_CODE)
            {
                BL_Password.sharedInstance.getUserAccountDetailsForVersionUpgrader { (status) in
                    if status == SERVER_SUCCESS_CODE
                    {
                        
                        self.updateVersionUpgradeCompleted(versionNumber: versionNumber)
                    }
                    completion(status)
                }
            }
        }
    }
    
    func versionUpgradeForDoctorPOBBuild(versionNumber: String, viewController: UIViewController, completion: @escaping (Int) -> ())
    {
        BL_MenuAccess.sharedInstance.getCheckUserExist(viewController: viewController) { (objApiResponse) in
            if (objApiResponse.list.count > 0)
            {
                BL_MasterDataDownload.sharedInstance.downloadSystemSettings(masterDataGroupName: EMPTY) { (status) in
                    if (status == SERVER_SUCCESS_CODE)
                    {
                        BL_Password.sharedInstance.getUserRegionTypeAccountDetailsForVersionUpgrade{ (status) in
                            if (status == SERVER_SUCCESS_CODE)
                            {
                                BL_PrepareMyDevice.sharedInstance.getUserTypeMenuAccess(masterDataGroupName: EMPTY, completion: { (status) in
                                    if status == SERVER_SUCCESS_CODE
                                    {
                                        BL_MasterDataDownload.sharedInstance.downloadCustomerData(masterDataGroupName: EMPTY, completion: { (status) in
                                            if status == SERVER_SUCCESS_CODE
                                            {
                                                DBHelper.sharedInstance.updateValueForNewColumnsInPOBBuild()
                                                self.updateVersionUpgradeCompleted(versionNumber: versionNumber)
                                            }
                                            completion(status)
                                        })
                                    }
                                    else
                                    {
                                        completion(status)
                                    }
                                })
                            }
                            else
                            {
                                completion(status)
                            }
                        }
                    }
                    else
                    {
                        completion(status)
                    }
                }
            }
            else
            {
                completion(SERVER_ERROR_CODE)
            }
        }
    }
    
    func versionUpgradeForInheritanceBuild(versionNumber: String, viewController: UIViewController, completion: @escaping (Int) -> ())
    {
        BL_MenuAccess.sharedInstance.getCheckUserExist(viewController: viewController) { (objApiResponse) in
            if (objApiResponse.list.count > 0)
            {
                BL_MasterDataDownload.sharedInstance.downloadSystemSettings(masterDataGroupName: EMPTY) { (status) in
                    if (status == SERVER_SUCCESS_CODE)
                    {
                        BL_PrepareMyDevice.sharedInstance.getAccompanists(masterDataGroupName: EMPTY, completion: { (status) in
                            if (status == SERVER_SUCCESS_CODE)
                            {
                                DBHelper.sharedInstance.updateValueForNewColumnsInInheritanceBuild()
                                self.updateVersionUpgradeCompleted(versionNumber: versionNumber)
                                completion(status)
                            }
                            else
                            {
                                completion(status)
                            }
                        })
                    }
                    else
                    {
                        completion(status)
                    }
                }
            }
            else
            {
                completion(SERVER_ERROR_CODE)
            }
        }
    }
    
    func versionUpgradeForICEBuild(versionNumber: String, viewController: UIViewController, completion: @escaping (Int) -> ())
    {
        BL_MenuAccess.sharedInstance.getCheckUserExist(viewController: viewController) { (objApiResponse) in
            if (objApiResponse.list.count > 0)
            {
                BL_MasterDataDownload.sharedInstance.downloadSystemSettings(masterDataGroupName: EMPTY) { (status) in
                    if (status == SERVER_SUCCESS_CODE)
                    {
                        BL_MasterDataDownload.sharedInstance.getDigitalAssetsData(masterDataGroupName: EMPTY, completion: { (status) in
                            if (status == SERVER_SUCCESS_CODE)
                            {
                                if BL_DCR_Doctor_Visit.sharedInstance.getStoryEnabledPrivVal().lowercased() == PrivilegeValues.YES.rawValue.lowercased()
                                {
                                    BL_MasterDataDownload.sharedInstance.getStoryData(masterDataGroupName: EMPTY, completion: { (status) in
                                        if(status == 1)
                                        {
                                            BL_PrepareMyDevice.sharedInstance.getAllCompetitorProducts(completion: { (status) in
                                                if status == SERVER_SUCCESS_CODE
                                                {
                                                    BL_PrepareMyDevice.sharedInstance.getAllProductsCompetitor(completion: { (status) in
                                                        if status == SERVER_SUCCESS_CODE
                                                        {
                                                            self.getUserDetails(completion: { (status) in
                                                                if(status == 1)
                                                                {
                                                                    BL_DCR_Refresh.sharedInstance.getDCRCompetitorDetailsInPrepare (completion: { (status) in
                                                                        if(status == 1)
                                                                        {
                                                                            BL_DCR_Refresh.sharedInstance.getDCRAttendanceSampleDetailsInPrepare(completion: { (status) in
                                                                                if(status == SERVER_SUCCESS_CODE)
                                                                                {
                                                                                    self.updateVersionUpgradeCompleted(versionNumber: versionNumber)
                                                                                    completion(status)
                                                                                }
                                                                                else
                                                                                {
                                                                                    completion(SERVER_ERROR_CODE)
                                                                                }
                                                                                
                                                                            })
                                                                        }
                                                                        else
                                                                        {
                                                                            completion(SERVER_ERROR_CODE)
                                                                        }
                                                                    })
                                                                }
                                                                else
                                                                {
                                                                    completion(SERVER_ERROR_CODE)
                                                                }
                                                            })
                                                        }
                                                        else
                                                        {
                                                            completion(SERVER_ERROR_CODE)
                                                        }
                                                    })
                                                    
                                                    
                                                }
                                                else
                                                {
                                                    completion(SERVER_ERROR_CODE)
                                                }
                                                
                                            })
                                        }
                                    })
                                }
                            }
                            else
                            {
                                completion(SERVER_ERROR_CODE)
                            }
                        })
                    }
                    else
                    {
                        completion(status)
                    }
                }
            }
            else
            {
                completion(SERVER_ERROR_CODE)
            }
        }
    }
    
    func versionUpgradeForHourlyReportChanges(versionNumber: String, viewController: UIViewController, completion: @escaping (Int) -> ())
    {
        BL_MenuAccess.sharedInstance.getCheckUserExist(viewController: viewController) { (objApiResponse) in
            if (objApiResponse.list.count > 0)
            {
                BL_MasterDataDownload.sharedInstance.downloadSystemSettings(masterDataGroupName: EMPTY) { (status) in
                    if (status == SERVER_SUCCESS_CODE)
                    {
                        BL_PrepareMyDevice.sharedInstance.getUserProductMapping(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue, completion: { (status) in
                            if(status == 1)
                            {
                                self.getUserDetails(completion: { (status) in
                                    if(status == 1)
                                    {
                                        self.updateVersionUpgradeCompleted(versionNumber: versionNumber)
                                        completion(status)
                                    }
                                    else
                                    {
                                        completion(SERVER_ERROR_CODE)
                                    }
                                })
                            }
                            else
                            {
                                completion(SERVER_ERROR_CODE)
                            }
                        })
                    }
                    else
                    {
                        completion(SERVER_ERROR_CODE)
                    }
                }
                
            }
            else
            {
                completion(SERVER_ERROR_CODE)
            }
            
        }
        
    }
    
    func versionUpgradeForSampleBatchChanges(versionNumber: String, viewController: UIViewController, completion: @escaping (Int) -> ())
    {
        BL_MenuAccess.sharedInstance.getCheckUserExist(viewController: viewController) { (objApiResponse) in
            if (objApiResponse.list.count > 0)
            {
                BL_MasterDataDownload.sharedInstance.downloadSystemSettings(masterDataGroupName: EMPTY) { (status) in
                    if (status == SERVER_SUCCESS_CODE)
                    {
                        BL_PrepareMyDevice.sharedInstance.getUserProductMapping(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue, completion: { (status) in
                            if(status == 1)
                            {
                                self.getUserDetails(completion: { (status) in
                                    if(status == 1)
                                    {
                                        self.updateVersionUpgradeCompleted(versionNumber: versionNumber)
                                        completion(status)
                                    }
                                    else
                                    {
                                        completion(SERVER_ERROR_CODE)
                                    }
                                })
                            }
                            else
                            {
                                completion(SERVER_ERROR_CODE)
                            }
                        })
                    }
                    else
                    {
                        completion(SERVER_ERROR_CODE)
                    }
                }
                
            }
            else
            {
                completion(SERVER_ERROR_CODE)
            }
            
        }
        
    }
    
    func versionUpgradeForInwardBatchChanges(versionNumber: String, viewController: UIViewController, completion: @escaping (Int) -> ())
    {
        BL_MenuAccess.sharedInstance.getCheckUserExist(viewController: viewController) { (objApiResponse) in
            if (objApiResponse.list.count > 0)
            {
                BL_MasterDataDownload.sharedInstance.downloadSystemSettings(masterDataGroupName: EMPTY) { (status) in
                    if (status == SERVER_SUCCESS_CODE)
                    {
                        
                        self.getUserDetails(completion: { (status) in
                            if(status == 1)
                            {
                                self.updateVersionUpgradeCompleted(versionNumber: versionNumber)
                                completion(status)
                            }
                            else
                            {
                                completion(SERVER_ERROR_CODE)
                            }
                        })
                    }
                    else
                    {
                        completion(SERVER_ERROR_CODE)
                    }
                }
            }
            else
            {
                completion(SERVER_ERROR_CODE)
            }
        }
        
    }
    
    func versionUpgradeForAttendanceActivityChanges(versionNumber: String, viewController: UIViewController, completion: @escaping (Int) -> ())
    {
        BL_MenuAccess.sharedInstance.getCheckUserExist(viewController: viewController) { (objApiResponse) in
            if (objApiResponse.list.count > 0)
            {
                //   let userDict:NSDictionary = objApiResponse.list.firstObject as! NSDictionary
                //                    DBHelper.sharedInstance.insertUserDetails(dict: userDict)
                //                    navigateToNextScreen()
                
                BL_MasterDataDownload.sharedInstance.downloadSystemSettings(masterDataGroupName: EMPTY) { (status) in
                    if (status == SERVER_SUCCESS_CODE)
                    {
                        
                        self.getUserDetails(completion: { (status) in
                            if(status == 1)
                            {
                                self.updateVersionUpgradeCompleted(versionNumber: versionNumber)
                                completion(status)
                            }
                            else
                            {
                                completion(SERVER_ERROR_CODE)
                            }
                        })
                    }
                    else
                    {
                        completion(SERVER_ERROR_CODE)
                    }
                }
            }
            else
            {
                completion(SERVER_ERROR_CODE)
            }
        }
        
    }
    
    func versionUpgradeForAccompanistChanges(versionNumber: String, viewController: UIViewController, completion: @escaping (Int) -> ())
    {
        BL_MenuAccess.sharedInstance.getCheckUserExist(viewController: viewController) { (objApiResponse) in
            if (objApiResponse.list.count > 0)
            {
                BL_MasterDataDownload.sharedInstance.downloadSystemSettings(masterDataGroupName: EMPTY) { (status) in
                    if (status == SERVER_SUCCESS_CODE)
                    {
                        let accompanistList = DBHelper.sharedInstance.getAllListOfDCRAccompanist()
                        let userList = DBHelper.sharedInstance.getAccompanistMaster()
                        
                        for obj in accompanistList ?? []
                        {
                            let filteredArray = userList.filter{
                                $0.User_Code == obj.Acc_User_Code && $0.Region_Code == obj.Acc_Region_Code
                            }
                            
                            if filteredArray.count > 0
                            {
                                DBHelper.sharedInstance.updateDCRAccompanistByDCRId(dcrId: obj.DCR_Id, dcrModifyAccompanitsObj: obj, employeeName: filteredArray.first?.Employee_name ?? EMPTY)
                            }
                        }
                        
                        self.getUserDetails(completion: { (status) in
                            if(status == 1)
                            {
                                self.updateVersionUpgradeCompleted(versionNumber: versionNumber)
                                completion(status)
                            }
                            else
                            {
                                completion(SERVER_ERROR_CODE)
                            }
                        })
                    }
                    else
                    {
                        completion(SERVER_ERROR_CODE)
                    }
                }
            }
        }
        
    }
    
    func versionUpgradeForMCInDoctorVistSection(versionNumber: String, viewController: UIViewController, completion: @escaping (Int) -> ())
    {
        BL_MenuAccess.sharedInstance.getCheckUserExist(viewController: viewController) { (objApiResponse) in
            if (objApiResponse.list.count > 0)
            {
                BL_MasterDataDownload.sharedInstance.downloadSystemSettings(masterDataGroupName: EMPTY) { (status) in
                    if (status == SERVER_SUCCESS_CODE)
                    {
                        BL_PrepareMyDevice.sharedInstance.getDetailProdcutMaster(masterDataGroupName: EMPTY, completion: { (status) in
                            if status == SERVER_SUCCESS_CODE
                            {
                                BL_PrepareMyDevice.sharedInstance.getDoctorProductMapping(masterDataGroupName: EMPTY, selectedRegionCode: EMPTY, completion: { (status) in
                                    
                                    if status == 1
                                    {
                                        BL_PrepareMyDevice.sharedInstance.getAllMCDetails(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) {(status) in
                                            
                                            if status == 1
                                            {
                                                self.getUserDetails(completion: { (status) in
                                                    if(status == 1)
                                                    {
                                                        self.updateVersionUpgradeCompleted(versionNumber: versionNumber)
                                                        completion(status)
                                                    }
                                                    else
                                                    {
                                                        completion(SERVER_ERROR_CODE)
                                                    }
                                                })
                                            }
                                            else
                                            {
                                                completion(SERVER_ERROR_CODE)
                                            }
                                        }
                                    }
                                    else
                                    {
                                        completion(SERVER_ERROR_CODE)
                                    }
                                })
                            }
                            else
                            {
                                completion(SERVER_ERROR_CODE)
                            }
                        })
                    }
                    else
                    {
                        completion(SERVER_ERROR_CODE)
                    }
                }
            }
        }
        
    }
    
    
    private func getCompanyDetails(completion: @escaping (Int) -> ())
    {
        WebServiceHelper.sharedInstance.getCompanyDetails(companyName: getCompanyName()) { (apiResponseObj) in
            if apiResponseObj.Status == SERVER_SUCCESS_CODE
            {
                if apiResponseObj.Count > 0 && apiResponseObj.list.count > 0
                {
                    if let companyDict = apiResponseObj.list.firstObject as? NSDictionary
                    {
                        DBHelper.sharedInstance.deleteFromTable(tableName: "\(MST_COMP_DETAILS)")
                        DBHelper.sharedInstance.insertCompanyDetails(dict: companyDict)
                        
                        self.getUserDetails() { (status) in
                            if status == SERVER_SUCCESS_CODE
                            {
                                BL_PrepareMyDevice.sharedInstance.getUserPrivileges(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
                                    if status == SERVER_SUCCESS_CODE
                                    {
                                        BL_PrepareMyDevice.sharedInstance.getCompanyConfigSettings(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
                                            completion(status)
                                        }
                                    }
                                    else
                                    {
                                        completion(status)
                                    }
                                }
                            }
                            else
                            {
                                completion(status)
                            }
                        }
                    }
                    else
                    {
                        completion(0)
                    }
                }
                else
                {
                    completion(0)
                }
            }
            else
            {
                completion(apiResponseObj.Status)
            }
        }
    }
    
    private func getUserDetails(completion: @escaping (Int) -> ())
    {
        WebServiceHelper.sharedInstance.postUserDetails(companyCode: getCompanyCode(), userName: getUserName(), password: getUserPassword(),isVersionCode:true) { (apiResponseObj) in
            if apiResponseObj.Status == SERVER_SUCCESS_CODE
            {
                if apiResponseObj.Count > 0 && apiResponseObj.list.count > 0
                {
                    if let userDict = apiResponseObj.list.firstObject as? NSDictionary
                    {
                        let dict = ["Employee_Number":userDict.value(forKey: "Employee_Number"),"Division_Name":userDict.value(forKey: "Division_Name"),"Email_Id":userDict.value(forKey: "Email_Id")]
                        UserDefaults.standard.set(dict, forKey: kennectUserDetails)
                        
                        DBHelper.sharedInstance.deleteFromTable(tableName: "\(MST_USER_DETAILS)")
                        DBHelper.sharedInstance.insertUserDetails(dict: userDict)
                        
                        completion(apiResponseObj.Status)
                    }
                    else
                    {
                        completion(0)
                    }
                }
                else
                {
                    completion(0)
                }
            }
            else
            {
                completion(apiResponseObj.Status)
            }
        }
    }
    
    private func getAssetData(versionNumber: String,completion: @escaping (Int) -> ())
    {
        BL_PrepareMyDevice.sharedInstance.getAssetHeaderDetails(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            
            if status == SERVER_SUCCESS_CODE
            {
                BL_PrepareMyDevice.sharedInstance.getAssetTagDetails(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
                    
                    if status == SERVER_SUCCESS_CODE
                    {
                        BL_PrepareMyDevice.sharedInstance.getAssetAnalyticsDetails(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
                            if status == SERVER_SUCCESS_CODE
                            {
                                self.updateVersionUpgradeCompleted(versionNumber: versionNumber)
                                completion(status)
                            }
                            else
                            {
                                completion(status)
                            }
                        }
                        
                    }
                    else
                    {
                        completion(status)
                    }
                }
            }
            else
            {
                completion(status)
            }
        }
    }
    
    private func getStoryData(versionNumber: String, completion: @escaping (Int) -> ())
    {
        BL_PrepareMyDevice.sharedInstance.getStoryDetails(masterDataGroupName: masterDataGroupName.prepareMyDevice.rawValue) { (status) in
            
            if status == SERVER_SUCCESS_CODE
            {
                self.updateVersionUpgradeCompleted(versionNumber: versionNumber)
                completion(status)
            }
            else
            {
                completion(status)
            }
        }
    }
    
    private func updateVersionUpgradeCompleted(versionNumber: String)
    {
        DBHelper.sharedInstance.updateVersionUpgradeStatusForVersionNumber(status: 1, versionNumber: versionNumber)
        BL_PrepareMyDevice.sharedInstance.getbussinessStatusPotential()
        BL_InitialSetup.sharedInstance.doInitialSetUp()
    }
}
