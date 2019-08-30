//
//  NotesListViewController.swift
//  HiDoctorApp
//
//  Created by SwaaS on 19/07/19.
//  Copyright © 2019 swaas. All rights reserved.
//

import UIKit

class NotesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource
{
    
    
    var date: String = ""
    
    @IBOutlet weak var segmentedcontrol: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var emptytext: UILabel!
    @IBOutlet weak var cellview: UITableViewCell!
    var list: NSDictionary = [:]
    var isnotes: Bool = true
    var istask: Bool = false
    var toTimePicker = UIDatePicker()
    var pickerView = UIPickerView()
    var sectioncounttask: Int = 0
    var sectioncountnote: Int = 0
    var tasklist: NSArray = []
    var noteslist: NSArray = []
    var index: Int = 0
    var selectedRow: Int = 0
    var statusArray:NSArray = ["In Progress","Closed"]
    let toolBar = UIToolbar()
    var selecteddate: String = ""
    var selectedseg: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.autoresizingMask = UIViewAutoresizing.flexibleHeight;
        noteslistapi(selecteddate: self.date)
        Taskslistapi(selecteddate: self.date)
        self.addTimePicker()
        //duedatelabel.isEnabled = false
        pickerView = UIPickerView()
        pickerView.backgroundColor = UIColor.lightGray
        pickerView.delegate = self
        
        pickerdone()
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statusArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statusArray[row] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedRow = row
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return SCREEN_WIDTH
    }
    func pickerdone()
    {
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(NotesListViewController.doneBtnClicked))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
    }
    
    @objc func  cancelClick()
    {
        self.tableView.reloadData()
    }
    private func addTimePicker()
    {
        let timePicker = UIDatePicker()
        let locale = NSLocale(localeIdentifier: "en_US")
        timePicker.locale = locale as Locale
        timePicker.datePickerMode = UIDatePickerMode.date
        timePicker.date = getDateFromString(dateString: getCurrentDate())
        timePicker.frame.size.height = timePickerHeight
        timePicker.backgroundColor = UIColor.lightGray
        
        toTimePicker = timePicker
        
        let doneToolbar = getToolBar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(NotesTaskViewController.doneBtnClicked))
        let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(NotesTaskViewController.cancelBtnClicked))
        doneToolbar.items = [flexSpace, done, cancel]
        doneToolbar.sizeToFit()
        
        //duedatelabel.inputAccessoryView = doneToolbar
        //duedatelabel.inputView = toTimePicker
        timePicker.addTarget(self, action: #selector(NotesTaskViewController.setTimeDetails), for: UIControlEvents.valueChanged)
    }
    @objc func doneBtnClicked()
    {
        //self.setTimeDetails(sender: toTimePicker)
        //self.resignResponderForTxtField()
        var value = 2
        if(self.selectedRow == 0)
        {
            value = 2
        }
        else if (self.selectedRow == 1)
        {
            value = 3
        }
        //let value = self.selectedRow + 2
        let model = tasklist[self.index] as! NSDictionary
        let noteid = model.value(forKey:"Task_HeaderId") as! Int
        let dict: NSDictionary = [:]
        if(checkInternetConnectivity())
        {
            showCustomActivityIndicatorView(loadingText: "changing status")
            WebServiceHelper.sharedInstance.updatestatustask(postData:dict as! [String : Any],id: noteid, taskid: value, date: self.selecteddate) { (apiObj) in
                if(apiObj.Status == SERVER_SUCCESS_CODE)
                {
                    removeCustomActivityView()
                    self.Taskslistapi(selecteddate: self.date)
                    self.tableView.reloadData()
                }
            }
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
        
    }
    @objc func setTimeDetails(sender : UIDatePicker)
    {
        let datePic = sender.date
        var datetext = stringDateFormat(date1: datePic)
        //self.duedatelabel.text = stringDateFormat(date1: datePic)
    }
    func stringDateFormat(date1: Date) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = defaultDateFomat
        formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        formatter.timeZone = NSTimeZone.local
        return formatter.string(from: date1)
    }
    override func viewWillAppear(_ animated: Bool) {
        noteslistapi(selecteddate: self.date)
        Taskslistapi(selecteddate: self.date)
        self.emptytext.isHidden = true
        if(self.selectedseg == 1)
        {
            self.emptytext.isHidden = true
            if(self.tasklist.count < 1)
            {
                self.emptytext.text = "No Task Available"
                self.emptytext.isHidden = false
            }
        }
        else
        {
            self.emptytext.isHidden = true
            if(self.noteslist.count < 1)
            {
                self.emptytext.text = "No Notes Available"
                self.emptytext.isHidden = false
            }
        }
        self.tableView.reloadData()
    }
    func noteslistapi(selecteddate: String)
    {
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: "Loading...")
            WebServiceHelper.sharedInstance.getcalendarnoteslist( completion: { (apiObj) in
                if apiObj.Status == SERVER_SUCCESS_CODE
                {
                    let list = apiObj.list
                    if(list!.count > 0)
                    {
                        self.sectioncountnote = apiObj.list.count
                        self.noteslist = list!
                        self.tableView.reloadData()
                        self.emptytext.isHidden = true
                    }
                    else
                    {
                        self.noteslist = []
                        
                        // self.emptytext.text = "No Notes Available"
                        //self.emptytext.isHidden = false
                        self.sectioncountnote = 0
                        self.tableView.reloadData()
                    }
                    
                }
            }, date: selecteddate)
            removeCustomActivityView()
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    func Taskslistapi(selecteddate: String)
    {
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: "Loading...")
            WebServiceHelper.sharedInstance.getcalendartaskslist( completion: { (apiObj) in
                if apiObj.Status == SERVER_SUCCESS_CODE
                {
                    let list = apiObj.list
                    if(list!.count > 0)
                    {
                        self.sectioncounttask = apiObj.list.count
                        self.tasklist = list!
                        self.tableView.reloadData()
                        //self.emptytext.isHidden = true
                    }
                    else
                    {
                        self.tasklist = []
                        
                        //self.emptytext.text = "No Tasks Available"
                        //self.emptytext.isHidden = false
                        self.sectioncounttask = 0
                        self.tableView.reloadData()
                    }
                    
                    
                    removeCustomActivityView()
                }
            }, date: selecteddate)
            removeCustomActivityView()
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isnotes)
        {
            return self.sectioncountnote
        }
        else
        {
            return self.sectioncounttask
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    @IBAction func segemnt(_ sender: UISegmentedControl) {
        
        if(sender.selectedSegmentIndex == 1)
        {
            self.emptytext.isHidden = true
            Taskslistapi(selecteddate: self.date)
            self.tableView.reloadData()
            self.istask = true
            self.isnotes = false
            if(self.tasklist.count < 1)
            {
                self.emptytext.text = "No Tasks Available"
                self.emptytext.isHidden = false
            }
            self.selectedseg = 1
            self.tableView.reloadData()
        }
        else
        {
            self.emptytext.isHidden = true
            noteslistapi(selecteddate: self.date)
            self.tableView.reloadData()
            self.isnotes = true
            self.istask = false
            if(self.noteslist.count < 1)
            {
                self.emptytext.text = "No Notes Available"
                self.emptytext.isHidden = false
            }
            self.selectedseg = 0
            self.tableView.reloadData()
        }
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotesCellVcID, for: indexPath) as! NotesViewCell
        
        if(istask)
        {
            if (tasklist.count > 0)
            {
                let model = self.tasklist[indexPath.row] as! NSDictionary
                
                cell.Title.text = "\(model.value(forKey: "Title") as! String)"
                cell.dateview.isHidden = false
                cell.statusview.isHidden = false
                cell.duedatellbl.isHidden = false
                cell.statuslbl.isHidden = false
                let task = model.value(forKey: "lstTasks") as! NSArray
                let temp = task[0] as! NSDictionary
                //cell.Date.text = "Created Date: " + "\(temp.value(forKey: "Created_DateTime") as! String)"
                
                cell.Description.text = "\(temp.value(forKey: "Tasks_Description") as! String)"
                cell.date.text = model.value(forKey: "Task_Due_Date") as! String
                if(model.value(forKey: "Task_Status")  != nil)
                {
                    cell.status.setTitle(model.value(forKey: "Task_Status") as! String, for: .normal)
                }
                else{
                    cell.status.setTitle("open", for: .normal)
                }
                // cell.status.set = pickerView
                cell.date.inputView = toTimePicker
                //cell.status.i = toolBar
                cell.date.isEnabled = false
                cell.closebtn.isHidden = true
                cell.statusinput.inputView = pickerView
                cell.statusinput.inputAccessoryView = toolBar
                cell.statusinput.tintColor = .clear
                //            let but = cell.viewWithTag(1) as! UIButton
                //            //but.setTitle("MODIFY", for: .normal)
                //            but.addTarget(self, action: #selector(delete(sender:)), for: .touchUpInside)
                //            self.index = indexPath.row
                let but = cell.viewWithTag(2) as! UIButton
                //but.setTitle("MODIFY", for: .normal)
                but.addTarget(self, action: #selector(updatestatus(sender:)), for: .touchUpInside)
            }
        }
        else
        {
            if (noteslist.count > 0)
            {
                let model = self.noteslist[indexPath.row] as! NSDictionary
                cell.closebtn.isHidden = false
                cell.Title.text = "\(model.value(forKey: "Title") as! String)"
                let task = model.value(forKey: "lstNotes") as! NSArray
                let temp = task[0] as! NSDictionary
                //cell.Date.text = "Created Date: " + "\(temp.value(forKey: "Created_DateTime") as! String)"
                
                cell.Description.text = "\(temp.value(forKey: "Notes_Description") as! String)"
                //            cell.date.text = model.value(forKey: "Note_Actual_Date") as! String
                //            cell.status.text = model.value(forKey: "Task_Status") as! String
                cell.dateview.isHidden = true
                cell.statusview.isHidden = true
                cell.duedatellbl.isHidden = true
                cell.statuslbl.isHidden = true
                let but = cell.viewWithTag(1) as! UIButton
                //but.setTitle("MODIFY", for: .normal)
                but.addTarget(self, action: #selector(delete(sender:)), for: .touchUpInside)
                //self.index = indexPath.row
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //self.index = selectedRow
        if(isnotes)
        {
            list = noteslist[indexPath.row] as! NSDictionary
        }
        else
        {
            list = tasklist[indexPath.row] as! NSDictionary
        }
        navigate()
    }
    func navigate()
    {
        let sb = UIStoryboard(name: "calendar", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "NotesVcid") as! NotesTaskViewController
        vc.isfromnotes = false
        vc.iseditnotes = isnotes
        vc.isedittask = istask
        vc.editlist = list
        vc.dateselected = self.selecteddate
        self.navigationController?.pushViewController(vc, animated: false)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(isnotes)
        {
            return 60
        }
        else
        {
            return 100
        }
    }
    @objc func updatestatus(sender:UIButton)
    {
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        let indexPath = tableView.indexPathForRow(at: buttonPosition)
        self.index = indexPath!.row
    }
    @objc func delete(sender:UIButton)
    {
        let initialAlert = "Are you sure to Delete"
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        let indexPath = tableView.indexPathForRow(at: buttonPosition)
        let alertViewController = UIAlertController(title: alertTitle, message: initialAlert, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { alertAction in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
            self.deletenote(index: indexPath!.row)
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    func deletenote(index: Int)
    {
        if(checkInternetConnectivity())
        {
            let model = noteslist[index] as! NSDictionary
            let noteid = model.value(forKey:"Note_HeaderId") as! Int
            let dict: NSDictionary = [:]
            WebServiceHelper.sharedInstance.deletenotes(postData:dict as! [String : Any],id: noteid, date: self.selecteddate) { (apiObj) in
                if(apiObj.Status == SERVER_SUCCESS_CODE)
                {
                    //showToastViewWithShortTime(toastText: "Note deleted successfully")
                    self.noteslistapi(selecteddate: self.date)
                    self.tableView.reloadData()
                }
            }
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
        
    }
}

