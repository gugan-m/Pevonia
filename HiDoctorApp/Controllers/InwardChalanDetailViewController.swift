//
//  InwardChalanDetailViewController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 27/03/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class InwardChalanDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate {

     var inwardDataList : InwardAccknowledgmentProductData!
    var inwardList : [InwardAccknowledgment] = []
    var saveBut : UIBarButtonItem!
    var infoBut : UIBarButtonItem!
    var isAlert : Bool = false
    var defaultEmptyValue = -99999
    
    @IBOutlet weak var deliverChalanNo: UILabel!
    @IBOutlet weak var deliverDate: UILabel!
    @IBOutlet weak var dateTxtFld: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var receiveDatePicker = UIDatePicker()
    var fromDate : Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.addBackButtonView()
        self.addSaveBtn()
        addDatePicker()
        NotificationCenter.default.addObserver(self, selector: #selector(InwardChalanDetailViewController.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(InwardChalanDetailViewController.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
         self.hideKeyboardWhenTappedAround()
        setDefaults()
        
       
        

        // Do any additional setup after loading the view.
    }

    //Mark:- Back Button
//    private func addBackButtonView()
//    {
//        let imgBackArrow = UIImage(named: "navigation-arrow")
//        
//        navigationController?.navigationBar.backIndicatorImage = imgBackArrow
//        navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBackArrow
//        
//        navigationItem.leftItemsSupplementBackButton = true
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
//    }
    
    //Mark:- Save Button
    func addSaveBtn()
    {
         infoBut = UIBarButtonItem(image: UIImage(named: "icon-Assetinfo"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(infoAction))
        saveBut = UIBarButtonItem(title: "SAVE", style: .plain, target: self, action: #selector(saveAction))
        self.navigationItem.rightBarButtonItems = [saveBut,infoBut]
    }
    
    @objc func saveAction()
    {
        self.view.endEditing(true)
        isAlert = false
        let chalanUploadDate = convertDateIntoString(dateString: inwardDataList.Inward_Upload_Actual_Date)
        let currentDate = inwardDataList.Server_Current_Date.components(separatedBy: " ")
        let currentDateFromServer = convertDateIntoString(dateString: currentDate[0])
        let dateString = convertPickerDateIntoDefault(date: fromDate, format: defaultServerDateFormat)
        let receivedDate = convertDateIntoString(dateString: dateString)
        
        if((chalanUploadDate <= receivedDate) && (receivedDate <= currentDateFromServer))
        {
            for inwardObj in inwardDataList.lstInwardAckDetails
            {
                if(inwardObj.isEntered)
                {
                    if(inwardObj.Pending_Quantity != inwardObj.Received_Quantity)
                    {
                        if(inwardObj.Received_Quantity == defaultEmptyValue)
                        {
                            AlertView.showAlertView(title: alertTitle, message: "Please Enter Received Quantity for \(inwardObj.Product_Name!) ", viewController: self)
                            return
                        }
                        if(inwardObj.Pending_Quantity < inwardObj.Received_Quantity)
                        {
                            AlertView.showAlertView(title: alertTitle, message: "Quantity Entered For \(inwardObj.Product_Name!) is Greater", viewController: self)
                            isAlert = true
                            return
                        }
                        if(inwardObj.Received_Quantity < 0)
                        {
                            AlertView.showAlertView(title: alertTitle, message: "Please Enter Correct Received Quantity for \(inwardObj.Product_Name!) ", viewController: self)
                            return

                        }
                    }
                }
            }
            if(!isAlert)
            {
                for inwardObj in inwardDataList.lstInwardAckDetails
                {
                    if(inwardObj.isEntered)
                    {
                        if(inwardObj.Remarks == EMPTY)
                        {
                            AlertView.showAlertView(title: alertTitle, message: "Please Enter Remarks For \(inwardObj.Product_Name!)", viewController: self)
                            isAlert = true
                            return
                        }
                        if(inwardObj.Remarks.count > 250)
                        {
                            AlertView.showAlertView(title: alertTitle, message: "\(inwardObj.Product_Name!) remarks cannot exceed 250 characters", viewController: self)
                            return
                        }
                        if isSpecialCharacterExist(remarks:inwardObj.Remarks)
                        {
                            let restrictedCharacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
                            AlertView.showSpecialCharacterAlertview(title: alertTitle, subject: "Remarks for \(inwardObj.Product_Name!)", restrictedVal: restrictedCharacter, viewController: self)
                            return
                        }
                    }
                }
            }
            if(!isAlert)
            {
                let filterValue = inwardDataList.lstInwardAckDetails.filter{
                    $0.Received_Quantity > 0
                }
                
                if(filterValue.count == 0)
                {
                  AlertView.showAlertView(title: alertTitle, message: "All received quanity should not be zero", viewController: self)
                    return
                }
            }
            if(!isAlert)
            {
                self.postData()
            }
        }
        else if(receivedDate < chalanUploadDate)
        {
            AlertView.showAlertView(title: alertTitle, message: "Received date can not be less than challan date", viewController: self)
            isAlert = true
            return
        }
        else
        {
            AlertView.showAlertView(title: alertTitle, message: "Received date can not be  date", viewController: self)
            isAlert = true
            return
        }
        
    }
    
    func isSpecialCharacterExist(remarks:String) -> Bool
    {
        let restrictedChatacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
        
        if (remarks.count > 0)
        {
            if restrictedChatacter != ""
            {
                return checkIfSpecialCharacterFound(restrictedCharacter: restrictedChatacter, remarkTxt: remarks)
            }
        }
        return false
    }
    
    func postData()
    {
        if(checkInternetConnectivity())
        {
            showCustomActivityIndicatorView(loadingText: "Saving InWard Details")
            let list :NSMutableArray = []
            
            for (index,element) in inwardDataList.lstInwardAckDetails!.enumerated()
            {
//                if(element.isEntered)
//                {
                    let Inward_Entered_Date = getServerFormattedDateString(date: fromDate)
                let getCurrentDate = getServerFormattedDateString(date:getCurrentDateAndTime())
//                let dict :NSDictionary = ["ID":index+1,"Details_Id":element.Details_Id,"Quantity_Type":"ACK","Uploaded_Qty":element.Sent_Quantity,"Total_Acknowledged_Qty":element.Received_Quantity,"Current_Stock":0,"Inward_Actual_Date":inwardDataList.Inward_Upload_Actual_Date,"Inward_Entered_Date":Inward_Entered_Date,"Company_Code":getCompanyCode(),"User_Code":getUserCode(),"Product_Code":element.Product_Code,"Delivery_Challan_Number":inwardDataList.Delivery_Challan_Number,"Remarks":element.Remarks,"Batch_Number":element.Batch_Number,"Header_Id":inwardDataList.Header_Id]
                
                 let dict :NSDictionary = ["ID":index+1,"Details_Id":element.Details_Id,"Quantity_Type":"ACK","Uploaded_Qty":element.Sent_Quantity,"Total_Acknowledged_Qty":element.Received_Quantity,"Current_Stock":0,"Inward_Actual_Date":Inward_Entered_Date,"Inward_Entered_Date":getCurrentDate,"Company_Code":getCompanyCode(),"User_Code":getUserCode(),"Product_Code":element.Product_Code,"Delivery_Challan_Number":inwardDataList.Delivery_Challan_Number,"Remarks":element.Remarks,"Batch_Number":element.Batch_Number,"Header_Id":inwardDataList.Header_Id]
                    
                    list.add(dict)
               // }
            }
            
            WebServiceHelper.sharedInstance.postInwardAckDetails(postData: list, completion: { (apiObj) in
                if(apiObj.Status == SERVER_SUCCESS_CODE)
                {
                    BL_PrepareMyDevice.sharedInstance.getUserProductMapping(masterDataGroupName: EMPTY, completion: { (status) in
                        removeCustomActivityView()
                        BL_Upload_DCR.sharedInstance.isFromDCRUpload = false
                        _ = self.navigationController?.popViewController(animated: false)
                    })
                }
                else
                {
                    removeCustomActivityView()
                    AlertView.showAlertView(title: errorTitle, message: "Try Again", viewController: self)
                }
            })

        }
        else
        {
            showToastView(toastText: "No Internet Connection")
        }
        
    }
    @objc func infoAction()
    {
        AlertView.showAlertView(title: alertTitle, message: "To Acknowledge Inward quantity, Received Date should be greater than the Delivery Challan date.\n\nTo Acknowledge Inward quantity, Remarks are Mandatory,when Recieved Quantity is less than Pending Quantity.", viewController: self)
    }
    func setDefaults()
    {
        deliverChalanNo.text = inwardDataList.Delivery_Challan_Number!
        let uploadDate = convertDateIntoString(dateString: inwardDataList.Inward_Upload_Actual_Date!)
        let appFormat = convertDateIntoString(date: uploadDate)
        deliverDate.text = appFormat
        inwardList = inwardDataList.lstInwardAckDetails
        self.tableView.reloadData()
        
    }
    private func addDatePicker()
    {
        receiveDatePicker = getDatePickerView()
        receiveDatePicker.maximumDate = Date()
        receiveDatePicker.setDate(Date(), animated: false)
        fromDate = receiveDatePicker.date
        let doneToolbar = getToolBar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        doneToolbar.sizeToFit()
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(GeoReportDateViewController.fromPickerDoneAction))
        let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(GeoReportDateViewController.cancelBtnClicked))
        
        doneToolbar.items = [flexSpace, done, cancel]
        
        receiveDatePicker.tag = 1
        setDateDetails(sender: receiveDatePicker)
        dateTxtFld.inputAccessoryView = doneToolbar
        dateTxtFld.inputView = receiveDatePicker
    }
    
    @objc func fromPickerDoneAction()
    {
        fromDate = receiveDatePicker.date
        setDateDetails(sender: receiveDatePicker)
        resignResponderForTextField()
    }
    @objc func cancelBtnClicked()
    {
        self.resignResponderForTextField()
    }
    @objc func resignResponderForTextField()
    {
        self.dateTxtFld.resignFirstResponder()
    }
    private func setDateDetails(sender : UIDatePicker)
    {
        let date = convertPickerDateIntoDefault(date: sender.date, format: defaultDateFomat)
        
        if sender.tag == 1
        {
            self.dateTxtFld.text = date
        }
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inwardDataList.lstInwardAckDetails.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "InwardDetailTableViewCell") as! InwardDetailTableViewCell
        let inwardObj = inwardDataList.lstInwardAckDetails[indexPath.row]
        cell.productType.text = inwardObj.Product_Type
        cell.productName.text = inwardObj.Product_Name
        cell.sentQty.text = "\(inwardObj.Sent_Quantity!)"
        if(inwardObj.isEntered)
        {
            cell.receiveQty.text = "\(inwardObj.Received_Quantity!)"
        }
        else
        {
           cell.receiveQty.text = "\(inwardObj.Received_Quantity!)"
        }
        if inwardObj.Batch_Number == EMPTY
        {
            cell.batchNumber.text = EMPTY
            cell.batchNumberLbl.text = EMPTY
        }
        else
        {
            cell.batchNumber.text = inwardObj.Batch_Number
            cell.batchNumberLbl.text = "Batch Number"
        }
        cell.receivedSoFar.text = "\(inwardObj.Received_So_Far!)"
        cell.pendingQty.text = "\(inwardObj.Pending_Quantity!)"
        cell.remarks.text = inwardObj.Remarks
        cell.remarks.delegate = self
        cell.remarks.tag = indexPath.row
        cell.receiveQty.delegate = self
        cell.receiveQty.tag = indexPath.row
        cell.viewBut.tag = indexPath.row
        cell.viewBut.addTarget(self, action: #selector(self.navigateHistoryView(sender:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 340
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        let row = textView.tag
      inwardDataList.lstInwardAckDetails[row].Remarks = textView.text
        inwardDataList.lstInwardAckDetails[row].isEntered = true
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
        let row = textView.tag
        inwardDataList.lstInwardAckDetails[row].Remarks = textView.text
        inwardDataList.lstInwardAckDetails[row].isEntered = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        let row = textField.tag
        let value = textField.text!
        let text = textField.text!
        if(textField.text != EMPTY || text.count > 0)
        {
            inwardDataList.lstInwardAckDetails[row].Received_Quantity = Int(value)
        }
        else
        {
         inwardDataList.lstInwardAckDetails[row].Received_Quantity = defaultEmptyValue
        }
        inwardDataList.lstInwardAckDetails[row].isEntered = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        let row = textField.tag
        let value = textField.text!
        inwardDataList.lstInwardAckDetails[row].Received_Quantity = Int(value)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let row = textField.tag
        let value = textField.text!
        inwardDataList.lstInwardAckDetails[row].Received_Quantity = Int(value)
        return true
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
//        let pointInTable:CGPoint = (tableView.superview?.convert(textView.frame.origin, to: self.tableView))!
//        var contentOffset:CGPoint = tableView.contentOffset
//        contentOffset.y  = pointInTable.y
//        if let accessoryView = textView.inputAccessoryView {
//            contentOffset.y -= accessoryView.frame.size.height
//        }
//        tableView.contentOffset = contentOffset
//        return true
        
        let pointInTable:CGPoint = textView.superview!.convert(textView.frame.origin, to: tableView)
        var contentOffset:CGPoint = tableView.contentOffset
        contentOffset.y  = pointInTable.y
        if let accessoryView = textView.inputAccessoryView
        {
            contentOffset.y -= accessoryView.frame.size.height + 100
        }
        tableView.contentOffset = contentOffset
        return true
    }
    

    @objc func navigateHistoryView(sender:UIButton)
    {
        //let inwarddata = inwardDataList[indexPath.row]
        let sb = UIStoryboard(name: commonListSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: InwardRemarksViewControllerID) as!InwardRemarksViewController
       vc.headerId = inwardDataList.lstInwardAckDetails[sender.tag].Details_Id
        vc.batchNum = inwardDataList.lstInwardAckDetails[sender.tag].Batch_Number
        self.navigationController?.pushViewController(vc, animated: false)
        
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
            contentInset.bottom = keyboardFrame.size.height
            self.tableView.contentInset = contentInset
            
            //get indexpath
            // let indexpath = IndexPath(row: 1, section: 0)
            //  self.tableView.scrollToRow(at: indexpath, at: UITableViewScrollPosition.top, animated: true)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        let contentInsets = UIEdgeInsets.zero
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
    }
    
   
}
