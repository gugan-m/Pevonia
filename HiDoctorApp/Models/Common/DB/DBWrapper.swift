import UIKit
import GRDB

var dbPool: DatabasePool!

func setupDatabase(_ application: UIApplication) throws
{
    let databasePath = getDBPath()
    
    dbPool = try DatabasePool(path: databasePath)
    dbPool.setupMemoryManagement(in: application)
    
    var migrator = DatabaseMigrator()
    
    migrator.registerMigration(DatabaseMigrationString.version1.rawValue) { db in
        var createTableString = ""
        
        createTableString = "CREATE TABLE IF NOT EXISTS mst_Company_Details (" + "Company_Id INTEGER PRIMARY KEY," + "Company_Name TEXT," + "Company_Code TEXT," + "Company_URL TEXT," + "Geo_location_Support INTEGER," + "PayRoll_Integrated INTEGER," + "Logo_URL TEXT," + "Display_Name TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS mst_User_Details (" + "User_Code TEXT," + "User_Name TEXT," + "User_Id INTEGER PRIMARY KEY," + "Employee_Name TEXT," + "Region_Name TEXT," + "Region_Code TEXT,"
            + "User_Type_Code TEXT," + "User_Type_Name TEXT," + "User_Password TEXT,"
            + "Hidoctor_Start_Date DATE," + "App_User_Flag INTEGER," +
            "Is_WideAngle_User INTEGER" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_CUSTOMER_MASTER_PERSONAL_INFO) (" + "Customer_Code TEXT," + "Region_Code  TEXT," + "DOB DATE," + "Anniversary_Date DATE," + "Mobile_Number TEXT," + "Alternate_Number TEXT," + "Assistant_Number TEXT," + "Registration_Number TEXT," + "Email_Id TEXT," + "Blob_Photo_Url TEXT," + "Hospital_Name TEXT," + "Hospital_Address TEXT," + "Notes TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_API_DOWNLOAD_DETAILS) (" + "Api_Name TEXT," + "Master_Data_Group_Name TEXT," + "Download_Date TEXT," + "Download_Status INTEGER" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS mst_Privileges (" + "Privilege_Name TEXT," + "Privilege_Value TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS tran_Config_Settings (" + "Config_Name TEXT," + "Config_Value TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS mst_Work_Category (" + "Category_Id INTEGER PRIMARY KEY," + "Category_Name TEXT," + "Category_Code TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS mst_Speciality (" + "Speciality_Id INTEGER PRIMARY KEY," + "Speciality_Name TEXT," + "Speciality_Code TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS tran_Leave_Type (" + "Leave_Type_Id INTEGER PRIMARY KEY," + "Leave_Type_Code TEXT," + "Leave_Type_Name TEXT," + "Effective_From DATE," + "Effective_To DATE" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS tran_Travel_Mode (" + "Travel_Mode_Id INTEGER PRIMARY KEY," + "Travel_Mode_Name TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS mst_Project_Activity (" + "Activity_Code TEXT," + "Activity_Name TEXT," + "Project_Name TEXT," + "Project_Code TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS mst_Detail_Products (" + "Detail_Product_Id INTEGER PRIMARY KEY," + "Product_Code TEXT," + "Product_Name TEXT," + "Speciality_Code TEXT," + "Division_Name TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS mst_CP_Header (" + "CP_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "CP_Code TEXT," + "CP_Name TEXT," + "Region_Code TEXT," + "Region_Name TEXT," + "Category_Code TEXT," + "Work_Area TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS mst_CP_SFC (" + "CP_SFC_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "CP_Code TEXT," + "CP_Id INTEGER," + "From_Place TEXT," + "To_Place TEXT," + "Travel_Mode TEXT," + "Distance REAL," + "Fare_Amount REAL," + "SFC_Category_Code TEXT," + "Distance_fare_Code TEXT," + "SFC_Version INT," + "Route_Way TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS mst_CP_Doctors (" + "CP_Doctor_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "CP_Id INTEGER," + "CP_Code TEXT," + "Doctor_Code TEXT," + "Doctor_Region_Code TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS mst_Expense_Groups (" + "Expense_Type_Code TEXT," + "Expense_Type_Name TEXT," + "Expense_Group_Id INTEGER," + "Expense_Group_Detail_Id INTEGER PRIMARY KEY," + "Expense_Mode TEXT," + "Expense_Entity TEXT," + "Expense_Entity_Code TEXT," + "Eligibility_Amount FLOAT," + "Can_Split_Amount TEXT," + "Period TEXT," + "Is_Validation_On_Eligibility INT," + "Effective_From DATE," + "Effective_To DATE," + "SFC_Type TEXT," + "Is_Prefill TEXT," + "Record_Status TEXT," + "Distance_Edit INTEGER," + "Sum_Distance_Needed INTEGER" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS tran_TP_Header (" + "TP_Id INTEGER PRIMARY KEY," + "TP_Date DATE," + "TP_Day TEXT," + "CP_Id INTEGER," + "CP_Code TEXT," + "Category_Code TEXT," + "Activity INTEGER," + "Activity_Code TEXT," + "Activity_Name TEXT," + "Project_Code TEXT," + "Work_Place TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS tran_TP_Doctors (" + "TP_Doctor_Id INTEGER PRIMARY KEY," + "TP_Id INTEGER," + "Doctor_Code TEXT," + "Doctor_Region_Code TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS tran_TP_Accompanists (" + "TP_Id INTEGER," + "Acc_User_Code TEXT," + "Acc_User_Name TEXT," + "Acc_Region_Code TEXT," + "Acc_User_Type_Name TEXT," + "Is_Only_For_Doctor TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS tran_TP_Products (" + "TP_Product_Id INTEGER PRIMARY KEY," + "TP_Id INTEGER," + "Doctor_Code TEXT," + "Doctor_Region_Code TEXT," + "Product_Code TEXT," + "Product_Name TEXT," + "Quantity_Provided INTEGER" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS tran_TP_SFC (" + "TP_SFC_Id INTEGER PRIMARY KEY," + "TP_Id INTEGER," + "From_Place TEXT," + "To_Place TEXT," + "Travel_Mode TEXT," + "Distance TEXT," + "Distance_fare_Code TEXT," + "SFC_Version INTEGER" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS mst_DFC (" + "DFC_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "Distance_Range_Code TEXT," + "From_Km FLOAT," + "To_Km FLOAT," + "Fare_Amount FLOAT," + "Travel_Mode TEXT," + "Date_From DATE," + "Date_To DATE," + "Is_Amount_Fixed TEXT," + "Entity_Code TEXT," + "Category_Name TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS mst_User_Products (" + "Product_Id INTEGER PRIMARY KEY," + "Product_Code TEXT," + "Product_Name TEXT," + "Product_Type_Code TEXT," + "Product_Type_Name TEXT," + "Division_Name TEXT," + "Current_Stock INTEGER," + "Speciality_Code TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS mst_Accompanist (" + "Accompanist_Id INTEGER PRIMARY KEY," + "User_Code TEXT," + "User_Name TEXT," + "Employee_name TEXT," + "User_Type_Name TEXT," + "Region_Code TEXT," + "Region_Name TEXT," + "Division_Name TEXT," + "Is_Child_User INTEGER," + "Is_Immedidate_User INTEGER" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS tran_DCR_Header (" + "DCR_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "DCR_Actual_Date DATE," + "DCR_Entered_Date DATE," + "DCR_Status TEXT," + "Flag INTEGER," + "Place_Worked TEXT," + "Category_Id INTEGER," + "Category_Name TEXT," + "Travelled_KMS FLOAT," + "CP_Name TEXT," + "CP_Code TEXT," + "CP_Id INTEGER," + "Start_Time TEXT," + "End_Time TEXT," + "Approved_By TEXT," + "Approved_Date DATE," + "Unapprove_Reason TEXT," + "Leave_Type_Id INTEGER," + "Leave_Type_Code TEXT," + "Region_Code TEXT," + "Lattitude TEXT," + "Longitude TEXT," + "Activity_Count FLOAT," + "Reason TEXT," + "DCR_Code TEXT," + "DCR_General_Remarks TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS tran_DCR_Travelled_Places (" + "DCR_Travel_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "DCR_Id INTEGER," + "From_Place TEXT," + "To_Place TEXT," + "Travel_Mode TEXT," + "Distance FLOAT," + "SFC_Category_Name TEXT," + "Distance_Fare_Code TEXT," + "SFC_Version INTEGER," + "Route_Way TEXT," + "Flag INTEGER," + "DCR_Code TEXT," + "Region_Code TEXT," + "Is_Circular_Route_Complete INTEGER" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS tran_DCR_Accompanist (" + "DCR_Accompanist_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "DCR_Id INTEGER," + "Acc_Region_Code TEXT," + "Acc_User_Code TEXT," + "Acc_User_Name TEXT," + "Acc_User_Type_Name TEXT," + "Is_Only_For_Doctor INTEGER," + "Acc_Start_Time TEXT," + "Acc_End_Time TEXT," + "DCR_Code TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS tran_DCR_Doctor_Accompanist (" + "DCR_Doctor_Accompanist_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "DCR_Id INTEGER," + "DCR_Code TEXT," + "DCR_Doctor_Visit_Id INTEGER," + "DCR_Doctor_Visit_Code TEXT," + "Acc_Region_Code TEXT," + "Acc_User_Code TEXT," + "Acc_User_Name TEXT," + "Acc_User_Type_Name TEXT," + "Is_Only_For_Doctor INTEGER" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS tran_DCR_Doctor_Visit (" + "DCR_Doctor_Visit_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "DCR_Doctor_Visit_Code TEXT," + "DCR_Id INTEGER," + "DCR_Code TEXT," + "Doctor_Id INTEGER," + "Doctor_Code TEXT," + "Doctor_Region_Code TEXT," + "Doctor_Region_Name TEXT," + "Doctor_Name TEXT," + "Speciality_Name TEXT," + "MDL_Number TEXT," + "Category_Code TEXT," + "Category_Name TEXT," + "Visit_Mode TEXT," + "Visit_Time TEXT," + "POB_Amount FLOAT," + "Local_Area TEXT," + "Sur_Name TEXT," + "Is_CP_Doctor INTEGER," + "Is_Acc_Doctor INTEGER," + "Remarks TEXT," + "Lattitude TEXT," + "Longitude TEXT" +     ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS tran_DCR_Sample_Details (" + "DCR_Sample_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "DCR_Doctor_Visit_Id INTEGER," + "DCR_Doctor_Visit_Code TEXT," + "DCR_Id INTEGER," + "DCR_Code TEXT," + "Product_Id INTEGER," + "Product_Code TEXT," + "Product_Name TEXT," + "Quantity_Provided INTEGER," + "Speciality_Code TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS tran_DCR_Detailed_Products (" + "DCR_Detailed_Products_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "DCR_Doctor_Visit_Id INTEGER," + "DCR_Doctor_Visit_Code TEXT," + "DCR_Id INTEGER," + "DCR_Code TEXT," + "Product_Id INTEGER," + "Product_Code TEXT," + "Product_Name TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS tran_DCR_Chemists_Visit (" + "DCR_Chemist_Visit_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "DCR_Chemist_Visit_Code TEXT," + "DCR_Doctor_Visit_Id INTEGER," + "DCR_Doctor_Visit_Code TEXT," + "DCR_Id INTEGER," + "DCR_Code TEXT," + "Chemist_Id INTEGER," + "Chemist_Code TEXT," + "Chemist_Name TEXT," + "POB_Amount FLOAT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS tran_DCR_RCPA_Details (" + "DCR_RCPA_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "DCR_Chemist_Visit_Id INTEGER," + "DCR_Chemist_Visit_Code TEXT," + "DCR_Doctor_Visit_Id INTEGER," + "DCR_Doctor_Visit_Code TEXT," + "DCR_Id INTEGER," + "DCR_Code TEXT," + "Product_Code TEXT," + "Own_Product_Id INTEGER," + "Own_Product_Code TEXT," + "Own_Product_Name TEXT," + "Qty_Given FLOAT," + "Competitor_Product_Id INTEGER," + "Competitor_Product_Code TEXT," + "Competitor_Product_Name TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS tran_DCR_Calendar_Header (" + "Date_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "Activity_Date DATE," + "Activity_Count INTEGER," + "Is_WeekEnd INTEGER," +  "Is_Holiday INTEGER," + "Is_LockLeave INTEGER," + "DCR_Status INTEGER," + "Activity_Date_In_Date DATE" + ")"
        
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS tran_DCR_Expense_Details (" + "DCR_Expense_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "DCR_Id INTEGER," + "DCR_Code TEXT," + "Flag INTEGER," + "Expense_Type_Code TEXT," + "Expense_Type_Name TEXT," + "Expense_Amount FLOAT," + "Expense_Mode TEXT," + "Eligibility_Amount FLOAT," + "Expense_Group_Id INTEGER," + "Expense_Claim_Code TEXT," + "Remarks TEXT," + "Is_Prefilled INTEGER," + "Is_Editable INTEGER" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS mst_App_Status (" + "Is_Login_Completed INTEGER," + "Is_PMD_Completed INTEGER," + "Is_PMD_Accompanist_Completed INTEGER," + "OverAll_Status INTEGER" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS mst_Customer_Master (" + "Customer_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "Customer_Code TEXT," + "Customer_Name TEXT," + "Region_Code TEXT," + "Region_Name TEXT," + "Speciality_Code TEXT," + "Speciality_Name TEXT," + "Category_Code TEXT," + "Category_Name TEXT," + "MDL_Number TEXT," + "Local_Area TEXT," + "Hospital_Name TEXT," + "Customer_Entity_Type TEXT," + "Sur_Name TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS mst_SFC_Master (" + "SFC_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "Distance_Fare_Code TEXT,"  + "Region_Code TEXT," + "From_Place TEXT,"  + "To_Place TEXT," + "Travel_Mode TEXT," + "Distance FLOAT," + "Fare_Amount FLOAT," + "Category_Name TEXT," + "Date_From DATE," + "Date_To DATE," + "SFC_Version INTEGER," + "SFC_Visit_count INTEGER" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS mst_Holiday_Master (" + "Holiday_Date DATE PRIMARY KEY," + "Holiday_Name TEXT"  + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS mst_Accompanist_Data_Download_Details (" + "Request_Id INTEGER," + "User_Code TEXT," + "Region_Code TEXT," + "Is_Doctor_Data_Downloaded INTEGER," + "Is_Chemist_Data_Downloaded INTEGER," + "Is_SFC_Data_Downloaded INTEGER," + "Is_CP_Data_Downloaded INTEGER," + "Is_All_Data_Downloaded INTEGER," + "Download_DateTime DATE" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS tran_DCR_Stcokiest_Visit (" + "DCR_Stockiest_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "DCR_Id INTEGER," + "DCR_Code TEXT," + "Stockiest_Id INTEGER," + "Stockiest_Code TEXT," + "Stockiest_Name TEXT," + "Visit_Mode TEXT," + "POB_Amount FLOAT," + "Collection_Amount FLOAT," + "Remarks TEXT" + "Latitude TEXT" + "Longitude TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS Onboard_Shown (" + "Version_Name TEXT PRIMARY KEY," + "Shown_Type INTEGER," + "Screen_Name TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS tran_DCR_Attendance_Activities (" + "DCR_Attendance_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "DCR_Id INTEGER," + "DCR_Date DATE," + "Project_Code TEXT," + "Activity_Code TEXT," + "Start_Time TEXT," + "End_Time TEXT," + "Remarks TEXT," + "DCR_Code TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS mst_Flexi_Doctor (" + "Flexi_Doctor_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "Flexi_Doctor_Name TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS mst_Flexi_Chemist (" + "Flexi_Chemist_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "Flexi_Chemist_Name TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS mst_Flexi_Place (" + "Flexi_Place_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "Flexi_Place_Name TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS mst_Competitor_Products (" + "Competitor_Product_Id INTEGER PRIMARY KEY," + "Competitor_Product_Code TEXT," + "Competitor_Product_Name TEXT," + "Own_Product_code TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_MENU_MASTER) (" + "Menu_Id INTEGER PRIMARY KEY," + "Menu_Name TEXT" + "MDM_Menu_Url TEXT" + "Type TEXT" + "Category TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_DASHBOARD_HEADER) (" + "Dashboard_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "User_Code TEXT," + "Region_Code TEXT," + "Last_Update_Date DATE" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_DASHBOARD_DETAILS) (" + "Dashboard_Detail_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "Dashboard_Id INTEGER," + "Entity_Id INTEGER," + "Current_Month_Value FLOAT," + "Previous_Month_Value FLOAT," + "Count INTEGER," + "Is_Self INTEGER" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_DASHBOARD_DATE_DETAILS) (" + "Dashboard_Date_Detail_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "Dashboard_Id INTEGER," + "Dashboard_Detail_Id INTEGER," + "Activity_Date DATE," + "Activity INTEGER" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_DASHBOARD_MISSED_DOCTOR) (" + "Customer_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "Customer_Code TEXT," + "Customer_Name TEXT," + "Region_Code TEXT," + "Region_Name TEXT," + "Speciality_Code TEXT," + "Speciality_Name TEXT," + "Category_Code TEXT," + "Category_Name TEXT," + "MDL_Number TEXT," + "Local_Area TEXT," + "Hospital_Name TEXT," + "Customer_Entity_Type TEXT," + "Sur_Name TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_DCR_DOCTOR_VISIT_TRACKER) (" + "DCR_Doctor_Visit_Tracker_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "DCR_Doctor_Visit_Id INTEGER," + "DCR_Id INTEGER," + "DCR_Actual_Date DATE," + "Doctor_Code TEXT," + "Doctor_Region_Code TEXT," + "Doctor_Name TEXT," + "Speciality_Name TEXT," + "" + "MDL_Number TEXT," + "Category_Code TEXT," + "Doctor_Visit_Date_Time DATE," + "Lattitude TEXT," + "Longitude TEXT," + "Modified_Entity INTEGER" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(BUSINESS_STATUS_POTENTIAL) (" + "Doctor_Code TEXT," + "Doctor_Region_Code TEXT," + "Dcr_Date TEXT," + "Business_Status_Id INTEGER," + "Business_Status_Name TEXT," + "Entity_Type INTEGER," + "Entity_Description TEXT," + "Division_Code TEXT," + "Product_Code TEXT," + "Business_Potential FLOAT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(Travel_Tracking_Report) (" + "Latitude TEXT," + "Longitude  TEXT," + "Entered_DateTime DATE," + "Type TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(Hourly_Report_Visit) (" + "Doctor_Code TEXT," + "Doctor_Name TEXT," + "Doctor_Region_Code TEXT," + "Speciality_Name TEXT," + "Category_Code TEXT," + "MDL_Number TEXT," + "DCR_Actual_Date TEXT," + "Doctor_Visit_Date_Time TEXT," + "Latitude TEXT," + "Longitude TEXT," + "Modified_Entity INTEGER," + "Synced_DateTime TEXT," + "Customer_Entity_Type TEXT," + "Category_Name TEXT," + "Doctor_Region_Name TEXT" + ")"
        try db.execute(createTableString)
    }
    
    var isMigrationV2Required: Bool = false
    
    migrator.registerMigration(DatabaseMigrationString.version2.rawValue) { db in
        var createTableString = ""
        var rows: [Row] = []
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(MST_EXPENSE_GROUP_MAPPING)')")
        }
        
        if !checkIsColumnExist(rowList: rows, columnName: "Is_Remarks_Mandatory")
        {
            createTableString = "ALTER TABLE \(MST_EXPENSE_GROUP_MAPPING) ADD Is_Remarks_Mandatory INTEGER"
            try db.execute(createTableString)
        }
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_DCR_CUSTOMER_FOLLOW_UPS) (" + "Follow_Up_Id INTEGER PRIMARY KEY AUTOINCREMENT," +  "DCR_Id INTEGER," + "DCR_Code TEXT," + "DCR_Doctor_Visit_Id INTEGER," + "DCR_Doctor_Visit_Code  TEXT," + "Follow_Up_Text TEXT," + "Due_Date  DATE" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_VERSION_UPGRADE_INFO) (" + "Version_Number TEXT PRIMARY KEY," +  "Is_Version_Update_Completed INTEGER" + ")"
        try db.execute(createTableString)
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_DCR_DOCTOR_ACCOMPANIST)')")
        }
        
        if !checkIsColumnExist(rowList: rows, columnName: "Is_Accompanied")
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_DOCTOR_ACCOMPANIST) ADD Is_Accompanied INTEGER"
            try db.execute(createTableString)
        }
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_DCR_DOCTOR_VISIT_POB_HEADER) (" + "Order_Entry_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "Order_Id INTEGER," + "Order_Number INTEGER," + "Order_Date DATE," + "DCR_Id INTEGER," + "DCR_Actual_Date DATE," + "Stockiest_Code TEXT," + "Stockiest_Region_Code TEXT," + "Customer_Name TEXT," + "Customer_Code TEXT," + "Customer_Region_Code TEXT," + "Customer_MDL_Number TEXT," + "Customer_Category_Code TEXT," + "Speciality_Name TEXT," + "DCR_Doctor_Visit_Id INTEGER," + "Order_Due_Date DATE," + "Order_Status INTEGER," + "Order_Mode INTEGER," + "Action_Mode INTEGER DEFAULT 0," + "Favouring_User_Code TEXT," + "Favouring_Region_Code TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_DCR_DOCTOR_VISIT_POB_DETAILS) (" + "Order_Detail_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "Order_Entry_Id INTEGER," + "Product_Code TEXT," + "Product_Qty DECIMAL(10,2)," + "Product_Unit_Rate DECIMAL(10,2)," + "Product_Amount DECIMAL(12,2)" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_DCR_DOCTOR_VISIT_POB_REMARKS) (" + "Remarks_Entry_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "Order_Entry_Id INTEGER," + "Remarks TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_DCR_DOCTOR_VISIT_ATTACHMENT) (" + "Id INTEGER PRIMARY KEY AUTOINCREMENT," + "DCR_Doctor_Visit_Code TEXT," + "DCR_Id INTEGER," + "DCR_Doctor_Visit_Id INTEGER," + "Attachment_Size TEXT," + "Blob_Url TEXT," + "Uploaded_File_Name TEXT," + "DCR_Actual_Date TEXT," + "Doctor_Name TEXT," + "Speciality_Name TEXT," + "Is_Success INTEGER," + "IsFile_Downloaded INTEGER" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_PS_Header) (" + "PS_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "Region_Code TEXT,"  + "Doc_Type_Code INTEGER," + "Value DECIMAL(15,2)," + "Doc_Month INTEGER," + "Doc_Year INTEGER," + "Processed_Date DATE," + "Doc_Type_Name TEXT," + "Display_Order INTEGER" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_PS_ProductDetails) (" + "PS_Details_Id INTEGER PRIMARY KEY AUTOINCREMENT,"  + "Region_Code TEXT," + "Product_Name TEXT," + "Value DECIMAL," + "Processed_Date DATE," + "Doc_Month INTEGER," +  "Doc_Year INTEGER" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_PS_Collection_Values) (" + "Collection_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "Region_Code TEXT," + "Collection_Value  DECIMAL," + "OutStanding_Value DECIMAL," + "Processed_Date DATE," + "Month INTEGER," + "Year INTEGER" + ")"
        try db.execute(createTableString)
        
        isMigrationV2Required = true
    }
    
    var isMigrationeDetailingRequired: Bool = false
    
    migrator.registerMigration(DatabaseMigrationString.eDetailingVersion.rawValue) { db in
        
        var createTableString = ""
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_ASSET_HEADER) (" + "DA_Code INTEGER PRIMARY KEY," + "DA_Name TEXT," + "Doc_Type INTEGER," + "Is_Downloadable INTEGER," + "Is_Viewable INTEGER," + "Is_Shareable INTEGER," + "Thumbnail_Url TEXT," + "DA_Size_In_MB FLOAT," + "Is_Downloaded INTEGER," + "DA_FileName TEXT," + "Effective_From DATE," + "Effective_To DATE," + "DA_Description TEXT," + "Number_Of_Parts INTEGER," + "Total_Duration_In_Seconds INTEGER," + "DA_Online_Url TEXT," + "Html_Start_Page TEXT," + "Total_Measure TEXT," + "Measured_Unit TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_ASSET_TAG_DETAILS) (" + "Id INTEGER PRIMARY KEY AUTOINCREMENT," + "DA_Code INTEGER," + "Tag_Type INTEGER," + "Tag_Value TEXT," + "Tag_Code TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_ASSET_PARTS) (" + "Id INTEGER PRIMARY KEY AUTOINCREMENT," + "DA_Code INTEGER," + "Part_Id INTEGER," + "Part_Name TEXT," + "Start_Time INTEGER," + "End_Time INTEGER," + "Total_Duration_In_Seconds INTEGER" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_VIDEO_FILE_DOWNLOAD_INFO) (" + "Id INTEGER PRIMARY KEY AUTOINCREMENT," + "Encoding_Preset INTEGER," + "DA_Code INTEGER," + "File_Size INTEGER" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_ASSET_PRESET) (" + "Id INTEGER PRIMARY KEY AUTOINCREMENT," + "Doc_Type INTEGER," + "Encoding_Preset TEXT," + "Source_Type INTEGER" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_ASSET_ANALYTICS_SUMMARY) (" + "Id INTEGER PRIMARY KEY AUTOINCREMENT," + "DA_Code INTEGER," + "Played_Time_Duration INTEGER," + "Played_DateTime DATE," + "Time_Zone TEXT," + "Is_Preview INTEGER," + "Is_Synced INTEGER," + "Synced_DateTime DATE," + "Customer_Code TEXT," + "Customer_Name TEXT," + "Customer_MDL_Number TEXT," + "Customer_Region_Code TEXT," + "Customer_Speciality_Code TEXT," +  "Customer_Speciality_Name TEXT," + "Customer_Category_Code TEXT," + "Customer_Category_Name TEXT," + "PlayMode INTEGER," + "Like INTEGER," + "Rating INTEGER" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_ASSET_ANALYTICS_DETAILS) (" + "Asset_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "DA_Code INTEGER," + "Customer_Detailed_Id INTEGER," + "Part_Id INTEGER," + "Part_URL TEXT," + "Session_Id INTEGER," + "Detailed_DateTime DATE," + "Detailed_StartTime DATE," + "Detailed_EndTime DATE," + "Player_StartTime TEXT," + "Player_EndTime TEXT," + "Played_Time_Duration INTEGER," + "Time_Zone TEXT," + "Is_Preview INTEGER," + "Is_Synced INTEGER," + "Synced_DateTime DATE," + "Customer_Code TEXT," + "Customer_Name TEXT," +  "MDL_Number TEXT," + "Customer_Region_Code TEXT," +  "Customer_Speciality_Name TEXT," + "Customer_Category_Code TEXT," + "Customer_Category_Name TEXT," + "Customer_Speciality_Code TEXT," + "Sur_Name TEXT," + "Local_Area TEXT," + "PlayMode INTEGER," + "Like INTEGER," + "Rating INTEGER," + "Latitude TEXT," + "Longitude TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_DOWNLOADED_ASSET) (" + "DA_Code INTEGER PRIMARY KEY," + "DA_Offline_Url TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_DCR_DA_DATA) (" + "Id INTEGER PRIMARY KEY AUTOINCREMENT," + "DCR_Id INTEGER," + "DCR_Doctor_Visit_Id INTEGER," + "DCR_Visit_Code TEXT," + "DA_Code INTEGER," + "DCR_Date DATE," + "Doctor_Code TEXT," +  "Doctor_Region_ Code TEXT," + "Total_Played_Time INTEGER," + "No_Of_Parts_Viewed INTEGER," + "DA_Name TEXT," + "Doc_Type INTEGER," + "No_Of_Parts_Unique_Viewed INTEGER" + ")"
        try db.execute(createTableString)
        
        isMigrationeDetailingRequired = true
    }
    
    var isMigrationeDetailing2Required: Bool = false
    
    migrator.registerMigration(DatabaseMigrationString.eDetailingVersion2.rawValue) { db in
        
        var createTableString = ""
        var rows: [Row] = []
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_ASSET_ANALYTICS_DETAILS)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "MC_StoryID"))
        {
            createTableString = "ALTER TABLE \(TRAN_ASSET_ANALYTICS_DETAILS) ADD MC_StoryID NUMERIC"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "UD_StoryID"))
        {
            createTableString = "ALTER TABLE \(TRAN_ASSET_ANALYTICS_DETAILS) ADD UD_StoryID NUMERIC"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "DA_Type"))
        {
            createTableString = "ALTER TABLE \(TRAN_ASSET_ANALYTICS_DETAILS) ADD DA_Type INTEGER"
            try db.execute(createTableString)
        }
        
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_DOWNLOADED_ASSET)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "DA_Type"))
        {
            createTableString = "ALTER TABLE \(TRAN_DOWNLOADED_ASSET) ADD DA_Type INTEGER"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Is_Downloaded"))
        {
            createTableString = "ALTER TABLE \(TRAN_DOWNLOADED_ASSET) ADD Is_Downloaded INTEGER"
            try db.execute(createTableString)
        }
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TBL_EL_CUSTOMER_DA_FEEDBACK) (" + "Id INTEGER PRIMARY KEY," + "Region_Code TEXT," + "Customer_Code TEXT," + "User_Code TEXT," + "DA_Code INTEGER," + "DA_Type INTEGER," + "Rating INTEGER," + "User_Like INTEGER," + "Feedback TEXT," + "Is_Synced INTEGER," + "Time_Zone TEXT," + "Source_Of_Entry INTEGER," + "Updated_Date DATE," + "Updated_Datetime DATE" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TBL_CUSTOMER_TEMP_SHOWLIST) (" + "Id INTEGER PRIMARY KEY AUTOINCREMENT," + "Story_Id NUMERIC," + "DA_Code INTEGER," + "Display_Order INTEGER" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_MC_STORY_HEADER) (" + "Story_Id NUMERIC," + "Story_Name TEXT," + "Effective_From DATE," + "Effective_To DATE," + "No_Of_Assets INTEGER," +  "Is_Mandatory INTEGER," + "Last_Updated_Time DATE" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_MC_STORY_CATEGORIES) (" + "Story_Id NUMERIC," +  "Category_Code TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_MC_STORY_SPECIALITIES) (" + "Story_Id NUMERIC," + "Speciality_Code TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_MC_STORY_ASSETS) (" + "Story_Id NUMERIC," + "DA_Code INTEGER," + "Display_Order INTEGER" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_MC_STORY_ASSET_LOG) (" + "Story_Id NUMERIC," + "DA_Code INTEGER," + "Customer_Code TEXT," + "Customer_Region_Code TEXT," + "Visit_DateTime DATE," + "TimeZone TEXT," + "Is_Synched INTEGER" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_LOCAL_STORY_HEADER) (" + "Story_Id NUMERIC," + "Story_Name TEXT," + "No_Of_Assets INTEGER," + "Is_Synched INTEGER," + "Active_Status INTEGER" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_LOCAL_STORY_ASSETS) (" + "Story_Id NUMERIC," + "DA_Code INTEGER," + "Display_Order INTEGER" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_LOCAL_STORY_ASSET_LOG) (" + "Story_Id NUMERIC," + "DA_Code INTEGER," + "Customer_Code TEXT," + "Customer_Region_Code TEXT," + "Visit_DateTime DATE," + "TimeZone TEXT" + ")"
        try db.execute(createTableString)
        
        
        isMigrationeDetailing2Required = true
        
    }
    
    var isMigrationeDetailing3Required: Bool = false
    
    migrator.registerMigration(DatabaseMigrationString.eDetailingVersion3.rawValue) { db in
        var createTableString = ""
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TBL_ED_DOCTOR_VISIT_FEEDBACK) (" + "Id INTEGER PRIMARY KEY," + "User_Code TEXT," + "Detailed_Date TEXT," + "Customer_Code TEXT," + "Customer_Region_Code TEXT," + "Visit_Rating INTEGER," + "Visit_Feedback TEXT," + "Source_Of_Entry INTEGER," +  "Updated_Datetime TEXT," + "Time_Zone TEXT," + "Is_Synced INTEGER" + ")"
        try db.execute(createTableString)
        
        isMigrationeDetailing3Required = true
    }
    
    var isMigrationTPVersionRequired: Bool = false
    
    migrator.registerMigration(DatabaseMigrationString.TPVersion.rawValue) { db in
        var createTableString = ""
        
        createTableString = "DROP TABLE \(TRAN_TP_PRODUCT)"
        try db.execute(createTableString)
        
        createTableString = "DROP TABLE \(TRAN_TP_DOCTOR)"
        try db.execute(createTableString)
        
        createTableString = "DROP TABLE \(TRAN_TP_SFC)"
        try db.execute(createTableString)
        
        createTableString = "DROP TABLE \(TRAN_TP_ACCOMPANIST)"
        try db.execute(createTableString)
        
        createTableString = "DROP TABLE \(TRAN_TP_HEADER)"
        try db.execute(createTableString)
        
        var rows: [Row] = []
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(MST_CUSTOMER_MASTER)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Latitude"))
        {
            createTableString = "ALTER TABLE \(MST_CUSTOMER_MASTER) ADD Latitude DOUBLE"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Longitude"))
        {
            createTableString = "ALTER TABLE \(MST_CUSTOMER_MASTER) ADD Longitude DOUBLE"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Anniversary_Date"))
        {
            createTableString = "ALTER TABLE \(MST_CUSTOMER_MASTER) ADD Anniversary_Date DATE"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "DOB"))
        {
            createTableString = "ALTER TABLE \(MST_CUSTOMER_MASTER) ADD DOB DATE"
            try db.execute(createTableString)
        }
        
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_DCR_DOCTOR_VISIT_TRACKER)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "POB_Amount"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_DOCTOR_VISIT_TRACKER) ADD POB_Amount FLOAT"
            try db.execute(createTableString)
        }
        
        
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(MST_USER_DETAILS)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Session_Id"))
        {
            createTableString = "ALTER TABLE \(MST_USER_DETAILS) ADD Session_Id INT"
            try db.execute(createTableString)
        }
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_TP_HEADER) (TP_Entry_Id INTEGER PRIMARY KEY AUTOINCREMENT, TP_Id INTEGER, TP_Date DATE, TP_Day TEXT, Activity INTEGER, Status INTEGER, CP_Id INTEGER, CP_Code TEXT, CP_Name TEXT, Category_Code TEXT, Category_Name TEXT, Activity_Code TEXT, Activity_Name TEXT, Project_Code TEXT, Work_Place TEXT, Meeting_Place TEXT, Meeting_Time TEXT, UnApprove_Reason TEXT, TP_ApprovedBy TEXT, Approved_Date DATE, Is_Weekend INTEGER, Is_Holiday INTEGER, Remarks TEXT, Upload_Message TEXT)"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_TP_ACCOMPANIST) (TP_Accompanist_Id INTEGER PRIMARY KEY AUTOINCREMENT, TP_Entry_Id INTEGER, TP_Id INTEGER, Acc_User_Code TEXT, Acc_User_Type_Code TEXT, Acc_Region_Code TEXT, Acc_User_Name TEXT, Acc_Employee_Name TEXT, Acc_User_Type_Name TEXT, Is_Only_For_Doctor TEXT)"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_TP_SFC) (TP_SFC_Id INTEGER PRIMARY KEY AUTOINCREMENT, TP_Entry_Id INTEGER, TP_Id INTEGER, Flag INTEGER, Distance_Fare_Code TEXT, Region_Code TEXT, SFC_Version INTEGER, From_Place TEXT, To_Place TEXT, Travel_Mode TEXT, Distance FLOAT, SFC_Category_Name TEXT)"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_TP_DOCTOR) (TP_Doctor_Id INTEGER PRIMARY KEY AUTOINCREMENT, TP_Entry_Id INTEGER, TP_Id INTEGER, TP_Date DATE, Doctor_Code TEXT, Doctor_Region_Code TEXT, Doctor_Name TEXT, Doctor_Region_Name TEXT, MDL_Number TEXT, Speciality_Name TEXT, Category_Code TEXT, Category_Name TEXT)"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_TP_PRODUCT) (TP_Product_Id INTEGER PRIMARY KEY AUTOINCREMENT, TP_Entry_Id INTEGER, TP_Id INTEGER, Doctor_Code TEXT, Doctor_Region_Code TEXT, Product_Code TEXT, Product_Name TEXT, Quantity_Provided INTEGER)"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_TP_UNFREEZE_DATES) (TP_Unfreeze_Id INTEGER PRIMARY KEY AUTOINCREMENT, TP_Date DATE)"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(NOTICEBOARD_DETAIL) (" + "Msg_Code TEXT PRIMARY KEY," + "Msg_Distribution_Type TEXT," + "Msg_Title TEXT," + "Msg_Body TEXT," + "Msg_Hyperlink TEXT," + "Msg_Priority INTEGER," +  "Msg_Valid_From TEXT," + "Msg_Valid_To TEXT," + "Msg_Sender_UserCode TEXT," + "Msg_AcknowlendgementReqd TEXT," + "Msg_ApprovalStatus TEXT," + "Msg_AttachmentPath TEXT," + "User_Name TEXT," + "Employee_Name TEXT," + "Show_In_Ticker_Only TEXT," +  "Highlight TEXT," + "Company_Code TEXT," + "Target_UserCode TEXT," + "Is_Read TEXT"+")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(NOTICEBOARD_DOWNLOAD) (" + "Msg_Code TEXT PRIMARY KEY," + "Msg_Distribution_Type TEXT," + "Msg_Title TEXT," + "Msg_Body TEXT," + "Msg_Hyperlink TEXT," + "Msg_AttachmentPath TEXT," +  "Msg_Valid_From TEXT," + "Msg_Valid_To TEXT," + "Is_Read TEXT"+")"
        try db.execute(createTableString)
        
        //massage table creation
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_MAIL_MESSAGE_HEADER) (" + "Msg_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "Msg_Code Text," + "Is_Richtext INTEGER," + "Priority INTEGER," + "Date_From DATE," + "Sent_Status TEXT," + "Sent_Type TEXT," + "Sender_Employee_Name TEXT," + "Sender_User_Code TEXT," + "Is_Sent INTEGER" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_MAIL_MSG_CONTENT) (" + "Msg_Content_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "Msg_Id INTEGER," + "Msg_Code TEXT," + "Subject TEXT," + "Content TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_MAIL_MSG_ATTACHMENT) (" + "Msg_Attachment_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "Msg_Id INTEGER," + "Msg_Code TEXT," + "Local_Attachment_Path TEXT," + "Blob_Url TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_MAIL_MSG_AGENT) (" + "Msg_Agent_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "Msg_Id INTEGER," + "Msg_Code TEXT," + "Target_Usercode TEXT," + "Address_Type INTEGER," + "Is_Read INTEGER," + "Ack_Req INTEGER," + "Target_Employee_Name TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_ED_ASSET_PRODUCT_MAPPING) (" + "Asset_Product_Mapping_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "DA_Code INTEGER," + "Product_Code TEXT," + "Updated_DateTime DATE," + "Active_Status INTEGER" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_DAY_WISE_ASSETS_DETAILED) (" + "Asset_Detailed_Id INTEGER PRIMARY KEY AUTOINCREMENT,Customer_Code TEXT,Customer_Region_Code TEXT,DCR_Actual_Date DATE,DA_Code INTEGER,Product_Code TEXT,Product_Name TEXT,Active_Status INTEGER)"
        try db.execute(createTableString)
        
        isMigrationTPVersionRequired = true
    }
    
    var isMigrationFDCPilot: Bool = false
    
    migrator.registerMigration(DatabaseMigrationString.FDC_Pilot.rawValue) { db in
        var createTableString = ""
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_DOCTOR_PRODUCT_MAPPING) (" + "Doctor_Product_Mapping_Id INTEGER PRIMARY KEY AUTOINCREMENT,Customer_Code TEXT,Customer_Region_Code TEXT,Product_Code TEXT)"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_ED_DOCTOR_LOCATION_INFO) (" + "Doctor_Location_Id INTEGER PRIMARY KEY AUTOINCREMENT,Customer_Code TEXT,Customer_Region_Code TEXT,DCR_Actual_Date DATE,Latitude DOUBLE,Longitude DOUBLE)"
        try db.execute(createTableString)
        
        isMigrationFDCPilot = true
    }
    
    var isMigrationChemistDay: Bool = false
    
    migrator.registerMigration(DatabaseMigrationString.ChemistDay.rawValue) { db in
        var createTableString = ""
        
        var rows: [Row] = []
        
        //        dbPool.read { db in
        //            rows = Row.fetchAll(db, "PRAGMA table_info('\(TRAN_DCR_CHEMIST_VISIT_DETAIL)')")
        //        }
        //
        //        if (!checkIsColumnExist(rowList: rows, columnName: "Cv_Customer_Name"))
        //        {
        //            createTableString = "ALTER TABLE \(TRAN_DCR_CHEMIST_VISIT_DETAIL) ADD Cv_Customer_Name TEXT"
        //            try db.execute(createTableString)
        //        }
        //
        //        if (!checkIsColumnExist(rowList: rows, columnName: "Cv_Customer_Region_Code"))
        //        {
        //            createTableString = "ALTER TABLE \(TRAN_DCR_CHEMIST_VISIT_DETAIL) ADD Cv_Customer_Region_Code TEXT"
        //            try db.execute(createTableString)
        //        }
        //
        //        if (!checkIsColumnExist(rowList: rows, columnName: "Cv_Customer_Code"))
        //        {
        //            createTableString = "ALTER TABLE \(TRAN_DCR_CHEMIST_VISIT_DETAIL) ADD Cv_Customer_Code TEXT"
        //            try db.execute(createTableString)
        //        }
        //        //        if (!checkIsColumnExist(rowList: rows, columnName: "Cv_Customer_Speciality"))
        //        {
        //            createTableString = "ALTER TABLE \(TRAN_DCR_CHEMIST_VISIT_DETAIL) ADD Cv_Customer_Speciality TEXT"
        //            try db.execute(createTableString)
        //        }
        //
        //        if (!checkIsColumnExist(rowList: rows, columnName: "Cv_Customer_Category"))
        //        {
        //            createTableString = "ALTER TABLE \(TRAN_DCR_CHEMIST_VISIT_DETAIL) ADD Cv_Customer_Category TEXT"
        //            try db.execute(createTableString)
        //        }
        //
        //        if (!checkIsColumnExist(rowList: rows, columnName: "Cv_Customer_MDL_Number"))
        //        {
        //            createTableString = "ALTER TABLE \(TRAN_DCR_CHEMIST_VISIT_DETAIL) ADD Cv_Customer_MDL_Number TEXT"
        //            try db.execute(createTableString)
        //        }
        //
        //        if (!checkIsColumnExist(rowList: rows, columnName: "Cv_Customer_Visit_Time"))
        //        {
        //            createTableString = "ALTER TABLE \(TRAN_DCR_CHEMIST_VISIT_DETAIL) ADD Cv_Customer_Visit_Time TEXT"
        //            try db.execute(createTableString)
        //        }
        //
        //        if (!checkIsColumnExist(rowList: rows, columnName: "Cv_Remarks"))
        //        {
        //            createTableString = "ALTER TABLE \(TRAN_DCR_CHEMIST_VISIT_DETAIL) ADD Cv_Remarks TEXT"
        //            try db.execute(createTableString)
        //        }
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_DCR_DOCTOR_VISIT_ATTACHMENT)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "DCR_Code"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_DOCTOR_VISIT_ATTACHMENT) ADD DCR_Code TEXT"
            try db.execute(createTableString)
        }
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(MST_DETAIL_PRODUCTS)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Unit_Rate"))
        {
            createTableString = "ALTER TABLE \(MST_DETAIL_PRODUCTS) ADD Unit_Rate DECIMAL(10,2)"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Region_Code"))
        {
            createTableString = "ALTER TABLE \(MST_DETAIL_PRODUCTS) ADD Region_Code TEXT"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Price_Group_Code"))
        {
            createTableString = "ALTER TABLE \(MST_DETAIL_PRODUCTS) ADD Price_Group_Code TEXT"
            try db.execute(createTableString)
        }
        
        createTableString = "DROP TABLE \(TRAN_DCR_DOCTOR_VISIT_POB_HEADER)"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_DCR_DOCTOR_VISIT_POB_HEADER) (" + "Order_Entry_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "Order_Id INTEGER," + "Order_Number INTEGER," + "Order_Date DATE," + "DCR_Id INTEGER," + "DCR_Code TEXT," + "DCR_Actual_Date DATE," + "Stockiest_Name TEXT," + "Stockiest_Code TEXT," + "Stockiest_Region_Code TEXT," + "Customer_Name TEXT," + "Customer_Code TEXT," + "Customer_Region_Code TEXT," + "Customer_MDL_Number TEXT," + "Customer_Category_Code TEXT," + "Speciality_Name TEXT," + "Visit_Id INTEGER," + "Order_Due_Date DATE," + "Order_Status INTEGER," + "Order_Mode INTEGER," + "Action_Mode INTEGER DEFAULT 0," + "Favouring_User_Code TEXT," + "Favouring_Region_Code TEXT," + "Customer_Entity_Type TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "DROP TABLE \(TRAN_DCR_DOCTOR_VISIT_POB_DETAILS)"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_DCR_DOCTOR_VISIT_POB_DETAILS) (" + "Order_Detail_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "Order_Entry_Id INTEGER," + "DCR_Id INTEGER," + "DCR_Code TEXT," + "Product_Name TEXT," + "Product_Code TEXT," + "Product_Qty DECIMAL(10,2)," + "Product_Unit_Rate DECIMAL(10,2)," + "Product_Amount DECIMAL(12,2)" + ")"
        try db.execute(createTableString)
        
        createTableString = "DROP TABLE \(TRAN_DCR_DOCTOR_VISIT_POB_REMARKS)"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_DCR_DOCTOR_VISIT_POB_REMARKS) (" + "Remarks_Entry_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "Order_Entry_Id INTEGER," + "DCR_Id INTEGER," + "DCR_Code TEXT," + "Remarks TEXT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_DCR_CHEMIST_DAY_VISIT) (DCR_Chemist_Day_Visit_Id INTEGER PRIMARY KEY AUTOINCREMENT,DCR_Id INTEGER, DCR_Code TEXT, CV_Visit_Id INTEGER, Chemist_Visit_Code TEXT, Chemist_Code TEXT,Chemist_Region_Code TEXT, Chemist_Name TEXT,Chemist_Region_Name TEXT,Category_Code TEXT,Category_Name TEXT,MDL_Number TEXT,Visit_Mode TEXT,Visit_Time TEXT,Remarks TEXT,Latitude DOUBLE,Longitude DOUBLE)"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_DCR_CHEMIST_ACCOMPANIST) (DCR_Chemist_Accompanist_Id INTEGER PRIMARY KEY AUTOINCREMENT,DCR_Chemist_Day_Visit_Id INTEGER,DCR_Id INTEGER,DCR_Code TEXT,Chemist_Visit_Id INTEGER,Chemist_Visit_Code TEXT,Acc_Region_Code TEXT,Acc_User_Name TEXT,Acc_User_Code TEXT,Acc_User_Type_Name TEXT,Is_Accompanied_Call INTEGER,Is_Only_For_Chemist INTEGER)"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_DCR_CHEMIST_SAMPLE_PROMOTION) (DCR_Chemist_Sample_Id INTEGER PRIMARY KEY AUTOINCREMENT,DCR_Chemist_Day_Visit_Id INTEGER,DCR_Id INTEGER,DCR_Code TEXT,Chemist_Visit_Id INTEGER,Chemist_Visit_Code TEXT,Product_Code TEXT,Product_Name TEXT,Quantity_Provided INTEGER)"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_DCR_CHEMIST_DETAILED_PRODUCT) (DCR_Chemist_Detail_Id INTEGER PRIMARY KEY AUTOINCREMENT,DCR_Chemist_Day_Visit_Id INTEGER,DCR_Id INTEGER,DCR_Code TEXT,Chemist_Visit_Id INTEGER,Product_Code TEXT,Product_Name TEXT,Chemist_Visit_Code TEXT)"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_DCR_CHEMIST_RCPA_OWN) (DCR_Chemist_RCPA_Own_Id INTEGER PRIMARY KEY AUTOINCREMENT,DCR_Chemist_Day_Visit_Id INTEGER,DCR_Id INTEGER,DCR_Code TEXT,Chemist_Visit_Id INTEGER,Chemist_Visit_Code TEXT,Own_Product_Id INTEGER,Product_Code TEXT,Product_Name TEXT,Quantity FLOAT,Doctor_Code TEXT,Doctor_Region_Code TEXT,Doctor_Name TEXT,Doctor_Speciality_Name TEXT,Doctor_Category_Name TEXT,Doctor_MDL_Number TEXT)"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_DCR_CHEMIST_RCPA_COMPETITOR) (DCR_Chemist_RCPA_Competitor_Id INTEGER PRIMARY KEY AUTOINCREMENT,DCR_Chemist_RCPA_Own_Id INTEGER,DCR_Chemist_Day_Visit_Id INTEGER,DCR_Id INTEGER,DCR_Code TEXT,Chemist_Visit_Id INTEGER,Chemist_Visit_Code TEXT,Own_Product_Code TEXT,Competitor_Product_Code TEXT,Competitor_Product_Name TEXT,Quantity FLOAT)"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_DCR_CHEMIST_ATTACHMENT) (DCR_Chemist_Attachment_Id INTEGER PRIMARY KEY AUTOINCREMENT,DCR_Chemist_Day_Visit_Id INTEGER,DCR_Id INTEGER,DCR_Code TEXT,Chemist_Visit_Id INTEGER,Chemist_Visit_Code TEXT,DCR_Actual_Date DATE,Blob_Url TEXT,Uploaded_File_Name TEXT,IsFile_Downloaded INTEGER, Is_Success INTEGER)"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_DCR_CHEMIST_FOLLOWUP) (DCR_Chemist_Followup_Id INTEGER PRIMARY KEY AUTOINCREMENT,DCR_Chemist_Day_Visit_Id INTEGER,DCR_Id INTEGER,DCR_Code TEXT,Chemist_Visit_Id INTEGER,Chemist_Visit_Code TEXT,Task TEXT,Due_Date DATE)"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_CUSTOMER_MASTER_EDIT) (Customer_Id INTEGER PRIMARY KEY AUTOINCREMENT,Customer_Code TEXT,Customer_Name TEXT,Region_Code TEXT,Region_Name TEXT,Speciality_Code TEXT,Speciality_Name TEXT,Category_Code TEXT,Category_Name TEXT,MDL_Number TEXT,Local_Area TEXT,Hospital_Name TEXT,Customer_Entity_Type TEXT,Sur_Name TEXT, Latitude DOUBLE, Longitude DOUBLE, Anniversary_Date DATE, DOB DATE, Customer_Status INTEGER)"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_CUSOMTER_MASTER_PERSONAL_INFO_EDIT) (Customer_Code TEXT,Region_Code TEXT,DOB DATE,Anniversary_Date DATE,Mobile_Number TEXT,Alternate_Number TEXT,Assistant_Number TEXT,Registration_Number TEXT,Email_Id TEXT,Blob_Photo_Url TEXT,Hospital_Name TEXT,Hospital_Address TEXT,Notes TEXT, Photo_Local_Path TEXT)"
        try db.execute(createTableString)
        
        isMigrationChemistDay = true
    }
    
    var isMigrationAlertBuild: Bool = false
    
    migrator.registerMigration(DatabaseMigrationString.AlertBuild.rawValue) { db in
        var createTableString = ""
        
        var rows: [Row] = []
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(MST_DOCTOR_PRODUCT_MAPPING)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Product_Name"))
        {
            createTableString = "ALTER TABLE \(MST_DOCTOR_PRODUCT_MAPPING) ADD Product_Name TEXT"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Brand_Name"))
        {
            createTableString = "ALTER TABLE \(MST_DOCTOR_PRODUCT_MAPPING) ADD Brand_Name TEXT"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Priority_Order"))
        {
            createTableString = "ALTER TABLE \(MST_DOCTOR_PRODUCT_MAPPING) ADD Priority_Order INTEGER"
            try db.execute(createTableString)
        }
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_DCR_HEADER)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Is_TP_Frozen"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_HEADER) ADD Is_TP_Frozen INTEGER"
            try db.execute(createTableString)
        }
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_DCR_TRAVELLED_PLACES)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Is_TP_SFC"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_TRAVELLED_PLACES) ADD Is_TP_SFC INTEGER"
            try db.execute(createTableString)
        }
        
        
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_MC_DOCTOR_PRODUCT_MAPPING) (MC_Doctor_Product_Mapping_Id INTEGER PRIMARY KEY AUTOINCREMENT,MC_Code TEXT,MC_Name TEXT,Customer_Code TEXT,Customer_Region_Code TEXT,Product_Code TEXT,Product_Name TEXT,Brand_Name TEXT,Priority_Order INTEGER,Effective_From DATE,Effective_To DATE)"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_MASTER_DATA_DOWNLOAD_CHECK_API_INFO) (API_Check_Date DATE PRIMARY KEY,Skip_Count  INTEGER,Completed_Status INTEGER)"
        try db.execute(createTableString)
        
        isMigrationAlertBuild = true
    }
    
    var isPaswordPolicyMigrationRequired: Bool = false
    
    migrator.registerMigration(DatabaseMigrationString.PasswordPolicy.rawValue) { db in
        var createTableString = ""
        var rows: [Row] = []
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(MST_USER_DETAILS)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Last_Password_Updated_Date"))
        {
            createTableString = "ALTER TABLE \(MST_USER_DETAILS) ADD Last_Password_Updated_Date TEXT"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Account_Locked_DateTime"))
        {
            createTableString = "ALTER TABLE \(MST_USER_DETAILS) ADD Account_Locked_DateTime TEXT"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Is_Account_Locked"))
        {
            createTableString = "ALTER TABLE \(MST_USER_DETAILS) ADD Is_Account_Locked INTEGER"
            try db.execute(createTableString)
        }
        
        isPaswordPolicyMigrationRequired = true
    }
    
    var isDoctorPOBMigratonRequired: Bool = false
    
    migrator.registerMigration(DatabaseMigrationString.DOCTORPOB.rawValue) { db in
        var createTableString = ""
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_CUSTOMER_ADDRESS) (Address_Id INTEGER PRIMARY KEY,Customer_Code TEXT,Region_Code TEXT,Customer_Entity_Type TEXT,Address1 TEXT,Address2 TEXT,Local_Area TEXT,City TEXT,State TEXT,Pin_Code TEXT,Hospital_Name TEXT,Hospital_Classification TEXT,Phone_Number TEXT,Email_Id TEXT,Latitude DOUBLE,Longitude DOUBLE,Is_Synced INTEGER,Update_Page_Source TEXT)"
        try db.execute(createTableString)
        
        var rows: [Row] = []
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_DCR_DOCTOR_VISIT)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Geo_Fencing_Deviation_Remarks"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_DOCTOR_VISIT) ADD Geo_Fencing_Deviation_Remarks TEXT"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Geo_Fencing_Page_Source"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_DOCTOR_VISIT) ADD Geo_Fencing_Page_Source TEXT"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Business_Status_ID"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_DOCTOR_VISIT) ADD Business_Status_ID INTEGER"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Business_Status_Name"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_DOCTOR_VISIT) ADD Business_Status_Name TEXT"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Business_Status_Active_Status"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_DOCTOR_VISIT) ADD Business_Status_Active_Status INTEGER"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Call_Objective_ID"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_DOCTOR_VISIT) ADD Call_Objective_ID INTEGER"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Call_Objective_Name"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_DOCTOR_VISIT) ADD Call_Objective_Name TEXT"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Call_Objective_Active_Status"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_DOCTOR_VISIT) ADD Call_Objective_Active_Status INTEGER"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Is_DCR_Inherited_Doctor"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_DOCTOR_VISIT) ADD Is_DCR_Inherited_Doctor INTEGER"
            try db.execute(createTableString)
        }
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_ED_DOCTOR_LOCATION_INFO)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Geo_Fencing_Deviation_Remarks"))
        {
            createTableString = "ALTER TABLE \(TRAN_ED_DOCTOR_LOCATION_INFO) ADD Geo_Fencing_Deviation_Remarks TEXT"
            try db.execute(createTableString)
        }
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_DCR_CALL_ACTIVITY) (DCR_Call_Activity_ID INTEGER PRIMARY KEY,DCR_Code TEXT,DCR_Id INTEGER,DCR_Customer_Visit_Id INTEGER,DCR_Customer_Visit_Code INTEGER,Flag INTEGER,Customer_Entity_Type INTEGER,Customer_Entity_Type_Description TEXT,Customer_Activity_ID INTEGER,Customer_Activity_Name TEXT,Cusotmer_Activity_Status INTEGER,Activity_Remarks TEXT)"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_DCR_MC_ACTIVITY) (DCR_MC_Activity_ID INTEGER PRIMARY KEY,DCR_Code TEXT,DCR_Id INTEGER,DCR_Customer_Visit_Id INTEGER,DCR_Customer_Visit_Code INTEGER,Flag INTEGER,Customer_Entity_Type INTEGER,Customer_Entity_Type_Description TEXT,Campaign_Code TEXT,Campaign_Name TEXT,MC_Activity_Id INTEGER,MC_Activity_Name TEXT,MC_Activity_Status INTEGER,MC_Activity_Remarks TEXT)"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_BUSINESS_STATUS) (Business_Status_ID INTEGER PRIMARY KEY,Status_Name TEXT,Entity_Type INTEGER,Entity_Type_Description TEXT)"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_CALL_OBJECTIVE) (Call_Objective_ID INTEGER PRIMARY KEY,Call_Objective_Name TEXT,Entity_Type INTEGER,Entity_Type_Description TEXT)"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_CALL_ACTIVITY) (Call_Activity_Id INTEGER PRIMARY KEY,Activity_Name TEXT)"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_MC_HEADER) (Campaign_Code INTEGER PRIMARY KEY,Campaign_Name TEXT,Effective_From DATE,Effective_To DATE)"
        try db.execute(createTableString)
        
        //        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_MC_MAPPED_REGION_TYPES) (Mapping_Id INTEGER PRIMARY KEY AUTOINCREMENT,Campaign_Code TEXT,Region_Type_Code TEXT)"
        //        try db.execute(createTableString)
        
        //        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_MC_CATEGORY) (MC_Category_Id INTEGER PRIMARY KEY AUTOINCREMENT,Campaign_Code TEXT,Customer_Category_Code TEXT)"
        //        try db.execute(createTableString)
        //
        //        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_MC_SPECIALITY) (MC_Speciality_Id INTEGER PRIMARY KEY AUTOINCREMENT,Campaign_Code TEXT,Customer_Speciality_Code TEXT)"
        //        try db.execute(createTableString)
        //
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_MC_ACTIVITY) (MC_Activity_Id INTEGER,Campaign_Code TEXT,MC_Activity_Name TEXT)"
        try db.execute(createTableString)
        //
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(MST_USER_DETAILS)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Region_Type_Code"))
        {
            createTableString = "ALTER TABLE \(MST_USER_DETAILS) ADD Region_Type_Code TEXT"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Region_Type_Name"))
        {
            createTableString = "ALTER TABLE \(MST_USER_DETAILS) ADD Region_Type_Name TEXT"
            try db.execute(createTableString)
        }
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_DCR_DETAILED_PRODUCTS)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Business_Status_ID"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_DETAILED_PRODUCTS) ADD Business_Status_ID INTEGER"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Business_Status_Name"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_DETAILED_PRODUCTS) ADD Business_Status_Name TEXT"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Business_Status_Active_Status"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_DETAILED_PRODUCTS) ADD Business_Status_Active_Status INTEGER"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Business_Potential"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_DETAILED_PRODUCTS) ADD Business_Potential FLOAT"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Remarks"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_DETAILED_PRODUCTS) ADD Remarks TEXT"
            try db.execute(createTableString)
        }
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(MST_MC_DOCTOR_PRODUCT_MAPPING)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Ref_Type"))
        {
            createTableString = "ALTER TABLE \(MST_MC_DOCTOR_PRODUCT_MAPPING) ADD Ref_Type TEXT"
            try db.execute(createTableString)
        }
        
        isDoctorPOBMigratonRequired = true
    }
    
    var isDoctorInheritanceMigrationRequired: Bool = false
    
    migrator.registerMigration(DatabaseMigrationString.DOCTORINHERITANCE.rawValue) { db in
        var createTableString = ""
        var rows: [Row] = []
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_DCR_DOCTOR_VISIT)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Is_DCR_Inherited_Doctor"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_DOCTOR_VISIT) ADD Is_DCR_Inherited_Doctor INTEGER"
            try db.execute(createTableString)
        }
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_DCR_ACCOMPANIST)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Is_Customer_Data_Inherited"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_ACCOMPANIST) ADD Is_Customer_Data_Inherited INTEGER"
            try db.execute(createTableString)
        }
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(MST_ACCOMPANIST)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Child_User_Count"))
        {
            createTableString = "ALTER TABLE \(MST_ACCOMPANIST) ADD Child_User_Count INTEGER"
            try db.execute(createTableString)
        }
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_REGION_ENTITY_COUNT) (Region_Code TEXT,Entity_Type TEXT,Count INTEGER)"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_ERROR_LOG) (Log_Id INTEGER PRIMARY KEY AUTOINCREMENT, Event_Id INTEGER, Priority INTEGER, Severity TEXT, Timestamp TEXT, MachineName TEXT, AppDomainName TEXT, ProcessID TEXT, ProcessName TEXT, ThreadName TEXT, Message TEXT, ExtendedProperties TEXT)"
        try db.execute(createTableString)
        
        
        
        isDoctorInheritanceMigrationRequired = true
    }
    
    var isICEMigrationRequired: Bool = false
    
    migrator.registerMigration(DatabaseMigrationString.ICE.rawValue) { db in
        var createTableString = ""
        var rows: [Row] = []
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(MST_ASSET_HEADER)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Asset_Id"))
        {
            createTableString = "ALTER TABLE \(MST_ASSET_HEADER) ADD Asset_Id INTEGER"
            try db.execute(createTableString)
        }
//        if (!checkIsColumnExist(rowList: rows, columnName: "Total_Measure"))
//        {
//            createTableString = "ALTER TABLE \(MST_ASSET_HEADER) ADD Total_Measure TEXT"
//            try db.execute(createTableString)
//        }
//        if (!checkIsColumnExist(rowList: rows, columnName: "Measured_Unit"))
//        {
//            createTableString = "ALTER TABLE \(MST_ASSET_HEADER) ADD Measured_Unit TEXT"
//            try db.execute(createTableString)
//        }
        
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(MST_MC_STORY_HEADER)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Local_Story_Id"))
        {
            createTableString = "ALTER TABLE \(MST_MC_STORY_HEADER) ADD Local_Story_Id INTEGER"
            try db.execute(createTableString)
        }
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_DCR_EDETAIL_DOCTOR_DELETE_AUDIT) (Audit_Id INTEGER PRIMARY KEY AUTOINCREMENT, DCR_Id INTEGER, DCR_Actual_Date TEXT, Doctor_Code TEXT, Doctor_Region_Code TEXT, Doctor_Name TEXT)"
        try db.execute(createTableString)
        
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_DCR_COMPETITOR_DETAILS)(Competitor_Detail_Id INTEGER PRIMARY KEY AUTOINCREMENT, DCR_ID INTEGER, DCR_Code TEXT, DCR_Doctor_Visit_Code TEXT, DCR_Doctor_Visit_Id INTEGER, DCR_Product_Detail_Id INTEGER, DCR_Product_Detail_Code TEXT, Competitor_Code INTEGER, Competitor_Name TEXT, Product_Name TEXT, Product_Code TEXT, Value INTEGER, Probability FLOAT, Remarks TEXT)"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_COMPETITOR_MAPPING)(Competitor_Code INTEGER, Competitor_Name TEXT, Competitor_Status INTEGER)"
        try db.execute(createTableString)
        
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_COMPETITOR_PRODUCT_MASTER)(Product_Name TEXT, Product_Code TEXT, Competitor_Code INTEGER)"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_DCR_ATTENDANCE_DOCTOR_VISIT)(DCR_Doctor_Visit_Id INTEGER PRIMARY KEY AUTOINCREMENT,DCR_Id INTEGER,DCR_Code TEXT,Doctor_Code TEXT,Doctor_Name TEXT,DCR_Doctor_Visit_Code TEXT,DCR_Actual_Date DATE,Doctor_Region_Name TEXT,Doctor_Region_Code TEXT,Speciality_Name TEXT,Speciality_Code TEXT,Category_Name TEXT,Category_Code TEXT,MDL_Number TEXT)"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_DCR_ATTENDANCE_SAMPLES_DETAILS)(DCR_Attendance_Sample_Id INTEGER PRIMARY KEY AUTOINCREMENT,DCR_Id INTEGER,DCR_Code TEXT,DCR_Doctor_Visit_Id INTEGER,DCR_Doctor_Visit_Code TEXT,DCR_Actual_Date DATE,Product_Code TEXT,Product_Name TEXT,Quantity_Provided INTEGER,Remark TEXT)"
        try db.execute(createTableString)
        
        isICEMigrationRequired = true
    }
    
    var isHourlyReportChangeMigrationRequired: Bool = false
    
    migrator.registerMigration(DatabaseMigrationString.HOURLY_REPORT_CHANGE.rawValue) { db in
        var createTableString = ""
        var rows: [Row] = []
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_ED_DOCTOR_LOCATION_INFO)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Synced_Date_Time"))
        {
            createTableString = "ALTER TABLE \(TRAN_ED_DOCTOR_LOCATION_INFO) ADD Synced_Date_Time TEXT"
            try db.execute(createTableString)
        }
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(MST_USER_PRODUCT)')")
        }
        //MST_USER_PRODUCT
        if (!checkIsColumnExist(rowList: rows, columnName: "Effective_From"))
        {
            createTableString = "ALTER TABLE \(MST_USER_PRODUCT) ADD Effective_From TEXT"
            try db.execute(createTableString)
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Effective_To"))
        {
            createTableString = "ALTER TABLE \(MST_USER_PRODUCT) ADD Effective_To TEXT"
            try db.execute(createTableString)
        }
        isHourlyReportChangeMigrationRequired = true
    }
    
    var isSampleBatchMigrationRequired: Bool = false
    
    migrator.registerMigration(DatabaseMigrationString.SAMPLEBATCH.rawValue) { db in
        var createTableString = ""
        var rows: [Row] = []
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(MST_USER_PRODUCT)')")
        }
        //MST_USER_PRODUCT
        if (!checkIsColumnExist(rowList: rows, columnName: "Min_Count"))
        {
            createTableString = "ALTER TABLE \(MST_USER_PRODUCT) ADD Min_Count INTEGER"
            try db.execute(createTableString)
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Max_Count"))
        {
            createTableString = "ALTER TABLE \(MST_USER_PRODUCT) ADD Max_Count INTEGER"
            try db.execute(createTableString)
        }
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_SAMPLE_BATCH_MAPPING)(Product_Code TEXT,Batch_Number TEXT, Expiry_Date TEXT, Batch_Effective_From TEXT,Batch_Effective_To TEXT,Batch_Current_Stock INTEGER)"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_DCR_SAMPLE_DETAILS_MAPPING)(Ref_Id INTEGER,DCR_Id INTEGER,DCR_Code TEXT,Visit_Id INTEGER,Visit_Code TEXT,Product_Code TEXT,Batch_Number TEXT,Quantity_Provided INTEGER,Entity_Type TEXT)"
        try db.execute(createTableString)
        
        
        isSampleBatchMigrationRequired = true
    }
    
    var isInwardBatchMigrationRequired: Bool = false
    
    migrator.registerMigration(DatabaseMigrationString.INWARDBATCH.rawValue) { db in
        var createTableString = ""
        var rows: [Row] = []
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_DCR_CALENDAR_HEADER)')")
        }
        //MST_USER_PRODUCT
        if (!checkIsColumnExist(rowList: rows, columnName: "Is_Field_Lock"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_CALENDAR_HEADER) ADD Is_Field_Lock INTEGER NOT NULL DEFAULT(0)"
            try db.execute(createTableString)
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Is_Attendance_Lock"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_CALENDAR_HEADER) ADD Is_Attendance_Lock INTEGER NOT NULL DEFAULT(0)"
            try db.execute(createTableString)
        }
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_DCR_ACCOMPANIST)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Is_TP_Frozen"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_ACCOMPANIST) ADD Is_TP_Frozen INTEGER NOT NULL DEFAULT(0)"
            try db.execute(createTableString)
        }
        
        
        isInwardBatchMigrationRequired = true
    }
    
    var isAttendanceActivityMigrationRequired: Bool = false
    
    migrator.registerMigration(DatabaseMigrationString.ATTENDANCEACTIVITY.rawValue) { db in
        var createTableString = ""
        var rows: [Row] = []
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_DCR_DOCTOR_VISIT)')")
        }
        //MST_USER_PRODUCT
        if (!checkIsColumnExist(rowList: rows, columnName: "Campaign_Code"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_DOCTOR_VISIT) ADD Campaign_Code TEXT"
            try db.execute(createTableString)
        }
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_DCR_DOCTOR_VISIT)')")
        }
        //MST_USER_PRODUCT
        if (!checkIsColumnExist(rowList: rows, columnName: "Campaign_Name"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_DOCTOR_VISIT) ADD Campaign_Name TEXT"
            try db.execute(createTableString)
        }
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_DCR_ATTENDANCE_DOCTOR_VISIT)')")
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Campaign_Code"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_ATTENDANCE_DOCTOR_VISIT) ADD Campaign_Code TEXT"
            try db.execute(createTableString)
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Business_Status_ID"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_ATTENDANCE_DOCTOR_VISIT) ADD Business_Status_ID INTEGER"
            try db.execute(createTableString)
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Business_Status_Active_Status"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_ATTENDANCE_DOCTOR_VISIT) ADD Business_Status_Active_Status INTEGER"
            try db.execute(createTableString)
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Business_Status_Name"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_ATTENDANCE_DOCTOR_VISIT) ADD Business_Status_Name TEXT"
            try db.execute(createTableString)
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Call_Objective_ID"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_ATTENDANCE_DOCTOR_VISIT) ADD Call_Objective_ID INTEGER"
            try db.execute(createTableString)
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Call_Objective_Active_Status"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_ATTENDANCE_DOCTOR_VISIT) ADD Call_Objective_Active_Status INTEGER"
            try db.execute(createTableString)
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Call_Objective_Name"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_ATTENDANCE_DOCTOR_VISIT) ADD Call_Objective_Name TEXT"
            try db.execute(createTableString)
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Campaign_Name"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_ATTENDANCE_DOCTOR_VISIT) ADD Campaign_Name TEXT"
            try db.execute(createTableString)
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Remarks"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_ATTENDANCE_DOCTOR_VISIT) ADD Remarks TEXT"
            try db.execute(createTableString)
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Visit_Mode"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_ATTENDANCE_DOCTOR_VISIT) ADD Visit_Mode TEXT"
            try db.execute(createTableString)
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Visit_Time"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_ATTENDANCE_DOCTOR_VISIT) ADD Visit_Time TEXT"
            try db.execute(createTableString)
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Longitude"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_ATTENDANCE_DOCTOR_VISIT) ADD Longitude TEXT"
            try db.execute(createTableString)
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Lattitude"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_ATTENDANCE_DOCTOR_VISIT) ADD Lattitude TEXT"
            try db.execute(createTableString)
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "POB_Amount"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_ATTENDANCE_DOCTOR_VISIT) ADD POB_Amount FLOAT"
            try db.execute(createTableString)
        }
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_DCR_CALL_ACTIVITY)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Entity_Type"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_CALL_ACTIVITY) ADD Entity_Type TEXT"
            try db.execute(createTableString)
        }
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_DCR_MC_ACTIVITY)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Entity_Type"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_MC_ACTIVITY) ADD Entity_Type TEXT"
            try db.execute(createTableString)
        }
        
        
        isAttendanceActivityMigrationRequired = true
    }
    
    var isAccompanistChangeMigrationRequired: Bool = false
    
    migrator.registerMigration(DatabaseMigrationString.ACCOMPANISTCHANGE.rawValue) { db in
        var createTableString = ""
        var rows: [Row] = []
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_DCR_ACCOMPANIST)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Employee_Name"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_ACCOMPANIST) ADD Employee_Name TEXT"
            try db.execute(createTableString)
        }
        
        
        
        isAccompanistChangeMigrationRequired = true
    }
    
    var isMCInDoctorVisitMigrationRequired: Bool = false
    
    migrator.registerMigration(DatabaseMigrationString.MCINDOCTORVISIT.rawValue) { db in
        var createTableString = ""
        var rows: [Row] = []
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(MST_DOCTOR_PRODUCT_MAPPING)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Customer_Name"))
        {
            createTableString = "ALTER TABLE \(MST_DOCTOR_PRODUCT_MAPPING) ADD Customer_Name TEXT"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Customer_Status"))
        {
            createTableString = "ALTER TABLE \(MST_DOCTOR_PRODUCT_MAPPING) ADD Customer_Status TEXT"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "MDL_Number"))
        {
            createTableString = "ALTER TABLE \(MST_DOCTOR_PRODUCT_MAPPING) ADD MDL_Number TEXT"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Potential_Quantity"))
        {
            createTableString = "ALTER TABLE \(MST_DOCTOR_PRODUCT_MAPPING) ADD Potential_Quantity TEXT"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Support_Quantity"))
        {
            createTableString = "ALTER TABLE \(MST_DOCTOR_PRODUCT_MAPPING) ADD Support_Quantity TEXT"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Ref_Type"))
        {
            createTableString = "ALTER TABLE \(MST_DOCTOR_PRODUCT_MAPPING) ADD Ref_Type TEXT"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Created_By"))
        {
            createTableString = "ALTER TABLE \(MST_DOCTOR_PRODUCT_MAPPING) ADD Created_By TEXT"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Mapped_Region_Code"))
        {
            createTableString = "ALTER TABLE \(MST_DOCTOR_PRODUCT_MAPPING) ADD Mapped_Region_Code TEXT"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Selected_Region_Code"))
        {
            createTableString = "ALTER TABLE \(MST_DOCTOR_PRODUCT_MAPPING) ADD Selected_Region_Code TEXT"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "MC_Code"))
        {
            createTableString = "ALTER TABLE \(MST_DOCTOR_PRODUCT_MAPPING) ADD MC_Code TEXT"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "MC_Name"))
        {
            createTableString = "ALTER TABLE \(MST_DOCTOR_PRODUCT_MAPPING) ADD MC_Name TEXT"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "MC_Effective_From"))
        {
            createTableString = "ALTER TABLE \(MST_DOCTOR_PRODUCT_MAPPING) ADD MC_Effective_From DATE"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "MC_Effective_To"))
        {
            createTableString = "ALTER TABLE \(MST_DOCTOR_PRODUCT_MAPPING) ADD MC_Effective_To DATE"
            try db.execute(createTableString)
        }
        
        // MST_DETAIL_PRODUCTS
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(MST_DETAIL_PRODUCTS)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Product_Type_Name"))
        {
            createTableString = "ALTER TABLE \(MST_DETAIL_PRODUCTS) ADD Product_Type_Name TEXT"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Effective_From"))
        {
            createTableString = "ALTER TABLE \(MST_DETAIL_PRODUCTS) ADD Effective_From DATE"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Effective_To"))
        {
            createTableString = "ALTER TABLE \(MST_DETAIL_PRODUCTS) ADD Effective_To DATE"
            try db.execute(createTableString)
        }
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(MST_USER_DETAILS)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Full_index"))
        {
            createTableString = "ALTER TABLE \(MST_USER_DETAILS) ADD Full_index TEXT"
            try db.execute(createTableString)
        }
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(MST_ACCOMPANIST)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Full_index"))
        {
            createTableString = "ALTER TABLE \(MST_ACCOMPANIST) ADD Full_index TEXT"
            try db.execute(createTableString)
        }
        

        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(MST_MC_HEADER)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Customer_Count"))
        {
            createTableString = "ALTER TABLE \(MST_MC_HEADER) ADD Customer_Count INTEGER"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Customer_Selection"))
        {
            createTableString = "ALTER TABLE \(MST_MC_HEADER) ADD Customer_Selection TEXT"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Campaign_Based_On"))
        {
            createTableString = "ALTER TABLE \(MST_MC_HEADER) ADD Campaign_Based_On TEXT"
            try db.execute(createTableString)
        }
        
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_MC_DETAILS)(MC_Id INTEGER PRIMARY KEY AUTOINCREMENT,Campaign_Code TEXT,Ref_Type TEXT,Ref_Code TEXT)"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_DIVISION_MAPPING_DETAILS)(Division_Id INTEGER PRIMARY KEY AUTOINCREMENT,Entity_Code TEXT,Ref_Type TEXT,Division_Code TEXT)"
        try db.execute(createTableString)
        
        
        isMCInDoctorVisitMigrationRequired = true
    }
    
    var isBusinessPotentialRequired: Bool = false
    
    migrator.registerMigration(DatabaseMigrationString.BUSSINESSPOTENTIAL.rawValue) { db in
        var createTableString = ""
        var rows: [Row] = []
        
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(BUSINESS_STATUS_POTENTIAL) (" + "Doctor_Code TEXT," + "Doctor_Region_Code TEXT," + "Dcr_Date TEXT," + "Business_Status_Id INTEGER," + "Business_Status_Name TEXT," + "Entity_Type INTEGER," + "Entity_Description TEXT," + "Division_Code TEXT," + "Product_Code TEXT," + "Business_Potential FLOAT" + ")"
        try db.execute(createTableString)
        
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_DCR_STOCKIST_VISIT)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Visit_Time"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_STOCKIST_VISIT) ADD Visit_Time TEXT"
            try db.execute(createTableString)
        }
        
        isBusinessPotentialRequired = true
    }
    
    var isTravelTrackingReportRequired: Bool = false

    migrator.registerMigration(DatabaseMigrationString.TRAVELTRACKINGREPRT.rawValue) { db in
        var createTableString = ""
        var rows: [Row] = []

        createTableString = "CREATE TABLE IF NOT EXISTS \(Travel_Tracking_Report) (" + "Latitude TEXT," + "Longitude  TEXT," + "Entered_DateTime DATE," + "Type TEXT" + ")"
        try db.execute(createTableString)

        isTravelTrackingReportRequired = true
    }
    
    var isMenuRequired: Bool = false
    
    migrator.registerMigration(DatabaseMigrationString.MENUCUSTOMIZATION.rawValue) { db in
        var createTableString = ""
        var rows: [Row] = []
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(MST_MENU_MASTER)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "MDM_Menu_Url"))
        {
            createTableString = "ALTER TABLE \(MST_MENU_MASTER) ADD MDM_Menu_Url TEXT"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Type"))
        {
            createTableString = "ALTER TABLE \(MST_MENU_MASTER) ADD Type TEXT"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Category"))
        {
            createTableString = "ALTER TABLE \(MST_MENU_MASTER) ADD Category TEXT"
            try db.execute(createTableString)
        }

        isMenuRequired = true

    }
    
    var isLatLongRequired: Bool = false
    
        migrator.registerMigration(DatabaseMigrationString.STOCKIST.rawValue) { db in
        var createTableString = ""
        var rows: [Row] = []
        
            try dbPool.read { db in
                rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_DCR_STOCKIST_VISIT)')")
            }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Latitude"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_STOCKIST_VISIT) ADD Latitude TEXT"
            try db.execute(createTableString)
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Longitude"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_STOCKIST_VISIT) ADD Longitude TEXT"
            try db.execute(createTableString)
        }
        
        isLatLongRequired = true
        
    }
    
    var isEntityTypeRequired: Bool = false
    
    migrator.registerMigration(DatabaseMigrationString.ENTITYTYPE.rawValue) { db in
        var createTableString = ""
        var rows: [Row] = []
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_DCR_DOCTOR_VISIT)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Customer_Entity_Type"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_DOCTOR_VISIT) ADD Customer_Entity_Type TEXT"
            try db.execute(createTableString)
        }
       
        isEntityTypeRequired = true
        
    }
    
    
    
    
    var isHourlyReportVisitRequired: Bool = false
    
    migrator.registerMigration(DatabaseMigrationString.HOURLYREPORTVISIT.rawValue) { db in
        var createTableString = ""
        var rows: [Row] = []
        
        
       createTableString = "CREATE TABLE IF NOT EXISTS \(Hourly_Report_Visit) (" + "Doctor_Code TEXT," + "Doctor_Name TEXT," + "Doctor_Region_Code TEXT," + "Speciality_Name TEXT," + "Category_Code TEXT," + "MDL_Number TEXT," + "DCR_Actual_Date TEXT," + "Doctor_Visit_Date_Time TEXT," + "Latitude TEXT," + "Longitude TEXT," + "Modified_Entity INTEGER," + "Synced_DateTime TEXT," + "Customer_Entity_Type TEXT," + "Category_Name TEXT," + "Doctor_Region_Name TEXT" + ")"
        try db.execute(createTableString)
        
        
        isHourlyReportVisitRequired = true
    }
    
    
    
    var isHospitalNameRequied: Bool = false
    
    migrator.registerMigration(DatabaseMigrationString.HOSPITAL.rawValue) { db in
        var createTableString = ""
        var rows: [Row] = []
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_DCR_DOCTOR_VISIT)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "Hospital_Name"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_DOCTOR_VISIT) ADD Hospital_Name TEXT"
            try db.execute(createTableString)
        }
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_TP_DOCTOR)')")
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Hospital_Name"))
        {
            createTableString = "ALTER TABLE \(TRAN_TP_DOCTOR) ADD Hospital_Name TEXT"
            try db.execute(createTableString)
        }
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_TP_HEADER)')")
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Hospital_Name"))
        {
            createTableString = "ALTER TABLE \(TRAN_TP_HEADER) ADD Hospital_Name TEXT"
            try db.execute(createTableString)
        }
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_DCR_DOCTOR_VISIT_TRACKER)')")
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Hospital_Name"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_DOCTOR_VISIT_TRACKER) ADD Hospital_Name TEXT"
            try db.execute(createTableString)
        }
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(MST_ACCOMPANIST)')")
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Hospital_Name"))
        {
            createTableString = "ALTER TABLE \(MST_ACCOMPANIST) ADD Hospital_Name TEXT"
            try db.execute(createTableString)
        }
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_ASSET_ANALYTICS_DETAILS)')")
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Hospital_Name"))
        {
            createTableString = "ALTER TABLE \(TRAN_ASSET_ANALYTICS_DETAILS) ADD Hospital_Name TEXT"
            try db.execute(createTableString)
        }
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(Hourly_Report_Visit)')")
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Hospital_Name"))
        {
            createTableString = "ALTER TABLE \(Hourly_Report_Visit) ADD Hospital_Name TEXT"
            try db.execute(createTableString)
        }
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_DCR_ATTENDANCE_DOCTOR_VISIT)')")
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Hospital_Name"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_ATTENDANCE_DOCTOR_VISIT) ADD Hospital_Name TEXT"
            try db.execute(createTableString)
        }
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(MST_CUSTOMER_MASTER)')")
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "userCode"))
        {
            createTableString = "ALTER TABLE \(MST_CUSTOMER_MASTER) ADD userCode TEXT"
            try db.execute(createTableString)
        }
        
//        if (!checkIsColumnExist(rowList: rows, columnName: "Is_TP_Frozen"))
//        {
//            createTableString = "ALTER TABLE \(TRAN_DCR_DOCTOR_ACCOMPANIST) ADD Is_TP_Frozen INTEGER"
//            try db.execute(createTableString)
//        }
        
//        if (!checkIsColumnExist(rowList: rows, columnName: "Is_TP_Frozen"))
//        {
//            createTableString = "ALTER TABLE \(TRAN_DCR_CHEMIST_ACCOMPANIST) ADD Is_TP_Frozen INTEGER"
//            try db.execute(createTableString)
//        }
        
        
        
        isHospitalNameRequied = true
        
    }
    
    var isAddressRequired: Bool = false
    
    migrator.registerMigration(DatabaseMigrationString.ADDRESS.rawValue) { db in
        var createTableString = ""
        
        createTableString = "DROP TABLE \(MST_CUSTOMER_ADDRESS)"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(MST_CUSTOMER_ADDRESS) (Address_Id INT,Customer_Code TEXT,Region_Code TEXT,Customer_Entity_Type TEXT,Address1 TEXT,Address2 TEXT,Local_Area TEXT,City TEXT,State TEXT,Pin_Code TEXT,Hospital_Name TEXT,Hospital_Classification TEXT,Phone_Number TEXT,Email_Id TEXT,Latitude DOUBLE,Longitude DOUBLE,Is_Synced INTEGER,Update_Page_Source TEXT,Customer_Code_Global TEXT,Region_Code_Global TEXT,Updated_By TEXT)"
        try db.execute(createTableString)
        
        isAddressRequired = true
        
    }
    
    
    var isAttachemntRequired: Bool = false
    
    migrator.registerMigration(DatabaseMigrationString.ATTACHMENT.rawValue) { db in
        var createTableString = ""
        var rows: [Row] = []
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_DCR_LEAVE_ATTACHMENT) (" + "Attachment_Id INTEGER PRIMARY KEY AUTOINCREMENT," + "From_Date TEXT," + "To_Date TEXT," + "LEAVE_TYPE_CODE TEXT," + "Leave_Status TEXT," + "Attachment_Size TEXT," + "Blob_Url TEXT," + "Uploaded_File_Name TEXT," + "DCR_Actual_Date TEXT," + "Document_Url TEXT," + "Number_Of_Days TEXT," + "Is_Success INTEGER," + "IsFile_Downloaded INTEGER" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(Notes_Attachment) (AttachmentName TEXT)"
        try db.execute(createTableString)
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_DCR_DOCTOR_VISIT)')")
        }
        // punch in
        if (!checkIsColumnExist(rowList: rows, columnName: "Punch_Start_Time"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_DOCTOR_VISIT) ADD Punch_Start_Time TEXT"
            try db.execute(createTableString)
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Punch_End_Time"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_DOCTOR_VISIT) ADD Punch_End_Time TEXT"
            try db.execute(createTableString)
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Punch_Offset"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_DOCTOR_VISIT) ADD Punch_Offset TEXT"
            try db.execute(createTableString)
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Punch_TimeZone"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_DOCTOR_VISIT) ADD Punch_TimeZone TEXT"
            try db.execute(createTableString)
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Punch_UTC_DateTime"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_DOCTOR_VISIT) ADD Punch_UTC_DateTime TEXT"
            try db.execute(createTableString)
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Punch_Status"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_DOCTOR_VISIT) ADD Punch_Status INTEGER"
            try db.execute(createTableString)
        }
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_ASSET_ANALYTICS_DETAILS)')")
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Punch_Start_Time"))
        {
            createTableString = "ALTER TABLE \(TRAN_ASSET_ANALYTICS_DETAILS) ADD Punch_Start_Time TEXT"
            try db.execute(createTableString)
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Punch_End_Time"))
        {
            createTableString = "ALTER TABLE \(TRAN_ASSET_ANALYTICS_DETAILS) ADD Punch_End_Time TEXT"
            try db.execute(createTableString)
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Punch_Offset"))
        {
            createTableString = "ALTER TABLE \(TRAN_ASSET_ANALYTICS_DETAILS) ADD Punch_Offset TEXT"
            try db.execute(createTableString)
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Punch_TimeZone"))
        {
            createTableString = "ALTER TABLE \(TRAN_ASSET_ANALYTICS_DETAILS) ADD Punch_TimeZone TEXT"
            try db.execute(createTableString)
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Punch_UTC_DateTime"))
        {
            createTableString = "ALTER TABLE \(TRAN_ASSET_ANALYTICS_DETAILS) ADD Punch_UTC_DateTime TEXT"
            try db.execute(createTableString)
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Punch_Status"))
        {
            createTableString = "ALTER TABLE \(TRAN_ASSET_ANALYTICS_DETAILS) ADD Punch_Status INTEGER"
            try db.execute(createTableString)
        }

        isAttachemntRequired = true
        
    }
    
    var isHospitalInfoRequired: Bool = false
    
    migrator.registerMigration(DatabaseMigrationString.ACCOUNTNUMBER.rawValue) { db in
        var createTableString = ""
        var rows: [Row] = []
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_CUSTOMER_HOSPITAL_INFO) (" + "Region_Code TEXT," + "Customer_Code TEXT," + "Hospital_Name TEXT," + "Hospital_Address1 TEXT," + "Hospital_Address2 TEXT," + "Hospital_Local_Area TEXT," + "Hospital_City TEXT," + "Hospital_State TEXT," + "Hospital_Latitude TEXT," + "Hospital_Longitude TEXT," +  "Hospital_Pincode TEXT," +  "Mapping_Status INTEGER," +  "Hospital_Classification TEXT," +  "Hospital_Account_Number TEXT" + ")"
        try db.execute(createTableString)
        
//        try dbPool.read { db in
//            rows = try Row.fetchAll(db, "PRAGMA table_info('\(MST_CUSTOMER_MASTER)')")
//        }
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(MST_CUSTOMER_MASTER)')")
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Hospital_Account_Number"))
        {
            createTableString = "ALTER TABLE \(MST_CUSTOMER_MASTER) ADD Hospital_Account_Number TEXT"
            try db.execute(createTableString)
        }
        
        
        
//        if (!checkIsColumnExist(rowList: rows, columnName: "Hospital_Account_Number"))
//        {
//            createTableString = "ALTER TABLE \(TRAN_DCR_DOCTOR_VISIT) ADD Hospital_Account_Number TEXT"
//            try db.execute(createTableString)
//        }
//
//        if (!checkIsColumnExist(rowList: rows, columnName: "Hospital_Account_Number"))
//        {
//            createTableString = "ALTER TABLE \(TRAN_TP_DOCTOR) ADD Hospital_Account_Number TEXT"
//            try db.execute(createTableString)
//        }
//
//        if (!checkIsColumnExist(rowList: rows, columnName: "Hospital_Account_Number"))
//        {
//            createTableString = "ALTER TABLE \(TRAN_TP_HEADER) ADD Hospital_Account_Number TEXT"
//            try db.execute(createTableString)
//        }
//
//        if (!checkIsColumnExist(rowList: rows, columnName: "Hospital_Account_Number"))
//        {
//            createTableString = "ALTER TABLE \(TRAN_DCR_DOCTOR_VISIT_TRACKER) ADD Hospital_Account_Number TEXT"
//            try db.execute(createTableString)
//        }
//
//        if (!checkIsColumnExist(rowList: rows, columnName: "Hospital_Account_Number"))
//        {
//            createTableString = "ALTER TABLE \(MST_ACCOMPANIST) ADD Hospital_Account_Number TEXT"
//            try db.execute(createTableString)
//        }
//
//        if (!checkIsColumnExist(rowList: rows, columnName: "Hospital_Account_Number"))
//        {
//            createTableString = "ALTER TABLE \(TRAN_ASSET_ANALYTICS_DETAILS) ADD Hospital_Account_Number TEXT"
//            try db.execute(createTableString)
//        }
//
//        if (!checkIsColumnExist(rowList: rows, columnName: "Hospital_Account_Number"))
//        {
//            createTableString = "ALTER TABLE \(Hourly_Report_Visit) ADD Hospital_Account_Number TEXT"
//            try db.execute(createTableString)
//        }
//
//        if (!checkIsColumnExist(rowList: rows, columnName: "Hospital_Account_Number"))
//        {
//            createTableString = "ALTER TABLE \(TRAN_DCR_ATTENDANCE_DOCTOR_VISIT) ADD Hospital_Account_Number TEXT"
//            try db.execute(createTableString)
//        }
//
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(MST_CUSTOMER_MASTER_EDIT)')")
        }
        if (!checkIsColumnExist(rowList: rows, columnName: "Hospital_Account_Number"))
        {
            createTableString = "ALTER TABLE \(MST_CUSTOMER_MASTER_EDIT) ADD Hospital_Account_Number TEXT"
            try db.execute(createTableString)
        }
        
//        if (!checkIsColumnExist(rowList: rows, columnName: "Hospital_Account_Number"))
//        {
//            createTableString = "ALTER TABLE \(MST_CUSOMTER_MASTER_PERSONAL_INFO_EDIT) ADD Hospital_Account_Number TEXT"
//            try db.execute(createTableString)
//        }
        
        
        isHospitalInfoRequired = true
        
    }
    
    var isTPAttachemntRequired: Bool = false

    migrator.registerMigration(DatabaseMigrationString.TPATTACHMENT.rawValue) { db in
        var createTableString = ""
         var rows: [Row] = []
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_TP_DOCTOR_VISIT_ATTACHMENT) (" + "TP_Id INTEGER," + "Check_Sum_Id INTEGER," + "TP_Doctor_Id INTEGER," + "Uploaded_File_Name TEXT," + "Blob_URL TEXT," + "Doctor_Code TEXT," + "Doctor_Region_Code TEXT," + "Is_Success INTEGER," + "TP_Entry_Id INTEGER," + "TP_Doctor_Attachment_Id INTEGER PRIMARY KEY AUTOINCREMENT" + ")"
        try db.execute(createTableString)
        
        createTableString = "CREATE TABLE IF NOT EXISTS \(TRAN_PROSPECTING) (" + "Flag TEXT," + "Prospect_Id INTEGER," + "Company_Code TEXT," + "Company_Id INTEGER," + "Account_Name TEXT," + "Contact_Name TEXT," + "Title TEXT," + "Address TEXT," + "City TEXT," + "State TEXT," + "Phone_No TEXT," + "Email TEXT," + "Prospect_Status TEXT," + "DCR_Date TEXT," + "Created_Region_Code TEXT," + "Created_By TEXT," + "Created_DateTime TEXT," + "Zip INTEGER" + ")"
        try db.execute(createTableString)
        

 
       try dbPool.read { db in
                 rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_TP_HEADER)')")
             }
             
             if (!checkIsColumnExist(rowList: rows, columnName: "TP_Type"))
             {
                 createTableString = "ALTER TABLE \(TRAN_TP_HEADER) ADD TP_Type TEXT"
                 try db.execute(createTableString)
             }
             
             try dbPool.read { db in
                  rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_TP_DOCTOR)')")
             }
                    
             if (!checkIsColumnExist(rowList: rows, columnName: "Call_Objective_Id"))
             {
                 createTableString = "ALTER TABLE \(TRAN_TP_DOCTOR) ADD Call_Objective_Id INTEGER"
                 try db.execute(createTableString)
             }
             
             if (!checkIsColumnExist(rowList: rows, columnName: "Call_Objective_Name"))
             {
                 createTableString = "ALTER TABLE \(TRAN_TP_DOCTOR) ADD Call_Objective_Name TEXT"
                 try db.execute(createTableString)
             }
             
        isTPAttachemntRequired = true
        
    }
    var isDVR_Subtype: Bool = false

    migrator.registerMigration(DatabaseMigrationString.DVR_SUBTYPE.rawValue) { db in
        var createTableString = ""
         var rows: [Row] = []
        
        try dbPool.read { db in
            rows = try Row.fetchAll(db, "PRAGMA table_info('\(TRAN_DCR_HEADER)')")
        }
        
        if (!checkIsColumnExist(rowList: rows, columnName: "DCR_Type"))
        {
            createTableString = "ALTER TABLE \(TRAN_DCR_HEADER) ADD DCR_Type TEXT"
            try db.execute(createTableString)
        }
        
        isDVR_Subtype = true
    }
    
    
    
    try migrator.migrate(dbPool)
    
    DatabaseMigration.sharedInstance.doV1Migration()
    
    if (isMigrationV2Required)
    {
        BL_Version_Upgrade.sharedInstance.insertVersionUpgradeInfo(versionNumber: DatabaseMigrationString.version2.rawValue, isVersionUpdateCompleted: 0)
    }
    
    if (isMigrationeDetailingRequired)
    {
        BL_Version_Upgrade.sharedInstance.insertVersionUpgradeInfo(versionNumber: DatabaseMigrationString.eDetailingVersion.rawValue, isVersionUpdateCompleted: 0)
    }
    
    if (isMigrationeDetailing2Required)
    {
        BL_Version_Upgrade.sharedInstance.insertVersionUpgradeInfo(versionNumber: DatabaseMigrationString.eDetailingVersion2.rawValue, isVersionUpdateCompleted: 0)
    }
    
    if (isMigrationeDetailing3Required)
    {
        
    }
    
    if (isMigrationTPVersionRequired)
    {
        BL_Version_Upgrade.sharedInstance.insertVersionUpgradeInfo(versionNumber: DatabaseMigrationString.TPVersion.rawValue, isVersionUpdateCompleted: 0)
    }
    
    if (isMigrationFDCPilot)
    {
        BL_Version_Upgrade.sharedInstance.insertVersionUpgradeInfo(versionNumber: DatabaseMigrationString.FDC_Pilot.rawValue, isVersionUpdateCompleted: 0)
    }
    
    if (isMigrationChemistDay)
    {
        BL_Version_Upgrade.sharedInstance.insertVersionUpgradeInfo(versionNumber: DatabaseMigrationString.ChemistDay.rawValue, isVersionUpdateCompleted: 0)
    }
    
    if (isMigrationAlertBuild)
    {
        BL_Version_Upgrade.sharedInstance.insertVersionUpgradeInfo(versionNumber: DatabaseMigrationString.AlertBuild.rawValue, isVersionUpdateCompleted: 0)
    }
    
    if (isPaswordPolicyMigrationRequired)
    {
        BL_Version_Upgrade.sharedInstance.insertVersionUpgradeInfo(versionNumber: DatabaseMigrationString.PasswordPolicy.rawValue, isVersionUpdateCompleted: 0)
    }
    
    if (isDoctorPOBMigratonRequired)
    {
        BL_Version_Upgrade.sharedInstance.insertVersionUpgradeInfo(versionNumber: DatabaseMigrationString.DOCTORPOB.rawValue, isVersionUpdateCompleted: 0)
    }
    
    if (isDoctorInheritanceMigrationRequired)
    {
        BL_Version_Upgrade.sharedInstance.insertVersionUpgradeInfo(versionNumber: DatabaseMigrationString.DOCTORINHERITANCE.rawValue, isVersionUpdateCompleted: 0)
    }
    
    if (isICEMigrationRequired)
    {
        BL_Version_Upgrade.sharedInstance.insertVersionUpgradeInfo(versionNumber: DatabaseMigrationString.ICE.rawValue, isVersionUpdateCompleted: 0)
    }
    if (isHourlyReportChangeMigrationRequired)
    {
        BL_Version_Upgrade.sharedInstance.insertVersionUpgradeInfo(versionNumber: DatabaseMigrationString.HOURLY_REPORT_CHANGE.rawValue, isVersionUpdateCompleted: 0)
    }
    if(isSampleBatchMigrationRequired)
    {
        BL_Version_Upgrade.sharedInstance.insertVersionUpgradeInfo(versionNumber: DatabaseMigrationString.SAMPLEBATCH.rawValue, isVersionUpdateCompleted: 0)
    }
    if(isInwardBatchMigrationRequired)
    {
        BL_Version_Upgrade.sharedInstance.insertVersionUpgradeInfo(versionNumber: DatabaseMigrationString.INWARDBATCH.rawValue, isVersionUpdateCompleted: 0)
    }
    if(isAttendanceActivityMigrationRequired)
    {
        BL_Version_Upgrade.sharedInstance.insertVersionUpgradeInfo(versionNumber: DatabaseMigrationString.ATTENDANCEACTIVITY.rawValue, isVersionUpdateCompleted: 0)
    }
    if isAccompanistChangeMigrationRequired
    {
        BL_Version_Upgrade.sharedInstance.insertVersionUpgradeInfo(versionNumber: DatabaseMigrationString.ACCOMPANISTCHANGE.rawValue, isVersionUpdateCompleted: 0)
    }
    if isMCInDoctorVisitMigrationRequired
    {
        BL_Version_Upgrade.sharedInstance.insertVersionUpgradeInfo(versionNumber: DatabaseMigrationString.MCINDOCTORVISIT.rawValue, isVersionUpdateCompleted: 0)
    }
    
    if isBusinessPotentialRequired
    {
        BL_Version_Upgrade.sharedInstance.insertVersionUpgradeInfo(versionNumber: DatabaseMigrationString.BUSSINESSPOTENTIAL.rawValue, isVersionUpdateCompleted: 0)
    }
    
    if isTravelTrackingReportRequired
    {
        BL_Version_Upgrade.sharedInstance.insertVersionUpgradeInfo(versionNumber: DatabaseMigrationString.TRAVELTRACKINGREPRT.rawValue, isVersionUpdateCompleted: 0)
    }
    
    if isMenuRequired
    {
        BL_Version_Upgrade.sharedInstance.insertVersionUpgradeInfo(versionNumber: DatabaseMigrationString.MENUCUSTOMIZATION.rawValue, isVersionUpdateCompleted: 0)
    }
    
    if isLatLongRequired
    {
        BL_Version_Upgrade.sharedInstance.insertVersionUpgradeInfo(versionNumber: DatabaseMigrationString.STOCKIST.rawValue, isVersionUpdateCompleted: 0)
    }
    
    
    
    if isEntityTypeRequired
    {
        BL_Version_Upgrade.sharedInstance.insertVersionUpgradeInfo(versionNumber: DatabaseMigrationString.ENTITYTYPE.rawValue, isVersionUpdateCompleted: 0)
    }
    
    if isHourlyReportVisitRequired
    {
        BL_Version_Upgrade.sharedInstance.insertVersionUpgradeInfo(versionNumber: DatabaseMigrationString.HOURLYREPORTVISIT.rawValue, isVersionUpdateCompleted: 0)
    }
    
    if isHospitalNameRequied
    {
        BL_Version_Upgrade.sharedInstance.insertVersionUpgradeInfo(versionNumber: DatabaseMigrationString.HOSPITAL.rawValue, isVersionUpdateCompleted: 0)
    }
    
    if isAddressRequired
    {
        BL_Version_Upgrade.sharedInstance.insertVersionUpgradeInfo(versionNumber: DatabaseMigrationString.ADDRESS.rawValue, isVersionUpdateCompleted: 0)
    }
    
    if isAttachemntRequired
    {
        BL_Version_Upgrade.sharedInstance.insertVersionUpgradeInfo(versionNumber: DatabaseMigrationString.ATTACHMENT.rawValue, isVersionUpdateCompleted: 0)
    }
    
    if isHospitalInfoRequired
    {
        BL_Version_Upgrade.sharedInstance.insertVersionUpgradeInfo(versionNumber: DatabaseMigrationString.ACCOUNTNUMBER.rawValue, isVersionUpdateCompleted: 0)
    }

    if isTPAttachemntRequired
    {
        BL_Version_Upgrade.sharedInstance.insertVersionUpgradeInfo(versionNumber: DatabaseMigrationString.TPATTACHMENT.rawValue, isVersionUpdateCompleted: 0)
    }
    
    if isDVR_Subtype
    {
         BL_Version_Upgrade.sharedInstance.insertVersionUpgradeInfo(versionNumber: DatabaseMigrationString.DVR_SUBTYPE.rawValue, isVersionUpdateCompleted: 0)
    }
    
}

func executeQuery(query: String)
{
    try? dbPool.write({ db in
        try db.execute(query)
    })
}

func fetchDataFromTable(selectQuery: String) -> [Row]
{
    var rowArray : [Row] = []
    
    try? dbPool.read{db  in
        rowArray = try Row.fetchAll(db, selectQuery)
    }
    
    return rowArray
}

func checkIsColumnExist(rowList: [Row], columnName: String) -> Bool
{
    var isFound = false
    
    for row in rowList
    {
        let name = row["name"] as! String
        
        if (name == columnName)
        {
            isFound = true
        }
    }
    
    return isFound
}



