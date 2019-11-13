//
//  BL_AssetModel.swift
//  HiDoctorApp
//
//  Created by swaasuser on 18/05/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class BL_AssetModel: NSObject
{
    var showList : [ShowListModel] = []
    var assetList : [AssetHeader] = []
    var thumbailImage : [String : UIImage] = [:]
    var detailedCustomerId : Int = 0
    var isForDigitalAssets = false
    var isfromDcrPunchIn = false
    var punchout = ""
    var punchin = ""
    var punchutc = ""
    var punchstatus = 2
    var selected_CustomersForEdetailing: [CustomerMasterModel] = []
    
    static let sharedInstance : BL_AssetModel =
    {
        let instance = BL_AssetModel()
        instance.setShowList()
        return instance
    }()
    
    func refreshShowList()
    {
        self.showList.removeAll()
        self.showList =  getCustomerShowList()
    }
    
    func setShowList()
    {
        self.showList = getCustomerShowList()
    }
    
    func getWrapperAssetList(list : [AssetHeader]) -> [AssetsWrapperModel]
    {
        var assetsWrapperList : [AssetsWrapperModel] = []
        var assetTagArray : [String] = []
        
        for obj in list
        {
            var tagValue = checkNullAndNilValueForString(stringData: (obj.tagValue))
            if tagValue == EMPTY
            {
                tagValue = NOT_ASSIGNED
            }
            if !assetTagArray.contains(tagValue)
            {
                assetTagArray.append(tagValue)
            }
        }
        
        for tag in assetTagArray
        {
            let wrapperObj : AssetsWrapperModel = AssetsWrapperModel()
            
            let filterArray = list.filter{
                var tagValue = checkNullAndNilValueForString(stringData: ($0.tagValue))
                if tagValue == EMPTY
                {
                    tagValue = NOT_ASSIGNED
                }
                return checkNullAndNilValueForString(stringData:tagValue) == tag
            }
            
            if filterArray.count > 0
            {
                wrapperObj.assetTag = tag
                wrapperObj.assetList = filterArray
                assetsWrapperList.append(wrapperObj)
            }
        }
        return assetsWrapperList
    }
    
    func getAssetList(isFromDigitalAssets: Bool, customerCode: String, regionCode: String) -> [AssetHeader]
    {
        let assetList = DBHelper.sharedInstance.getMasterAssetList()
        var resultList: [AssetHeader] = []
        
        if (!isFromDigitalAssets)
        {
            let showList = DBHelper.sharedInstance.getAssetShowList()
            let assetTags: [AssetTag] = DBHelper.sharedInstance.getAssetsTags()
            let customerObj = DBHelper.sharedInstance.getCustomerByCustomerCode(customerCode: customerCode, regionCode: regionCode)
            let targetAssets = DBHelper.sharedInstance.getAssetsMappedToTargets(doctorCode: customerCode, regionCode: regionCode)
            let doctorProductAssets = DBHelper.sharedInstance.getAssetsMappedToDoctors(doctorCode: customerCode, regionCode: regionCode)
            var categoryCode: String = EMPTY
            var specialtyCode: String = EMPTY
            
            if (customerObj != nil)
            {
                categoryCode = checkNullAndNilValueForString(stringData: customerObj?.Category_Code)
                specialtyCode = checkNullAndNilValueForString(stringData: customerObj?.Speciality_Code)
            }
            
            if (assetList.count > 0)
            {
                // Add Target product assets in the array
                for objAsset in targetAssets
                {
                    if (!isAssetAddedInShowList(showList: showList, daCode: objAsset.DA_Code))
                    {
                        if (!isAssetAddedInResultList(showList: resultList, daCode: objAsset.DA_Code))
                        {
                            if (isCategoryAndSpltyCheckRequired(assetTags: assetTags, daCode: objAsset.DA_Code, categoryCode: categoryCode, specialtyCode: specialtyCode))
                            {
                                let filteredArray = assetList.filter{
                                    $0.daCode == objAsset.DA_Code
                                }
                                
                                if (filteredArray.count > 0)
                                {
                                    resultList.append(filteredArray.first!)
                                }
                            }
                        }
                    }
                }
                
                // Add Doctor product assets in the array
                for objAsset in doctorProductAssets
                {
                    if (!isAssetAddedInShowList(showList: showList, daCode: objAsset.DA_Code))
                    {
                        if (!isAssetAddedInResultList(showList: resultList, daCode: objAsset.DA_Code))
                        {
                            if (isCategoryAndSpltyCheckRequired(assetTags: assetTags, daCode: objAsset.DA_Code, categoryCode: categoryCode, specialtyCode: specialtyCode))
                            {
                                let filteredArray = assetList.filter{
                                    $0.daCode == objAsset.DA_Code
                                }
                                
                                if (filteredArray.count > 0)
                                {
                                    resultList.append(filteredArray.first!)
                                }
                            }
                        }
                    }
                }
                
                // Add rest of the assets in the array
                for objAsset in assetList
                {
                    if (!isAssetAddedInShowList(showList: showList, daCode: objAsset.daCode))
                    {
                        if (!isAssetAddedInResultList(showList: resultList, daCode: objAsset.daCode))
                        {
                            if (isCategoryAndSpltyCheckRequired(assetTags: assetTags, daCode: objAsset.daCode, categoryCode: categoryCode, specialtyCode: specialtyCode))
                            {
                                resultList.append(objAsset)
                            }
                        }
                    }
                }
            }
        }
        else
        {
            resultList = assetList
        }
        
        return resultList
    }
    
    private func isAssetAddedInShowList(showList: [AssetShowList], daCode: Int) -> Bool
    {
        let filteredArray = showList.filter{
            $0.daCode == daCode && $0.storyId == -1
        }
        
        if (filteredArray.count == 0)
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    private func isAssetAddedInResultList(showList: [AssetHeader], daCode: Int) -> Bool
    {
        let filteredArray = showList.filter{
            $0.daCode == daCode
        }
        
        if (filteredArray.count == 0)
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    private func isCategoryAndSpltyCheckRequired(assetTags: [AssetTag], daCode: Int, categoryCode: String, specialtyCode: String) -> Bool
    {
        let isSpltyTagged = isAssetTagged(assetTags: assetTags, daCode: daCode, tagType: Constants.Asset_Tag_Codes.SPECIALTY)
        let isCategoryTagged = isAssetTagged(assetTags: assetTags, daCode: daCode, tagType: Constants.Asset_Tag_Codes.CATEGORY)
        var addAsset: Bool = true
        
        if (isSpltyTagged)
        {
            addAsset = isAssetTaggedForValue(assetTags: assetTags, daCode: daCode, tagType: Constants.Asset_Tag_Codes.SPECIALTY, tagValue: specialtyCode)
        }
        
        if (addAsset)
        {
            if (isCategoryTagged)
            {
                addAsset = isAssetTaggedForValue(assetTags: assetTags, daCode: daCode, tagType: Constants.Asset_Tag_Codes.CATEGORY, tagValue: categoryCode)
            }
        }
        
        return addAsset
    }
    
    private func isAssetTagged(assetTags: [AssetTag], daCode: Int, tagType: String) -> Bool
    {
        let filteredArray = assetTags.filter{
            $0.daCode == daCode && $0.tagCode == tagType
        }
        
        if (filteredArray.count > 0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    private func isAssetTaggedForValue(assetTags: [AssetTag], daCode: Int, tagType: String, tagValue: String) -> Bool
    {
        let filteredArray = assetTags.filter{
            $0.daCode == daCode && $0.tagCode == tagType && $0.tagValue == tagValue
        }
        
        if (filteredArray.count > 0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    private func isAssetTaggedInSpecialtyAndCategory(assetTags: [AssetTag], daCode: Int, categoryCode: String, specialtyCode: String) -> Bool
    {
        var isTagged: Bool = false
        
        let spltyFilter = assetTags.filter{
            $0.daCode == daCode && $0.tagCode == Constants.Asset_Tag_Codes.SPECIALTY && $0.tagValue == specialtyCode
        }
        
        if (spltyFilter.count > 0) // Doctor specialty is mapped for this asset
        {
            let categoryFilter = assetTags.filter{
                $0.daCode == daCode && $0.tagCode == Constants.Asset_Tag_Codes.CATEGORY && $0.tagValue == categoryCode
            }
            
            if (categoryFilter.count > 0) // Doctor category is mapped for this asset
            {
                isTagged = true
            }
        }
        
        return isTagged
    }
    
    func getAssetsMenuList(assetName : String) -> [AssetsMenuModel]
    {
        var assetMenuList : [AssetsMenuModel] = []
        
        var assetObj : AssetsMenuModel = AssetsMenuModel()
        
        assetObj.menuLeftIcon = "icon-Assetinfo"
        assetObj.menuName = assetName
        assetObj.menuRightIcon = "icon-image-thumbnail"
        assetObj.menuId = 0
        assetMenuList.append(assetObj)
        
        assetObj = AssetsMenuModel()
        assetObj.menuLeftIcon = "icon-play"
        assetObj.menuName = "Play"
        assetObj.menuId = 1
        assetObj.menuRightIcon = ""
        assetMenuList.append(assetObj)
        
        assetObj = AssetsMenuModel()
        assetObj.menuLeftIcon = "icon-play"
        assetObj.menuName = "Preview"
        assetObj.menuId = 2
        assetObj.menuRightIcon = ""
        assetMenuList.append(assetObj)
        
        assetObj = AssetsMenuModel()
        assetObj.menuLeftIcon = "icon-list"
        assetObj.menuName = "Add to show list"
        assetObj.menuRightIcon = ""
        assetObj.menuId = 3
        assetMenuList.append(assetObj)
        
        assetObj = AssetsMenuModel()
        assetObj.menuLeftIcon = "icon-download"
        assetObj.menuName = "Available Offline"
        assetObj.menuRightIcon = ""
        assetObj.menuId = 4
        assetMenuList.append(assetObj)
        
        assetObj = AssetsMenuModel()
        assetObj.menuLeftIcon = "icon-Assetinfo"
        assetObj.menuName = "Details"
        assetObj.menuRightIcon = ""
        assetObj.menuId = 5
        assetMenuList.append(assetObj)
        
        assetObj = AssetsMenuModel()
        assetObj.menuLeftIcon = "icon-delete"
        assetObj.menuName = "Remove from Showlist"
        assetObj.menuRightIcon = ""
        assetObj.menuId = 6
        assetMenuList.append(assetObj)
        
        return assetMenuList
    }
    
    func thumbnailImgForVideo(videoUrl : String, additionalDetail : Any, completionHandler: @escaping(_ image: UIImage?,_ url: String, _ additionalDetail : Any ) -> ()  )
    {
        ImageLoader.sharedLoader.createImageFromVideo(videoUrl: videoUrl, additionalDetail: additionalDetail) { (image, url, additionalDetail) in
            completionHandler(image, url, additionalDetail)
        }
    }
    
    func clearList()
    {
        self.assetList = []
    }
    
    func getCustomerShowList() -> [ShowListModel]
    {
        let showList = DBHelper.sharedInstance.getAssetShowList()
        var filteredList = [ShowListModel]()
        var displayIndex = 1
        
        for value in showList
        {
            if value.daCode != -1
            {
                let asset = DBHelper.sharedInstance.getAssetsByDacodeWithOfflineUrl(daCode: value.daCode)
                
                if (asset != nil)
                {
                    // let asset = DBHelper.sharedInstance.getAssetsByDacode(daCode: value.daCode)
                    asset!.displayIndex = displayIndex
                    let showListObj = ShowListModel()
                    showListObj.id = value.id
                    showListObj.assetDetail = asset
                    filteredList.append(showListObj)
                    displayIndex += 1
                }
            }
            else if value.storyId != -1
            {
                if BL_DCR_Doctor_Visit.sharedInstance.getStoryEnabledPrivVal().lowercased() == PrivilegeValues.YES.rawValue.lowercased()
                {
                    let storyobj = DBHelper.sharedInstance.getStoryHeaderByStoryId(storyId: value.storyId)
                    
                    if storyobj.Story_Id != -2
                    {
                        let storyAssetList = DBHelper.sharedInstance.getAssetsByStoryId(storyId: value.storyId)
                        let story = AssetMandatoryListModel()
                        story.storyObj = storyobj
                        story.assetList = storyAssetList
                        
                        let showListObj = ShowListModel()
                        showListObj.id = value.id
                        showListObj.storyId = value.storyId
                        showListObj.storyObj = story
                        showListObj.storyEnabled = true
                        
                        for storyAsset in storyAssetList
                        {
                            storyAsset.displayIndex = displayIndex
                            displayIndex += 1
                        }
                        
                        filteredList.append(showListObj)
                    }
                }
            }
        }
        
        return filteredList
    }
    
    func checkPlayListAvailabiltyForCustomer(storyId : NSNumber, customerCode: String, regionCode: String) -> Bool
    {
        let storyList = getStoryList(customerCode: customerCode, regionCode: regionCode)
        let filteredArray = storyList.filter{
            $0.Story_Id == storyId
        }
        
        if (filteredArray.count > 0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func getStoryList(customerCode: String, regionCode: String) -> [StoryHeader]
    {
        let customerObj = getCustomerObjByCustomerCode()
        
        return DBHelper.sharedInstance.getMasterStoryIdByCustomerDetails(categoryCode: checkNullAndNilValueForString(stringData: customerObj?.Category_Code), specialityCode: checkNullAndNilValueForString(stringData: customerObj?.Speciality_Code))
    }
    
    func getAssetPlayList(assetList : [AssetHeader],isShowList : Bool) -> [AssetsPlayListModel]
    {
        var assetPlayList  : [AssetsPlayListModel] = []
        let assetsPartsList = getAssetsPartList(assetList: assetList, isShowList: isShowList)
        
        for obj in assetList
        {
            let assetObj : AssetsPlayListModel = AssetsPlayListModel()
            
            if getDocTypeVal(docType: obj.docType) == Constants.DocType.zip
            {
                if checkNullAndNilValueForString(stringData: obj.localUrl) != EMPTY
                {
                    assetObj.assetObj = obj
                    let filteredArray = assetsPartsList.filter {
                        $0.daCode == obj.daCode
                    }
                    if filteredArray.count > 0
                    {
                        assetObj.assetPartList = filteredArray
                    }
                    assetPlayList.append(assetObj)
                }
            }
            else
            {
                assetObj.assetObj = obj
                let filteredArray = assetsPartsList.filter {
                    $0.daCode == obj.daCode
                }
                if filteredArray.count > 0
                {
                    assetObj.assetPartList = filteredArray
                }
                assetPlayList.append(assetObj)
            }
        }
        return assetPlayList
    }
    
    func assignAllPlayListToShowList(customerCode: String, regionCode: String)
    {
        // Delete existing records from show list table
        DBHelper.sharedInstance.deleteFromTable(tableName: TBL_CUSTOMER_TEMP_SHOWLIST)
        
        // Insert MC Story
        let playList   = DBHelper.sharedInstance.getMasterStoryList()
        var listCount = DBHelper.sharedInstance.getMaxDisplayOrderForShowList() ?? 1
        var alreadyAddedList: [AssetShowList] = []
        
        for playListObj in playList
        {
            if (checkPlayListAvailabiltyForCustomer(storyId: playListObj.Story_Id, customerCode: customerCode, regionCode: regionCode))
            {
                let dict = NSMutableDictionary()
                dict.setValue( playListObj.Story_Id ,forKey: "Story_Id")
                dict.setValue( -1 ,forKey: "DA_Code")
                dict.setValue( listCount ,forKey: "Display_Order")
                
                let insertObj = AssetShowList(dict: dict)
                alreadyAddedList.append(insertObj)
                
                DBHelper.sharedInstance.insertCustomerShowList1(showListObj: insertObj)
                
                listCount += 1
            }
        }
        
        // Insert Doctor Product mapping assets
        let assetList = DBHelper.sharedInstance.getMasterAssetList()
        let customerCode: String = checkNullAndNilValueForString(stringData: BL_DoctorList.sharedInstance.customerCode)
        let regionCode: String = checkNullAndNilValueForString(stringData: BL_DoctorList.sharedInstance.regionCode)
        let doctorProductAssetsList = DBHelper.sharedInstance.getAssetsMappedToDoctors(doctorCode: customerCode, regionCode: regionCode)
        let assetTags: [AssetTag] = DBHelper.sharedInstance.getAssetsTags()
        let customerObj = DBHelper.sharedInstance.getCustomerByCustomerCode(customerCode: customerCode, regionCode: regionCode)
        var categoryCode: String = EMPTY
        var specialtyCode: String = EMPTY
        
        if (customerObj != nil)
        {
            categoryCode = checkNullAndNilValueForString(stringData: customerObj?.Category_Code)
            specialtyCode = checkNullAndNilValueForString(stringData: customerObj?.Speciality_Code)
        }
        
        if (doctorProductAssetsList.count > 0)
        {
            for objDrProdAsset in doctorProductAssetsList
            {
                let filteredArray = assetList.filter{
                    $0.daCode == objDrProdAsset.DA_Code
                }
                
                if (filteredArray.count > 0)
                {
                    let duplicateFilter = alreadyAddedList.filter{
                        $0.daCode == objDrProdAsset.DA_Code
                    }
                    
                    if (duplicateFilter.count == 0)
                    {
                        if (isCategoryAndSpltyCheckRequired(assetTags: assetTags, daCode: objDrProdAsset.DA_Code, categoryCode: categoryCode, specialtyCode: specialtyCode))
                        {
                            let dict = NSMutableDictionary()
                            dict.setValue(-1, forKey: "Story_Id")
                            dict.setValue(objDrProdAsset.DA_Code, forKey: "DA_Code")
                            dict.setValue(listCount, forKey: "Display_Order")
                            
                            let insertObj = AssetShowList(dict: dict)
                            alreadyAddedList.append(insertObj)
                            
                            DBHelper.sharedInstance.insertCustomerShowList1(showListObj: insertObj)
                            
                            listCount += 1
                        }
                    }
                }
            }
        }
    }
    
    func updateDownloadStatus(selectedList : [AssetHeader],status : Int)
    {
        for assetObj in selectedList
        {
            if assetObj.isDownloadable != 0
            {
                DBHelper.sharedInstance.updateDownloadStatus(downloadStatus: status, fileName: EMPTY, daCode: assetObj.daCode)
                let assetObjList = DBHelper.sharedInstance.checkDownloadedAssetsForDACode(daCode: assetObj.daCode)
                if assetObjList.count > 0
                {
                    DBHelper.sharedInstance.updateAssetDownloaded(daCode: assetObj.daCode, offlineUrl: "", docType: assetObj.docType, isDownloaded: status)
                }
                else
                {
                    insertDownloadedAsset(daCode: assetObj.daCode, offlineUrl: "", docType: assetObj.docType, isDownloaded: isFileDownloaded.progress.rawValue)
                }
            }
        }
    }
    
    func getAssetByDaCode(daCode : Int) -> AssetHeader
    {
        return DBHelper.sharedInstance.getAssetsByDacode(daCode:daCode)
    }
    
    func getSessionIdByDaCode(daCode : Int)-> Int?
    {
        return DBHelper.sharedInstance.getAssetSessionIdByDaCode(daCode: daCode, customerDetailedId: BL_AssetModel.sharedInstance.detailedCustomerId, customerCode: BL_DoctorList.sharedInstance.customerCode, customeregionCode: BL_DoctorList.sharedInstance.regionCode, detailingDate: getCurrentDate())
    }
    
    func getDownloadStatus(isDownloaded : Int) -> String
    {
        var downloadStatus : String = EMPTY
        
        if isDownloaded == isFileDownloaded.pending.rawValue
        {
            downloadStatus = "Online"
        }
        else if isDownloaded == isFileDownloaded.completed.rawValue
        {
            downloadStatus = "Offline"
        }
        else if isDownloaded == isFileDownloaded.progress.rawValue
        {
            downloadStatus = "InProgress"
        }
        return downloadStatus
    }
    
    func insertAssetAnalytics(analyticsObj : AssetAnalyticsDetail ,customerObj: CustomerMasterModel?) -> Int
    {
        if(BL_MenuAccess.sharedInstance.is_Punch_In_Out_Enabled())
        {
            if (isfromDcrPunchIn)
            {
                var localTimeZoneName: String { return TimeZone.current.identifier }
                analyticsObj.Punch_Start_Time = punchin
                analyticsObj.Punch_Status = 2
                analyticsObj.Punch_UTC_DateTime =  punchutc
                analyticsObj.Punch_TimeZone = localTimeZoneName
                analyticsObj.Punch_Offset = getOffset()
                analyticsObj.Punch_End_Time = punchout
            }
            else
            {
            var localTimeZoneName: String { return TimeZone.current.identifier }
            analyticsObj.Punch_Start_Time = BL_DoctorList.sharedInstance.punchInTime
            analyticsObj.Punch_Status = 1
            analyticsObj.Punch_UTC_DateTime =  getUTCDateForPunch()
            analyticsObj.Punch_TimeZone = localTimeZoneName
            analyticsObj.Punch_Offset = getOffset()
                
                if customerObj != nil {
                    let assets = DBHelper.sharedInstance.getAssestAnalyticsByCustomer(dcrDate: getCurrentDate(), customerCode: customerObj!.Customer_Code, customeRegionCode: customerObj!.Region_Code)
                    
                    //           let assets = DBHelper.sharedInstance.getPunchEndTimeWith(customerCode: customerObj!.Customer_Code, customeRegionCode: customerObj!.Region_Code)
                    if(assets != nil && assets.count > 0 && assets[0].Punch_End_Time != "" && assets[0].Punch_End_Time != nil)
                    {
                        analyticsObj.Punch_End_Time = assets[0].Punch_End_Time
                    }
                }
                
                
                
                
            }
        }
        if customerObj != nil && analyticsObj.Is_Preview != 1
        {
            analyticsObj.Customer_Code = checkNullAndNilValueForString(stringData: customerObj?.Customer_Code)
            analyticsObj.Customer_Name = customerObj?.Customer_Name
            analyticsObj.Customer_Category_Code = checkNullAndNilValueForString(stringData: customerObj?.Category_Code)
            analyticsObj.Customer_Region_Code = checkNullAndNilValueForString(stringData:  customerObj?.Region_Code)
            analyticsObj.Customer_Speciality_Name = checkNullAndNilValueForString(stringData: customerObj?.Speciality_Name)
            analyticsObj.Customer_Speciality_Code = checkNullAndNilValueForString(stringData: customerObj?.Speciality_Code)
            analyticsObj.Customer_Category_Name = checkNullAndNilValueForString(stringData: customerObj?.Category_Name)
            analyticsObj.Local_Area = checkNullAndNilValueForString(stringData: customerObj?.Local_Area)
            analyticsObj.MDL_Number = checkNullAndNilValueForString(stringData: customerObj?.MDL_Number)
         
        }
        
        if analyticsObj.Is_Preview == 1
        {
            analyticsObj.Customer_Detailed_Id = 0
        }
        else
        {
            analyticsObj.Customer_Detailed_Id = self.detailedCustomerId
        }
        
        analyticsObj.Time_Zone = getCurrentTimeZone()
        analyticsObj.Latitude = getLatitude()
        analyticsObj.Longitude = getLongitude()
        
        if (analyticsObj.Is_Preview == 0)
        {
            DBHelper.sharedInstance.deleteDayWiseAssetsDetailed(dcrDate: analyticsObj.Detailed_DateTime, doctorCode: analyticsObj.Customer_Code, regionCode: analyticsObj.Customer_Region_Code, daCode: analyticsObj.DA_Code)
            
            let productList = DBHelper.sharedInstance.getProductsMappedToAssets(daCode: analyticsObj.DA_Code)
            var dayWiseDetailedInsertList: [DayWiseAssestsDetailedModel] = []
            
            if (productList.count > 0)
            {
                for objAssetProductMapping in productList
                {
                    let dict: NSDictionary = ["Customer_Code": analyticsObj.Customer_Code, "Customer_Region_Code": analyticsObj.Customer_Region_Code, "DCR_Actual_Date": analyticsObj.Detailed_DateTime, "DA_Code": analyticsObj.DA_Code, "Product_Code": objAssetProductMapping.Product_Code, "Product_Name": objAssetProductMapping.Product_Name!, "Active_Status": 1]
                    let obj = DayWiseAssestsDetailedModel(dict: dict)
                    
                    dayWiseDetailedInsertList.append(obj)
                }
                
                if (dayWiseDetailedInsertList.count > 0)
                {
                    DBHelper.sharedInstance.insertDayWiseDetailedProducts(productList: dayWiseDetailedInsertList)
                }
            }
        }
        
        
        
        
        return DBHelper.sharedInstance.insertAssetAnalytics(assetObj: analyticsObj)
    }
    
    func insertDownloadedAsset(daCode : Int,offlineUrl : String, docType: Int, isDownloaded: Int)
    {
        let dict : NSDictionary = ["DA_Code" : daCode,"DA_Offline_Url":offlineUrl, "DA_Type": docType, "Is_Downloaded": isDownloaded]
        DBHelper.sharedInstance.insertAssetDownloaded(dict: dict)
    }
    
    func updateDownloadedAsset(daCode : Int,offlineUrl : String, docType: Int, isDownloaded: Int)
    {
        DBHelper.sharedInstance.updateAssetDownloaded(daCode: daCode, offlineUrl: offlineUrl, docType: docType, isDownloaded: isDownloaded)
    }
    
    func getAssetAnalyticsById(analyticsId : Int) -> AssetAnalyticsDetail
    {
        return DBHelper.sharedInstance.getAssetAnalyticsByAnalyticsId(analyticsId: analyticsId)
    }
    
    func getCustomerObjByCustomerCode() -> CustomerMasterModel?
    {
        return DBHelper.sharedInstance.getCustomerByCustomerCode(customerCode: BL_DoctorList.sharedInstance.customerCode, regionCode: BL_DoctorList.sharedInstance.regionCode)
    }
    
    func updateAssetAnalyticsById(assetAnalyticsId : Int,assetObj : AssetAnalyticsDetail)
    {
        return DBHelper.sharedInstance.updateAnalyticsByAnalyticsId(analyticsId:assetAnalyticsId,analyticsObj:assetObj)
    }
    
    func deleteAssetsByDacode(daCode : String)
    {
        DBHelper.sharedInstance.deleteAssetsDownlodedByDacode(daCodes: "'\(daCode)'")
    }
    
    func getThumbnailImage(docType : Int) -> UIImage
    {
        switch docType {
        case 1:
            return UIImage(named: "icon-thumbnail-image")!
        case 2:
            return UIImage(named: "icon-thumbnail-video")!
        case 3:
            return UIImage(named: "icon-thumbnail-audio")!
        case 4:
            return UIImage(named: "icon-thumbnail-document")!
        case 5:
            return UIImage(named: "icon-thumbnail-html")!
        default:
            return UIImage(named: "icon-thumbnail-image")!
        }
    }
    
    
    //MARK:- Private function
    
    func getDaCode(daCodeArray : [Int]) -> String
    {
        var dacode : String = EMPTY
        
        for code in daCodeArray
        {
            dacode = dacode + "'" + String(code) + "',"
        }
        
        if (dacode != EMPTY)
        {
            dacode = dacode.substring(to: dacode.index(before: dacode.endIndex))
        }
        return dacode
    }
    
    
    private func getAssetsPartList(assetList :[AssetHeader],isShowList : Bool) -> [AssetParts]
    {
        var daCode : [Int] = []
        var assetPartList : [AssetParts]  = []
        
        for obj in assetList
        {
            daCode.append(obj.daCode)
        }
        
        let dacode = getDaCode(daCodeArray: daCode)
        
        if isShowList
        {
            assetPartList = DBHelper.sharedInstance.getAssetsPartsListByDaCode(daCode: dacode)
        }
        else
        {
            assetPartList = DBHelper.sharedInstance.getAssetPartsList()
        }
        return assetPartList
    }
    
    // Get Assets from Showlist
    func getAssetsFromShowList() -> [AssetHeader]
    {
        var assetList: [AssetHeader] = []
        
        let showList = getCustomerShowList()
        
        for model in showList
        {
            if model.storyEnabled == true
            {
                for assetModel in model.storyObj.assetList
                {
                    assetList.append(assetModel)
                }
            }
            else
            {
                assetList.append(model.assetDetail)
            }
        }
        
        return assetList
    }
    
    func checkForHTMLAssets() -> Int
    {
        let assetList: [AssetHeader] = getAssetsFromShowList()
        
        var status: Int = 0
        
        let getFilteredAssets = assetList.filter({$0.docType == Constants.DocTypeIds.zip})
        let getHTMLAssets = DBHelper.sharedInstance.getDownloadedHTMLAssets()
        for assetModel in getFilteredAssets
        {
            if !getHTMLAssets.contains(where: { $0.daCode == assetModel.daCode})
            {
                status = 1
                return status
            }
        }
        
        for assetModel in getFilteredAssets
        {
            if getHTMLAssets.contains(where: { $0.daCode == assetModel.daCode && $0.isDownloaded == isFileDownloaded.progress.rawValue})
            {
                status = 2
                return status
            }
        }
        
        return status
    }
    
    func updateHTMLAssetDownloadStatus()
    {
        let downloadStatus = isFileDownloaded.progress.rawValue
        let assetList: [AssetHeader] = getAssetsFromShowList()
        
        let getFilteredAssets = assetList.filter({$0.docType == Constants.DocTypeIds.zip})
        let getHTMLAssets = DBHelper.sharedInstance.getDownloadedHTMLAssets()
        for assetModel in getFilteredAssets
        {
            if !getHTMLAssets.contains(where: { $0.daCode == assetModel.daCode})
            {
                DBHelper.sharedInstance.updateDownloadStatus(downloadStatus: downloadStatus, fileName: EMPTY, daCode: assetModel.daCode)
                let assetObjList = DBHelper.sharedInstance.checkDownloadedAssetsForDACode(daCode: assetModel.daCode)
                if assetObjList.count == 0
                {
                    BL_AssetModel.sharedInstance.insertDownloadedAsset(daCode: assetModel.daCode, offlineUrl: "", docType: assetModel.docType, isDownloaded: isFileDownloaded.progress.rawValue)
                }
            }
        }
        
        if BL_AssetDownloadOperation.sharedInstance.statusList.count == 0
        {
            BL_AssetDownloadOperation.sharedInstance.initiateOperation()
        }
    }
    
    func updateDisplayOrderInShowList(){
        var displayIndex = 1
        for showListObj in BL_AssetModel.sharedInstance.showList{
            DBHelper.sharedInstance.updateTheDisplayIndexForShowList(showListObj: showListObj, displayIndex: displayIndex)
            displayIndex += 1
        }
    }
    
    func getAssetSwapPrivilegeValue() -> Int
    {
        let privValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.EDETAILING_MC_STORY_AND_ASSET_SWAP)
        var returnValue: Int = 1
        
        if (privValue != EMPTY)
        {
            if (isValidIntegerNumber(value: privValue))
            {
                returnValue = Int(privValue)!
            }
        }
        
        return returnValue
    }
}


class BL_StoryModel : NSObject
{
    static let sharedInstance : BL_StoryModel = BL_StoryModel()
    
    
    func getMasterStoryList(ismandatory : Bool) -> [AssetMandatoryListModel]
    {
        var mandatoryStoryList : [AssetMandatoryListModel] = []
        var  storyList  = [StoryHeader]()
        
        if !ismandatory{
           storyList =  getHeaderStoryList()
        }else{
            storyList = getMandatoryStoryList()
        }
        
        for obj in storyList
        {
            let mandatoryObj : AssetMandatoryListModel = AssetMandatoryListModel()
            mandatoryObj.storyObj = obj
            mandatoryObj.isAssets = false
            mandatoryObj.assetList = DBHelper.sharedInstance.getAssetsByStoryId(storyId: obj.Story_Id)
            mandatoryStoryList.append(mandatoryObj)
        }
        return mandatoryStoryList
    }
    
    func getFullMasterStoryList() -> [AssetMandatoryListModel]
    {
        var mandatoryStoryList : [AssetMandatoryListModel] = []
        let  storyList  = DBHelper.sharedInstance.getMasterStoryList()
        for obj in storyList
        {
            let mandatoryObj : AssetMandatoryListModel = AssetMandatoryListModel()
            mandatoryObj.storyObj = obj
            mandatoryObj.isAssets = false
            mandatoryObj.assetList = DBHelper.sharedInstance.getAssetsByStoryId(storyId: obj.Story_Id)
            mandatoryStoryList.append(mandatoryObj)
        }
        return mandatoryStoryList
    }
    
    private func getHeaderStoryList() -> [StoryHeader]
    {
        let customerObj = BL_AssetModel.sharedInstance.getCustomerObjByCustomerCode()
        
        return DBHelper.sharedInstance.getMasterStoryIdByCustomerDetails(categoryCode: checkNullAndNilValueForString(stringData: customerObj?.Category_Code), specialityCode: checkNullAndNilValueForString(stringData: customerObj?.Speciality_Code))
    }
    
    func getSpecialitynamesForStory(storyId : NSNumber) -> String{
        
        let specialities = DBHelper.sharedInstance.getSpecialityCodeByStoryId(storyId: storyId)
        print(specialities,"special")
        
        let uniqueList = Array(Set(specialities))
        
        return uniqueList.joined(separator: ", ")
        
    }
    
     private func getMandatoryStoryList() -> [StoryHeader]
    {
        let customerObj = BL_AssetModel.sharedInstance.getCustomerObjByCustomerCode()
        
        return DBHelper.sharedInstance.getMandatoryStoryListIds(customerObj: customerObj!)
    }
    
    func checkForOfflineAssets(assetList: [AssetHeader]) -> Int
    {
        var status: Int = 0
        
        let getFilteredAssets = assetList.filter({$0.docType == Constants.DocTypeIds.zip})
        let getHTMLAssets = DBHelper.sharedInstance.getDownloadedHTMLAssets()
        for assetModel in getFilteredAssets
        {
            if !getHTMLAssets.contains(where: { $0.daCode == assetModel.daCode})
            {
                status = 1
                return status
            }
        }
        
        for assetModel in getFilteredAssets
        {
            if getHTMLAssets.contains(where: { $0.daCode == assetModel.daCode && $0.isDownloaded == isFileDownloaded.progress.rawValue})
            {
                status = 2
                return status
            }
        }
        
        return status
    }
    
    func updateAssetDownloadStatus(downloadStatus: Int, assetList: [AssetHeader])
    {
        let getFilteredAssets = assetList.filter({$0.docType == Constants.DocTypeIds.zip})
        let getHTMLAssets = DBHelper.sharedInstance.getDownloadedHTMLAssets()
        for assetModel in getFilteredAssets
        {
            if !getHTMLAssets.contains(where: { $0.daCode == assetModel.daCode})
            {
                DBHelper.sharedInstance.updateDownloadStatus(downloadStatus: downloadStatus, fileName: EMPTY, daCode: assetModel.daCode)
                let assetObjList = DBHelper.sharedInstance.checkDownloadedAssetsForDACode(daCode: assetModel.daCode)
                if assetObjList.count == 0
                {
                    BL_AssetModel.sharedInstance.insertDownloadedAsset(daCode: assetModel.daCode, offlineUrl: "", docType: assetModel.docType, isDownloaded: isFileDownloaded.progress.rawValue)
                }
            }
        }
        
        if BL_AssetDownloadOperation.sharedInstance.statusList.count == 0
        {
            BL_AssetDownloadOperation.sharedInstance.initiateOperation()
        }
    }
    
}



