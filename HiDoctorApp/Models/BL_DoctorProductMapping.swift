//
//  BL_DoctorProductMapping.swift
//  HiDoctorApp
//
//  Created by Swaas on 26/12/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import Foundation
import UIKit

class BL_DoctorProductMapping: NSObject
{
    static let sharedInstance = BL_DoctorProductMapping()
    
    var customerList: [CustomerMasterModel] = []
    var detailedProductList: [DetailProductMaster] = []
    var campaignData:MCHeaderModel!
    
    
    
    func getDPMParentUsers(selectedRegionCode: String, completion: @escaping (_ userList: [DPMUserList],_ status:Int) -> ())
    {
        var userList : [DPMUserList] = []
        WebServiceHelper.sharedInstance.getDPMParentUsers(selectedRegionCode: selectedRegionCode) { (apiObj) in
            if apiObj.Status == SERVER_SUCCESS_CODE
            {
                if apiObj.list.count > 0
                {
                    
                    for obj in apiObj.list
                    {
                        let dict = obj as! NSDictionary
                        let lstChildUserstoParentlist = dict.value(forKey: "lstChildUserstoParentlevel") as! NSArray
                        
                        for lstObj in lstChildUserstoParentlist
                        {
                            let dict = lstObj as! NSDictionary
                            let userObj = DPMUserList()
                            userObj.Region_Code = checkNullAndNilValueForString(stringData:dict.value(forKey: "Region_Code") as? String)
                            userObj.Region_Name = checkNullAndNilValueForString(stringData:dict.value(forKey: "Region_Name") as? String)
                            userObj.Region_Type_Name = checkNullAndNilValueForString(stringData:dict.value(forKey: "Region_Type_Name") as? String)
                            userObj.User_Code = checkNullAndNilValueForString(stringData:dict.value(forKey: "User_Code") as? String)
                            userObj.User_Name = checkNullAndNilValueForString(stringData:dict.value(forKey: "User_Name") as? String)
                            userObj.User_Type_Name = checkNullAndNilValueForString(stringData:dict.value(forKey: "User_Type_Name") as? String)
                            
                            userList.append(userObj)
                        }
                    }
                    completion(userList,SERVER_SUCCESS_CODE)
                }
                else
                {
                    completion(userList,apiObj.Status)
                    
                }
            }
            else
            {
                completion([],apiObj.Status)
                
            }
        }
    }
    
    func getDPMParentUsersByCampaignCode(selectedRegionCode: String,campaignCode:String, completion: @escaping (_ userList: [DPMUserList],_ status:Int) -> ())
    {
        var userList : [DPMUserList] = []
        WebServiceHelper.sharedInstance.getDPMParentUsersByCampaignCode(selectedRegionCode: selectedRegionCode,campaignCode:campaignCode) { (apiObj) in
            if apiObj.Status == SERVER_SUCCESS_CODE
            {
                if apiObj.list.count > 0
                {
                    
                    for obj in apiObj.list
                    {
                        let dict = obj as! NSDictionary
                        let lstChildUserstoParentlist = dict.value(forKey: "lstChildUserstoParentlevel") as! NSArray
                        
                        for lstObj in lstChildUserstoParentlist
                        {
                            let dict = lstObj as! NSDictionary
                            let userObj = DPMUserList()
                            userObj.Region_Code = checkNullAndNilValueForString(stringData:dict.value(forKey: "Region_Code") as? String)
                            userObj.Region_Name = checkNullAndNilValueForString(stringData:dict.value(forKey: "Region_Name") as? String)
                            userObj.Region_Type_Name = checkNullAndNilValueForString(stringData:dict.value(forKey: "Region_Type_Name") as? String)
                            userObj.User_Code = checkNullAndNilValueForString(stringData:dict.value(forKey: "User_Code") as? String)
                            userObj.User_Name = checkNullAndNilValueForString(stringData:dict.value(forKey: "User_Name") as? String)
                            userObj.User_Type_Name = checkNullAndNilValueForString(stringData:dict.value(forKey: "User_Type_Name") as? String)
                            
                            userList.append(userObj)
                        }
                    }
                    completion(userList,SERVER_SUCCESS_CODE)
                }
                else
                {
                    completion(userList,apiObj.Status)
                    
                }
            }
            else
            {
                completion([],apiObj.Status)
                
            }
        }
    }
    
    func getMCAllList(refType:String,refCode:String) -> [MCAllDetailsModel]
    {
        return DBHelper.sharedInstance.getMCAllList(refType: refType, refCode: refCode)
    }
    
    private func getCustomerMasterDataList(regionCode:String) -> [CustomerMasterModel]
    {
        
        return DBHelper.sharedInstance.getCustomerMasterList(regionCode: regionCode, customerEntityType: "DOCTOR") ?? []
    }
    
    private func getMappedDPMCustomer(reftype:String,regionCode:String) -> [DoctorProductMappingModel]
    {
        return DBHelper.sharedInstance.getDoctorProductMappingList(regionCode: regionCode, refType: reftype)
    }
    
    func getDPMCustomerList(regionCode: String, refType: String,selectedRegionCode: String) -> [CustomerMasterModel]
    {
        
        let customerMasterList = getCustomerMasterDataList(regionCode: selectedRegionCode)
        let mappedCustomerList = getMappedDPMCustomer(reftype: refType, regionCode: regionCode)
        for obj in customerMasterList
        {
            let filteredValue = mappedCustomerList.filter{
                $0.Customer_Code == obj.Customer_Code
            }
            
            if filteredValue.count > 0
            {
                obj.isViewEnable = true
                obj.noOfPrescription = filteredValue[0].Support_Quantity
                obj.potentialPrescription = filteredValue[0].Potential_Quantity
            }
        }
        
        return customerMasterList
    }
    
    //    func getSelectedProductFromDoctor(mappedRegionCode:String,refType:String,customerCode:String,customerRegionCode:String)-> [DoctorProductMappingModel]
    //    {
    //        return DBHelper.sharedInstance.getDoctorProductMappingListUsingCustomerCode(mappedRegionCode: mappedRegionCode, refType: refType, customerCode: customerCode, customerRegionCode: customerRegionCode)
    //    }
    
    private func getProductMasterList(regionCode:String) -> [DetailProductMaster]
    {
        
        return DBHelper.sharedInstance.getDetailedProducts(productTypeName: "ACTIVITY", date: getCurrentDate(),regionCode:regionCode)
    }
    
    private func getMappedDPMProduct(reftype:String,mappedRegionCode:String,customerRegionCode:String) -> [DoctorProductMappingModel]
    {
        return DBHelper.sharedInstance.getDPMProductList(mappedRegionCode: mappedRegionCode, refType: reftype, customerRegionCode:customerRegionCode)
    }
    
    func getDPMProductList(mappedRegionCode: String, refType: String,customerRegionCode: String) -> [DetailProductMaster]
    {
        
        let detailedProductList = getProductMasterList(regionCode: customerRegionCode)
        let dpmProductList = getMappedDPMProduct(reftype: refType, mappedRegionCode: mappedRegionCode, customerRegionCode: customerRegionCode)
        
        for obj in detailedProductList
        {
            let filteredValue = dpmProductList.filter{
                $0.Product_Code == obj.Product_Code && $0.Customer_Region_Code == obj.Region_Code
            }
            
            if filteredValue.count > 0
            {
                obj.isViewEnable = true
                obj.noOfPrescription = filteredValue[0].Support_Quantity
                obj.potentialPrescription = filteredValue[0].Potential_Quantity
                if filteredValue[0].Priority_Order == productDefaultPriorityOrder
                {
                    obj.priorityOrder = 0
                }
                else
                {
                    obj.priorityOrder = filteredValue[0].Priority_Order
                }
            }
        }
        
        return detailedProductList
    }
    
    private func getCampaignCustomerMasterDataList(regionCode:String,campaignCode:String) -> [CustomerMasterModel]
    {
        
        return DBHelper.sharedInstance.getCampaignCustomerMasterList(campaignCode:campaignCode,regionCode: regionCode, customerEntityType: "DOCTOR") ?? []
    }
    
    private func getMappedCampaignCustomerList(refType: String, mappedRegion: String, selectedRegion: String, mcCode: String) -> [DoctorProductMappingModel]
    {
        return DBHelper.sharedInstance.getMappedCampaignCustomerList(refType: refType, mappedRegion: mappedRegion, selectedRegion: selectedRegion, mcCode: mcCode)
    }
    
    func getDPMMarketingCampaignCustomerList(mappedRegionCode:String,regionCode: String, refType: String,mcCode:String) -> [CustomerMasterModel]
    {
        
        let customerMasterList = getCampaignCustomerMasterDataList(regionCode: regionCode, campaignCode: mcCode)
        let mappedCustomerList = getMappedCampaignCustomerList(refType: refType, mappedRegion: mappedRegionCode, selectedRegion: regionCode, mcCode: mcCode)
        for obj in customerMasterList
        {
            let filteredValue = mappedCustomerList.filter{
                $0.Customer_Code == obj.Customer_Code && $0.Customer_Region_Code == obj.Region_Code
            }
            
            if filteredValue.count > 0
            {
                obj.isViewEnable = true
                obj.noOfPrescription = filteredValue[0].Support_Quantity
                obj.potentialPrescription = filteredValue[0].Potential_Quantity
            }
        }
        
        return customerMasterList
    }
    
    private func getCampaignProductDataList(regionCode:String,campaignCode:String) -> [DetailProductMaster]
    {
        
        return DBHelper.sharedInstance.getCampaignProductMasterList(campaignCode:campaignCode, regionCode:regionCode)
    }
    
    private func getMappedCampaignProductList(refType: String, mappedRegion: String, selectedRegion: String, mcCode: String) -> [DoctorProductMappingModel]
    {
        return DBHelper.sharedInstance.getMappedCampaignProductList(refType: refType, mappedRegion: mappedRegion, selectedRegion: selectedRegion, mcCode: mcCode)
    }
    
    
    func getDPMMarketingCampaignProductList(mappedRegionCode:String,regionCode: String, refType: String,mcCode:String) -> [DetailProductMaster]
    {
        
        let detailedProductList = getCampaignProductDataList(regionCode: regionCode,campaignCode:mcCode)
        let dpmProductList = getMappedCampaignProductList(refType: refType, mappedRegion: mappedRegionCode, selectedRegion: regionCode, mcCode: mcCode)
        
        for obj in detailedProductList
        {
            let filteredValue = dpmProductList.filter{
                $0.Product_Code == obj.Product_Code && $0.Customer_Region_Code == obj.Region_Code
            }
            
            if filteredValue.count > 0
            {
                obj.isViewEnable = true
                obj.noOfPrescription = filteredValue[0].Support_Quantity
                obj.potentialPrescription = filteredValue[0].Potential_Quantity
                if filteredValue[0].Priority_Order == productDefaultPriorityOrder
                {
                    obj.priorityOrder = 0
                }
                else
                {
                    obj.priorityOrder = filteredValue[0].Priority_Order
                }
            }
        }
        
        return detailedProductList
    }
    
    func getMappedCustomerList(refType: String, mappedRegion: String, selectedRegion: String, customerCode: String) -> [DoctorProductMappingModel]
    {
        return DBHelper.sharedInstance.getMappedCustomerList(refType: refType, mappedRegion: mappedRegion, selectedRegion: selectedRegion, customerCode: customerCode)
    }
    
    func getMappedProductList(refType: String, mappedRegion: String, selectedRegion: String, productCode: String) -> [DoctorProductMappingModel]
    {
        return DBHelper.sharedInstance.getMappedProductList(refType: refType, mappedRegion: mappedRegion, selectedRegion: selectedRegion, productCode: productCode)
    }
    
    
    
    
    //MARK:- DPM Delete(General,Target and Marketing)
    
    func deleteDoctorProductMapping(postData:[String:Any],completion: @escaping(_ apiObj: ApiResponseModel)-> ())
    {
        WebServiceHelper.sharedInstance.deleteDoctorProductMapping(postData: postData) { (apiObj) in
            
            completion(apiObj)
        }
    }
    
    //MARK:- DPM Mapped list(Marketing Campaign)
    
    func getMappedCampaignCustomerListUsingCampaignCode(refType: String, mappedRegion: String, selectedRegion: String, mcCode: String,customerCode:String) -> [DoctorProductMappingModel]
    {
        return DBHelper.sharedInstance.getMappedCampaignCustomerListUsingCustomerRegion(refType: refType, mappedRegion: mappedRegion, selectedRegion: selectedRegion, mcCode: mcCode, customerCode: customerCode)
    }
    
    func getMappedCampaignProductListUsingCampaignCode(refType: String, mappedRegion: String, selectedRegion: String, mcCode: String,productCode:String) -> [DoctorProductMappingModel]
    {
        return DBHelper.sharedInstance.getMappedCampaignProductListUsingCustomerRegion(refType: refType, mappedRegion: mappedRegion, selectedRegion: selectedRegion, mcCode: mcCode, productCode: productCode)
    }
    
    //MARK:- DPM Mapping list
    
    func getMappingProductList(refType: String, mappedRegion: String, selectedRegion: String, customerCode: String) -> [DetailProductMaster]
    {
        
        let detailedProductList = getProductMasterList(regionCode: selectedRegion)
        let mappedList = DBHelper.sharedInstance.getMappedCustomerList(refType: refType, mappedRegion: mappedRegion, selectedRegion: selectedRegion, customerCode: customerCode)
        
        for obj in detailedProductList
        {
            let filteredValue = mappedList.filter{
                $0.Product_Code == obj.Product_Code && $0.Customer_Region_Code == obj.Region_Code
            }
            
            if filteredValue.count > 0
            {
                obj.isViewEnable = true
                obj.noOfPrescription = filteredValue[0].Support_Quantity
                obj.potentialPrescription = filteredValue[0].Potential_Quantity
                if filteredValue[0].Priority_Order == productDefaultPriorityOrder
                {
                    obj.priorityOrder = 0
                }
                else
                {
                    obj.priorityOrder = filteredValue[0].Priority_Order
                }
            }
        }
        
        return detailedProductList
    }
    
    func getMappingCustomerList(mappedRegionCode:String,refType:String,selectedRegionCode:String,productCode:String) -> [CustomerMasterModel]
    {
        let customerMasterList = getCustomerMasterDataList(regionCode: selectedRegionCode)
        let mappedList = DBHelper.sharedInstance.getExistingDPMProductList(mappedRegionCode: mappedRegionCode,refType: refType,customerRegionCode:selectedRegionCode, productCode: productCode)
        
        
        for obj in customerMasterList
        {
            let filteredValue = mappedList.filter{
                $0.Customer_Code == obj.Customer_Code && $0.Customer_Region_Code == obj.Region_Code
            }
            
            
            
            if filteredValue.count > 0
            {
                obj.isViewEnable = true
                obj.noOfPrescription = filteredValue[0].Support_Quantity
                obj.potentialPrescription = filteredValue[0].Potential_Quantity
            }
        }
        
        return customerMasterList
        
    }
    
    func getMappingMarketingCustomerList(refType: String, mappedRegion: String, selectedRegion: String, mcCode: String, productCode: String) -> [CustomerMasterModel]
    {
        
        let customerMasterList = getCampaignCustomerMasterDataList(regionCode: selectedRegion, campaignCode: mcCode)
        let mappedLsit = getMappedCampaignProductListUsingCampaignCode(refType: refType, mappedRegion: mappedRegion, selectedRegion: selectedRegion, mcCode: mcCode, productCode: productCode)
        
        for obj in customerMasterList
        {
            let filteredValue = mappedLsit.filter{
                $0.Customer_Code == obj.Customer_Code && $0.Customer_Region_Code == obj.Region_Code
            }
            
            if filteredValue.count > 0
            {
                obj.isViewEnable = true
                obj.noOfPrescription = filteredValue[0].Support_Quantity
                obj.potentialPrescription = filteredValue[0].Potential_Quantity
            }
        }
        
        return customerMasterList
    }
    func getMappingMarketingProductList(refType: String, mappedRegion: String, selectedRegion: String, mcCode: String, customerCode: String) -> [DetailProductMaster]
    {
        
        let detailedProductList = getCampaignProductDataList(regionCode: selectedRegion,campaignCode:mcCode)
        let mappedList = DBHelper.sharedInstance.getMappedCampaignCustomerListUsingCustomerRegion(refType: refType, mappedRegion: mappedRegion, selectedRegion: selectedRegion, mcCode: mcCode, customerCode: customerCode)
        
        for obj in detailedProductList
        {
            let filteredValue = mappedList.filter{
                $0.Product_Code == obj.Product_Code && $0.Customer_Region_Code == obj.Region_Code
            }
            
            if filteredValue.count > 0
            {
                obj.isViewEnable = true
                obj.noOfPrescription = filteredValue[0].Support_Quantity
                obj.potentialPrescription = filteredValue[0].Potential_Quantity
                if filteredValue[0].Priority_Order == productDefaultPriorityOrder
                {
                    obj.priorityOrder = 0
                }
                else
                {
                    obj.priorityOrder = filteredValue[0].Priority_Order
                }
            }
        }
        
        return detailedProductList
    }
}

class DPMUserList: NSObject
{
    var Region_Code: String!
    var Region_Name: String!
    var Region_Type_Name: String!
    var User_Code: String!
    var User_Name: String!
    var User_Type_Name: String!
    
}
