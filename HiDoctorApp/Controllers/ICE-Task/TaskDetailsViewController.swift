//
//  TaskDetailsViewController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 03/06/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class TaskDetailsViewController: UIViewController {

    @IBOutlet weak var taskId: UILabel!
    @IBOutlet weak var taskIdSta: UILabel!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskNameSta: UILabel!
    @IBOutlet weak var taskDescription: UILabel!
    @IBOutlet weak var taskDescriptionSta: UILabel!
    @IBOutlet weak var taskAssignedBy: UILabel!
    @IBOutlet weak var general_Remarks: UILabel!
    @IBOutlet weak var taskAssignedBysts: UILabel!
    @IBOutlet weak var taskAssignedOn: UILabel!
    @IBOutlet weak var completedOn: UILabel!
     @IBOutlet weak var taskAssignedOnSta: UILabel!
    @IBOutlet weak var taskStatus: UILabel!
     @IBOutlet weak var bottomVertical: NSLayoutConstraint!
    @IBOutlet weak var inProgress: UIButton!
    @IBOutlet weak var completed: UIButton!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var remarkTextView: UITextView!
    @IBOutlet weak var remarkView: UIView!
    
    var taskDetail :TaskList = TaskList()
    var inProgressStatus : Int!
    var completeStatus : Int!
    var isShow = false
    var isFromFollowup = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = taskDetail.Task_Name
        
        self.taskId.text = "\(self.taskDetail.Task_Id!)"
        self.taskName.text = self.taskDetail.Task_Name
        if(self.taskDetail.Task_Description == "")
        {
            self.taskDescription.text = NOT_APPLICABLE
        }
        else
        {
            self.taskDescription.text = self.taskDetail.Task_Description
           // self.viewHeight.constant += getTextSize(text: self.taskDetail.Task_Description, fontName: fontRegular, fontSize: 15, constrainedWidth: 16).height
        }
        if(isFromFollowup)
        {
            self.taskIdSta.text = "Followup Id:"
            self.taskNameSta.text = "Followup Name:"
            self.taskDescriptionSta.text = "Followup Description:"
            self.taskAssignedBysts.text = "Followup By:"
            self.taskAssignedOnSta.text = "Followup On:"
            self.taskAssignedBy.text = self.taskDetail.Created_By_Employee_Name
        }
        else
        {
            self.taskIdSta.text = "Task Id:"
            self.taskNameSta.text = "Task Name:"
            self.taskDescriptionSta.text = "Task Description:"
            self.taskAssignedBysts.text = "Assigned By"
            self.taskAssignedOn.text = "Assigned On"
            self.taskAssignedBy.text = self.taskDetail.Created_By_Employee_Name
        }
        
        
        
        
        
        //self.taskAssignedBy.text = self.taskDetail.Created_By_Employee_Name
        let createDate = convertDateIntoString(dateString: self.taskDetail.Created_DateTime)
        let appFormatCreateDate = convertDateIntoString(date: createDate)
        self.taskAssignedOn.text = appFormatCreateDate
        
        if(self.taskDetail.Task_Status == 3 || self.taskDetail.Task_Status == 0)
        {
            if(checkNullAndNilValueForString(stringData:self.taskDetail.Updated_DateTime) != EMPTY)
            {
            let completeDate = convertDateIntoString(dateString: self.taskDetail.Updated_DateTime)
            let appFormatCompleteDate = convertDateIntoString(date: completeDate)
            self.completedOn.text? = appFormatCompleteDate
            }
            else
            {
                self.completedOn.text? = NOT_APPLICABLE
            }
        }
        else
        {
           self.completedOn.text? = "Yet to Complete"
        }

        let status = self.taskDetail.Task_Status
        if(status == 2)
        {
            if(isFromFollowup)
            {
                self.taskStatus.text = "In Progress"
                if(isShow)
                {
                    
                    self.bottomVertical.constant = -(self.view.frame.width/2 + 2)
                    inProgressStatus = 2
                    completeStatus = 3
                    self.completed.setTitle("Completed", for: .normal)
                    self.inProgress.isHidden = true
                    self.completed.isHidden =  false
                }
                else
                {
                    self.inProgress.isHidden = true
                    self.completed.isHidden =  true
                }
            }
            else
            {
                self.taskStatus.text = "In Progress"
                if(isManager() && isShow)
                {
                    self.inProgress.isHidden = true
                    self.completed.isHidden =  true
                    
                }
                else
                {
                    self.bottomVertical.constant = -(self.view.frame.width/2 + 2)
                    inProgressStatus = 2
                    completeStatus = 3
                    self.completed.setTitle("Completed", for: .normal)
                    self.inProgress.isHidden = true
                    self.completed.isHidden =  false
                }
            }
        }
        else if(status == 3)
        {
            if(isFromFollowup)
            {
                self.inProgress.isHidden = true
                self.completed.isHidden =  true
                self.taskStatus.text = "Completed"
            }
            else
            {
                self.taskStatus.text = "Completed"
                if(isManager() && isShow)
                {
                    self.inProgress.isHidden = false
                    self.completed.isHidden =  false
                    self.inProgress.setTitle("ReOpen", for: .normal)
                    self.completed.setTitle("Reviewed", for: .normal)
                    completeStatus = 0
                    inProgressStatus = 5
                }
                else
                {
                    self.inProgress.isHidden = true
                    self.completed.isHidden =  true
                    self.inProgress.setTitle("In Progress", for: .normal)
                    self.completed.setTitle("Completed", for: .normal)
                    completeStatus = 3
                }
            }
        }
        else if(status == 0)
        {
            if(isFromFollowup)
            {
                self.inProgress.isHidden = true
                self.completed.isHidden =  true
                self.taskStatus.text = "Reviewed"
            }
            else
            {
                self.taskStatus.text = "Reviewed"
                if(isManager() && isShow)
                {
                    self.inProgress.isHidden = true
                    self.completed.isHidden =  true
                }
                else
                {
                    self.inProgress.isHidden = true
                    self.completed.isHidden =  true
                }
            }
        }
        else if(status == 5)
        {
            self.taskStatus.text = "ReOpen"
            if(isFromFollowup)
            {
                self.inProgress.isHidden = true
                self.completed.isHidden =  true
                self.taskStatus.text = "ReOpen"
            }
            else
            {
                self.taskStatus.text = "ReOpen"
                if(isManager() && isShow)
                {
                    self.inProgress.isHidden = true
                    self.completed.isHidden =  true
                }
                else
                {
                    self.inProgress.isHidden = false
                    self.completed.isHidden =  false
                    inProgressStatus = 2
                    completeStatus = 3
                }
            }
        }
        else
        {
            self.taskStatus.text = "Open"
            if(isFromFollowup)
            {
                if(isShow)
                {
                    
                    self.inProgress.isHidden = false
                    self.completed.isHidden =  false
                    self.taskStatus.text = "Open"
                    inProgressStatus = 2
                    completeStatus = 3
                }
                else
                {
                    self.inProgress.isHidden = true
                    self.completed.isHidden =  true
                }
            }
            else
            {
                self.taskStatus.text = "Open"
                if(isManager() && isShow)
                {
                    self.inProgress.isHidden = true
                    self.completed.isHidden =  true
                }
                else
                {
                    self.inProgress.isHidden = false
                    self.completed.isHidden =  false
                    inProgressStatus = 2
                    completeStatus = 3
                }
            }
        }
        if(self.taskDetail.Assignee_Remarks == nil || self.taskDetail.Assignee_Remarks == EMPTY){
            self.general_Remarks.text = NOT_APPLICABLE
        }
        else {
            self.general_Remarks.text = self.taskDetail.Assignee_Remarks
        }
        
        
        self.remarkTextView.layer.borderColor = UIColor.gray.cgColor
        self.remarkTextView.layer.borderWidth = 0.9
        self.remarkView.isHidden = true
        self.hideKeyboardWhenTappedAround()
        // self.taskStatus.text = self.taskDetail.Task_Status
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func inProgress(_ sender: UIButton)
    {
        self.updateTask(remarks: "", status: inProgressStatus)
        
    }
    
    @IBAction func completed(_ sender: UIButton)
    {
        if(completeStatus == 3)
        {
           self.remarkView.isHidden = false
        }
        else
        {
            self.updateTask(remarks: "", status: completeStatus)
        }
    }
   
    @IBAction func updateCompletStatus(_ sender: UIButton)
    {
        self.remarkView.isHidden = true
        self.updateTask(remarks: remarkTextView.text, status: completeStatus)
    }
    
    @IBAction func closeCompletStatus(_ sender: UIButton)
    {
        self.remarkView.isHidden = true
    }
    
    
    func updateTask(remarks:String,status:Int)
    {
        let postData = ["Task_Id":self.taskDetail.Task_Id,"Task_Status":status,"Remarks":remarks,"updatedBy":getUserName()] as [String : Any]
        if(checkInternetConnectivity())
        {
            showCustomActivityIndicatorView(loadingText: "Loading....")
            WebServiceHelper.sharedInstance.postTaskStatus(postData:postData) { (apiObj) in
                if(apiObj.Status ==  SERVER_SUCCESS_CODE)
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

}
