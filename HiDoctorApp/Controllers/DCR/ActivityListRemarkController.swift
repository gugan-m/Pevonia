//
//  ActivityListRemarkController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 20/03/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class ActivityListRemarkController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate {
   
    @IBOutlet weak var tableView : UITableView!
    var activityDataList: [ActivityListObj] = []
    var saveBut : UIBarButtonItem!
    var isFromCallActivityEdit: Bool!
    var isFromMCActivity = Bool()
    var mcCampaignCode = String()
    var mcCampaignName = String()
    var isFromAttendance: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.addBackButtonView()
        
        self.addSaveBtn()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ActivityListRemarkController.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ActivityListRemarkController.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityListRemarksTableViewCell") as! ActivityListRemarksTableViewCell
        let activityData = activityDataList[indexPath.row]
        cell.activityText.text = activityData.activityName
       cell.activityTextView.delegate = self
        cell.activityTextView.addHideinputAccessoryView()
        cell.activityTextView.tag = indexPath.row
        cell.bgView.backgroundColor = UIColor.white
        if (activityData.isSelected)
        {
            cell.textViewHeight.constant = 50
            cell.labelViewHeight.constant = 17
            cell.activityTextView.text = activityData.remarks
            cell.selectionImageView.image = UIImage(named: "icon-check")
        }
        else
        {
            cell.textViewHeight.constant = 0
            cell.labelViewHeight.constant = -1
            activityData.remarks = ""
            cell.selectionImageView.image = UIImage(named: "icon-uncheck")
        }
        if(activityData.isAdded)
        {
           cell.bgView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
           cell.selectionImageView.image = UIImage(named: "icon-check")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         let activityData = activityDataList[indexPath.row]
        if (activityData.isSelected)
        {
            return 115
        }
        else
        {
            return 42
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let activityData = activityDataList[indexPath.row]
        if(!activityData.isAdded)
        {
        activityData.isSelected = !activityData.isSelected
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        let index = textView.tag
        let activityData = activityDataList[index]
        activityData.remarks = textView.text
    }
    func textViewDidChange(_ textView: UITextView) {
        let index = textView.tag
        let activityData = activityDataList[index]
        activityData.remarks = textView.text
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
    
    func addSaveBtn()
    {
        
        saveBut = UIBarButtonItem(title: "SAVE", style: .plain, target: self, action: #selector(saveAction))
        self.navigationItem.rightBarButtonItems = [saveBut]
    }
    
    @objc func saveAction()
    {
        let filterIsSelected = activityDataList.filter{
            $0.isSelected == true
        }
        
        for activityDat in filterIsSelected
        {
            if(activityDat.remarks.count > 250)
            {
                AlertView.showAlertView(title: alertTitle, message: "\(activityDat.activityName) remarks cannot exceed 250 characters", viewController: self)
                return
            }
            if isSpecialCharacterExist(remarks:activityDat.remarks)
            {
                let restrictedCharacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
                AlertView.showSpecialCharacterAlertview(title: alertTitle, subject: "Remarks for \(activityDat.activityName)", restrictedVal: restrictedCharacter, viewController: self)
                return
            }
        }
        var entityType = String()
        if isFromAttendance
        {
            entityType = sampleBatchEntity.Attendance.rawValue
        }
        else
        {
            entityType = sampleBatchEntity.Doctor.rawValue
        }
        if(isFromMCActivity)
        {
            if(isFromCallActivityEdit)
            {
                let filterIsNotSelected = activityDataList.filter{
                    $0.isSelected == false
                }
                for activityData in filterIsNotSelected
                {
                    DBHelper.sharedInstance.updateDoctorMCCallActivityData(doctorVisitCode: DCRModel.sharedInstance.customerVisitId, activityID: activityData.activityId,CampaignCode: mcCampaignCode, entityType: entityType)
                }
                for activityData in filterIsSelected
                {
                    DBHelper.sharedInstance.updateDoctorMCCallActivityData(doctorVisitCode: DCRModel.sharedInstance.customerVisitId, activityID: activityData.activityId,CampaignCode: mcCampaignCode, entityType: entityType)
                }
            }
            
            var activityList:[NSDictionary] = []
            for activityData in filterIsSelected
            {
                
                let CategoryData:NSDictionary = ["DCR_Id":getDCRId(),"DCR_Customer_Visit_Id":getDoctorVisitId(),"Visit_Code":"","Flag":ActivityFlag.Field.rawValue,"Customer_Entity_Type":customerEntityInt.Doctor.rawValue,"Customer_Entity_Type_Description":customerEntityDescribtion.Doctor.rawValue,"Campaign_Code":mcCampaignCode,"Campaign_Name":mcCampaignName,"MC_Activity_Id":activityData.activityId,"Activity_Name":activityData.activityName,"MC_Remark":activityData.remarks,"Entity_Type":entityType]
                
                activityList.append(CategoryData)
            }
            
            DBHelper.sharedInstance.insertDCRMCCallActivityList(array: activityList as NSArray)
        }
        else
        {
            //procced
            if(isFromCallActivityEdit)
            {
                let filterIsNotSelected = activityDataList.filter{
                    $0.isSelected == false
                }
                for activityData in filterIsNotSelected
                {
                    DBHelper.sharedInstance.updateDoctorCallActivityData(doctorVisitCode: DCRModel.sharedInstance.customerVisitId, activityID: activityData.activityId, entityType: entityType)
                }
                for activityData in filterIsSelected
                {
                    DBHelper.sharedInstance.updateDoctorCallActivityData(doctorVisitCode: DCRModel.sharedInstance.customerVisitId, activityID: activityData.activityId, entityType: entityType)
                }
            }
            //            else
            //            {
            //            DBHelper.sharedInstance.deleteDoctorCallActivityData(doctorVisitCode: DCRModel.sharedInstance.customerVisitId)
            //            }
            var activityList:[NSDictionary] = []
            for activityData in filterIsSelected
            {
                let CategoryData:NSDictionary = ["DCR_Id":getDCRId(),"DCR_Customer_Visit_Id":getDoctorVisitId(),"Visit_code":"","Flag":ActivityFlag.Field.rawValue,"Customer_Entity_Type":customerEntityInt.Doctor.rawValue,"Customer_Entity_Type_Description":customerEntityDescribtion.Doctor.rawValue,"Customer_Activity_ID":activityData.activityId,"Activity_Name":activityData.activityName,"Activity_Remarks":activityData.remarks,"Entity_Type":entityType]
                
                activityList.append(CategoryData)
            }
            
            DBHelper.sharedInstance.insertDCRCallActivity(array: activityList as NSArray)
        }
        
        //            _ = self.navigationController?.popViewController(animated: false)
        
        if let navController = self.navigationController
        {
            let vcList = navController.viewControllers
            var index = vcList.count - 3
            
            if(!isFromMCActivity)
            {
                index = vcList.count - 2
            }
            
            navController.popToViewController(vcList[index], animated: true)
        }
    }
    
    func getDCRId() -> Int
    {
        return DCRModel.sharedInstance.dcrId!
    }
    
    func getDoctorVisitId() -> Int
    {
        return DCRModel.sharedInstance.customerVisitId
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
