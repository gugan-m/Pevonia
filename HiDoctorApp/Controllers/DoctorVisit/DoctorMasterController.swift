//
//  DoctorMasterController.swift
//  HiDoctorApp
//
//  Created by Vijay on 07/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class DoctorMasterController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, GeoFencingSkipDelegate, customerAddressSelecitonDelegate
{
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var emptyStateImage: UIImageView!
    @IBOutlet weak var emptyStatelabel: UILabel!
    @IBOutlet weak var addBtn: UIBarButtonItem!
    @IBOutlet weak var searchBarHeightConst: NSLayoutConstraint!
    
    @IBOutlet var segmentedControlHeight: NSLayoutConstraint!
    
    @IBOutlet var segmentedControlTopSpace: NSLayoutConstraint!
    var selectedIndex : Int!
    var constrainedWidth : CGFloat!
    var cellIdentifier : String!
    var regionCode : String!
    var regionName : String!
    var suffixConfigVal : [String]!
    var doctorMasterList : [CustomerMasterModel] = []
    var currentList : [CustomerMasterModel] = []
    var searchList : [CustomerMasterModel] = []
    var isFromRCPA: Bool = false
    var isFromAttendance:Bool = false
    
    var sectionTitle : [String] = []
    var userSortList : [CustomerSortedModel] = []
    var isAscending : Bool = true
    var userCurrentList : [CustomerSortedModel] = []
    var searchedWrappedList : [CustomerMasterModel] = []
    var dcrID: Int = 0
    var currentList1 : [CustomerSortedModel] = []
    var showOrganisation: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        showOrganisation = (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.SHOW_ORGANISATION_IN_CUSTOMER))
        
        
        self.navigationItem.title = "\(appDoctorPlural) List"
        self.segmentedControlHeight.constant = 28
        self.segmentedControlTopSpace.constant = 10
        self.segmentedControl.isHidden = false
        self.searchBar.searchBarStyle = .default
        if isFromAttendance
        {
            self.segmentedControlHeight.constant = 0
            self.segmentedControlTopSpace.constant = 0
            self.segmentedControl.isHidden = true
            self.searchBar.searchBarStyle = .minimal
        }
        addCustomBackButtonToNavigationBar()
        setDefaults()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        BL_SampleProducts.sharedInstance.selectedAttendanceDoctor = nil
    }
    
    func setDefaults()
    {
        constrainedWidth = SCREEN_WIDTH - 40.0
        cellIdentifier = "doctorMasterCell"
        
        let checkRegionCode = getUserModelObj()
        if checkRegionCode?.Region_Code == regionCode
        {
            let tpData = BL_DCR_Doctor_Visit.sharedInstance.getTPDoctorsForSelectedDate()!
            let cpData = BL_DCR_Doctor_Visit.sharedInstance.getCPDoctorsForSelectedDate()!
            
            if tpData.count > 0
            {
                if BL_DCR_Doctor_Visit.sharedInstance.cpTab == true
                {
                    selectedIndex = 2
                }
                else if BL_DCR_Doctor_Visit.sharedInstance.tpTab == true
                {
                    selectedIndex = 1
                }
            }
            else if cpData.count > 0
            {
                selectedIndex = 2
            }
            else
            {
                selectedIndex = 0
            }
        }
        else
        {
            selectedIndex = 0
        }
        
        suffixConfigVal = BL_DCR_Doctor_Visit.sharedInstance.getDoctorSuffixColumnName()
        
        segmentedControl.selectedSegmentIndex = selectedIndex
        setCurrentTableList()
        isAddbtnHidden(index: selectedIndex)
    }
    
    func setCurrentTableList()
    {
        let checkRegionCode = getUserModelObj()
        if selectedIndex == 0
        {
            doctorMasterList = BL_DCR_Doctor_Visit.sharedInstance.getDoctorMasterList(regionCode: regionCode)!
            // doctorMasterList = BL_DCR_Doctor_Visit.sharedInstance.getDoctorMasterListOrderBY(regionCode: regionCode,orderBy : "Customer_Name")!
        }
        else if selectedIndex == 1
        {
            if checkRegionCode?.Region_Code == regionCode
            {
                if(isFromAttendance)
                {
                    doctorMasterList = BL_DCR_Doctor_Visit.sharedInstance.getDoctorMasterList(regionCode: regionCode)!
                }
                else
                {
                    doctorMasterList = BL_DCR_Doctor_Visit.sharedInstance.getTPDoctorsForSelectedDate()!
                }
                
            }
            else
            {
                doctorMasterList = []
            }
        }
        else if selectedIndex == 2
        {
            if checkRegionCode?.Region_Code == regionCode
            {
                doctorMasterList = BL_DCR_Doctor_Visit.sharedInstance.getCPDoctorsForSelectedDate()!
            }
            else
            {
                doctorMasterList = []
            }
        }
        
        if (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.SHOW_ORGANISATION_IN_CUSTOMER) == PrivilegeValues.YES.rawValue)
        {
            getHospitalNameSortedList(userWrapperList: doctorMasterList)
        }
        else
        {
            getNameSortedList(userWrapperList: doctorMasterList)
        }
        
        changeCurrentArray(list: userSortList, type: 0)
    }
    
    private func getHospitalNameSortedList(userWrapperList : [CustomerMasterModel])
    {
        
        var validDoctorList : [CustomerMasterModel] = []
        var invalidDoctorList : [CustomerMasterModel] = []
        
        for model in userWrapperList
        {
            let userObj = model as CustomerMasterModel
            let strHospitalName = checkNullAndNilValueForString(stringData: userObj.Hospital_Name) as? String
            if strHospitalName != ""
            {
                validDoctorList.append(userObj)
            }
            else
            {
                invalidDoctorList.append(userObj)
            }
        }
        
        userSortList.removeAll()
        sectionTitle.removeAll()
        
        if validDoctorList.count > 0
        {
            getOtherSortedList(userWrapperList: validDoctorList)
        }
        
        if invalidDoctorList.count > 0
        {
            let userObj = CustomerSortedModel()
            userObj.sectionKey = others
            userObj.userList = invalidDoctorList
            
            sectionTitle.append(others)
            userSortList.append(userObj)
        }
    }
    
    private func getNameSortedList(userWrapperList : [CustomerMasterModel])
    {
        let detailDict : NSMutableDictionary = NSMutableDictionary()
        for obj in userWrapperList
        {
            let capitalisedStr = condenseWhitespace(stringValue: obj.Customer_Name).capitalized as NSString
            let firstCharacter = capitalisedStr.substring(to: 1) as NSString
            var nameList = detailDict.object(forKey: firstCharacter) as? NSMutableArray
            if nameList == nil
            {
                nameList = NSMutableArray()
                detailDict.setObject(nameList!, forKey: firstCharacter)
            }
            nameList?.add(obj)
        }
        
        for eachCharacter in detailDict.allKeys as! [NSString]
            
        {
            let arrayOfCharacter = detailDict.object(forKey: eachCharacter) as! NSArray
            let sortedArray = (arrayOfCharacter as NSArray).sorted { (($0 as! CustomerMasterModel).Customer_Name).localizedCaseInsensitiveCompare((($1 as! CustomerMasterModel).Customer_Name) as String) == ComparisonResult.orderedAscending }
            detailDict.setObject(sortedArray, forKey: eachCharacter)
        }
        
        let unsortedSection:[String] = detailDict.allKeys as! [String]
        
        if isAscending == true
        {
            self.sectionTitle = unsortedSection.sorted(by: { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending })
        }
        else
        {
            self.sectionTitle = unsortedSection.sorted(by: { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedDescending })
        }
        
        userSortList.removeAll()
        
        for char in sectionTitle
        {
            let userObj  = CustomerSortedModel()
            userObj.sectionKey = char
            userObj.userList = detailDict.object(forKey: char) as! [CustomerMasterModel]
            userSortList.append(userObj)
        }
    }
    
    func condenseWhitespace(stringValue: String) -> String
    {
        return stringValue.components(separatedBy: CharacterSet.whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
    
    private func getOtherSortedList(userWrapperList : [CustomerMasterModel])
    {
        let detailDict : NSMutableDictionary = NSMutableDictionary()
        
        for obj in userWrapperList
        {
            var capitalisedStr : NSString!
            
            if obj.Hospital_Account_Number != ""
            {
                var accountNumber = "(" + ((condenseWhitespace(stringValue: obj.Hospital_Account_Number!).capitalized as NSString) as String) + ")"
                capitalisedStr = ((condenseWhitespace(stringValue: obj.Hospital_Name!).capitalized as NSString) as String) + "-" + accountNumber as NSString
            }
            else
            {
                capitalisedStr = condenseWhitespace(stringValue: obj.Hospital_Name!).capitalized as NSString
            }
            
            var nameList = detailDict.object(forKey: capitalisedStr) as? NSMutableArray
            if nameList == nil
            {
                nameList = NSMutableArray()
                detailDict.setObject(nameList!, forKey: capitalisedStr)
            }
            nameList?.add(obj)
        }
        
        for eachCharacter in detailDict.allKeys as! [NSString]
        {
            let arrayOfCharacter = detailDict.object(forKey: eachCharacter) as! NSArray
            let sortedArray = (arrayOfCharacter as NSArray).sorted { (($0 as! CustomerMasterModel).Customer_Name).localizedCaseInsensitiveCompare((($1 as! CustomerMasterModel).Customer_Name) as String) == ComparisonResult.orderedAscending }
            detailDict.setObject(sortedArray, forKey: eachCharacter)
        }
        
        let unsortedSection:[String] = detailDict.allKeys as! [String]
        
        if isAscending == true
        {
            self.sectionTitle = unsortedSection.sorted(by: { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending })
        }
        else
        {
            self.sectionTitle = unsortedSection.sorted(by: { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedDescending })
        }
        
        userSortList.removeAll()
        
        for char in sectionTitle
        {
            let userObj  = CustomerSortedModel()
            userObj.sectionKey = char
            userObj.userList = detailDict.object(forKey: char) as! [CustomerMasterModel]
            userSortList.append(userObj)
        }
    }
    
    func isAddbtnHidden(index: Int)
    {
        if(isFromAttendance)
        {
            if BL_DCR_Doctor_Visit.sharedInstance.doctorAttendanceMasterAddBtnHidden()
            {
                addBtn.isEnabled = false
                addBtn.tintColor = UIColor.clear
            }
            else
            {
                addBtn.isEnabled = true
                addBtn.tintColor = nil
            }
        }
        else
        {
            if index == 0
            {
                if BL_DCR_Doctor_Visit.sharedInstance.doctorMasterAddBtnHidden()
                {
                    addBtn.isEnabled = false
                    addBtn.tintColor = UIColor.clear
                }
                else
                {
                    addBtn.isEnabled = true
                    addBtn.tintColor = nil
                }
            }
            else if index == 1 || index == 2
            {
                addBtn.isEnabled = false
                addBtn.tintColor = UIColor.clear
            }
        }
    }
    
    
    
    // MARK: - Tableview delegates & datasources
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if sectionTitle.count > 0
        {
            return sectionTitle.count
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if sectionTitle.count > 0
        {
            return sectionTitle[section]
        }
        else
        {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if sectionTitle.count > 0
        {
            return 34
        }
        else
        {
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        header.contentView.backgroundColor = UIColor(red: 20/250, green: 126/250, blue: 251/250, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int
    {
        if selectedIndex == 0
        {
            return sectionTitle.index(of: title)!
        }
        else
        {
            return 0
        }
    }
    
    //    func sectionIndexTitles(for tableView: UITableView) -> [String]?
    //    {
    //        if selectedIndex == 0
    //        {
    //            return sectionTitle
    //        }
    //        else
    //        {
    //            return []
    //        }
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if userCurrentList.count > 0
        {
            return userCurrentList[section].userList.count
        }
        else
        {
            return 0
        }
    }
    
    
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    //    {
    //        return currentList.count
    //    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        var heightVal : CGFloat = 60.0
        var attString3 = NSMutableAttributedString()
        
        let model = userCurrentList[indexPath.section].userList[indexPath.row]
        let nameTextSize = getTextSize(text: model.Customer_Name, fontName: fontSemiBold, fontSize: 15.0, constrainedWidth: constrainedWidth)
        //        var detailText : String = ""
        //
        //        detailText = String(format: "%@ | %@ | %@ | %@", model.MDL_Number, model.Speciality_Name, model.Category_Name!, model.Region_Name)
        //
        //        if suffixConfigVal.contains(ConfigValues.SUR_NAME.rawValue) && model.Sur_Name != ""
        //        {
        //            detailText = String(format: "%@ | %@", detailText, model.Sur_Name!)
        //        }
        //
        //        if suffixConfigVal.contains(ConfigValues.LOCAL_AREA.rawValue) && model.Local_Area != ""
        //        {
        //            detailText = String(format: "%@ | %@", detailText, model.Local_Area!)
        //        }
        if (showOrganisation == PrivilegeValues.YES.rawValue)
        {
            if model.Hospital_Account_Number != "" || model.Hospital_Name != ""
            {
                var hospitalDetails = String(format: "%@ | %@", model.Hospital_Name!, model.Hospital_Account_Number!)
                
                var detailText : String = ""
                
                detailText = String(format: "%@ | %@ | %@ | %@| %@","\n", ccmNumberPrefix + model.MDL_Number, model.Speciality_Name, model.Category_Name!, model.Region_Name)
                
                if suffixConfigVal.contains(ConfigValues.SUR_NAME.rawValue) && model.Sur_Name != ""
                {
                    detailText = String(format: "%@ | %@", detailText, model.Sur_Name!)
                }
                
                if suffixConfigVal.contains(ConfigValues.LOCAL_AREA.rawValue) && model.Local_Area != ""
                {
                    detailText = String(format: "%@ | %@", detailText, model.Local_Area!)
                }
                
                let attString1 = NSMutableAttributedString.init(string: detailText)
                let blueFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0/250, green: 191/250, blue: 255/250, alpha: 1.0), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0)]
                let attString2 = NSMutableAttributedString(string: hospitalDetails, attributes: blueFontAttributes)
                
                attString3.append(attString2)
                attString3.append(attString1)
            }
                
            else
            {
                //  var hospitalDetails = String(format: "%@", model.Hospital_Name!)
                
                var detailText : String = ""
                
                detailText = String(format: "%@ | %@ | %@ | %@| %@","\n", ccmNumberPrefix + model.MDL_Number, model.Speciality_Name, model.Category_Name!, model.Region_Name)
                
                if suffixConfigVal.contains(ConfigValues.SUR_NAME.rawValue) && model.Sur_Name != ""
                {
                    detailText = String(format: "%@ | %@", detailText, model.Sur_Name!)
                }
                
                if suffixConfigVal.contains(ConfigValues.LOCAL_AREA.rawValue) && model.Local_Area != ""
                {
                    detailText = String(format: "%@ | %@", detailText, model.Local_Area!)
                }
                
                let attString1 = NSMutableAttributedString.init(string: detailText)
                let blueFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 135/250, green: 206/250, blue: 250/250, alpha: 1.0), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0)]
                //            let attString2 = NSMutableAttributedString(string: hospitalDetails, attributes: blueFontAttributes)
                //
                //            attString3.append(attString2)
                attString3.append(attString1)
            }
        }
        else
        {
            var detailText : String = ""
            
            detailText = String(format: "%@ | %@ | %@ | %@| %@","\n", ccmNumberPrefix + model.MDL_Number, model.Speciality_Name, model.Category_Name!, model.Region_Name)
            
            if suffixConfigVal.contains(ConfigValues.SUR_NAME.rawValue) && model.Sur_Name != ""
            {
                detailText = String(format: "%@ | %@", detailText, model.Sur_Name!)
            }
            
            if suffixConfigVal.contains(ConfigValues.LOCAL_AREA.rawValue) && model.Local_Area != ""
            {
                detailText = String(format: "%@ | %@", detailText, model.Local_Area!)
            }
            
            let attString1 = NSMutableAttributedString.init(string: detailText)
            let blueFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 135/250, green: 206/250, blue: 250/250, alpha: 1.0), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0)]
            //            let attString2 = NSMutableAttributedString(string: hospitalDetails, attributes: blueFontAttributes)
            //
            //            attString3.append(attString2)
            attString3.append(attString1)
            
        }
        
        //        let detailTextSize = getTextSize(text: detailText, fontName: fontRegular, fontSize: 14.0, constrainedWidth: constrainedWidth)
        let detailTextSize = getAttributedTextSize(text: attString3, fontName: fontRegular, fontSize: 14.0, constrainedWidth: constrainedWidth)
        heightVal = heightVal + nameTextSize.height + detailTextSize.height
        
        return heightVal
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let model = userCurrentList[indexPath.section].userList[indexPath.row]
        let cell: DoctorMasterCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! DoctorMasterCell
        var doctorCheck = 0
        var attString3 = NSMutableAttributedString()
        if isFromAttendance
        {
            doctorCheck = DBHelper.sharedInstance.checkAttendenceDoctorVisitforDoctorId(doctorCode: model.Customer_Code, regionCode: model.Region_Code)
        }
        else if !isFromRCPA
        {
            doctorCheck = DBHelper.sharedInstance.checkDoctorVisitforDoctorId(doctorCode: model.Customer_Code, regionCode: model.Region_Code)
        }
        else
        {
            doctorCheck = DBHelper.sharedInstance.checkDoctorVisitforDoctorIdForChemistDay(doctorCode: model.Customer_Code, regionCode: model.Region_Code)
        }
        
        if doctorCheck > 0
        {
            cell.wrapperView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        }
        else
        {
            cell.wrapperView.backgroundColor = UIColor.white
        }
        
        cell.doctorName.text = model.Customer_Name
        
        //        var detailText : String = ""
        //
        //        detailText = String(format: "%@ | %@ | %@ | %@", ccmNumberPrefix + model.MDL_Number, model.Speciality_Name, model.Category_Name!, model.Region_Name)
        //
        //        if suffixConfigVal.contains(ConfigValues.SUR_NAME.rawValue) && model.Sur_Name != ""
        //        {
        //            detailText = String(format: "%@ | %@", detailText, model.Sur_Name!)
        //        }
        //
        //        if suffixConfigVal.contains(ConfigValues.LOCAL_AREA.rawValue) && model.Local_Area != ""
        //        {
        //            detailText = String(format: "%@ | %@", detailText, model.Local_Area!)
        //        }
        
        if (showOrganisation == PrivilegeValues.YES.rawValue)
        {
            if model.Hospital_Account_Number != "" || model.Hospital_Name != ""
            {
                var hospitalDetails = String(format: "%@ | %@", model.Hospital_Name!, model.Hospital_Account_Number!)
                
                var detailText : String = ""
                
            //   detailText = String(format: "%@ | %@ | %@ | %@| %@","\n", ccmNumberPrefix + model.MDL_Number, model.Speciality_Name, model.Category_Name!, model.Region_Name)
                detailText = String(format: "%@%@ | %@ | %@","\n",model.Speciality_Name, model.Category_Name!, model.Region_Name)
                
                if suffixConfigVal.contains(ConfigValues.SUR_NAME.rawValue) && model.Sur_Name != ""
                {
                    detailText = String(format: "%@ | %@", detailText, model.Sur_Name!)
                }
                
                if suffixConfigVal.contains(ConfigValues.LOCAL_AREA.rawValue) && model.Local_Area != ""
                {
                    detailText = String(format: "%@ | %@", detailText, model.Local_Area!)
                }
                
                let attString1 = NSMutableAttributedString.init(string: detailText)
                let blueFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0/250, green: 191/250, blue: 255/250, alpha: 1.0), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0)]
                let attString2 = NSMutableAttributedString(string: hospitalDetails, attributes: blueFontAttributes)
                
                attString3.append(attString2)
                attString3.append(attString1)
            }
            else
            {
                //  var hospitalDetails = String(format: "%@", model.Hospital_Name!)
                
                var detailText : String = ""
                
               // detailText = String(format: "%@ | %@ | %@ | %@| %@","\n", ccmNumberPrefix + model.MDL_Number, model.Speciality_Name, model.Category_Name!, model.Region_Name)
               detailText = String(format: "%@%@ | %@ | %@","\n",model.Speciality_Name, model.Category_Name!, model.Region_Name)
                
                if suffixConfigVal.contains(ConfigValues.SUR_NAME.rawValue) && model.Sur_Name != ""
                {
                    detailText = String(format: "%@ | %@", detailText, model.Sur_Name!)
                }
                
                if suffixConfigVal.contains(ConfigValues.LOCAL_AREA.rawValue) && model.Local_Area != ""
                {
                    detailText = String(format: "%@ | %@", detailText, model.Local_Area!)
                }
                
                let attString1 = NSMutableAttributedString.init(string: detailText)
                let blueFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 135/250, green: 206/250, blue: 250/250, alpha: 1.0), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0)]
                //            let attString2 = NSMutableAttributedString(string: hospitalDetails, attributes: blueFontAttributes)
                //
                //            attString3.append(attString2)
                attString3.append(attString1)
            }
        }
        else
        {
            var detailText : String = ""
            
//            detailText = String(format: "%@ | %@ | %@ | %@| %@","\n", ccmNumberPrefix + model.MDL_Number, model.Speciality_Name, model.Category_Name!, model.Region_Name)
            detailText = String(format: "%@%@ | %@ | %@","\n",model.Speciality_Name, model.Category_Name!, model.Region_Name)
            
            if suffixConfigVal.contains(ConfigValues.SUR_NAME.rawValue) && model.Sur_Name != ""
            {
                detailText = String(format: "%@ | %@", detailText, model.Sur_Name!)
            }
            
            if suffixConfigVal.contains(ConfigValues.LOCAL_AREA.rawValue) && model.Local_Area != ""
            {
                detailText = String(format: "%@ | %@", detailText, model.Local_Area!)
            }
            
            let attString1 = NSMutableAttributedString.init(string: detailText)
            let blueFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 135/250, green: 206/250, blue: 250/250, alpha: 1.0), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0)]
            //            let attString2 = NSMutableAttributedString(string: hospitalDetails, attributes: blueFontAttributes)
            //
            //            attString3.append(attString2)
            attString3.append(attString1)
            
        }
        
        cell.doctorDetail.attributedText = attString3
        
        return cell
    }
    
    private func getCustomerLocations(customerCode: String, regionCode: String) -> [GeoLocationModel]
    {
        var lstCustomerLocations: [GeoLocationModel] = []
        let lstAddress = BL_Geo_Location.sharedInstance.getCustomerAddress(customerCode: customerCode, regionCode: regionCode, customerEntityType: DOCTOR)
        
        for objAddress in lstAddress
        {
            let objGeoLocationModel = GeoLocationModel()
            
            objGeoLocationModel.Latitude = objAddress.Latitude
            objGeoLocationModel.Longitude = objAddress.Longitude
            objGeoLocationModel.Address_Id = objAddress.Address_Id
            
            lstCustomerLocations.append(objGeoLocationModel)
        }
        
        return lstCustomerLocations
    }
    
    private func getDoctorLocations() ->[GeoLocationModel]
    {
        var lstDoctorLocations: [GeoLocationModel] = []
        
        let objLocation = GeoLocationModel() //SwaaS
        objLocation.Latitude = 0 //12.9165
        objLocation.Longitude = 0 //79.1325
        objLocation.Address_Id = 3489
        
        lstDoctorLocations.append(objLocation)
        
        //        objLocation = GeoLocationModel() // Pillar
        //        objLocation.Latitude = 13.0374
        //        objLocation.Longitude = 80.2123
        //
        //        lstDoctorLocations.append(objLocation)
        //
        //        objLocation = GeoLocationModel() // Alandur metro
        //        objLocation.Latitude = 13.0040
        //        objLocation.Longitude = 80.2015
        //
        //        lstDoctorLocations.append(objLocation)
        
        //13.067439, 80.237617 - Guindy metro
        
        return lstDoctorLocations
    }
    
    private func moveToDCRDoctorVisitStepper(indexPath: IndexPath, geoFencingSkipRemarks: String, currentLocation: GeoLocationModel)
    {
        let sb = UIStoryboard(name: doctorMasterSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: doctorVisitStepperVcID) as! DoctorVisitStepperController
        
        vc.customerMasterModel = userCurrentList[indexPath.section].userList[indexPath.row]
        vc.geoLocationSkipRemarks = geoFencingSkipRemarks
        vc.currentLocation = currentLocation
        
        DCRModel.sharedInstance.customerCode = checkNullAndNilValueForString(stringData: userCurrentList[indexPath.section].userList[indexPath.row].Customer_Code)
        DCRModel.sharedInstance.customerRegionCode = userCurrentList[indexPath.section].userList[indexPath.row].Region_Code
        //            DCRModel.sharedInstance.customerId = currentList[indexPath.row].Customer_Id
        DCRModel.sharedInstance.doctorVisitId = 0
        
        if let navigationController = self.navigationController
        {
            navigationController.popViewController(animated: false)
            navigationController.pushViewController(vc, animated: false)
        }
    }
    func isCurrentDate() -> Bool
    {
        
        let dcrDate = DCRModel.sharedInstance.dcrDateString
        let currentDate = getCurrentDate()
        
        if (dcrDate == currentDate)
        {
            return true
        }
        else
        {
            return false
        }
    }
    private func PunchInmoveToDCRDoctorVisitStepper(indexPath: IndexPath, geoFencingSkipRemarks: String, currentLocation: GeoLocationModel)
    {
        let sb = UIStoryboard(name: doctorMasterSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: doctorVisitStepperVcID) as! DoctorVisitStepperController
        var localTimeZoneName: String { return TimeZone.current.identifier }
        vc.customerMasterModel = userCurrentList[indexPath.section].userList[indexPath.row]
        vc.geoLocationSkipRemarks = geoFencingSkipRemarks
        vc.currentLocation = currentLocation
        vc.punch_start = getStringFromDateforPunch(date: getCurrentDateAndTime())
        vc.punch_status = 1
        vc.punch_UTC = getUTCDateForPunch()
        vc.punch_timezone = localTimeZoneName
        vc.punch_timeoffset = getOffset()
        DCRModel.sharedInstance.customerCode = checkNullAndNilValueForString(stringData: userCurrentList[indexPath.section].userList[indexPath.row].Customer_Code)
        DCRModel.sharedInstance.customerRegionCode = userCurrentList[indexPath.section].userList[indexPath.row].Region_Code
        //            DCRModel.sharedInstance.customerId = currentList[indexPath.row].Customer_Id
        DCRModel.sharedInstance.doctorVisitId = 0
        
        if let navigationController = self.navigationController
        {
            navigationController.popViewController(animated: false)
            navigationController.pushViewController(vc, animated: false)
        }
    }
    func saveSkipRemarks(remarks: String, isCancelled: Bool, indexPath: IndexPath, currentLocation: GeoLocationModel)
    {
        if (!isCancelled)
        {
            moveToDCRDoctorVisitStepper(indexPath: indexPath, geoFencingSkipRemarks: remarks, currentLocation: currentLocation)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if (!isFromRCPA && !isFromAttendance && BL_MenuAccess.sharedInstance.is_Punch_In_Out_Enabled() && isCurrentDate())
            
        {
            var model : [DCRDoctorVisitModel] = []
            model = DBHelper.sharedInstance.getDCRDoctorVisitPunchTimeValidation(dcrId: DCRModel.sharedInstance.dcrId)
            
            if(model != nil && model.count > 0)
            {
                let doctorobj : DCRDoctorVisitModel = model[0]
                let initialAlert = "Punch-out time for " + doctorobj.Doctor_Name + " is " + getcurrenttime() + ". You cannot Punch-in for other \(appDoctor) until you punch-out for " + doctorobj.Doctor_Name
                //let indexpath = sender.tag
                let alertViewController = UIAlertController(title: "Punch Out", message: initialAlert, preferredStyle: UIAlertControllerStyle.alert)
                
                alertViewController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { alertAction in
                    alertViewController.dismiss(animated: true, completion: nil)
                }))
                
                alertViewController.addAction(UIAlertAction(title: "Go to modify", style: UIAlertActionStyle.default, handler: { alertAction in
                    //function
                    self.navigateToNextScreen(stoaryBoard: doctorMasterSb, viewController: doctorVisitModifyVcID)
                    
                    alertViewController.dismiss(animated: true, completion: nil)
                }))
                
                self.present(alertViewController, animated: true, completion: nil)
            }
            else
            {
                
                let doctorCheck = DBHelper.sharedInstance.checkDoctorVisitforDoctorId(doctorCode: userCurrentList[indexPath.section].userList[indexPath.row].Customer_Code, regionCode: userCurrentList[indexPath.section].userList[indexPath.row].Region_Code)
                if doctorCheck == 0
                {
                    let currentLocation = getCurrentLocaiton()
                    let initialAlert = "Punch-in time for " + userCurrentList[indexPath.section].userList[indexPath.row].Customer_Name + " is " + getcurrenttime() + ". You cannot Punch-in for other \(appDoctor) until you punch-out for " + userCurrentList[indexPath.section].userList[indexPath.row].Customer_Name
                    //let indexpath = sender.tag
                    let alertViewController = UIAlertController(title: "Punch In", message: initialAlert, preferredStyle: UIAlertControllerStyle.alert)
                    
                    alertViewController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { alertAction in
                        alertViewController.dismiss(animated: true, completion: nil)
                    }))
                    
                    alertViewController.addAction(UIAlertAction(title: "Punch In", style: UIAlertActionStyle.default, handler: { alertAction in
                        //function
                        self.PunchInmoveToDCRDoctorVisitStepper(indexPath: indexPath, geoFencingSkipRemarks: EMPTY, currentLocation: currentLocation)
                        alertViewController.dismiss(animated: true, completion: nil)
                    }))
                    
                    self.present(alertViewController, animated: true, completion: nil)
                }
            }
            
            
        }
            
        else{
            
            if isFromAttendance
            {
                let doctorCheck = DBHelper.sharedInstance.checkDoctorVisitforAttandanceDoctorId(doctorCode: userCurrentList[indexPath.section].userList[indexPath.row].Customer_Code, regionCode: userCurrentList[indexPath.section].userList[indexPath.row].Region_Code)
                
                if doctorCheck == 0
                {
                    let sb = UIStoryboard(name: attendanceStepperSb, bundle: nil)
                    let vc = sb.instantiateViewController(withIdentifier: AttendanceDoctorStepperControllerID) as! AttendanceDoctorStepperController
                    vc.customerMasterModel = userCurrentList[indexPath.section].userList[indexPath.row]
                    // vc.geoLocationSkipRemarks = geoFencingSkipRemarks
                    vc.currentLocation = getCurrentLocaiton()
                    
                    DCRModel.sharedInstance.customerCode = checkNullAndNilValueForString(stringData: userCurrentList[indexPath.section].userList[indexPath.row].Customer_Code)
                    DCRModel.sharedInstance.customerRegionCode = userCurrentList[indexPath.section].userList[indexPath.row].Region_Code
                    //            DCRModel.sharedInstance.customerId = currentList[indexPath.row].Customer_Id
                    DCRModel.sharedInstance.doctorVisitId = 0
                    
                    if let navigationController = self.navigationController
                    {
                        navigationController.popViewController(animated: false)
                        navigationController.pushViewController(vc, animated: false)
                    }
                }
                
            }
            else if !isFromRCPA
            {
                let doctorCheck = DBHelper.sharedInstance.checkDoctorVisitforDoctorId(doctorCode: userCurrentList[indexPath.section].userList[indexPath.row].Customer_Code, regionCode: userCurrentList[indexPath.section].userList[indexPath.row].Region_Code)
                if doctorCheck == 0
                {
                    let currentLocation = getCurrentLocaiton()
                    
                    if (BL_Geo_Location.sharedInstance.isGeoLocationMandatoryPrivEnabled())
                    {
                        let lstAddress = BL_Geo_Location.sharedInstance.getCustomerAddress(customerCode: userCurrentList[indexPath.section].userList[indexPath.row].Customer_Code, regionCode: userCurrentList[indexPath.section].userList[indexPath.row].Region_Code, customerEntityType: DOCTOR)
                        
                        if (lstAddress.count > 1)
                        {
                            moveToCustomerAddressView(addressList: lstAddress, indexPath: indexPath, currentLocation: currentLocation)
                        }
                        else
                        {
                            selectSingleAddress(indexPath: indexPath, customerAddressList: lstAddress, currentLocation: currentLocation)
                        }
                    }
                        
                    else
                    {
                        moveToDCRDoctorVisitStepper(indexPath: indexPath, geoFencingSkipRemarks: EMPTY, currentLocation: currentLocation)
                    }
                }
            }
            else
            {
                self.navigateToProductList(doctorObj: userCurrentList[indexPath.section].userList[indexPath.row])
            }
        }
    }
    
    private func navigateToNextScreen(stoaryBoard: String, viewController:String)
    {
        let sb = UIStoryboard(name: stoaryBoard, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: viewController)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func updatepunchout(dcrID: Int, visitid: Int)
    {
        let time = getStringFromDateforPunch(date: getCurrentDateAndTime())
        executeQuery(query: "UPDATE \(TRAN_DCR_DOCTOR_VISIT) SET Punch_End_Time = '\(time)', Punch_Status = 2 WHERE DCR_Id = \(dcrID) AND DCR_Doctor_Visit_Id = '\(visitid)'")
    }
    private func moveToCustomerAddressView(addressList: [CustomerAddressModel], indexPath: IndexPath, currentLocation: GeoLocationModel)
    {
        let sb = UIStoryboard(name: doctorMasterSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.CustomerAddressVCId) as! CustomerAddressViewController
        vc.addressList = addressList
        vc.objCustomer = userCurrentList[indexPath.section].userList[indexPath.row]
        vc.delegate = self
        vc.indexPath = indexPath
        vc.currentLocation = currentLocation
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func selectAddres(indexPath: IndexPath, customerAddressList: [CustomerAddressModel], currentLocation: GeoLocationModel)
    {
        if let navigationController = self.navigationController
        {
            navigationController.popViewController(animated: false)
        }
        
        selectSingleAddress(indexPath: indexPath, customerAddressList: customerAddressList, currentLocation: currentLocation)
    }
    
    func selectSingleAddress(indexPath: IndexPath, customerAddressList: [CustomerAddressModel], currentLocation: GeoLocationModel)
    {
        let customerName = userCurrentList[indexPath.section].userList[indexPath.row].Customer_Name
        //let currentLocation = getCurrentLocaiton()
        let doctorLocationsList = convertCustomerAddressModelToGeoLocaitonModel(customerAddressList: customerAddressList)
        
        let objGeoValidation = BL_Geo_Location.sharedInstance.doGeoLocationAndFencingValidations(userLocation: currentLocation, doctorLocationsList: doctorLocationsList, viewController: self, customerName: customerName!)
        
        if (objGeoValidation.Customer_Location != nil)
        {
            confirmCustomerAddressAlert(indexPath: indexPath, currentLocaiton: currentLocation, objGeoValidation: objGeoValidation)
        }
        else
        {
            proceedDCR(indexPath: indexPath, currentLocation: currentLocation, objGeoValidation: objGeoValidation)
        }
    }
    
    private func convertCustomerAddressModelToGeoLocaitonModel(customerAddressList: [CustomerAddressModel]) -> [GeoLocationModel]
    {
        var lstCustomerLocations: [GeoLocationModel] = []
        
        for objAddress in customerAddressList
        {
            let objGeoLocationModel = GeoLocationModel()
            
            objGeoLocationModel.Latitude = objAddress.Latitude
            objGeoLocationModel.Longitude = objAddress.Longitude
            objGeoLocationModel.Address_Id = objAddress.Address_Id
            
            lstCustomerLocations.append(objGeoLocationModel)
        }
        
        return lstCustomerLocations
    }
    
    private func showGeoFencingDeviationAlertWithSkip(indexPath: IndexPath, currentLocaiton: GeoLocationModel)
    {
        let objCustomer = userCurrentList[indexPath.section].userList[indexPath.row]
        let customerName = objCustomer.Customer_Name!
        
        let alertViewController = UIAlertController(title: alertTitle, message: "You are away from the \(customerName)'s location. \n\n Please tap on SKIP button to enter the reason for skip and then proceed further \n\n Please tap on CANCEL button not to proceed further", preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.default, handler: { alertAction in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        alertViewController.addAction(UIAlertAction(title: "SKIP", style: UIAlertActionStyle.default, handler: { alertAction in
            self.skipAction(indexPath: indexPath, currentLocaiton: currentLocaiton)
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    private func skipAction(indexPath: IndexPath, currentLocaiton: GeoLocationModel)
    {
        let sb = UIStoryboard(name: dcrStepperSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.GeoFencingSkipRemarksVCId) as! GeoLocationSkipViewController
        vc.delegate = self
        vc.indexPath = indexPath
        vc.currentLocation = currentLocaiton
        
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        
        self.present(vc, animated: false, completion: nil)
    }
    
    private func confirmCustomerAddressAlert(indexPath: IndexPath, currentLocaiton: GeoLocationModel, objGeoValidation: GeoLocationValidationModel)
    {
        let objCustomer = userCurrentList[indexPath.section].userList[indexPath.row]
        let customerName = objCustomer.Customer_Name!
        
        let alertViewController = UIAlertController(title: alertTitle, message: "We have not found any location info for \(appDoctor). Are you at \(customerName)'s location now ? \n\n Tap on YES button to update the current location as \(customerName)'s location \n\n Tap on NO button not to update any location info and proceed further", preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { alertAction in
            self.confrimAddressYesButtonAction(indexPath: indexPath, currentLocation: currentLocaiton, objGeoValidation: objGeoValidation)
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        alertViewController.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: { alertAction in
            self.proceedDCR(indexPath: indexPath, currentLocation: currentLocaiton, objGeoValidation: objGeoValidation)
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    private func confrimAddressYesButtonAction(indexPath: IndexPath, currentLocation: GeoLocationModel, objGeoValidation: GeoLocationValidationModel)
    {
        if (objGeoValidation.Customer_Location != nil)
        {
            BL_Geo_Location.sharedInstance.updateCustomerLocation(customerLocation: objGeoValidation.Customer_Location!, pageSource: Constants.Geo_Fencing_Page_Names.DCR)
        }
        
        proceedDCR(indexPath: indexPath, currentLocation: currentLocation, objGeoValidation: objGeoValidation)
    }
    
    private func proceedDCR(indexPath: IndexPath, currentLocation: GeoLocationModel, objGeoValidation: GeoLocationValidationModel)
    {
        if (objGeoValidation.Status == 1)
        {
            moveToDCRDoctorVisitStepper(indexPath: indexPath, geoFencingSkipRemarks: objGeoValidation.Remarks, currentLocation: currentLocation)
        }
        else if (objGeoValidation.Status == 2)
        {
            self.showGeoFencingDeviationAlertWithSkip(indexPath: indexPath, currentLocaiton: currentLocation)
        }
        else if (objGeoValidation.Status == 3)
        {
            AlertView.showAlertToCaptureGPS()
        }
    }
    
    // Search bar delegates
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool
    {
        self.searchBar.showsCancelButton = true
        enableCancelButtonForSearchBar(searchBar:searchBar)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        selectedIndex = 0
        self.searchBar.showsCancelButton = false
        self.searchBar.text = nil
        self.searchBar.resignFirstResponder()
        
        var userWrapperModelArray = currentList
        getNameSortedList(userWrapperList: userWrapperModelArray)
        changeCurrentArray(list: userSortList, type: 1)
        setDefaults()
        //  self.changeCurrentArray(list: userCurrentList,type : 0)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        //        if (searchBar.text?.count)! > 0
        //        {
        sortCurrentList(searchText: searchBar.text!)
        //        }else{
        //            selectedIndex = 0
        //        }
    }
    
    func sortCurrentList(searchText:String)
    {
        
        if selectedIndex == 0
        {
            currentList = BL_DCR_Doctor_Visit.sharedInstance.getDoctorMasterList(regionCode: regionCode)!
        }
        else if selectedIndex == 1
        {
            currentList = BL_DCR_Doctor_Visit.sharedInstance.getTPDoctorsForSelectedDate()!
        }
        else
        {
            currentList = BL_DCR_Doctor_Visit.sharedInstance.getCPDoctorsForSelectedDate()!
        }
        //currentList = BL_DCR_Doctor_Visit.sharedInstance.getDoctorMasterList(regionCode: regionCode)!
        
        var userWrapperModelArray = currentList
        if searchText != ""
        {
            userWrapperModelArray = currentList.filter { (userWrapperObj) -> Bool in
                let loweredSeachString = searchText.lowercased()
                return userWrapperObj.Customer_Name.lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData: userWrapperObj.Region_Name).lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData: userWrapperObj.MDL_Number).lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData: userWrapperObj.Category_Name).lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData: userWrapperObj.Speciality_Name).lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData: userWrapperObj.Local_Area).lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData: userWrapperObj.Hospital_Name).lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData: userWrapperObj.Hospital_Account_Number).lowercased().contains(loweredSeachString)
                //                    || checkNullAndNilValueForString(stringData: userWrapperObj.Region_Name).lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData: userWrapperObj.MDL_Number).lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData: userWrapperObj.Category_Name).lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData: userWrapperObj.Speciality_Name).lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData: userWrapperObj.Local_Area).lowercased().contains(loweredSeachString)
            }
            searchedWrappedList = userWrapperModelArray
            if (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.SHOW_ORGANISATION_IN_CUSTOMER) == PrivilegeValues.YES.rawValue)
            {
                getOtherSortedList(userWrapperList : userWrapperModelArray)
            }
            else
            {
                getNameSortedList(userWrapperList: userWrapperModelArray)
            }
            //getOtherSortedList(userWrapperList : userWrapperModelArray)
            self.changeCurrentArray1(list: userSortList,type: 1)
        }
        else
        {
            searchedWrappedList = []
            //            getOtherSortedList(userWrapperList : userWrapperModelArray)
            //            self.changeCurrentArray(list: userSortList,type: 1)
            if (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.SHOW_ORGANISATION_IN_CUSTOMER) == PrivilegeValues.YES.rawValue)
            {
                getHospitalNameSortedList(userWrapperList: userWrapperModelArray)
            }
            else
            {
                getNameSortedList(userWrapperList: userWrapperModelArray)
            }
            //getNameSortedList(userWrapperList: userWrapperModelArray)
            changeCurrentArray(list: userSortList, type: 1)
        }
        
        
    }
    
    func changeCurrentArray1(list : [CustomerSortedModel],type : Int)
    {
        if list.count > 0
        {
            userCurrentList = list
            self.showEmptyStateView(show: false)
            searchBarHeightConst.constant = 44.0
            self.tableView.reloadData()
        }
        else
        {
            self.showEmptyStateView(show: true)
            self.setEmptyStateLbl(type: type)
        }
    }
    
    func changeCurrentArray(list : [CustomerSortedModel],type : Int)
    {
        if list.count > 0
        {
            userCurrentList = list
            self.showEmptyStateView(show: false)
            searchBarHeightConst.constant = 44.0
            self.tableView.reloadData()
        }
        else
        {
            self.showEmptyStateView(show: true)
            self.setEmptyStateLbl(type: type)
        }
    }
    
    func showEmptyStateView(show : Bool)
    {
        self.emptyStateView.isHidden = !show
        self.contentView.isHidden = show
    }
    
    func setEmptyStateLbl(type : Int)
    {
        var text : String = ""
        if type == 0
        {
            if selectedIndex == 0
            {
                emptyStateImage.image = UIImage(named: "icon-doctor")
                text = "No \(appDoctorPlural) available"
            }
            else if selectedIndex == 1
            {
                emptyStateImage.image = UIImage(named: "icon-stepper-cycle")
                text = "Tour planner data not available"
            }
            else if selectedIndex == 2
            {
                emptyStateImage.image = UIImage(named: "icon-stepper-cycle")
                text = "Beat/Patch data not available"
            }
            self.searchBarHeightConst.constant = 0
        }
        else
        {
            text = "No results found. Clear your search and try again."
            emptyStateImage.image = nil
            self.searchBarHeightConst.constant = 44
        }
        
        self.emptyStatelabel.text = text
    }
    
    @IBAction func segControlAction(_ sender: AnyObject)
    {
        self.searchBar.showsCancelButton = false
        self.searchBar.text = nil
        self.searchBar.resignFirstResponder()
        
        
        selectedIndex = sender.selectedSegmentIndex
        isAddbtnHidden(index: selectedIndex)
        setCurrentTableList()
    }
    
    @IBAction func addAction(_ sender: AnyObject)
    {
        
        let sb = UIStoryboard(name: doctorMasterSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AddFlexiDoctorVcId") as! AddFlexiDoctor
        if isFromRCPA
        {
            vc.isfromChemistDay = isFromRCPA
        }
        else if isFromAttendance
        {
            vc.isFromAttendance = self.isFromAttendance
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func addCustomBackButtonToNavigationBar()
    {
        let backButton = UIButton(type: UIButtonType.custom)
        
        backButton.addTarget(self, action: #selector(self.backButtonClicked), for: UIControlEvents.touchUpInside)
        backButton.setImage(UIImage(named: "navigation-arrow"), for: .normal)
        backButton.sizeToFit()
        
        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func backButtonClicked()
    {
        _ = navigationController?.popViewController(animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func navigateToProductList(doctorObj: CustomerMasterModel)
    {
        let sb = UIStoryboard(name: detailProductSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: DetailProductVcID) as! DetailedProductViewController
        vc.customerModel = doctorObj
        vc.isFromRCPA = isFromRCPA
        if let navigationController = self.navigationController
        {
            navigationController.popViewController(animated: false)
            navigationController.pushViewController(vc, animated: false)
        }
        
    }
    
}
