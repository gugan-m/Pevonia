//
//  DCRStepperModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 23/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class DCRStepperModel: NSObject
{
    var sectionTitle: String!
    var emptyStateTitle: String!
    var emptyStateSubTitle: String!
    var doctorEmptyStateTitle: String!
    var doctorEmptyStatePendingCount: String!
    var isExpanded: Bool!
    var recordCount: Int = 0
    var showEmptyStateAddButton: Bool = false
    var showEmptyStateSkipButton: Bool = false
    var showLeftButton: Bool = false
    var showRightButton: Bool = false
    var sectionIconName: String!
    var leftButtonTitle: String!
    var Entity_Id: Int = -1
}

class StepperWorkPlaceModel: NSObject
{
    var key: String!
    var value: String!
}

class CallObjectModel: NSObject
{
    var objTitle: String!
    var objName: String!

//    var workCategory: String!
//    var activityName: String!

}


class StepperTravelPlaceModel: NSObject
{
    var TP_Travel_Id: Int!
    var TP_Id: Int!
    var From_Place: String!
    var To_Place: String!
    var Travel_Mode: String!
    var Distance: Float!
    var SFC_Category_Name: String?
    var Distance_Fare_Code: String?
    var SFC_Version: Int?
    var Route_Way: String?
    var Flag: Int!
    var TP_Code: String!
    var Is_Circular_Route_Complete: Int?
    var Region_Code : String?
}

class StepperMeetingPlaceModel: NSObject
{
    var key : String!
    var value : String!
}

class StepperDoctorModel: NSObject
{
    var tpDoctorId: Int!
    var Customer_Code: String!
    var Customer_Name: String!
    var Region_Code: String!
    var Region_Name: String!
    var Speciality_Name: String!
    var Hospital_Name: String!
    var Category_Name: String?
    var MDL_Number: String!
    var sampleList1 = [DCRSampleModel]()
    var sampleList = [SampleBatchProductModel]()
    var isExpanded = false
}

class StepperAttendanceDoctorModel: NSObject
{
    var doctorId: Int!
    var Customer_Code: String!
    var Customer_Name: String!
    var Region_Code: String!
    var Region_Name: String!
    var Speciality_Name: String!
    var Hospital_Name: String!
    var MDL_Number: String!
    var sampleList = [SampleBatchProductModel]()
    var isExpanded = false
}
class StepperPOBModel
{
    var sectionTitle : String!
    var emptyStateTitle : String!
    var emptyStateSubTitle : String!
    var isExpanded:Bool!
    var recordCount : Int = 0
    var showEmptyStateAddButton : Bool = false
    var showLeftButton: Bool = false
    var showRightButton: Bool = false
    var sectionIconName : String!
}

class TPUploadModel
{
    var Month: Int!
    var Year: Int!
    var Count: Int!
}
