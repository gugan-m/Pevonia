//
//  IceFeedbackViewController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 30/05/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class IceFeedbackViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIScrollViewDelegate {
    
    
    @IBOutlet weak var emptyStateLbl : UILabel!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var feddbackDatePicker: UITextField!
    @IBOutlet weak var remarkHeightConst: NSLayoutConstraint!
    @IBOutlet weak var submitButHeight: NSLayoutConstraint!
    @IBOutlet weak var overAllRemark: UITextView!
    var userCode = String()
    var userName = String()
    var iceList : [ICEQueAnsList] = []
    var receiveDatePicker = UIDatePicker()
    var fromDate : Date!
    var attachBut : UIBarButtonItem!
    var activeTextview: UITextView?
    var keyBoardHeight = CGFloat()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ICE Form"
        remarkHeightConst.constant = 0
        submitButHeight.constant = 0
        self.addBackButtonView()
        addDatePicker()
        self.addFeedBackBtn()
        BL_ICE_Task.sharedInstance.selectedDate = ""
        NotificationCenter.default.addObserver(self, selector: #selector(IceFeedbackViewController.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(IceFeedbackViewController.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.hideKeyboardWhenTappedAround()
        setDefaults()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        if(BL_ICE_Task.sharedInstance.selectedDate != nil && BL_ICE_Task.sharedInstance.selectedDate != EMPTY)
        {
            let dateToValue = convertDateIntoString(dateString: BL_ICE_Task.sharedInstance.selectedDate)
            let appFormatModifiyFromDate = convertDateIntoString(date: dateToValue)
            feddbackDatePicker.text = appFormatModifiyFromDate
            
            //feddbackDatePicker.text = BL_ICE_Task.sharedInstance.selectedDate
           // convertServerDateStringToDate(BL_ICE_Task.sharedInstance.selectedDate)
        }
    }
    func setDefaults()
    {
        self.tableView.isHidden = true
        self.emptyStateLbl.isHidden = true
        self.tableView.tableFooterView = UIView()
        self.overAllRemark.layer.borderColor = UIColor.gray.cgColor
        self.overAllRemark.layer.borderWidth = 0.9
        self.overAllRemark.delegate = self
        getICEQuestions()
        
        
    }
    
    func getICEQuestions()
    {
        if(checkInternetConnectivity())
        {
            showCustomActivityIndicatorView(loadingText: "Loading....")
            WebServiceHelper.sharedInstance.getICEFeedbackQuestions(userCode: userCode) { (apiObj) in
                if(apiObj.Status == SERVER_SUCCESS_CODE)
                {
                    removeCustomActivityView()
                    if(apiObj.list.count > 0)
                    {
                        for obj in apiObj.list
                        {
                            let iceQueAnsData = obj as! NSDictionary
                            let iceAnsList = iceQueAnsData.value(forKey: "RatingList") as! NSArray
                            let iceObj = ICEQueAnsList()
                            
                            iceObj.Questions = iceQueAnsData.value(forKey: "Questions") as! String
                            iceObj.Question_Active = iceQueAnsData.value(forKey: "Question_Active") as! Int
                            iceObj.Question_Id = iceQueAnsData.value(forKey: "Question_Id") as! Int
                            iceObj.Question_Type = iceQueAnsData.value(forKey: "Question_Type") as! Int
                            
                            var answerList :[ICEAnswerList] = []
                            for iceAnswerObj in  iceAnsList
                            {
                                let iceAnsObj = ICEAnswerList()
                                let iceAnsData = iceAnswerObj as! NSDictionary
                                
                                iceAnsObj.Rating_Value = iceAnsData.value(forKey: "Rating_Value") as! Int
                                iceAnsObj.Parameter_Id = iceAnsData.value(forKey: "Parameter_Id") as! Int
                                iceAnsObj.Question_Id = iceAnsData.value(forKey: "Question_Id") as! Int
                                iceAnsObj.Rating_Description = iceAnsData.value(forKey: "Rating_Description") as! String
                                
                                answerList.append(iceAnsObj)
                            }
                            
                            iceObj.answerList = answerList
                            
                            self.iceList.append(iceObj)
                            
                            
                        }
                        self.tableView.isHidden = false
                        self.emptyStateLbl.isHidden = true
                        self.emptyStateLbl.text = ""
                        self.tableView.reloadData()
                    }
                    else
                    {
                        self.tableView.isHidden = true
                        self.emptyStateLbl.isHidden = false
                        self.emptyStateLbl.text = "No ICE Feedback found"
                    }
                }
                else
                {
                    removeCustomActivityView()
                    AlertView.showAlertView(title: errorTitle, message: apiObj.Message, viewController: self)
                }
            }
            
        }
        else
        {
            AlertView.showAlertView(title: internetOfflineTitle, message: internetOfflineMessage, viewController: self)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.iceList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.iceList[section].isExpand)
        {
            return self.iceList[section].answerList.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "IceFeedbackQuestionCellID") as! IceFeedbackQuestionCell
        cell1.questionTextLbl.text = self.iceList[section].Questions
        cell1.expandButton.tag = section
        cell1.expandButton.addTarget(self, action: #selector(expandTableViewCell(sender:)), for: .touchUpInside)
        if(self.iceList[section].isExpand)
        {
            cell1.arrowImage.image = UIImage(named: "icon-stepper-up-arrow")
        }
        else
        {
            cell1.arrowImage.image = UIImage(named: "icon-stepper-down-arrow")
        }
        return cell1.contentView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if(self.iceList[section].isExpand)
        {
            let cell1 = self.tableView.dequeueReusableCell(withIdentifier: "IceFeedbackRemarkCellID") as! IceFeedbackRemarkCell
            cell1.remarkTextView.text = self.iceList[section].remarks
            cell1.remarkTextView.delegate = self
            cell1.remarkTextView.tag = section
            if(cell1.remarkTextView.text == "")
            {
                cell1.remarkTextView.text = "Enter Remarks"
                cell1.remarkTextView.textColor = UIColor.gray
            }
            else
            {
                cell1.remarkTextView.textColor = UIColor.black
            }
            return cell1.contentView
        }
        else
        {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = self.tableView.dequeueReusableCell(withIdentifier: "IceFeedbackAnswerCellID") as! IceFeedbackAnswerCell
        cell1.answerTextLbl.text = self.iceList[indexPath.section].answerList[indexPath.row].Rating_Description
        if(self.iceList[indexPath.section].answerList[indexPath.row].isSelected)
        {
            cell1.radioImage.image = UIImage(named: "icon-radio-selected")
        }
        else
        {
            cell1.radioImage.image = UIImage(named: "icon-radio-unselected")
        }
        return cell1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for (index,_) in self.iceList[indexPath.section].answerList.enumerated()
        {
            if(index == indexPath.row)
            {
                self.iceList[indexPath.section].answerList[index].isSelected = true
            }
            else
            {
                self.iceList[indexPath.section].answerList[index].isSelected = false
            }
        }
        self.tableView.reloadData()
        
        var totalSelected = Int()
        for obj in self.iceList
        {
            let filterValue = obj.answerList.filter{
                $0.isSelected == true
            }
            
            if(filterValue.count > 0)
            {
                totalSelected += 1
            }
        }
        if(totalSelected == self.iceList.count)
        {
            remarkHeightConst.constant = 65
            submitButHeight.constant = 30
        }
        else
        {
            remarkHeightConst.constant = 0
            submitButHeight.constant = 0
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return getTextSize(text: self.iceList[section].Questions, fontName: fontRegular, fontSize: 15, constrainedWidth: SCREEN_WIDTH - 44).height + 30
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        if(self.iceList[section].isExpand)
        {
            return 85
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getTextSize(text: self.iceList[indexPath.section].answerList[indexPath.row].Rating_Description, fontName: fontRegular, fontSize: 15, constrainedWidth: SCREEN_WIDTH - 49).height + 16
    }
    
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //
    //        if(indexPath.section + 1 == self.iceList.count || indexPath.row + 1 == self.iceList[indexPath.section].answerList.count)
    //        {
    //            remarkHeightConst.constant = 65
    //            submitButHeight.constant = 30
    //        }
    //        else
    //        {
    //            remarkHeightConst.constant = 0
    //            submitButHeight.constant = 0
    //        }
    //    }
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //
    //        //If we reach the end of the table.
    //        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
    //        {
    //            remarkHeightConst.constant = 65
    //            submitButHeight.constant = 30
    //        }
    //        else
    //        {
    //            remarkHeightConst.constant = 0
    //            submitButHeight.constant = 0
    //        }
    //    }
    
    @objc func expandTableViewCell(sender:UIButton)
    {
        let index = sender.tag
        self.iceList[index].isExpand = !self.iceList[index].isExpand
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
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(IceFeedbackViewController.fromPickerDoneAction))
        let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(IceFeedbackViewController.cancelBtnClicked))
        
        doneToolbar.items = [flexSpace, done, cancel]
        
        receiveDatePicker.tag = 1
        setDateDetails(sender: receiveDatePicker)
        feddbackDatePicker.inputAccessoryView = doneToolbar
        feddbackDatePicker.inputView = receiveDatePicker
    }
    
    @objc func fromPickerDoneAction()
    {
        fromDate = receiveDatePicker.date
        setDateDetails(sender: receiveDatePicker)
        BL_ICE_Task.sharedInstance.selectedDate = ""
        resignResponderForTextField()
    }
    @objc func cancelBtnClicked()
    {
        self.resignResponderForTextField()
    }
    @objc func resignResponderForTextField()
    {
        self.feddbackDatePicker.resignFirstResponder()
    }
    private func setDateDetails(sender : UIDatePicker)
    {
        let date = convertPickerDateIntoDefault(date: sender.date, format: defaultDateFomat)
        
        if sender.tag == 1
        {
            self.feddbackDatePicker.text = date
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
            
            var contentInset:UIEdgeInsets = self.tableView.contentInset
            contentInset.bottom = keyboardFrame.size.height
            self.tableView.contentInset = contentInset
            
            if let activeTextview=activeTextview{
                let contentInsets = UIEdgeInsets.zero
                self.tableView.contentInset = contentInsets
                self.tableView.scrollIndicatorInsets = contentInsets
                // self.view.frame.origin.y -= keyboardFrame.height
                
            }
            self.keyBoardHeight = keyboardFrame.height
            //get indexpath
            // let indexpath = IndexPath(row: 1, section: 0)
            //  self.tableView.scrollToRow(at: indexpath, at: UITableViewScrollPosition.top, animated: true)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        let contentInsets = UIEdgeInsets.zero
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
        
    
//        if(activeTextview != nil)
//        {
//            self.view.frame.origin.y += keyboardFrame.height
//        }
        
    }
    
    @IBAction func viewDates(_ sender: UIButton) {
        
        let sb = UIStoryboard(name: commonListSb, bundle: nil)
        let vc:IceDatesListViewController = sb.instantiateViewController(withIdentifier: IceDatesListViewControllerID) as! IceDatesListViewController
        vc.userName = self.userName
        vc.userCode = self.userCode
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if(textView.tag == 99)
        {
            if(textView.text == "Over All Remarks")
            {
                overAllRemark.text = ""
                textView.textColor = UIColor.black
            }
            else
            {
                overAllRemark.text = textView.text
            }
            activeTextview = nil
        }
        else
        {
            if(textView.text == "Enter Remarks")
            {
                self.iceList[textView.tag].remarks = ""
            }
            else
            {
                self.iceList[textView.tag].remarks = textView.text
            }
        }
        
//        let pointInTable:CGPoint = textView.superview!.convert(textView.frame.origin, to: tableView)
//        var contentOffset:CGPoint = tableView.contentOffset
//        contentOffset.y  = pointInTable.y
//        if let accessoryView = textView.inputAccessoryView
//        {
//            contentOffset.y -= accessoryView.frame.size.height + 100
//        }
//        tableView.contentOffset = contentOffset
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView.tag == 99)
        {
            activeTextview = textView
            if(textView.text == "Over All Remarks")
            {
                textView.text = ""
                textView.textColor = UIColor.black
            }
            
        }
        else
        {
            
            if(textView.text == "Enter Remarks")
            {
                textView.text = ""
                textView.textColor = UIColor.black
            }
        }
        
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if(textView.tag == 99)
        {
            activeTextview = textView
        }
      
        
        //        let pointInTable:CGPoint = (tableView.superview?.convert(textView.frame.origin, to: self.tableView))!
        //        var contentOffset:CGPoint = tableView.contentOffset
        //        contentOffset.y  = pointInTable.y
        //        if let accessoryView = textView.inputAccessoryView {
        //            contentOffset.bo = 343
        //        }
        //        tableView.contentOffset = contentOffset
        
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
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.tag == 99)
        {
//            if(activeTextview != nil)
//            {
//                self.view.frame.origin.y += self.keyBoardHeight
//            }
        }
        activeTextview = nil
    }
    func addFeedBackBtn()
    {
        attachBut = UIBarButtonItem(image: UIImage(named: "visiblity_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(showFeedbackAction))
        
        self.navigationItem.rightBarButtonItems = [attachBut]
    }
    
    @objc func showFeedbackAction()
    {
        let sb = UIStoryboard(name: commonListSb, bundle: nil)
        let vc:IceFeedbackHistoryViewController = sb.instantiateViewController(withIdentifier:IceFeedbackHistoryViewControllerID) as! IceFeedbackHistoryViewController
        
        vc.userCode = self.userCode
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func saveRatings()
    {
        let iceArray = NSMutableArray()
        for iceObj in self.iceList
        {
            let ratingArray = NSMutableArray()
            
            let filteredRating = iceObj.answerList.filter{
                $0.isSelected == true
            }
            for ratingObj in filteredRating
            {
                let ratingDict = ["Rating_Value":ratingObj.Rating_Value,"Rating_Description":ratingObj.Rating_Description,"Question_Id":ratingObj.Question_Id,"Parameter_Id":ratingObj.Parameter_Id,"Remarks":iceObj.remarks] as [String : Any]
                if checkNullAndNilValueForString(stringData: iceObj.remarks).count > doctorRemarksMaxLength
                {
                    AlertView.showMaxLengthExceedAlertView(title: alertTitle, subject: "Remarks for \(iceObj.Questions)", maxVal: doctorRemarksMaxLength, viewController: self)
                    return
                }
                ratingArray.add(ratingDict)
            }
            let iceDict = ["Questions":iceObj.Questions,"Question_Id":iceObj.Question_Id,"Question_Active":iceObj.Question_Active,"Question_Type":iceObj.Question_Type,"lstRating":ratingArray] as [String : Any]
            
            iceArray.add(iceDict)
            
        }
        
        if checkNullAndNilValueForString(stringData: self.overAllRemark.text).count > doctorRemarksMaxLength
        {
            AlertView.showMaxLengthExceedAlertView(title: alertTitle, subject: "OverAll Remarks", maxVal: doctorRemarksMaxLength, viewController: self)
            return
        }
        var overAllRemarks = String()
        if(self.overAllRemark.text == "Over All Remarks" || self.overAllRemark.text == "Enter Remarks")
        {
            overAllRemarks = ""
        }
        else
        {
            overAllRemarks = self.overAllRemark.text
        }
        let icePostData = ["OverAllRemarks":overAllRemarks,"lstMappedUserQuestionsNew":iceArray] as [String : Any]
        var date = String()
        if(BL_ICE_Task.sharedInstance.selectedDate != nil && BL_ICE_Task.sharedInstance.selectedDate != EMPTY)
        {
           date = BL_ICE_Task.sharedInstance.selectedDate
        }
        else
        {
            date = getServerFormattedDateString(date: fromDate)
        }
        if(checkInternetConnectivity())
        {
            showCustomActivityIndicatorView(loadingText: "Submiting ICE Form....")
            WebServiceHelper.sharedInstance.postIceRatings(selectedUserCode: userCode, createdBy:getUserName(), evaluatedDate: date, postData: icePostData) { (apiObj) in
                if(apiObj.Status == SERVER_SUCCESS_CODE)
                {
                    removeCustomActivityView()
                    _ = self.navigationController?.popViewController(animated: true)
                    
                }
                else
                {
                    removeCustomActivityView()
                    AlertView.showAlertView(title: errorTitle, message: apiObj.Message, viewController: self)
                }
            }
        }
        else
        {
            AlertView.showAlertView(title: internetOfflineTitle, message: internetOfflineMessage, viewController: self)
        }
        
    }
    
    @IBAction func submitAction(_ sender:UIButton)
    {
        if(feddbackDatePicker.text == "")
        {
            AlertView.showAlertView(title: errorTitle, message: "Please Select Feedback Date", viewController: self)
        }
        else
        {
        saveRatings()
        }
    }
}
