//
//  DPMMainViewController.swift
//  HiDoctorApp
//
//  Created by Swaas on 26/12/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class DPMMainViewController: UIViewController,UIPickerViewDelegate,UITextFieldDelegate,UIPickerViewDataSource{
    
    
    @IBOutlet weak var typeOfMapLbl: UILabel!
    @IBOutlet weak var mappingModeLbl: UILabel!
    @IBOutlet weak var marketingCampaignLbl: UILabel!
    @IBOutlet weak var MappingForLbl: UILabel!
    @IBOutlet weak var typeOfMapTxt: UITextField!
    @IBOutlet weak var mappingModeTxt: UITextField!
    @IBOutlet weak var marketingCampaignTxt: UITextField!
    @IBOutlet weak var mappingForTxt: UITextField!
    @IBOutlet weak var marketingCampaignViewHeight:NSLayoutConstraint!
    @IBOutlet weak var marketingCampaignView:UIView!
    
    var pickerView: UIPickerView!
    var pickerViewOne: UIPickerView!
    var pickerViewTwo: UIPickerView!
    var pickerViewThree: UIPickerView!
    var selectedIndex: Int = 0
    var pickerIndex: Int = 1
    var mappingMode :[String] = ["Contact product mapping","Product contact mapping"]
    var typeOfMap : [String] = ["General Mapping","Target Mapping","Marketing Campaign"]
    var userList: [DPMUserList] = []
    var selectedMappingUser: DPMUserList!
    var allMcList: [MCAllDetailsModel] = []
    var selectedMCValue: MCAllDetailsModel!
    var defaultTypeName = "Select type of mapping"
    var defaultMapMode = "Select mapping mode"
    var defaultMCName = "Select campaign name"
    var defaultMapFor = "Select mapping for"
    
    
    
    var selectedRegionCode: String!
    var selectedName:String!
    var selectedRegionName:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.marketingCampaignViewHeight.constant = 0
        self.marketingCampaignView.isHidden = true
        addDatePicker()
        setDefaults()
        self.title = selectedName + "(" + selectedRegionName + ")"
        

        // Do any additional setup after loading the view.
    }
    
    private func setDefaults()
    {
      
        self.typeOfMapLbl.text = defaultTypeName
        self.mappingModeLbl.text = defaultMapMode
        self.marketingCampaignLbl.text = defaultMCName
        self.MappingForLbl.text = defaultMapFor
    }
    
    private func addDatePicker()
    {
        self.pickerView = getPicker()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerViewOne = getPicker()
        self.pickerViewOne.delegate = self
        self.pickerViewOne.dataSource = self
        self.pickerViewTwo = getPicker()
        self.pickerViewTwo.delegate = self
        self.pickerViewTwo.dataSource = self
        self.pickerViewThree = getPicker()
        self.pickerViewThree.delegate = self
        self.pickerViewThree.dataSource = self
        self.typeOfMapTxt.delegate = self
        self.mappingModeTxt.delegate = self
        self.marketingCampaignTxt.delegate = self
        self.mappingForTxt.delegate = self
        
        
        let doneToolbar = getToolBar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        doneToolbar.sizeToFit()
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.fromPickerDoneAction))
        let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.cancelBtnClicked))
        
        doneToolbar.items = [flexSpace, done, cancel]
        
         self.pickerView.tag = 1
       
        typeOfMapTxt.inputAccessoryView = doneToolbar
        typeOfMapTxt.inputView = self.pickerView
        mappingModeTxt.inputAccessoryView = doneToolbar
        mappingModeTxt.inputView = self.pickerViewOne
        marketingCampaignTxt.inputAccessoryView = doneToolbar
        marketingCampaignTxt.inputView = self.pickerViewTwo
        mappingForTxt.inputAccessoryView = doneToolbar
        mappingForTxt.inputView = self.pickerViewThree
    }
    
    @objc func fromPickerDoneAction()
    {
        
        if pickerIndex == 1
        {
            self.typeOfMapLbl.text = typeOfMap[selectedIndex]
            
                getDPMUserList()
        }
        else if pickerIndex == 2
        {
            self.mappingModeLbl.text = mappingMode[selectedIndex]
        }
        else if pickerIndex == 3
        {
            if allMcList.count > 0
            {
                self.getDPMUserListByCampaignCode(campaignCode: allMcList[selectedIndex].Campaign_Code)
                self.selectedMCValue = allMcList[selectedIndex]
                self.marketingCampaignLbl.text = allMcList[selectedIndex].Campaign_Name
                BL_DoctorProductMapping.sharedInstance.campaignData = DBHelper.sharedInstance.getMCCampaignData(campaignCode: allMcList[selectedIndex].Campaign_Code).first
            }
            else
            {
               AlertView.showAlertView(title: alertTitle, message: "No Marketing campaign found", viewController: self)
            }
        }
        else if pickerIndex == 4
        {
            if self.userList.count > 0
            {
                selectedMappingUser = self.userList[selectedIndex]
                let value = userList[selectedIndex].User_Name
                if value == EMPTY
                {
                self.MappingForLbl.text = VACANT + "(" + self.userList[selectedIndex].Region_Name + ")"
                }
                else
                {
                   self.MappingForLbl.text = userList[selectedIndex].User_Name + "(" + self.userList[selectedIndex].Region_Name + ")"
                }
            }
            else
            {
                if checkInternetConnectivity()
                {
                    AlertView.showAlertView(title: alertTitle, message: "Please select type of mapping", viewController: self)
                }
                else
                {
                    AlertView.showAlertView(title: internetOfflineTitle, message: internetOfflineMessage, viewController: self)
                }
            }
        }
        
        if "Marketing Campaign" == typeOfMapLbl.text
        {
            marketingCampaignViewHeight.constant = 65
            marketingCampaignView.isHidden = false
            self.getMCAllList()
        }
        else
        {
            marketingCampaignViewHeight.constant = 0
            marketingCampaignView.isHidden = true
        }
        
        resignResponderForTextField()
        self.view.endEditing(true)
    }
    
    @objc func cancelBtnClicked()
    {
        self.resignResponderForTextField()
    }
    
    @objc func resignResponderForTextField()
    {
        self.typeOfMapTxt.resignFirstResponder()
        self.mappingModeTxt.resignFirstResponder()
        self.marketingCampaignTxt.resignFirstResponder()
        self.mappingForTxt.resignFirstResponder()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if self.pickerView == pickerView
        {
            return typeOfMap.count
        }
        else if pickerViewOne == pickerView
        {
            return mappingMode.count
        }
        else if pickerViewTwo == pickerView
        {
            return allMcList.count
        }
        else if pickerViewThree == pickerView
        {
            return self.userList.count
        }
        else
        {
            return 0
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if  self.pickerView == pickerView
        {
            return typeOfMap[row]
        }
        else if pickerViewOne == pickerView
        {
            return mappingMode[row]
        }
        else if pickerViewTwo == pickerView
        {
            return allMcList[row].Campaign_Name
        }
        else if pickerViewThree == pickerView
        {
            return self.userList[row].User_Name + "(" + self.userList[row].Region_Name + ")"
        }
        else
        {
            return ""
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedIndex = row
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        pickerView.selectRow(0, inComponent: 0, animated: false)
        selectedIndex = 0
        pickerIndex = textField.tag
        return true
    }
    
    func getDPMUserList()
    {
        BL_DoctorProductMapping.sharedInstance.getDPMParentUsers(selectedRegionCode: selectedRegionCode) { (userList, status) in
            
            if status == SERVER_SUCCESS_CODE
            {
                self.userList = userList
            }
            else
            {
                self.userList = []
            }
        }
    }
    
    func getDPMUserListByCampaignCode(campaignCode:String)
    {
        BL_DoctorProductMapping.sharedInstance.getDPMParentUsersByCampaignCode(selectedRegionCode: selectedRegionCode,campaignCode:campaignCode) { (userList, status) in
            
            if status == SERVER_SUCCESS_CODE
            {
                self.userList = userList
            }
            else
            {
                self.userList = []
            }
        }
    }
    
    func getMCAllList()
    {
      let mcList = BL_DoctorProductMapping.sharedInstance.getMCAllList(refType: "REGION_PARTICIPATING", refCode: selectedRegionCode)
        
        allMcList = mcList
    }
    
    @IBAction func submitAction(_ sender: UIButton)
    {
        if typeOfMapLbl.text == defaultTypeName
        {
           AlertView.showAlertView(title: alertTitle, message: "Please select type of mapping.", viewController: self)
        }
        else if mappingModeLbl.text == defaultMapMode
        {
            AlertView.showAlertView(title: alertTitle, message: "Please select mapping mode", viewController: self)
        }
        else if MappingForLbl.text == defaultMapFor
        {
            AlertView.showAlertView(title: alertTitle, message: "Please select mapping for", viewController: self)
        }
        else if typeOfMapLbl.text == "Marketing Campaign" && marketingCampaignLbl.text == defaultMCName
        {
             AlertView.showAlertView(title: alertTitle, message: "Please select campaign name", viewController: self)
        }
        else
        {
            let sb = UIStoryboard(name: "NoticeBoardViewController", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "DPMCustomerProductListController") as! DPMCustomerProductListController
            vc.selectedRegionCode = self.selectedRegionCode
            if self.typeOfMapLbl.text == "General Mapping"
            {
                vc.selectedType = Constants.Doctor_Product_Mapping_Ref_Types.GENERAL
            }
            else if self.typeOfMapLbl.text == "Target Mapping"
            {
                vc.selectedType = Constants.Doctor_Product_Mapping_Ref_Types.TARGET_MAPPING
            }
            else
            {
                vc.selectedType = Constants.Doctor_Product_Mapping_Ref_Types.Marketing_Campaign
                vc.selectedMCValue = self.selectedMCValue
            }
            vc.mappingRegionCode = self.selectedMappingUser.Region_Code
            vc.selectedMode = self.mappingModeLbl.text
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
