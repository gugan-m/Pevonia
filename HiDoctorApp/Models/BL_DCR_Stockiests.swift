//
//  BL_Stockiests.swift
//  HiDoctorApp
//
//  Created by swaasuser on 24/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class BL_DCR_Stockiests: NSObject
{
    static let sharedInstance : BL_DCR_Stockiests = BL_DCR_Stockiests()
    
    func getMasterStockiestList() -> [CustomerMasterModel]
    {
        var masterStockiestsList : [CustomerMasterModel]?
        masterStockiestsList = DBHelper.sharedInstance.getStockiestList(customerEntityType: "STOCKIEST")
        return masterStockiestsList!
    }
    
    func insertDCRStockiestsVisit(customerMasterObj : CustomerMasterModel,pobAmount:Double,visitMode:String,collectionAmount:Double,remarks: String,visitTime:String)
    {
        let dict : NSDictionary = ["DCR_Id":getDCRId(),"DCR_Code":getDCRCode(),"Stockiest_Id":customerMasterObj.Customer_Id,"Stockiest_Code":customerMasterObj.Customer_Code,"Stockiest_Name":customerMasterObj.Customer_Name,"POB_Amount":pobAmount,"Visit_Mode":visitMode,"Collection_Amount":collectionAmount,"Remarks":remarks,"Visit_Time":visitTime,"Longitude":getLongitude(),"Latitude":getLatitude()]
        
        let dcrStockiestsModelObj : DCRStockistVisitModel = DCRStockistVisitModel(dict: dict)
        DBHelper.sharedInstance.insertDcrStockiestsVisit(dcrStockiestVisitObj: dcrStockiestsModelObj)
    }
    
    func updateDCRStockiestsVisit(dcrStockiestsObj : DCRStockistVisitModel)
    {
        DBHelper.sharedInstance.updateDCRStockiestsVisit(dcrStockiestObj: dcrStockiestsObj)
    }
    
    func getDCRStockiestsList() -> [DCRStockistVisitModel]
    {
        return DBHelper.sharedInstance.getDCRStockiestVisitList(dcrId: getDCRId())
    }
    
    func deleteDCRStockiests(stockiestsCode : String)
    {
        DBHelper.sharedInstance.deleteDCRStockiets(stockiestsCode: stockiestsCode, dcrId: getDCRId())
    }
    
    func getDcrStockistVisitTime() -> String
    {
       return PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.DCR_STOCKIEST_VISIT_TIME).uppercased()
    }
    
    
    
    class func getSelectStockiestsCode() -> [String]
    {
        var selectedList : [String] = []
        let selectedDCRList =  BL_DCR_Stockiests.sharedInstance.getDCRStockiestsList()
        
        for dcrStockiests in selectedDCRList
        {
            if dcrStockiests.Stockiest_Code != nil
            {
                selectedList.append(dcrStockiests.Stockiest_Code)
            }
        }
        
        return selectedList
    }
    
    class func getSelectedPOBStockiestCode() -> [String]
    {
        var selectedList : [String] = []
        let selectedPOBList = BL_POB_Stepper.sharedInstance.getPOBHeaderForDCRId(dcrId: DCRModel.sharedInstance.dcrId, visitId: DCRModel.sharedInstance.customerVisitId, customerEntityType: DCRModel.sharedInstance.customerEntityType)
        
        for selectedPOBObj in selectedPOBList
        {
            if selectedPOBObj.Stockiest_Code != nil && selectedPOBObj.Order_Status != Constants.OrderStatus.complete
            {
                selectedList.append(selectedPOBObj.Stockiest_Code)
            }
        }
        
        return selectedList
    }
    
    // MARK:- Private Functions
    private func getDCRId() -> Int
    {
        return DCRModel.sharedInstance.dcrId
    }
    
    private func getDCRCode() -> String
    {
        return DCRModel.sharedInstance.dcrCode
    }
    
    
}

class BL_Customer_Complaint: NSObject
{
    
    static let sharedInstance : BL_Customer_Complaint = BL_Customer_Complaint()
    var selectedCustomerDetail : CustomerMasterModel?
    var customerProblemText : String!
    var customerRemarkText : String!
    
    func getCustomerMasterList(regionCode: String,customerEntityType: String) -> [CustomerMasterModel]?
    {
        return DBHelper.sharedInstance.getCustomerMasterList(regionCode: regionCode, customerEntityType: customerEntityType)
    }
}

class ComplaintList: NSObject
{
    var Complaint_Date: String!
    var Problem_Short_Description: String!
    var Resolution_By: String!
    var Resolution_Date: Date?
    var Complaint_Status: Int!
    var Problem_Description: String!
    var Customer_Name: String!
    var Customer_Entity_Type: String!
    var Resolution_Remarks: String!
    var Region_Name: String!
}

class ICEFeedbackList: NSObject
{
    var Evaluation_Date: String!
    var Feedback_Remarks: String?
    var Feedback_Id: Int!
    var User_Code: String!
    var User_Name: String!
    var Feedback_Status: Int!
    var Created_By: String!
    var Created_DateTime: String!
    var Feedback_User_Employee_Name: String!
    var Created_By_Employee_Name: String!
    
}

class ICEQueAnsList: NSObject
{
    var Questions: String!
    var Question_Id: Int!
    var Question_Active: Int!
    var Question_Type: Int!
    var answerList : [ICEAnswerList]!
    var remarks:String = ""
    var isExpand:Bool = false
}
class ICEAnswerList:NSObject
{
    var Rating_Value : Int!
    var Rating_Description : String!
    var Question_Id: Int!
    var Parameter_Id: Int!
    var isSelected = false
}
class BL_ICE_Task: NSObject
{
    
    static let sharedInstance : BL_ICE_Task = BL_ICE_Task()
    var selectedDate = String()
}


class ICEAnswerHistory : NSObject
{
    var Questions : String!
    var Question_Id : Int!
    var Assigned_Rating : Int!
    var Remarks : String?
    var Feedback_Id : Int!
    var Question_Type : Int!
    var Rating_Description : String!
    var Rating_Value : Int!
    var Parameter_Id : Int!
}

class ICEAnswerHistoryList : NSObject
{
    var feedbackDetails : ICEFeedbackList!
    var feedbackHistoryList:[ICEAnswerHistory] = []
}

class TaskList : NSObject
{
    var Task_Name: String!
    var Task_Description: String?
    var Task_Id : Int!
    var Task_Status : Int!
    var Task_Due_Date: String!
    var Created_By: String!
    var Created_DateTime: String!
    var User_Name: String!
    var User_Code: String?
    var Task_Closed_Date: String!
    var Completed_On: String!
    var Assignee_Remarks: String?
    var Over_Due: Int!
    var Days_Left: Int!
    var After_Due: Int!
    var With_In: Int!
    var Created_By_Employee_Name: String!
    var Task_User_Employee_Name: String!
    var Updated_DateTime: String!
    
}



























