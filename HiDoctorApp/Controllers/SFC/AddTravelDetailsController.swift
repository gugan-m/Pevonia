//
//  AddTravelDetailsController.swift
//  HiDoctorApp
//
//  Created by Vijay on 24/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class AddTravelDetailsController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var contentViewBtmConst: NSLayoutConstraint!
    @IBOutlet weak var contentViewYOffsetConst: NSLayoutConstraint!
    @IBOutlet weak var fromPlaceField: UITextField!
    @IBOutlet weak var toPlaceField: UITextField!
    @IBOutlet weak var travelModeLabel: UILabel!
    @IBOutlet weak var travelModeField: UITextField!
    @IBOutlet weak var distanceField: UITextField!
    @IBOutlet weak var tapBtnHeightConst: NSLayoutConstraint!
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
    var distanceFinal : Float = 0.0
    var travelId : Int = 0
    var fromPlaceDisabled : Bool = false
    var toPlaceDisabled : Bool = false
    var validSFC : Bool!
    var initialToPlace : String!
    var isUpdatedSFC: Bool = false
    var sfcValidationVal: [String]!
    var modifyFromplaceFlag : Bool = false
    var isComingFromModify: Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        setDefaults()
        
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
        
        
        setConfigValues()
        setDistanceBtnEditablity()
        setControlsEditForTPFreeze()
    }
    
    func setConfigValues()
    {
        if fromPlace != ""
        {
            fromPlaceField.text = fromPlace
        }
        BL_SFC.sharedInstance.fromPlace = fromPlace
        
        if toPlace != ""
        {
            toPlaceField.text = toPlace
        }
        BL_SFC.sharedInstance.toPlace = toPlace
        
        if travelMode != ""
        {
            validTravelMode = true
            travelModeLabel.text = travelMode
        }
        else
        {
            validTravelMode = false
            travelModeLabel.text = "Select travel mode"
        }
        
        if distance > 0.0
        {
            distanceField.text = String(format: "%.2f", distance)
        }
        else
        {
            distanceField.text = "0"
        }
        
        loadPickerview()
    }
    
//    func fromToCheck(){
//        if (fromPlaceField.text != "" && toPlaceField.text != ""){
//
//        }
//    }
    
    func setDistanceBtnEditablity()
    {
        if (fromPlaceField.text != "" && toPlaceField.text != "") {
            let fromValue = DAL_SFC.sharedInstance.getPlaceList1(FromDate: fromPlaceField.text!)
            let toValue = DAL_SFC.sharedInstance.getPlaceList1(FromDate: toPlaceField.text!)
            
            if (fromValue!.count == 0 || toValue!.count == 0){
               // distanceField.isUserInteractionEnabled = true
                if (distanceFareCode == ""){
                    distanceField.isUserInteractionEnabled = true
                }else{
                    distanceField.isUserInteractionEnabled = false
                }
            }else{
                let dcrDate = DCRModel.sharedInstance.dcrDate
                let DCRVALUE = DAL_SFC.sharedInstance.checkDistanceDCREdit(dcrDate: dcrDate!)
                if (DCRVALUE.count == 0){
                    if (distanceFareCode == ""){
                        distanceField.isUserInteractionEnabled = true
                    }else{
                        distanceField.isUserInteractionEnabled = false
                    }
                }else{
                    
                    let dcrDate = DCRModel.sharedInstance.dcrDate
                    let categoryName = DCRModel.sharedInstance.expenseEntityName
              
                    let expenseMappingList = DAL_SFC.sharedInstance.checkDistanceEditStatus(dcrDate: dcrDate!, categoryName: categoryName!)
                    
                    if expenseMappingList.count == 0
                    {
                        if (distanceFareCode == ""){
                            distanceField.isUserInteractionEnabled = true
                        }else{
                            distanceField.isUserInteractionEnabled = false
                        }
                    }else if (expenseMappingList[0].Distance_Edit == 0){
                        distanceField.isUserInteractionEnabled = false
                    }else if (expenseMappingList[0].Distance_Edit == 1){
                        if (distanceFareCode == ""){
                            distanceField.isUserInteractionEnabled = true
                        }else{
                            distanceField.isUserInteractionEnabled = false
                        }
                    }else if (expenseMappingList[0].Distance_Edit == 2){
                            distanceField.isUserInteractionEnabled = true
                    }
                    
                }
            }
        }else{

        }
    }
    
    func setDefaults()
    {
        addBackButtonView()
        
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
        
        travelModeList = DAL_SFC.sharedInstance.getTravelModeList()!
        contentViewHeightConst.constant = self.view.frame.size.height + 64.0
        
        sfcValidationVal = BL_SFC.sharedInstance.getSFCValidationPrivVal()
        
        let travelledPlaces = DAL_SFC.sharedInstance.getTravelledDetailList()
        
        if (travelledPlaces?.count)! > 0 && travelId == 0
        {
            fromPlace = (travelledPlaces?.last?.To_Place)!
            if sfcValidationVal.contains(DCRModel.sharedInstance.expenseEntityName)
            {
                fromPlaceDisabled = true
            }
            else
            {
                fromPlaceDisabled = false
            }
        }
        
        if travelId != 0 && modifyFromplaceFlag == true && sfcValidationVal.contains(DCRModel.sharedInstance.expenseEntityName)
        {
            fromPlaceDisabled = true
        }
        
        initialToPlace = toPlace
        
        if isUpdatedSFC
        {
            showToastView(toastText: sfcUpdateToastMsg)
        }
    }
    
    private func setControlsEditForTPFreeze()
    {
        if (BL_Stepper.sharedInstance.isTPFreeseDay)
        {
            if (isComingFromModify)
            {
                self.fromPlaceDisabled = true
                self.toPlaceDisabled = true
                self.travelModeField.isUserInteractionEnabled = false
            }
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
                            self.contentView.frame.origin.y = (keyboardSize.height - btmSpaceVal) * -1
                            self.contentViewYOffsetConst.constant = (keyboardSize.height - btmSpaceVal) * -1
                            self.contentViewBtmConst.constant = keyboardSize.height
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
                self.contentView.frame.origin.y = 0
                self.contentViewYOffsetConst.constant = 0
                self.contentViewBtmConst.constant = 0
                }, completion: { finished in
            })
        }
    }
    
    // Textfield delegates
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == distanceField
        {
            textfieldYoffset = 296.0
        }
        else if textField == travelModeField
        {
            textfieldYoffset = 0.0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        var flag : Bool = false
        
        if textField == distanceField
        {
            flag = true
            self.view.endEditing(true)
        }
        
        return flag
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
        let doneButton : UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(AddTravelDetailsController.doneClicked))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        pickerToolbar.setItems([spaceButton, doneButton], animated: false)
        pickerToolbar.sizeToFit()
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
                let sfcList = BL_SFC.sharedInstance.getSFCDetailsbasedOnTravelMode(fromPlace: fromPlaceField.text!, toPlace: toPlaceField.text!, travelMode: travelModeLabel.text!)
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
                    distanceField.text = String(format: "%.2f", distance)
                }
                else
                {
                    validSFC = false
                    sfcVersion = 0
                    sfcCategory = ""
                    sfcRegionCode = getRegionCode()
                    distanceFareCode = ""
                    distance = 0.0
                    distanceField.text = "0"
                }
                
                setDistanceBtnEditablity()
            }
        }
        
        travelModeField.resignFirstResponder()
    }
    
    func navigateToNextscreen(tag: String)
    {
        if !BL_SFC.sharedInstance.isAccompanistScreenHidden()
        {
            let sb = UIStoryboard(name: commonListSb, bundle: nil)
            let vc:UserListViewController = sb.instantiateViewController(withIdentifier: userListVcID) as! UserListViewController
            vc.navigationScreenName = tag
            self.navigationController?.pushViewController(vc, animated: true)
        } else
        {
            let loggedUserModel = getUserModelObj()
            let regionCode = loggedUserModel?.Region_Code
            let placeList = BL_SFC.sharedInstance.convertToSFCPlaceModel(regionCode: regionCode!)
            let sb = UIStoryboard(name: commonListSb, bundle: nil)
            let vc:PlaceListViewController = sb.instantiateViewController(withIdentifier: placeListVcID) as! PlaceListViewController
            vc.navigationScreenname = tag
            vc.placeList = placeList!
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
            navigateToNextscreen(tag: addTravelFromPlace)
        }
    }

    @IBAction func toPlaceAction(_ sender: AnyObject)
    {
        if (!toPlaceDisabled)
        {
            navigateToNextscreen(tag: addTravelToPlace)
        }
    }
    
    @IBAction func submitAction(_ sender: AnyObject)
    {
        
        let dcrDate = DCRModel.sharedInstance.dcrDate
        let categoryName = DCRModel.sharedInstance.expenseEntityName
        
        let expenseMappingList = DAL_SFC.sharedInstance.checkDistanceEditStatus(dcrDate: dcrDate!, categoryName: categoryName!)
        var IntCheck = 3
        if (expenseMappingList.isEmpty == true){
            IntCheck = 3
           // expenseMappingList[0].Distance_Edit = 3
        }else{
            IntCheck = expenseMappingList[0].Distance_Edit
        }
        
        let distanceFloatVal : Float
        if (distanceField.text! == ""){
            distanceFloatVal = 0.0
        }else{
            distanceFloatVal = Float(distanceField.text!)!
        }
        
        
        let sfcList = BL_SFC.sharedInstance.getSFCDetailsbasedOnTravelMode(fromPlace: fromPlaceField.text!, toPlace: toPlaceField.text!, travelMode: travelModeLabel.text!)
        if sfcList.count > 0
        {
            let model = sfcList[0]
            distanceFinal = model.Distance
        }
        
        if fromPlaceField.text == ""
        {
            AlertView.showAlertView(title: alertTitle, message: fromPlaceErrorMsg, viewController: self)
        }
        else if toPlaceField.text == ""
        {
            AlertView.showAlertView(title: alertTitle, message: toPlaceErrorMsg, viewController: self)
        }
        else if !validTravelMode
        {
            AlertView.showAlertView(title: alertTitle, message: travelModeErrorMsg, viewController: self)
        }
        else if distanceField.text! == ""
        {
            AlertView.showAlertView(title: alertTitle, message: distanceErrorMsg, viewController: self)
        }
        else if (!isValidFloatNumber(value: distanceField.text!))
        {
            AlertView.showAlertView(title: alertTitle, message: validNumberMsg, viewController: self)
        }
        else if !maxNumberValidationCheck(value: distanceField.text!, maxVal: sfcMaxVal)
        {
            AlertView.showNumberExceedAlertView(title: alertTitle, subject: "Distance", maxVal: sfcMaxVal, viewController: self)
        }
        else if (IntCheck == 2 && distanceFareCode != "" && distanceFinal < distanceFloatVal){
           
                AlertView.showAlertView(title: alertTitle, message: "Entered kilometer is greater than actual kilometer. (Actual kilometer is \(distanceFinal)", viewController: self)
        }
//        else if (expenseMappingList[0].Distance_Edit == 2 && distanceFinal < distanceFloatVal)
//        {
//            AlertView.showAlertView(title: alertTitle, message: "Entered kilometer is greater than actual kilometer. (Actual kilometer is \(distanceFinal)", viewController: self)
//        }
        else
        {
            if validSFC == true
            {
                mineValidationCheck()
            }
            else
            {
                let statusMsg = BL_SFC.sharedInstance.sfcValidationCheck(fromPlace: fromPlaceField.text!, toPlace: toPlaceField.text!, travelMode: travelModeLabel.text!)
                if statusMsg != ""
                {
                    AlertView.showAlertView(title: alertTitle, message: statusMsg, viewController: self)
                }
                else
                {
                    mineValidationCheck()
                }
                
//                if validSFC == true && travelMode != travelModeLabel.text
//                {
//                    let sfcList = BL_SFC.sharedInstance.getSFCDetailsbasedOnTravelMode(fromPlace: fromPlaceField.text!, toPlace: toPlaceField.text!, travelMode: travelModeLabel.text!)
//                    if sfcList.count > 0
//                    {
//                        updateSFCDetails(model: sfcList[0])
//                    }
//                    else
//                    {
//                        let statusMsg = BL_SFC.sharedInstance.sfcValidationCheck(fromPlace: fromPlaceField.text!, toPlace: toPlaceField.text!, travelMode: travelModeLabel.text!)
//                        if statusMsg != ""
//                        {
//                            AlertView.showAlertView(title: errorTitle, message: statusMsg, viewController: self)
//                        } else
//                        {
//                            saveSFCDetails()
//                        }
//                    }
//                }
//                else
//                {
//                    let statusMsg = BL_SFC.sharedInstance.sfcValidationCheck(fromPlace: fromPlaceField.text!, toPlace: toPlaceField.text!, travelMode: travelModeLabel.text!)
//                    if statusMsg != ""
//                    {
//                        AlertView.showAlertView(title: errorTitle, message: statusMsg, viewController: self)
//                    } else
//                    {
//                        saveSFCDetails()
//                    }
//                }
            }
        }
    }
    
    private func mineValidationCheck()
    {
        let sfcValidationVal = BL_SFC.sharedInstance.getSFCValidationPrivVal()
        if sfcValidationVal.contains(DCRModel.sharedInstance.expenseEntityName)
        {
            let sfcList = BL_SFC.sharedInstance.getSFCDetailsbasedOnTravelMode(fromPlace: fromPlaceField.text!, toPlace: toPlaceField.text!, travelMode: travelModeLabel.text!)
            var validationErrorMsg : String = ""
            
            let noncatFilteredList = sfcList.filter {
                $0.Region_Code == getRegionCode() && $0.Category_Name != DCRModel.sharedInstance.expenseEntityName
            }
            
            if noncatFilteredList.count > 0
            {
                validationErrorMsg = sfcMineValMsg
            }
            
            let catFilteredList = sfcList.filter {
                $0.Region_Code == getRegionCode() && $0.Category_Name == DCRModel.sharedInstance.expenseEntityName
            }
            
            if catFilteredList.count > 0
            {
                validationErrorMsg = ""
            }
            
            if (self.sfcRegionCode != nil && self.sfcCategory != nil)
            {
                if (self.sfcRegionCode == getRegionCode())
                {
                    if (self.sfcCategory!.uppercased() != DCRModel.sharedInstance.expenseEntityName.uppercased())
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
            let distanceFloatVal : Float = Float(distanceField.text!)!
            DAL_SFC.sharedInstance.updateSFCDetails(fromPlace : fromPlaceField.text!, toPlace : toPlaceField.text!, distance : distanceFloatVal, distanceFareCode: distanceFareCode!, travelMode: travelModeLabel.text!, sfcVersion : sfcVersion!, travelId: travelId, regionCode: sfcRegionCode!, categoryName: sfcCategory!)
            if sfcValidationVal.contains(DCRModel.sharedInstance.expenseEntityName)
            {
                let categoryName = DCRModel.sharedInstance.expenseEntityName
                let travelledPlaces = DAL_SFC.sharedInstance.getTravelledDetailList()
                let circularPrivVal = BL_SFC.sharedInstance.getCircleRouteAppCategoryPrivVal()
                let intermediatePrivVal = BL_SFC.sharedInstance.getIntermediatePlacePrivVal()
                if (travelledPlaces?.count) == 1 && circularPrivVal.contains(categoryName!) && !intermediatePrivVal.contains(categoryName!) && categoryName != defaultWorkCategoryType
                {
                    let dictionary : NSMutableDictionary = [:]
                    dictionary.setValue(DCRModel.sharedInstance.dcrId, forKey: "DCR_Id")
                    dictionary.setValue(fromPlaceField.text, forKey: "To_Place")
                    dictionary.setValue(toPlaceField.text, forKey: "From_Place")
                    dictionary.setValue(travelModeLabel.text, forKey: "Travel_Mode")
                    dictionary.setValue(distanceField.text, forKey: "Distance")
                    dictionary.setValue(sfcCategory, forKey: "SFC_Category_Name")
                    dictionary.setValue(distanceFareCode, forKey: "Distance_Fare_Code")
                    dictionary.setValue(sfcVersion, forKey: "SFC_Version")
                    dictionary.setValue(DCRModel.sharedInstance.dcrFlag, forKey: "Flag")
                    dictionary.setValue(DCRModel.sharedInstance.dcrCode, forKey: "DCR_Code")
                    dictionary.setValue(sfcRegionCode, forKey: "SFC_Region_Code")
                    dictionary.setValue(1, forKey: "Is_Circular_Route_Complete")
                    DAL_SFC.sharedInstance.insertSFCDetails(dict: dictionary)
                }
                else if toPlaceField.text != initialToPlace
                {
                    DAL_SFC.sharedInstance.deleteNextTravelledDetail(travelId: travelId)
                }
            }
        }
        else
        {
            let dictionary : NSMutableDictionary = [:]
            dictionary.setValue(DCRModel.sharedInstance.dcrId, forKey: "DCR_Id")
            dictionary.setValue(fromPlaceField.text, forKey: "From_Place")
            dictionary.setValue(toPlaceField.text, forKey: "To_Place")
            dictionary.setValue(travelModeLabel.text, forKey: "Travel_Mode")
            dictionary.setValue(distanceField.text, forKey: "Distance")
            dictionary.setValue(sfcCategory, forKey: "SFC_Category_Name")
            dictionary.setValue(distanceFareCode, forKey: "Distance_Fare_Code")
            dictionary.setValue(sfcVersion, forKey: "SFC_Version")
            dictionary.setValue(DCRModel.sharedInstance.dcrFlag, forKey: "Flag")
            dictionary.setValue(DCRModel.sharedInstance.dcrCode, forKey: "DCR_Code")
            dictionary.setValue(sfcRegionCode, forKey: "SFC_Region_Code")
            BL_SFC.sharedInstance.insertSFCDetail(dict: dictionary)
        }
        
        let sb = UIStoryboard(name: travelDetailListSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: travelDetailListVcID)
        
        if let navigationController = self.navigationController
        {
            navigationController.popViewController(animated: false)
            navigationController.pushViewController(vc, animated: false)
        }
    }
    
//    private func updateSFCDetails(model : SFCMasterModel)
//    {
//        var categoryName = ""
//        if model.Category_Name != nil
//        {
//            categoryName = model.Category_Name
//        }
//        if travelId > 0
//        {
//            DAL_SFC.sharedInstance.updateSFCDetails(fromPlace : model.From_Place, toPlace : model.To_Place, distance : model.Distance, distanceFareCode: model.Distance_Fare_Code, travelMode: model.Travel_Mode, sfcVersion : model.SFC_Version, travelId: travelId, regionCode: model.Region_Code, categoryName:categoryName)
//        } else
//        {
//            let dictionary : NSMutableDictionary = [:]
//            dictionary.setValue(DCRModel.sharedInstance.dcrId, forKey: "DCR_Id")
//            dictionary.setValue(model.From_Place, forKey: "From_Place")
//            dictionary.setValue(model.To_Place, forKey: "To_Place")
//            dictionary.setValue(model.Travel_Mode, forKey: "Travel_Mode")
//            dictionary.setValue(String(format: "%.2f", model.Distance), forKey: "Distance")
//            dictionary.setValue(categoryName, forKey: "SFC_Category_Name")
//            dictionary.setValue(model.Distance_Fare_Code, forKey: "Distance_Fare_Code")
//            dictionary.setValue(model.SFC_Version, forKey: "SFC_Version")
//            dictionary.setValue(DCRModel.sharedInstance.dcrFlag, forKey: "Flag")
//            dictionary.setValue(DCRModel.sharedInstance.dcrCode, forKey: "DCR_Code")
//            dictionary.setValue(model.Region_Code, forKey: "SFC_Region_Code")
//            BL_SFC.sharedInstance.insertSFCDetail(dict: dictionary)
//        }
//        
//        let sb = UIStoryboard(name: travelDetailListSb, bundle: nil)
//        let vc = sb.instantiateViewController(withIdentifier: travelDetailListVcID)
//        
//        if let navigationController = self.navigationController
//        {
//            navigationController.popViewController(animated: false)
//            navigationController.pushViewController(vc, animated: false)
//        }
//    }
    
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
