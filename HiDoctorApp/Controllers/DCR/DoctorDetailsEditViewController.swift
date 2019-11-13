//
//  DoctorDetailsEditViewController.swift
//  HiDoctorApp
//
//  Created by Vijay on 05/01/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class DoctorDetailsEditViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,DocumentDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate{
    
    @IBOutlet weak var emptyStateWrapper: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var tableViewHgtConst: NSLayoutConstraint!
    @IBOutlet weak var btmWrapper: UIView!
    @IBOutlet weak var btmWrapperHeightConst: NSLayoutConstraint!
    var doneToolbar = UIToolbar()
    var doctorDataList : [DoctorListModel] = []
    var profileImgUrl : String!
    var isEmptyState: Bool = false
    var locationAlertCount: Int = 0
    let picker = UIDatePicker()
    var dueDate : String?
    var done : UIBarButtonItem!
    let iCloudObserver = "iCloudObserverForDoctor"
    var pickerView = UIPickerView()
    var pickerView1 = UIPickerView()
    var selectedIndex = Int()
    var categoryCode = String()
    var specialityCode = String()
    var fromPicker = Bool()
    var numberAlertString = String()
    var textAlertString = String()
    var getPickerValue = Bool()
    var dobServerDate : String?
    var anniversaryServerDate : String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: Constants.NibNames.DoctorDetailEditCell, bundle: nil), forCellReuseIdentifier: Constants.TableViewCellIdentifier.DoctorListEditDetailsCell)
        hideKeyboardWhenTappedAround()
        self.iCloudAttachObserver()
        //Add Submit Button
        done = UIBarButtonItem(title: "SAVE", style: .plain, target: self, action: #selector(self.submitDetails(sender:)))
        self.navigationItem.rightBarButtonItems = [done]
        
        self.navigationController?.navigationBar.topItem?.title = " "
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView1.delegate = self
        self.pickerView1.dataSource = self
        
        BL_DoctorList.sharedInstance.selectedImageData = NSData()
        BL_DoctorList.sharedInstance.doctorDataList = []
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        loadDefaultData()
    }
    
    func loadDefaultData()
    {
        if self.view != nil
        {
            self.tableView.estimatedRowHeight = 200
            self.setDoctorProfileImg()
            
            self.title = BL_DoctorList.sharedInstance.doctorTitle
            
            self.setDefaultDetails()
            
            if isEmptyState == false
            {
                scrollView.isHidden = false
                emptyStateWrapper.isHidden = true
            }
            else
            {
                scrollView.isHidden = true
                emptyStateWrapper.isHidden = false
            }
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    //MARK:- Cloud Attachment
    func iCloudAttachObserver()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(MessageComposeViewController.iCloudObserverAction(_:)), name: NSNotification.Name(rawValue: iCloudObserver), object: nil)
    }
    
    func iCloudObserverAction(_ notification: NSNotification)
    {
        if(BL_DoctorList.sharedInstance.selectedImageData.length > 0)
        {
            profilePic.image = UIImage(data: (BL_DoctorList.sharedInstance.selectedImageData as NSData) as Data)
            
        }
        else
        {
            self.profilePic.image = UIImage(named: "profile-placeholder-image")
        }
    }
    
    //MARK:- TableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return doctorDataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
        
    {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let footer = UIView()
        footer.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        return footer
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.DoctorListDetailsSectionCell) as! DoctorListSectionTableViewCell
        
        let obj = doctorDataList[section]
        
        cell.sectionNameLbl.text = obj.sectionTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return doctorDataList[section].dataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.DoctorListEditDetailsCell, for: indexPath) as! DoctorDetailEditTableViewCell
        
        let cell1 = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.DoctorListDetailsCell, for: indexPath) as! DoctorDetailsListTableViewCell
        
        
        let obj = doctorDataList[indexPath.section].dataList[indexPath.row]
        
        if(obj.isEditable)
        {
            picker.datePickerMode = .date
            
            doneToolbar = UIToolbar()
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            doneToolbar.sizeToFit()
            var done: UIBarButtonItem = UIBarButtonItem()
            
            done = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.fromPickerDoneAction(sender:)))
            let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.cancelBtnClicked))
            
            done.tag = indexPath.section * 1000 + indexPath.row
            
            doneToolbar.items = [flexSpace, done, cancel]
            
            if(obj.controlType == controlValues.Date)
            {
                cell.editTxtField.inputView = picker
                cell.editTxtField.inputAccessoryView = doneToolbar
            }
            else if(obj.controlType == controlValues.Number)
            {
                cell.editTxtField.keyboardType = .numberPad
                cell.editTxtField.tag = indexPath.section * 1000 + indexPath.row
                cell.editTxtField.addTarget(self, action: #selector(self.textFieldEndEditing(sender:)), for: .editingDidEnd)
            }
            else if(obj.controlType == controlValues.Picker)
            {
                if(obj.headerTitle == "Position")
                {
                    cell.editTxtField.inputView = pickerView
                }
                else if(obj.headerTitle == "Category Name")
                {
                    cell.editTxtField.inputView = pickerView1
                }
                
                cell.editTxtField.inputAccessoryView = doneToolbar
            }
            else if(obj.controlType == controlValues.Text)
            {
                if(obj.headerTitle == "Email Id")
                {
                    cell.editTxtField.keyboardType = .emailAddress
                }
                else
                {
                    cell.editTxtField.keyboardType = .asciiCapable
                }
                cell.editTxtField.tag = indexPath.section * 1000 + indexPath.row
                cell.editTxtField.addTarget(self, action: #selector(self.textFieldEndEditing(sender:)), for: .editingDidEnd)
            }
            let getNewValue = obj.newValue
            if(getNewValue != EMPTY || getNewValue != nil)
            {
                cell.editTxtField.text = obj.newValue
            }
            
            cell.titleLbl.text = obj.headerTitle
            
            return cell
        }
        else
        {
            if(indexPath.section == 0)
            {
                var description : String = NOT_APPLICABLE
                
                if obj.value != ""
                {
                    description = obj.value
                }
                
                cell1.headerNameLbl.text = obj.headerTitle
                cell1.descriptionLbl.text = description
                
                if indexPath.row == doctorDataList[indexPath.section].dataList.count - 1
                {
                    cell1.sepView.isHidden = true
                    let maskPathBottom  = UIBezierPath(roundedRect: cell1.outerView.bounds, byRoundingCorners: [.bottomLeft,.bottomRight] ,cornerRadii: CGSize(width: 10, height: 10))
                    let shapeLayerBottom = CAShapeLayer()
                    shapeLayerBottom.frame = cell1.outerView.bounds
                    shapeLayerBottom.path = maskPathBottom.cgPath
                    cell1.outerView.layer.mask = shapeLayerBottom
                }
            }
            return cell1
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        reloadTableView()
    }
    
    func setDefaultDetails()
    {
        if(BL_DoctorList.sharedInstance.doctorDataList.count > 0)
        {
            doctorDataList = BL_DoctorList.sharedInstance.doctorDataList
        }
        else
        {
            doctorDataList = BL_DoctorList.sharedInstance.getDoctorDataList(isEdit: true)
            doctorDataList[0].dataList = BL_DoctorList.sharedInstance.getDoctorOfficialDetailsForEdit()
            doctorDataList[1].dataList = BL_DoctorList.sharedInstance.getDoctorPersonalDetailsListForEdit()
            doctorDataList[2].dataList = BL_DoctorList.sharedInstance.getDoctorHospitalDetailsListForEdit()
            doctorDataList[3].dataList = BL_DoctorList.sharedInstance.getDoctorOtherDetailsForEdit()
        }
        
        if self.tableView != nil
        {
            self.tableView.reloadData()
        }
        
        if(doctorDataList[1].dataList[0].newValue != NOT_APPLICABLE)
        {
            dobServerDate = convertDateFormater(doctorDataList[1].dataList[0].newValue)
        }
        if(doctorDataList[1].dataList[1].newValue != NOT_APPLICABLE)
        {
            anniversaryServerDate = convertDateFormater(doctorDataList[1].dataList[1].newValue)
        }
    }
    
    //MARK:- Reload TableView
    func reloadTableView()
    {
        self.tableView.layoutIfNeeded()
        self.tableViewHgtConst.constant = tableView.contentSize.height
    }
    
    func setDoctorProfileImg()
    {
        if(BL_DoctorList.sharedInstance.selectedImageData.length > 0)
        {
            profilePic.image = UIImage(data: (BL_DoctorList.sharedInstance.selectedImageData as NSData) as Data)
            
        }
        else
        {
            profileImgUrl = BL_DoctorList.sharedInstance.getDoctorProfileImgUrlForEdit()
            if profileImgUrl != ""
            {
                
                let imageUrl = profileImgUrl.components(separatedBy: "/")
                BL_DoctorList.sharedInstance.selectedImage = []
                BL_DoctorList.sharedInstance.selectedImageData = NSData()
                if (checkInternetConnectivity())
                {
                    ImageLoader.sharedLoader.imageForUrl(urlString: profileImgUrl) {(image) in
                        
                        if(image != nil)
                        {
                            self.profilePic.image = image
                            let imageData = UIImagePNGRepresentation(image!)
                            BL_DoctorList.sharedInstance.selectedImage.append(imageUrl.last!)
                            BL_DoctorList.sharedInstance.selectedImageData = imageData! as NSData
                        }
                        else
                        {
                            self.profilePic.image = UIImage(named: "profile-placeholder-image")
                        }
                    }
                }
                else
                {
                    
                    let imageName = imageUrl.last!
                    let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
                    let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
                    let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
                    if let dirPath          = paths.first
                    {
                        let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(Constants.DirectoryFolders.doctorProfileFolder+"/\(imageName)")
                        
                        self.profilePic.image = UIImage(contentsOfFile: imageURL.path)
                    }
                    
                }
            }
            else
            {
                self.profilePic.image = UIImage(named: "profile-placeholder-image")
            }
        }
        
    }
    
    //MARK:-Get IndexPath from textFiels after end editing
    @objc func textFieldEndEditing(sender: UITextField)
    {
        let section = sender.tag/1000
        let row = sender.tag%1000
        if(!self.fromPicker)
        {
            self.doctorDataList[section].dataList[row].newValue = sender.text!
        }
        self.fromPicker = false
    }
    
    //MARK:- CustomNavigationBack Button and Action
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
    
    //MARK:- Submit Button Action
    @objc func submitDetails(sender: UIBarButtonItem)
    {
        if checkInternetConnectivity()
        {
            self.view.endEditing(true)
            var successValue = Int()
            self.textAlertString = EMPTY
            self.numberAlertString = EMPTY
            var errorMsg: String = EMPTY
            
            outer : for (index, doctorList) in doctorDataList.enumerated()
            {
                for data in doctorList.dataList
                {
                    let fieldName = data.headerTitle
                    errorMsg = EMPTY
                    
                    if (fieldName == "\(appDoctor) Name")
                    {
                        errorMsg = doValidations(objDoctorDataListModel: data, validationType: Constants.Validation_Type.Alphabet_And_Space, minLength: 3, maxLength: 100)
                    }
                    else if (fieldName == "Position")
                    {
                        if (data.isMandatory && (data.newValue == EMPTY || data.newValue == specialityDefaults))
                        {
                            errorMsg = "Please choose Position"
                        }
                    }
                    else if (fieldName == ccmNumberCaption)
                    {
                        errorMsg = doValidations(objDoctorDataListModel: data, validationType: Constants.Validation_Type.AlphaNumeric_And_Space, minLength: 1, maxLength: 50)
                    }
                    else if (fieldName == "Category Name")
                    {
                        if (data.isMandatory && (data.newValue == EMPTY || data.newValue == categoryDefaults))
                        {
                            errorMsg = "Please choose category"
                        }
                    }
                    else if (fieldName == "Email Id")
                    {
                        errorMsg = doValidations(objDoctorDataListModel: data, validationType: Constants.Validation_Type.Email, minLength: 6, maxLength: 100)
                    }
                    else if (fieldName == "Date of Birth")
                    {
                        if (data.isMandatory && data.newValue == EMPTY)
                        {
                            errorMsg = "Please choose Date of Birth"
                        }
                    }
                    else if (fieldName == "Anniversary Date")
                    {
                        if (data.isMandatory && data.newValue == EMPTY)
                        {
                            errorMsg = "Please choose Anniversary Date"
                        }
                    }
                    else if (fieldName == "Phone Number")
                    {
                        errorMsg = doValidations(objDoctorDataListModel: data, validationType: Constants.Validation_Type.Phone_Number, minLength: 10, maxLength: 10)
                    }
                    else if (fieldName == "Alternate Phone Number")
                    {
                        errorMsg = doValidations(objDoctorDataListModel: data, validationType: Constants.Validation_Type.Phone_Number, minLength: 10, maxLength: 10)
                    }
                    else if (fieldName == "Registration Number")
                    {
                        errorMsg = doValidations(objDoctorDataListModel: data, validationType: Constants.Validation_Type.All_Except_Spl_Chars, minLength: 3, maxLength: 30)
                    }
                    else if (fieldName == "Assistant Phone Number")
                    {
                        errorMsg = doValidations(objDoctorDataListModel: data, validationType: Constants.Validation_Type.Phone_Number, minLength: 10, maxLength: 10)
                    }
                    else if (fieldName == "\(PEV_HOSPITAL_NAME)")
                    {
                        errorMsg = doValidations(objDoctorDataListModel: data, validationType: Constants.Validation_Type.AlphaNumeric_And_Space, minLength: 3, maxLength: 100)
                    }
                    else if (fieldName == "\(PEV_HOSPITAL_ADDRESS)")
                    {
                        errorMsg = doValidations(objDoctorDataListModel: data, validationType: Constants.Validation_Type.All_Except_Spl_Chars, minLength: 3, maxLength: 500)
                    }
                    else if (fieldName == "Notes")
                    {
                        errorMsg = doValidations(objDoctorDataListModel: data, validationType: Constants.Validation_Type.All_Except_Spl_Chars, minLength: 3, maxLength: 500)
                    }
                    
                    if (errorMsg != EMPTY)
                    {
                        break outer
                    }
                }
                successValue = index
            }
            
            self.tableView.reloadData()
            
            if(errorMsg != EMPTY)
            {
                AlertView.showAlertView(title: alertTitle, message: errorMsg)
            }
            else if(successValue == doctorDataList.count - 1 && errorMsg == EMPTY)
            {
                customActivityIndicatory(self.view, startAnimate: true, viewController: self)
                self.view.isUserInteractionEnabled = false
                var specialityName = String()
                var specialityCode = String()
                var categoryName = String()
                var categoryCode = String()
                
                if(specialityDefaults == checkNullAndNilValueForString(stringData:doctorDataList[0].dataList[3].newValue))
                {
                    specialityName = EMPTY
                    specialityCode = EMPTY
                }
                else
                {
                    specialityName = checkNullAndNilValueForString(stringData:doctorDataList[0].dataList[3].newValue)
                    specialityCode = checkNullAndNilValueForString(stringData:doctorDataList[0].dataList[3].Code_Value)
                }
                
                if(categoryDefaults == checkNullAndNilValueForString(stringData:doctorDataList[0].dataList[4].newValue))
                {
                    categoryName = EMPTY
                    categoryCode = EMPTY
                }
                else
                {
                    categoryName = checkNullAndNilValueForString(stringData:doctorDataList[0].dataList[4].newValue)
                    categoryCode = checkNullAndNilValueForString(stringData:doctorDataList[0].dataList[4].Code_Value)
                }
                
                let dobDate = dobServerDate
                let anniversaryDate = anniversaryServerDate
                
                if(anniversaryDate == nil || anniversaryDate == EMPTY)
                {
                    anniversaryServerDate = EMPTY
                }
                if(dobDate == nil || dobDate == EMPTY)
                {
                    dobServerDate = EMPTY
                }
                
                var photoUrlValue = String()
                
                if(profileImgUrl != EMPTY)
                {
                    photoUrlValue = profileImgUrl
                }
                else
                {
                    photoUrlValue = EMPTY
                }
                
                let imageData = BL_DoctorList.sharedInstance.selectedImageData
                
                var personalInfo: NSMutableDictionary = ["Category_Code":categoryCode,"Category_Name":categoryName,"Customer_Code":checkNullAndNilValueForString(stringData:doctorDataList[0].dataList[0].Code_Value),"Customer_Entity_Type":"DOCTOR","Customer_Id":"0","Customer_Name":checkNullAndNilValueForString(stringData:doctorDataList[0].dataList[0].newValue),"Customer_Status":Int(doctorDataList[0].dataList[2].Code_Value)!,"Hospital_Name": checkNullAndNilValueForString(stringData:doctorDataList[2].dataList[0].newValue),"Hospital_Address":checkNullAndNilValueForString(stringData:doctorDataList[2].dataList[1].newValue),"MDL_Number":checkNullAndNilValueForString(stringData:doctorDataList[0].dataList[4].newValue),"Region_Code":checkNullAndNilValueForString(stringData:doctorDataList[0].dataList[1].Code_Value),"Region_Name":checkNullAndNilValueForString(stringData:doctorDataList[0].dataList[1].value),"Speciality_Code":specialityCode,"Speciality_Name":specialityName,"Alternate_No":checkNullAndNilValueForString(stringData:doctorDataList[1].dataList[4].newValue),"Anniversary_Date":anniversaryServerDate ?? "","Assistant_No":checkNullAndNilValueForString(stringData:doctorDataList[1].dataList[6].newValue),"DOB":dobServerDate ?? "","Email_Id":checkNullAndNilValueForString(stringData:doctorDataList[1].dataList[2].newValue),"Notes":checkNullAndNilValueForString(stringData:doctorDataList[3].dataList[0].newValue),"Phone_No":checkNullAndNilValueForString(stringData:doctorDataList[1].dataList[3].newValue),"Photo_URL":checkNullAndNilValueForString(stringData: photoUrlValue),"Registration_No":checkNullAndNilValueForString(stringData:doctorDataList[1].dataList[5].newValue)]
                
                personalInfo = replaceEmptyStringToNullValues(combinedAttributes: personalInfo)
                
                var fileName = String()
                if(BL_DoctorList.sharedInstance.selectedImage.count > 0)
                {
                    fileName = BL_DoctorList.sharedInstance.selectedImage[0]
                }
                else
                {
                    fileName = EMPTY
                }
                
                BL_DoctorList.sharedInstance.doctorPhotoUpload(getFileData: imageData, filePath: fileName, outputFilename: fileName, attachmentInfo: personalInfo as! [String : Any], completion: { (responseCode) in
                    customActivityIndicatory(self.view, startAnimate: false, viewController: self)
                    self.view.isUserInteractionEnabled = true
                    BL_DoctorList.sharedInstance.selectedImageData = NSData()
                    BL_DoctorList.sharedInstance.selectedImage = []
                    
                    if(responseCode == SERVER_SUCCESS_CODE)
                    {
                        BL_DoctorList.sharedInstance.selectedImageData = NSData()
                        BL_DoctorList.sharedInstance.selectedImage = []
                        
                        let alertViewController = UIAlertController(title: alertTitle, message: "\(appDoctor) updated successfully", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
                            _ = self.navigationController?.popViewController(animated: true)
                            alertViewController.dismiss(animated: true, completion: nil)
                        }))
                        
                        self.present(alertViewController, animated: true, completion: nil)
                    }
                    else if(responseCode == SERVER_ERROR_CODE)
                    {
                        AlertView.showAlertView(title: alertTitle, message: "Sorry unable to upload", viewController: self)
                    }
                    else
                    {
                        AlertView.showAlertView(title: alertTitle, message: "Please check connection", viewController: self)
                    }
                })
            }
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    
    private func doFormValidations(objDoctorDataListModel: DoctorDataListModel) -> String
    {
        let errorMsg: String = EMPTY
        
        return errorMsg
    }
    
    private func isEmpty(fieldName: String,  stringData: String) -> String
    {
        let newValue = condenseWhitespace(stringValue: stringData)
        var errorMsg: String = EMPTY
        
        if (newValue == EMPTY)
        {
            errorMsg = "Please enter \(fieldName)"
        }
        
        return errorMsg
    }
    
    private func doMaxLengthValidation(fieldName: String, maxLength: Int, stringData: String) -> String
    {
        let newValue = condenseWhitespace(stringValue: stringData)
        var errorMsg: String = EMPTY
        
        if (newValue.count > maxLength)
        {
            errorMsg = "\(fieldName) can't exceed \(maxLength) characters"
        }
        
        return errorMsg
    }
    
    private func doMinimumLengthValidation(fieldName: String, minLength: Int, stringData: String) -> String
    {
        let newValue = condenseWhitespace(stringValue: stringData)
        var errorMsg: String = EMPTY
        
        if (newValue.count < minLength)
        {
            errorMsg = "\(fieldName) should have minimum of \(minLength) characters"
        }
        
        return errorMsg
    }
    
    private func doAlphabetValidations(fieldName: String, stingData: String) -> String
    {
        var errorMsg: String = EMPTY
        
        if (stingData != EMPTY)
        {
            if (!isOnlyAlphabet(stringData: stingData))
            {
                errorMsg = "\(fieldName) should contain only alphabets"
            }
        }
        
        return errorMsg
    }
    
    private func dlAlphabetAndSpaceValidations(fieldName: String, stingData: String) -> String
    {
        var errorMsg: String = EMPTY
        
        if (stingData != EMPTY)
        {
            if (!isAlphabetAndSpace(stringData: stingData))
            {
                errorMsg = "\(fieldName) should contain only alphabets and space"
            }
        }
        
        return errorMsg
    }
    
    private func doAlphaNumericValidations(fieldName: String, stingData: String) -> String
    {
        var errorMsg: String = EMPTY
        
        if (stingData != EMPTY)
        {
            if (!isAlphaNumeric(stringData: stingData))
            {
                errorMsg = "\(fieldName) should contain only alphabets and numbers"
            }
        }
        
        return errorMsg
    }
    
    private func doAlphaNumericAndSpaceValidations(fieldName: String, stingData: String) -> String
    {
        var errorMsg: String = EMPTY
        
        if (stingData != EMPTY)
        {
            if (!isAlphaNumericAndSpace(stringData: stingData))
            {
                errorMsg = "\(fieldName) should contain only alphabets, numbers and space"
            }
        }
        
        return errorMsg
    }
    
    private func doEmailIdValidations(fieldName: String, stingData: String) -> String
    {
        var errorMsg: String = EMPTY
        
        if (stingData != EMPTY)
        {
            if (!isValidEmail(stringData: stingData))
            {
                errorMsg = "Invalid email id"
            }
        }
        
        return errorMsg
    }
    
    private func doPhoneNumnerValidations(fieldName: String, stingData: String) -> String
    {
        var errorMsg: String = EMPTY
        
        if (stingData != EMPTY)
        {
            if (!isNumericOnly(stringData: stingData))
            {
                errorMsg = "Invalid \(fieldName)"
            }
            
            if (errorMsg == EMPTY && stingData.count != 10)
            {
                errorMsg = "\(fieldName) must be 10 digits"
            }
        }
        
        return errorMsg
    }
    
    private func doSpecialCharactersValidations(fieldName: String, stingData: String) -> String
    {
        var errorMsg: String = EMPTY
        let restrictedChatacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
        
        if (restrictedChatacter != EMPTY && stingData != EMPTY)
        {
            if (checkIfSpecialCharacterFound(restrictedCharacter: restrictedChatacter, remarkTxt: fieldName))
            {
                errorMsg = String(format: "%@ characters restricted for %@", restrictedChatacter, fieldName)
            }
        }
        
        return errorMsg
    }
    
    private func doValidations(objDoctorDataListModel: DoctorDataListModel, validationType: Int, minLength: Int, maxLength: Int) -> String
    {
        var errorMsg: String = EMPTY
        let valueToCompare = objDoctorDataListModel.newValue
        let fieldName = objDoctorDataListModel.headerTitle!
        
        if (objDoctorDataListModel.isMandatory)
        {
            errorMsg = isEmpty(fieldName: fieldName, stringData: valueToCompare)
        }
        
        if (errorMsg == EMPTY)
        {
            if (validationType == Constants.Validation_Type.Alphabet_Only)
            {
                errorMsg = doAlphabetValidations(fieldName: fieldName, stingData: valueToCompare)
            }
            else if (validationType == Constants.Validation_Type.Alphabet_And_Space)
            {
                errorMsg = dlAlphabetAndSpaceValidations(fieldName: fieldName, stingData: valueToCompare)
            }
            else if (validationType == Constants.Validation_Type.AlphaNumeric)
            {
                errorMsg = doAlphaNumericValidations(fieldName: fieldName, stingData: valueToCompare)
            }
            else if (validationType == Constants.Validation_Type.AlphaNumeric_And_Space)
            {
                errorMsg = doAlphaNumericAndSpaceValidations(fieldName: fieldName, stingData: valueToCompare)
            }
            else if (validationType == Constants.Validation_Type.Email)
            {
                errorMsg = doEmailIdValidations(fieldName: fieldName, stingData: valueToCompare)
            }
            else if (validationType == Constants.Validation_Type.Phone_Number)
            {
                errorMsg = doPhoneNumnerValidations(fieldName: fieldName, stingData: valueToCompare)
            }
        }
        
        if (errorMsg == EMPTY)
        {
            errorMsg = doSpecialCharactersValidations(fieldName: fieldName, stingData: valueToCompare)
        }
        
        let trimData = condenseWhitespace(stringValue: valueToCompare)
        
        if (errorMsg == EMPTY && minLength > 0 && trimData != EMPTY)
        {
            errorMsg = doMinimumLengthValidation(fieldName: fieldName, minLength: minLength, stringData: trimData)
        }
        
        if (errorMsg == EMPTY && maxLength > 0)
        {
            errorMsg = doMaxLengthValidation(fieldName: fieldName, maxLength: maxLength, stringData: trimData)
        }
        
        return errorMsg
    }
    
    private func replaceEmptyStringToNullValues(combinedAttributes: NSMutableDictionary) -> NSMutableDictionary
    {
        for (key, value) in combinedAttributes
        {
            if (value is String)
            {
                if (value as! String == EMPTY)
                {
                    combinedAttributes.setValue(NSNull(), forKey: key as! String)
                }
            }
        }
        
        return combinedAttributes
    }
    
    //MARK:- Keyboard Action
    @objc func keyboardWillShow(notification: NSNotification)
    {
        if ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil
        {
            //self.view.frame.origin.y -= keyboardSize.height
            var userInfo = notification.userInfo!
            var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            keyboardFrame = self.view.convert(keyboardFrame, from: nil)
            
            var contentInset:UIEdgeInsets = self.tableView.contentInset
            contentInset.bottom = keyboardFrame.size.height+160
            self.scrollView.contentInset = contentInset
            self.tableView.contentInset = contentInset
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        let contentInsets = UIEdgeInsets.zero
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        //self.tableView.reloadData()
    }
    
    //MARK:- DatePicker done and cancel action
    @objc func fromPickerDoneAction(sender: UIBarButtonItem)
    {
        self.fromPicker = true
        let section = sender.tag/1000
        let row = sender.tag%1000
        //let indexPath = IndexPath(row: row, section: section)
        if(doctorDataList[section].dataList[row].controlType == controlValues.Date)
        {
            dueDate = convertDateInRequiredFormat(date: picker.date, format: defaultDateFomat)
            doctorDataList[section].dataList[row].newValue = dueDate!
            if(section == 1 && row == 0)
            {
                let dobDate = convertDateInRequiredFormat(date: picker.date, format: defaultServerDateFormat)
                dobServerDate = dobDate
            }
            else if(section == 1 && row == 1)
            {
                let anniDate = convertDateInRequiredFormat(date: picker.date, format: defaultServerDateFormat)
                anniversaryServerDate = anniDate
            }
            // self.tableView.reloadRows(at: [indexPath], with: .none)
            self.tableView.reloadData()
        }
        else if(doctorDataList[section].dataList[row].controlType == controlValues.Picker)
        {
            if(doctorDataList[section].dataList[row].headerTitle == "Position")
            {
                let name = BL_DoctorList.sharedInstance.customerSpecialityArray.value(forKey: "Speciality_Name") as! NSArray
                let code = BL_DoctorList.sharedInstance.customerSpecialityArray.value(forKey: "Speciality_Code") as! NSArray
                let specialityName = name[selectedIndex] as! String
                let specialityCode = code[selectedIndex] as! String
                doctorDataList[section].dataList[row].newValue = specialityName
                doctorDataList[section].dataList[row].Code_Value = specialityCode
                self.categoryCode = code[selectedIndex] as! String
                self.tableView.reloadData()
                // self.tableView.reloadRows(at: [indexPath], with: .none)
                
            }
            else
            {
                let name = BL_DoctorList.sharedInstance.customerCategoryArray.value(forKey: "Category_Name") as! NSArray
                let code = BL_DoctorList.sharedInstance.customerCategoryArray.value(forKey: "Category_Code") as! NSArray
                let categoryName = name[selectedIndex] as! String
                let categoryCode = code[selectedIndex] as! String
                doctorDataList[section].dataList[row].newValue = categoryName
                doctorDataList[section].dataList[row].Code_Value = categoryCode
                self.specialityCode = code[selectedIndex] as! String
                self.tableView.reloadData()
                //self.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
        
        self.view.endEditing(true)
        self.fromPicker = false
    }
    
    @objc func cancelBtnClicked()
    {
        self.view.endEditing(true)
    }
    
    @IBAction func pickImageBut(_ sender: UIButton)
    {
        self.view.endEditing(true)
        Attachment.sharedInstance.showAttachmentActionSheet(viewController: self)
        Attachment.sharedInstance.delegate = self
        Attachment.sharedInstance.isFromEditDoctor = true
        BL_DoctorList.sharedInstance.selectedImage = []
        BL_DoctorList.sharedInstance.doctorDataList = doctorDataList
    }
    
    func saveImageToDirectory()
    {
        _ = BL_DoctorList.sharedInstance.writeFile(fileData: BL_DoctorList.sharedInstance.selectedImageData as Data, blobUrl: BL_DoctorList.sharedInstance.selectedImage[0])
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if(pickerView == self.pickerView)
        {
            if(BL_DoctorList.sharedInstance.customerSpecialityArray.count == 0)
            {
                if(!getPickerValue)
                {
                    self.pickerView.isHidden = true
                    self.getPickerValue = true
                    self.getSpecialityAndCategory()
                }
            }
            return BL_DoctorList.sharedInstance.customerSpecialityArray.count
        }
        else
        {
            if(BL_DoctorList.sharedInstance.customerCategoryArray.count == 0)
            {
                if(!getPickerValue)
                {
                    self.pickerView1.isHidden = true
                    self.getPickerValue = true
                    self.getSpecialityAndCategory()
                }
            }
            
            return BL_DoctorList.sharedInstance.customerCategoryArray.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if(pickerView == self.pickerView)
        {
            let name = BL_DoctorList.sharedInstance.customerSpecialityArray.value(forKey: "Speciality_Name") as! NSArray
            return name[row] as? String
        }
        else
        {
            let name = BL_DoctorList.sharedInstance.customerCategoryArray.value(forKey: "Category_Name") as! NSArray
            return name[row] as? String
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.selectedIndex = row
    }
    
    func getSpecialityAndCategory()
    {
        showCustomActivityIndicatorView(loadingText: "Loading Data..")
        if checkInternetConnectivity()
        {
            self.getPickerValue = false
            BL_DoctorList.sharedInstance.getCustomerCategoryNameList(regionCode: CustomerModel.sharedInstance.regionCode, completion: { (objResponse) in
                if objResponse.Status == SERVER_SUCCESS_CODE
                {
                    removeCustomActivityView()
                    BL_DoctorList.sharedInstance.customerCategoryArray = NSMutableArray()
                    let dict : NSDictionary = [ "Category_Code":"0","Category_Name" : categoryDefaults]
                    BL_DoctorList.sharedInstance.customerCategoryArray.add(dict)
                    let categoryListValue = objResponse.list!
                    for categoryValue in categoryListValue
                    {
                        BL_DoctorList.sharedInstance.customerCategoryArray.add(categoryValue)
                    }
                    self.pickerView.isHidden = false
                    self.pickerView.reloadAllComponents()
                }
                else
                {
                    
                }
            })
            
            BL_DoctorList.sharedInstance.getSpecialityNameList(completion: { (objResponse) in
                if objResponse.Status == SERVER_SUCCESS_CODE
                {
                    removeCustomActivityView()
                    BL_DoctorList.sharedInstance.customerSpecialityArray = NSMutableArray()
                    let dict : NSDictionary = [ "Speciality_Code":"0","Speciality_Name" : specialityDefaults]
                    BL_DoctorList.sharedInstance.customerSpecialityArray.add(dict)
                    let specialityListValue = objResponse.list!
                    for specialityValue in specialityListValue
                    {
                        BL_DoctorList.sharedInstance.customerSpecialityArray.add(specialityValue)
                    }
                    self.pickerView1.isHidden = false
                    self.pickerView1.reloadAllComponents()
                }
                else
                {
                    
                }
                
            })
        }
        else
        {
            self.getPickerValue = false
            self.view.endEditing(true)
            self.doneToolbar.isHidden = true
            /* removeCustomActivityView()
             self.fromPicker = true*/
            removeCustomActivityView()
            showToastView(toastText: "Please Check your connection")
        }
    }
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = defaultDateFomat
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = defaultServerDateFormat
        return  dateFormatter.string(from: date!)
        
    }
}


