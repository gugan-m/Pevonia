//
//  PrivilegesAndConfigSettings.swift
//  HiDoctorApp
//
//  Created by SwaaS on 10/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class PrivilegesAndConfigSettings: NSObject
{
    static let sharedInstance = PrivilegesAndConfigSettings()
    
    // MARK:- Variables
    var Privilge_Data: NSMutableDictionary = [:]
    var Config_Settings_Data: NSMutableDictionary = [:]
    var defaultPrivilege: NSMutableDictionary = [:]
    var defaultConfigSettings: NSMutableDictionary = [:]
    
    // MARK:- Public Functions
    func setPrivilege()
    {
        let privilegeList = DBHelper.sharedInstance.getPrivileges()
        
        if (privilegeList!.count > 0)
        {
            for objPrivilege in privilegeList!
            {
                self.Privilge_Data.setValue(objPrivilege.Privilege_Value, forKey: objPrivilege.Privilege_Name)
            }
        }
        
        setPrivilegeDefaultValue()
    }
    
    func clearAllArray()
    {
        Privilge_Data.removeAllObjects()
        Config_Settings_Data.removeAllObjects()
        defaultPrivilege.removeAllObjects()
        defaultConfigSettings.removeAllObjects()
    }
    
    func setConfigSettings()
    {
        let configList = DBHelper.sharedInstance.getConfigSettings()
        
        if (configList!.count > 0)
        {
            for objConfig in configList!
            {
                Config_Settings_Data.setValue(objConfig.Config_Value, forKey: objConfig.Config_Name)
            }
        }
        
        setConfigSettingsDefaultValue()
        
        defaultDateFomat = getConfigSettingValue(configName: ConfigNames.DATE_DISPLAY_FORMAT).replacingOccurrences(of: "mm", with: "MM")
    }
    
    func getPrivilegeValue(privilegeName: PrivilegeNames) -> String
    {
        let objPrivilege = DBHelper.sharedInstance.getPrivilegeByPrivilegeName(privilegeName: privilegeName.rawValue)
        var privilegeValue = ""
        
        if (objPrivilege != nil)
        {
            privilegeValue = (objPrivilege?.Privilege_Value)!
        }
        else
        {
            setPrivilegeDefaultValue()
            privilegeValue = getDefaultPrivilegeValue(privilegeName: privilegeName)
        }
        
        return privilegeValue
    }
    
    func getConfigSettingValue(configName: ConfigNames) -> String
    {
        let objConfigSettings = DBHelper.sharedInstance.getConfigByConfigName(configName: configName.rawValue)
        var configSettingValue = ""
        
        if (objConfigSettings != nil)
        {
            configSettingValue = (objConfigSettings?.Config_Value)!
        }
        else
        {
            setConfigSettingsDefaultValue()
            configSettingValue = getDefaultConfigSettingValue(configName: configName)
        }
        
        return configSettingValue
    }
    
    
    func getMoneyTreeConfigSettingValue(configName: ConfigNames) -> String
    {
        let objConfigSettings = DBHelper.sharedInstance.getConfigByConfigName(configName: configName.rawValue)
        var configSettingValue = ""
        
        if (objConfigSettings != nil)
        {
            configSettingValue = (objConfigSettings?.Config_Value)!
        }
        else
        {
            setConfigSettingsDefaultValue()
            configSettingValue = getDefaultConfigSettingValue(configName: configName)
        }
        
        return configSettingValue
    }
    
    
    
    
    
    // MARK:- Private Functions
    private func setPrivilegeDefaultValue()
    {
        defaultPrivilege.setValue(PrivilegeValues.ZERO.rawValue, forKey: PrivilegeNames.DCR_ACCOMPANIST_MANDATORY.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.NO.rawValue, forKey: PrivilegeNames.CAMPAIGN_PLANNER.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.YES.rawValue, forKey: PrivilegeNames.RIGID_DOCTOR_ENTRY.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.YES.rawValue, forKey: PrivilegeNames.RIGID_ATTENDANCE_DOCTOR_ENTRY.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.OPTIONAL.rawValue, forKey: PrivilegeNames.DCR_WORK_TIME_MANDATORY.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.EMPTY.rawValue, forKey: PrivilegeNames.INTERMEDIATE_PLACES.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.EMPTY.rawValue, forKey: PrivilegeNames.DAILY_ALLOWANCE_TO_HIDE_FOR_ACTIVITIES.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.NO.rawValue, forKey: PrivilegeNames.DCR_AUTO_APPROVAL.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.ZERO.rawValue, forKey: PrivilegeNames.DCR_CHEMIST_MANDATORY_NUMBER.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.ZERO.rawValue, forKey: PrivilegeNames.DCR_DETAILING_MANDATORY_NUMBER.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.NO.rawValue, forKey: PrivilegeNames.DCR_DOCTOR_POB_AMOUNT.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.AM_PM.rawValue, forKey: PrivilegeNames.DCR_DOCTOR_VISIT_MODE.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.EMPTY.rawValue, forKey: PrivilegeNames.LEAVE_ENTRY_VALIDATION_REQUIRED_LEAVES.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.EMPTY.rawValue, forKey: PrivilegeNames.RCPA_MANDATORY_DOCTOR_CATEGORY.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.YES.rawValue, forKey: PrivilegeNames.SEQUENTIAL_DCR_ENTRY.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.EMPTY.rawValue, forKey: PrivilegeNames.SFC_VALIDATION.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.EMPTY.rawValue, forKey: PrivilegeNames.SFC_CATEGORY_DONT_CHECK.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.EMPTY.rawValue, forKey: PrivilegeNames.SHOW_ACCOMPANISTS_DATA.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.NO.rawValue, forKey: PrivilegeNames.TOUR_PLANNER.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.ZERO.rawValue, forKey: PrivilegeNames.DCR_INPUT_MANDATORY_NUMBER.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.NO.rawValue, forKey: PrivilegeNames.APP_GEO_LOCATION_MANDATORY.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.NO.rawValue, forKey: PrivilegeNames.HDAPP_REQUIRED_MARK_DOCTOR_LOCATION.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.NO.rawValue, forKey: PrivilegeNames.HD_APP_MARK_DOCTOR_USING_MAP.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.NO.rawValue, forKey: PrivilegeNames.ACCOMPANISTS_VALID_IN_DOC_VISITS.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.EMPTY.rawValue, forKey: PrivilegeNames.CIRCLE_ROUTE_APPLICABLE_CATEGORY.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.FIELD_RCPA_ATTENDANCE_LEAVE.rawValue, forKey: PrivilegeNames.DCR_ENTRY_OPTIONS.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.EMPTY.rawValue, forKey: PrivilegeNames.CAN_UNAPPROVE_AN_APPROVED_ENTRY_OF.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.EMPTY.rawValue, forKey: PrivilegeNames.FARE_DAILY_ALLOWANCE.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.ZERO.rawValue, forKey: PrivilegeNames.TP_LOCK_DAY.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.NO.rawValue, forKey: PrivilegeNames.HOURLY_REPORT_ENABLED.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.NO.rawValue, forKey: PrivilegeNames.BULK_DCR_APPROVAL.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.MULTIPLE.rawValue, forKey: PrivilegeNames.SINGLE_ACTIVITY_PER_DAY.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.FULL_DAY.rawValue, forKey: PrivilegeNames.LEAVE_ENTRY_MODE.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.APPDOCTOR_DEFAULT.rawValue, forKey: PrivilegeNames.APPDOCTOR_CAPTION.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.APPCHEMIST_DEFAULT.rawValue, forKey: PrivilegeNames.APPCHEMIST_CAPTION.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.APPSTOCKIEST_DEFAULT.rawValue, forKey: PrivilegeNames.APPSTOCKIEST_CAPTION.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.NO.rawValue, forKey: PrivilegeNames.PS_DASHBOARD_IN_APP.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.NO.rawValue, forKey: PrivilegeNames.IS_MC_STORY_ENABLED.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.ACC_MAND_NO_DOC_MAND_NUM_0.rawValue, forKey: PrivilegeNames.TP_ACC_MAND_DOC_MAND_VALUES.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.FIELD_RCPA_ATTENDANCE_LEAVE.rawValue, forKey: PrivilegeNames.TP_ENTRY_OPTIONS.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.NO.rawValue, forKey: PrivilegeNames.TP_MEETING_PLACE_TIME_MANDATORY.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.ZERO.rawValue, forKey: PrivilegeNames.GEO_FENCING_DEVIATION_LIMIT_IN_KM.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.EMPTY.rawValue, forKey: PrivilegeNames.AUTO_SYNC_ENABLED_FOR.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.TEN.rawValue, forKey: PrivilegeNames.NUMBER_OF_OFFLINE_DCR_ALLOWED.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.NO, forKey: PrivilegeNames.RIGID_CHEMIST_ENTRY.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.ZERO.rawValue, forKey: PrivilegeNames.DCR_CHEMIST_DETAILING_MANDATORY_NUMBER.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.ZERO.rawValue, forKey: PrivilegeNames.DCR_CHEMIST_INPUT_MANDATORY_NUMBER.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.NO.rawValue, forKey: PrivilegeNames.ACCOMPANISTS_VALID_IN_CHEMIST_VISITS.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.AM_PM.rawValue, forKey: PrivilegeNames.DCR_CHEMIST_VISIT_MODE.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.CHEMIST_VISITS_CAPTURE_VALUE.rawValue, forKey: PrivilegeNames.CHEMIST_VISITS_CAPTURE_CONTROLS.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.DOCTOR_VISITS_CAPTURE_VALUE.rawValue, forKey: PrivilegeNames.DOCTOR_VISITS_CAPTURE_CONTROLS.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.ENABLED.rawValue, forKey: PrivilegeNames.DOCTOR_MANDATORY_FIELD_MODIFICATION.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.NO.rawValue, forKey: PrivilegeNames.DOCTOR_CATEGORY.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.NO.rawValue, forKey: PrivilegeNames.CAN_CHANGE_CUSTOMER_NAME.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.NO.rawValue, forKey: PrivilegeNames.DCR_ENTRY_TP_APPROVAL_NEEDED.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.YES.rawValue, forKey: PrivilegeNames.APPROVED_FIELD_TP_CAN_BE_DEVIATED.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.NO.rawValue, forKey: PrivilegeNames.PASSWORD_POLICY.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.ZERO.rawValue, forKey: PrivilegeNames.PASSWORD_LOCK_RELEASE_DURATION.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.ZERO.rawValue, forKey: PrivilegeNames.PASSWORD_EXPIRY_DAYS.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.ZERO.rawValue, forKey: PrivilegeNames.PASSWORD_EXPIRY_NOTIFICATION_DAYS.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.ZERO.rawValue, forKey: PrivilegeNames.APP_PASSWORD_EXPIRED_ALERT_MAX_SKIP_COUNT.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.RIGID.rawValue, forKey: PrivilegeNames.GEO_FENCING_VALIDATION_MODE.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.NO.rawValue, forKey: PrivilegeNames.CAN_EDIT_CUSTOMER_LOCATION.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.NO.rawValue, forKey: PrivilegeNames.INWARD_ACKNOWLEDGEMENT_NEEDED.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.ZERO.rawValue, forKey: PrivilegeNames.DCR_INHERITANCE.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.YES.rawValue, forKey: PrivilegeNames.IS_DCR_INHERITANCE_EDITABLE.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.NO.rawValue, forKey: PrivilegeNames.ADD_DOCTOR_FROM_DCR.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.ONE.rawValue, forKey: PrivilegeNames.EDETAILING_MC_STORY_AND_ASSET_SWAP.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.NO.rawValue, forKey: PrivilegeNames.DELETE_EDETAILED_DOCTOR_IN_DCR_DOCTOR_VISIT.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.ZERO.rawValue, forKey: PrivilegeNames.COLLECT_RETAIL_COMPETITOR_INFO.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.NO.rawValue, forKey: PrivilegeNames.SHOW_SAMPLE_IN_DCR_ATTENDANCE.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.ZERO.rawValue, forKey: PrivilegeNames.CP_VISIT_FREQENCY_IN_TP.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.NO.rawValue, forKey: PrivilegeNames.SFC_MINCOUNTVALID_IN_TP.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.EMPTY.rawValue, forKey:PrivilegeNames.ALERT_LANDING_PAGE_REDIRECT.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.YES.rawValue, forKey:PrivilegeNames.FUTURE_LEAVE_ALLOW_IN_DCR.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.NO.rawValue, forKey:PrivilegeNames.INWARD_ACKNOWLEDGEMENT_ENFORCEMENT.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.ZERO.rawValue, forKey:PrivilegeNames.CAN_CHECK_MASTER_DATA_DOWNLOAD_IN_DAYS.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.YES.rawValue, forKey: PrivilegeNames.SHOW_DETAILED_PRODUCTS_WITH_TAGS.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.NO.rawValue, forKey: PrivilegeNames.CAN_PLAY_ASSETS_IN_SEQUENCE.rawValue)
        
                defaultPrivilege.setValue(PrivilegeValues.AM_PM.rawValue, forKey: PrivilegeNames.DCR_STOCKIEST_VISIT_TIME.rawValue)
        //LEAVE_POLICY
        defaultPrivilege.setValue(PrivilegeValues.NO.rawValue, forKey: PrivilegeNames.LEAVE_POLICY.rawValue)
        //Account Number Filter
        defaultPrivilege.setValue(PrivilegeValues.NO.rawValue, forKey: PrivilegeNames.SHOW_ORGANISATION_IN_CUSTOMER.rawValue)
        // Attendance Privilege
  defaultPrivilege.setValue(PrivilegeValues.DOCTOR_VISITS_CAPTURE_CONTROLS_IN_ATTENDANCE_VALUE.rawValue, forKey: PrivilegeNames.DOCTOR_VISITS_CAPTURE_CONTROLS_IN_ATTENDANCE.rawValue)
        // New Privilege
        defaultPrivilege.setValue(PrivilegeValues.DCR_FIELD_CAPTURE_VALUE.rawValue, forKey: PrivilegeNames.DCR_FIELD_CAPTURE_CONTROLS.rawValue)
        defaultPrivilege.setValue(PrivilegeValues.DCR_ATTENDANCE_CAPTURE_VALUE.rawValue, forKey: PrivilegeNames.DCR_ATTENDANCE_CAPTURE_CONTROLS.rawValue)
    
         defaultPrivilege.setValue(PrivilegeValues.TP_FIELD_CAPTURE_VALUE.rawValue, forKey: PrivilegeNames.TP_FIELD_CAPTURE_CONTROLS.rawValue)
         defaultPrivilege.setValue(PrivilegeValues.TP_FIELD_CAPTURE_VALUE.rawValue, forKey: PrivilegeNames.TP_ATTENDANCE_CAPTURE_CONTROLS.rawValue)
        
        defaultPrivilege.setValue(PrivilegeValues.NO.rawValue, forKey: PrivilegeNames.ALLOW_GROUP_EDETAILING.rawValue)
    
    }
    
    private func setConfigSettingsDefaultValue()
    {
        defaultConfigSettings.setValue(ConfigValues.dd_mm_yyyy.rawValue, forKey: ConfigNames.DATE_DISPLAY_FORMAT.rawValue)
        defaultConfigSettings.setValue(ConfigValues.EMPTY.rawValue, forKey: ConfigNames.DCR_DOCTOR_SUFIX_COLUMNS.rawValue)
        defaultConfigSettings.setValue(ConfigValues.MANUAL.rawValue, forKey: ConfigNames.DCR_DOCTOR_VISIT_TIME_ENTRY_MODE.rawValue)
        
        defaultConfigSettings.setValue(ConfigValues.EMPTY.rawValue, forKey: ConfigNames.MONEY_TREE_KEY.rawValue)
        
        
        
        defaultConfigSettings.setValue(ConfigValues.FIVE.rawValue, forKey: ConfigNames.DCR_ENTRY_TIME_GAP.rawValue)
        defaultConfigSettings.setValue(ConfigValues.NO.rawValue, forKey: ConfigNames.DCR_NO_PREFIL_EXPENSE_VALUE.rawValue)
        defaultConfigSettings.setValue(ConfigValues.YES.rawValue, forKey: ConfigNames.DCR_UNAPPROVED_INCLUDE_IN_SEQ.rawValue)
        defaultConfigSettings.setValue(ConfigValues.SPL_CHARS.rawValue, forKey: ConfigNames.SPECIAL_CHARACTERS_TO_BE_RESTRICTED.rawValue)
        defaultConfigSettings.setValue(ConfigValues.FOUR.rawValue, forKey: ConfigNames.MAX_ACCOMPANIST_FOR_A_DAY.rawValue)
        defaultConfigSettings.setValue(ConfigValues.NO.rawValue, forKey: ConfigNames.IsPayRollIntegrated.rawValue)
        defaultConfigSettings.setValue(ConfigValues.NO.rawValue, forKey: ConfigNames.ALLOW_OTHER_HIERARCHY_IN_ACCOMPANIST_IN_APP.rawValue)
        defaultConfigSettings.setValue(ConfigValues.THREE.rawValue, forKey: ConfigNames.DCR_DOCTOR_ATTACHMENT_PER_FILE_SIZE.rawValue)
        defaultConfigSettings.setValue(ConfigValues.FIVE.rawValue, forKey: ConfigNames.DCR_DOCTOR_ATTACHMENTS_FILES_COUNT.rawValue)
        defaultConfigSettings.setValue(ConfigValues.NO.rawValue, forKey: ConfigNames.IS_EDetailing_Enabled.rawValue)
        defaultConfigSettings.setValue(ConfigValues.NO.rawValue, forKey: ConfigNames.IS_SINGLE_DEVICE_LOGIN_ENABLED.rawValue)
        defaultConfigSettings.setValue(ConfigValues.NO.rawValue, forKey: ConfigNames.CHEMIST_DAY.rawValue)
        defaultConfigSettings.setValue(ConfigValues.EMPTY.rawValue, forKey: ConfigNames.DOCTOR_MASTER_MANDATORY_COLUMNS.rawValue)
        defaultConfigSettings.setValue(ConfigValues.ZERO.rawValue, forKey: ConfigNames.MASTER_DATA_DOWNLOAD_ALERT_MAX_SKIP.rawValue)
        
    }
    
    func getDefaultConfigSettingValue(configName: ConfigNames) -> String
    {
        var configSettingValue = ""
        
        if let configValue = defaultConfigSettings.value(forKey: configName.rawValue) as? String
        {
            configSettingValue = configValue
        }
        
        return configSettingValue
    }
    
    private func getDefaultPrivilegeValue(privilegeName: PrivilegeNames) -> String
    {
        var privilegeValue = ""
        
        if let privValue = defaultPrivilege.value(forKey: privilegeName.rawValue) as? String
        {
            privilegeValue = privValue
        }
        
        return privilegeValue
    }
}
