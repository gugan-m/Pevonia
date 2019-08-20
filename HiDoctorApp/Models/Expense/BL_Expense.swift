//
//  BL_Expense.swift
//  HiDoctorApp
//
//  Created by SwaaS on 13/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class BL_Expense: NSObject
{
    // MARK:- Local Variables
    static let sharedInstance = BL_Expense()
    var ZERO: Float = 0.0
    let TILDE: String = "~"
    var dcrExpenses: [DCRExpenseModel]?
    
    // MARK:- Public Functions
    func calculateFareForPrefillTypeExpenses()
    {
        let doctorVisitCount = getDoctorVisitCount()
        let chemistDayVisitCount = getChemistDayVisitCount()
        var dcrExpensesList: [DCRExpenseModel] = []
        
        if (((doctorVisitCount > 0 || chemistDayVisitCount > 0) && getSFCCount() > 0) || (DCRModel.sharedInstance.dcrFlag == DCRFlag.attendance.rawValue))
        {
            let dcrDate = getDcrDate()
            let expenseEntityCode = getExpenseEntityCode()
            
            dcrExpenses = getDCRExpenses()
            
            let prefillExpenseTypes = DBHelper.sharedInstance.getPrefillTypeExpenses(dcrDate: dcrDate, expenseEntityCode: expenseEntityCode)
            
            deletePrefillTypeExpenses(prefillExpenseTypes: prefillExpenseTypes)
            
            let dailyAllowances = getDailyAllowance(prefillExpenseTypes: prefillExpenseTypes)
            
            for objDA in dailyAllowances
            {
                dcrExpensesList.append(objDA)
            }
            
            let travelAllowances = getTravelAllowance(prefillExpenseTypes: prefillExpenseTypes)
            
            for objTA in travelAllowances
            {
                dcrExpensesList.append(objTA)
            }
            
            let _ = insertDCRExpense(dcrExpenseList: dcrExpensesList)

            let _ = getDCRExpenses()
        }
        
    }
    
    func getDCRExpenses() -> [DCRExpenseModel]?
    {
        return DBHelper.sharedInstance.getDCRExpenses(dcrId: getDcrId())
    }
    
    func getExpenseTypes() -> [ExpenseGroupMapping]?
    {
        return DBHelper.sharedInstance.getExpenseTypes()
    }
    
    func getUniqueExpenseTypes() -> [ExpenseGroupMapping]
    {
        let dailyModeExpenseList = DBHelper.sharedInstance.getDailyModeNoPrefillExpenseTypes(dcrActualDate: DCRModel.sharedInstance.dcrDateString, expenseEnityCode: DCRModel.sharedInstance.expenseEntityCode)
        let nonDailyModeExpenseList = DBHelper.sharedInstance.getNonDailyModeExpenseTypes(dcrActualDate: DCRModel.sharedInstance.dcrDateString)
        var resultArray: [ExpenseGroupMapping] = []
        
        if (dailyModeExpenseList.count > 0)
        {
            for objExpense in dailyModeExpenseList
            {
                resultArray.append(objExpense)
            }
        }
        
        if (nonDailyModeExpenseList.count > 0)
        {
            for objExpense in nonDailyModeExpenseList
            {
                resultArray.append(objExpense)
            }
        }
        
        return resultArray
    }
    
    func saveDcrExpense(expenseTypeCode: String, expenseAmount: Float, remarks: String, isPrefilled: Int, isEditable: Int, expenseMode: String)
    {
        let expenseEntityCode = DCRModel.sharedInstance.expenseEntityCode
        let expenseList = getExpenseTypes()!
        var filteredArray: [ExpenseGroupMapping] = []
        
        if (expenseMode.uppercased() == "DAILY")
        {
            filteredArray = expenseList.filter{
                $0.Expense_Type_Code == expenseTypeCode && $0.Expense_Entity_Code == expenseEntityCode
            }
        }
        else
        {
            filteredArray = expenseList.filter{
                $0.Expense_Type_Code == expenseTypeCode
            }
        }
        
        if (filteredArray.count > 0)
        {
            let expenseGroupObj = filteredArray[0]
            
            let dcrExpenseObj: DCRExpenseModel = generateExpenseModel(expenseGroupObj: expenseGroupObj, expenseAmount: expenseAmount, eligibilityAmount: expenseGroupObj.Eligibility_Amount, remarks: remarks, isPrefilled: isPrefilled,isEditable: isEditable)
            
            insertDCRExpense(dcrExpenseList: [dcrExpenseObj])
        }
    }
    
    func getPrefillAmount(expenseTypeCode: String) -> Float
    {
        var expenseAmount: Float = ZERO
        let expenseList = getExpenseTypes()
        
        if (expenseList != nil)
        {
            var filteredArray = expenseList!.filter{
                $0.Expense_Type_Code.uppercased() == expenseTypeCode.uppercased()
            }
            
            if (filteredArray.count > 0)
            {
                if (filteredArray[0].Expense_Mode.uppercased() == DAILY)
                {
                    filteredArray = expenseList!.filter{
                        $0.Expense_Type_Code.uppercased() == expenseTypeCode.uppercased() && $0.Expense_Entity_Code.uppercased() == DCRModel.sharedInstance.expenseEntityCode.uppercased()
                    }
                }
                
                if (filteredArray.count > 0)
                {
                    let expenseGroupObj = filteredArray[0]
                    
                    if (expenseGroupObj.Is_Prefill.uppercased() == "N")
                    {
                        let privilegeValue = PrivilegesAndConfigSettings.sharedInstance.getConfigSettingValue(configName: ConfigNames.DCR_NO_PREFIL_EXPENSE_VALUE)
                        
                        if (privilegeValue == ConfigValues.YES.rawValue)
                        {
                            expenseAmount = expenseGroupObj.Eligibility_Amount
                        }
                    }
                }
            }
        }
        
        return expenseAmount
    }
    
    func doEligibilityAmountValidation(enteredAmount: Float!, expenseTypeCode: String) -> Bool
    {
        var isValid: Bool = true
        let expenseList = getExpenseTypes()
        
        if (expenseList != nil)
        {
            var filteredArray = expenseList!.filter{
                $0.Expense_Type_Code.uppercased() == expenseTypeCode.uppercased()
            }
            
            if (filteredArray.count > 0)
            {
                if (filteredArray[0].Expense_Mode.uppercased() == DAILY)
                {
                    filteredArray = expenseList!.filter{
                        $0.Expense_Type_Code.uppercased() == expenseTypeCode.uppercased() && $0.Expense_Entity_Code.uppercased() == DCRModel.sharedInstance.expenseEntityCode.uppercased()
                    }
                }
                
                if (filteredArray.count > 0)
                {
                    let expenseGroupObj = filteredArray[0]
                    
                    if (expenseGroupObj.Is_Validation_On_Eligibility.uppercased() == "Y")
                    {
                        if (enteredAmount > expenseGroupObj.Eligibility_Amount)
                        {
                            isValid = false
                        }
                    }
                }
            }
        }
        
        return isValid
    }
    
    func isSameExpenseTypeAlreadyEntered(expenseTypeCode: String) -> Bool
    {
        var isAlreadyEntered: Bool = false
        let expenseList = getDCRExpenses()
        
        if (expenseList != nil)
        {
            if (expenseList!.count > 0)
            {
                let filteredArray = expenseList!.filter{
                    expenseTypeCode == $0.Expense_Type_Code
                }
                
                if (filteredArray.count > 0)
                {
                    isAlreadyEntered = true
                }
            }
        }
        
        return isAlreadyEntered
    }
    
    func updateDCRExpense(dcrExpenseObj: DCRExpenseModel)
    {
        return DBHelper.sharedInstance.updateDCRExpense(dcrExpenseObj: dcrExpenseObj)
    }
    
    func deleteDCRExpense(expenseTypeCode: String)
    {
        DBHelper.sharedInstance.deleteDCRExpense(expenseTypeCode: expenseTypeCode, dcrId: getDcrId())
    }
    
    func checkToValidateSpecialCharacter() -> String
    {
        return PrivilegesAndConfigSettings.sharedInstance.getDefaultConfigSettingValue(configName: ConfigNames.SPECIAL_CHARACTERS_TO_BE_RESTRICTED)
    }
    
    func checkIsExpenseRemarksMandatory(expenseCode : String) -> Bool
    {
        let expenseTypeObj = getExpenseTypeByExpenseCode(expenseCode: expenseCode)
        var IsMandatory : Bool = false
        
        if expenseTypeObj != nil
        {
            if expenseTypeObj!.Is_Remarks_Mandatory == 1
            {
                IsMandatory = true
            }
        }
        
        return IsMandatory
    }
    
    // MARK:- Private Functions
    // MARK:-- DCR Variable Functions
    private func getDcrDate() -> Date
    {
       return DCRModel.sharedInstance.dcrDate
    }
    
    private func getDcrId() -> Int
    {
        return DCRModel.sharedInstance.dcrId
    }
    
    private func getDcrCode() -> String
    {
        return DCRModel.sharedInstance.dcrCode
    }
    
    private func getDcrFlag() -> Int
    {
        return DCRModel.sharedInstance.dcrFlag
    }
    
    private func getExpenseEntityCode() -> String
    {
        return DCRModel.sharedInstance.expenseEntityCode
    }
    
    private func getDFC(travelMode: String) -> [DFCMaster]?
    {
        return DBHelper.sharedInstance.getDFC(dcrDate: getDcrDate(), expenseEntityCode: getExpenseEntityCode(), travelMode: travelMode)
    }
    
    private func getDcrSFC() -> [DCRTravelledPlacesModel]?
    {
        return DBHelper.sharedInstance.getDCRSFC(dcrId: getDcrId(), flag: getDcrFlag())
    }
    
    private func getDoctorVisitCount() -> Int
    {
        return DBHelper.sharedInstance.getDoctorVisitCountForDCRId(dcrId: getDcrId())
    }
    
    private func getChemistDayVisitCount() -> Int
    {
        return DBHelper.sharedInstance.getChemistDayVisitCountForDCRId(dcrId: getDcrId())
    }
    
    private func getSFCCount() -> Int
    {
        let sfcList = getDcrSFC()
        var count: Int = 0
        
        if (sfcList != nil)
        {
            count = sfcList!.count
        }
        
        return count
    }
    
    private func deletePrefillTypeExpenses(prefillExpenseTypes: [ExpenseGroupMapping]?)
    {
        if (prefillExpenseTypes != nil)
        {
            if (prefillExpenseTypes!.count > 0)
            {
                var expenseTypeCodes: [String] = []
                
                for expenseGroupObj in prefillExpenseTypes!
                {
                    expenseTypeCodes.append(expenseGroupObj.Expense_Type_Code)
                }
                
                DBHelper.sharedInstance.deletePrefillTypeExpenses(dcrId: getDcrId(), expenseTypeCodeArr: expenseTypeCodes)
            }
        }
        
        DBHelper.sharedInstance.deletePrefilledExpenses(dcrId: getDcrId())
    }
    
    // MARK:-- Calculation Functions
    private func getDailyAllowance(prefillExpenseTypes: [ExpenseGroupMapping]?) -> [DCRExpenseModel]
    {
        var expenseList: [DCRExpenseModel] = []
        
        if (prefillExpenseTypes != nil && (prefillExpenseTypes?.count)! > 0)
        {
            let dailyAllowanceList = prefillExpenseTypes!.filter{
                $0.SFC_Type == EXPENSE_GROUP_ELIGIBILITY
            }
            
            if (dailyAllowanceList.count > 0)
            {
                for expenseGroupObj in dailyAllowanceList
                {
                    var calculateDA: Bool = true
                    
                    if (isFirstActivity())
                    {
                        if (getDcrFlag() == DCRFlag.attendance.rawValue)
                        {
                            if (isFareDailyAllowancePrivEnabled(expenseTypeNme: expenseGroupObj.Expense_Type_Name))
                            {
                                if (isDailyAllowanceHidePrivEnabled())
                                {
                                    calculateDA = false
                                }
                            }
                        }
                    }
                    else
                    {
                        if (isFareDailyAllowancePrivEnabled(expenseTypeNme: expenseGroupObj.Expense_Type_Name))
                        {
                            if (isDailyAllowanceAlreadyEntered(expenseTypeCode: expenseGroupObj.Expense_Type_Code))
                            {
                                calculateDA = false
                            }
                            else
                            {
                                if (isDailyAllowanceHidePrivEnabled())
                                {
                                    calculateDA = false
                                }
                            }
                        }
                    }
                    
                    if (calculateDA)
                    {
                        let dcrExpenseObj = generateDCRExpenseModel(expenseGroupObj: expenseGroupObj)
                        expenseList.append(dcrExpenseObj)
                    }
                }
            }
        }
        
        return expenseList
    }
    
    private func isDailyAllowanceAlreadyEntered(expenseTypeCode: String) -> Bool
    {
        let count = DBHelper.sharedInstance.getDailyAllowanceEnteredCount(dcrDate: DCRModel.sharedInstance.dcrDateString, expenseTypeCode: expenseTypeCode)
        
        if (count > 0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    private func isFirstActivity() -> Bool
    {
        let count = DBHelper.sharedInstance.getDCRCountByDCRDate(dcrDate: getDcrDate())
        
        if (count == 0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    private func isDailyAllowanceHidePrivEnabled() -> Bool
    {
        var calculateDA: Bool = false
        
        if (getDcrFlag() == DCRFlag.attendance.rawValue)
        {
            let privilegeValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.DAILY_ALLOWANCE_TO_HIDE_FOR_ACTIVITIES).uppercased()
            
            if (privilegeValue != PrivilegeValues.EMPTY.rawValue)
            {
                let privArray = privilegeValue.components(separatedBy: ",")
                
                if (privArray.count > 0)
                {
                    let attendanceActivitiesList = BL_DCR_Attendance.sharedInstance.getDCRAttendanceActivities()
                    
                    if (attendanceActivitiesList != nil)
                    {
                        for objAttendanceActivity in attendanceActivitiesList!
                        {
                            if (privArray.contains(objAttendanceActivity.Activity_Name!.uppercased()))
                            {
                                calculateDA = true
                                break
                            }
                        }
                    }
                }
            }
        }
        
        return calculateDA
    }
    
    private func isFareDailyAllowancePrivEnabled(expenseTypeNme: String) -> Bool
    {
        var expenseTypeNme = expenseTypeNme
        var isPrivEnabled: Bool = false
        
        var privilegeValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.FARE_DAILY_ALLOWANCE).uppercased()
        privilegeValue = condenseWhitespace(stringValue: privilegeValue)
        
        expenseTypeNme = condenseWhitespace(stringValue: expenseTypeNme).uppercased()
        
        if (privilegeValue != PrivilegeValues.EMPTY.rawValue)
        {
            let privArray = privilegeValue.components(separatedBy: ",")
            
            if (privArray.count > 0)
            {
                if (privArray.contains(expenseTypeNme))
                {
                    isPrivEnabled = true
                }
            }
        }
        
        return isPrivEnabled
    }
    
    private func generateDCRExpenseModel(expenseGroupObj: ExpenseGroupMapping) -> DCRExpenseModel
    {
        var isEditable: Int = 0
        
        if (expenseGroupObj.Is_Prefill == EXPENSE_FLEXI)
        {
            isEditable = 1
        }
        
        let expenseAmount = expenseGroupObj.Eligibility_Amount
        let dcrExpenseObj = generateExpenseModel(expenseGroupObj: expenseGroupObj, expenseAmount: expenseAmount!, eligibilityAmount: expenseAmount!, remarks: "", isPrefilled: 1, isEditable: isEditable)
        
        let isExpEdited = isExpenseModified(expenseGroupObj: expenseGroupObj, expenseAmount: expenseAmount!)
        
        if (isExpEdited)
        {
            let filteredArray = dcrExpenses!.filter{
                $0.Expense_Type_Code == dcrExpenseObj.Expense_Type_Code
            }
            
            if (filteredArray.count > 0)
            {
                dcrExpenseObj.Expense_Amount = filteredArray[0].Expense_Amount
                dcrExpenseObj.Remarks = filteredArray[0].Remarks
            }
        }
        
        return dcrExpenseObj
    }
    
    private func isExpenseModified(expenseGroupObj: ExpenseGroupMapping, expenseAmount: Float) -> Bool
    {
        var result: Bool = false
        
        if (expenseGroupObj.Is_Prefill == EXPENSE_FLEXI)
        {
            if (dcrExpenses != nil)
            {
                let filteredArray = dcrExpenses!.filter{
                    $0.Expense_Type_Code == expenseGroupObj.Expense_Type_Code
                }
                
                if (filteredArray.count > 0)
                {
                    if (filteredArray[0].Expense_Amount != expenseAmount)
                    {
                        result = true
                    }
                    else
                    {
                        if (filteredArray[0].Remarks! != EMPTY)
                        {
                            result = true
                        }
                    }
                }
            }
        }
        
        return result
    }
    
    private func getTravelAllowance(prefillExpenseTypes: [ExpenseGroupMapping]?) -> [DCRExpenseModel]
    {
        var expenseList: [DCRExpenseModel] = []
        
        if (prefillExpenseTypes != nil && (prefillExpenseTypes?.count)! > 0)
        {
            let travelAllowanceList = prefillExpenseTypes!.filter{
                $0.SFC_Type.uppercased() != EXPENSE_GROUP_ELIGIBILITY.uppercased()
            }
            
            if (travelAllowanceList.count > 0)
            {
                for expenseGroupObj in travelAllowanceList
                {
                    var isEditable: Int = 0
                    
                    if (expenseGroupObj.Is_Prefill == EXPENSE_FLEXI)
                    {
                        isEditable = 1
                    }
                    
                    let expenseAmount = calculateTravelAllowance(expenseGroupObj: expenseGroupObj)
                    let dcrExpenseObj: DCRExpenseModel = generateExpenseModel(expenseGroupObj: expenseGroupObj, expenseAmount: expenseAmount, eligibilityAmount: expenseAmount, remarks: "", isPrefilled: 1, isEditable: isEditable)
                    let isExpModified = isExpenseModified(expenseGroupObj: expenseGroupObj, expenseAmount: expenseAmount)
                    
                    if (isExpModified)
                    {
                        let filteredArray = dcrExpenses!.filter{
                            $0.Expense_Type_Code == expenseGroupObj.Expense_Type_Code
                        }
                        
                        if (filteredArray.count > 0)
                        {
                            dcrExpenseObj.Expense_Amount = filteredArray[0].Expense_Amount
                            dcrExpenseObj.Remarks = filteredArray[0].Remarks
                        }
                    }
                    
                    expenseList.append(dcrExpenseObj)
                }
            }
        }
        
        return expenseList
    }
    
    private func generateExpenseModel(expenseGroupObj: ExpenseGroupMapping, expenseAmount: Float, eligibilityAmount: Float, remarks: String, isPrefilled: Int, isEditable: Int) -> DCRExpenseModel
    {
        let expenseDict: NSDictionary = ["DCR_Id": getDcrId(), "DCR_Code": getDcrCode(), "DCR_Expense_Type_Code": expenseGroupObj.Expense_Type_Code, "Expense_Type_Name": expenseGroupObj.Expense_Type_Name, "Expense_Amount": String(expenseAmount), "Expense_Mode": expenseGroupObj.Expense_Mode, "Eligibility_Amount": eligibilityAmount, "Expense_Group_Id": expenseGroupObj.Expense_Group_Id, "Expense_Claim_Code": "", "Expense_Remarks": remarks, "Is_Prefilled": isPrefilled, "Is_Editable": isEditable, "Flag": getDcrFlag()]
        
        let dcrExpenseObj: DCRExpenseModel = DCRExpenseModel(dict: expenseDict)
        
        return dcrExpenseObj
    }
    
    private func calculateTravelAllowance(expenseGroupObj: ExpenseGroupMapping) -> Float
    {
        var expenseAmount: Float = ZERO
        let eligibilityBase = expenseGroupObj.SFC_Type.uppercased()
        
        if (eligibilityBase == "S")
        {
            expenseAmount = calculateExpense_S()
        }
        else if (eligibilityBase == "D")
        {
            expenseAmount =  calculateExpense_D(isSlab: false, sumDistanceNeeded: expenseGroupObj.Sum_Distance_Needed)
        }
        else if (eligibilityBase == "D_SLAB")
        {
            expenseAmount =  calculateExpense_D(isSlab: true, sumDistanceNeeded: expenseGroupObj.Sum_Distance_Needed)
        }
        else if (eligibilityBase == "SD")
        {
            expenseAmount =  calculateExpense_SD(sumDistanceNeeded: expenseGroupObj.Sum_Distance_Needed, isSlab: false)
        }
        else if (eligibilityBase == "SD_SLAB")
        {
            expenseAmount =  calculateExpense_SD(sumDistanceNeeded: expenseGroupObj.Sum_Distance_Needed, isSlab: true)
        }
        else if (eligibilityBase == "DS")
        {
            expenseAmount =  calculateExpense_DS(sumDistanceNeeded: expenseGroupObj.Sum_Distance_Needed, isSlab: false)
        }
        else if (eligibilityBase == "DS_SLAB")
        {
            expenseAmount =  calculateExpense_DS(sumDistanceNeeded: expenseGroupObj.Sum_Distance_Needed, isSlab: true)
        }
        
        return expenseAmount
    }
    
    private func calculateExpense_S() -> Float
    {
        let dcrSFCList = getDcrSFC()
        var expenseAmount: Float = ZERO
        
        if (dcrSFCList != nil && (dcrSFCList?.count)! > 0)
        {
            for dcrSFCObj in dcrSFCList!
            {
                expenseAmount += calculateExpenseBySFC(dcrSFCObj: dcrSFCObj)
            }
        }
        
        return expenseAmount
    }
    
    private func calculateExpense_D(isSlab: Bool, sumDistanceNeeded: Int) -> Float
    {
        let dcrSFCList = getDcrSFC()
        var expenseAmount: Float = ZERO
        
        if (dcrSFCList != nil && (dcrSFCList?.count)! > 0)
        {
            if (sumDistanceNeeded == 1)
            {
                let travelModeAndDistances: [String] = getUniqueTravelModesAndDistance(sfcList: dcrSFCList!)
                
                for tmAndDistance in travelModeAndDistances
                {
                    let array = tmAndDistance.components(separatedBy: TILDE)
                    
                    if (isSlab)
                    {
                        expenseAmount += calculateExpense_D_SLAB(distance: Float(array[1])!, travelMode: array[0])
                    }
                    else
                    {
                        expenseAmount += calculateExpense_D_STEPUP(distance: Float(array[1])!, travelMode: array[0])
                    }
                }
            }
            else
            {
                for dcrSFCObj in dcrSFCList!
                {
                    if (isSlab)
                    {
                        expenseAmount += calculateExpense_D_SLAB(distance: dcrSFCObj.Distance, travelMode: dcrSFCObj.Travel_Mode)
                    }
                    else
                    {
                        expenseAmount += calculateExpense_D_STEPUP(distance: dcrSFCObj.Distance, travelMode: dcrSFCObj.Travel_Mode)
                    }
                }
            }
        }
        
        return expenseAmount
    }
    
    private func calculateExpenseBySFC(dcrSFCObj: DCRTravelledPlacesModel?) -> Float
    {
        var expenseAmount: Float = ZERO
        
        if (dcrSFCObj?.Distance_Fare_Code != nil && dcrSFCObj?.Distance_Fare_Code != "")
        {
            let sfcMasterObj = DBHelper.sharedInstance.getSFCBySFCCode(distanceFareCode: (dcrSFCObj?.Distance_Fare_Code!)!, sfcVersion: (dcrSFCObj?.SFC_Version)!, dcrDate: getDcrDate())
            
            if (sfcMasterObj != nil)
            {
                expenseAmount = (sfcMasterObj?.Fare_Amount)!
            }
        }
        
        return expenseAmount
    }
    
    private func calculateExpense_D_STEPUP(distance: Float!, travelMode: String) -> Float
    {
        var expenseAmount: Float = ZERO
        
        if (distance > 0.0)
        {
            let dfcList = getDFC(travelMode: travelMode)
            
            if (dfcList!.count > 0)
            {
                if (distance <= dfcList![dfcList!.count - 1].To_Km)
                {
                    var index = 0
                    
                    for dfcObj in dfcList!
                    {
                        if ((distance >= dfcObj.From_Km && distance <= dfcObj.To_Km))
                        {
                            break
                        }
                        
                        index += 1
                    }
                    
                    var remainingDistance: Float = distance
                    
                    for i in 0...index
                    {
                        if (i < index)
                        {
                            expenseAmount += dfcList![i].To_Km * dfcList![i].Fare_Amount
                            
                            remainingDistance -= dfcList![i].To_Km
                        }
                        else
                        {
                            expenseAmount += remainingDistance * dfcList![i].Fare_Amount
                        }
                    }
                }
            }
        }
        
        return expenseAmount
    }
    
    private func calculateExpense_D_SLAB(distance: Float!, travelMode: String) -> Float
    {
        var expenseAmount: Float = ZERO
        
        if (distance > 0.0)
        {
            let dfcList = getDFC(travelMode: travelMode)
            
            if (dfcList != nil && (dfcList?.count)! > 0)
            {
                let filteredDFC = dfcList?.filter {
                    distance >= $0.From_Km && distance <= $0.To_Km
                }
                
                if (filteredDFC != nil && (filteredDFC?.count)! > 0)
                {
                    expenseAmount = distance * (filteredDFC?[0].Fare_Amount)!
                }
            }
        }
        
        return expenseAmount
    }
    
    private func calculateExpense_SD(sumDistanceNeeded: Int, isSlab: Bool) -> Float
    {
        let dcrSFCList = getDcrSFC()
        var expenseAmount: Float = ZERO
        var notFoundInSFC: [DCRTravelledPlacesModel] = []
        
        if (dcrSFCList != nil && (dcrSFCList?.count)! > 0)
        {
            for dcrSFCObj in dcrSFCList!
            {
                let expAmount = calculateExpenseBySFC(dcrSFCObj: dcrSFCObj)
                
                if (expAmount == ZERO)
                {
                    notFoundInSFC.append(dcrSFCObj)
                }
                else
                {
                    expenseAmount += expAmount
                }
            }
            
            if (notFoundInSFC.count > 0)
            {
                if (sumDistanceNeeded == 1)
                {
                    let travelModeAndDistances: [String] = getUniqueTravelModesAndDistance(sfcList: notFoundInSFC)
                    
                    for tmAndDistance in travelModeAndDistances
                    {
                        let array = tmAndDistance.components(separatedBy: TILDE)
                        
                        if (isSlab)
                        {
                            expenseAmount += calculateExpense_D_SLAB(distance: Float(array[1])!, travelMode: array[0])
                        }
                        else
                        {
                            expenseAmount += calculateExpense_D_STEPUP(distance: Float(array[1])!, travelMode: array[0])
                        }
                    }
                }
                else
                {
                    for sfcObj in notFoundInSFC
                    {
                        if (isSlab)
                        {
                            expenseAmount += calculateExpense_D_SLAB(distance: sfcObj.Distance, travelMode: sfcObj.Travel_Mode)
                        }
                        else
                        {
                            expenseAmount += calculateExpense_D_STEPUP(distance: sfcObj.Distance, travelMode: sfcObj.Travel_Mode)
                        }
                    }
                }
            }
        }
        
        return expenseAmount
    }
    
    private func calculateExpense_DS(sumDistanceNeeded: Int, isSlab: Bool) -> Float
    {
        let dcrSFCList = getDcrSFC()
        var expenseAmount: Float = ZERO
        
        if (dcrSFCList != nil && (dcrSFCList?.count)! > 0)
        {
            if (sumDistanceNeeded == 1)
            {
                let travelModeAndDistances: [String] = getUniqueTravelModesAndDistance(sfcList: dcrSFCList!)
                
                for tmAndDistance in travelModeAndDistances
                {
                    let array = tmAndDistance.components(separatedBy: TILDE)
                    var fareAmount: Float = ZERO
                    let travelMode = array[0]
                    
                    if (isSlab)
                    {
                        fareAmount = calculateExpense_D_SLAB(distance: Float(array[1])!, travelMode: travelMode)
                    }
                    else
                    {
                        fareAmount = calculateExpense_D_STEPUP(distance: Float(array[1])!, travelMode: travelMode)
                    }
                    
                    if (fareAmount == ZERO)
                    {
                        let filteredArray = dcrSFCList!.filter{
                            travelMode.uppercased() == $0.Travel_Mode.uppercased()
                        }
                        
                        for sfcObj in filteredArray
                        {
                            expenseAmount += calculateExpenseBySFC(dcrSFCObj: sfcObj)
                        }
                    }
                    else
                    {
                        expenseAmount += fareAmount
                    }
                }
            }
            else
            {
                for dcrSFCObj in dcrSFCList!
                {
                    var fareAmount: Float = ZERO
                    
                    if (isSlab)
                    {
                        fareAmount = calculateExpense_D_SLAB(distance: dcrSFCObj.Distance, travelMode: dcrSFCObj.Travel_Mode)
                    }
                    else
                    {
                        fareAmount = calculateExpense_D_STEPUP(distance: dcrSFCObj.Distance, travelMode: dcrSFCObj.Travel_Mode)
                    }
                    
                    if (fareAmount == ZERO)
                    {
                        fareAmount = calculateExpenseBySFC(dcrSFCObj: dcrSFCObj)
                    }
                    
                    expenseAmount += fareAmount
                }
            }
        }
        
        return expenseAmount
    }
    
    private func getUniqueTravelModesAndDistance(sfcList: [DCRTravelledPlacesModel]) -> [String]
    {
        let travelModes = sfcList.map { $0.Travel_Mode.uppercased()}
        let uniqueTravelModes = Set(travelModes)
        var travelModeAndDistances: [String] = []
        
        for travelMode in uniqueTravelModes
        {
            let filteredArray = sfcList.filter{
                travelMode.uppercased() == $0.Travel_Mode.uppercased()
            }
            
            var sumDistance: Float = ZERO
            
            for sfcObj in filteredArray
            {
                sumDistance += sfcObj.Distance
            }
            
            travelModeAndDistances.append(travelMode + TILDE + String(sumDistance))
        }
        
        return travelModeAndDistances
    }
    
    private func insertDCRExpense(dcrExpenseList: [DCRExpenseModel])
    {
        DBHelper.sharedInstance.insertDCRExpenseDetails(dcrExpenseList: dcrExpenseList)
    }
    
    private func getExpenseTypeByExpenseCode(expenseCode : String) -> ExpenseGroupMapping?
    {
       return DBHelper.sharedInstance.getExpenseTypeByExpenseCode(dcrActualDate: DCRModel.sharedInstance.dcrDateString, expenseCode: expenseCode)
    }
}
