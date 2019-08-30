//
//  TPTravelDetailsViewController.swift
//  HiDoctorApp
//
//  Created by Admin on 7/26/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class TPTravelDetailsViewController: UIViewController , UITextFieldDelegate, UIPickerViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var fromPlaceField: UITextField!
    @IBOutlet weak var toPlaceField: UITextField!
    @IBOutlet weak var travelModeLabel: UILabel!
    @IBOutlet weak var travelModeField: UITextField!
    @IBOutlet weak var fromPlacebtn: UIButton!
    
    var pickerView: UIPickerView!
    var selectedRow: Int = 0
    var travelModeList: [TravelModeMaster] = []
    var textfieldYoffset: CGFloat = 0.0
    var validTravelMode: Bool = false
    var fromPlace : String = ""
    var toPlace : String = ""
    var travelMode : String? = ""
    var sfcVersion : Int? = 0
    var sfcCategory : String? = ""
    var sfcRegionCode : String? = ""
    var distanceFareCode : String? = ""
    var distance : Float = 0.0
    var travelId : Int = 0
    var fromPlaceDisabled : Bool = false
    var validSFC : Bool!
    var initialToPlace : String!
    var isUpdatedSFC: Bool = false
    var sfcValidationVal: [String]!
    var modifyFromplaceFlag : Bool = false
    var isFromTPAttendance = false
    var isComingFromModify = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaults()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaults()
        setConfigValues()
    }
    
    func setConfigValues()
    {
        if fromPlace != ""
        {
            fromPlaceField.text = fromPlace
        }
        else
        {
            fromPlace = BL_TP_SFC.sharedInstance.fromPlace
            fromPlaceField.text = fromPlace
        }
        BL_TP_SFC.sharedInstance.fromPlace = fromPlace
        if toPlace != ""
        {
            toPlaceField.text = toPlace
        }
        else
        {
            toPlace = BL_TP_SFC.sharedInstance.toPlace
            toPlaceField.text = toPlace
        }
        BL_TP_SFC.sharedInstance.toPlace = toPlace
        
        if travelMode != "" && travelMode != "Select travel mode"
        {
            validTravelMode = true
            travelModeLabel.text = travelMode
            
        } else
        {
            validTravelMode = false
            travelModeLabel.text = "Select travel mode"
        }
        
        loadPickerview()
    }
    
    
    func setDefaults()
    {
        addBackButtonView()
        self.navigationItem.title = "Add Travel Place"
        
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(keyboardWillShow(_:)),
                           name: .UIKeyboardWillShow,
                           object: nil)
        
        center.addObserver(self,
                           selector: #selector(keyboardWillHide(_:)),
                           name: .UIKeyboardWillHide,
                           object: nil)
        
        let tapRecog = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tapRecog)
        
        travelModeList = DAL_TP_SFC.sharedInstance.getTravelModeList()!
        
        sfcValidationVal = BL_SFC.sharedInstance.getSFCValidationPrivVal()
        let travelledPlaces = DAL_TP_SFC.sharedInstance.getTravelledDetailList()
        
        if (travelledPlaces.count) > 0 && travelId == 0
        {
            fromPlace = (travelledPlaces.last?.To_Place)!
            if sfcValidationVal.contains(TPModel.sharedInstance.expenseEntityName)
            {
                fromPlaceDisabled = true
            }
            else
            {
                fromPlaceDisabled = false
            }
        }
        
        if travelId != 0 && modifyFromplaceFlag == true && sfcValidationVal.contains(TPModel.sharedInstance.expenseEntityName)
        {
            fromPlaceDisabled = true
        }
        
        initialToPlace = toPlace
        
        if isUpdatedSFC
        {
            showToastView(toastText: sfcUpdateToastMsg)
        }
    }
    
    // Keyboard notification methods
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if textfieldYoffset != 0.0
                {
                    let btmSpaceVal:CGFloat = self.view.frame.size.height - textfieldYoffset
                    if keyboardSize.height > btmSpaceVal {
                        UIView.animate(withDuration: 0.5, animations: {
                            
                        }, completion: { finished in
                        })
                    }
                }
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        if textfieldYoffset != 0.0
        {
            UIView.animate(withDuration: 0.5, animations: {
                
            }, completion: { finished in
            })
        }
    }
    
    
    
    // Common functions
    func loadPickerview()
    {
        pickerView = UIPickerView()
        pickerView.backgroundColor = UIColor.lightGray
        pickerView.delegate = self
        var selectedIndex : Int = 0
        if validTravelMode
        {
            for i in 0..<travelModeList.count
            {
                if travelModeList[i].Travel_Mode_Name == travelModeLabel.text
                {
                    selectedIndex = i
                }
            }
            
        }
        selectedRow = selectedIndex
        pickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
        let pickerToolbar = UIToolbar()
        let doneButton : UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneClicked))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        pickerToolbar.setItems([spaceButton, doneButton], animated: false)
        pickerToolbar.sizeToFit()
        
        //        if validTravelMode
        //        {
        //            travelModeField.isUserInteractionEnabled = false
        //        }
        //        else
        //        {
        //            travelModeField.isUserInteractionEnabled = true
        //        }
        
        travelModeField.inputView = pickerView
        travelModeField.inputAccessoryView = pickerToolbar
    }
    
    @objc func hideKeyboard()
    {
        self.view.endEditing(true)
    }
    
    @objc func doneClicked()
    {
        if selectedRow >= 0
        {
            if !validTravelMode
            {
                validTravelMode = true
            }
            travelModeLabel.text = travelModeList[selectedRow].Travel_Mode_Name
            
            if fromPlaceField.text != "" && toPlaceField.text != ""
            {
                let sfcList = BL_TP_SFC.sharedInstance.getSFCDetailsbasedOnTravelMode(fromPlace: fromPlaceField.text!, toPlace: toPlaceField.text!, travelMode: travelModeLabel.text!)
                if sfcList.count > 0
                {
                    validSFC = true
                    let model = sfcList[0]
                    sfcVersion = model.SFC_Version
                    var categoryName = ""
                    if model.Category_Name != nil
                    {
                        categoryName = model.Category_Name
                    }
                    sfcCategory = categoryName
                    sfcRegionCode = model.Region_Code
                    distanceFareCode = model.Distance_Fare_Code
                    distance = model.Distance
                }
                else
                {
                    validSFC = false
                    sfcVersion = 0
                    sfcCategory = ""
                    sfcRegionCode = getRegionCode()
                    distanceFareCode = ""
                    distance = 0.0
                }
            }
        }
        
        travelModeField.resignFirstResponder()
    }
    
    
    func navigateToNextscreen(tag: String)
    {
        if !BL_TP_SFC.sharedInstance.isAccompanistScreenHidden()
        {
            let sb = UIStoryboard(name: commonListSb, bundle: nil)
            let vc:UserListViewController = sb.instantiateViewController(withIdentifier: userListVcID) as! UserListViewController
            vc.navigationScreenName = tag
            self.navigationController?.pushViewController(vc, animated: true)
        } else
        {
            let loggedUserModel = getUserModelObj()
            let regionCode = loggedUserModel?.Region_Code
            let placeList = BL_TP_SFC.sharedInstance.convertToSFCPlaceModel(regionCode: regionCode!)
            let sb = UIStoryboard(name: commonListSb, bundle: nil)
            let vc:PlaceListViewController = sb.instantiateViewController(withIdentifier: placeListVcID) as! PlaceListViewController
            vc.navigationScreenname = tag
            vc.placeList = placeList!
            vc.getRegion = regionCode!
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    // Pickerview delegates
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return travelModeList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return travelModeList[row].Travel_Mode_Name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedRow = row
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return 36.0
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat
    {
        return SCREEN_WIDTH
    }
    
    // Button actions
    @IBAction func fromPlaceAction(_ sender: AnyObject)
    {
        if !fromPlaceDisabled
        {
            navigateToNextscreen(tag: addTPTravelFromPlace)
        }
    }
    
    @IBAction func toPlaceAction(_ sender: AnyObject)
    {
        navigateToNextscreen(tag: addTPTravelToPlace)
        
    }
    
    @IBAction func submitAction(_ sender: AnyObject)
    {
        if fromPlaceField.text == ""
        {
            AlertView.showAlertView(title: alertTitle, message: fromPlaceErrorMsg, viewController: self)
        }
        else if toPlaceField.text == ""
        {
            AlertView.showAlertView(title: alertTitle, message: toPlaceErrorMsg, viewController: self)
        }
        else if travelModeLabel.text == "Select travel mode"
        {
            AlertView.showAlertView(title: alertTitle, message: travelModeErrorMsg, viewController: self)
        }
        else
        {
            
            if validSFC == true
            {
                mineValidationCheck()
            }
            else
            {
                let statusMsg = BL_TP_SFC.sharedInstance.sfcValidationCheck(fromPlace: fromPlaceField.text!, toPlace: toPlaceField.text!, travelMode: travelModeLabel.text!)
                if statusMsg != ""
                {
                    AlertView.showAlertView(title: alertTitle, message: statusMsg, viewController: self)
                } else
                {
                    mineValidationCheck()
                }
                
            }
        }
    }
    
    private func mineValidationCheck()
    {
        let sfcValidationVal = BL_SFC.sharedInstance.getSFCValidationPrivVal()
        if sfcValidationVal.contains(TPModel.sharedInstance.expenseEntityName)
        {
            let sfcList = BL_TP_SFC.sharedInstance.getSFCDetailsbasedOnTravelMode(fromPlace: fromPlaceField.text!, toPlace: toPlaceField.text!, travelMode: travelModeLabel.text!)
            var validationErrorMsg : String = ""
            
            let noncatFilteredList = sfcList.filter {
                $0.Region_Code == getRegionCode() && $0.Category_Name != TPModel.sharedInstance.expenseEntityName
            }
            
            if noncatFilteredList.count > 0
            {
                validationErrorMsg = sfcMineValMsg
            }
            
            let catFilteredList = sfcList.filter {
                $0.Region_Code == getRegionCode() && $0.Category_Name == TPModel.sharedInstance.expenseEntityName
            }
            if catFilteredList.count > 0
            {
                validationErrorMsg = ""
            }
            
            if (self.sfcRegionCode != nil && self.sfcCategory != nil)
            {
                if (self.sfcRegionCode == getRegionCode())
                {
                    if (self.sfcCategory!.uppercased() != TPModel.sharedInstance.expenseEntityName.uppercased())
                    {
                        validationErrorMsg = sfcMineValMsg
                    }
                }
            }
            
            if validationErrorMsg != ""
            {
                AlertView.showAlertView(title: alertTitle, message: validationErrorMsg, viewController: self)
            }
            else
            {
                saveSFCDetails()
            }
        }
        else
        {
            saveSFCDetails()
        }
    }
    
    private func saveSFCDetails()
    {
        if travelId > 0
        {
            DAL_TP_SFC.sharedInstance.updateSFCDetails(fromPlace : fromPlaceField.text!, toPlace : toPlaceField.text!, distance : distance, distanceFareCode: distanceFareCode!, travelMode: travelModeLabel.text!, sfcVersion : sfcVersion!, travelId: travelId, regionCode: sfcRegionCode!, categoryName: sfcCategory!)
            
            BL_TPStepper.sharedInstance.changeTPStatusToDraft(tpEntryId: TPModel.sharedInstance.tpEntryId)
            
            if sfcValidationVal.contains(TPModel.sharedInstance.expenseEntityName)
            {
                let categoryName = TPModel.sharedInstance.expenseEntityName
                let travelledPlaces = DAL_TP_SFC.sharedInstance.getTravelledDetailList()
                let intermediatePrivVal = BL_SFC.sharedInstance.getIntermediatePlacePrivVal()
                
                if (travelledPlaces.count) == 1 && !intermediatePrivVal.contains(categoryName!) && categoryName != defaultWorkCategoryType
                {
                    let dictionary : NSMutableDictionary = [:]
                    dictionary.setValue(TPModel.sharedInstance.tpEntryId, forKey: "TP_Entry_Id")
                    dictionary.setValue(fromPlaceField.text, forKey: "To_Place")
                    dictionary.setValue(toPlaceField.text, forKey: "From_Place")
                    dictionary.setValue(travelModeLabel.text, forKey: "Travel_Mode")
                    dictionary.setValue(String(distance), forKey: "Distance")
                    dictionary.setValue(sfcCategory, forKey: "SFC_Category_Name")
                    dictionary.setValue(distanceFareCode, forKey: "Distance_Fare_Code")
                    dictionary.setValue(sfcVersion, forKey: "SFC_Version")
                    dictionary.setValue(TPModel.sharedInstance.tpFlag, forKey: "Flag")
                    dictionary.setValue(TPModel.sharedInstance.tpId, forKey: "TP_Id")
                    dictionary.setValue(sfcRegionCode, forKey: "SFC_Region_Code")
                    DAL_TP_SFC.sharedInstance.insertSFCDetails(dict: dictionary)
                    BL_TPStepper.sharedInstance.changeTPStatusToDraft(tpEntryId: TPModel.sharedInstance.tpEntryId)
                }
                else if toPlaceField.text != initialToPlace
                {
                    DAL_TP_SFC.sharedInstance.deleteNextTravelledDetail(travelId: travelId)
                }
            }
        }
        else
        {
            let dictionary : NSMutableDictionary = [:]
            dictionary.setValue(TPModel.sharedInstance.tpEntryId, forKey: "TP_Entry_Id")
            dictionary.setValue(fromPlaceField.text, forKey: "From_Place")
            dictionary.setValue(toPlaceField.text, forKey: "To_Place")
            dictionary.setValue(travelModeLabel.text, forKey: "Travel_Mode")
            dictionary.setValue(String(distance), forKey: "Distance")
            dictionary.setValue(sfcCategory, forKey: "SFC_Category_Name")
            dictionary.setValue(distanceFareCode, forKey: "Distance_Fare_Code")
            dictionary.setValue(sfcVersion, forKey: "SFC_Version")
            dictionary.setValue(TPModel.sharedInstance.tpFlag, forKey: "Flag")
            dictionary.setValue(TPModel.sharedInstance.tpId, forKey: "TP_Id")
            dictionary.setValue(sfcRegionCode, forKey: "SFC_Region_Code")
            BL_TP_SFC.sharedInstance.insertSFCDetail(dict: dictionary)
            BL_TPStepper.sharedInstance.changeTPStatusToDraft(tpEntryId: TPModel.sharedInstance.tpEntryId)
        }
        
        let sb = UIStoryboard(name: TourPlannerSB, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: TPTravelListVcId)
        
        if let navigationController = self.navigationController
        {
            navigationController.popViewController(animated: false)
            navigationController.pushViewController(vc, animated: false)
        }
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
    
}
