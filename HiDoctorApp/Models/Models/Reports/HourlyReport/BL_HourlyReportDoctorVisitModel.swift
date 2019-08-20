//
//  BL_HourlyReportDoctorVisitModel.swift
//  HiDoctorApp
//
//  Created by swaasuser on 10/03/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class HourlyReportDoctorVisitModel: NSObject
{
    var Doctor_Code: String = EMPTY
    var Doctor_Name: String = EMPTY
    var Speciality_Name: String = EMPTY
    var MDL_Number: String = EMPTY
    var Category_Name: String = EMPTY
    var Doctor_Region_Name: String = EMPTY
    var Local_Area: String = EMPTY
    var Lattitude: Double = 0
    var Longitude: Double = 0
    var Entered_DateTime: String = EMPTY
    var SyncUp_DateTime: String = EMPTY
    var Doctor_Address: String = EMPTY
    var Doctor_Region_Code: String = EMPTY
    var Time: Date?
    var Customer_Entity_Type: String = EMPTY
    var Hospital_Name: String = EMPTY
    
    convenience init(dict: NSDictionary)
    {
        self.init()
        
        self.Doctor_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Code") as? String)
        self.Doctor_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Name") as? String)
        self.Speciality_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Specilaity_Name") as? String)
        self.MDL_Number = checkNullAndNilValueForString(stringData: dict.value(forKey: "MDL_Number") as? String)
        self.Category_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Category") as? String)
        self.Doctor_Region_Code = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Region_Code") as? String)
        self.Doctor_Region_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Region_Name") as? String)
        self.Local_Area = checkNullAndNilValueForString(stringData: dict.value(forKey: "Local_Area") as? String)
        
        let enteredDateTime = checkNullAndNilValueForString(stringData: dict.value(forKey: "Entered_Date_Time") as? String)
        let syncUpDateTime = checkNullAndNilValueForString(stringData: dict.value(forKey: "Synced_Date_Time") as? String)
        
        if (enteredDateTime != EMPTY)
        {
            let enteredDate = convertStringToDate(string: enteredDateTime, timeZone: localTimeZone, format: dateTimeWithoutMilliSec)
            let date = convertDateIntoString(date: enteredDate)
            let time = getTimeIn12HrFormat(date: enteredDate, timeZone: localTimeZone)
            
            self.Entered_DateTime = date + " " + time
            self.Time = getDateAndTimeInFormat(dateString: dict.value(forKey: "Entered_Date_Time") as! String + ".000")
        }
        else
        {
            self.Entered_DateTime = NOT_APPLICABLE
        }
        
        if (syncUpDateTime != EMPTY)
        {
            let syncDate = convertStringToDate(string: syncUpDateTime, timeZone: utcTimeZone, format: dateTimeWithoutMilliSec)
            let date = convertDateToString(date: syncDate, timeZone: utcTimeZone, format: defaultDateFomat)
            let time = getTimeIn12HrFormat(date: syncDate, timeZone: utcTimeZone)
            
            self.SyncUp_DateTime = date + " " + time
        }
        else
        {
            self.SyncUp_DateTime = NOT_APPLICABLE
        }
        
        self.Doctor_Address = checkNullAndNilValueForString(stringData: dict.value(forKey: "Doctor_Address") as? String)
        
        if (self.Doctor_Address == EMPTY)
        {
            self.Doctor_Address = NOT_APPLICABLE
        }
        
        let latitude = checkNullAndNilValueForString(stringData: dict.value(forKey: "Latitude") as? String)
        if (latitude != EMPTY)
        {
            self.Lattitude = Double(latitude)!
        }
        
        let longitude = checkNullAndNilValueForString(stringData: dict.value(forKey: "Longitude") as? String)
        if (longitude != EMPTY)
        {
            self.Longitude = Double(longitude)!
        }
        
        self.Customer_Entity_Type = checkNullAndNilValueForString(stringData: dict.value(forKey: "Customer_Entity_Type") as? String)
        self.Hospital_Name = checkNullAndNilValueForString(stringData: dict.value(forKey: "Hospital_Name") as? String)
    }
}

class ReportDoctorVisitListModel : NSObject
{
    var displayDate : String = ""
    var dcrStatus : String = ""
    var doctorVisitCount : String = ""
    var geoDoctorList : [DCRDoctorVisitModel] = []
    var geoChemistList : [DCRDoctorVisitModel] = []
    var geoStockistList : [DCRDoctorVisitModel] = []
    var geoAllList : [DCRDoctorVisitModel] = []
}
