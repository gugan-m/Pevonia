    //
    //  SearchApprovalViewController.swift
    //  HiDoctorApp
    //
    //  Created by swaasuser on 06/11/17.
    //  Copyright © 2017 swaas. All rights reserved.
    //

    import UIKit

    protocol  searchResultListDelegate
    {
        func getSelectedActivityListDelegate(menuId: Int,searchtText: String , searchType : Bool,customerStatus: Int)
    }

    class SearchApprovalViewController: UIViewController,UITextFieldDelegate {
        
        var menuId : Int = Int()
        var searchType: Int = 0
        var searchId: Bool = true
        var placeHolderUser = "Enter user name"
        var placeHolderRegion = "Enter region name"
        var delegate : searchResultListDelegate?
        var customerStatus: Int = 1
        
        @IBOutlet weak var searchTextField: UITextField!
        @IBOutlet weak var customerStatusViewHeight: NSLayoutConstraint!
        
        @IBOutlet weak var customerStatusSwitch: UISwitch!
        @IBOutlet weak var customerStatusLbl: UILabel!
        @IBOutlet weak var searchButtonWidth: NSLayoutConstraint!
        
        @IBOutlet weak var customerStatusHiddenTop: NSLayoutConstraint!
        override func viewDidLoad()
        {
            super.viewDidLoad()
            self.setPlaceHolderForTxtFld(searchType: searchType)
            searchTextField.delegate = self
            self.addTapGestureForView()
            if SwifterSwift().isPad
            {
                searchButtonWidth.constant = 170
            }
            else
            {
                searchButtonWidth.constant = 120
            }

            // Do any additional setup after loading the view.
        }
        override func viewWillAppear(_ animated: Bool) {
            if(menuId == MenuIDs.DoctorApproval.rawValue)
            {
                customerStatusViewHeight.constant = 43
                customerStatusHiddenTop.constant = 25
                customerStatusSwitch.isHidden = false
                customerStatusLbl.isHidden = false
                if(customerStatus == 1)
                {
                    customerStatusLbl.text = "Applied \(appDoctor)"
                }
                else
                {
                    customerStatusLbl.text = "Approved \(appDoctor)"
                }
            }
            else
            {
                customerStatusViewHeight.constant = 0
                customerStatusHiddenTop.constant = 0
                customerStatusSwitch.isHidden = true
                customerStatusLbl.isHidden = true
            }
        }
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            
            if searchTextField.text == placeHolderUser || searchTextField.text == placeHolderRegion
            {
                searchTextField.text = ""
                searchTextField.textColor = UIColor.black
            }
            searchTextField.autocorrectionType = .no
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString text: String) -> Bool {
            
            let charList = ACCEPTABLE_CHARACTERS
            var newLength = textField.text?.count
            if  text != "" && !charList.contains(text.last!)
            {
                return false
            }
            
            if (text == UIPasteboard.general.string)
            {
                textField.text = "\(textField.text! )" + text
                newLength = textField.text?.count
                
            }
            
            if (textField.text == placeHolderUser || textField.text == placeHolderRegion)
            {
                textField.text = ""
            }
            
            textField.autocorrectionType = .no
            return true
        }
        
    
        @IBAction func searchType(_ sender: UISegmentedControl)
        {
            searchType = sender.selectedSegmentIndex
            self.setPlaceHolderForTxtFld(searchType: searchType)
        }
        
        @IBAction func searchUser(_ sender: UIButton)
        {
            self.searchValidation()
        }
        
        func setPlaceHolderForTxtFld(searchType: Int)
        {
            if searchType == 0
            {
                searchTextField.text = ""
                searchTextField.text = placeHolderUser
                searchTextField.textColor = UIColor.lightGray
            }
            else
            {
                searchTextField.text = ""
                searchTextField.text = placeHolderRegion
                searchTextField.textColor = UIColor.lightGray
            }
        }
        
        func isSpecialCharacterExist() -> Bool
        {
            let restrictedChatacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
            
            if (searchTextField.text?.count)! > 0
            {
                if restrictedChatacter != ""
                {
                    return checkIfSpecialCharacterFound(restrictedCharacter: restrictedChatacter, remarkTxt: searchTextField.text!)
                }
            }
            
            return false
        }
        
        //MARK:- Search Details Validation
        func validation() -> Bool
        {
            
            if (searchTextField.text == placeHolderUser || searchTextField.text == placeHolderRegion)
            {
                if searchId == true
                {
                    AlertView.showAlertView(title: alertTitle, message: placeHolderUser, viewController: self)
                }
                else
                {
                    AlertView.showAlertView(title: alertTitle, message: placeHolderRegion, viewController: self)
                }
                return false
            }
            
            if (searchTextField.text == EMPTY)
            {
                if searchId == true
                {
                    AlertView.showAlertView(title: alertTitle, message: placeHolderUser, viewController: self)
                }
                else
                {
                    AlertView.showAlertView(title: alertTitle, message: placeHolderRegion, viewController: self)
                }
                return false
            }
            
            if (searchTextField.text?.count == 0)
            {
                if searchId == true
                {
                    AlertView.showAlertView(title: alertTitle, message: placeHolderUser, viewController: self)
                }
                else
                {
                    AlertView.showAlertView(title: alertTitle, message: placeHolderRegion, viewController: self)
                }
                return false
            }
            
            if isSpecialCharacterExist()
            {
                let restrictedCharacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
                
                AlertView.showSpecialCharacterAlertview(title: alertTitle, subject: "Search Text", restrictedVal: restrictedCharacter, viewController: self)
                return false
            }
            
            else if condenseWhitespace(stringValue:searchTextField.text!).count == 0
            {
                if searchId == true
                {
                AlertView.showAlertView(title: alertTitle, message: placeHolderUser, viewController: self)
                }
                else
                {
                    AlertView.showAlertView(title: alertTitle, message: placeHolderRegion, viewController: self)
                }
            
                return false
                }
            return true
        }
        
                
        func resignResponderForTxtField()
        {
            self.searchTextField.resignFirstResponder()
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool
        {
            self.searchTextField.resignFirstResponder()
            self.searchValidation()
            return true
        }
        func addDoneButtonOnKeyboard()
        {
            let doneToolbar = getToolBar()
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneClicked))
            doneToolbar.items = [flexSpace, done]
            doneToolbar.sizeToFit()
            self.searchTextField.inputAccessoryView = doneToolbar
        }
        @objc func doneClicked()
        {
            self.searchTextField.resignFirstResponder()
            if searchTextField.text == ""
            {
                searchTextField.textColor = UIColor.lightGray
                if searchType == 0
                {
                    searchTextField.text =  placeHolderUser
                }
                else
                {
                    searchTextField.text = placeHolderRegion
                }
            }
        }
        func addTapGestureForView()
        {
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.doneClicked))
            view.addGestureRecognizer(tap)
        }

        func searchValidation()
        {
            if searchType == 0
            {
                searchId = true
            }
            else
            {
                searchId = false
            }
            let formValidation : Bool = self.validation()
            if formValidation
            {
                if checkInternetConnectivity()
                {
                    
                    if(menuId == MenuIDs.DoctorApproval.rawValue)
                    {
                    }
                    else
                    {
                       self.customerStatus = 0
                    }
                    self.delegate?.getSelectedActivityListDelegate(menuId: menuId, searchtText: searchTextField.text!, searchType: searchId, customerStatus: self.customerStatus)
                    self.navigationController?.popViewController(animated: true)
                    
                }
                else
                {
                    AlertView.showNoInternetAlert()
                }
            }

        }
        @IBAction func customerStatusSwitchButton(_ sender: UISwitch) {
            if(customerStatusSwitch.isOn)
            {
                customerStatus = 2
                customerStatusLbl.text = "Approved \(appDoctor)"
                
            }
            else
            {
                customerStatus = 1
                customerStatusLbl.text = "Applied \(appDoctor)"
               
            }
        }
        
    }
