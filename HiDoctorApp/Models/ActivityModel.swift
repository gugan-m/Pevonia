//
//  ActicityModel.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 19/03/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import Foundation
import GRDB

class DCRActivityCallType: Record
{
    var DCR_Call_Activity_ID: Int!
    var DCR_Code: String!
    var DCR_Id: Int!
    var DCR_Customer_Visit_Id: Int!
    var DCR_Customer_Visit_Code: String!
    var Flag: String!
    var Customer_Entity_Type: Int!
    var Customer_Entity_Type_Description: String!
    var Customer_Activity_ID: Int!
    var Customer_Activity_Name: String!
    var Cusotmer_Activity_Status: Int!
    var Activity_Remarks: String!
    var Entity_Type: String!
    
    init(dict: NSDictionary)
    {
        self.DCR_Id = 0
        
        if let dcrId = dict.value(forKey: "DCR_Id") as? Int
        {
            self.DCR_Id = dcrId
        }
        
        self.DCR_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Code") as? String)
        self.DCR_Customer_Visit_Id = 0
        if let visitId = dict.value(forKey: "DCR_Customer_Visit_Id") as? Int
        {
            self.DCR_Customer_Visit_Id = visitId
        }
        self.DCR_Customer_Visit_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Visit_code") as? String)
        self.Flag = checkNullAndNilValueForString(stringData: dict.value(forKey: "Flag") as? String)
        self.Customer_Entity_Type = dict.value(forKey: "Customer_Entity_Type") as! Int
        self.Customer_Entity_Type_Description = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Entity_Type_Description") as? String)
        self.Customer_Activity_ID =  dict.value(forKey: "Customer_Activity_ID") as! Int
        self.Customer_Activity_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Activity_Name") as? String)
      //  self.Cusotmer_Activity_Status = 0
            //dict.value(forKey: "Cusotmer_Activity_Status") as! Int
        self.Activity_Remarks = checkNullAndNilValueForString(stringData: dict.value(forKey: "Activity_Remarks") as? String)
        self.Entity_Type = checkNullAndNilValueForString(stringData: dict.value(forKey: "Entity_Type") as? String)
        
        super.init()
    }
    override class var databaseTableName: String
    {
        return TRAN_DCR_CALL_ACTIVITY
    }
    
    required init(row: Row)
    {
        DCR_Call_Activity_ID = row["DCR_Call_Activity_ID"]
        DCR_Id = row["DCR_Id"]
        DCR_Code = row["DCR_Code"]
        DCR_Customer_Visit_Id = row["DCR_Customer_Visit_Id"]
        DCR_Customer_Visit_Code = row["DCR_Customer_Visit_Code"]
        Flag = row["Flag"]
        Customer_Entity_Type = row["Customer_Entity_Type"]
        Customer_Entity_Type_Description = row["Customer_Entity_Type_Description"]
        Customer_Activity_ID = row["Customer_Activity_ID"]
        Customer_Activity_Name = row["Customer_Activity_Name"]
      //  Cusotmer_Activity_Status = row["Cusotmer_Activity_Status"]
        Activity_Remarks = row["Activity_Remarks"]
        Entity_Type = row["Entity_Type"]
       
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["DCR_Id"] = DCR_Id
        container["DCR_Code"] = DCR_Code
        container["DCR_Customer_Visit_Id"] = DCR_Customer_Visit_Id
        container["DCR_Customer_Visit_Code"] = DCR_Customer_Visit_Code
        container["Flag"] = Flag
        container["Customer_Entity_Type"] = Customer_Entity_Type
        container["Customer_Entity_Type_Description"] = Customer_Entity_Type_Description
        container["Customer_Activity_ID"] = Customer_Activity_ID
        container["Customer_Activity_Name"] = Customer_Activity_Name
       // container["Cusotmer_Activity_Status"] = Cusotmer_Activity_Status
        container["Activity_Remarks"] = Activity_Remarks
        container["Entity_Type"] = Entity_Type
    }
}

class DCRMCActivityCallType: Record
{
    var DCR_MC_Activity_ID: Int!
    var DCR_Code: String!
    var DCR_Id: Int!
    var DCR_Customer_Visit_Id: Int!
    var DCR_Customer_Visit_Code: String!
    var Flag: String!
    var Customer_Entity_Type: Int!
    var Customer_Entity_Type_Description: String!
    var Campaign_Code: String!
    var Campaign_Name: String!
    var MC_Activity_Id: Int!
    var MC_Activity_Name: String!
    var MC_Activity_Status: Int!
    var MC_Activity_Remarks: String!
    var Entity_Type: String!
    
    init(dict: NSDictionary)
    {
        self.DCR_Id = 0
        
        if let dcrId = dict.value(forKey: "DCR_Id") as? Int
        {
            self.DCR_Id = dcrId
        }
        
        self.DCR_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "DCR_Code") as? String)
        self.DCR_Customer_Visit_Id = 0
        if let visitId = dict.value(forKey: "DCR_Customer_Visit_Id") as? Int
        {
            self.DCR_Customer_Visit_Id = visitId
        }
        if let visitcode = dict.value(forKey: "Visit_code") as? String
        {
           self.DCR_Customer_Visit_Code = visitcode
        }
        else if let visitcode = dict.value(forKey: "Visit_Code") as? String
        {
           self.DCR_Customer_Visit_Code = visitcode
        }
        else
        {
           self.DCR_Customer_Visit_Code = EMPTY
        }
       // self.DCR_Customer_Visit_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Visit_code") as? String)
        self.Flag = checkNullAndNilValueForString(stringData: dict.value(forKey: "Flag") as? String)
        self.Customer_Entity_Type = dict.value(forKey: "Customer_Entity_Type") as! Int
        self.Customer_Entity_Type_Description = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Entity_Type_Description") as? String)
        self.Campaign_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Campaign_Code") as? String)
        self.Campaign_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Campaign_Name") as? String)
        self.MC_Activity_Id =  dict.value(forKey: "MC_Activity_Id") as! Int
        self.MC_Activity_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Activity_Name") as? String)
     //   self.MC_Activity_Status =  dict.value(forKey: "MC_Activity_Status") as! Int
        self.MC_Activity_Remarks = checkNullAndNilValueForString(stringData: dict.value(forKey: "MC_Remark") as? String)
        self.Entity_Type = checkNullAndNilValueForString(stringData: dict.value(forKey: "Entity_Type") as? String)
        
        super.init()
    }
    override class var databaseTableName: String
    {
        return TRAN_DCR_MC_ACTIVITY
    }
    
    required init(row: Row)
    {
        DCR_MC_Activity_ID = row["DCR_MC_Activity_ID"]
        DCR_Id = row["DCR_Id"]
        DCR_Code = row["DCR_Code"]
        DCR_Customer_Visit_Id = row["DCR_Customer_Visit_Id"]
        DCR_Customer_Visit_Code = row["DCR_Customer_Visit_Code"]
        Flag = row["Flag"]
        Customer_Entity_Type = row["Customer_Entity_Type"]
        Customer_Entity_Type_Description = row["Customer_Entity_Type_Description"]
        Campaign_Code = row["Campaign_Code"]
        Campaign_Name = row["Campaign_Name"]
        MC_Activity_Id = row["MC_Activity_Id"]
        MC_Activity_Name = row["MC_Activity_Name"]
        MC_Activity_Remarks = row["MC_Activity_Remarks"]
        Entity_Type = row["Entity_Type"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        
        container["DCR_Id"] = DCR_Id
        container["DCR_Code"] = DCR_Code
        container["DCR_Customer_Visit_Id"] = DCR_Customer_Visit_Id
        container["DCR_Customer_Visit_Code"] = DCR_Customer_Visit_Code
        container["Flag"] = Flag
        container["Customer_Entity_Type"] = Customer_Entity_Type
        container["Customer_Entity_Type_Description"] = Customer_Entity_Type_Description
        container["Campaign_Code"] = Campaign_Code
        container["Campaign_Name"] = Campaign_Name
        container["MC_Activity_Id"] = MC_Activity_Id
        container["MC_Activity_Name"] = MC_Activity_Name
        container["MC_Activity_Remarks"] = MC_Activity_Remarks
        container["Entity_Type"] = Entity_Type
    }
}


class BusinessStatusModel: Record
{
    var Business_Status_ID: Int!
    var Status_Name: String!
    var Entity_Type: Int!
    var Entity_Type_Description: String!
    
    init(dict: NSDictionary)
    {
        self.Business_Status_ID = dict.value(forKey: "Business_Status_Id") as! Int
        self.Status_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Status_Name") as? String)
        self.Entity_Type_Description = checkNullAndNilValueForString(stringData: dict.value(forKey: "Entity_Type_Description") as? String)
        self.Entity_Type = 0
        
        if let entityType = dict.value(forKey: "Entity_Type") as? Int
        {
            self.Entity_Type = Int(entityType)
        }
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_BUSINESS_STATUS
    }
    
    required init(row: Row)
    {
        Business_Status_ID = row["Business_Status_ID"]
        Status_Name = row["Status_Name"]
        Entity_Type = row["Entity_Type"]
        Entity_Type_Description = row["Entity_Type_Description"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer)
    {
        
        container["Business_Status_ID"] = Business_Status_ID
        container["Status_Name"] = Status_Name
        container["Entity_Type"] = Entity_Type
        container["Entity_Type_Description"] = Entity_Type_Description
    }
}

class CallObjectiveModel: Record
{
    var Call_Objective_ID: Int!
    var Call_Objective_Name: String!
    var Entity_Type: Int!
    var Entity_Type_Description: String!
    
    init(dict: NSDictionary)
    {
        self.Call_Objective_ID = dict.value(forKey: "Call_Objective_ID") as! Int
        self.Call_Objective_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Call_Objective_Name") as? String)
        self.Entity_Type_Description = checkNullAndNilValueForString(stringData: dict.value(forKey: "Entity_Description") as? String)
        self.Entity_Type = 0
        
        if let entityType = dict.value(forKey: "Entity_Type") as? Int
        {
            self.Entity_Type = entityType
        }
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_CALL_OBJECTIVE
    }
    
    required init(row: Row)
    {
        Call_Objective_ID = row["Call_Objective_ID"]
        Call_Objective_Name = row["Call_Objective_Name"]
        Entity_Type = row["Entity_Type"]
        Entity_Type_Description = row["Entity_Type_Description"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer)
    {
        
        container["Call_Objective_ID"] = Call_Objective_ID
        container["Call_Objective_Name"] = Call_Objective_Name
        container["Entity_Type"] = Entity_Type
        container["Entity_Type_Description"] = Entity_Type_Description
    }
}

class CallActivity: Record
{
    var Call_Activity_Id: Int!
    var Activity_Name: String!
    
    init(dict: NSDictionary)
    {
        self.Call_Activity_Id = dict.value(forKey: "Customer_Activity_Id") as! Int
        self.Activity_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Activity_Name") as? String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_CALL_ACTIVITY
    }
    required init(row: Row)
    {
        Call_Activity_Id = row["Call_Activity_Id"]
        Activity_Name = row["Activity_Name"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer)
    {
        container["Call_Activity_Id"] = Call_Activity_Id
        container["Activity_Name"] = Activity_Name
    }
}

class MCHeaderModel: Record
{
    var Campaign_Code: String!
     var Campaign_Name: String!
    var Effective_From: Date?
    var Effective_To: Date?
    var Customer_Count: Int!
    var Campaign_Based_On: String!
    var Customer_Selection: String!
    var isAdded: Bool = false
    var isSelected: Bool = false
    
    
    init(dict: NSDictionary)
    {
        self.Campaign_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Campaign_Code") as? String)
        self.Campaign_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Campaign_Name") as? String)
        
        let effective_From_Date = checkNullAndNilValueForString(stringData: dict.value(forKey: "Effective_From") as? String)
        if(effective_From_Date != EMPTY)
        {
            self.Effective_From = getDateStringInFormatDate(dateString: effective_From_Date, dateFormat: defaultServerDateFormat)
            
        }
        let effective_To_Date = checkNullAndNilValueForString(stringData: dict.value(forKey: "Effective_To") as? String)
        if(effective_From_Date != EMPTY)
        {
            self.Effective_To = getDateStringInFormatDate(dateString: effective_To_Date, dateFormat: defaultServerDateFormat)
            
        }
        
        self.Customer_Count = dict.value(forKey: "Customer_Count") as? Int ?? 0
        self.Campaign_Based_On = checkNullAndNilValueForString(stringData: dict.value(forKey: "Campaign_Based_On") as? String)
        self.Customer_Selection = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Selection") as? String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_MC_HEADER
    }
    
    required init(row: Row)
    {
        Campaign_Code = row["Campaign_Code"]
        Campaign_Name = row["Campaign_Name"]
        Effective_From = row["Effective_From"]
        Effective_To = row["Effective_To"]
        Customer_Count = row["Customer_Count"]
        Campaign_Based_On = row["Campaign_Based_On"]
        Customer_Selection = row["Customer_Selection"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer)
    {
        container["Campaign_Code"] = Campaign_Code
        container["Campaign_Name"] = Campaign_Name
        container["Effective_From"] = Effective_From
        container["Effective_To"] = Effective_To
        container["Customer_Count"] = Customer_Count
        container["Campaign_Based_On"] = Campaign_Based_On
        container["Customer_Selection"] = Customer_Selection
    }
}
class MCRegionTypeModel: Record
{
    var Mapping_Id: Int!
    var Campaign_Code: String!
    var Region_Type_Code: String!
    
    init(dict: NSDictionary)
    {
       
        self.Campaign_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Campaign_Code") as? String)
        self.Region_Type_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Region_Type_Code") as? String)

        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_MC_MAPPED_REGION_TYPES
    }
    required init(row: Row)
    {
        Mapping_Id = row["Mapping_Id"]
        Campaign_Code = row["Campaign_Code"]
        Region_Type_Code = row["Region_Type_Code"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer)
    {
        
        container["Campaign_Code"] = Campaign_Code
        container["Region_Type_Code"] = Region_Type_Code
    }
}

class MCCategoryModel: Record
{
    var MC_Category_Id: Int!
    var Campaign_Code: String!
    var Customer_Category_Code: String!
    
    init(dict: NSDictionary)
    {
        self.Campaign_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Campaign_Code") as? String)
        self.Customer_Category_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Category_Code") as? String)
        
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_MC_CATEGORY
    }
    required init(row: Row)
    {
        MC_Category_Id = row["MC_Category_Id"]
        Campaign_Code = row["Campaign_Code"]
        Customer_Category_Code = row["Customer_Category_Code"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer)
    {
        
        container["Campaign_Code"] = Campaign_Code
        container["Customer_Category_Code"] = Customer_Category_Code
    }
}

//Specialty_Code
class MCSpecialtyModel: Record
{
    var MC_Speciality_Id: Int!
    
    var Campaign_Code: String!
    var Customer_Speciality_Code: String!
    
    init(dict: NSDictionary)
    {
        self.Campaign_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Campaign_Code") as? String)
        self.Customer_Speciality_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Speciality_Code") as? String)
        
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_MC_SPECIALITY
    }
    required init(row: Row)
    {
        MC_Speciality_Id = row["MC_Speciality_Id"]
        Campaign_Code = row["Campaign_Code"]
        Customer_Speciality_Code = row["Customer_Speciality_Code"]
        
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer)
    {
      
        container["Campaign_Code"] = Campaign_Code
        container["Customer_Speciality_Code"] = Customer_Speciality_Code
    }
}

class MCActivityModel:Record
{
    var MC_Activity_Id: Int!
    var MC_Activity_Name: String!
    var Campaign_Code: String!
    
    init(dict: NSDictionary)
    {
        self.MC_Activity_Id = dict.value(forKey: "MC_Activity_Id") as! Int
        self.MC_Activity_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "MC_Activity_Name") as? String)
         self.Campaign_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Campaign_Code") as? String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_MC_ACTIVITY
    }
    required init(row: Row)
    {
        MC_Activity_Id = row["MC_Activity_Id"]
        MC_Activity_Name = row["MC_Activity_Name"]
        Campaign_Code = row["Campaign_Code"]
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer)
    {
        container["MC_Activity_Id"] = MC_Activity_Id
        container["MC_Activity_Name"] = MC_Activity_Name
        container["Campaign_Code"] = Campaign_Code
    }
}
class ActivityListObj: NSObject
{
    var activityId: Int!
    var activityName: String!
    var remarks: String!
    var isSelected : Bool = false
    var isAdded : Bool = false
}

class ActivityMainStepperObj: NSObject
{
    var activityName: String!
    var activityRemarks: String!
}

