//
//  BL_DoctorList.swift
//  HiDoctorApp
//
//  Created by swaasuser on 03/02/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class BL_DoctorList: NSObject
{
    static let sharedInstance : BL_DoctorList = BL_DoctorList()
    
    var regionCode : String  = ""
    var customerCode : String = ""
    var doctorTitle : String = ""
    var selectedImage: [String] = []
    var selectedImageData : NSData = NSData()
    var customerSpecialityArray : NSMutableArray = NSMutableArray()
    var customerCategoryArray : NSMutableArray = NSMutableArray()
    var pickerState = String()
    var doctorDataList:[DoctorListModel] = []
    var punchInTime : String = ""
    var modifyEntity : Int = 0
    
    var selectedCustomer: CustomerMasterModel?
    
    func getDoctorDataList(isEdit:Bool) -> [DoctorListModel]
    {
        var doctorDataList : [DoctorListModel] = []
        var totalCount = Int()
        if(isEdit)
        {
           totalCount = 4
        }
        else
        {
            totalCount = 6
        }
        
        for index : Int in 0 ..< totalCount
        {
            var reportObject = DoctorListModel()
            if(isEdit)
            {
                reportObject.sectionTitle = ["\(appDoctor) Official Details","\(appDoctor) Personal Details","Account Details", "Other Information"][index]
            }
            else
            {
                reportObject.sectionTitle = ["\(appDoctor) Official Details","\(appDoctor) Personal Details","Account Details", "Other Information","Marketing Campaign Products","Products Mapped"][index]
            }
            reportObject.sectionType = DoctorListSectionHeader.init(rawValue: index)!
            doctorDataList.append(reportObject)
        }
        
        return doctorDataList
    }
    
    func clearAllArray()
    {
        regionCode = ""
        customerCode = ""
        doctorTitle = ""
        selectedImage = []
        selectedImageData = NSData()
        customerSpecialityArray = NSMutableArray()
        customerCategoryArray = NSMutableArray()
        pickerState = String()
        doctorDataList = []
    }
    
    //MARK:- Cusomter List Functions
    func getDoctorOfficialDetails() -> [DoctorDataListModel]
    {
        let doctorDetailObj = BL_DCR_Doctor_Visit.sharedInstance.getCustomerMasterByCustomerCode(customerCode: customerCode, regionCode: regionCode)
        var doctorOfficialList : [DoctorDataListModel] = []
        
        if doctorDetailObj != nil
        {
            var dataListObj : DoctorDataListModel = DoctorDataListModel()
            
            // Doctor Name
            dataListObj.headerTitle = "\(appDoctor) Name"
            dataListObj.value = doctorDetailObj!.Customer_Name
            doctorOfficialList.append(dataListObj)
            
            // Region Name
            dataListObj = DoctorDataListModel()
            dataListObj.headerTitle = "Territory Name"
            dataListObj.value = doctorDetailObj!.Region_Name
            doctorOfficialList.append(dataListObj)
            
            // Specialty
            dataListObj = DoctorDataListModel()
            dataListObj.headerTitle = "Position"
            dataListObj.value = doctorDetailObj!.Speciality_Name
            doctorOfficialList.append(dataListObj)
            
//            // MDL Number
//            dataListObj = DoctorDataListModel()
//            dataListObj.headerTitle = ccmNumberCaption
//            dataListObj.value = ccmNumberPrefix + doctorDetailObj!.MDL_Number
//            doctorOfficialList.append(dataListObj)
            
            // Category
            dataListObj = DoctorDataListModel()
            dataListObj.headerTitle = "Category Name"
            dataListObj.value = doctorDetailObj!.Category_Name
            doctorOfficialList.append(dataListObj)
        }
        
        return doctorOfficialList
    }
    
    func getDoctorPersonalDetailsList() -> [DoctorDataListModel]
    {
        let doctorPersonalDetailObj = getDoctorPersonalInfo()
        var doctorPersonalInfoList : [DoctorDataListModel] = []
        var dataListObj : DoctorDataListModel = DoctorDataListModel()
        var dob : String = NOT_APPLICABLE
        
        if doctorPersonalDetailObj?.DOB != nil
        {
            dob = checkNullAndNilValueForString(stringData: convertDateIntoString( date : (doctorPersonalDetailObj?.DOB)!))
        }
        
        dataListObj.headerTitle = "Date of Birth"
        dataListObj.value = dob
        doctorPersonalInfoList.append(dataListObj)
        
        dataListObj = DoctorDataListModel()
        var anniversaryDate : String = NOT_APPLICABLE
        
        if doctorPersonalDetailObj?.Anniversary_Date != nil
        {
            anniversaryDate = checkNullAndNilValueForString(stringData: convertDateIntoString( date : (doctorPersonalDetailObj?.Anniversary_Date)!))
        }
        
        dataListObj.headerTitle = "Anniversary Date"
        dataListObj.value = anniversaryDate
        doctorPersonalInfoList.append(dataListObj)
        
        dataListObj = DoctorDataListModel()
        dataListObj.headerTitle = "Email Id"
        dataListObj.value = checkNullAndNilValueForString(stringData: doctorPersonalDetailObj?.Email_Id)
        doctorPersonalInfoList.append(dataListObj)
        
        dataListObj = DoctorDataListModel()
        dataListObj.headerTitle = "Phone Number"
        dataListObj.value = checkNullAndNilValueForString(stringData: doctorPersonalDetailObj?.Mobile_Number)
        doctorPersonalInfoList.append(dataListObj)
        
        dataListObj = DoctorDataListModel()
        dataListObj.headerTitle = "Alternate Phone Number"
        dataListObj.value = checkNullAndNilValueForString(stringData: doctorPersonalDetailObj?.Alternate_Number)
        doctorPersonalInfoList.append(dataListObj)
        
        dataListObj = DoctorDataListModel()
        dataListObj.headerTitle = "Registration Number"
        dataListObj.value = checkNullAndNilValueForString(stringData: doctorPersonalDetailObj?.Registration_Number)
        doctorPersonalInfoList.append(dataListObj)
        
        dataListObj = DoctorDataListModel()
        dataListObj.headerTitle = "Assistant Phone Number"
        dataListObj.value = checkNullAndNilValueForString(stringData: doctorPersonalDetailObj?.Assistant_Number)
        
        doctorPersonalInfoList.append(dataListObj)
        
        return doctorPersonalInfoList
    }
    
    func getDoctorHospitalDetailsList() -> [DoctorDataListModel]
    {
        let doctorHospitalInfo = getDoctorPersonalInfo()
        var doctorHospitalInfoList : [DoctorDataListModel] = []
        var dataListObj : DoctorDataListModel = DoctorDataListModel()
        
        dataListObj.headerTitle = PEV_HOSPITAL_NAME
        dataListObj.value = checkNullAndNilValueForString(stringData: doctorHospitalInfo?.Hospital_Name)
        doctorHospitalInfoList.append(dataListObj)
        
        dataListObj = DoctorDataListModel()
        dataListObj.headerTitle = "\(PEV_HOSPITAL_ADDRESS)"
        dataListObj.value = checkNullAndNilValueForString(stringData: doctorHospitalInfo?.Hospital_Address)
        doctorHospitalInfoList.append(dataListObj)
        
        return doctorHospitalInfoList
    }
    
    func getDoctorOtherDetails() -> [DoctorDataListModel]
    {
        let doctorOtherInfo = getDoctorPersonalInfo()
        var doctorOtherInfoList : [DoctorDataListModel] = []
        let dataListObj : DoctorDataListModel = DoctorDataListModel()
        
        dataListObj.headerTitle = "Notes"
        dataListObj.value = checkNullAndNilValueForString(stringData:doctorOtherInfo?.Notes)
        
        doctorOtherInfoList.append(dataListObj)
        
        return doctorOtherInfoList
    }
    func getDoctorProductMappingDetails() -> [DoctorDataListModel]
    {
        let doctorProductObjs = getDoctorProductMaping()
        var doctorProductMappingList : [DoctorDataListModel] = []
        
        if(doctorProductObjs.count == 0 )
        {
            let dataListObj : DoctorDataListModel = DoctorDataListModel()
            dataListObj.headerTitle = EMPTY
            dataListObj.value = EMPTY
            doctorProductMappingList.append(dataListObj)
        }
        else
        {
            for doctorProductObj in doctorProductObjs
            {
                let dataListObj : DoctorDataListModel = DoctorDataListModel()
                dataListObj.headerTitle = doctorProductObj.Product_Name + " | " + doctorProductObj.Brand_Name
                let orderValue = doctorProductObj.Priority_Order as Int
                var orderValueString = String()
                if(orderValue == productDefaultPriorityOrder)
                {
                   orderValueString = NOT_APPLICABLE
                }
                else
                {
                    orderValueString = String(orderValue)
                }
                dataListObj.value = "Priority: " + orderValueString
                
                doctorProductMappingList.append(dataListObj)
            }
        }
        return doctorProductMappingList
    }
    
    func getMCDoctorProductMappingDetails() -> [DoctorDataListModel]
    {
        let doctorProductObjs = getMCDoctorProductMaping()
        var doctorProductMappingList : [DoctorDataListModel] = []
        
        if(doctorProductObjs.count == 0 )
        {
            let dataListObj : DoctorDataListModel = DoctorDataListModel()
            dataListObj.headerTitle = EMPTY
            dataListObj.value = EMPTY
            doctorProductMappingList.append(dataListObj)
        }
        else
        {
            for doctorProductObj in doctorProductObjs
            {
                let dataListObj : DoctorDataListModel = DoctorDataListModel()
                dataListObj.headerTitle = doctorProductObj.Product_Name + " | " + doctorProductObj.Brand_Name
                dataListObj.value = doctorProductObj.MC_Name + " | " + "Priority: " + String(doctorProductObj.Priority_Order)
                
                doctorProductMappingList.append(dataListObj)
            }
        }
        return doctorProductMappingList
    }
    
    func getDoctorProfileImgUrl() -> String
    {
        var url : String = ""
        let obj = getDoctorPersonalInfo()
        
        if obj != nil
        {
            url = checkNullAndNilValueForString(stringData: (obj?.Blob_Photo_Url))
        }
        
        return url
    }
    
    //MARK:- Customer Master Edit
    func getDoctorOfficialDetailsForEdit() -> [DoctorDataListModel]
    {
        let doctorDetailObj = BL_DCR_Doctor_Visit.sharedInstance.getCustomerMasterByCustomerCodeForEdit(customerCode: customerCode, regionCode: regionCode)
        var doctorOfficialList : [DoctorDataListModel] = []
        let privMandFieldModify: String = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.DOCTOR_MANDATORY_FIELD_MODIFICATION).uppercased()
        let privDoctorCategory: String = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.DOCTOR_CATEGORY).uppercased()
        let privCanChangeCustomerName: String = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.CAN_CHANGE_CUSTOMER_NAME).uppercased()
        
        if doctorDetailObj != nil
        {
            var dataListObj : DoctorDataListModel = DoctorDataListModel()
            
            // Doctor Name
            dataListObj.headerTitle = "\(appDoctor) Name"
            dataListObj.value = doctorDetailObj!.Customer_Name
            dataListObj.isEditable = true
            dataListObj.isMandatory = true
            dataListObj.controlType = controlValues.Text
            dataListObj.newValue = doctorDetailObj!.Customer_Name
            dataListObj.Code_Value = doctorDetailObj!.Customer_Code
            
            if (doctorDetailObj!.Customer_Status == Constants.Customer_Status.Approved && privCanChangeCustomerName == PrivilegeValues.NO.rawValue)
            {
                dataListObj.isEditable = false
                dataListObj.controlType = controlValues.Label
            }
            
            doctorOfficialList.append(dataListObj)
            
            // Region Name
            dataListObj = DoctorDataListModel()
            dataListObj.headerTitle = "Territory Name"
            dataListObj.value = doctorDetailObj!.Region_Name
            dataListObj.isEditable = false
            dataListObj.isMandatory = true
            dataListObj.controlType = controlValues.Label
            dataListObj.Code_Value = doctorDetailObj!.Region_Code
            doctorOfficialList.append(dataListObj)
            
            // Doctor Status
            dataListObj = DoctorDataListModel()
            dataListObj.headerTitle = "Status"
            dataListObj.value = getCustomerStatusName(status: doctorDetailObj!.Customer_Status)
            dataListObj.isEditable = false
            dataListObj.isMandatory = true
            dataListObj.controlType = controlValues.Label
            dataListObj.Code_Value = String(doctorDetailObj!.Customer_Status)
            doctorOfficialList.append(dataListObj)
            
            // Specialty
            dataListObj = DoctorDataListModel()
            dataListObj.headerTitle = "Position"
            dataListObj.value = doctorDetailObj!.Speciality_Name
            dataListObj.isEditable = true
            dataListObj.isMandatory = true
            dataListObj.controlType = controlValues.Picker
            dataListObj.Code_Value = doctorDetailObj!.Speciality_Code
            dataListObj.newValue = doctorDetailObj!.Speciality_Name
            
            if (doctorDetailObj!.Customer_Status == Constants.Customer_Status.Approved && privMandFieldModify == PrivilegeValues.DISABLED.rawValue)
            {
                dataListObj.isEditable = false
                dataListObj.controlType = controlValues.Label
            }
            
            doctorOfficialList.append(dataListObj)
            
//            // MDL Number
//            dataListObj = DoctorDataListModel()
//            dataListObj.headerTitle = ccmNumberCaption
//           // dataListObj.value = ccmNumberPrefix + doctorDetailObj!.MDL_Number
//            dataListObj.isEditable = true
//            dataListObj.isMandatory = true
//            dataListObj.controlType = controlValues.Text
//            dataListObj.newValue = doctorDetailObj!.MDL_Number
//
//            if (doctorDetailObj!.Customer_Status == Constants.Customer_Status.Approved && privMandFieldModify == PrivilegeValues.DISABLED.rawValue)
//            {
//                dataListObj.isEditable = false
//                dataListObj.controlType = controlValues.Label
//            }
//
//            doctorOfficialList.append(dataListObj)
//
            // Category
            dataListObj = DoctorDataListModel()
            dataListObj.headerTitle = "Category Name"
            dataListObj.value = checkNullAndNilValueForString(stringData: doctorDetailObj!.Category_Name)
            dataListObj.isEditable = true
            dataListObj.controlType = controlValues.Picker
            dataListObj.Code_Value = checkNullAndNilValueForString(stringData: doctorDetailObj?.Category_Code)
            dataListObj.newValue = checkNullAndNilValueForString(stringData: doctorDetailObj!.Category_Name)
            
            if (doctorDetailObj!.Customer_Status == Constants.Customer_Status.Approved && privMandFieldModify == PrivilegeValues.DISABLED.rawValue)
            {
                dataListObj.isEditable = false
                dataListObj.controlType = controlValues.Label
            }
            
            if (privDoctorCategory == PrivilegeValues.YES.rawValue)
            {
                dataListObj.isMandatory = true
            }
            else
            {
                dataListObj.isMandatory = false
            }
            
            doctorOfficialList.append(dataListObj)
        }
        
        return doctorOfficialList
    }
    
    func getDoctorPersonalDetailsListForEdit() -> [DoctorDataListModel]
    {
        let doctorPersonalDetailObj = getDoctorPersonalInfoEdit()
        var doctorPersonalInfoList : [DoctorDataListModel] = []
        var dataListObj : DoctorDataListModel = DoctorDataListModel()
        var dob : String = NOT_APPLICABLE
        let privMandColumnsList = PrivilegesAndConfigSettings.sharedInstance.getConfigSettingValue(configName: ConfigNames.DOCTOR_MASTER_MANDATORY_COLUMNS).uppercased()
        let privArray = privMandColumnsList.components(separatedBy: ",")
        
        if doctorPersonalDetailObj?.DOB != nil
        {
            dob = checkNullAndNilValueForString(stringData: convertDateIntoString( date : (doctorPersonalDetailObj?.DOB)!))
        }
        
        dataListObj.headerTitle = "Date of Birth"
        dataListObj.value = dob
        dataListObj.isEditable = true
        dataListObj.isMandatory = false
        dataListObj.controlType = controlValues.Date
        dataListObj.newValue = dob
        doctorPersonalInfoList.append(dataListObj)
        
        dataListObj = DoctorDataListModel()
        
        var anniversaryDate : String = NOT_APPLICABLE
        
        if doctorPersonalDetailObj?.Anniversary_Date != nil
        {
            anniversaryDate = checkNullAndNilValueForString(stringData: convertDateIntoString( date : (doctorPersonalDetailObj?.Anniversary_Date)!))
        }
        
        dataListObj.headerTitle = "Anniversary Date"
        dataListObj.value = anniversaryDate
        dataListObj.isEditable = true
        dataListObj.isMandatory = false
        dataListObj.controlType = controlValues.Date
        dataListObj.newValue = anniversaryDate
        doctorPersonalInfoList.append(dataListObj)
        
        dataListObj = DoctorDataListModel()
        
        dataListObj.headerTitle = "Email Id"
        dataListObj.value = checkNullAndNilValueForString(stringData: doctorPersonalDetailObj?.Email_Id)
        dataListObj.isEditable = true
        dataListObj.isMandatory = false
        dataListObj.controlType = controlValues.Text
        dataListObj.newValue = checkNullAndNilValueForString(stringData: doctorPersonalDetailObj?.Email_Id)
        doctorPersonalInfoList.append(dataListObj)
        
        dataListObj = DoctorDataListModel()
        
        dataListObj.headerTitle = "Phone Number"
        dataListObj.value = checkNullAndNilValueForString(stringData: doctorPersonalDetailObj?.Mobile_Number)
        dataListObj.isEditable = true
        
        if (privArray.contains(ConfigValues.MOBILE.rawValue.uppercased()))
        {
            dataListObj.isMandatory = true
        }
        else
        {
            dataListObj.isMandatory = false
        }
        
        dataListObj.controlType = controlValues.Number
        dataListObj.newValue = checkNullAndNilValueForString(stringData: doctorPersonalDetailObj?.Mobile_Number)
        doctorPersonalInfoList.append(dataListObj)
        
        dataListObj = DoctorDataListModel()
        
        dataListObj.headerTitle = "Alternate Phone Number"
        dataListObj.value = checkNullAndNilValueForString(stringData: doctorPersonalDetailObj?.Alternate_Number)
        dataListObj.isEditable = true
        dataListObj.isMandatory = false
        dataListObj.controlType = controlValues.Number
        dataListObj.newValue = checkNullAndNilValueForString(stringData: doctorPersonalDetailObj?.Alternate_Number)
        doctorPersonalInfoList.append(dataListObj)
        
        dataListObj = DoctorDataListModel()
        
        dataListObj.headerTitle = "Registration Number"
        dataListObj.value = checkNullAndNilValueForString(stringData: doctorPersonalDetailObj?.Registration_Number)
        dataListObj.isEditable = true
        
        if (privArray.contains(ConfigValues.REGISTRATION_NO.rawValue.uppercased()))
        {
            dataListObj.isMandatory = true
        }
        else
        {
            dataListObj.isMandatory = false
        }
        dataListObj.controlType = controlValues.Text
        dataListObj.newValue = checkNullAndNilValueForString(stringData: doctorPersonalDetailObj?.Registration_Number)
        doctorPersonalInfoList.append(dataListObj)
        
        dataListObj = DoctorDataListModel()
        
        dataListObj.headerTitle = "Assistant Phone Number"
        dataListObj.value = checkNullAndNilValueForString(stringData: doctorPersonalDetailObj?.Assistant_Number)
        dataListObj.isEditable = true
        dataListObj.isMandatory = false
        dataListObj.controlType = controlValues.Number
        dataListObj.newValue = checkNullAndNilValueForString(stringData: doctorPersonalDetailObj?.Assistant_Number)
        
        doctorPersonalInfoList.append(dataListObj)
        
        return doctorPersonalInfoList
    }
    func getCustomerCategoryNameList(regionCode: String,completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        
        WebServiceHelper.sharedInstance.getCustomerCategoryNameList(regionCode: regionCode) { (objApiResponse) in
            completion(objApiResponse)
        }
    }
    
    func getSpecialityNameList(completion: @escaping (_ apiResponseObj: ApiResponseModel) -> ())
    {
        
        WebServiceHelper.sharedInstance.getSpecialityNameList { (objApiResponse) in
            completion(objApiResponse)
        }
    }
    
    func getDoctorHospitalDetailsListForEdit() -> [DoctorDataListModel]
    {
        let doctorHospitalInfo = getDoctorPersonalInfoEdit()
        var doctorHospitalInfoList : [DoctorDataListModel] = []
        var dataListObj : DoctorDataListModel = DoctorDataListModel()
        let privMandColumnsList = PrivilegesAndConfigSettings.sharedInstance.getConfigSettingValue(configName: ConfigNames.DOCTOR_MASTER_MANDATORY_COLUMNS).uppercased()
        let privArray = privMandColumnsList.components(separatedBy: ",")
        
        dataListObj.headerTitle = PEV_HOSPITAL_NAME
        dataListObj.value = checkNullAndNilValueForString(stringData: doctorHospitalInfo?.Hospital_Name)
        dataListObj.isEditable = true
        
        if (privArray.contains(ConfigValues.HOSPITAL_NAME.rawValue.uppercased()))
        {
            dataListObj.isMandatory = true
        }
        else
        {
            dataListObj.isMandatory = false
        }
        
        dataListObj.controlType = controlValues.Text
        dataListObj.newValue = checkNullAndNilValueForString(stringData: doctorHospitalInfo?.Hospital_Name)
        doctorHospitalInfoList.append(dataListObj)
        
        dataListObj = DoctorDataListModel()
        
        dataListObj.headerTitle = "\(PEV_HOSPITAL_ADDRESS)"
        dataListObj.value = checkNullAndNilValueForString(stringData: doctorHospitalInfo?.Hospital_Address)
        dataListObj.isEditable = true
        dataListObj.isMandatory = false
        dataListObj.controlType = controlValues.Text
        dataListObj.newValue = checkNullAndNilValueForString(stringData: doctorHospitalInfo?.Hospital_Address)
        doctorHospitalInfoList.append(dataListObj)
        
        return doctorHospitalInfoList
    }
    
    func getDoctorOtherDetailsForEdit() -> [DoctorDataListModel]
    {
        let doctorOtherInfo = getDoctorPersonalInfoEdit()
        var doctorOtherInfoList : [DoctorDataListModel] = []
        let dataListObj : DoctorDataListModel = DoctorDataListModel()
        
        dataListObj.headerTitle = "Notes"
        dataListObj.value = checkNullAndNilValueForString(stringData:doctorOtherInfo?.Notes)
        dataListObj.isEditable = true
        dataListObj.isMandatory = false
        dataListObj.controlType = controlValues.Text
        dataListObj.newValue = checkNullAndNilValueForString(stringData:doctorOtherInfo?.Notes)
        doctorOtherInfoList.append(dataListObj)
        
        return doctorOtherInfoList
    }
    
    func getDoctorProfileImgUrlForEdit() -> String
    {
        var url : String = ""
        let obj = getDoctorPersonalInfoEdit()
        
        if obj != nil
        {
            url = checkNullAndNilValueForString(stringData: (obj?.Blob_Photo_Url))
        }
        
        return url
    }
    
    func doctorPhotoUpload(getFileData: NSData?, filePath: String, outputFilename: String, attachmentInfo:[String : Any], completion: @escaping (Int) -> ())
    {
        BL_AttachmentOperation.sharedInstance.doctorPhotoUpload(getFileData: getFileData, filePath: filePath, outputFilename: outputFilename, attachmentInfo: attachmentInfo) { (objApiResponse) in
            
            if (objApiResponse.Status == SERVER_SUCCESS_CODE)
            {
                let array = objApiResponse.list
                
                if (array!.count > 0)
                {
                    self.saveCallBack(doctorDict: array!.firstObject as! NSDictionary)
                }
            }

            completion(objApiResponse.Status)
        }
    }
    
    //MARK:- Profile Photo functions
    func writeFile(fileData: Data, blobUrl: String) -> String
    {

        let fileName: String = getFileComponent(fileName: blobUrl, separatedBy: "/")
        let localPath: String = getFileUrlFromDocumentsDirectory(fileName: fileName)
        
        do
        {
            try fileData.write(to: URL(fileURLWithPath: localPath), options: .atomic)
        }
        catch
        {
            print("Data write error \(error.localizedDescription)")
            return EMPTY
        }
        
        return localPath
    }
    
    private func doesFileExist(fileName: String) -> Bool
    {
        var flag: Bool = false
        var fileURL : URL!
        
        if fileName != EMPTY
        {
            fileURL = getDocumentsURL().appendingPathComponent("\(Constants.DirectoryFolders.doctorProfileFolder)/\(fileName)")
        }
        else
        {
            fileURL = getDocumentsURL().appendingPathComponent("\(Constants.DirectoryFolders.doctorProfileFolder)")
        }
        
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: (fileURL?.path)!)
        {
            flag = true
        }
        
        return flag
    }
    
    private func getFileComponent(fileName: String, separatedBy: String) -> String
    {
        var component: String = EMPTY
        let componentsArr = fileName.components(separatedBy: separatedBy)
        
        if let ext = componentsArr.last
        {
            component = ext
        }
        
        return component
    }
    
    func getFileUrlFromDocumentsDirectory(fileName: String) -> String
    {
        if fileName != EMPTY
        {
            return getDocumentsURL().appendingPathComponent("\(Constants.DirectoryFolders.doctorProfileFolder)/\(fileName)")!.path
        }
        else
        {
            return getDocumentsURL().appendingPathComponent("\(Constants.DirectoryFolders.doctorProfileFolder)")!.path
        }
    }
    
    //MARK:- DB Functions
    
    func getDoctorListForGroupEdetailing(type: String) -> [CustomerMasterModel]? {
        return DBHelper.sharedInstance.getCustomerListForGroupEDetailing(accountType: type)
    }
    
    func getDoctorPersonalInfo() -> CustomerMasterPersonalInfo?
    {
        return DBHelper.sharedInstance.getDoctorPersonalInfo(customerCode: customerCode, regionCode: regionCode)
    }
    
    func getDoctorPersonalInfoEdit() -> CustomerMasterPersonalInfoEdit?
    {
        return DBHelper.sharedInstance.getDoctorPersonalInfoEdit(customerCode: customerCode, regionCode: regionCode)
    }
    
    func getAllChildUser() -> [AccompanistModel]?
    {
        return DBHelper.sharedInstance.getAllChildUsers()
    }
    
    func saveCallBack(doctorDict: NSDictionary)
    {
        let customerStatus = doctorDict.value(forKey: "Customer_Status_Str") as! String
        let customerCode = doctorDict.value(forKey: "Customer_Code") as! String
        let regionCode = doctorDict.value(forKey: "Region_Code") as! String
        
        DBHelper.sharedInstance.deleteCustomerMasterByCusotmerCode(customerCode: customerCode, regionCode: regionCode)
        DBHelper.sharedInstance.deleteCustomerMasterEditByCusotmerCode(customerCode: customerCode, regionCode: regionCode)
        DBHelper.sharedInstance.insertCustomerMasterEdit(array: [doctorDict])
        DBHelper.sharedInstance.insertCustomerMasterPersonalInfoEdit(array: [doctorDict])
        
        if (Int(customerStatus) == Constants.Customer_Status.Approved)
        {
            DBHelper.sharedInstance.insertCustomerMaster(array: [doctorDict])
            DBHelper.sharedInstance.insertCustomerMasterPersonalInfo(array: [doctorDict])
        }
    }
    
    private func getCustomerStatusName(status: Int) -> String
    {
        if (status == Constants.Customer_Status.Approved)
        {
            return "Approved"
        }
        else if (status == Constants.Customer_Status.Applied)
        {
            return "Applied"
        }
        else
        {
            return "Unapproved"
        }
    }
    
    func getDoctorProductMaping() -> [DoctorProductMappingModel]
    {
        let doctorObj = DBHelper.sharedInstance.getDoctorProductMapping(customerCode: customerCode, regionCode: regionCode, refType: Constants.Doctor_Product_Mapping_Ref_Types.GENERAL, date:getCurrentDate())
        
        return doctorObj
    }
    
    func getMCDoctorProductMaping() -> [DoctorProductMappingModel]
    {
        let doctorObj = DBHelper.sharedInstance.getMCDoctorProductMapping(customerCode: customerCode, regionCode: regionCode, date: getCurrentDate(), refType: Constants.Doctor_Product_Mapping_Ref_Types.Marketing_Campaign)
        return doctorObj
    }
}

struct DoctorListModel
{
    var sectionTitle : String = ""
    var dataList : [DoctorDataListModel] = []
    var sectionType : DoctorListSectionHeader!
}

class DoctorDataListModel : NSObject
{
    var headerTitle : String!
    var value : String!
    var isEditable : Bool = false
    var isMandatory: Bool = false
    var controlType : controlValues = controlValues.Label
    var newValue : String = EMPTY
    var Code_Value: String = EMPTY
}

enum DoctorListSectionHeader : Int
{
    case OfficialDetails = 0
    case PersonalDetails = 1
    case HospitalDetails = 2
    case OtherInformation = 3
    case MarketingCampaign = 4
    case DoctorProductMapping = 5
}

enum controlValues : Int
{
    case Label = 0
    case Text = 1
    case Number = 2
    case Date = 3
    case Picker = 4
}

