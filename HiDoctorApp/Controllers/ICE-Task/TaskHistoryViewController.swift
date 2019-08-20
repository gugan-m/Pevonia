//
//  TaskHistoryViewController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 04/06/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class TaskHistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateLbl: UILabel!

    var taskList :[TaskList] = []
    var userCode =  String()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Reviewed Task History"
        getAllHistoryTaskList()
        self.addBackButtonView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAllHistoryTaskList()
    {
        if(checkInternetConnectivity())
        {
            showCustomActivityIndicatorView(loadingText: "Loading Task....")
            WebServiceHelper.sharedInstance.getTaskHistory(userCode:userCode) { (apiObj) in
                if(apiObj.Status == SERVER_SUCCESS_CODE)
                {
                    removeCustomActivityView()
                    if(apiObj.list.count > 0)
                    {
                        self.taskList = []
                        for takObj in apiObj.list
                        {
                            let tasktData = takObj as! NSDictionary
                            let taskListObj = TaskList()
                            taskListObj.After_Due = tasktData.value(forKey: "After_Due") as! Int
                            taskListObj.Assignee_Remarks = checkNullAndNilValueForString(stringData:tasktData.value(forKey: "Assignee_Remarks") as? String)
                            taskListObj.Completed_On = tasktData.value(forKey: "Completed_On") as! String
                            taskListObj.Created_By = tasktData.value(forKey: "Created_By") as! String
                            taskListObj.Created_By_Employee_Name = tasktData.value(forKey: "Created_By_Employee_Name") as! String
                            taskListObj.Created_DateTime = tasktData.value(forKey: "Created_DateTime") as! String
                            taskListObj.Days_Left = tasktData.value(forKey: "Days_Left") as! Int
                            taskListObj.Over_Due = tasktData.value(forKey: "Over_Due") as! Int
                            taskListObj.Task_Closed_Date = tasktData.value(forKey: "Task_Closed_Date") as! String
                            taskListObj.Task_Description = checkNullAndNilValueForString(stringData:tasktData.value(forKey: "Task_Description") as? String)
                            taskListObj.Task_Due_Date = tasktData.value(forKey: "Task_Due_Date") as! String
                            taskListObj.Task_Id = tasktData.value(forKey: "Task_Id") as! Int
                            taskListObj.Task_Name = tasktData.value(forKey: "Task_Name") as! String
                            taskListObj.Task_Status = tasktData.value(forKey: "Task_Status") as! Int
                            taskListObj.Task_User_Employee_Name = tasktData.value(forKey: "Task_User_Employee_Name") as! String
                            taskListObj.Updated_DateTime = tasktData.value(forKey: "Updated_DateTime") as! String
                            taskListObj.User_Code = checkNullAndNilValueForString(stringData:tasktData.value(forKey: "User_Code") as? String)
                            taskListObj.User_Name = tasktData.value(forKey: "User_Name") as! String
                            taskListObj.With_In = tasktData.value(forKey: "With_In") as! Int
                            
                            self.taskList.append(taskListObj)
                            self.tableView.isHidden = false
                            self.tableView.reloadData()
                            self.emptyStateLbl.text = ""
                            
                        }
                    }
                    else
                    {
                        self.tableView.isHidden = true
                        self.emptyStateLbl.text = "No Task History"
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
            AlertView.showAlertView(title: internetOfflineMessage, message: internetOfflineMessage, viewController: self)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "AllTaskListCell") as! TaskListCell
        let getTaskData = self.taskList[indexPath.row]
        cell.taskName.text = getTaskData.Task_Name
        cell.createdBy.text = "Created By: " + getTaskData.Created_By_Employee_Name
        let dateCreated = convertDateIntoString(dateString: getTaskData.Created_DateTime)
        let appFormatCreateDate = convertDateIntoString(date: dateCreated)
        let dueDate = convertDateIntoString(dateString: getTaskData.Task_Due_Date)
        let appFormatDueDate = convertDateIntoString(date: dueDate)
        if(getTaskData.Completed_On == "")
        {
           cell.completedOn.text = ""
        }
        else
        {
        let completedDateDate = convertDateIntoString(dateString: getTaskData.Completed_On)
        let appFormatcompletedDate = convertDateIntoString(date: completedDateDate)
            cell.completedOn.text = "Completed on:" + appFormatcompletedDate
        }
            
        if(getTaskData.Task_Closed_Date == "")
        {
           cell.reviewedOn.text = ""
            
        }
        else
        {
        let reviewedDate = convertDateIntoString(dateString: getTaskData.Task_Closed_Date)
        let appFormatreviewedDate = convertDateIntoString(date: reviewedDate)
            cell.reviewedOn.text = "Reviewed on:" + appFormatreviewedDate
        }
        cell.createdOn.text = "Created On: " + appFormatCreateDate
        cell.dueDate.text = "DueDate: " + appFormatDueDate
//        let status = self.taskList[indexPath.row].Task_Status
//        if(status == 2)
//        {
//            cell.status.text = "In Progress"
//        }
//        else if(status == 1)
//        {
//            cell.status.text = "Open"
//        }
//        else if(status == 3)
//        {
//            cell.status.text = "Completed"
//        }
//        else if(status == 0)
//        {
//            cell.status.text = "Reviewed"
//        }
//        else if(status == 5)
//        {
//            cell.status.text = "ReOpen"
//        }
//        else
//        {
//            cell.status.text = "Open"
//        }
        
        cell.status.text = ""
        
        return cell
    }

}
