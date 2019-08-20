//
//  AssetsDataManager.swift
//  HiDoctorApp
//
//  Created by Admin on 6/4/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class AssetsDataManager: NSObject {

    var currentIndex = 0
    var previousIndex = 0
    var docType = 0
    var isSubviewsHidden = true
    var currentAssetObj = AssetsPlayListModel()
    var childControllersList = [AssetsPlayerChildViewController]()
    var isStoryTracked = false
    var previousStoryId  : NSNumber = -1
    //MARK: Shared Instance
    
    static let sharedManager : AssetsDataManager = {
        let instance = AssetsDataManager()
        return instance
    }()
    
    
    
    func convertShowListObjToAssetHeader(asset : AssetShowListModel ) -> AssetHeader {
        
        let fromDate =  convertDateIntoServerStringFormat(date: asset.startDate)
        let endDate =  convertDateIntoServerStringFormat(date: asset.endDate)
        
            let dict : NSDictionary = ["DA_Code" : asset.daCode, "DA_Name" : asset.daName , "DA_Type" : asset.docType , "Is_Downloadable" : asset.isDownloadable , "DA_Thumbnail_URL" : asset.thumbnailUrl, "DA_Size_In_MB" : asset.daSize , "Is_Downloaded" : asset.isDownloaded  , "DA_FileName" : asset.daFileName , "FromDate":fromDate , "ToDate" : endDate , "Html_Start_Page" : asset.Html_Start_Page ,"DA_Description": asset.daDesc, "Number_Of_Parts": asset.noOfParts , "Total_Duration_in_Seconds": asset.duration , "DA_Online_URL" : asset.onlineUrl  ]
            
            let assetModel = AssetHeader(dict: dict)
        assetModel.localUrl = asset.localUrl

            return assetModel
        
    }
    
    
    func convertAssetHeaderToShowListObj(asset : AssetHeader ) -> AssetShowListModel {
        
        
            let dict : NSDictionary = ["DA_Code" : asset.daCode, "DA_Name" : asset.daName , "DA_Type" : asset.docType , "Is_Downloadable" : asset.isDownloadable , "DA_Thumbnail_URL" : asset.thumbnailUrl, "DA_Size_In_MB" : asset.daSize , "Is_Downloaded" : asset.isDownloaded  , "DA_FileName" : asset.daFileName , "FromDate":asset.startDate , "ToDate" : asset.endDate, "Html_Start_Page" : asset.Html_Start_Page ,"DA_Description": asset.daDesc, "Number_Of_Parts": asset.noOfParts , "Total_Duration_in_Seconds": asset.duration , "DA_Online_URL" : asset.onlineUrl  ]
            
            let assetModel = AssetShowListModel(dict: dict)
        assetModel.localUrl = asset.localUrl

        return assetModel
    }
    
    
    func convertShowListModelToAssetHeader(showList : [AssetShowListModel] ) -> [AssetHeader] {
        
        var assetHeaderList = [AssetHeader]()
        
        for asset in showList{
            
             let fromDate =  convertDateIntoServerStringFormat(date: asset.startDate)
            let endDate =  convertDateIntoServerStringFormat(date: asset.endDate)

            
            let dict : NSDictionary = ["DA_Code" : asset.daCode, "DA_Name" : asset.daName , "DA_Type" : asset.docType , "Is_Downloadable" : asset.isDownloadable , "DA_Thumbnail_URL" : asset.thumbnailUrl, "DA_Size_In_MB" : asset.daSize , "Is_Downloaded" : asset.isDownloaded  , "DA_FileName" : asset.daFileName , "FromDate":fromDate , "ToDate" : endDate, "Html_Start_Page" : asset.Html_Start_Page ,"DA_Description": asset.daDesc, "Number_Of_Parts": asset.noOfParts , "Total_Duration_in_Seconds": asset.duration , "DA_Online_URL" : asset.onlineUrl  ]
            
            let assetModel = AssetHeader(dict: dict)
            assetModel.localUrl = asset.localUrl
            assetHeaderList.append(assetModel)
            
        }
        
        return assetHeaderList
    }
    
    
    func convertAssetHeaderToShowListModel(assetList : [AssetHeader] ) -> [AssetShowListModel] {
        
        var assetShowList = [AssetShowListModel]()
        
        for asset in assetList{
            
            let dict : NSDictionary = ["DA_Code" : asset.daCode, "DA_Name" : asset.daName , "DA_Type" : asset.docType , "Is_Downloadable" : asset.isDownloadable , "DA_Thumbnail_URL" : asset.thumbnailUrl, "DA_Size_In_MB" : asset.daSize , "Is_Downloaded" : asset.isDownloaded  , "DA_FileName" : asset.daFileName , "FromDate":asset.startDate , "ToDate" : asset.endDate, "Html_Start_Page" : asset.Html_Start_Page ,"DA_Description": asset.daDesc, "Number_Of_Parts": asset.noOfParts , "Total_Duration_in_Seconds": asset.duration , "DA_Online_URL" : asset.onlineUrl  ]
            
            let assetModel = AssetShowListModel(dict: dict)
            assetModel.localUrl = asset.localUrl
            assetShowList.append(assetModel)
            
        }
        
        return assetShowList
    }
}
