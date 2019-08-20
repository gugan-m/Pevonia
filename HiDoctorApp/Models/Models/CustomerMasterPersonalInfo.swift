//
//  CustomerMasterPersonalInfo.swift
//  HiDoctorApp
//
//  Created by SwaaS on 03/02/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import GRDB

class CustomerMasterPersonalInfo: Record
{
    var Customer_Code: String!
    var Region_Code: String!
    var DOB: Date!
    var Anniversary_Date: Date!
    var Mobile_Number: String!
    var Alternate_Number: String?
    var Assistant_Number: String?
    var Registration_Number: String!
    var Email_Id: String?
    var Blob_Photo_Url: String?
    var Hospital_Name: String!
    var Hospital_Address: String?
    var Notes: String?
    
    init(dict: NSDictionary)
    {
        self.Customer_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Code") as? String)
        self.Region_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Region_Code") as? String)
        //self.DOB = getStringInFormatDate(dateString: dict.value(forKey: "DOB") as! String)
        //self.Anniversary_Date = getStringInFormatDate(dateString: dict.value(forKey: "Anniversary_Date") as! String)
        self.Mobile_Number = checkNullAndNilValueForString(stringData: dict.value(forKey: "Phone_No") as? String)
        self.Alternate_Number = checkNullAndNilValueForString(stringData: dict.value(forKey: "Alternate_No") as? String)
        self.Assistant_Number = checkNullAndNilValueForString(stringData: dict.value(forKey: "Assistant_No") as? String)
        self.Registration_Number = checkNullAndNilValueForString(stringData: dict.value(forKey: "Registration_No") as? String)
        self.Email_Id = checkNullAndNilValueForString(stringData: dict.value(forKey: "Email_Id") as? String)
        self.Blob_Photo_Url = checkNullAndNilValueForString(stringData: dict.value(forKey: "Photo_URL") as? String)
        self.Hospital_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Hospital_Name") as? String)
        self.Hospital_Address = checkNullAndNilValueForString(stringData: dict.value(forKey: "Hospital_Address") as? String)
        self.Notes = checkNullAndNilValueForString(stringData: dict.value(forKey: "Notes") as? String)
        
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return MST_CUSTOMER_MASTER_PERSONAL_INFO
    }
    
    required init(row: Row)
    {
        Customer_Code = row["Customer_Code"]
        Region_Code = row["Region_Code"]
        DOB = row["DOB"]
        Anniversary_Date = row["Anniversary_Date"]
        Mobile_Number = row["Mobile_Number"]
        Alternate_Number = row["Alternate_Number"]
        Assistant_Number = row["Assistant_Number"]
        Registration_Number = row["Registration_Number"]
        Email_Id = row["Email_Id"]
        Blob_Photo_Url = row["Blob_Photo_Url"]
        Hospital_Name = row["Hospital_Name"]
        Hospital_Address = row["Hospital_Address"]
        Notes = row["Notes"]
        
        super.init(row: row)
    }
     override func encode(to container: inout PersistenceContainer) {
        
        container["Customer_Code"] =  Customer_Code
        container["Region_Code"] =  Region_Code
        container["DOB"] =  DOB
        container["Anniversary_Date"] =  Anniversary_Date
        container["Mobile_Number"] =  Mobile_Number
        container["Alternate_Number"] =  Alternate_Number
        container["Assistant_Number"] =  Assistant_Number
        container["Registration_Number"] =  Registration_Number
        container["Email_Id"] =  Email_Id
        container["Blob_Photo_Url"] =  Blob_Photo_Url
        container["Hospital_Name"] =  Hospital_Name
        container["Hospital_Address"] =  Hospital_Address
        container["Notes"] =  Notes
    }
//    var persistentDictionary: [String : DatabaseValueConvertible?]
//    {
//        let dict1: [String : DatabaseValueConvertible?] = [
//            "Customer_Code": Customer_Code,
//            "Region_Code": Region_Code,
//            "DOB": DOB,
//            "Anniversary_Date": Anniversary_Date,
//            "Mobile_Number": Mobile_Number,
//            "Alternate_Number": Alternate_Number,
//            "Assistant_Number": Assistant_Number,
//            "Registration_Number": Registration_Number
//        ]
//        
//        let dict2: [String : DatabaseValueConvertible?] = [
//            "Email_Id": Email_Id,
//            "Blob_Photo_Url": Blob_Photo_Url,
//            "Hospital_Name": Hospital_Name,
//            "Hospital_Address": Hospital_Address,
//            "Notes": Notes
//        ]
//        
//        var combinedAttributes : NSMutableDictionary!
//        
//        combinedAttributes = NSMutableDictionary(dictionary: dict1)
//        
//        combinedAttributes.addEntries(from: dict2)
//        
//        return combinedAttributes as! [String : DatabaseValueConvertible?]
//    }
}
