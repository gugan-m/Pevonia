//
//  TaskListViewController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 02/06/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class TaskListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource {
    
    var userMode = String()
    let toMe = "ToMe"
    let byMe = "ByMe"
    let own = "Me"
    let team = "Team"
    let notask = "No Task Assigned"
    var taskList :[TaskList] = []
    var tempTaskList :[TaskList] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    @IBOutlet weak var segmentHeight: NSLayoutConstraint!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var pickerHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var pickerView : UIPickerView!
    var filterButton : UIBarButtonItem!
    var toMeArray = ["Open","Completed","Reviewed"]
    var byMeArray = ["Completed","Show All"]
    var ownArray = ["Open","Completed"]
    var selectedStatus = Int()
    var isFollowUp = Bool()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        self.addBackButtonView()
        self.pickerView.isHidden = true
        self.pickerHeightConstraints.constant = 0

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.addFilterBtn()
        setDefaults()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addFilterBtn()
    {
        filterButton = UIBarButtonItem(image: UIImage(named: "icon-filter"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(filterAction))
       
        self.navigationItem.rightBarButtonItems = [filterButton]
    }
    
    @objc func filterAction()
    {
        //show pickerView
        self.pickerView.isHidden = false
        self.pickerHeightConstraints.constant = 200
    }
    func setDefaults()
    {
        self.segment.selectedSegmentIndex = 0
        //self.userMode = toMe
        if(isManager())
        {
            self.segment.isHidden = false
            
            if(!isFollowUp)
            {
                self.segment.setTitle("Assigned to me", forSegmentAt: 0)
                self.segment.setTitle("Assigned by me", forSegmentAt: 1)
                self.userMode = toMe
            }
            else
            {
                self.segment.setTitle("My followup", forSegmentAt: 0)
                self.segment.setTitle("Team followup", forSegmentAt: 1)
                self.userMode = own
            }
        }
        else
        {
            self.segment.isHidden = true
            self.segmentHeight.constant = 0
        }
        if(isFollowUp)
        {
        //get followup list
            self.title = "Follow up List"
            self.userMode = own
            getFollowupTask()
        }
        else
        {
            self.title = "Task List"
            self.userMode = toMe
          getTaskList()
        }
        self.tableView.tableFooterView = UIView()
    }
    
    func getFollowupTask()
    {
        if(checkInternetConnectivity())
        {
            showCustomActivityIndicatorView(loadingText: "Loading Task....")
            WebServiceHelper.sharedInstance.getFollowUpTaskList(mode: self.userMode) { (apiObj) in
                if(apiObj.Status == SERVER_SUCCESS_CODE)
                {
                    removeCustomActivityView()
                    if(apiObj.list.count > 0)
                    {
                        var taskListFromApi:[TaskList] = []
                        for takObj in apiObj.list
                        {
                            let tasktData = takObj as! NSDictionary
                            let taskListObj = TaskList()
                            taskListObj.After_Due = tasktData.value(forKey: "After_Due") as! Int
                            taskListObj.Assignee_Remarks = checkNullAndNilValueForString(stringData:tasktData.value(forKey: "Assignee_Remarks") as? String)
                            taskListObj.Completed_On = tasktData.value(forKey: "Completed_On") as! String
                            taskListObj.Created_By = tasktData.value(forKey: "Created_By") as! String
                            taskListObj.Created_By_Employee_Name = checkNullAndNilValueForString(stringData:tasktData.value(forKey: "Created_By_Employee_Name") as? String)
                            taskListObj.Created_DateTime = tasktData.value(forKey: "Created_DateTime") as! String
                            taskListObj.Days_Left = tasktData.value(forKey: "Days_Left") as! Int
                            taskListObj.Over_Due = tasktData.value(forKey: "Over_Due") as! Int
                            taskListObj.Task_Closed_Date = tasktData.value(forKey: "Task_Closed_Date") as! String
                            taskListObj.Task_Description = checkNullAndNilValueForString(stringData:tasktData.value(forKey: "Task_Description") as? String)
                            taskListObj.Task_Due_Date = tasktData.value(forKey: "Task_Due_Date") as! String
                            taskListObj.Task_Id = tasktData.value(forKey: "Task_Id") as! Int
                            taskListObj.Task_Name = tasktData.value(forKey: "Task_Name") as! String
                            taskListObj.Task_Status = tasktData.value(forKey: "Task_Status") as! Int
                            taskListObj.Task_User_Employee_Name = checkNullAndNilValueForString(stringData:tasktData.value(forKey: "Task_User_Employee_Name") as? String)
                            taskListObj.Updated_DateTime = checkNullAndNilValueForString(stringData:tasktData.value(forKey: "Updated_DateTime") as? String)
                            taskListObj.User_Code = checkNullAndNilValueForString(stringData:tasktData.value(forKey: "User_Code") as? String)
                            taskListObj.User_Name = checkNullAndNilValueForString(stringData:tasktData.value(forKey: "User_Name") as? String)
                            taskListObj.With_In = tasktData.value(forKey: "With_In") as! Int
                            
                            taskListFromApi.append(taskListObj)
                        }
                        self.tempTaskList = taskListFromApi
                        let tempedValue = self.tempTaskList
                        if(isManager())
                        {
                            if(self.userMode == self.own)
                            {
                                self.taskList = tempedValue.filter{
                                    $0.Task_Status == 1 || $0.Task_Status == 2
                                }
                            }
                            else
                            {
                                self.taskList = tempedValue
                            }
                        }
                        else
                        {
                            if(self.userMode == self.own)
                            {
                                self.taskList = tempedValue.filter{
                                    $0.Task_Status == 1 || $0.Task_Status == 2
                                }
                            }
                        }
                        if(self.taskList.count > 0)
                        {
                            self.tableView.isHidden = false
                            self.tableView.reloadData()
                            self.emptyStateLbl.text = ""
                        }
                        else
                        {
                            self.tableView.isHidden = true
                            self.emptyStateLbl.text = "No Follow Up"
                        }
                        
                        
                    }
                    else
                    {
                        self.tempTaskList = []
                        self.tableView.isHidden = true
                        self.emptyStateLbl.text = "No Follow Up"
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
    
    func getTaskList()
    {
        if(checkInternetConnectivity())
        {
           showCustomActivityIndicatorView(loadingText: "Loading Task....")
            WebServiceHelper.sharedInstance.getTaskList(mode: self.userMode) { (apiObj) in
                if(apiObj.Status == SERVER_SUCCESS_CODE)
                {
                    removeCustomActivityView()
                    if(apiObj.list.count > 0)
                    {
                        var taskListFromApi:[TaskList] = []
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
                            taskListObj.User_Code = tasktData.value(forKey: "User_Code") as! String
                            taskListObj.User_Name = tasktData.value(forKey: "User_Name") as! String
                            taskListObj.With_In = tasktData.value(forKey: "With_In") as! Int
                            
                            taskListFromApi.append(taskListObj)
                        }
                            self.tempTaskList = taskListFromApi
                        let tempedValue = self.tempTaskList
                        if(isManager())
                        {
                            if(self.userMode == self.toMe)
                            {
                                self.taskList = tempedValue.filter{
                                    $0.Task_Status == 1 || $0.Task_Status == 2 || $0.Task_Status == 5
                                }
                            }
                            else
                            {
                                self.taskList = tempedValue.filter{
                                    $0.Task_Status == 3                                }
                            }
                        }
                        else
                        {
                            if(self.userMode == self.toMe)
                            {
                                self.taskList = tempedValue.filter{
                                    $0.Task_Status == 1 || $0.Task_Status == 2 || $0.Task_Status == 5
                                }
                            }
                        }
                        if(self.taskList.count > 0)
                        {
                            self.tableView.isHidden = false
                            self.tableView.reloadData()
                            self.emptyStateLbl.text = ""
                        }
                        else
                        {
                            self.tableView.isHidden = true
                            self.emptyStateLbl.text = "No Task Assigned"
                        }
                            
                    
                    }
                    else
                    {
                        self.tempTaskList = []
                        self.tableView.isHidden = true
                        self.emptyStateLbl.text = "No Task Assigned"
                    }
                }
                else
                {
                    self.tempTaskList = []
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
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TaskListCell") as! TaskListCell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name:commonListSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: TaskDetailsViewControllerID) as! TaskDetailsViewController
        vc.taskDetail = self.taskList[indexPath.row]
        if(self.userMode == toMe || self.userMode == own)
        {
            vc.isShow = false
            if(self.userMode == own)
            {
                vc.isShow = true
              vc.isFromFollowup = true
            }
            else
            {
            vc.isFromFollowup = false
            }
        }
        else if(self.userMode == team)
        {
            vc.isFromFollowup = true
            vc.isShow = false
        }
        else
        {
           vc.isShow = true
            vc.isFromFollowup = false
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func segmentView(_ sender: UISegmentedControl) {
      self.pickerView.isHidden = true
        
        self.navigationItem.rightBarButtonItems = [filterButton]
        if(sender.selectedSegmentIndex == 0)
        {
            if(isFollowUp)
            {
                self.userMode = own
                self.getFollowupTask()
            }
            else
            {
                self.userMode = toMe
                self.getTaskList()
            }
        }
        else
        {
            if(isFollowUp)
            {
                self.navigationItem.rightBarButtonItems = []
                self.userMode = team
                self.getFollowupTask()
            }
            else
            {
                self.navigationItem.rightBarButtonItems = [filterButton]
                self.userMode = byMe
                self.getTaskList()
            }
        }
        self.pickerView.reloadAllComponents()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(self.userMode == toMe)
        {
            return toMeArray.count
        }
        else if(self.userMode == own)
        {
            return ownArray.count
        }
        else
        {
            return byMeArray.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(self.userMode == toMe)
        {
            return toMeArray[row]
        }
        else if(self.userMode == own)
        {
            return ownArray[row]
        }
        else
        {
            return byMeArray[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(self.userMode == toMe)
        {
            if(row == 0)
            {
                let filteredValue = self.tempTaskList.filter{
                    $0.Task_Status == 1 || $0.Task_Status == 2 || $0.Task_Status == 5
                }
                
                self.handleList(list: filteredValue, emptyState: notask)
            }
            else if(row == 1)
            {
                let filteredValue = self.tempTaskList.filter{
                    $0.Task_Status == 3
                }
                self.handleList(list: filteredValue, emptyState: notask)
            }
            else
            {
                let filteredValue = self.tempTaskList.filter{
                    $0.Task_Status == 0
                }
                self.handleList(list: filteredValue, emptyState: notask)
            }
        }
        else if(self.userMode == own)
        {
            if(row == 0)
            {
                let filteredValue = self.tempTaskList.filter{
                    $0.Task_Status == 1 || $0.Task_Status == 2
                }
                self.handleList(list: filteredValue, emptyState: "No Follow up")
            }
            else if(row == 1)
            {
                let filteredValue = self.tempTaskList.filter{
                    $0.Task_Status == 3
                }
                self.handleList(list: filteredValue, emptyState: "No Follow up")
            }
        }
        else
        {
            if(row == 0)
            {
                let filteredValue = self.tempTaskList.filter{
                    $0.Task_Status == 3
                }
                self.handleList(list: filteredValue, emptyState: notask)
            }
            else
            {
                let filteredValue = self.tempTaskList.filter{
                    $0.Task_Status == 1 || $0.Task_Status == 2 || $0.Task_Status == 5 || $0.Task_Status == 0
                }
                self.handleList(list: filteredValue, emptyState: notask)
            }
        }
       
    }
    
    func handleList(list:[TaskList],emptyState:String)
    {
        if(list.count > 0)
        {
            self.tableView.isHidden = false
            self.emptyStateLbl.text = ""
            self.taskList = list
        }
        else
        {
            self.tableView.isHidden = true
            self.emptyStateLbl.text = emptyState
        }
        
        self.tableView.reloadData()
        self.pickerView.isHidden = true
        self.pickerHeightConstraints.constant = 0
        
    }
    @IBAction func taskList(_ sender: UIButton)
    {
        self.navigationItem.rightBarButtonItems = [filterButton]
        self.title = "Task List"
        self.pickerView.isHidden = true
        self.taskList = []
        isFollowUp = false
        self.setDefaults()
        
    }
    @IBAction func followupList(_ sender: UIButton)
    {
        self.navigationItem.rightBarButtonItems = [filterButton]
        self.title = "Follow Up List"
        self.pickerView.isHidden = true
        self.taskList = []
        isFollowUp = true
        self.setDefaults()
    }
    
}
