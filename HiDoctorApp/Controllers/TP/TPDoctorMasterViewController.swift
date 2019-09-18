//
//  TPDoctorMasterViewController.swift
//  HiDoctorApp
//
//  Created by Admin on 7/27/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class TPDoctorMasterViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
{
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var emptyStateImage: UIImageView!
    @IBOutlet weak var emptyStatelabel: UILabel!
    @IBOutlet weak var searchBarHeightConst: NSLayoutConstraint!
    @IBOutlet weak var refreshLabelHeightConst: NSLayoutConstraint!
    @IBOutlet weak var refreshLabel: UILabel!
    
    var delegate: ChildViewControllerDelegate?
    var selectedIndex : Int! = 1
    var constrainedWidth : CGFloat!
    var cellIdentifier : String!
    var regionCode : String!
    var regionName : String!
    var suffixConfigVal : [String]!
    var doctorMasterList : [CustomerMasterModel] = []
    var currentList : [CustomerMasterModel] = []
    var searchList : [CustomerMasterModel] = []
    var userSelectedProductCode : [String] = []
    var userSelectedList : NSMutableArray = []
    var nextBtn : UIBarButtonItem!
    var refreshBtn : UIBarButtonItem!
    var doctorMasterListselected : [CustomerMasterModel] = []
    var sectionTitle : [String] = []
    var userSortList : [CustomerSortedModel] = []
    var isAscending : Bool = true
    var userCurrentList : [CustomerSortedModel] = []
    var DoctorList : [CustomerMasterModel] = []
    // var fromtasknotesList : NSArray = []
    var searchedWrappedList : [CustomerMasterModel] = []
    var isfromnotes: Bool = false
    var list: [String] = []
    var showOrganisation: String?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        showOrganisation = (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.SHOW_ORGANISATION_IN_CUSTOMER))
        if (isfromnotes == true)
        {
            addBarButtonItem()
            addBackButtonView()
            //addRefreshBtn()
            //            let list = BL_DCR_Doctor_Visit.sharedInstance.getDoctorMasterSortList(regionCode: regionCode, sortFieldCode: 0, sortTypeCode: 0)!
            //            doctorMasterList = list
            //            getHospitalNameSortedList(userWrapperList: doctorMasterList)
            //            changeCurrentArray(list: userSortList, type: 0)
            segmentedControl.selectedSegmentIndex = 0
            segmentedControl.removeSegment(at: 1, animated: false)
            setDefaults()
            
            let rect = CGRect(origin: self.segmentedControl.frame.origin, size: CGSize(width: self.segmentedControl.frame.size.width, height: 0))
            self.segmentedControl.frame = rect
            self.segmentedControl.setTitle(appDoctor + " List", forSegmentAt: 0)
            self.segmentedControl.setEnabled(true, forSegmentAt: 0)
            //self.segmentedControl.isHidden = true
            //self.navigationItem.rightBarButtonItems = [refreshBtn]
        }
        else
        {
            if (TPModel.sharedInstance.tpStatus == TPStatus.unapproved.rawValue)
            {
                DAL_TP_Stepper.sharedInstance.changeTPStatusToDraft(tpEntryId: TPModel.sharedInstance.tpEntryId)
            }
            
            self.navigationItem.title = "\(appDoctorPlural) List"
            
            addBarButtonItem()
            addRefreshBtn()
            addBackButtonView()
            setDefaults()
            
            self.navigationItem.rightBarButtonItems = [refreshBtn]
        }
    }
    
    func setDefaults()
    {
        if(!isfromnotes)
        {
            self.syncRefreshDate()
            
            constrainedWidth = SCREEN_WIDTH - 40.0
            cellIdentifier = "doctorMasterCell"
            suffixConfigVal = BL_TP_Doctor_Visit.sharedInstance.getDoctorSuffixColumnName()
            
            if let list = BL_TP_Doctor_Visit.sharedInstance.getCPDoctorsForSelectedDate()
            {
                if (list.count == 0)
                {
                    selectedIndex = 0
                }
                else
                {
                    selectedIndex = 1
                }
            }
            else
            {
                selectedIndex = 1
            }
            
            //segmentedControl.selectedSegmentIndex = selectedIndex
            //segmentedControl.isHidden = true
        }
        
        setCurrentTableList()
    }
    
    func setCurrentTableList()
    {
        
        if selectedIndex == 0
        {
            self.navigationItem.rightBarButtonItems = [refreshBtn]
            
            if let list = BL_TP_Doctor_Visit.sharedInstance.getDoctorMasterList(regionCode: regionCode)
            {
                doctorMasterList = list
                self.refreshLabelHeightConst.constant = 16
            }
        }
            
        else if selectedIndex == 1
        {
            if(!isfromnotes)
            {
                self.navigationItem.rightBarButtonItems = []
                self.refreshLabelHeightConst.constant = 0
                
                if let list = BL_TP_Doctor_Visit.sharedInstance.getCPDoctorsForSelectedDate()
                {
                    doctorMasterList = list
                }
            }
        }
        if(isfromnotes)
        {
            var chemistMasterList : [CustomerMasterModel]?
            let regionCode = getRegionCode()
            let customerEntityType = "DOCTOR"
            try? dbPool.read { db in
                chemistMasterList = try CustomerMasterModel.fetchAll(db, "SELECT * FROM \(MST_CUSTOMER_MASTER) WHERE Region_Code = ? AND UPPER(Customer_Entity_Type) = ? ORDER BY Customer_Name",arguments:[regionCode,customerEntityType])
                doctorMasterList = chemistMasterList!
            }
            if(list.count > 0)
            {
                
                var newList: [CustomerMasterModel] = []
                for doctorobj in doctorMasterList
                {
                    for i in list
                    {
                        if (i == doctorobj.Customer_Code)
                        {
                            doctorobj.isSelected = true
                            
                        }
                        
                    }
                    newList.append(doctorobj)
                }
                doctorMasterList = newList
            }
            
            //let dict = [:]
            //var obj: CustomerMasterModel = CustomerMasterModel(dict: dict)
            
            
        }
        if (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.SHOW_ORGANISATION_IN_CUSTOMER) == PrivilegeValues.YES.rawValue)
        {
            getHospitalNameSortedList(userWrapperList: doctorMasterList)
        }
        else
        {
            getNameSortedList(userWrapperList: doctorMasterList)
        }
        
        // getHospitalNameSortedList(userWrapperList: doctorMasterList)
        changeCurrentArray(list: userSortList, type: 0)
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
    
    // MARK: - Tableview delegates & datasources
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    //    {
    //        return currentList.count
    //    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        var heightVal : CGFloat = 44.0
        var attString3 = NSMutableAttributedString()
        
        let model = userCurrentList[indexPath.section].userList[indexPath.row]
        if(!isfromnotes)
        {
            let nameTextSize = getTextSize(text: model.Customer_Name, fontName: fontSemiBold, fontSize: 15.0, constrainedWidth: constrainedWidth)
            
            //            var detailText : String = ""
            //
            //            //let strHospitalName = checkNullAndNilValueForString(stringData:model.Hospital_Name!) as? String
            //            detailText = String(format: "%@ | %@ | %@ | %@", model.MDL_Number, model.Speciality_Name, model.Category_Name!, model.Region_Name)
            //
            //            if suffixConfigVal.contains(ConfigValues.SUR_NAME.rawValue) && model.Sur_Name != ""
            //            {
            //                detailText = String(format: "%@ | %@", detailText, model.Sur_Name!)
            //            }
            //
            //            if suffixConfigVal.contains(ConfigValues.LOCAL_AREA.rawValue) && model.Local_Area != ""
            //            {
            //                detailText = String(format: "%@ | %@", detailText, model.Local_Area!)
            //            }
            if (showOrganisation == PrivilegeValues.YES.rawValue)
            {
                if model.Hospital_Account_Number != ""
                {
                    var hospitalDetails = String(format: "%@ | %@", model.Hospital_Name!, model.Hospital_Account_Number!)
                    
                    var detailText : String = ""
                    
//                    detailText = String(format: "%@ | %@ | %@ | %@| %@","\n", ccmNumberPrefix + model.MDL_Number, model.Speciality_Name, model.Category_Name!, model.Region_Name)
                    detailText = String(format: "%@ | %@| %@","\n", model.Speciality_Name, model.Category_Name!, model.Region_Name)
                    
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
                    let attString2 = NSMutableAttributedString(string: hospitalDetails, attributes: blueFontAttributes)
                    
                    attString3.append(attString2)
                    attString3.append(attString1)
                }
                    
                else
                {
                    // var hospitalDetails = String(format: "%@", model.Hospital_Name!)
                    
                    var detailText : String = ""
                    
//                    detailText = String(format: "%@ | %@ | %@ | %@| %@","\n", ccmNumberPrefix + model.MDL_Number, model.Speciality_Name, model.Category_Name!, model.Region_Name)
                    detailText = String(format: "%@ | %@| %@","\n",model.Speciality_Name, model.Category_Name!, model.Region_Name)
                    
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
                    //                let attString2 = NSMutableAttributedString(string: hospitalDetails, attributes: blueFontAttributes)
                    //
                    //                attString3.append(attString2)
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
                //                let attString2 = NSMutableAttributedString(string: hospitalDetails, attributes: blueFontAttributes)
                //
                //                attString3.append(attString2)
                attString3.append(attString1)
                
            }
            
            //        let detailTextSize = getTextSize(text: detailText, fontName: fontRegular, fontSize: 14.0, constrainedWidth: constrainedWidth)
            let detailTextSize = getAttributedTextSize(text: attString3, fontName: fontRegular, fontSize: 14.0, constrainedWidth: constrainedWidth)
            
            //let detailTextSize = getTextSize(text: detailText, fontName: fontRegular, fontSize: 14.0, constrainedWidth: constrainedWidth)
            
            heightVal = heightVal + nameTextSize.height + detailTextSize.height
        }
        return heightVal
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let model = userCurrentList[indexPath.section].userList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: TPAccompanistCell, for: indexPath) as! TPAccompanistTableViewCell
        var attString3 = NSMutableAttributedString()
        
        cell.userNameLbl.text = model.Customer_Name
        
        //        var detailText : String = ""
        //        //let strHospitalName = checkNullAndNilValueForString(stringData: model.Hospital_Name!) as? String
        //        detailText = String(format: "%@ | %@ | %@ | %@", model.MDL_Number, model.Speciality_Name, model.Category_Name!, model.Region_Name)
        //        if(!isfromnotes)
        //        {
        //            if suffixConfigVal.contains(ConfigValues.SUR_NAME.rawValue) && model.Sur_Name != ""
        //            {
        //                detailText = String(format: "%@ | %@", detailText, model.Sur_Name!)
        //            }
        //
        //            if suffixConfigVal.contains(ConfigValues.LOCAL_AREA.rawValue) && model.Local_Area != ""
        //            {
        //                detailText = String(format: "%@ | %@", detailText, model.Local_Area!)
        //            }
        //        }
        if (showOrganisation == PrivilegeValues.YES.rawValue)
        {
            if model.Hospital_Account_Number != "" || model.Hospital_Name != ""
            {
                var hospitalDetails = String(format: "%@ | %@", model.Hospital_Name!, model.Hospital_Account_Number!)
                
                var detailText : String = ""
                
//                detailText = String(format: "%@ | %@ | %@ | %@| %@","\n", ccmNumberPrefix + model.MDL_Number, model.Speciality_Name, model.Category_Name!, model.Region_Name)
                
                detailText = String(format: "%@%@ | %@ | %@","\n",model.Speciality_Name, model.Category_Name!, model.Region_Name)
                
                
                if(!isfromnotes)
                {
                    if suffixConfigVal.contains(ConfigValues.SUR_NAME.rawValue) && model.Sur_Name != ""
                    {
                        detailText = String(format: "%@ | %@", detailText, model.Sur_Name!)
                    }
                    
                    if suffixConfigVal.contains(ConfigValues.LOCAL_AREA.rawValue) && model.Local_Area != ""
                    {
                        detailText = String(format: "%@ | %@", detailText, model.Local_Area!)
                    }
                }
                let attString1 = NSMutableAttributedString.init(string: detailText)
                let blueFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0/250, green: 191/250, blue: 255/250, alpha: 1.0), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0)]
                let attString2 = NSMutableAttributedString(string: hospitalDetails, attributes: blueFontAttributes)
                
                attString3.append(attString2)
                attString3.append(attString1)
            }
                
            else
            {
                //var hospitalDetails = String(format: "%@", model.Hospital_Name!)
                
                var detailText : String = ""
                
//                detailText = String(format: "%@ | %@ | %@ | %@| %@","\n", ccmNumberPrefix + model.MDL_Number, model.Speciality_Name, model.Category_Name!, model.Region_Name)
                
                detailText = String(format: "%@%@ | %@ | %@","\n",model.Speciality_Name, model.Category_Name!, model.Region_Name)
                
                if(!isfromnotes)
                {
                    if suffixConfigVal.contains(ConfigValues.SUR_NAME.rawValue) && model.Sur_Name != ""
                    {
                        detailText = String(format: "%@ | %@", detailText, model.Sur_Name!)
                    }
                    
                    if suffixConfigVal.contains(ConfigValues.LOCAL_AREA.rawValue) && model.Local_Area != ""
                    {
                        detailText = String(format: "%@ | %@", detailText, model.Local_Area!)
                    }
                }
                
                let attString1 = NSMutableAttributedString.init(string: detailText)
                let blueFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0/250, green: 191/250, blue: 255/250, alpha: 1.0), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0)]
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
            
            if(!isfromnotes)
            {
                if suffixConfigVal.contains(ConfigValues.SUR_NAME.rawValue) && model.Sur_Name != ""
                {
                    detailText = String(format: "%@ | %@", detailText, model.Sur_Name!)
                }
                
                if suffixConfigVal.contains(ConfigValues.LOCAL_AREA.rawValue) && model.Local_Area != ""
                {
                    detailText = String(format: "%@ | %@", detailText, model.Local_Area!)
                }
            }
            
            let attString1 = NSMutableAttributedString.init(string: detailText)
            let blueFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0/250, green: 191/250, blue: 255/250, alpha: 1.0), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0)]
            //            let attString2 = NSMutableAttributedString(string: hospitalDetails, attributes: blueFontAttributes)
            //
            //            attString3.append(attString2)
            attString3.append(attString1)
        }
        
        cell.subTitleLbl.attributedText = attString3
        cell.placeLabel.isHidden = true
        
        let strUserCode = checkNullAndNilValueForString(stringData: model.userCode) as? String
        if userSelectedProductCode.contains(strUserCode!)
        {
            cell.selectedImageView.image = UIImage(named: "icon-tick")
            cell.outerView.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1.0)
        }
        else if model.isReadOnly
        {
            cell.selectedImageView.image = UIImage(named: "icon-selected")
            cell.outerView.backgroundColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
        }
        else if userSelectedList.contains(model) || model.isSelected == true
        {
            cell.selectedImageView.image = UIImage(named: "icon-tick")
            cell.outerView.backgroundColor = UIColor.white
        }
        else
        {
            cell.selectedImageView.image = UIImage(named: "icon-unselected")
            cell.outerView.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let userDetail = userCurrentList[indexPath.section].userList[indexPath.row]
        
        let strUserCode = checkNullAndNilValueForString(stringData: userDetail.userCode) as? String
        if !userSelectedProductCode.contains(strUserCode!)
        {
            if !userDetail.isReadOnly
            {
                userDetail.isSelected = !userDetail.isSelected
                var i = 0
                for obj in doctorMasterList{
                    if(doctorMasterList[i].Customer_Name == userDetail.Customer_Name){
                        doctorMasterList[i].isSelected = userDetail.isSelected
                    }
                    i += 1
                }
                
                tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                
                toggleTickButton()
                //  toggleTickButton(list : userDetail)
            }
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
        self.searchBar.showsCancelButton = false
        self.searchBar.text = nil
        self.searchBar.resignFirstResponder()
        
        setDefaults()
        //        let userWrapperModelArray = currentList
        //        getHospitalNameSortedList(userWrapperList: userWrapperModelArray)
        //        changeCurrentArray(list: userSortList, type: 1)
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
        //        }
    }
    
    func sortCurrentList(searchText:String)
    {
        currentList = BL_DCR_Doctor_Visit.sharedInstance.getDoctorMasterList(regionCode: regionCode)!
        
        var userWrapperModelArray = doctorMasterList
        if searchText != ""
        {
            userWrapperModelArray = doctorMasterList.filter { (userWrapperObj) -> Bool in
                let loweredSeachString = searchText.lowercased()
                return userWrapperObj.Customer_Name.lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData: userWrapperObj.Region_Name).lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData: userWrapperObj.MDL_Number).lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData: userWrapperObj.Category_Name).lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData: userWrapperObj.Speciality_Name).lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData: userWrapperObj.Local_Area).lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData: userWrapperObj.Hospital_Name).lowercased().contains(loweredSeachString) || checkNullAndNilValueForString(stringData: userWrapperObj.Hospital_Account_Number).lowercased().contains(loweredSeachString)
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
            changeCurrentArray(list: userSortList,type: 1)
        }
        else
        {
            setDefaults()
            //            searchedWrappedList = []
            //            getHospitalNameSortedList(userWrapperList: userWrapperModelArray)
            //            changeCurrentArray(list: userSortList, type: 1)
        }
    }
    
    func changeCurrentArray(list : [CustomerSortedModel],type : Int)
    {
        if list.count > 0
        {
            userCurrentList = list
            var i = 0
            for value in userCurrentList{
                value.userCode = "\(i)"
                i += 1
            }
            
            self.showEmptyStateView(show: false)
            searchBarHeightConst.constant = 44.0
            if(!isfromnotes)
            {
                filterSelectedList()
            }
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
                text = " No \(appCp) \(appDoctorPlural) available"
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
        setCurrentTableList()
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
    
    func addBarButtonItem()
    {
        nextBtn = UIBarButtonItem(image: UIImage(named: "icon-done"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(nextScreenBtnAction))
    }
    
    func addRefreshBtn(){
        refreshBtn = UIBarButtonItem(image: UIImage(named: "icon-refresh"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(refreshAction))
    }
    
    @objc func nextScreenBtnAction(){
        
        
        if(isfromnotes)
        {   self.doctorMasterListselected = doneButtonAction()
            self.delegate?.childViewControllerResponse(parameter: self.doctorMasterListselected)
            // UserDefaults.standard.set(userSelectedList, forKey: "selectedlist")
            _ = navigationController?.popViewController(animated: true)
        }
        else
        {
            let userSelectedList = doneButtonAction()
            BL_TPStepper.sharedInstance.insertTPSelectedDoctorDetails(selectedDoctorsList: userSelectedList)
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: TPStepperViewController.self){
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }
    }
    
    @objc func refreshAction()
    {
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: "Loading customer data...")
            
            BL_MasterDataDownload.sharedInstance.downloadCustomerData(masterDataGroupName: EMPTY, completion: { (status) in
                removeCustomActivityView()
                
                if status == SERVER_SUCCESS_CODE
                {
                    self.setDefaults()
                    AlertView.showAlertView(title: "SUCCESS", message: "\(appDoctor) data are downloaded successfully")
                }
                else
                {
                    showToastView(toastText: "Unable to load the customer data")
                }
            })
        }
        else
        {
            showToastView(toastText: internetOfflineMessage)
        }
    }
    
    
    func doneButtonAction() -> [CustomerMasterModel]
    {
        
        let filtered = doctorMasterList.filter{
            $0.isSelected == true
        }
        
        return filtered
    }
    // private func toggleTickButton(list : CustomerMasterModel)
    private func toggleTickButton()
    {
        if(!isfromnotes)
        {
            self.navigationItem.rightBarButtonItems = [refreshBtn]
        }
        let filtered = doctorMasterList.filter{
            $0.isSelected == true
        }
        if (filtered.count > 0 )
        {
            if(isfromnotes)
            {
                self.navigationItem.rightBarButtonItems = [nextBtn]
            }
            else
            {
                self.navigationItem.rightBarButtonItems = [refreshBtn, nextBtn]
            }
        }
        
    }
    
    func filterSelectedList()
    {
        
        
        if (TPModel.sharedInstance.tpStatus == 3){
            let selectedList = BL_TPStepper.sharedInstance.getTPSelectedDoctorDetails(TP_Entry_Id: TPModel.sharedInstance.tpEntryId) as [TourPlannerDoctor]
            if(selectedList.count != 0)
            {
                for objHeader in selectedList
                {
                    let filteredContent = doctorMasterList.filter{
                        $0.Customer_Code == objHeader.Doctor_Code && $0.Region_Code == objHeader.Doctor_Region_Code
                    }
                    if (filteredContent.count > 0)
                    {
                        filteredContent.first!.isReadOnly = true
                    }
                }
            }
        }
        else if (TPModel.sharedInstance.tpStatus == 0){
            //   let selectedList = BL_TPStepper.sharedInstance.getTPSelectedDoctorDetails1(tpdate : TPModel.sharedInstance.tpDate ) as [TourPlannerDoctor]
            let selectedList = BL_TPStepper.sharedInstance.getTPSelectedDoctorDetails(TP_Entry_Id: TPModel.sharedInstance.tpEntryId) as [TourPlannerDoctor]
            
            // selectedList.append(selectedList1)
            
            if(selectedList.count != 0)
            {
                for objHeader in selectedList
                {
                    let filteredContent = doctorMasterList.filter{
                        $0.Customer_Code == objHeader.Doctor_Code && $0.Region_Code == objHeader.Doctor_Region_Code
                    }
                    if (filteredContent.count > 0)
                    {
                        filteredContent.first!.isReadOnly = true
                    }
                }
            }
        }
        else{
            let selectedList = BL_TPStepper.sharedInstance.getTPSelectedDoctorDetails1(tpdate : TPModel.sharedInstance.tpDate ) as [TourPlannerDoctor]
            if(selectedList.count != 0)
            {
                for objHeader in selectedList
                {
                    let filteredContent = doctorMasterList.filter{
                        $0.Customer_Code == objHeader.Doctor_Code && $0.Region_Code == objHeader.Doctor_Region_Code
                    }
                    if (filteredContent.count > 0)
                    {
                        filteredContent.first!.isReadOnly = true
                    }
                }
            }
        }
        
        
    }
    
    func syncRefreshDate()
    {
        let apiModel = BL_TPStepper.sharedInstance.getLastSyncDate(apiName: ApiName.CustomerData.rawValue)
        
        if(apiModel != nil)
        {
            if(apiModel.Download_Date != nil)
            {
                let date = convertDateIntoLocalDateString(date: apiModel.Download_Date)
                let time = stringFromDate(date1: apiModel.Download_Date)
                self.refreshLabel.text = "Last Modified: \(date) \(time)"
                self.refreshLabelHeightConst.constant = 16
                
                
            }
            else
            {
                self.refreshLabelHeightConst.constant = 0
                
            }
        }
    }
}

protocol ChildViewControllerDelegate
{
    func childViewControllerResponse(parameter: [CustomerMasterModel])
}
