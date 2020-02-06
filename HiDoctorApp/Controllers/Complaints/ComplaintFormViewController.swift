//
//  ComplaintFormViewController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 17/05/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class ComplaintFormViewController: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var problemTxt: UITextView!
    @IBOutlet weak var remarTxtx:  UITextView!
    @IBOutlet weak var selectedCustomerName: UILabel!
    @IBOutlet weak var scrollView:  UIScrollView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButtonView()
        self.title = "Complaint Form"
        remarTxtx.delegate = self
        problemTxt.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(ComplaintFormViewController.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ComplaintFormViewController.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.hideKeyboardWhenTappedAround()
        
        BL_Customer_Complaint.sharedInstance.selectedCustomerDetail = nil
        BL_Customer_Complaint.sharedInstance.customerProblemText = ""
        BL_Customer_Complaint.sharedInstance.customerRemarkText = ""
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
       self.setDefaults()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setDefaults()
    {
        if let customerName = BL_Customer_Complaint.sharedInstance.selectedCustomerDetail?.Customer_Name
        {
            if(customerName != "")
            {
                selectedCustomerName.text = customerName
            }
            else
            {
                selectedCustomerName.text = "Select Contact"
            }
        }
        else
        {
            selectedCustomerName.text = "Select Contact"
        }
        problemTxt.text = BL_Customer_Complaint.sharedInstance.customerProblemText
        remarTxtx.text = BL_Customer_Complaint.sharedInstance.customerRemarkText
        
    }
    
    @IBAction func selectCustomer(_ sender: UIButton)
    {
        BL_Customer_Complaint.sharedInstance.customerProblemText = problemTxt.text
        BL_Customer_Complaint.sharedInstance.customerRemarkText = remarTxtx.text
        if isManager()
        {
            let sb = UIStoryboard(name: commonListSb, bundle: nil)
            let vc:UserListViewController = sb.instantiateViewController(withIdentifier: userListVcID) as! UserListViewController
            vc.navigationScreenName = doctorMasterVcID
            vc.isFromDCR = false
            vc.isFromComplaint = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let sb = UIStoryboard(name: commonListSb, bundle: nil)
            let vc:ComplaintCustomerListViewController = sb.instantiateViewController(withIdentifier: ComplaintCustomerListViewControllerID) as! ComplaintCustomerListViewController
            vc.regionCode = getRegionCode()
            vc.regionName = getRegionName()
            vc.isFromComplaintTrack = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func saveAction(_ sender: UIButton)
    {
    validation()
    }
    
    func setSelectedCustomerDetails(accompanistObj: CustomerMasterModel,isFromCc:Bool)
    {
        selectedCustomerName.text = accompanistObj.Customer_Name
        
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
        
        let pointInTable:CGPoint = scrollView.superview!.convert(textView.frame.origin, to: scrollView)
        var contentOffset:CGPoint = scrollView.contentOffset
        contentOffset.y  = pointInTable.y
        if let accessoryView = scrollView.inputAccessoryView
        {
            contentOffset.y -= accessoryView.frame.size.height + 100
        }
        scrollView.contentOffset = contentOffset
        return true
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
            
            var contentInset:UIEdgeInsets = self.scrollView.contentInset
            contentInset.bottom = keyboardFrame.size.height
            self.scrollView.contentInset = contentInset
            
            //get indexpath
            // let indexpath = IndexPath(row: 1, section: 0)
            //  self.tableView.scrollToRow(at: indexpath, at: UITableViewScrollPosition.top, animated: true)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        let contentInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func submitComplaintForm()
    {
        
        let postData : [String:Any] = ["Complaint_Company_Code":getCompanyCode(),"Complaint_Customer_Region_Code":BL_Customer_Complaint.sharedInstance.selectedCustomerDetail!.Region_Code,"Complaint_User_Code":getUserCode(),"Customer_Code":BL_Customer_Complaint.sharedInstance.selectedCustomerDetail!.Customer_Code,"Customer_Entity_Type":BL_Customer_Complaint.sharedInstance.selectedCustomerDetail!.Customer_Entity_Type,"Customer_Id":0,"Customer_Status":0,"Lat":0,"Lng":0,"PageNo":0,"Problem_Description":self.remarTxtx.text,"Problem_Short_Description":self.problemTxt.text,"Region_Code":getRegionCode(),"customerNameHeader":false,"flag":false,"isAlreadyAdded":0,"isEnable":false,"isServerUpdated":false]
        if(checkInternetConnectivity())
        {
            showCustomActivityIndicatorView(loadingText: "Submiting Complaints...")
            WebServiceHelper.sharedInstance.customerComplaintPost(postData:postData, completion: { (apiObj) in
                if(apiObj.Status == SERVER_SUCCESS_CODE)
                {
                    removeCustomActivityView()
                    showToastView(toastText: "Complaint Submited")
                    self.navigationController?.popViewController(animated: false)
                }
                else
                {
                    removeCustomActivityView()
                    AlertView.showAlertView(title: errorTitle, message:apiObj.Message, viewController: self)
                }
            })
        }
        else
        {
            AlertView.showAlertView(title: internetOfflineTitle, message: internetOfflineMessage, viewController: self)
        }
    }
    
    func validation()
    {
        var complaintCustomerName = String()
        if let customerName = BL_Customer_Complaint.sharedInstance.selectedCustomerDetail?.Customer_Name
        {
            if(customerName != "")
            {
                complaintCustomerName = customerName
            }
            else
            {
                complaintCustomerName = customerName
            }
        }
        else
        {
            complaintCustomerName = ""
        }
        if(complaintCustomerName == "")
        {
            AlertView.showAlertView(title: errorTitle, message: "Please Select Contact", viewController: self)
        }
        else if checkNullAndNilValueForString(stringData: problemTxt.text).count > flexiPlaceMaxLength
        {
            AlertView.showMaxLengthExceedAlertView(title: alertTitle, subject: "Problem", maxVal: flexiPlaceMaxLength, viewController: self)
        }
        else if(problemTxt.text == "")
        {
            AlertView.showAlertView(title: errorTitle, message: "Please Enter Problem", viewController: self)
        }
        else if(remarTxtx.text == "")
        {
             AlertView.showAlertView(title: errorTitle, message: "Please Enter Remark", viewController: self)
        }
        else if checkNullAndNilValueForString(stringData: remarTxtx.text).count > tpRemarksLength
        {
            AlertView.showMaxLengthExceedAlertView(title: alertTitle, subject: "Remark", maxVal: flexiPlaceMaxLength, viewController: self)
        }
        else if isSpecialCharacterExist(remarks:problemTxt.text)
        {
            let restrictedCharacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
            AlertView.showSpecialCharacterAlertview(title: alertTitle, subject: "Problem for \(problemTxt.text)", restrictedVal: restrictedCharacter, viewController: self)
            return
        }
        else if isSpecialCharacterExist(remarks:remarTxtx.text)
        {
            let restrictedCharacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
            AlertView.showSpecialCharacterAlertview(title: alertTitle, subject: "Remarks for \(remarTxtx.text)", restrictedVal: restrictedCharacter, viewController: self)
            return
        }
        else
        {
            submitComplaintForm()
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

}
