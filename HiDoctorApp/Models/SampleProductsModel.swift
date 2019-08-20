//
//  SampleProductsModel.swift
//  HiDoctorApp
//
//  Created by swaasuser on 19/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class SampleProductsModel: NSObject {

    var DCR_Sample_Id: Int!
    var DCR_Doctor_Visit_Id: Int!
    var DCR_Doctor_Visit_Code: String!
    var DCR_Id: Int!
    var DCR_Code: String!
    var Product_Id: Int!
    var Product_Code: String!
    var Product_Type_Code: String!
    var Product_Name: String!
    var Product_Type_Name : String!
    var Quantity_Provided: Int!
    var Speciality_Code: String!
    var Hospital_Name: String!
    var Current_Stock : Int!
    var Division_Name : String!
    var Batch_Name: String = ""
    var Batch_Current_Stock : Int = 0
}

class SampleBatchProductModel: NSObject
{
    var title: String!
    var isShowSection: Bool!
    var sampleList: [DCRSampleModel] = []
    var chemistSamplePromotion: [DCRChemistSamplePromotion] = []
}

class InwardAccknowledgmentProductData: NSObject {
    
    var Header_Id: Int!
    var Delivery_Challan_Number:  String!
    var Inward_Upload_Actual_Date: String!
    var Server_Current_Date: String!
    var lstInwardAckDetails: [InwardAccknowledgment]!
}
class InwardAccknowledgment: NSObject {
    
    var Details_Id : Int!
    var Product_Type : String!
    var Product_Name : String!
    var Sent_Quantity : Int!
    var Received_Quantity: Int!
    var Product_Code: String!
    var Pending_Quantity: Int!
    var Received_So_Far: Int!
    var Remarks :String = ""
    var isEntered: Bool = false
    var Batch_Number : String!
}

class InwardAccknowledgmentRemarkData: NSObject {
    
    var Product_Name: String!
    var Batch_Number: String!
    var Total_Sent_Quantity: Int!
    var Created_On: String!
    var Created_For: String!
    var lstInwardRemarksDetails: [InwardAccknowledgmentRemark]!
}

class InwardAccknowledgmentRemark: NSObject {
    var Modified_Inward_Actual_Date: String!
    var Modified_On: String!
    var Quantity: Int!
    var Acknowledgement_Type: String!
    var Remarks: String!
}



