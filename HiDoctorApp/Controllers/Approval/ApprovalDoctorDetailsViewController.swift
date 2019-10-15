//
//  ApprovalDoctorDetailsViewController.swift
//  HiDoctorApp
//
//  Created by Vignaya on 1/10/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class ApprovalDoctorDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,SelectedChemistDelegate,SelectedChemistpobDelegate
{
    @IBOutlet weak var mainTableView: UITableView!
    
    var doctorDetailList : [DoctorDetailsListModel] = []
    var DCRCode : String!
    var doctorVisitCode : String!
    var userCode : String!
    var dcrDate : String!
    var isFromChemistDay : Bool = false
    var dcrId: Int!
    var doctorVisitId: Int!
    var doctorCode: String!
    var doctorRegionCode: String!
    var doctorName: String!
    var specialtyName: String!
    var chemistVisitId: Int!
    var isFromAttendance: Bool = false
    var userObj : ApprovalUserMasterModel!
    var selectedIndex : Int = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        addBackButtonView()
        if(isFromChemistDay)
        {
            self.doctorDetailList = BL_Approval.sharedInstance.getDCRChemistApprovalDataList()
        }
        else if isFromAttendance
        {
           self.doctorDetailList = BL_Approval.sharedInstance.getAttendanceDCRApprovalDataList()
        }
        else
        {
            self.doctorDetailList = BL_Approval.sharedInstance.getDCRApprovalDataList()
        }
        let dict : NSDictionary = NSDictionary()
        self.setDetailObj(dict: dict)
        self.setDefaultDetails()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func setDefaultDetails()
    {
        if DCRCode == ""
        {
            setOfflineDoctorDetailList()
        }
        else
        {
            doctorApiCall()
        }
    }
    
    func doctorApiCall()
    {
        if(isFromChemistDay)
        {
            getChemistVisitDetails()
            getChemistAccompanistsDetails()
            getChemistSampleDetails()
            getChemistDetailedProducts()
            getChemistRCPAOwn()
            getChemistFollowUpDetails()
            getChemistAttachmentDetails()
            getDCRChemistPOB(regionCode: DCRModel.sharedInstance.userDetail.Region_Code, userCode: DCRModel.sharedInstance.userDetail.User_Code, startDate: DCRModel.sharedInstance.dcrDateString, endDate: DCRModel.sharedInstance.dcrDateString)
            
        }
        else if isFromAttendance
        {
           getAttendanceDoctorDetails()
            getAttendanceActivityDetails(regionCode: DCRModel.sharedInstance.userDetail.Region_Code, userCode: DCRModel.sharedInstance.userDetail.User_Code, startDate: DCRModel.sharedInstance.dcrDateString, endDate: DCRModel.sharedInstance.dcrDateString)
            getAttendanceMCActivityDetails(regionCode: DCRModel.sharedInstance.userDetail.Region_Code, userCode: DCRModel.sharedInstance.userDetail.User_Code, startDate: DCRModel.sharedInstance.dcrDateString, endDate: DCRModel.sharedInstance.dcrDateString)
        }
        else
        {
            getDoctorVisitDetails()
            getDoctorAccompanistsDetails()
            getSampleDetails()
            getDetailedProducts()
            getDoctorAssetDetails()
            getFollowUpDetails()
            getAttachmentDetails()
            getChemistsProducts()
            getDCRDoctorPOB(regionCode: DCRModel.sharedInstance.userDetail.Region_Code, userCode: DCRModel.sharedInstance.userDetail.User_Code, startDate: DCRModel.sharedInstance.dcrDateString, endDate: DCRModel.sharedInstance.dcrDateString)
            getActivityDetails(regionCode: DCRModel.sharedInstance.userDetail.Region_Code, userCode: DCRModel.sharedInstance.userDetail.User_Code, startDate: DCRModel.sharedInstance.dcrDateString, endDate: DCRModel.sharedInstance.dcrDateString)
            getMCActivityDetails(regionCode: DCRModel.sharedInstance.userDetail.Region_Code, userCode: DCRModel.sharedInstance.userDetail.User_Code, startDate: DCRModel.sharedInstance.dcrDateString, endDate: DCRModel.sharedInstance.dcrDateString)
        }
    }

    func setOfflineDoctorDetailList()
    {
        if(isFromChemistDay)
        {
            self.setDetailObj(dict:(BL_Reports.sharedInstance.getDCRChemistVisitDetails()).firstObject  as! NSDictionary)
            self.doctorDetailList[1].dataList = BL_Reports.sharedInstance.getDCRChemistAccompanistDetails(chemistVisitId: self.chemistVisitId, dcrId: self.dcrId)
            self.doctorDetailList[2].dataList = BL_Reports.sharedInstance.getDCRChemistSampleDetails()
            self.doctorDetailList[3].dataList = BL_Reports.sharedInstance.getdcrChemistDetailedProducts()
            self.doctorDetailList[4].dataList = BL_Reports.sharedInstance.getChemistDayRCPAOwn()
            self.doctorDetailList[5].dataList = BL_Reports.sharedInstance.getDCRChemistFollowUpsDetails()
            self.doctorDetailList[6].dataList = BL_Reports.sharedInstance.getDCRChemistAttachmentDetails()
            self.doctorDetailList[7].dataList = BL_Reports.sharedInstance.getDCRChemistPOB()
        }
        else if isFromAttendance
        {
            //getAttendanceDCRDoctorVisitDetails
            self.setDetailObj(dict:(BL_Reports.sharedInstance.getAttendanceDCRDoctorVisitDetails()).firstObject  as! NSDictionary)
            self.doctorDetailList[1].dataList = BL_Reports.sharedInstance.getAttendanceDCRDoctorSampleDetails()
            self.doctorDetailList[2].dataList = BL_Reports.sharedInstance.getAttendanceDoctorActivity()
            self.doctorDetailList[3].dataList = BL_Reports.sharedInstance.getAttendanceDoctorMCActivity()           
        }
        else
        {
            
            self.setDetailObj(dict:(BL_Reports.sharedInstance.getDCRDoctorVisitDetails()).firstObject  as! NSDictionary)
            self.doctorDetailList[1].dataList = BL_Reports.sharedInstance.getDCRDoctorAccompanistDetails(doctorVisitId: self.doctorVisitId, dcrId: dcrId)
            self.doctorDetailList[2].dataList = BL_Reports.sharedInstance.getDCRDoctorSampleDetails()
            self.doctorDetailList[3].dataList = BL_Reports.sharedInstance.getDoctorDetailedProducts(dcrId: self.dcrId, doctorVisitId: self.doctorVisitId)
            self.doctorDetailList[4].dataList = BL_Reports.sharedInstance.getDCRDoctorAssets()
            self.doctorDetailList[5].dataList = BL_Reports.sharedInstance.getDCRFollowUpsDetails()
            self.doctorDetailList[6].dataList = BL_Reports.sharedInstance.getDCRAttachmentDetails()
            self.doctorDetailList[7].dataList = BL_Reports.sharedInstance.getDCRDcotorChemist()
            self.doctorDetailList[8].dataList = BL_Reports.sharedInstance.getDCRDoctorPOB()
            self.doctorDetailList[9].dataList = BL_Reports.sharedInstance.getDoctorActivity()
            self.doctorDetailList[10].dataList = BL_Reports.sharedInstance.getDoctorMCActivity()
        }
        
        
        self.doctorDetailList[0].currentAPIStatus = APIStatus.Success
        self.doctorDetailList[1].currentAPIStatus = APIStatus.Success
        self.doctorDetailList[2].currentAPIStatus = APIStatus.Success
        self.doctorDetailList[3].currentAPIStatus = APIStatus.Success
        if(!isFromAttendance)
        {
        self.doctorDetailList[4].currentAPIStatus = APIStatus.Success
        self.doctorDetailList[5].currentAPIStatus = APIStatus.Success
        self.doctorDetailList[6].currentAPIStatus = APIStatus.Success
        self.doctorDetailList[7].currentAPIStatus = APIStatus.Success
        }
        if(!isFromChemistDay && !isFromAttendance)
        {
            self.doctorDetailList[8].currentAPIStatus = APIStatus.Success
            self.doctorDetailList[9].currentAPIStatus = APIStatus.Success
            self.doctorDetailList[10].currentAPIStatus = APIStatus.Success
        }
        
        self.mainTableView.reloadData()
    }
    
    func getDoctorVisitDetails()
    {
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getDCRADoctorVisitDetails(DCRCode: DCRCode, doctorVisitCode: doctorVisitCode) { (apiResponseObj) in
                if apiResponseObj.Status == SERVER_SUCCESS_CODE
                {
                    self.setDetailObj(dict: apiResponseObj.list.firstObject as! NSDictionary)
                    self.doctorDetailList[0].currentAPIStatus = APIStatus.Success
                }
                else
                {
                    self.doctorDetailList[0].currentAPIStatus = APIStatus.Failed
                }
                self.reloadTableView()
            }
        }
        else
        {
            self.setToastText(sectionType: DoctorDetailsHeaderType.DoctorVisit.rawValue)
        }
    }
    
    func getAttendanceDoctorDetails()
    {
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getDCRAttendanceSamples(userObj:userObj) { (apiResponseObject) in
                if apiResponseObject.Status == SERVER_SUCCESS_CODE
                {
                    self.doctorDetailList[0].currentAPIStatus = APIStatus.Success
                    self.doctorDetailList[1].currentAPIStatus = APIStatus.Success
                    if apiResponseObject.list.count > 0
                    {
                        self.setDetailObj(dict: apiResponseObject.list[self.selectedIndex] as! NSDictionary)
                        let list : NSMutableArray = []
                        let batchObjList : NSMutableArray = []
                       
                            let doctordetails = apiResponseObject.list[self.selectedIndex] as! NSDictionary
                            
                            
                            var dcrDoctorProductList : NSArray = []
                            
                            let sampleListObj = doctordetails.value(forKey: "lstAttendanceSamplesDetails") as! NSArray
                            if sampleListObj.count > 0
                            {
                                
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
                                
                                self.doctorDetailList[1].dataList = dcrDoctorProductList
                            }
                    }
                }
                else
                {
                    self.doctorDetailList[0].currentAPIStatus = APIStatus.Failed
                    self.doctorDetailList[1].currentAPIStatus = APIStatus.Failed
                }
                self.reloadTableView()
                
            }
        }
                            
                            
                            
                            
                            
                            
//                            var sampleList :[DCRAttendanceSampleDetailsModel] = []
//                            var dcrDoctorProductList : NSArray = []
//
//                            let sampleListObj = doctordetails.value(forKey: "lstAttendanceSamplesDetails") as! NSArray
//
//                            let newLine = "\n"
//
//                            for (_,element) in sampleListObj.enumerated()
//                            {
//                                let sampleObj = element as! NSDictionary
//                                let batchList = sampleObj.value(forKey: "lstuserproductbatch") as! NSArray
//                                var productName = String()
//                                var quantity = Int()
//
//
//                                if(batchList.count > 0)
//                                {
//                                    for (index,obj) in batchList.enumerated()
//                                    {
//                                        let batchObj = obj as! NSDictionary
//                                        if(index == 0)
//                                        {
//                                            let prodName = sampleObj.value(forKey:"Product_Name") as! String
//                                            let batchName = batchObj.value(forKey: "Batch_Number") as! String
//                                            productName = prodName + newLine + batchName
//                                        }
//                                        else
//                                        {
//                                            productName = batchObj.value(forKey: "Batch_Number") as! String
//                                        }
//                                        quantity = batchObj.value(forKey: "Batch_Quantity_Provided") as! Int
//                                        let dict = ["Product_Name":productName,"Quantity_Provided":quantity] as [String : Any]
//
//                                        batchObjList.add(dict)
//                                    }
//                                }
//                                else
//                                {
//                                    productName = sampleObj.value(forKey:"Product_Name") as! String
//                                    quantity = sampleObj.value(forKey: "Quantity_Provided") as! Int
//                                    let dict = ["Product_Name":productName,"Quantity_Provided":quantity] as [String : Any]
//                                    batchObjList.add(dict)
//                                }
//                            }
//                            dcrDoctorProductList = NSArray(array: batchObjList)
//
//
//
//
//
//                        }
//                        self.approvalDataList[3].dataList = list
//                    }
//                }
//                else
//                {
//                    self.approvalDataList[3].currentAPIStatus = APIStatus.Failed
//                }
//                self.reloadTableView()
//            }
//        }
//        else
//        {
//            self.setToastText(sectionType: 3)
//        }
    }
    
    func getDoctorAccompanistsDetails()
    {
        
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getDCRDoctorAccompanistForADoctorVisit(DCRCode: DCRCode, doctorVisitCode: doctorVisitCode) { (apiResponseObj) in
                if apiResponseObj.Status == SERVER_SUCCESS_CODE
                {
//                    let predicate = NSPredicate(format: "accompainedCall == %d",1)
//                    self.doctorDetailList[1].dataList = apiResponseObj.list.filtered(using: predicate) as NSArray
                    self.doctorDetailList[1].dataList = apiResponseObj.list as NSArray
                    self.doctorDetailList[1].currentAPIStatus = APIStatus.Success
                    self.reloadTableView()
                }
                else
                {
                    self.doctorDetailList[1].currentAPIStatus = APIStatus.Failed
                }
                self.reloadTableView()
            }
        }
        else
        {
            self.setToastText(sectionType: DoctorDetailsHeaderType.Accompanist.rawValue)
        }
        
    }
    
    func getSampleDetails()
    {
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getDCRSampleDetailsForADoctorVisit(DCRCode: DCRCode, doctorVisitCode: doctorVisitCode) { (apiResponseObj) in
                if apiResponseObj.Status == SERVER_SUCCESS_CODE
                {
                    let convertedList = BL_Reports.sharedInstance.getDoctorDetailSampleBatchDetails(dataArray: apiResponseObj.list)
                    self.doctorDetailList[2].dataList = convertedList
                    self.doctorDetailList[2].currentAPIStatus = APIStatus.Success
                }
                else
                {
                    self.doctorDetailList[2].currentAPIStatus = APIStatus.Failed
                }
                self.reloadTableView()
            }
        }
        else
        {
            self.setToastText(sectionType: DoctorDetailsHeaderType.Sample.rawValue)
        }
    }
    
    func getDetailedProducts()
    {
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getDCRDetailedProductsDetailsForADoctorVisit(DCRCode: DCRCode, doctorVisitCode: doctorVisitCode) { (apiResponseObj) in
                if apiResponseObj.Status == SERVER_SUCCESS_CODE
                {
                    let convertedList = BL_Reports.sharedInstance.getDoctorDetailedProductsApi(dataArray: apiResponseObj.list)
                    self.doctorDetailList[3].dataList = convertedList
                    self.doctorDetailList[3].currentAPIStatus = APIStatus.Success
                }
                else
                {
                    self.doctorDetailList[3].currentAPIStatus = APIStatus.Failed
                }
                self.reloadTableView()
            }
        }
        else
        {
            self.setToastText(sectionType: DoctorDetailsHeaderType.DetailedProduct.rawValue)
        }
    }
    
    func getDoctorAssetDetails()
    {
        if(DCRModel.sharedInstance.customerCode == EMPTY)
        {
            self.doctorDetailList[4].dataList = []
            self.doctorDetailList[4].currentAPIStatus = APIStatus.Success
            self.reloadTableView()
        }
        else
        {
            if checkInternetConnectivity()
            {
                BL_Approval.sharedInstance.getDoctorDigitalAssets(userCode : userCode,dcrDate :dcrDate)
                { (apiResponseObj) in
                    if apiResponseObj.Status == SERVER_SUCCESS_CODE
                    {
                        self.doctorDetailList[4].dataList = apiResponseObj.list
                        self.doctorDetailList[4].currentAPIStatus = APIStatus.Success
                    }
                    else
                    {
                        self.doctorDetailList[4].currentAPIStatus = APIStatus.Failed
                    }
                    self.reloadTableView()
                }
            }
            else
            {
                self.setToastText(sectionType: DoctorDetailsHeaderType.DigitalAssets.rawValue)
            }
        }
    }
    
    func getFollowUpDetails()
    {
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getFollowUpDetails(userCode: userCode, doctorVisitCode: doctorVisitCode) { (apiResponseObj) in
                if apiResponseObj.Status == SERVER_SUCCESS_CODE
                {
                    self.doctorDetailList[5].dataList = apiResponseObj.list
                    self.doctorDetailList[5].currentAPIStatus = APIStatus.Success
                }
                else
                {
                    self.doctorDetailList[5].currentAPIStatus = APIStatus.Failed
                }
                self.reloadTableView()
            }
        }
        else
        {
            self.setToastText(sectionType: DoctorDetailsHeaderType.FollowUps.rawValue)
        }
    }
    
    func getAttachmentDetails()
    {
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getAttachmentForDoctorDetails(userCode: userCode, doctorVisitCode: doctorVisitCode) { (apiResponseObj) in
                if apiResponseObj.Status == SERVER_SUCCESS_CODE
                {
                    self.doctorDetailList[6].dataList = apiResponseObj.list
                    self.doctorDetailList[6].currentAPIStatus = APIStatus.Success
                }
                else
                {
                    self.doctorDetailList[6].currentAPIStatus = APIStatus.Failed
                }
                self.reloadTableView()
            }
        }
        else
        {
            self.setToastText(sectionType: DoctorDetailsHeaderType.ChemistVisit.rawValue)
        }
    }
    
    func getChemistsProducts()
    {
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getDCRChemistVisitDetailsForADoctorVisit(DCRCode: DCRCode, doctorVisitCode: doctorVisitCode) { (apiResponseObj) in
                if apiResponseObj.Status == SERVER_SUCCESS_CODE
                {
                    self.doctorDetailList[7].dataList = apiResponseObj.list
                    self.doctorDetailList[7].currentAPIStatus = APIStatus.Success
                }
                else
                {
                    self.doctorDetailList[7].currentAPIStatus = APIStatus.Failed
                }
                self.reloadTableView()
            }
        }
        else
        {
            self.setToastText(sectionType: DoctorDetailsHeaderType.ChemistVisit.rawValue)
        }
    }
    
    
    //ChemistDay
    
    func getChemistVisitDetails()
    {
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getDCRAChemistVisitDetails(DCRCode: DCRCode, chemistVisitCode: doctorVisitCode) { (apiResponseObj) in
                if apiResponseObj.Status == SERVER_SUCCESS_CODE
                {
                    let list : NSMutableArray = []
                    for obj in apiResponseObj.list
                    {
                        let chemistObj = obj as! NSDictionary
                        var visitTime = checkNullAndNilValueForString(stringData: chemistObj.value(forKey: "Visit_Time") as? String)
                        if(!(visitTime.contains("AM"))) || (!(visitTime.contains("PM")))
                        {
                            visitTime = visitTime + " " + checkNullAndNilValueForString(stringData: chemistObj.value(forKey: "Visit_Mode") as? String)
                        }
                        let dict : NSDictionary = ["Doctor_Name" : checkNullAndNilValueForString(stringData: chemistObj.value(forKey: "Chemist_Name") as? String), /*"MDL_Number" : checkNullAndNilValueForString(stringData: chemistObj.value(forKey: "Chemists_MDL_Number") as? String) , */"Speciality_Name" : NA , "Category_Name" : NA, "Visit_Mode" :  checkNullAndNilValueForString(stringData: chemistObj.value(forKey: "Visit_Mode") as? String) , "Visit_Time" :  visitTime, "POB_Amount" : String(describing: chemistObj.value(forKey: "POB_Amount") as! Int), "Remarks" : checkNullAndNilValueForString(stringData: chemistObj.value(forKey: "Remarks") as? String)]
                        list.add(dict)
                    }
                    
                    self.setDetailObj(dict: list.firstObject as! NSDictionary)
                    self.doctorDetailList[0].currentAPIStatus = APIStatus.Success
                }
                else
                {
                    self.doctorDetailList[0].currentAPIStatus = APIStatus.Failed
                }
                self.reloadTableView()
            }
        }
        else
        {
            self.setToastText(sectionType: DoctorDetailsHeaderType.DoctorVisit.rawValue)
        }
    }
    
    
    func getChemistAccompanistsDetails()
    {
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getDCRChemistAccompanistForAChemistVisit(DCRCode: DCRCode, chemistVisitCode: doctorVisitCode) { (apiResponseObj) in
                if apiResponseObj.Status == SERVER_SUCCESS_CODE
                {
//                    let list : NSMutableArray = []
//                    for obj in apiResponseObj.list
//                    {
//                    let accOBj = obj as! NSDictionary
//                    let isChemist = accOBj.value(forKey: "Is_Only_For_Chemist")! as! Int
//                    let dict : NSDictionary = ["Acc_User_Name" : checkNullAndNilValueForString(stringData:accOBj.value(forKey: "Acc_User_Name") as? String), "Is_Only_For_Doctor" : String(isChemist)]
//
//                        if(String(isChemist) == "0")
//                        {
//                            list.add(dict)
//                        }
//                    }
//                    let predicate = NSPredicate(format: "accompainedCall == %d",1)
//                    self.doctorDetailList[1].dataList = apiResponseObj.list.filtered(using: predicate) as NSArray
                    self.doctorDetailList[1].dataList = apiResponseObj.list as NSArray
                    self.doctorDetailList[1].currentAPIStatus = APIStatus.Success
                    self.reloadTableView()
                }
                else
                {
                    self.doctorDetailList[1].currentAPIStatus = APIStatus.Failed
                }
                self.reloadTableView()
            }
        }
        else
        {
            self.setToastText(sectionType: DoctorDetailsHeaderType.Accompanist.rawValue)
        }
    }
    
    
    func getChemistSampleDetails()
    {
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getDCRSampleDetailsForAChemistVisit(DCRCode: DCRCode, chemistVisitCode: doctorVisitCode) { (apiResponseObj) in
                if apiResponseObj.Status == SERVER_SUCCESS_CODE
                {
                    var dcrDoctorProductList : NSArray = []
                    let list : NSMutableArray = []
                    let newLine = "\n"
                    
                    for (_,element) in apiResponseObj.list.enumerated()
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
                                
                                list.add(dict)
                            }
                        }
                        else
                        {
                            productName = sampleObj.value(forKey:"Product_Name") as! String
                            quantity = sampleObj.value(forKey: "Quantity_Provided") as! Int
                            let dict = ["Product_Name":productName,"Quantity_Provided":quantity] as [String : Any]
                            list.add(dict)
                        }
                    }
                    dcrDoctorProductList = NSArray(array: list)
//                    let list : NSMutableArray = []
//                    for obj in apiResponseObj.list
//                    {
//                        let sampleObj = obj as! NSDictionary
//                        let dict : NSDictionary = ["Product_Name" : sampleObj.value(forKey: "Product_Name") as? String ?? NA, "Quantity_Provided" : String(describing: sampleObj.value(forKey:"Quantity_Provided")as! Int)]
//                        list.add(dict)
//
//                    }
                    self.doctorDetailList[2].dataList = dcrDoctorProductList as NSArray
                    self.doctorDetailList[2].currentAPIStatus = APIStatus.Success
                }
                else
                {
                    self.doctorDetailList[2].currentAPIStatus = APIStatus.Failed
                }
                self.reloadTableView()
            }
        }
        else
        {
            self.setToastText(sectionType: DoctorDetailsHeaderType.Sample.rawValue)
        }
    }
    
    
    func getChemistDetailedProducts()
    {
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getDCRDetailedProductsDetailsForChemistVisit(DCRCode: DCRCode, chemistVisitCode: doctorVisitCode) { (apiResponseObj) in
                if apiResponseObj.Status == SERVER_SUCCESS_CODE
                {
                    let list : NSMutableArray = []
                    for obj in apiResponseObj.list
                    {
                        let detailObj = obj as! NSDictionary
                        let dict : NSDictionary = ["Product_Name" :detailObj.value(forKey: "Sales_Product_Name") as? String ?? NA]
                        list.add(dict)
                        
                    }
                    self.doctorDetailList[3].dataList = list as NSArray
                    self.doctorDetailList[3].currentAPIStatus = APIStatus.Success
                }
                else
                {
                    self.doctorDetailList[3].currentAPIStatus = APIStatus.Failed
                }
                self.reloadTableView()
            }
        }
        else
        {
            self.setToastText(sectionType: DoctorDetailsHeaderType.DetailedProduct.rawValue)
        }
    }
    
    
    func getChemistFollowUpDetails()
    {
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getChemistFollowUpDetails(chemistVisitCode: doctorVisitCode, userCode: DCRModel.sharedInstance.userDetail.User_Code!) { (apiResponseObj) in
                if apiResponseObj.Status == SERVER_SUCCESS_CODE
                {
                    let list : NSMutableArray = []
                    for obj in apiResponseObj.list
                    {
                        let followup = obj as! NSDictionary
                        let dict : NSDictionary = ["Tasks" : checkNullAndNilValueForString(stringData: followup.value(forKey: "Tasks") as? String),"Due_Date":checkNullAndNilValueForString(stringData: followup.value(forKey: "Due_Date") as? String)]
                        list.add(dict)
                        
                    }
                    self.doctorDetailList[5].dataList = list as NSArray
                    self.doctorDetailList[5].currentAPIStatus = APIStatus.Success
                }
                else
                {
                    self.doctorDetailList[5].currentAPIStatus = APIStatus.Failed
                }
                self.reloadTableView()
            }
        }
        else
        {
            self.setToastText(sectionType: DoctorDetailsHeaderType.FollowUps.rawValue)
        }
    }
    
    func getChemistAttachmentDetails()
    {
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getAttachmentForChemistDetails(chemistVisitCode: doctorVisitCode, userCode: DCRModel.sharedInstance.userDetail.User_Code!) { (apiResponseObj) in
                if apiResponseObj.Status == SERVER_SUCCESS_CODE
                {
                    let list : NSMutableArray = []
                    for obj in apiResponseObj.list
                    {
                        let attachmentObj = obj as! NSDictionary
                        let dict : NSDictionary = ["Uploaded_File_Name":checkNullAndNilValueForString(stringData: attachmentObj.value(forKey: "Uploaded_File_Name") as? String),"Blob_Url":checkNullAndNilValueForString(stringData: attachmentObj.value(forKey:"Blob_Url") as? String)]
                        list.add(dict)
                        
                    }
                    
                    self.doctorDetailList[6].dataList = list as NSArray
                    self.doctorDetailList[6].currentAPIStatus = APIStatus.Success
                }
                else
                {
                    self.doctorDetailList[6].currentAPIStatus = APIStatus.Failed
                }
                self.reloadTableView()
            }
        }
        else
        {
            self.setToastText(sectionType: DoctorDetailsHeaderType.ChemistVisit.rawValue)
        }
    }
    
    func getChemistRCPAOwn()
    {
        if checkInternetConnectivity()
        {
            BL_Approval.sharedInstance.getDCRRCPAProductsDetailsForChemistVisit(DCRCode:DCRCode,chemistVisitCode: doctorVisitCode) { (apiResponseObj) in
                if apiResponseObj.Status == SERVER_SUCCESS_CODE
                {
                    
                    self.doctorDetailList[4].dataList = apiResponseObj.list!
                    self.doctorDetailList[4].currentAPIStatus = APIStatus.Success
                }
                else
                {
                    self.doctorDetailList[4].currentAPIStatus = APIStatus.Failed
                }
                self.reloadTableView()
            }
        }
        else
        {
            self.setToastText(sectionType: DoctorDetailsHeaderType.ChemistVisit.rawValue)
        }
    }
    
    func getDCRChemistPOB(regionCode: String ,userCode: String , startDate: String, endDate: String)
    {
        if checkInternetConnectivity()
        {
            //start date and enddate to be in yyyy/dd/mm
            BL_Approval.sharedInstance.getPOBForChemistDetails(regionCode: regionCode ,userCode: userCode , startDate: startDate, endDate: startDate)  { (apiResponseObj) in
                if apiResponseObj.Status == SERVER_SUCCESS_CODE
                {
                    let list : NSMutableArray = []
                    var orderedPOBList : NSArray = []
                    for obj in apiResponseObj.list
                    {
                        let pobObj = obj as! NSDictionary
                        let pob = pobObj.value(forKey: "Total_Value") as! Double
                        orderedPOBList = ((pobObj as AnyObject).object(forKey: "Orderdetails") as? NSArray)!
                        let dict : NSDictionary = ["Chemist_Name" :pobObj.value(forKey: "Stockiest_Name") ?? EMPTY,"POB_Amount" :Float(pob),"DCR_Chemist_Visit_Id":pobObj.value(forKey: "No_Of_Products") as? Int ?? 0,"Orderdetails":orderedPOBList]
                        let chemistName = pobObj.value(forKey: "Customer_Name") as! String
                        if(ChemistDay.sharedInstance.customerName.uppercased() == chemistName.uppercased())
                        {
                            list.add(dict)
                        }
                    }
                    self.doctorDetailList[7].dataList = list as NSArray
                    self.doctorDetailList[7].currentAPIStatus = APIStatus.Success
                }
                else
                {
                    self.doctorDetailList[7].currentAPIStatus = APIStatus.Failed
                }
                self.reloadTableView()
            }
        }
        else
        {
            self.setToastText(sectionType: DoctorDetailsHeaderType.ChemistVisit.rawValue)
        }
    }
    
    func getDCRDoctorPOB(regionCode: String ,userCode: String , startDate: String, endDate: String)
    {
        if checkInternetConnectivity()
        {
            //start date and enddate to be in yyyy/dd/mm
            BL_Approval.sharedInstance.getPOBForDoctorDetails(regionCode: regionCode ,userCode: userCode , startDate: startDate, endDate: startDate)  { (apiResponseObj) in
                if apiResponseObj.Status == SERVER_SUCCESS_CODE
                {
                    let list : NSMutableArray = []
                    var orderedPOBList : NSArray = []
                    
                    var predicate = NSPredicate()
                    
                    if (self.doctorCode != EMPTY)
                    {
                        predicate = NSPredicate(format: "Customer_Code = %@ AND Customer_Region_Code = %@", self.doctorCode, self.doctorRegionCode)
                    }
                    else
                    {
                        predicate = NSPredicate(format: "Customer_Name = %@ AND Customer_Speciality = %@", self.doctorName, self.specialtyName)
                    }
                    
                    let filteredArray = apiResponseObj.list.filtered(using: predicate)
                    
                    for obj in filteredArray
                    {
                        let pobObj = obj as! NSDictionary
                        var pob = pobObj.value(forKey: "Total_Value") as? Double
                        if (pob == nil)
                        {
                            pob = 0.0
                        }
                        orderedPOBList = ((pobObj as AnyObject).object(forKey: "Orderdetails") as? NSArray)!
                        let dict : NSDictionary = ["Chemist_Name" :pobObj.value(forKey: "Stockiest_Name") ?? EMPTY,"POB_Amount" :Float(pob!),"DCR_Chemist_Visit_Id":pobObj.value(forKey: "No_Of_Products") as? Int ?? 0,"Orderdetails":orderedPOBList]
                        let chemistName = pobObj.value(forKey: "Customer_Name") as! String
//                        if(ChemistDay.sharedInstance.customerName.uppercased() == chemistName.uppercased())
//                        {
                            list.add(dict)
                      //  }
                    }
                    
                    self.doctorDetailList[8].dataList = list as NSArray
                    self.doctorDetailList[8].currentAPIStatus = APIStatus.Success
                }
                else
                {
                    self.doctorDetailList[8].currentAPIStatus = APIStatus.Failed
                }
                self.reloadTableView()
            }
        }
        else
        {
            self.setToastText(sectionType: DoctorDetailsHeaderType.ChemistVisit.rawValue)
        }
        
    }
    
    func getActivityDetails(regionCode: String ,userCode: String , startDate: String, endDate: String)
    {
        if checkInternetConnectivity()
        {
            BL_DCR_Refresh.sharedInstance.getDCRCallActivitesInReport(startDate:startDate, regionCode: regionCode, userCode: userCode, completion: { (apiObj) in
                
                if(apiObj.Status == SERVER_SUCCESS_CODE)
                {
                    var dcrDoctorActivityList : NSArray = []
                    let list : NSMutableArray = []
                    for (index,element) in apiObj.list.enumerated()
                    {
                       let obj = apiObj.list[index] as! NSDictionary
                        if(obj.value(forKey: "Visit_code") as! String == self.doctorVisitCode)
                        {
                            
                            let activityName = checkNullAndNilValueForString(stringData: (obj.value(forKey:  "Activity_Name") as! String))
                            let dict : NSDictionary = ["Activity_Remarks" : checkNullAndNilValueForString(stringData:(obj.value(forKey: "Activity_Remarks") as! String)),"Activity_Name":  activityName]
                            list.add(dict)
                        }
                    }
                    dcrDoctorActivityList = NSArray(array: list)
                    self.doctorDetailList[9].dataList = dcrDoctorActivityList as NSArray
                    self.doctorDetailList[9].currentAPIStatus = APIStatus.Success
                    
                }
                else
                {
                    self.doctorDetailList[9].currentAPIStatus = APIStatus.Failed
                }
                self.reloadTableView()
                
                
            })
            
        }
        else
        {
            self.setToastText(sectionType: DoctorDetailsHeaderType.ChemistVisit.rawValue)
        }
    }
    
    func getMCActivityDetails(regionCode: String ,userCode: String , startDate: String, endDate: String)
    {
        if checkInternetConnectivity()
        {
            BL_DCR_Refresh.sharedInstance.getDCRMCActivitesInReport(startDate:startDate, regionCode: regionCode, userCode: userCode, completion: { (apiObj) in
                if(apiObj.Status == SERVER_SUCCESS_CODE)
                {
                    
                    var dcrDoctorMCActivityList : NSArray = []
                    let list : NSMutableArray = []
                    for (index,element) in apiObj.list.enumerated()
                    {
                        let obj = apiObj.list[index] as! NSDictionary
                        if(obj.value(forKey: "Visit_code") as! String == self.doctorVisitCode)
                        {
                        let campaignName = checkNullAndNilValueForString(stringData: (obj.value(forKey:  "Campaign_Name") as! String))
                        let activityName = checkNullAndNilValueForString(stringData: (obj.value(forKey:  "Activity_Name") as! String))
                            let dict : NSDictionary = ["Activity_Remarks" : checkNullAndNilValueForString(stringData: (obj.value(forKey:   "MC_Remark") as? String)),"Activity_Name": campaignName + "\n" + activityName]
                            list.add(dict)
                        }
                    }
                    dcrDoctorMCActivityList = NSArray(array: list)
                    self.doctorDetailList[10].dataList = dcrDoctorMCActivityList as NSArray
                    self.doctorDetailList[10].currentAPIStatus = APIStatus.Success
                    
                }
                else
                {
                    self.doctorDetailList[10].currentAPIStatus = APIStatus.Failed
                }
                self.reloadTableView()
                
            })
            
        }
        else
        {
            self.setToastText(sectionType: DoctorDetailsHeaderType.ChemistVisit.rawValue)
        }
    }
    
    func getAttendanceActivityDetails(regionCode: String ,userCode: String , startDate: String, endDate: String)
    {
        if checkInternetConnectivity()
        {
            BL_DCR_Refresh.sharedInstance.getAttendanceDCRCallActivitesInReport(startDate:startDate, regionCode: regionCode, userCode: userCode, completion: { (apiObj) in
                
                if(apiObj.Status == SERVER_SUCCESS_CODE)
                {
                    var dcrDoctorActivityList : NSArray = []
                    let list : NSMutableArray = []
                    for (index,element) in apiObj.list.enumerated()
                    {
                        let obj = apiObj.list[index] as! NSDictionary
                        if(obj.value(forKey: "DCR_Doctor_Visit_Code") as! String == self.doctorVisitCode)
                        {
                            
                            let activityName = checkNullAndNilValueForString(stringData: (obj.value(forKey:  "Activity_Name") as! String))
                            let dict : NSDictionary = ["Activity_Remarks" : checkNullAndNilValueForString(stringData:(obj.value(forKey: "Activity_Remarks") as! String)),"Activity_Name":  activityName]
                            list.add(dict)
                        }
                    }
                    dcrDoctorActivityList = NSArray(array: list)
                    self.doctorDetailList[2].dataList = dcrDoctorActivityList as NSArray
                    self.doctorDetailList[2].currentAPIStatus = APIStatus.Success
                    
                }
                else
                {
                    self.doctorDetailList[2].currentAPIStatus = APIStatus.Failed
                }
                self.reloadTableView()
                
                
            })
            
        }
        else
        {
            self.setToastText(sectionType: DoctorDetailsHeaderType.ChemistVisit.rawValue)
        }
    }
    
    func getAttendanceMCActivityDetails(regionCode: String ,userCode: String , startDate: String, endDate: String)
    {
        if checkInternetConnectivity()
        {
            BL_DCR_Refresh.sharedInstance.getAttendanceDCRMCActivitesInReport(startDate:startDate, regionCode: regionCode, userCode: userCode, completion: { (apiObj) in
                if(apiObj.Status == SERVER_SUCCESS_CODE)
                {
                    
                    var dcrDoctorMCActivityList : NSArray = []
                    let list : NSMutableArray = []
                    for (index,element) in apiObj.list.enumerated()
                    {
                        let obj = apiObj.list[index] as! NSDictionary
                        if(obj.value(forKey: "DCR_Doctor_Visit_Code") as! String == self.doctorVisitCode)
                        {
                            let campaignName = checkNullAndNilValueForString(stringData: (obj.value(forKey:  "Campaign_Name") as! String))
                            let activityName = checkNullAndNilValueForString(stringData: (obj.value(forKey:  "Activity_Name") as! String))
                            let dict : NSDictionary = ["Activity_Remarks" : checkNullAndNilValueForString(stringData: (obj.value(forKey:   "MC_Remark") as? String)),"Activity_Name": campaignName + "\n" + activityName]
                            list.add(dict)
                        }
                    }
                    dcrDoctorMCActivityList = NSArray(array: list)
                    self.doctorDetailList[3].dataList = dcrDoctorMCActivityList as NSArray
                    self.doctorDetailList[3].currentAPIStatus = APIStatus.Success
                    
                }
                else
                {
                    self.doctorDetailList[3].currentAPIStatus = APIStatus.Failed
                }
                self.reloadTableView()
                
            })
            
        }
        else
        {
            self.setToastText(sectionType: DoctorDetailsHeaderType.ChemistVisit.rawValue)
        }
    }
    func setApiCall(indexPath : Int)
    {
        if(isFromChemistDay)
        {
            switch indexPath {
            case 0:
                getChemistVisitDetails()
            case 1:
                getChemistAccompanistsDetails()
            case 2:
                getChemistSampleDetails()
            case 3:
                getChemistDetailedProducts()
            case 4:
                getChemistRCPAOwn()
            case 5:
                getChemistFollowUpDetails()
            case 6:
                getChemistAttachmentDetails()
            case 7:
                getDCRChemistPOB(regionCode: DCRModel.sharedInstance.userDetail.Region_Code, userCode: DCRModel.sharedInstance.userDetail.User_Code, startDate: DCRModel.sharedInstance.dcrDateString, endDate: DCRModel.sharedInstance.dcrDateString)
            default:
                print("")
            }
            
            
        }
        else if isFromAttendance
        {
            switch indexPath {
            case 0:
                getAttendanceDoctorDetails()
            default:
                print("")
            }
            
        }
        else
        {
            switch indexPath {
            case 0:
                getDoctorVisitDetails()
            case 1:
                getDoctorAccompanistsDetails()
            case 2:
                getSampleDetails()
            case 3:
                getDetailedProducts()
            case 4:
                getDoctorAssetDetails()
            case 5:
                getFollowUpDetails()
            case 6:
                getAttachmentDetails()
            case 7:
                getChemistsProducts()
            case 8:
                getDCRChemistPOB(regionCode: DCRModel.sharedInstance.userDetail.Region_Code, userCode: DCRModel.sharedInstance.userDetail.User_Code, startDate: DCRModel.sharedInstance.dcrDateString, endDate: DCRModel.sharedInstance.dcrDateString)
            default:
                print("")
            }
        }
    }
    
    
    func setDetailObj(dict: NSDictionary)
    {
        var dataList : NSArray!
        let convertList : NSMutableArray = []
        var detailDict : NSDictionary = NSDictionary()
        var doctorName = checkNullAndNilValueForString(stringData:  dict.object(forKey: "Doctor_Name") as? String)
        
        if doctorName == ""
        {
            doctorName = NOT_APPLICABLE
        }
        
        if (!isFromChemistDay)
        {
            detailDict = ["SectionName" : "\(appDoctor) Name" , "SectionValue" : doctorName]
        }
        else
        {
            detailDict = ["SectionName" : "\(appChemist) Name" , "SectionValue" : doctorName]
        }
        
        convertList.add(detailDict)
        detailDict = NSDictionary()
        
//        var MDLNum = checkNullAndNilValueForString(stringData:  dict.object(forKey: "MDL_Number") as? String)
//
//        if MDLNum == ""
//        {
//            MDLNum = NOT_APPLICABLE
//        }
//
//        detailDict = ["SectionName" : "MDL Number" , "SectionValue" : MDLNum]
//        convertList.add(detailDict)
//        detailDict = NSDictionary()
        
        // organisation adding
        var hospitalName = checkNullAndNilValueForString(stringData:  dict.object(forKey: "Hospital_Name") as? String)
        
        if hospitalName == ""
        {
            hospitalName = NOT_APPLICABLE
        }
        
        detailDict = ["SectionName" : "Account Name" , "SectionValue" : hospitalName]
        convertList.add(detailDict)
        detailDict = NSDictionary()
        
        
        var splName = checkNullAndNilValueForString(stringData:  dict.object(forKey: "Speciality_Name") as? String)
        
        if splName == ""
        {
            splName = NOT_APPLICABLE
        }
        
        detailDict = ["SectionName" : "Position Name" , "SectionValue" : splName]
        convertList.add(detailDict)
        detailDict = NSDictionary()
        
        var catName = checkNullAndNilValueForString(stringData:  dict.object(forKey: "Category_Name") as? String)
        
        if catName == ""
        {
            catName = NOT_APPLICABLE
        }
        
        detailDict = ["SectionName" : "Category Name" , "SectionValue" : catName]
        convertList.add(detailDict)
        detailDict = NSDictionary()
        
        let visitMode = checkNullAndNilValueForString(stringData:  dict.object(forKey: "Visit_Mode") as? String)
        
        if visitMode != ""
        {
            detailDict = ["SectionName" : "Visit Mode / Time" , "SectionValue" : "\(visitMode)"]
        }
        let visitTime = checkNullAndNilValueForString(stringData:  dict.object(forKey: "Visit_Time") as? String)
        
        if visitTime != ""
        {
            detailDict = ["SectionName" : "Visit Mode / Time" , "SectionValue" : "\(visitTime)"]
        }
        
        if visitMode == "" && visitTime == ""
        {
            detailDict = ["SectionName" : "Visit Mode / Time" , "SectionValue" : NOT_APPLICABLE]
        }
        
        convertList.add(detailDict)
        
        if (!isFromChemistDay)
        {
            detailDict = NSDictionary()
            
            var POBAmt = checkNullAndNilValueForString(stringData:  dict.object(forKey: "POB_Amount") as? String)
            
            if POBAmt == ""
            {
                POBAmt = "0.0"
            }
            
            detailDict = ["SectionName" : "POB Amount" , "SectionValue" : POBAmt]
            convertList.add(detailDict)
        }
        
        detailDict = NSDictionary()
        var remarks = checkNullAndNilValueForString(stringData:  dict.object(forKey: "Remarks") as? String)
        
        if remarks == ""
        {
            remarks = NOT_APPLICABLE
        }
        
        detailDict = ["SectionName" : "Remarks" , "SectionValue" : remarks]
        convertList.add(detailDict)
        
        if (!isFromChemistDay)
        {
            let businessStatus = checkNullAndNilValueForString(stringData:  dict.object(forKey: "Status_Name") as? String)
            detailDict = NSDictionary()
            detailDict = ["SectionName" : "Business Status" , "SectionValue" : businessStatus]
            convertList.add(detailDict)
            
            let callObjective = checkNullAndNilValueForString(stringData:  dict.object(forKey: "Call_Objective_Name") as? String)
            detailDict = NSDictionary()
            detailDict = ["SectionName" : "Call Objective" , "SectionValue" : callObjective]
            convertList.add(detailDict)
            
            let campaignName = checkNullAndNilValueForString(stringData:  dict.object(forKey: "Campaign_Name") as? String)
            detailDict = NSDictionary()
            detailDict = ["SectionName" : "Campaign Name" , "SectionValue" : campaignName]
            convertList.add(detailDict)
            
            if (checkNullAndNilValueForString(stringData: dict.value(forKey: "Geo_Fencing_Deviation_Remarks") as? String) != EMPTY)
            {
                detailDict = NSDictionary()
                detailDict = ["SectionName" : "Geo Fencing Deviation Reason" , "SectionValue" : dict.value(forKey: "Geo_Fencing_Deviation_Remarks") as! String]
                convertList.add(detailDict)
            }
            if (checkNullAndNilValueForString(stringData: dict.value(forKey: "Punch_Start_Time") as? String) != EMPTY)
            {
                detailDict = NSDictionary()
                detailDict = ["SectionName" : "Check In Time" , "SectionValue" : stringFromDate(date1: getDateFromString(dateString: dict.value(forKey: "Punch_Start_Time") as! String)) as! String]
                convertList.add(detailDict)
            
            if (checkNullAndNilValueForString(stringData: dict.value(forKey: "Punch_End_Time") as? String) != EMPTY)
            {
                detailDict = NSDictionary()
                detailDict = ["SectionName" : "Check Out Time" , "SectionValue" : stringFromDate(date1: getDateFromString(dateString: dict.value(forKey: "Punch_End_Time") as! String)) as! String]
                convertList.add(detailDict)
            }
                else
            {
                detailDict = ["SectionName" : "Check Out Time" , "SectionValue" : "N/A" as! String]
                convertList.add(detailDict)
                }
            }
            
            if (checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Met_StartTime") as? String) != EMPTY)
            {
                detailDict = NSDictionary()
                detailDict = ["SectionName" : "Check In Time" , "SectionValue" : stringFromDate(date1: getDateFromString(dateString: dict.value(forKey: "Customer_Met_StartTime") as! String)) as! String]
                convertList.add(detailDict)
            
            if (checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Met_EndTime") as? String) != EMPTY)
            {
                detailDict = NSDictionary()
                detailDict = ["SectionName" : "Check Out Time" , "SectionValue" :stringFromDate(date1: getDateFromString(dateString: dict.value(forKey: "Customer_Met_EndTime") as! String))  as! String]
                convertList.add(detailDict)
            }
                else
            {
                detailDict = ["SectionName" : "Check Out Time" , "SectionValue" : "N/A" as! String]
                convertList.add(detailDict)
                }
            }
        }
        
        dataList = NSArray(array: convertList)
        doctorDetailList[0].dataList = dataList
        
        if let dcrId = dict.value(forKey: "DCR_Id") as? Int
        {
            self.dcrId = dcrId
            DCRModel.sharedInstance.dcrId = self.dcrId
        }
        
        if let doctorVisitId = dict.value(forKey: "DCR_Doctor_Visit_Id") as? Int
        {
            self.doctorVisitId = doctorVisitId
            DCRModel.sharedInstance.doctorVisitId = self.doctorVisitId
        }
        
        self.doctorCode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Code") as? String)
        self.doctorRegionCode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Region_Code") as? String)
        self.doctorName = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Name") as? String)
        self.specialtyName = checkNullAndNilValueForString(stringData: dict.value(forKey: "Speciality_Name") as? String)
        
        if let chemistVisitId = dict.value(forKey: "Chemist_Visit_Id") as? Int
        {
            self.chemistVisitId = chemistVisitId
            ChemistDay.sharedInstance.chemistVisitId = self.chemistVisitId
        }
    }
    
    // Table view delegates
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return doctorDetailList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.DoctorDetailsSectionCell) as! ApprovalSectionHeaderCell
        
        let obj = doctorDetailList[section]
        cell.titleLabel.text = obj.sectionTitle
        cell.imgView.image = UIImage(named: obj.titleImage)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let detail = doctorDetailList[indexPath.section]
        
        if detail.currentAPIStatus == APIStatus.Loading
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.DoctorVisitLoadingCell, for: indexPath) as! ApprovalLoadingTableViewCell
            return cell
        }
        else if detail.currentAPIStatus == APIStatus.Failed
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.DoctorVisitEmptyStateRetryCell, for: indexPath)
            return cell
        }
        else if detail.dataList.count > 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.ApprovalDoctorDetailMainCell, for: indexPath) as! ApprovalDoctorDetailMainTableViewCell
            cell.dataList = detail.dataList
            cell.sectionType = detail.sectionViewType
            cell.isFromChemistDay = isFromChemistDay
            cell.delegate = self
            cell.pobDelegate = self
            cell.isFromAttendance = isFromAttendance
            cell.subTableView.reloadData()
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.DoctorDetailsEmptyStateCell, for: indexPath) as! ApprovalEmptyStateTableViewCell
            
            cell.emptyStateTiltleLbl.text = detail.emptyStateText
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let detail = doctorDetailList[indexPath.section]
        let dataList = detail.dataList
        let defaultHeight : CGFloat  = 8
       
        if isFromAttendance
        {
            if detail.currentAPIStatus == APIStatus.Loading
            {
                return BL_Approval.sharedInstance.getLoadingCellHeight()
            }
            else if detail.currentAPIStatus == APIStatus.Failed
            {
                
                return BL_Approval.sharedInstance.getEmptyStateRetryCellHeight()
            }
            else if detail.dataList.count == 0
            {
                return BL_Approval.sharedInstance.getEmptyStateCellHeight()
            }
            else
            {
                return BL_Approval.sharedInstance.getCommonAttendanceDoctorCellHeight(dataList: dataList, sectionType: detail.sectionViewType.rawValue) + defaultHeight
            }
        }
        else
        {
            if detail.currentAPIStatus == APIStatus.Loading
            {
                return BL_Approval.sharedInstance.getLoadingCellHeight()
            }
            else if detail.currentAPIStatus == APIStatus.Failed
            {
                
                return BL_Approval.sharedInstance.getEmptyStateRetryCellHeight()
            }
            else if detail.dataList.count == 0
            {
                return BL_Approval.sharedInstance.getEmptyStateCellHeight()
            }
            else if detail.sectionViewType == DoctorDetailsHeaderType.DetailedProduct
            {
                return BL_Approval.sharedInstance.getCommonDoctorCellHeight(dataList: dataList, sectionType: detail.sectionViewType.rawValue,fromChemistDay:isFromChemistDay) - 4
            }
            else if (detail.sectionViewType == DoctorDetailsHeaderType.DigitalAssets && isFromChemistDay == false)
            {
                return BL_Approval.sharedInstance.getCommonDoctorAssetCellHeight(dataList: dataList)
            }
            else
            {
                return BL_Approval.sharedInstance.getCommonDoctorCellHeight(dataList: dataList, sectionType: detail.sectionViewType.rawValue, fromChemistDay: isFromChemistDay) + defaultHeight
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var detail = doctorDetailList[indexPath.section]
        
        if detail.currentAPIStatus == APIStatus.Failed
        {
            detail.currentAPIStatus = APIStatus.Loading
            reloadTableView()
            setApiCall(indexPath: indexPath.section)
        }
    }
    
    
    func reloadTableView()
    {
        self.mainTableView.reloadData()
    }
    
    private func setToastText(sectionType : Int)
    {
        switch sectionType
        {
        case DoctorDetailsHeaderType.DoctorVisit.rawValue:
            showToastView(toastText: "Problem in getting \(appDoctor) Visit Details")
            
        case DoctorDetailsHeaderType.Accompanist.rawValue:
            showToastView(toastText: "Problem in getting Ride Along Details")
            
        case DoctorDetailsHeaderType.Sample.rawValue:
            showToastView(toastText: "Problem in getting sample list")
            
        case DoctorDetailsHeaderType.DetailedProduct.rawValue:
            showToastView(toastText: "Problem in getting detailed product Details")
        case DoctorDetailsHeaderType.DigitalAssets.rawValue:
            showToastView(toastText: "Problem in getting digital resource Details")
        case DoctorDetailsHeaderType.FollowUps.rawValue:
            showToastView(toastText: "Problem in getting followup details")
        case DoctorDetailsHeaderType.ChemistVisit.rawValue:
            showToastView(toastText: "Problem in getting \(appChemist) visit details")
        case DoctorDetailsHeaderType.ChemistVisit.rawValue:
            showToastView(toastText: "Problem in getting \(appChemist) visit Details")
            
        default :
            showToastView(toastText: "Problem in getting Details.")
        }
    }
    
    func getSelectedChemistDetails(chemistVisitCode: String , chemistVisitId  :Int ,isChemistDay :Bool, ownProductId : Int)
    {
        let sb = UIStoryboard(name: ApprovalSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.ApprovalRCPAVcID) as! ApprovalRCPADetailsViewController
        
        if (isFromChemistDay)
        {
            vc.chemistVisitId = Int(doctorVisitCode)
            vc.doctorVisitCode = doctorVisitCode
            vc.DCRCode = DCRCode
            vc.ownProductId = ownProductId
            vc.isFromChemist = true
            
        }
        else
        {
            vc.chemistVisitCode = chemistVisitCode
            vc.doctorVisitCode = doctorVisitCode
            vc.DCRCode = DCRCode
            vc.chemistVisitId = chemistVisitId
            vc.ownProductId = 0
            vc.isFromChemist = false
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func getSelectedChemistPobDetails(dataList: NSArray, isFromChemistPob: Bool) {
       
        let sb = UIStoryboard(name: ApprovalSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.ApprovalRCPAVcID) as! ApprovalRCPADetailsViewController
        vc.chemistPobDataList = dataList
        vc.isFromChemistPob = isFromChemistPob
        self.navigationController?.pushViewController(vc, animated: true)
        
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
}


