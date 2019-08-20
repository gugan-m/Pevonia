//
//  DCRDoctorVisitModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 08/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class DCRDoctorVisitModel: Record
{
    var DCR_Doctor_Visit_Id: Int!
    var DCR_Doctor_Visit_Code: String!
    var Customer_Entity_Type: String!
    var DCR_Actual_Date: String = EMPTY
    var DCR_Id: Int!
    var DCR_Code: String!
    var Doctor_Id: Int?
    var Doctor_Code: String?
    var Doctor_Region_Code: String?
    var Doctor_Name: String!
    var Speciality_Name: String!
    var MDL_Number: String?
    var Category_Code: String?
    var Category_Name: String?
    var Visit_Mode: String!
    var Visit_Time: String?
    var POB_Amount: Double?
    var Is_CP_Doctor: Int?
    var Is_Acc_Doctor: Int?
    var Remarks: String?
    var Lattitude: String?
    var Longitude: String?
    //    var Region_Name: String?
    var Doctor_Region_Name: String?
    var Local_Area: String?
    var Sur_Name: String?
    var Geo_Fencing_Deviation_Remarks: String!
    var Geo_Fencing_Page_Source: String!
    var Business_Status_ID: Int!
    var Business_Status_Active_Status: Int!
    var Business_Status_Name: String!
    var Call_Objective_ID: Int!
    var Call_Objective_Active_Status: Int!
    var Call_Objective_Name: String!
    var Is_DCR_Inherited_Doctor: Int!
    var Campaign_Code: String!
    var Campaign_Name: String!
    var Punch_Start_Time: String?
    var Punch_End_Time: String?
    var Punch_Status: Int?
    var Punch_Offset: String?
    var Punch_TimeZone: String?
    var Punch_UTC_DateTime: String?
    var Hospital_Name: String!
  //  var Hospital_Account_Number: String!
    
    init(dict: NSDictionary)
    {
        self.DCR_Doctor_Visit_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Visit_Code") as? String)
        self.DCR_Id = Int(dict.value(forKey: "DCR_Id") as! String)
        self.DCR_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Code") as? String)
        
        if let doctorId = dict.value(forKey: "Doctor_Id") as? Int
        {
            self.Doctor_Id = doctorId
        }
        
        self.DCR_Actual_Date = EMPTY
        if let dcrActualDate = dict.value(forKey: "DCR_Actual_Date") as? String
        {
            self.DCR_Actual_Date = dcrActualDate
        }
        
        self.Doctor_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Code") as? String)
        self.Doctor_Region_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Region_Code") as? String)
        self.Doctor_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Name") as? String)
        self.Speciality_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Speciality_Name") as? String)
        self.MDL_Number = checkNullAndNilValueForString(stringData: dict.value(forKey: "MDL_Number") as? String)
        self.Category_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Category_Code") as? String)
        self.Category_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Category_Name") as? String)
        self.Visit_Mode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Visit_Mode") as? String)
        self.Visit_Time = checkNullAndNilValueForString(stringData: dict.value(forKey: "Visit_Time") as? String)
        let pobAmount = checkNullAndNilValueForString(stringData: dict.value(forKey: "POB_Amount") as? String)
        self.Customer_Entity_Type = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Entity_Type") as? String)
        self.Hospital_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Hospital_Name") as? String)
    //    self.Hospital_Account_Number = checkNullAndNilValueForString(stringData: dict.value(forKey: "Hospital_Account_Number") as? String)
        
        if (pobAmount != EMPTY)
        {
            self.POB_Amount = Double(pobAmount)
        }
        else
        {
            self.POB_Amount = 0
        }
        
        if let isCPDoctor = dict.value(forKey: "Is_CP_Doc") as? Int
        {
            self.Is_CP_Doctor = isCPDoctor
        }
        else
        {
            self.Is_CP_Doctor = 0
        }
        
        if let isAccDoctor = dict.value(forKey: "Is_Acc_Doctor") as? Int
        {
            self.Is_Acc_Doctor = isAccDoctor
        }
        else
        {
            self.Is_Acc_Doctor = 0
        }
        
        let visitTime = self.Visit_Time
        
        if (visitTime != EMPTY)
        {
            if (visitTime!.contains(AM) == false) && (visitTime!.contains(PM) == false)
            {
                self.Visit_Time = visitTime! + " " + self.Visit_Mode!
            }
        }
        
        self.Remarks = checkNullAndNilValueForString(stringData: dict.value(forKey: "Remarks") as? String)
        self.Lattitude = checkNullAndNilValueForString(stringData: dict.value(forKey: "Lattitude") as? String)
        self.Longitude = checkNullAndNilValueForString(stringData: dict.value(forKey: "Longitude") as? String)
        self.Doctor_Region_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Region_Name") as? String)
        self.Local_Area = checkNullAndNilValueForString(stringData: dict.value(forKey: "Local_Area") as? String)
        self.Sur_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Sur_Name") as? String)
        self.Geo_Fencing_Deviation_Remarks = checkNullAndNilValueForString(stringData: dict.value(forKey: "Geo_Fencing_Deviation_Remarks") as? String)
        self.Geo_Fencing_Page_Source = checkNullAndNilValueForString(stringData: dict.value(forKey: "Geo_Fencing_Page_Source") as? String)
        
        self.Business_Status_ID = defaultBusineessStatusId
        if let businessStatusId = dict.value(forKey: "Business_Status_ID") as? Int
        {
            self.Business_Status_ID = businessStatusId
        }
        
        self.Business_Status_Active_Status = defaultBusinessStatusActviveStatus
        if let activeStatus = dict.value(forKey: "Status") as? Int
        {
            self.Business_Status_Active_Status = activeStatus
        }
        
        self.Business_Status_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Status_Name") as? String)
        
        self.Call_Objective_ID = defaultCallObjectiveId
        if let callObjId = dict.value(forKey: "Call_Objective_ID") as? Int
        {
            self.Call_Objective_ID = callObjId
        }
        
        self.Call_Objective_Active_Status = defaultCallObjectiveActviveStatus
        if let callObjStatus = dict.value(forKey: "Call_Objective_Status") as? Int
        {
            self.Call_Objective_Active_Status = callObjStatus
        }
        
        self.Call_Objective_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Call_Objective_Name") as? String)
        
        self.Is_DCR_Inherited_Doctor = 0
        
        if let isInheritedDoctor = dict.value(forKey: "Is_DCR_Inherited_Doctor") as? Int
        {
            self.Is_DCR_Inherited_Doctor = isInheritedDoctor
        }
        
        self.Punch_Start_Time = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Met_StartTime") as? String)
        self.Punch_End_Time = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Met_EndTime") as? String)
        self.Punch_Offset = checkNullAndNilValueForString(stringData: dict.value(forKey: "Punch_OffSet") as? String)
        self.Punch_TimeZone = checkNullAndNilValueForString(stringData: dict.value(forKey: "Punch_TimeZone") as? String)
        self.Punch_UTC_DateTime = checkNullAndNilValueForString(stringData: dict.value(forKey: "UTC_DateTime") as? String)
        self.Campaign_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Campaign_Code") as? String)
        self.Campaign_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Campaign_Name") as? String)
        if let punch = dict.value(forKey: "Punch_Status") as? Int
        {
            self.Punch_Status = punch
        }
        else
        {
            self.Punch_Status = 0
        }
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_DOCTOR_VISIT
    }
    
    required init(row: Row)
    {
        DCR_Doctor_Visit_Id = row["DCR_Doctor_Visit_Id"]
        DCR_Doctor_Visit_Code = row["DCR_Doctor_Visit_Code"]
        DCR_Id = row["DCR_Id"]
        DCR_Code = row["DCR_Code"]
        Doctor_Id = row["Doctor_Id"]
        Doctor_Code = row["Doctor_Code"]
        Doctor_Region_Code = row["Doctor_Region_Code"]
        Doctor_Name = row["Doctor_Name"]
        Speciality_Name = row["Speciality_Name"]
        MDL_Number = row["MDL_Number"]
        Category_Code = row["Category_Code"]
        Category_Name = row["Category_Name"]
        Visit_Mode = row["Visit_Mode"]
        Visit_Time = row["Visit_Time"]
        POB_Amount = row["POB_Amount"]
        Is_CP_Doctor = row["Is_CP_Doctor"]
        Is_Acc_Doctor = row["Is_Acc_Doctor"]
        Remarks = row["Remarks"]
        Lattitude = row["Lattitude"]
        Longitude = row["Longitude"]
        //        Region_Name = row["Region_Name"]
        Doctor_Region_Name = row["Doctor_Region_Name"]
        Local_Area = row["Local_Area"]
        Sur_Name = row["Sur_Name"]
        Geo_Fencing_Deviation_Remarks = row["Geo_Fencing_Deviation_Remarks"]
        Geo_Fencing_Page_Source = row["Geo_Fencing_Page_Source"]
        Business_Status_ID = row["Business_Status_ID"]
        Business_Status_Name = row["Business_Status_Name"]
        Business_Status_Active_Status = row["Business_Status_Active_Status"]
        Call_Objective_ID = row["Call_Objective_ID"]
        Call_Objective_Name = row["Call_Objective_Name"]
        Call_Objective_Active_Status = row["Call_Objective_Active_Status"]
        Is_DCR_Inherited_Doctor = row["Is_DCR_Inherited_Doctor"]
        Campaign_Code = row["Campaign_Code"]
        Campaign_Name = row["Campaign_Name"]
        
        Customer_Entity_Type = row["Customer_Entity_Type"]
        Hospital_Name = row["Hospital_Name"]
       // Hospital_Account_Number = row["Hospital_Account_Number"]

        Punch_Status = row["Punch_Status"]
        Punch_UTC_DateTime =  row["Punch_UTC_DateTime"]
        Punch_TimeZone = row["Punch_TimeZone"]
        Punch_Start_Time = row["Punch_Start_Time"]
        Punch_End_Time = row["Punch_End_Time"]
        Punch_Offset =  row["Punch_Offset"]
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["DCR_Doctor_Visit_Code"] =  DCR_Doctor_Visit_Code
        container["DCR_Id"] =  DCR_Id
        container["DCR_Code"] =  DCR_Code
        container["Doctor_Id"] =  Doctor_Id
        container["Doctor_Code"] =  Doctor_Code
        container["Doctor_Region_Code"] =  Doctor_Region_Code
        container["Doctor_Name"] =  Doctor_Name
        container["Speciality_Name"] =  Speciality_Name
        container["MDL_Number"] =  MDL_Number
        container["Category_Code"] =  Category_Code
        container["Category_Name"] =  Category_Name
        container["Visit_Mode"] =  Visit_Mode
        container["Visit_Time"] =  Visit_Time
        container["POB_Amount"] =  POB_Amount
        container["Is_CP_Doctor"] =  Is_CP_Doctor
        container["Is_Acc_Doctor"] =  Is_Acc_Doctor
        container["Remarks"] =  Remarks
        container["Lattitude"] =  Lattitude
        container["Longitude"] =  Longitude
        container["Doctor_Region_Name"] =  Doctor_Region_Name
        container["Local_Area"] =  Local_Area
        container["Sur_Name"] =  Sur_Name
        container["Geo_Fencing_Deviation_Remarks"] = Geo_Fencing_Deviation_Remarks
        container["Geo_Fencing_Page_Source"] = Geo_Fencing_Page_Source
        container["Business_Status_ID"] = Business_Status_ID
        container["Business_Status_Name"] = Business_Status_Name
        container["Business_Status_Active_Status"] = Business_Status_Active_Status
        container["Call_Objective_ID"] = Call_Objective_ID
        container["Call_Objective_Name"] = Call_Objective_Name
        container["Call_Objective_Active_Status"] = Call_Objective_Active_Status
        container["Is_DCR_Inherited_Doctor"] = Is_DCR_Inherited_Doctor
        container["Campaign_Code"] = Campaign_Code
        container["Campaign_Name"] = Campaign_Name
        container["Customer_Entity_Type"] = Customer_Entity_Type
        container["Hospital_Name"] = Hospital_Name
      //  container["Hospital_Account_Number"] = Hospital_Name
        container["Punch_Status"] = Punch_Status
        container["Punch_UTC_DateTime"] = Punch_UTC_DateTime
        container["Punch_TimeZone"] = Punch_TimeZone
        container["Punch_Start_Time"] = Punch_Start_Time
        container["Punch_End_Time"] = Punch_End_Time
        container["Punch_Offset"] = Punch_Offset

    }
    //    var persistentDictionary: [String : DatabaseValueConvertible?]
    //    {
    //        let dict1: [String : DatabaseValueConvertible?] = [
    //            "DCR_Doctor_Visit_Code": DCR_Doctor_Visit_Code,
    //            "DCR_Id": DCR_Id,
    //            "DCR_Code": DCR_Code,
    //            "Doctor_Id": Doctor_Id,
    //            "Doctor_Code": Doctor_Code,
    //            "Doctor_Region_Code": Doctor_Region_Code,
    //            "Doctor_Name": Doctor_Name,
    //            "Speciality_Name": Speciality_Name,
    //            "MDL_Number": MDL_Number,
    //            "Category_Code": Category_Code
    //        ]
    //
    //        let dict2 : [String : DatabaseValueConvertible?] = [
    //            "Category_Name": Category_Name,
    //            "Visit_Mode": Visit_Mode,
    //            "Visit_Time": Visit_Time,
    //            "POB_Amount": POB_Amount,
    //            "Is_CP_Doctor": Is_CP_Doctor,
    //            "Is_Acc_Doctor": Is_Acc_Doctor,
    //            "Remarks": Remarks,
    //            "Lattitude": Lattitude,
    //            "Longitude": Longitude
    //        ]
    //
    //        let dict3: [String : DatabaseValueConvertible?] = [
    //            "Doctor_Region_Name": Doctor_Region_Name,
    //            "Local_Area": Local_Area,
    //            "Sur_Name": Sur_Name
    //        ]
    //
    //        var combinedAttributes : NSMutableDictionary!
    //
    //        combinedAttributes = NSMutableDictionary(dictionary: dict1)
    //
    //        combinedAttributes.addEntries(from: dict2)
    //        combinedAttributes.addEntries(from: dict3)
    //
    //        return combinedAttributes as! [String : DatabaseValueConvertible?]
    //    }
}


class DoctorVisitStepperIndex : NSObject
{
    var doctorVisitIndex: Int!
    var accompanistIndex: Int!
    var sampleIndex: Int!
    var detailedProduct: Int!
    var assetIndex: Int!
    var chemistIndex: Int!
    var followUpIndex: Int!
    var attachmentIndex: Int!
    var rcpaDetailIndex: Int!
    var pobIndex : Int!
    var activity : Int!
}
class ActivityStepperIndex : NSObject
{
    var callTypeIndex : Int = 0
    var mcActivity : Int = 1
}

class AttendanceDoctorStepperIndex : NSObject
{
    var doctorVisitIndex: Int = 0
    var sampleIndex: Int = 1
    var activity : Int = 2
}


class TPDoctorVisitModel: Record
{
    var DCR_Doctor_Visit_Id: Int!
    var DCR_Doctor_Visit_Code: String!
    var DCR_Id: Int!
    var DCR_Code: String!
    var Doctor_Id: Int?
    var Doctor_Code: String?
    var Doctor_Region_Code: String?
    var Doctor_Name: String!
    var Speciality_Name: String!
    var MDL_Number: String?
    var Hospital_Name: String!
    var Category_Code: String?
    var Category_Name: String?
    var Visit_Mode: String!
    var Visit_Time: String?
    var POB_Amount: Float?
    var Is_CP_Doctor: Int?
    var Is_Acc_Doctor: Int?
    var Remarks: String?
    var Lattitude: String?
    var Longitude: String?
    //    var Region_Name: String?
    var Doctor_Region_Name: String?
    var Local_Area: String?
    var Sur_Name: String?
    var sampleList = [DCRSampleModel]()
  //  var Hospital_Account_Number: String!
    
    
    init(dict: NSDictionary)
    {
        self.DCR_Doctor_Visit_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Visit_Code") as? String)
        self.DCR_Id = Int(dict.value(forKey: "DCR_Id") as! String)
        self.DCR_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Code") as? String)
        
        if let doctorId = dict.value(forKey: "Doctor_Id") as? Int
        {
            self.Doctor_Id = doctorId
        }
        
        self.Doctor_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Code") as? String)
        self.Doctor_Region_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Region_Code") as? String)
        self.Doctor_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Name") as? String)
        self.Speciality_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Speciality_Name") as? String)
        self.MDL_Number = checkNullAndNilValueForString(stringData: dict.value(forKey: "MDL_Number") as? String)
        self.Category_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Category_Code") as? String)
        self.Category_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Category_Name") as? String)
        self.Visit_Mode = checkNullAndNilValueForString(stringData: dict.value(forKey: "Visit_Mode") as? String)
        self.Visit_Time = checkNullAndNilValueForString(stringData: dict.value(forKey: "Visit_Time") as? String)
        let pobAmount = checkNullAndNilValueForString(stringData: dict.value(forKey: "POB_Amount") as? String)
        self.Hospital_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Hospital_Name") as? String)
      //  self.Hospital_Account_Number = checkNullAndNilValueForString(stringData: dict.value(forKey: "Hospital_Account_Number") as? String)
        
        if (pobAmount != EMPTY)
        {
            self.POB_Amount = Float(pobAmount)
        }
        else
        {
            self.POB_Amount = 0
        }
        
        if let isCPDoctor = dict.value(forKey: "Is_CP_Doc") as? Int
        {
            self.Is_CP_Doctor = isCPDoctor
        }
        else
        {
            self.Is_CP_Doctor = 0
        }
        
        if let isAccDoctor = dict.value(forKey: "Is_Acc_Doctor") as? Int
        {
            self.Is_Acc_Doctor = isAccDoctor
        }
        else
        {
            self.Is_Acc_Doctor = 0
        }
        
        let visitTime = self.Visit_Time
        
        if (visitTime != EMPTY)
        {
            if (visitTime!.contains(AM) == false) && (visitTime!.contains(PM) == false)
            {
                self.Visit_Time = visitTime! + " " + self.Visit_Mode!
            }
        }
        
        self.Remarks = checkNullAndNilValueForString(stringData: dict.value(forKey: "Remarks") as? String)
        self.Lattitude = checkNullAndNilValueForString(stringData: dict.value(forKey: "Lattitude") as? String)
        self.Longitude = checkNullAndNilValueForString(stringData: dict.value(forKey: "Longitude") as? String)
        self.Doctor_Region_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Region_Name") as? String)
        self.Local_Area = checkNullAndNilValueForString(stringData: dict.value(forKey: "Local_Area") as? String)
        self.Sur_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Sur_Name") as? String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_DOCTOR_VISIT
    }
    
    required init(row: Row)
    {
        DCR_Doctor_Visit_Id = row["DCR_Doctor_Visit_Id"]
        DCR_Doctor_Visit_Code = row["DCR_Doctor_Visit_Code"]
        DCR_Id = row["DCR_Id"]
        DCR_Code = row["DCR_Code"]
        Doctor_Id = row["Doctor_Id"]
        Doctor_Code = row["Doctor_Code"]
        Doctor_Region_Code = row["Doctor_Region_Code"]
        Doctor_Name = row["Doctor_Name"]
        Speciality_Name = row["Speciality_Name"]
        MDL_Number = row["MDL_Number"]
        Category_Code = row["Category_Code"]
        Category_Name = row["Category_Name"]
        Visit_Mode = row["Visit_Mode"]
        Visit_Time = row["Visit_Time"]
        POB_Amount = row["POB_Amount"]
        Is_CP_Doctor = row["Is_CP_Doctor"]
        Is_Acc_Doctor = row["Is_Acc_Doctor"]
        Remarks = row["Remarks"]
        Lattitude = row["Lattitude"]
        Longitude = row["Longitude"]
        //        Region_Name = row["Region_Name"]
        Doctor_Region_Name = row["Doctor_Region_Name"]
        Local_Area = row["Local_Area"]
        Sur_Name = row["Sur_Name"]
        Hospital_Name = row["Hospital_Name"]
       // Hospital_Account_Number = row["Hospital_Account_Number"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["DCR_Doctor_Visit_Code"] =  DCR_Doctor_Visit_Code
        container["DCR_Id"] =  DCR_Id
        container["DCR_Code"] =  DCR_Code
        container["Doctor_Id"] =  Doctor_Id
        container["Doctor_Code"] =  Doctor_Code
        container["Doctor_Region_Code"] =  Doctor_Region_Code
        container["Doctor_Name"] =  Doctor_Name
        container["Speciality_Name"] =  Speciality_Name
        container["MDL_Number"] =  MDL_Number
        container["Category_Code"] =  Category_Code
        container["Category_Name"] =  Category_Name
        container["Visit_Mode"] =  Visit_Mode
        container["Visit_Time"] =  Visit_Time
        container["POB_Amount"] =  POB_Amount
        container["Is_CP_Doctor"] =  Is_CP_Doctor
        container["Is_Acc_Doctor"] =  Is_Acc_Doctor
        container["Remarks"] =  Remarks
        container["Lattitude"] =  Lattitude
        container["Longitude"] =  Longitude
        container["Doctor_Region_Name"] =  Doctor_Region_Name
        container["Local_Area"] =  Local_Area
        container["Sur_Name"] =  Sur_Name
        container["Hospital_Name"] =  Hospital_Name
      //  container["Hospital_Account_Number"] =  Hospital_Account_Number
    }
    
    //    var persistentDictionary: [String : DatabaseValueConvertible?]
    //    {
    //        let dict1: [String : DatabaseValueConvertible?] = [
    //            "DCR_Doctor_Visit_Code": DCR_Doctor_Visit_Code,
    //            "DCR_Id": DCR_Id,
    //            "DCR_Code": DCR_Code,
    //            "Doctor_Id": Doctor_Id,
    //            "Doctor_Code": Doctor_Code,
    //            "Doctor_Region_Code": Doctor_Region_Code,
    //            "Doctor_Name": Doctor_Name,
    //            "Speciality_Name": Speciality_Name,
    //            "MDL_Number": MDL_Number,
    //            "Category_Code": Category_Code
    //        ]
    //
    //        let dict2 : [String : DatabaseValueConvertible?] = [
    //            "Category_Name": Category_Name,
    //            "Visit_Mode": Visit_Mode,
    //            "Visit_Time": Visit_Time,
    //            "POB_Amount": POB_Amount,
    //            "Is_CP_Doctor": Is_CP_Doctor,
    //            "Is_Acc_Doctor": Is_Acc_Doctor,
    //            "Remarks": Remarks,
    //            "Lattitude": Lattitude,
    //            "Longitude": Longitude
    //        ]
    //
    //        let dict3: [String : DatabaseValueConvertible?] = [
    //            "Doctor_Region_Name": Doctor_Region_Name,
    //            "Local_Area": Local_Area,
    //            "Sur_Name": Sur_Name
    //        ]
    //
    //        var combinedAttributes : NSMutableDictionary!
    //
    //        combinedAttributes = NSMutableDictionary(dictionary: dict1)
    //
    //        combinedAttributes.addEntries(from: dict2)
    //        combinedAttributes.addEntries(from: dict3)
    //
    //        return combinedAttributes as! [String : DatabaseValueConvertible?]
    //    }
}

class CustomerAddressModel: Record
{
    var Address_Id: Int!
    var Customer_Code: String!
    var Region_Code: String!
    var Customer_Entity_Type: String!
    var Address1: String!
    var Address2: String!
    var Local_Area: String!
    var City: String!
    var State: String!
    var Pin_Code: String!
    var Hospital_Name: String!
    var Hospital_Classification: String!
    var Phone_Number: String!
    var Email_Id: String!
    var Latitude: Double!
    var Longitude: Double!
    var Is_Synced: Int!
    var Is_Selected: Bool = false
    var Update_Page_Source: String!
    
    var Customer_Code_Global: String!
    var Region_Code_Global: String!
    var Updated_By: String!
    init(dict: NSDictionary)
    {
        self.Address_Id = 0
        
        if let addressId = dict.value(forKey: "Address_Id") as? Int
        {
            self.Address_Id = addressId
        }
        self.Customer_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Code") as? String)
        self.Region_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Region_Code") as? String)
        self.Customer_Entity_Type = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Entity_Type") as? String)
        self.Address1 = checkNullAndNilValueForString(stringData: dict.value(forKey: "Address1") as? String)
        self.Address2 = checkNullAndNilValueForString(stringData: dict.value(forKey: "Address2") as? String)
        self.Local_Area = checkNullAndNilValueForString(stringData: dict.value(forKey: "Local_Area") as? String)
        self.City = checkNullAndNilValueForString(stringData: dict.value(forKey: "City") as? String)
        self.State = checkNullAndNilValueForString(stringData: dict.value(forKey: "State") as? String)
        self.Pin_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Pin_Code") as? String)
        self.Hospital_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Hospital_Name") as? String)
        self.Hospital_Classification = checkNullAndNilValueForString(stringData: dict.value(forKey: "Hospital_Classification") as? String)
        self.Phone_Number = checkNullAndNilValueForString(stringData: dict.value(forKey: "Phone_Number") as? String)
        self.Email_Id = checkNullAndNilValueForString(stringData: dict.value(forKey: "Email_Id") as? String)
        self.Latitude = 0
        self.Longitude = 0
        self.Is_Synced = 1
        
        if let latitude = dict.value(forKey: "Latitude") as? Double
        {
            self.Latitude = latitude
        }
        
        if let longitude = dict.value(forKey: "Longitude") as? Double
        {
            self.Longitude = longitude
        }
        
        self.Update_Page_Source = checkNullAndNilValueForString(stringData: dict.value(forKey: "Update_Page_Source") as? String)
        
        self.Customer_Code_Global = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Code_Global") as? String)
        self.Region_Code_Global = checkNullAndNilValueForString(stringData: dict.value(forKey: "Region_Code_Global") as? String)
        self.Updated_By = checkNullAndNilValueForString(stringData: dict.value(forKey: "Updated_By") as? String)
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_CUSTOMER_ADDRESS
    }
    
    required init(row: Row)
    {
        Address_Id = row["Address_Id"]
        Customer_Code = row["Customer_Code"]
        Region_Code = row["Region_Code"]
        Customer_Entity_Type = row["Customer_Entity_Type"]
        Address1 = row["Address1"]
        Address2 = row["Address2"]
        Local_Area = row["Local_Area"]
        City = row["City"]
        State = row["State"]
        Pin_Code = row["Pin_Code"]
        Hospital_Name = row["Hospital_Name"]
        Hospital_Classification = row["Hospital_Classification"]
        Phone_Number = row["Phone_Number"]
        Email_Id = row["Email_Id"]
        Latitude = row["Latitude"]
        Longitude = row["Longitude"]
        Is_Synced = row["Is_Synced"]
        Update_Page_Source = row["Update_Page_Source"]
        Customer_Code_Global = row["Customer_Code_Global"]
        Region_Code_Global = row["Region_Code_Global"]
        Updated_By = row["Updated_By"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer)
    {
        container["Address_Id"] =  Address_Id
        container["Customer_Code"] =  Customer_Code
        container["Region_Code"] =  Region_Code
        container["Customer_Entity_Type"] =  Customer_Entity_Type
        container["Address1"] =  Address1
        container["Address2"] =  Address2
        container["Local_Area"] =  Local_Area
        container["City"] =  City
        container["State"] =  State
        container["Pin_Code"] =  Pin_Code
        container["Hospital_Name"] =  Hospital_Name
        container["Hospital_Classification"] =  Hospital_Classification
        container["Phone_Number"] =  Phone_Number
        container["Email_Id"] =  Email_Id
        container["Latitude"] =  Latitude
        container["Longitude"] =  Longitude
        container["Is_Synced"] =  Is_Synced
        container["Update_Page_Source"] = Update_Page_Source
        container["Customer_Code_Global"] =  Customer_Code_Global
        container["Region_Code_Global"] =  Region_Code_Global
        container["Updated_By"] =  Updated_By
    }
}

class RegionEntityCount: Record
{
    var Region_Code: String!
    var Entity_Type: String!
    var Count: Int!
    
    init(dict: NSDictionary)
    {
        self.Region_Code = dict.value(forKey: "Region_Code") as! String
        self.Entity_Type = dict.value(forKey: "Entity_Type") as! String
        self.Count = dict.value(forKey: "Customer_Count") as! Int
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_REGION_ENTITY_COUNT
    }
    
    required init(row: Row)
    {
        Region_Code = row["Region_Code"]
        Entity_Type = row["Entity_Type"]
        Count = row["Count"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer)
    {
        container["Region_Code"] =  Region_Code
        container["Entity_Type"] =  Entity_Type
        container["Count"] =  Count
    }
}

class EDetailDoctorDeleteAudit: Record
{
    var DCR_Actual_Date: String!
    var Doctor_Code: String!
    var Doctor_Region_Code: String!
    var Doctor_Name: String!
    var DCR_Id: Int!
    
    init(dict: NSDictionary)
    {
        self.DCR_Actual_Date = dict.value(forKey: "DCR_Actual_Date") as! String
        self.Doctor_Code = dict.value(forKey: "Doctor_Code") as! String
        self.Doctor_Region_Code = dict.value(forKey: "Doctor_Region_Code") as! String
        self.Doctor_Name = dict.value(forKey: "Doctor_Name") as! String
        self.DCR_Id = dict.value(forKey: "DCR_Id") as! Int
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return TRAN_DCR_EDETAIL_DOCTOR_DELETE_AUDIT
    }
    
    required init(row: Row)
    {
        DCR_Actual_Date = row["DCR_Actual_Date"]
        Doctor_Code = row["Doctor_Code"]
        Doctor_Region_Code = row["Doctor_Region_Code"]
        Doctor_Name = row["Doctor_Name"]
        DCR_Id = row["DCR_Id"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer)
    {
        container["DCR_Actual_Date"] =  DCR_Actual_Date
        container["Doctor_Code"] =  Doctor_Code
        container["Doctor_Region_Code"] =  Doctor_Region_Code
        container["Doctor_Name"] =  Doctor_Name
        container["DCR_Id"] = DCR_Id
    }
}
