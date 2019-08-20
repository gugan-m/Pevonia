//
//  CreateTaskViewController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 03/06/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class CreateTaskViewController: UIViewController {

    @IBOutlet weak var dueDatePicker: UITextField!
    @IBOutlet weak var taskText: UITextView!
    @IBOutlet weak var taskDescri: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var receiveDatePicker = UIDatePicker()
    var fromDate : Date!
     var userCode =  String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Task"
        self.addBackButtonView()
        NotificationCenter.default.addObserver(self, selector: #selector(CreateTaskViewController.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateTaskViewController.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.hideKeyboardWhenTappedAround()
        addDatePicker()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addDatePicker()
    {
        receiveDatePicker = getDatePickerView()
        receiveDatePicker.minimumDate = Date()
        receiveDatePicker.setDate(Date(), animated: false)
        fromDate = receiveDatePicker.date
        let doneToolbar = getToolBar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        doneToolbar.sizeToFit()
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(IceFeedbackViewController.fromPickerDoneAction))
        let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(IceFeedbackViewController.cancelBtnClicked))
        
        doneToolbar.items = [flexSpace, done, cancel]
        
        receiveDatePicker.tag = 1
        setDateDetails(sender: receiveDatePicker)
        dueDatePicker.inputAccessoryView = doneToolbar
        dueDatePicker.inputView = receiveDatePicker
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
        self.dueDatePicker.resignFirstResponder()
    }
    private func setDateDetails(sender : UIDatePicker)
    {
        let date = convertPickerDateIntoDefault(date: sender.date, format: defaultDateFomat)
        
        if sender.tag == 1
        {
            self.dueDatePicker.text = date
        }
        
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
    
    @IBAction func createTask(_ sender:UIButton)
    {
       self.createTask()
    }
    
    func createTask()
    {
        if(taskText.text == EMPTY)
        {
           AlertView.showAlertView(title: alertTitle, message: "Please Enter Task Name", viewController: self)
        }
        else if(taskDescri.text == EMPTY)
        {
           AlertView.showAlertView(title: alertTitle, message: "Please Enter Task Description", viewController: self)
        }
        else if(dueDatePicker.text == EMPTY)
        {
            AlertView.showAlertView(title: alertTitle, message: "Please select DueDate", viewController: self)
        }
        else
        {
            let dueDate = getServerFormattedDateString(date: fromDate)
            let postData = ["taskName":taskText.text,"taskDescription":taskDescri.text,"taskDueDate":dueDate] as [String : Any]
            if(checkInternetConnectivity())
            {
                showCustomActivityIndicatorView(loadingText: "Creating Task...")
                WebServiceHelper.sharedInstance.createTask(userCode: userCode, postData:postData, completion: { (apiObj) in
                    if(apiObj.Status == SERVER_SUCCESS_CODE)
                    {
                        removeCustomActivityView()
                        showToastView(toastText: "Task created")
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
    }
}
