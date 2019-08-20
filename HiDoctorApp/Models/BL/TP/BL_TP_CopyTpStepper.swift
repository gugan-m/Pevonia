//
//  BL_TP_CopyTpStepper.swift
//  HiDoctorApp
//
//  Created by swaasuser on 18/08/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class BL_TP_CopyTpStepper: NSObject {
    
    static let sharedInstance = BL_TP_CopyTpStepper()
    
    var showCopyTp = Int()
    var stepperDataList: [TPCopyStepperModel] = []
    var tourPlanHeaderAcc: [CopyTPAccHeaderModel] = []
    var tourPlannerSFCAcc: [CopyTpAccSFC] = []
    var tourPlannerDoctorDetailsAcc : [CopyAccDoctorDetails] = []
    var callObjectDataList: [HeaderCallObjModel] = []
    
    func getTourPlanDetails()
    {
        let callObj:TPCopyStepperModel = TPCopyStepperModel()
        callObj.sectionTitle = "Tour Plan Details"
        callObj.sectionIconName = "icon-stepper-work-area"
        callObj.recordCount = self.tourPlanHeaderAcc.count
        print(callObj.recordCount)
        stepperDataList.append(callObj)
    }
    
    func getPlacedetails()
    {
        let callObj:TPCopyStepperModel = TPCopyStepperModel()
        callObj.sectionTitle = "Place Details"
        callObj.sectionIconName = "icon-stepper-sfc"
        callObj.recordCount = self.tourPlannerSFCAcc.count
        stepperDataList.append(callObj)
    }
    
    func getDoctorDetails()
    {
        let callObj:TPCopyStepperModel = TPCopyStepperModel()
        callObj.sectionTitle = "\(appDoctor) Details"
        callObj.sectionIconName = "icon-stepper-two-user"
        callObj.recordCount = self.tourPlannerDoctorDetailsAcc.count
        stepperDataList.append(callObj)
    }
    func getHeaderCallObjModel()
    {
        var callObjectModel = HeaderCallObjModel()
        callObjectModel = HeaderCallObjModel()
        callObjectModel.objTitle = "Call Objective"
        callObjectModel.objName = "Field"
        callObjectDataList.append(callObjectModel)
    }
    
    func getWorkCategory()
    {
        var callObjectModel = HeaderCallObjModel()
        callObjectModel = HeaderCallObjModel()
        callObjectModel.objTitle = "Work Category"
        if tourPlanHeaderAcc.count > 0
        {
            if(checkNullAndNilValueForString(stringData: tourPlanHeaderAcc[0].work_Category_Name!) != "")
            {
                callObjectModel.objName = tourPlanHeaderAcc[0].work_Category_Name!
            }
            else
            {
                callObjectModel.objName = NOT_APPLICABLE
            }
        }
        else
        {
            callObjectModel.objName = NOT_APPLICABLE
        }
        callObjectDataList.append(callObjectModel)
        
    }
    
    func generateDataArray()
    {
        getTourPlanDetails()
        getPlacedetails()
        getDoctorDetails()
        getHeaderCallObjModel()
        getWorkCategory()
        
    }
    func clearArray()
    {
        stepperDataList = []
        tourPlanHeaderAcc = []
        tourPlannerSFCAcc = []
        tourPlannerDoctorDetailsAcc = []
        callObjectDataList = []
    }
    
    //MARK:- Webservice Call
    func postCopyTourPlanAccompanistDetails(user_code : String, start_Date: String, end_Date: String, region_Code: String, completion: @escaping (_ StatusMsg:String,_ Status: Int, _ list:NSArray) -> ())
    {
        self.showCopyTp = 0
        WebServiceHelper.sharedInstance.postCopyTourPlanAccompanist(postData: getCopyTourPlanAccPostData(user_Code: user_code , start_Date: start_Date, end_Date : end_Date ,region_Code: region_Code), urlString: wsRootUrl + wsTourPlannerAccUserTPHeaderDetails) { (apiResponseObj) in
            
            if apiResponseObj.Status == SERVER_SUCCESS_CODE
            {
                self.clearArray()
                for value   in apiResponseObj.list
                {
                    let obj = value as! NSDictionary
                    let headermodel = CopyTPAccHeaderModel()
                    
                    headermodel.call_Objective = "Call Objective"
                    headermodel.activity_Type = "Field"
                    headermodel.work_Category_Name = obj.value(forKey: "Category_Name") as? String
                    headermodel.cp_Code = checkNullAndNilValueForString(stringData: obj.value(forKey: "CP_Code") as? String)
                    headermodel.cp_Name = checkNullAndNilValueForString(stringData: obj.value(forKey: "CP_Name") as? String)
                    headermodel.tp_Id = obj.value(forKey: "TP_Id") as? Int ?? 0
                    headermodel.work_Area = checkNullAndNilValueForString(stringData: obj.value(forKey: "Work_Area") as? String)
                    headermodel.tp_Status = obj.value(forKey: "TP_Status") as? Int ?? 0
                    headermodel.activity_Code = checkNullAndNilValueForString(stringData: obj.value(forKey: "Activity_Code") as? String)
                    headermodel.activity_Name = checkNullAndNilValueForString(stringData: obj.value(forKey: "Activity_Name") as? String)
                    headermodel.project_Code = checkNullAndNilValueForString(stringData: obj.value(forKey: "Project_Code") as? String)
                    headermodel.tp_Date = checkNullAndNilValueForString(stringData: obj.value(forKey:  "TP_Date") as? String)
                    headermodel.cp_Id = obj.value(forKey: "CP_Id") as? Int ?? 0
                    headermodel.category_Code = checkNullAndNilValueForString(stringData: obj.value(forKey: "Category_Code") as? String)
                    headermodel.activity = checkNullAndNilValueForString(stringData: obj.value(forKey: "Activity") as? String)
                    headermodel.tp_Day = checkNullAndNilValueForString(stringData: obj.value(forKey: "TP_Day" ) as? String)
                    headermodel.meeting_Place = checkNullAndNilValueForString(stringData: obj.value(forKey: "Meeting_Place" ) as? String)
                    headermodel.meeting_Time = checkNullAndNilValueForString(stringData: obj.value(forKey: "Meeting_Time") as? String)
                    headermodel.UnApprove_Reason = checkNullAndNilValueForString(stringData: obj.value(forKey: "UnApprove_Reason") as? String)
                    headermodel.tp_ApprovedBy = checkNullAndNilValueForString(stringData: obj.value(forKey: "TP_ApprovedBy") as? String)
                    headermodel.approved_Date = checkNullAndNilValueForString(stringData: obj.value(forKey: "Approved_Date") as? String)
                    headermodel.is_Weekend = obj.value(forKey: "Is_Weekend") as? Int ?? 0
                    headermodel.is_Holiday = obj.value(forKey: "Is_Holiday") as? Int ?? 0
                    headermodel.copyAccess = obj.value(forKey: "CopyAccess") as? Int ?? 0
                    headermodel.remarks = checkNullAndNilValueForString(stringData: obj.value(forKey: "Remarks") as? String)
                    
                    self.tourPlanHeaderAcc.append(headermodel)
                    
                    if(self.tourPlanHeaderAcc.count > 0)
                    {
                        self.showCopyTp += 1
                    }
                }
                
                WebServiceHelper.sharedInstance.postCopyTourPlanAccompanist(postData: self.getCopyTourPlanAccPostData(user_Code: user_code , start_Date: start_Date, end_Date : end_Date ,region_Code: region_Code), urlString: wsRootUrl + wsTourPlannerAccUserTPSFCDetails) {(apiResponseObj) in
                    if apiResponseObj.Status == SERVER_SUCCESS_CODE
                    {
                        for value in apiResponseObj.list
                        {
                            print(apiResponseObj.list)
                            let obj = value as! NSDictionary
                            var sfcModel = CopyTpAccSFC()
                            sfcModel.company_Code = obj.value(forKey: "Company_Code") as? String
                            sfcModel.from_Place = obj.value(forKey:  "From_Place") as? String
                            sfcModel.to_Place = obj.value(forKey: "To_Place") as? String
                            let distance = obj.value(forKey: "Distance") as? CGFloat ?? 0
                            sfcModel.distance = "\(distance)"
                            sfcModel.distance_Fare_Code = obj.value(forKey: "Distance_Fare_Code") as? String
                            sfcModel.project_Code = obj.value(forKey: "Project_Code") as? String
                            sfcModel.route_Way = obj.value(forKey:  "Route_Way") as? String
                            sfcModel.sfc_Category_Name = obj.value(forKey: "SFC_Category_Name") as? String
                            sfcModel.sfc_Code = obj.value(forKey: "SFC_Code") as? String
                            sfcModel.sfc_Region_Code = obj.value(forKey: "SFC_Region_Code") as? String
                            sfcModel.sfc_Version = obj.value(forKey: "SFC_Version") as? String
                            sfcModel.tp_Date = obj.value(forKey: "TP_Date") as? String
                            sfcModel.tp_Id = obj.value(forKey:  "TP_Id") as? Int
                            sfcModel.tp_SFC_Id = obj.value(forKey: "TP_SFC_Id") as!Int
                            sfcModel.travel_Mode = obj.value(forKey: "Travel_Mode") as? String
                            
                            self.tourPlannerSFCAcc.append(sfcModel)
                            
                            if(self.tourPlannerSFCAcc.count>0)
                            {
                                self.showCopyTp += 1
                            }
                        }
                        
                        WebServiceHelper.sharedInstance.postCopyTourPlanAccompanist(postData: self.getCopyTourPlanAccPostData(user_Code: user_code , start_Date: start_Date, end_Date : end_Date ,region_Code: region_Code), urlString: wsRootUrl + wsTourPlannerAccUserTPDoctorsDetails) {(apiResponseObj) in
                            if apiResponseObj.Status == SERVER_SUCCESS_CODE
                            {
                                for value in apiResponseObj.list
                                {
                                    
                                    let obj = value as! NSDictionary
                                    var doctorModel = CopyAccDoctorDetails()
                                    doctorModel.doctor_Name = obj.value(forKey: "Doctor_Name") as? String
                                    doctorModel.doctorSpeciality = obj.value(forKey: "Speciality_Name") as? String
                                    doctorModel.tp_Id = obj.value(forKey: "TP_Id") as! Int
                                    doctorModel.tp_Doctor_Id = obj.value(forKey: "TP_Doctor_Id") as! Int
                                    doctorModel.doctor_Code = obj.value(forKey: "Doctor_Code") as? String
                                    doctorModel.doctor_Region_Code = obj.value(forKey: "Doctor_Region_Code") as? String
                                    doctorModel.mdl = obj.value(forKey: "MDL") as? String
                                    doctorModel.region_Code = obj.value(forKey: "Region_Code") as? String
                                    doctorModel.region_Name = obj.value(forKey: "Region_Name") as? String
                                    doctorModel.category_Name = obj.value(forKey: "Category_Name") as? String
                                    doctorModel.category_Code = obj.value(forKey: "SFC_Category_Name") as? String
                                    doctorModel.Hospital_Name = obj.value(forKey: "Hospital_Name") as? String
                                    self.tourPlannerDoctorDetailsAcc.append(doctorModel)
                                    
                                }
                                completion(apiResponseObj.Message,apiResponseObj.Status,apiResponseObj.list)
                            }
                            else
                            {
                                completion(apiResponseObj.Message,apiResponseObj.Status,apiResponseObj.list)
                            }}
                        
                    }
                    else
                    {
                        completion(apiResponseObj.Message,apiResponseObj.Status,apiResponseObj.list)
                    }}
                
            }
            else
            {
                completion(apiResponseObj.Message,apiResponseObj.Status,apiResponseObj.list)
            }}
    }
    
    //MARK:- PostData for CopyAccompanist details
    func getCopyTourPlanAccPostData(user_Code: String , start_Date: String, end_Date : String ,region_Code: String) -> [String: Any]
    {
        return ["CompanyCode": getCompanyCode() , "UserCode": user_Code , "RegionCode": region_Code , "StartDate": start_Date , "EndDate": end_Date , "TPStatus": "1" , "Flag" : "1"]
    }
    
    
    //MARK:- Tableview height functions
    func getDefaultCellHeight() -> CGFloat
    {
        return 40.0
    }
    
    //MARK:- ChildTableview Cell Height functions
    func getChildTPTravelDetailsCellHeight() -> CGFloat
    {
        return 100.0
    }
    
    func getChildDoctorDetailsCellHeight(selectedIndex : Int) -> CGFloat
    {
        var totalHeight:CGFloat = 0
        if tourPlannerDoctorDetailsAcc.count > 0
        {
        let doctorObjModel = BL_TP_CopyTpStepper.sharedInstance.tourPlannerDoctorDetailsAcc[selectedIndex]
            let strHospitalName = checkNullAndNilValueForString(stringData: doctorObjModel.Hospital_Name!) as? String
            let str = String(format: "%@ | %@ | %@ | %@ | %@", strHospitalName!, doctorObjModel.mdl, doctorObjModel.doctorSpeciality, doctorObjModel.category_Name, doctorObjModel.doctor_Region_Code)
        let titleLabelHeight: CGFloat = getTextSize(text: str, fontName: fontRegular, fontSize: 14, constrainedWidth: (SCREEN_WIDTH - (49 + 8))).height
        let singleCellHeight:CGFloat = 48.0
        totalHeight = (singleCellHeight + titleLabelHeight)
        }
        return totalHeight
    }
    
    func getChildTPActivityCellHeight() -> CGFloat
    {
        return 60.0
    }
    
    //MARK:- MainTableview Cell Height Functions
    
    func getTourPlanCellHeight() -> CGFloat
    {
        let defaultHeight:CGFloat = getDefaultCellHeight()
        let singleCellHeight:CGFloat = getChildTPActivityCellHeight()
        let cellCount:CGFloat = CGFloat(BL_TP_CopyTpStepper.sharedInstance.callObjectDataList.count)
        print(tourPlanHeaderAcc.count)
        let totalHeight:CGFloat = (singleCellHeight * cellCount) + defaultHeight
        return totalHeight
    }
    
    func getPlaceDetailsCellHeight(selectedIndex: Int) -> CGFloat
    {
        
        let stepperObj: TPCopyStepperModel = BL_TP_CopyTpStepper.sharedInstance.stepperDataList[selectedIndex]
        let defaultHeight:CGFloat = getDefaultCellHeight()
        let singleCellHeight:CGFloat = getChildTPTravelDetailsCellHeight()
        let cellCount:CGFloat = CGFloat(BL_TP_CopyTpStepper.sharedInstance.tourPlannerSFCAcc.count)
        let totalHeight:CGFloat = (singleCellHeight * cellCount) + defaultHeight
        return totalHeight
    }
    func getDoctorDetailsCellHeight(selectedIndex: Int) -> CGFloat
    {
        var totalHeight: CGFloat = 0
        if tourPlannerDoctorDetailsAcc.count > 0
        {
        let stepperObj: TPCopyStepperModel = BL_TP_CopyTpStepper.sharedInstance.stepperDataList[selectedIndex]
        let defaultHeight: CGFloat = 45.0
        let cellCount = stepperObj.recordCount
        var singleCellHeight: CGFloat =  0
        
        for var i in 0..<cellCount
        {
            singleCellHeight += getChildDoctorDetailsCellHeight(selectedIndex: i)
        }
        
        totalHeight = singleCellHeight + defaultHeight
        return totalHeight
        }
        return totalHeight
    }
    
    func insertAccompanistDetails()
    {
        var sfcArray:[NSMutableDictionary] = []
        
        for value in tourPlannerSFCAcc
        {
            let obj = value
            let dictionary : NSMutableDictionary = [:]
            dictionary.setValue(TPModel.sharedInstance.tpId, forKey: "TP_Id")
            dictionary.setValue(TPModel.sharedInstance.tpEntryId, forKey: "TP_Entry_Id")
            dictionary.setValue(obj.tp_SFC_Id, forKey: "TP_SFC_Id")
            dictionary.setValue(obj.to_Place, forKey: "To_Place")
            dictionary.setValue(obj.from_Place, forKey: "From_Place")
            dictionary.setValue(obj.distance, forKey: "Distance")
            dictionary.setValue(obj.travel_Mode, forKey: "Travel_Mode")
            dictionary.setValue(obj.distance_Fare_Code, forKey: "Distance_fare_Code")
            dictionary.setValue(obj.sfc_Category_Name, forKey: "SFC_Category_Name")
            dictionary.setValue(obj.sfc_Version, forKey: "SFC_Version")
            dictionary.setValue(obj.sfc_Region_Code, forKey: "Region_Code")
            sfcArray.append(dictionary)
        }
        
        DAL_TP_Stepper.sharedInstance.insertAccomapanistSFC(dictArray: sfcArray)
        
        var docArray:[NSMutableDictionary] = []
        
        if tourPlannerDoctorDetailsAcc.count > 0
        {
            for value in tourPlannerDoctorDetailsAcc
            {
                let obj = value
                let dictionary : NSMutableDictionary = [:]
                dictionary.setValue(TPModel.sharedInstance.tpId, forKey: "TP_Id")
                dictionary.setValue(TPModel.sharedInstance.tpEntryId, forKey: "TP_Entry_Id")
                dictionary.setValue(obj.tp_Doctor_Id, forKey: "TP_Doctor_Id")
                dictionary.setValue(obj.doctor_Code, forKey: "Doctor_Code")
                dictionary.setValue(obj.doctor_Region_Code, forKey: "Doctor_Region_Code")
                dictionary.setValue(obj.doctor_Name, forKey: "Doctor_Name")
                dictionary.setValue(obj.doctorSpeciality, forKey: "Speciality_Name")
                dictionary.setValue(obj.mdl, forKey: "MDL_Number")
                dictionary.setValue(obj.category_Code, forKey: "Category_Code")
                dictionary.setValue(obj.category_Name, forKey: "Category_Name")
                dictionary.setValue(obj.region_Name, forKey: "Doctor_Region_Name")
                dictionary.setValue(obj.Hospital_Name, forKey: "Hospital_Name")
                docArray.append(dictionary)
                
            }
            DAL_TP_Stepper.sharedInstance.insertAccomapanistDoctorDetails(dictArray: docArray)
        }
    }
    
    func updateAccHeaderDetails(tp_Entry_Id: Int, cp_Code: String, category_Code: String, work_Place: String, cp_Name: String, meeting_Place: String, meeting_Time: String, category_Name: String, remarks: String)
    {
        DAL_TP_Stepper.sharedInstance.updateHeaderDetailsFromAccHeader(tp_Entry_Id: tp_Entry_Id, cp_Code: cp_Code, category_Code: category_Code, work_Place: work_Place, cp_Name: cp_Name, meeting_Place: meeting_Place, meeting_Time: meeting_Time, category_Name: category_Name, remarks: remarks)
    }
    
    func deleteCopiedAccompanistSFC(tp_Entry_Id: Int)
    {
        DAL_TP_Stepper.sharedInstance.deleteCopiedAccDoctorSamples(tp_Entry_Id: tp_Entry_Id)
        DAL_TP_Stepper.sharedInstance.deleteCopiedAccSFC(tp_Entry_Id: tp_Entry_Id)
    }
    func deleteCopiedAccompanistDoctor(tp_Entry_Id: Int)
    {
        DAL_TP_Stepper.sharedInstance.deleteCopiedAccDoctorDetails(tp_Entry_Id: tp_Entry_Id)
    }
    
}

class TPCopyStepperModel : NSObject
{
    var sectionTitle : String!
    var sectionIconName : String!
    var recordCount: Int = 0
}

class CopyTPAccHeaderModel: NSObject
{
    var call_Objective : String!
    var activity_Type : String!
    var work_Category : String!
    var work_Category_Name : String!
    var cp_Code: String!
    var cp_Name: String!
    var tp_Id: Int!
    var work_Area: String!
    var tp_Status: Int!
    var activity_Code: String!
    var activity_Name: String!
    var project_Code: String!
    var tp_Date: String!
    var cp_Id: Int!
    var category_Code: String!
    var activity: String!
    var tp_Day: String!
    var meeting_Place: String?
    var meeting_Time: String?
    var UnApprove_Reason:String?
    var tp_ApprovedBy: String!
    var approved_Date: String!
    var is_Weekend: Int!
    var is_Holiday: Int!
    var copyAccess: Int!
    var remarks: String?
    
    
}

class CopyTpAccSFC : NSObject
{
    var company_Code: String?
    var from_Place : String!
    var to_Place : String!
    var distance : String!
    var sfc_Code : String!
    var travel_Mode : String!
    var distance_Fare_Code : String!
    var route_Way : String?
    var sfc_Category_Name : String!
    var sfc_Region_Code: String!
    var sfc_Version: String!
    var project_Code:String?
    var tp_Date: String!
    var tp_Id: Int!
    var tp_SFC_Id: Int!
    
}

class CopyAccDoctorDetails : NSObject
{
    var doctor_Name: String!
    var doctorSpeciality: String!
    var tp_Id: Int!
    var tp_Doctor_Id: Int!
    var doctor_Code: String!
    var doctor_Region_Code:  String!
    var mdl:  String!
    var region_Code:  String?
    var region_Name:  String!
    var category_Name:  String!
    var category_Code: String?
    var Hospital_Name: String?
}

class HeaderCallObjModel
{
    var objTitle: String!
    var objName: String!
}


