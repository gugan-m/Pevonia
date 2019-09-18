//
//  BL_POB_Stepper.swift
//  HiDoctorApp
//
//  Created by swaasuser on 19/04/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class BL_POB_Stepper: NSObject
{
    static let sharedInstance : BL_POB_Stepper = BL_POB_Stepper()
    
    var stepperDataList : [StepperPOBModel] = []
    var stockiestObj : DCRDoctorVisitPOBHeaderModel?
    var dueDate: Date?
    var salesProduct : [DCRDoctorVisitPOBDetailsModel]?
    var remarks : String?
    var dcrId : Int!
    var doctorVisitId : Int!
    var doctorObj:CustomerMasterModel!
    var chemistObj:CustomerMasterModel!
    var orderEntryId: Int!
    
    func getCurrentArray()
    {
        self.dcrId = DCRModel.sharedInstance.dcrId
        self.doctorVisitId = DCRModel.sharedInstance.doctorVisitId
        clearAllArray()
        getStockiestDetails()
        getDueDateDetail()
        getSaleProducts()
        getRemarks()
        determineButtonStatus()
    }
    
    func getStockiestDetails()
    {
        let stepperObjModel: StepperPOBModel = StepperPOBModel()
        
        stepperObjModel.sectionTitle = "Contributor"
        stepperObjModel.emptyStateTitle = "Contributor"
        stepperObjModel.emptyStateSubTitle = "Add Contributor Detail"
        stepperObjModel.isExpanded = false
        setStockiestObj()
        if (stockiestObj != nil)
        {
            stepperObjModel.showRightButton = true
            stepperObjModel.showLeftButton = true
            stepperObjModel.recordCount = 1
        }
        
        stepperDataList.append(stepperObjModel)
    }
    
    func getDueDateDetail()
    {
        let stepperObjModel: StepperPOBModel = StepperPOBModel()
        
        stepperObjModel.sectionTitle = "Due Date"
        stepperObjModel.emptyStateTitle = "Due Date"
        stepperObjModel.emptyStateSubTitle = "Add Due Date"
        stepperObjModel.isExpanded = false
        
        setDue()
        if (dueDate != nil)
        {
            stepperObjModel.recordCount = 1
        }
        
        stepperDataList.append(stepperObjModel)
    }
    
    func getSaleProducts()
    {
        let stepperObjModel: StepperPOBModel = StepperPOBModel()
        
        stepperObjModel.sectionTitle = "Sales Products"
        stepperObjModel.emptyStateTitle = "Sales Products"
        stepperObjModel.emptyStateSubTitle = "Add sales products"
        stepperObjModel.isExpanded = false
        stepperObjModel.sectionIconName = "icon-stepper-work-area"
        
        if self.orderEntryId != nil && self.orderEntryId != 0
        {
            self.salesProduct = setPOB()
        }
        
        if (salesProduct != nil)
        {
            stepperObjModel.recordCount = (salesProduct?.count)!
            stepperObjModel.showRightButton = true
            stepperObjModel.showLeftButton = true
        }
        
        stepperDataList.append(stepperObjModel)
    }
    
    func getRemarks()
    {
        let stepperObjModel: StepperPOBModel = StepperPOBModel()
        
        stepperObjModel.sectionTitle = "Remarks"
        stepperObjModel.emptyStateTitle = "Remarks"
        stepperObjModel.emptyStateSubTitle = "Add Remarks"
        stepperObjModel.isExpanded = false
        stepperObjModel.sectionIconName = "icon-stepper-remarks"
        
        if self.orderEntryId != nil && self.orderEntryId != 0
        {
            let remarksobj = self.getPOBRemarks(orderEntryId: self.orderEntryId)
            remarks = remarksobj?.Remarks
        }
        
        if (remarks != nil)
        {
            stepperObjModel.recordCount = 1
            stepperObjModel.showRightButton = true
            stepperObjModel.showLeftButton = false
        }
        
        stepperDataList.append(stepperObjModel)
    }
    
    private func determineButtonStatus()
    {
        if stockiestObj == nil
        {
            stepperDataList[0].showEmptyStateAddButton = true
        }
        else
        {
            if dueDate != nil
            {
                if salesProduct?.count == 0
                {
                    stepperDataList[2].showEmptyStateAddButton = true
                }
                else
                {
                    stepperDataList[2].showLeftButton = true
                    stepperDataList[2].showLeftButton = true
                }
                
                if remarks == nil && (salesProduct?.count)! > 0
                {
                    stepperDataList[3].showEmptyStateAddButton = true
                }
            }
            
        }
    }
    
    //MARK:-  Height Functions
    func getEmptyStateHeight(selectedIndex: Int) -> CGFloat
    {
        let stepperObj: StepperPOBModel = BL_POB_Stepper.sharedInstance.stepperDataList[selectedIndex]
        
        let topSpaceToContainer: CGFloat = 2
        let titleLabelHeight: CGFloat = getTextSize(text: stepperObj.emptyStateTitle, fontName: fontRegular, fontSize: 14, constrainedWidth: (SCREEN_WIDTH - (49 + 16))).height
        let verticalSpaceBetweenTitleAndSubTitle: CGFloat = 4
        let subTitleLabelHeight: CGFloat = getTextSize(text: stepperObj.emptyStateSubTitle, fontName: fontRegular, fontSize: 12, constrainedWidth: (SCREEN_WIDTH - (49 + 16))).height
        let verticalSpaceBetweenButtonAndSubTitle: CGFloat = 12
        var buttonHeight: CGFloat = 0
        
        if stepperObj.showEmptyStateAddButton == true
        {
            buttonHeight = 29
        }
        
        let bottomSpace: CGFloat = 20
        
        return topSpaceToContainer + titleLabelHeight + verticalSpaceBetweenTitleAndSubTitle + subTitleLabelHeight + verticalSpaceBetweenButtonAndSubTitle + buttonHeight + bottomSpace
    }
    
    func getCommonSingleCellHeight(selectedIndex: Int) -> CGFloat
    {
        let topSpace: CGFloat = 12
        let line1Height: CGFloat = 20
        let verticalSpaceBetweenLine1AndLine2: CGFloat = 4
        let line2Height: CGFloat = 20
        
        return topSpace + line1Height + verticalSpaceBetweenLine1AndLine2 + line2Height
    }
    
    func getCommonCellHeight(selectedIndex: Int) -> CGFloat
    {
        let stepperObj: StepperPOBModel = BL_POB_Stepper.sharedInstance.stepperDataList[selectedIndex]
        
        let titleSectionHeight: CGFloat = 30
        let buttonViewHeight: CGFloat = 60
        let bottomSpaceView: CGFloat = 20
        let cellY: CGFloat = 0
        var numberOfRows: Int = 1
        var childTableHeight: CGFloat = 0
        let topSpaceToCard : CGFloat = 10
        let pobAmtViewHeight : CGFloat = 60
        
        if (stepperObj.isExpanded == true)
        {
            numberOfRows = stepperObj.recordCount
        }
        
        for _ in 1...numberOfRows
        {
            childTableHeight += getCommonSingleCellHeight(selectedIndex: selectedIndex)
        }
        
        var totalHeight = titleSectionHeight + cellY + childTableHeight + buttonViewHeight + bottomSpaceView + topSpaceToCard + pobAmtViewHeight
        
        if (stepperObj.isExpanded == true || stepperObj.recordCount == 1)
        {
            totalHeight = totalHeight - 20
        }
        
        return totalHeight
    }
    
    func getStockiestsOrDueDateCellHeight(selectedIndex : Int) -> CGFloat
    {
        let sectionTitleHeight : CGFloat = 30
        let topSpaceToSectionTitle : CGFloat = 30
        var selectedIndexHeight : CGFloat = 0
        let bottomSpaceView: CGFloat = 20
        
        if selectedIndex == 0
        {
            selectedIndexHeight = 50
        }
        else
        {
            selectedIndexHeight = 40
        }
        
        let totalHeight =  sectionTitleHeight + topSpaceToSectionTitle + selectedIndexHeight + bottomSpaceView
        
        return totalHeight
    }
    
    func getGeneralRemarksCellHeight(selectedIndex: Int) -> CGFloat
    {
        let stepperObj: StepperPOBModel = BL_POB_Stepper.sharedInstance.stepperDataList[selectedIndex]
        
        let titleSectionHeight: CGFloat = 30
        let buttonViewHeight: CGFloat = 60
        let bottomSpaceView: CGFloat = 20
        let cellY: CGFloat = 0
        let childTableHeight: CGFloat = getGeneralRemarksSingleCellHeight(selectedIndex: selectedIndex)
        
        var totalHeight = titleSectionHeight + cellY + childTableHeight + buttonViewHeight + bottomSpaceView
        
        if (stepperObj.isExpanded == true || stepperObj.recordCount == 1)
        {
            totalHeight = totalHeight - 20
        }
        
        return totalHeight
    }
    
    func getGeneralRemarksSingleCellHeight(selectedIndex: Int) -> CGFloat
    {
        let topSpace: CGFloat = 12
        let line1Height: CGFloat = getTextSize(text: remarks, fontName: fontRegular, fontSize: 13, constrainedWidth: (SCREEN_WIDTH - 101)).height
        let verticalSpaceBetweenLine1AndLine2: CGFloat = 0
        let line2Height: CGFloat = 0
        
        return topSpace + line1Height + verticalSpaceBetweenLine1AndLine2 + line2Height
    }
    
    func getSalesProductCellHeight(index:Int) -> CGFloat
    {
        let topSpace : CGFloat = 5
        let bottomSpace: CGFloat = 5
        var lblheight : CGFloat = 0
        var totalHeight: CGFloat = 0
        var saleProductString: String = ""
        let obj = salesProduct?[index]
        let str = "ProductName: \(String(describing: obj?.Product_Name)) || UnitRate: \(String(describing: obj?.Product_Unit_Rate)) || Quantity: \(String(describing: obj?.Product_Qty)) || Amount: \(String(describing: obj?.Product_Amount))"
       saleProductString = str
       lblheight = getTextSize(text: saleProductString, fontName: fontRegular, fontSize: 14, constrainedWidth: SCREEN_WIDTH - 80).height
       totalHeight = topSpace + lblheight + bottomSpace
        
        return totalHeight
    }
    
    func getRemarksCellHeight() -> CGFloat
    {
        let topSpace : CGFloat = 5
        let bottomSpace: CGFloat = 5
        var lblheight : CGFloat = 0
        var totalHeight: CGFloat = 0
        
        lblheight = getTextSize(text: self.remarks, fontName: fontRegular, fontSize: 14, constrainedWidth: SCREEN_WIDTH - 80).height
        totalHeight = topSpace + lblheight + bottomSpace
        return totalHeight
    }
    
    //MARK:- Updating Stepper Arrays
    func setPOB() -> [DCRDoctorVisitPOBDetailsModel]?
    {
        var pobArray : [DCRDoctorVisitPOBDetailsModel] = []
        
        pobArray = self.getPOBDetailsForOrderEntryId(orderEntryID: self.orderEntryId)
        
        return pobArray
    }
    
    func setDue()
    {
        if self.orderEntryId != nil && self.orderEntryId != 0
        {
            let obj = self.getPOBHeaderforOrderEntryId(orderEntryID: self.orderEntryId)
            //            let date = convertDateIntoString(date: obj.Order_Due_Date)
            self.dueDate = obj.Order_Due_Date
            //convertDateIntoString(dateString: date)
        }
        
    }
    
    func setStockiestObj()
    {
        if orderEntryId != nil && self.orderEntryId != 0
        {
            let obj = self.getPOBHeaderforOrderEntryId(orderEntryID: self.orderEntryId)
            self.stockiestObj = obj
        }
        
        
    }
    
    //MARK:- Private function
    func clearAllArray()
    {
        stepperDataList = []
        stockiestObj = nil
        dueDate = nil
        salesProduct = []
        remarks = nil
    }
    
    //MARK:- DB related functions
    
    func insertPOBHeaderForChemist(stockiestsObj : CustomerMasterModel!,customerType: String!)
    {
        var dict = [String:Any] ()
        if(customerType == Constants.CustomerEntityType.chemist)
        {
        
            dict  = ["DCR_Id":DCRModel.sharedInstance.dcrId,"DCR_Actual_Date":DCRModel.sharedInstance.dcrDateString!,"DCR_Code":DCRModel.sharedInstance.dcrCode,"Order_Id":-1,"Order_Date":DCRModel.sharedInstance.dcrDateString!,"Stockiest_Name":stockiestsObj.Customer_Name,"Stockiest_Code":stockiestsObj.Customer_Code!,"Stockiest_Region_Code":stockiestsObj.Region_Code,"Customer_Name":ChemistDay.sharedInstance.customerName,"Customer_Code":ChemistDay.sharedInstance.customerCode,"Customer_Region_Code":ChemistDay.sharedInstance.regionCode,"Customer_MDLNumber":EMPTY,"Customer_CategoryCode":EMPTY,"Customer_Speciality":EMPTY,"Visit_Id": DCRModel.sharedInstance.customerVisitId,"Order_Due_Date":DCRModel.sharedInstance.dcrDateString!,"Order_Status":3,"Order_Mode":0,"Action_Mode":0,"Favouring_User_Code":getUserCode(),"Favouring_Region_Code":getRegionCode(),"Entity_Type":customerType]
        }
        else
        {
           dict  = ["DCR_Id":DCRModel.sharedInstance.dcrId,"DCR_Actual_Date":DCRModel.sharedInstance.dcrDateString!,"DCR_Code":DCRModel.sharedInstance.dcrCode,"Order_Id":-1,"Order_Date":DCRModel.sharedInstance.dcrDateString!,"Stockiest_Name":stockiestsObj.Customer_Name,"Stockiest_Code":stockiestsObj.Customer_Code!,"Stockiest_Region_Code":stockiestsObj.Region_Code,"Customer_Name":DCRModel.sharedInstance.doctorName,"Customer_Code":DCRModel.sharedInstance.customerCode,"Customer_Region_Code":DCRModel.sharedInstance.customerRegionCode,"Customer_MDLNumber":EMPTY,"Customer_CategoryCode":EMPTY,"Customer_Speciality":DCRModel.sharedInstance.doctorSpeciality,"Visit_Id": DCRModel.sharedInstance.customerVisitId,"Order_Due_Date":DCRModel.sharedInstance.dcrDateString!,"Order_Status":3,"Order_Mode":0,"Action_Mode":0,"Favouring_User_Code":getUserCode(),"Favouring_Region_Code":getRegionCode(),"Entity_Type":customerType]
        }
        
        let pobHeaderOBj = DCRDoctorVisitPOBHeaderModel(dict: dict as NSDictionary)
        
        if (pobHeaderOBj.Customer_Code == EMPTY && pobHeaderOBj.Customer_Region_Code == EMPTY)
        {
            pobHeaderOBj.Customer_Region_Code = getRegionCode()
        }
        
        let orderId = DBHelper.sharedInstance.insertPOBHeaderDetails(pobObj: pobHeaderOBj)
        self.orderEntryId = orderId
    }
    
    func insertPOBDetails(detailedProductList: [DCRDoctorVisitPOBDetailsModel])
    {
        for obj in detailedProductList
        {
            obj.DCR_Id = DCRModel.sharedInstance.dcrId
            obj.Order_Entry_Id = self.orderEntryId
            obj.DCR_Code = DCRModel.sharedInstance.dcrCode
        }
        DBHelper.sharedInstance.insertDetailedProductsPOB(array: detailedProductList)
    }
    
    func insertPOBRemarks(orderEntryId: Int,remarks: String)
    {
        var remarksList: [[String:Any]] = []
        
        let dict :[String:Any] = ["Order_Entry_Id":orderEntryId,"DCR_Id":DCRModel.sharedInstance.dcrId,"Remarks": remarks,"DCR_Code":DCRModel.sharedInstance.dcrCode]
        
        remarksList.append(dict)
        
        DBHelper.sharedInstance.insertDCRDoctorVisitOrderRemarksDetails(array: remarksList as NSArray)
    }
    
    func updatePOBHeader(stockiestCode: String, stockiestRegionCode: String, orderEntryId: Int)
    {
        DBHelper.sharedInstance.updateDCRDoctorVisitOrderHeaderDetails(stockiestCode: stockiestCode, stockiestRegionCode: stockiestRegionCode, orderEntryId: orderEntryId)
    }
    
    func updatePOBHeaderOrderStatus(orderEntryId: Int,orderStatus: Int)
    {
        DBHelper.sharedInstance.updateOrderHeaderDetailsOrderStatus(orderEntryId: orderEntryId,orderstatus: orderStatus)
    }
    
    func updateDueDateInPOBHeader(dueDate: String,orderEntryId: Int)
    {
        DBHelper.sharedInstance.updateDueDateInPOBHeader(dueDate: dueDate, orderEntryId: orderEntryId)
    }
    
    func updatePOBRemarks(orderEntryId: Int,remarks: String)
    {
        DBHelper.sharedInstance.updatePOBRemarks(orderEntryId: orderEntryId, remarks: remarks)
    }
    
    func getPOBHeaderForDCRId(dcrId: Int, visitId: Int,customerEntityType: String) -> [DCRDoctorVisitPOBHeaderModel]
    {
        return DBHelper.sharedInstance.getPOBHeaderForDCRId(dcrId: dcrId, visitId: visitId, customerEntityType: customerEntityType)
    }
    
    func getPOBDetailsBasedOnCustomer(dcrId: Int, visitId: Int,customerEntityType: String,orderEntryId: Int) -> [DCRDoctorVisitPOBDetailsModel]?
    {
        return DBHelper.sharedInstance.getPOBDetailsBasedOnCustomer(dcrId: dcrId, visitId: visitId, customerEntityType: customerEntityType, orderEntryId: orderEntryId)
    }
    
    func getPOBHeaderforOrderEntryId(orderEntryID: Int) -> DCRDoctorVisitPOBHeaderModel
    {
        return DBHelper.sharedInstance.getPOBHeaderForOrderEntryId(orderEntryId: orderEntryID)!
    }
    
    func getPOBDetailsForOrderEntryId(orderEntryID: Int) -> [DCRDoctorVisitPOBDetailsModel]
    {
        return DBHelper.sharedInstance.getPOBDetailsForOrderEntryId(orderEntryId: orderEntryID)
    }
    
    func getPOBDetailsForDCRId(dcrId: Int,visitId:Int) -> [DCRDoctorVisitPOBDetailsModel]?
    {
        var pobDetailsList :[DCRDoctorVisitPOBDetailsModel]?
        
        return pobDetailsList
    }
    
    func getPOBRemarks(orderEntryId: Int) -> DCRDoctorVisitPOBRemarksModel?
    {
        return DBHelper.sharedInstance.getPOBRemarks(orderEntryId: self.orderEntryId)
    }
    
    func deletePOBDetails(orderEntryId: Int)
    {
        DBHelper.sharedInstance.deletePOBDetails(orderEntryId: orderEntryId)
    }
    
    func deletePOBDetailsForOrderDetailId(orderEntryId: Int,orderDetailId: Int)
    {
        DBHelper.sharedInstance.deletePOBDetailsForOrderDetailId(orderEntryId: orderEntryId,orderDetailId: orderDetailId)
    }
    
    func deletePOBRemarks(orderEntryId: Int)
    {
        DBHelper.sharedInstance.deletePOBRemarks(orderEntryId: orderEntryId)
    }
    
    func deletePOBHeader(orderEntryId: Int)
    {
        DBHelper.sharedInstance.deletePOBHeader(orderEntryId: orderEntryId)
    }
    
//    func getStockiestName(stockiestCode: String) -> String!
//    {
//        var stockiestName: String!
//        let stockiestObj = DBHelper.sharedInstance.getStockiestName(stockiestCode: stockiestCode,customerEntityType: "STOCKIEST")
//        
//        if (stockiestObj != nil)
//        {
//            if stockiestObj?.Customer_Name != nil
//            {
//                stockiestName = stockiestObj!.Customer_Name!
//            }
//            else
//            {
//                stockiestName = ""
//            }
//        }
//        
//        return stockiestName
//    }
    
    func getNoOfProducts(orderEntryId: Int) -> Int
    {
        let productsList = DBHelper.sharedInstance.getPOBDetailsForOrderEntryId(orderEntryId: orderEntryId)
        
        return productsList.count
    }
    
    func totalAmountcalculation(orderEntryId: Int) -> Double
    {
        var totalAmount : Double = 0.0
        let list = self.getPOBDetailsForOrderEntryId(orderEntryID: orderEntryId)
        
        for obj in list
        {
            let amount = obj.Product_Amount
            totalAmount = totalAmount + amount!
        }
        
        return totalAmount
    }
}
