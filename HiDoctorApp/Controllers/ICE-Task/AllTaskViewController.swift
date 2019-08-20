//
//  AllTaskViewController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 03/06/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class AllTaskViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    @IBOutlet weak var segment: UISegmentedControl!

     var userMode = String()
    let toMe = "Me"
    let byAll = "All"
    var taskList :[TaskList] = []
    var createTask : UIBarButtonItem!
    var taskHistory : UIBarButtonItem!
    var userCode =  String()
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Task List"
        self.addCreateBtn()
        self.tableView.tableFooterView = UIView()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        segment.selectedSegmentIndex = 0
        self.userMode = toMe
        getAllTaskList()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addCreateBtn()
    {
        createTask = UIBarButtonItem(image: UIImage(named: "icon-plus-1"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(showCreateButAction))
        taskHistory = UIBarButtonItem(image: UIImage(named: "visiblity_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(showHistoryButAction))
        
        self.navigationItem.rightBarButtonItems = [createTask,taskHistory]
    }
    
    @objc func showCreateButAction()
    {
        let sb = UIStoryboard(name: commonListSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier:CreateTaskViewControllerID) as! CreateTaskViewController
        vc.userCode = userCode
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showHistoryButAction()
    {
        let sb = UIStoryboard(name: commonListSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier:TaskHistoryViewControllerID) as! TaskHistoryViewController
        vc.userCode = userCode
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func getAllTaskList()
    {
        if(checkInternetConnectivity())
        {
            showCustomActivityIndicatorView(loadingText: "Loading Task....")
            WebServiceHelper.sharedInstance.getAllTaskList(userCode:userCode,mode: self.userMode) { (apiObj) in
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
                        self.emptyStateLbl.text = "No Open & Completed Tasks"
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
        cell.createdOn.text = "Created On: " + appFormatCreateDate
        cell.dueDate.text = "DueDate: " + appFormatDueDate
        cell.dueDate.textColor = UIColor.black
        let status = self.taskList[indexPath.row].Task_Status
        if(status == 2)
        {
            cell.status.text = "In Progress"
            if(getTaskData.Over_Due > 0)
            {
               cell.dueDate.textColor = UIColor.red
            }
        }
        else if(status == 1)
        {
            cell.status.text = "Open"
            if(getTaskData.Over_Due > 0)
            {
                cell.dueDate.textColor = UIColor.red
            }
        }
        else if(status == 3)
        {
            cell.status.text = "Completed"
        }
        else if(status == 0)
        {
            cell.status.text = "Reviewed"
        }
        else if(status == 5)
        {
            cell.status.text = "ReOpen"
            
            if(getTaskData.Over_Due > 0)
            {
                cell.dueDate.textColor = UIColor.red
            }
        }
        
 
        return cell
    }
    
    @IBAction func segmentView(_ sender: UISegmentedControl) {
        
        if(sender.selectedSegmentIndex == 0)
        {
            self.userMode = toMe
            self.getAllTaskList()
        }
        else
        {
            self.userMode = byAll
            self.getAllTaskList()
        }
    }
}
