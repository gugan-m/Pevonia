//
//  AddStockiestsViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 27/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class AddStockiestsViewController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var amBtn: UIButton!
    @IBOutlet weak var pmBtn: UIButton!
    
    
    @IBOutlet weak var amLbl: UILabel!
    @IBOutlet weak var pmLbl: UILabel!
    
    
    @IBOutlet weak var visitTimeTxtField: UITextField!
    
    
    @IBOutlet weak var visitModeTime: UILabel!
    
    
    @IBOutlet weak var pobAmtTxtFld: UITextField!
    @IBOutlet weak var collectionAmtTxtFld: UITextField!
    @IBOutlet weak var remarksTxtFld: UITextField!
    @IBOutlet weak var remarksCountLbl : UILabel!
    @IBOutlet weak var stockNameLbl: UILabel!
    @IBOutlet weak var dcrDateLbl: UILabel!
    @IBOutlet weak var headerView :UIView!
    @IBOutlet weak var contentView : UIView!
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var scrollViewBtm : NSLayoutConstraint!
    
    var stockiestsObj : CustomerMasterModel?
    var stockiestsModifyObj : DCRStockistVisitModel!
    var isComingFromModifyPage : Bool = false
    var visitMode : String = ""
    var visitTimePicker = UIDatePicker()
    var visitTime : String = EMPTY
    var visitTimemod : String = EMPTY
    var visitT = BL_DCR_Stockiests.sharedInstance.getDcrStockistVisitTime()
    var stockiestname : String = EMPTY
    var stockiestcode : String = EMPTY
 
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setStockiestsValue()
        addBackButtonView()
        self.addTapGestureForView()
        self.addKeyBoardObserver()
        self.headerView.backgroundColor = brandColor
        self.addTimePicker()
        //self.setVisitTimeMode()
        //self.visitTimeTxtField.isUserInteractionEnabled = false
        
        
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func amBtnAction(_ sender: AnyObject)
    {
        self.amBtn.isSelected = !amBtn.isSelected
        self.pmBtn.isSelected = false
        
        if self.amBtn.isSelected
        {
            self.visitMode = AM
        }
    }
    
    @IBAction func pmBtnAction(_ sender: AnyObject)
    {
        self.pmBtn.isSelected = !pmBtn.isSelected
        self.amBtn.isSelected = false
        
        if self.pmBtn.isSelected
        {
            self.visitMode = PM
        }
    }
    
    @IBAction func saveBtnAction(_ sender: Any)
    {
        var pobAmt : Double = 0.0
        var collectionAmt : Double = 0.0
        let pobText = pobAmtTxtFld.text
        let collectionAmtText = collectionAmtTxtFld.text
        
        if (pobText?.count)! > 0 && !isValidFloatNumber(value: self.pobAmtTxtFld.text!)
        {
            showAlertView(message: "Please enter valid POB amount")
        }
        else if (pobText?.count)! > 0 && !maxNumberValidationCheck(value:pobText!, maxVal: stockiestPOBMaxVal)
        {
            AlertView.showNumberExceedAlertView(title: alertTitle, subject: "POB Amount", maxVal: stockiestPOBMaxVal, viewController: self)
        }
        else if (collectionAmtText?.count)! > 0 && !isValidFloatNumber(value: self.collectionAmtTxtFld.text!)
        {
            showAlertView(message: "Please enter valid collection amount")
        }
        else if (collectionAmtText?.count)! > 0 && !maxNumberValidationCheck(value:collectionAmtText!, maxVal: stockiestCollMaxVal)
        {
            AlertView.showNumberExceedAlertView(title: alertTitle, subject: "Collection Amount", maxVal: stockiestCollMaxVal, viewController: self)
        }
        else if isSpecialCharacterExist()
        {
            let restrictedCharacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
            AlertView.showSpecialCharacterAlertview(title: alertTitle, subject: "Remarks", restrictedVal: restrictedCharacter, viewController: self)
        }
        else if (remarksTxtFld.text?.count)! > stockiestRemarksMaxLength
        {
            AlertView.showMaxLengthExceedAlertView(title: alertTitle, subject: "Remarks", maxVal: stockiestRemarksMaxLength, viewController: self)
        }
        else
        {
            if (pobText?.count)! > 0
            {
                pobAmt = Double(pobText!)!
            }
            if (collectionAmtText?.count)! > 0
            {
                collectionAmt = Double(collectionAmtText!)!
            }
            
            if isComingFromModifyPage
            {
                stockiestsModifyObj.POB_Amount = pobAmt
                stockiestsModifyObj.Collection_Amount = collectionAmt
                stockiestsModifyObj.Visit_Mode = self.visitMode
                
                if condenseWhitespace(stringValue: (remarksTxtFld.text)!).count > 0
                {
                    stockiestsModifyObj.Remarks = remarksTxtFld.text
                }
                else
                {
                    stockiestsModifyObj.Remarks = EMPTY
                }
                if visitT == "AM_PM"
                {
                    stockiestsModifyObj.Visit_Time = ""
                    stockiestsModifyObj.Visit_Mode = getVisitModeType1(visitTime: self.visitMode)
                    
                    BL_DCR_Stockiests.sharedInstance.updateDCRStockiestsVisit(dcrStockiestsObj: stockiestsModifyObj!)
                }
                else if BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled() == true
                {
                    stockiestsModifyObj.Visit_Time = getVisitModeType2(visitTime: self.visitMode)
                    stockiestsModifyObj.Visit_Mode = getVisitModeType1(visitTime: self.visitMode)
                    
                    BL_DCR_Stockiests.sharedInstance.updateDCRStockiestsVisit(dcrStockiestsObj: stockiestsModifyObj!)
                    
                }
                else
                {
                    stockiestsModifyObj.Visit_Time = getVisitModeType2(visitTime: self.visitMode)
                    stockiestsModifyObj.Visit_Mode = getVisitModeType1(visitTime: self.visitMode)
                    
                    BL_DCR_Stockiests.sharedInstance.updateDCRStockiestsVisit(dcrStockiestsObj: stockiestsModifyObj!)
                }
                
                //Api call for stockist visit
                if BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled() && isCurrentDate()
                {
                    let postData: NSMutableArray = []
                    let dict:[String:Any] = ["companyCode":getCompanyCode(),"userCode":getUserCode(),"Doctor_Code": self.stockiestsModifyObj.Stockiest_Code! as! String,"Doctor_Name":self.stockiestsModifyObj?.Stockiest_Name! as! String,"regionCode":BL_InitialSetup.sharedInstance.regionCode,"Category_Code": EMPTY,"MDL_Number":EMPTY,"DCR_Actual_Date":DCRModel.sharedInstance.dcrDateString,"Doctor_Visit_Date_Time":DCRModel.sharedInstance.dcrDateString + "" + visitMode,"Lattitude":getLatitude(),"Longitude":getLongitude(),"Modified_Entity":1,"Doctor_Region_Code":getRegionCode(),"Customer_Entity_Type":"S","Source_Of_Entry":"iOS"]
                    
                    postData.add(dict)
                    showCustomActivityIndicatorView(loadingText: "Loading...")
                    WebServiceHelper.sharedInstance.sendHourlyReport(postData: postData, completion: { (apiObj) in
                        if(apiObj.Status == SERVER_SUCCESS_CODE)
                        {
                            
                            //self.saveStockiestsDetails(pobAmount: pobAmt, collectionAmount: collectionAmt)
                            removeCustomActivityView()
                            //_ = self.navigationController?.popViewController(animated: false)
                        }
                    })}
                
               
                
            }
            else
            {
                self.saveStockiestsDetails(pobAmount: pobAmt, collectionAmount: collectionAmt, visitMode: self.visitMode)
                //Api call for stockist visit
                if BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled() && isCurrentDate()
                {
                    let postData: NSMutableArray = []
                    let dict:[String:Any] = ["companyCode":getCompanyCode(),"userCode":getUserCode(),"Doctor_Code": self.stockiestsObj?.Customer_Code! as! String,"Doctor_Name":self.stockiestsObj?.Customer_Name! as! String,"regionCode":BL_InitialSetup.sharedInstance.regionCode,"Category_Code": EMPTY,"MDL_Number":EMPTY,"DCR_Actual_Date":DCRModel.sharedInstance.dcrDateString,"Doctor_Visit_Date_Time":DCRModel.sharedInstance.dcrDateString + " " + visitMode,"Lattitude":getLatitude(),"Longitude":getLongitude(),"Modified_Entity":0,"Doctor_Region_Code":getRegionCode(),"Customer_Entity_Type":"S","Source_Of_Entry":"iOS"]
                    
                    postData.add(dict)
                    showCustomActivityIndicatorView(loadingText: "Loading...")
                    WebServiceHelper.sharedInstance.sendHourlyReport(postData: postData, completion: { (apiObj) in
                        if(apiObj.Status == SERVER_SUCCESS_CODE)
                        {
                            
                            //self.saveStockiestsDetails(pobAmount: pobAmt, collectionAmount: collectionAmt)
                            removeCustomActivityView()
                            //_ = self.navigationController?.popViewController(animated: false)
                        }
                    })}
            }
        }
        
        _ = navigationController?.popViewController(animated: false)
    }
    
    
    func getVisitTimeEntryMode() -> String
    {
        return BL_DCR_Stockiests.sharedInstance.getDcrStockistVisitTime()
    }
    
    
    func IsManualVisitMode() -> Bool
    {
        var isManual : Bool = true
        let configValue = BL_DCR_Stockiests.sharedInstance.getDcrStockistVisitTime()
        if configValue == ConfigValues.SERVER_TIME.rawValue
        {
            
            let time =  getServerTime()
            self.visitTime = time
            self.visitMode = getVisitModeType(visitTime: time)
        }
        else
        {
            isManual = true
        }
        return isManual
    }
    
    
    func getServerTime() -> String
    {
        let date = Date()
        return stringFromDate(date1: date)
    }
    
    private func isCurrentDate() -> Bool
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
    
    
    func setVisitTimeMode()
    {
        if isCurrentDate()
        {
            if visitTime != EMPTY
            {
                self.visitTimeTxtField.text = visitTime
                self.visitMode = self.getVisitModeType(visitTime: visitTime)
            }
            else
            {
                self.visitTime = getServerTime()
                self.visitMode = self.getVisitModeType(visitTime: visitTime)
                self.visitTimeTxtField.text = self.visitTime
            }
            
            
            self.visitTimeTxtField.isUserInteractionEnabled = false
        }
        else
        {
            if visitTime != EMPTY
            {
                self.visitTimeTxtField.text = visitTime
                self.visitMode = self.getVisitModeType(visitTime: visitTime)
            }
            else
            {
                self.visitTime = getServerTime()
                self.visitMode = self.getVisitModeType(visitTime: visitTime)
                self.visitTimeTxtField.text = self.visitTime
            }
            
            self.visitTimeTxtField.isUserInteractionEnabled = true
        }
        
    }
    
    func setStockiestsValue()
    {
        if isComingFromModifyPage
        {
            
            self.stockNameLbl.text = stockiestsModifyObj?.Stockiest_Name
            var pobAmount : String = ""
            
            pobAmount = String(describing: stockiestsModifyObj.POB_Amount!) as String
            
            var collectionAmount: String = ""
            collectionAmount = String(describing: stockiestsModifyObj.Collection_Amount!) as String
            
            self.title = "Edit \(appStockiest) Details"
            
            if stockiestsModifyObj.Remarks != nil
            {
                let remarksText : String = stockiestsModifyObj.Remarks!
                self.remarksTxtFld.text = remarksText
                self.remarksCountLbl.text = "\(remarksText.count)/\(stockiestRemarksMaxLength)"
            }
            else
            {
                self.remarksCountLbl.text = "0/\(String(stockiestRemarksMaxLength))"
            }
            
            self.pobAmtTxtFld.text = pobAmount
            self.collectionAmtTxtFld.text = collectionAmount
            
            if BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled() == true
            {
                visitModeTime.text = "Visit Time"
                
                
                if (isCurrentDate())
                {
                    self.visitTimeTxtField.isUserInteractionEnabled = false
                }
                self.visitMode = stockiestsModifyObj.Visit_Time! + stockiestsModifyObj.Visit_Mode!
                //self.visitMode = getVisitModeType(visitTime: stockiestsModifyObj.Visit_Mode!)
                self.visitTimeTxtField.text = self.visitMode
                //self.visitTimeTxtField.tintColor = UIColor.lightGray
                
                
                amBtn.isHidden = true
                pmBtn.isHidden = true
                amLbl.isHidden = true
                pmLbl.isHidden = true
                
            }
            else if visitT != "AM_PM"
            {
                visitModeTime.text = "Visit Time"
                //
                if (isCurrentDate())
                {
                    self.visitTimeTxtField.isUserInteractionEnabled = true
                }
                self.visitMode = stockiestsModifyObj.Visit_Time! + stockiestsModifyObj.Visit_Mode!
                //self.visitTime = self.visitTimemod
                //self.visitMode = getVisitModeType(visitTime: stockiestsModifyObj.Visit_Mode!)
                self.visitTimeTxtField.text = self.visitMode
                // self.setModifyVisitDetails(type: 12)
                
                amBtn.isHidden = true
                pmBtn.isHidden = true
                amLbl.isHidden = true
                pmLbl.isHidden = true
                
            }
                
            else
            {
                
                visitModeTime.text = "Visit Mode"
                self.visitMode = stockiestsModifyObj.Visit_Mode!
                
                visitTimeTxtField.isHidden = true
                
                if stockiestsModifyObj.Visit_Mode == AM
                {
                    self.amBtn.isSelected  = true
                }
                else
                {
                    self.pmBtn.isSelected  = true
                }
                
                
            }
        }
        else
        {
            
            if BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled() == true
            {
                
                visitModeTime.text = "Visit Time"
                
                if (isCurrentDate())
                {
                    self.visitTimeTxtField.isUserInteractionEnabled = false
                }
                self.visitMode = getServerTime()
                // self.visitMode = getVisitModeType(visitTime: getServerTime())
                //self.visitTimemod = self.visitTime
                self.visitTimeTxtField.text = self.visitMode
                visitTimeTxtField.tintColor = UIColor.lightGray
                
                amBtn.isHidden = true
                pmBtn.isHidden = true
                amLbl.isHidden = true
                pmLbl.isHidden = true
                
            }
            else if visitT != "AM_PM"
            {
                visitModeTime.text = "Visit Time"
                
                if (isCurrentDate())
                {
                    self.visitTimeTxtField.isUserInteractionEnabled = true
                }
                
                //self.visitTime = getServerTime()
                // self.visitMode = getVisitModeType(visitTime: getServerTime())
                self.visitMode = getServerTime()
                //self.visitMode = getVisitModeType2(visitTime: visitTime)
                self.visitTimeTxtField.text = self.visitMode
                
                amBtn.isHidden = true
                pmBtn.isHidden = true
                amLbl.isHidden = true
                pmLbl.isHidden = true
                
            }
                
            else
            {
                
                visitModeTime.text = "Visit Mode"
                self.amBtn.isSelected = true
                self.visitMode = AM
                visitTimeTxtField.isHidden = true
                
            }
            
            //self.amBtn.isSelected = true
            // self.visitMode = AM
            self.navigationItem.title = nil
            self.stockNameLbl.text = stockiestsObj?.Customer_Name
            //self.stockiestname = (stockiestsObj?.Customer_Name)!
            //self.stockiestcode = stockiestsObj?.Customer_Code
            self.title = "Add \(appStockiest) Details"
            
            self.remarksCountLbl.text = "0/\(String(stockiestRemarksMaxLength))"
            self.setPlaceHolderForTxtFld()
        }
        
        let dcrDateVal : String = convertDateIntoString(date: DCRModel.sharedInstance.dcrDate!) as String
        var date : String = ""
        
        date = dcrDateVal
        
        self.dcrDateLbl.text = "DVR Date :\(date)"
    }
    
    
    func saveStockiestsDetails(pobAmount:Double,collectionAmount : Double,visitMode: String)
    {
        
    
        if BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled() == true
        {
            

            
            BL_DCR_Stockiests.sharedInstance.insertDCRStockiestsVisit(customerMasterObj: stockiestsObj!, pobAmount: pobAmount, visitMode: getVisitModeType1(visitTime: visitMode) , collectionAmount: collectionAmount, remarks: (remarksTxtFld.text)!, visitTime: getVisitModeType2(visitTime: visitMode) )

        }
        
        else if visitT == "AM_PM"
        {
    BL_DCR_Stockiests.sharedInstance.insertDCRStockiestsVisit(customerMasterObj: stockiestsObj!, pobAmount: pobAmount, visitMode: getVisitModeType1(visitTime: visitMode) , collectionAmount: collectionAmount, remarks: (remarksTxtFld.text)!, visitTime: "" )
        }
        else
       {
      BL_DCR_Stockiests.sharedInstance.insertDCRStockiestsVisit(customerMasterObj: stockiestsObj!, pobAmount: pobAmount, visitMode: getVisitModeType1(visitTime: visitMode) , collectionAmount: collectionAmount, remarks: (remarksTxtFld.text)!, visitTime: getVisitModeType2(visitTime: visitMode) )
        
        }
        
    }
    
    
    
    
    ///modify   ......
    
    func setModifyVisitDetails(type : Int)
    {
        if isComingFromModifyPage && stockiestsModifyObj != nil
        {
            //visitTime = stockiestsModifyObj.Visit_Time!
            visitMode = stockiestsModifyObj.Visit_Mode!
            if type == 0
            {
                self.visitModeTime.text = visitTime
            }
            else if type == 1
            {
                self.setVisitMode(mode: visitMode)
            }
            else if type == 3
            {
                if visitTime != EMPTY
                {
                    if visitTime.contains(" ")
                    {
                        self.visitTimeTxtField.text = visitTime
                        self.visitMode = self.getVisitModeType(visitTime: visitTime)
                    }
                    else
                    {
                        self.visitTimeTxtField.text = visitTime + " " + visitMode
                        self.visitMode = self.getVisitModeType(visitTime: visitTime + " " + visitMode)
                    }
                }
                else
                {
                    self.visitTime = getServerTime()
                    self.visitMode = self.getVisitModeType(visitTime: visitTime)
                    self.visitTimeTxtField.text = self.visitTime
                }
                
                
                self.visitTimeTxtField.isUserInteractionEnabled = false
            }
            else if type == 12
            {
                
                self.amBtn.isSelected = false
                self.pmBtn.isSelected = false
                self.setVisitMode(mode: visitMode)
                self.amBtn.isUserInteractionEnabled = true
                self.pmBtn.isUserInteractionEnabled = true
            }
                
            else if type == 14
            {
                if visitTime != EMPTY
                {
                    if visitTime.contains(" ")
                    {
                        self.visitTimeTxtField.text = visitTime
                        self.visitMode = self.getVisitModeType(visitTime: visitTime)
                    }
                    else
                    {
                        self.visitTimeTxtField.text = visitTime + " " + visitMode
                        self.visitMode = self.getVisitModeType(visitTime: visitTime + " " + visitMode)
                    }
                }
                else
                {
                    self.visitTime = getServerTime()
                    self.visitMode = self.getVisitModeType(visitTime: visitTime)
                    self.visitTimeTxtField.text = self.visitTime
                }
                
                self.visitTimeTxtField.isUserInteractionEnabled = true
            }
            else
            {
                
                if(visitTime.contains("AM") || visitTime.contains("PM"))
                {
                    self.visitTimeTxtField.text = visitTime
                }
                else
                {
                    self.visitTimeTxtField.text = visitTime + " " +  visitMode
                }
                
                
            }
        }
        else
        {
            if type == 3
            {
                self.visitTime = getServerTime()
                self.visitMode = getVisitModeType(visitTime: getServerTime())
                self.visitTimeTxtField.text = self.visitTime
                
                if (isCurrentDate())
                {
                    self.visitTimeTxtField.isUserInteractionEnabled = false
                }
            }
            else if type == 1
            {
                self.setVisitMode(mode: AM)
            }
            else if type == 12
            {
                
                self.visitMode = getVisitModeType(visitTime: getServerTime())
                self.setVisitMode(mode: visitMode)
                self.amBtn.isSelected = false
                self.pmBtn.isSelected = false
                self.amBtn.isUserInteractionEnabled = true
                self.pmBtn.isUserInteractionEnabled = true
            }
            else if type == 14
            {
                self.visitTime = getServerTime()
                self.visitMode = self.getVisitModeType(visitTime: visitTime)
                self.visitTimeTxtField.text = self.visitTime
                
                self.visitTimeTxtField.isUserInteractionEnabled = true
            }
        }
    }
    
    func setVisitMode(mode : String)
    {
        if mode == AM
        {
            self.amBtn.isSelected = true
        }
        else
        {
            self.pmBtn.isSelected = true
        }
    }
    
    
    func setPlaceHolderForTxtFld()
    {
        pobAmtTxtFld.attributedPlaceholder = NSAttributedString(string:"Enter Amount",
                                                                attributes:[NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        collectionAmtTxtFld.attributedPlaceholder = NSAttributedString(string:"Enter Amount",
                                                                       attributes:[NSAttributedStringKey.foregroundColor: UIColor.lightGray])
    }
    
    func showAlertView(message : String)
    {
        AlertView.showAlertView(title: alertTitle, message: message, viewController: self)
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
    
    func addTapGestureForView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.resignResponserForTextField))
        view.addGestureRecognizer(tap)
    }
    
    private func addTimePicker()
    {
        visitTimePicker = getTimePickerView()
        visitTimePicker.tag = 1
        let doneToolbar = getToolBar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(AddStockiestsViewController.doneBtnClicked))
        let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(AddStockiestsViewController.cancelBtnClicked))
        
        doneToolbar.items = [flexSpace, done, cancel]
        doneToolbar.sizeToFit()
        
        visitTimeTxtField.inputAccessoryView = doneToolbar
        visitTimeTxtField.inputView = visitTimePicker
    }
    
    
    @objc func cancelBtnClicked()
    {
        self.visitTimeTxtField.resignFirstResponder()
    }
    
    
    @objc func doneBtnClicked()
    {
        let time = self.visitTimePicker.date
        let selectedVisitTime = stringFromDate(date1: time)
        self.visitTimeTxtField.text = selectedVisitTime
        self.visitMode = self.getVisitModeType(visitTime: selectedVisitTime)
        self.visitTime = selectedVisitTime
        self.visitTimeTxtField.resignFirstResponder()
    }
    
    
    func getVisitModeType(visitTime : String) -> String
    {
        //let lastcharacterIndex = visitTime.index(visitTime.endIndex, offsetBy: -2)
        return visitTime//.substring(from: lastcharacterIndex)
    }
    
    func getVisitModeType1(visitTime : String) -> String
    {
        let lastcharacterIndex = visitTime.index(visitTime.endIndex, offsetBy: -2)
        return visitTime.substring(from: lastcharacterIndex)
    }
    
    func getVisitModeType2(visitTime : String) -> String
    {
        return String(visitTime.dropLast(2))
    }
    
    @objc func resignResponserForTextField()
    {
        self.visitTimeTxtField.resignFirstResponder()
        self.remarksTxtFld.resignFirstResponder()
        self.collectionAmtTxtFld.resignFirstResponder()
        self.pobAmtTxtFld.resignFirstResponder()
    }
    
    
    func isSpecialCharacterExist() -> Bool
    {
        let restrictedChatacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
        
        if (remarksTxtFld.text?.count)! > 0
        {
            if restrictedChatacter != ""
            {
                return checkIfSpecialCharacterFound(restrictedCharacter: restrictedChatacter, remarkTxt: remarksTxtFld.text!)
            }
        }
        return false
    }
    
    //MARK:- KeyBoard function
    
    func addKeyBoardObserver()
    {
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(keyboardDidShow(_:)),
                           name: .UIKeyboardDidShow,
                           object: nil)
        
        center.addObserver(self,
                           selector: #selector(keyboardWillHide(_:)),
                           name: .UIKeyboardWillHide,
                           object: nil)
    }
    
    private func removeKeyBoardObserver()
    {
        let center = NotificationCenter.default
        
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardDidShow(_ notification: NSNotification)
    {
        
        if let userInfo = notification.userInfo
        {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            {
                self.scrollViewBtm.constant = keyboardSize.height
                self.view.layoutIfNeeded()
                
                let viewPresentPosition = self.remarksTxtFld.convert(contentView.bounds, to: self.remarksTxtFld)
                
                let scrollViewHeight = self.scrollView.frame.height
                
                let finalContentOffset = (viewPresentPosition.origin.y + viewPresentPosition.height) - scrollViewHeight
                var contentOffset = self.scrollView.contentOffset
                
                if finalContentOffset > 0
                {
                    contentOffset.y = finalContentOffset
                }
                self.scrollView.contentOffset = contentOffset
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification)
    {
        self.scrollViewBtm.constant = 0
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 2
        {
            let text = textField.text ?? ""
            
            let newLength = text.count + (string.count - range.length)
            if newLength > stockiestRemarksMaxLength
            {
                let lengthDiff = stockiestRemarksMaxLength - newLength
                let start = string.startIndex
                let end = string.index((string.endIndex), offsetBy: lengthDiff)
                let substring = string[start..<end]
                if substring != ""
                {
                    textField.text = "\(textField.text!)" + substring
                }
                self.remarksCountLbl.text = "\(stockiestRemarksMaxLength)/\(stockiestRemarksMaxLength)"
                return false
            }
            else
            {
                self.remarksCountLbl.text = "\(newLength)/\(stockiestRemarksMaxLength)"
                return true
            }
        }
        else if textField.tag == 3
        {
            if(string == ".")
            {
                if(textField.text?.contains("."))!
                {
                    
                    return false
                }
            }
            
            if(textField.text?.contains("."))!
            {
                if var str = textField.text
                {
                    str.insert(string.first ?? " ", at: str.index(str.startIndex, offsetBy: range.location))
                    let stringArray = str.components(separatedBy: ".")
                    
                    if Int(stringArray[0]) ?? 0 > Int(doctorPOBMaxVal)
                    {
                        if string != EMPTY
                        {
                            return false
                        }
                    }
                    
                    if Int(stringArray[1]) ?? 0 > 99
                    {
                        if string != EMPTY
                        {
                            return false
                        }
                    }
                    if stringArray[1].count > 2
                    {
                        if string != EMPTY
                        {
                            return false
                        }
                    }
                }
            }
            else
            {
                if textField.text?.count ?? 0 > 10
                {
                    if(string != ".")
                    {
                        if string != EMPTY
                        {
                            return false
                        }
                    }
                }
            }
            
            let aSet = NSCharacterSet(charactersIn:"0123456789.").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered
            //return isValidNumberForPobAmt(string : string)
        }
        else if textField.tag == 4
        {
            if(string == ".")
            {
                if(textField.text?.contains("."))!
                {
                    
                    return false
                }
            }
            
            if(textField.text?.contains("."))!
            {
                if var str = textField.text
                {
                    str.insert(string.first ?? " ", at: str.index(str.startIndex, offsetBy: range.location))
                    let stringArray = str.components(separatedBy: ".")
                    
                    if Int(stringArray[0]) ?? 0 > Int(doctorPOBMaxVal)
                    {
                        if string != EMPTY
                        {
                            return false
                        }
                    }
                    
                    if Int(stringArray[1]) ?? 0 > 99
                    {
                        if string != EMPTY
                        {
                            return false
                        }
                    }
                    if stringArray[1].count > 2
                    {
                        if string != EMPTY
                        {
                            return false
                        }
                    }
                }
            }
            else
            {
                if textField.text?.count ?? 0 > 10
                {
                    if(string != ".")
                    {
                        if string != EMPTY
                        {
                            return false
                        }
                    }
                }
            }
            
            let aSet = NSCharacterSet(charactersIn:"0123456789.").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered
            //return isValidNumberForPobAmt(string : string)
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
}
