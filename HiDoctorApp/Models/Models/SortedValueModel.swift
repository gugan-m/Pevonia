//
//  SortedValueModel.swift
//  ContactsPoc
//
//  Created by Vignaya on 10/24/16.
//  Copyright © 2016 Vignaya. All rights reserved.
//

import UIKit

class SortedValueModel: NSObject {
    
    var sectionKey : String = ""
    var userList : [UserMasterWrapperModel] = []
    
}

class CustomerSortedModel: NSObject {
    
//    var Customer_Code: String!
//    var Customer_Name: String!
//    var Speciality_Name: String!
//    var MDL_Number: String!
//    var Category_Code: String?
//    var Category_Name: String?
//    var Region_Name: String!
//    var Hospital_Name: String?
//
//    var isSelected : Bool = false
//    var Region_Code: String!
//    var isReadOnly : Bool = false
//    var userCode : String?
    
    var Customer_Id: Int!
    var Customer_Code: String!
    var Customer_Name: String!
    var Region_Code: String!
    var Region_Name: String!
    var Speciality_Code: String!
    var Speciality_Name: String!
    var Category_Code: String?
    var Category_Name: String?
    var MDL_Number: String!
    var Local_Area: String?
    var Hospital_Name: String!
    var Customer_Entity_Type: String!
    var Sur_Name: String?
    var userCode : String?
    var isSelected : Bool = false
    var isReadOnly : Bool = false
    var Latitude: Double = 0
    var Longitude: Double = 0
    var Anniversary_Date: Date?
    var DOB: Date?
    var indays: Int?
    var Customer_Status: Int = 1
    var isViewEnable: Bool = false //DPM
    var noOfPrescription: String = EMPTY
    var potentialPrescription: String =  EMPTY
    
    var sectionKey : String = ""
    var userList : [CustomerMasterModel] = []
  //  var userList  = CustomerMasterModel()
   // var userList : UserMasterModel  = UserMasterModel()
    
    
    
    
}

class CustomerSortedModelHospital: NSObject {
    
    var sectionKey : String = ""
    var userList : [CustomerMasterModel] = []
}
