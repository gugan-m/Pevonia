//
//  UserMasterModel.swift
//  ContactsPoc
//
//  Created by Vignaya on 10/24/16.
//  Copyright © 2016 Vignaya. All rights reserved.
//

import UIKit

class UserMasterModel: NSObject
{
    var Accompanist_Id: Int!
    var User_Code: String!
    var User_Name: String!
    var Employee_name: String!
    var User_Type_Name: String!
    var Region_Code: String!
    var Region_Name: String!
    var Division_Name: String!
    var Is_Child_User: Int!
    var Is_Immedidate_User: Int!
    var User_Start_Date : Date!
    var User_End_Date : Date!
    var Child_User_Count: Int!
    var Hospital_Name: String!
}

class CompanyMasterModel : NSObject
{
    var companyId: Int!
    var companyCode : String!
    var companyName: String!
    var subDomain: String!
    var companyURL: String!
    var geoLocation: Int!
    var displayName: String!
    var companyLogoURL: String!
    var payrollIntegrated: Int!
}

class ApprovalUserMasterModel : NSObject
{
    var Employee_Name: String!
    var User_Type_Name: String!
    var Region_Code: String!
    var Region_Name: String!
    var Count : Int!
    var User_Name: String!
    var User_Code: String!
    var Employee_Number : String!
    var Actual_Date : String!
    var Entered_Date : String!
    var TP_Day : String!
    var Activity : Int!
    var Activity_Id :Int!
    var DCR_Code : String!
    var approvalStatus : Int!
    var DCR_Status : String!
    var activityMonth : String!
    var activityYear : String!
    var UnapprovalActivity : String!
    var IsChecked : Int!
    var actualDate : Date!
}

class DashboardUserMasterModel : NSObject
{
    var Speciality_Code : String!
    var Category_Code : String!
    var Category_Name : String!
    var Customer_Name : String!
    var Speciality_Name : String!
    var MDL_Number : String!
    var Region_Code : String!
    var Region_Name : String!
}

class UserChangePasswordModel : NSObject
{
    var New_Password : String!
    var Old_Password : String!
    var User_Name : String!
    var User_Code : String!
}

class GeoLocationModel: NSObject
{
    var Latitude: Double!
    var Longitude: Double!
    var Address_Id: Int?
}

class GeoLocationValidationModel: NSObject
{
    var Status: Int!
    var Customer_Location:GeoLocationModel?
    var Remarks: String!
}

class DCRInheritanceValidationModel: NSObject
{
    var Status: Int!
    var Message: String!
}
