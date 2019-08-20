//
//  NotesTaskViewController.swift
//  HiDoctorApp
//
//  Created by User on 16/07/19.
//  Copyright © 2019 swaas. All rights reserved.
//

import UIKit

class NotesTaskViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, DocumentDelegate, ChildViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    
    @IBAction func removedoctors() {
        self.DoctorList.removeAll()
        self.tableView.reloadData()
        self.removeallbtn.isHidden = true
    }
    @IBOutlet weak var removeallbtn: UIButton!
    @IBOutlet weak var nodoctors: UILabel!
    @IBOutlet weak var noattachments: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var savebtn: UIButton!
    @IBOutlet weak var collectionviewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var adddoc: UIButton!
    @IBOutlet weak var addattach: UIButton!
    let queue = OperationQueue()
    @IBOutlet weak var content: UIView!
    let imageArray: [String] = [jpg, jpeg, png, bmp, gif, tif, tiff]
    let excelArray: [String] = [xls, xlsx]
    let wordArray: [String] = [doc, docx]
    @IBOutlet weak var titletext: UITextField!
    @IBOutlet weak var contenttext: UITextView!
    @IBOutlet weak var duedatelabel: UITextField!
    @IBOutlet weak var statuslabel: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var duedate: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var duedateview: CornerRadiusWithShadowView!
    @IBOutlet weak var statusview: CornerRadiusWithShadowView!
    
    @IBOutlet weak var tableviewhgt: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    var DoctorList : [CustomerMasterModel] = []
    var toTimePicker = UIDatePicker()
    var pickerView = UIPickerView()
    var endDate : Date = Date()
    var selectedRow: Int = 0
    var statusArray:NSArray = ["","In Progress","Closed"]
    var isfromnotes : Bool = false
    var attachmentFiles :[String] = []
    let iCloudObserver = "iCloudObserver"
    var attachementBlodUrl :[Bloburl] = []
    var attachementList :[Bloburl] = []
    var editlist: NSDictionary = [:]
    var iseditnotes: Bool = false
    var isedittask: Bool = false
    var isfromtask: Bool = false
    var editbtn : UIBarButtonItem!
    var dateselected: String = ""
    var due: Date = Date()
    let toolBar = UIToolbar()
    
    @IBAction func addattachment() {
        Attachment.sharedInstance.isFromtask = true
        Attachment.sharedInstance.showAttachmentActionSheet(viewController: self)
        Attachment.sharedInstance.delegate = self
        
    }
    @IBAction func adddoctor() {
        let sb = UIStoryboard(name: TPStepperSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: TPDoctorMasterVCID) as! TPDoctorMasterViewController
        vc.regionCode = getRegionCode()
        vc.isfromnotes = true
        vc.delegate = self
        var temp: [String] = []
        if(DoctorList.count > 0)
        {
            for i in DoctorList
            {
                temp.append(i.Customer_Code)
            }
        }
        vc.list = temp
        //self.isfromnotes = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func childViewControllerResponse(parameter: [CustomerMasterModel])
    {
        self.DoctorList = parameter
    }
    @IBAction func save() {
        
        if(titletext.text!.count > 0 && contenttext.text!.count > 0)
        {
            if(checkInternetConnectivity())
            {
                self.savebtn.isEnabled = false
                if (isfromnotes && !iseditnotes && !isedittask && !isfromtask)
                {
                    var leaveData : NSMutableArray = []
                    var attachment : NSMutableArray = []
                    var doctortag : NSMutableArray = []
                    var insertData : [String : Any] = [:]
                    var insertTag : [String : Any] = [:]
                    var insertAttach : [String : Any] = [:]
                    if(DoctorList.count > 0)
                    {
                        for doctor in DoctorList
                        {
                            insertTag = [
                                "Company_Code": getCompanyCode(),
                                "Company_Id": getCompanyId(),
                                "Note_HeaderId": 0,
                                "Task_HeaderId": 0,
                                "Customer_Code": doctor.Customer_Code,
                                "Doctor_Name": doctor.Customer_Name,
                                "Region_Code": getRegionCode(),
                                "Master_CCM_Id": 0,
                                "Account_Number": "",
                                "Created_By": getUserCode(),
                                "Created_DateTime": dateselected]
                            doctortag.add(insertTag)
                        }
                    }
                    if (attachementList.count > 0 )
                    {
                        for i in attachementList
                        {
                            insertAttach = ["Company_Code": getCompanyCode(),
                                            "Company_Id": getCompanyId(),
                                            "Attachment_URL": i.bloburl,
                                            "Task_HeaderId": 0,
                                            "Note_HeaderId": 0,
                                            "File_Name": i.filename,
                                            "Created_By": getUserCode(),
                                            "Created_DateTime": dateselected,
                                            "InputStream": ""]
                            attachment.add(insertAttach)
                        }
                    }
                    insertData = ["Company_Code": getCompanyCode(), "Company_Id": getCompanyId() as Int, "Notes_Description": self.contenttext.text, "Note_HeaderId": 0, "Created_By": getUserCode(), "Created_DateTime": getCurrentDateAndTimeString()]
                    leaveData.add(insertData)
                    
                    let postData: [String : Any] = ["Company_Code": getCompanyCode(), "Company_Id": getCompanyId() as Int, "Title": self.titletext.text!, "Notes_or_Task_Of": EMPTY, "Region_Code": getRegionCode(), "Region_Name": getRegionName(), "User_Code": getUserCode(), "IsNotePinned": 0, "IsNotePublic": 0, "Created_By": getUserCode(), "Created_DateTime": getCurrentDateAndTimeString() ,"lstNotes": leaveData, "lstNotesTags":doctortag, "lstAttachments":attachment, "Note_Actual_Date": dateselected]
                    
                    let data: [String : Any] = ["_objNotes": postData]
                    let arrayData: NSArray = [data]
                    savenotesmethod(postData: postData, selecteddate: dateselected)
                }
                else if (iseditnotes)
                {
                    let model = editlist
                    let noteid = model.value(forKey:"Note_HeaderId") as! Int
                    let retaineddate = model.value(forKey: "Note_Actual_Date") as! String
                    var leaveData : NSMutableArray = []
                    var attachment : NSMutableArray = []
                    var doctortag : NSMutableArray = []
                    var insertData : [String : Any] = [:]
                    var insertTag : [String : Any] = [:]
                    var insertAttach : [String : Any] = [:]
                    if(DoctorList.count > 0)
                    {
                        for doctor in DoctorList
                        {
                            insertTag = [
                                "Company_Code": getCompanyCode(),
                                "Company_Id": getCompanyId(),
                                "Note_HeaderId": noteid,
                                "Task_HeaderId": 0,
                                "Customer_Code": doctor.Customer_Code,
                                "Doctor_Name": doctor.Customer_Name,
                                "Region_Code": getRegionCode(),
                                "Master_CCM_Id": 0,
                                "Account_Number": "",
                                "Created_By": getUserCode(),
                                "Created_DateTime": dateselected
                            ]
                            doctortag.add(insertTag)
                        }
                    }
                    if (attachementList.count > 0 )
                    {
                        for i in attachementList
                        {
                            insertAttach = ["Company_Code": getCompanyCode(),
                                            "Company_Id": getCompanyId(),
                                            "Attachment_URL": i.bloburl,
                                            "Task_HeaderId": 0,
                                            "Note_HeaderId": noteid,
                                            "File_Name": i.filename,
                                            "Created_By": getUserCode(),
                                            "Created_DateTime": dateselected,
                                            "InputStream": ""]
                            attachment.add(insertAttach)
                        }
                    }
                    insertData = ["Company_Code": getCompanyCode(), "Company_Id": getCompanyId() as Int, "Notes_Description": self.contenttext.text, "Note_HeaderId": noteid, "Created_By": getUserCode(), "Created_DateTime": dateselected]
                    leaveData.add(insertData)
                    
                    let postData: [String : Any] = ["Company_Code": getCompanyCode(), "Company_Id": getCompanyId() as Int, "Title": self.titletext.text!, "Notes_or_Task_Of": EMPTY, "Region_Code": getRegionCode(), "Region_Name": getRegionName(), "User_Code": getUserCode(), "IsNotePinned": 0, "IsNotePublic": 0, "Created_By": getUserCode(), "Created_DateTime": dateselected ,"lstNotes": leaveData, "lstNotesTags":doctortag, "lstAttachments":attachment, "Note_Actual_Date": dateselected,"Note_HeaderId": noteid]
                    
                    let data: [String : Any] = ["_objNotes": postData]
                    let arrayData: NSArray = [data]
                    editnotesmethod(postData: postData, selecteddate: dateselected, id: noteid)
                }
                else if (isedittask)
                {
                    let model = editlist
                    let noteid = model.value(forKey:"Task_HeaderId") as! Int
                    let retaineddate = model.value(forKey:"Task_Actual_Date") as! String
                    var leaveData : NSMutableArray = []
                    var attachment : NSMutableArray = []
                    var doctortag : NSMutableArray = []
                    var insertData : [String : Any] = [:]
                    var insertTag : [String : Any] = [:]
                    var insertAttach : [String : Any] = [:]
                    if(DoctorList.count > 0)
                    {
                        for doctor in DoctorList
                        {
                            insertTag = [
                                "Company_Code": getCompanyCode(),
                                "Company_Id": getCompanyId(),
                                "Note_HeaderId": 0,
                                "Task_HeaderId": noteid,
                                "Customer_Code": doctor.Customer_Code,
                                "Doctor_Name": doctor.Customer_Name,
                                "Region_Code": getRegionCode(),
                                "Master_CCM_Id": 0,
                                "Account_Number": "",
                                "Created_By": getUserCode(),
                                "Created_DateTime": dateselected
                                
                            ]
                            doctortag.add(insertTag)
                        }
                    }
                    if (attachementList.count > 0 )
                    {
                        for i in attachementList
                        {
                            insertAttach = ["Company_Code": getCompanyCode(),
                                            "Company_Id": getCompanyId(),
                                            "Attachment_URL": i.bloburl,
                                            "Task_HeaderId": noteid,
                                            "Note_HeaderId": 0,
                                            "File_Name": i.filename,
                                            "Created_By": getUserCode(),
                                            "Created_DateTime": dateselected,
                                            "InputStream": ""]
                            attachment.add(insertAttach)
                        }
                    }
                    insertData = ["Company_Code": getCompanyCode(), "Company_Id": getCompanyId() as Int, "Tasks_Description": self.contenttext.text, "Task_HeaderId": noteid, "Created_By": getUserCode(), "Created_DateTime": dateselected]
                    leaveData.add(insertData)
                    let temp: String = self.duedatelabel.text!
                    let year: String = String(temp.suffix(4))
                    let tempmonth: String = String(temp.prefix(5))
                    let month: String = String(tempmonth.suffix(2))
                    let day: String = String(tempmonth.prefix(2))
                    
                    let taskdate = year + "-" + month + "-" + day
                    //self.due = getDateFromString(dateString: taskdate)
                    let postData: [String : Any] = ["Company_Code": getCompanyCode(), "Company_Id": getCompanyId() as Int, "Title": self.titletext.text!, "Notes_or_Task_Of": EMPTY, "Region_Code": getRegionCode(), "Region_Name": getRegionName(), "User_Code": getUserCode(), "IsNotePinned": 0, "IsNotePublic": 0, "Created_By": getUserCode(), "Created_DateTime": dateselected ,"lstTasks": leaveData, "lstTaskTags":doctortag, "lstAttachments":attachment,"Task_Actual_Date":dateselected,"Task_Due_Date":taskdate, "Task_HeaderId":noteid]
                    
                    let data: [String : Any] = ["_objTask": postData]
                    let arrayData: NSArray = [data]
                    
                    var taskstatus : Int = 0
                    if(statuslabel.text!.contains("In Progress"))
                    {
                        taskstatus = 2
                        let value = taskstatus
                        let noteid = noteid
                        let dict: NSDictionary = [:]
                        WebServiceHelper.sharedInstance.updatestatustask(postData:dict as! [String : Any],id: noteid, taskid: value, date: dateselected) { (apiObj) in
                            if(apiObj.Status == SERVER_SUCCESS_CODE)
                            {
                                //self.Taskslistapi(selecteddate: self.date)
                                //self.tableView.reloadData()
                            }
                        }
                    }
                    else if (statuslabel.text!.contains("Closed"))
                    {
                        taskstatus = 3
                        let value = taskstatus
                        let noteid = noteid
                        let dict: NSDictionary = [:]
                        WebServiceHelper.sharedInstance.updatestatustask(postData:dict as! [String : Any],id: noteid, taskid: value, date: dateselected) { (apiObj) in
                            if(apiObj.Status == SERVER_SUCCESS_CODE)
                            {
                                //self.Taskslistapi(selecteddate: self.date)
                                //self.tableView.reloadData()
                            }
                        }
                    }
                    edittaskmethod(postData: postData, selecteddate: dateselected, id: noteid)
                }
                else if (isfromtask)
                {
                    var leaveData : NSMutableArray = []
                    var attachment : NSMutableArray = []
                    var doctortag : NSMutableArray = []
                    var insertData : [String : Any] = [:]
                    var insertTag : [String : Any] = [:]
                    var insertAttach : [String : Any] = [:]
                    if(DoctorList.count > 0)
                    {
                        for doctor in DoctorList
                        {
                            insertTag = [
                                "Company_Code": getCompanyCode(),
                                "Company_Id": getCompanyId(),
                                "Note_HeaderId": 0,
                                "Task_HeaderId": 0,
                                "Customer_Code": doctor.Customer_Code,
                                "Doctor_Name": doctor.Customer_Name,
                                "Region_Code": getRegionCode(),
                                "Master_CCM_Id": 0,
                                "Account_Number": "",
                                "Created_By": getUserCode(),
                                "Created_DateTime": getCurrentDate()
                                
                            ]
                            doctortag.add(insertTag)
                        }
                    }
                    if (attachementList.count > 0 )
                    {
                        for i in attachementList
                        {
                            insertAttach = ["Company_Code": getCompanyCode(),
                                            "Company_Id": getCompanyId(),
                                            "Attachment_URL": i.bloburl,
                                            "Task_HeaderId": 0,
                                            "Note_HeaderId": 0,
                                            "File_Name": i.filename,
                                            "Created_By": getUserCode(),
                                            "Created_DateTime": getCurrentDate(),
                                            "InputStream": ""]
                            attachment.add(insertAttach)
                        }
                    }
                    insertData = ["Company_Code": getCompanyCode(), "Company_Id": getCompanyId() as Int, "Tasks_Description": self.contenttext.text, "Task_HeaderId": 0, "Created_By": getUserCode(), "Created_DateTime": getCurrentDate()]
                    leaveData.add(insertData)
                    let temp: String = self.duedatelabel.text!
                    let year: String = String(temp.suffix(4))
                    let tempmonth: String = String(temp.prefix(5))
                    let month: String = String(tempmonth.suffix(2))
                    let day: String = String(tempmonth.prefix(2))
                    var taskdate = year + "-" + month + "-" + day
                    if(year.contains("-"))
                    {
                        taskdate = getCurrentDate()
                    }
                    let postData: [String : Any] = ["Company_Code": getCompanyCode(), "Company_Id": getCompanyId() as Int, "Title": self.titletext.text!, "Notes_or_Task_Of": EMPTY, "Region_Code": getRegionCode(), "Region_Name": getRegionName(), "User_Code": getUserCode(), "IsNotePinned": 0, "IsNotePublic": 0, "Created_By": getUserCode(), "Created_DateTime": getCurrentDate() ,"lstTasks": leaveData, "lstTaskTags":doctortag, "lstAttachments":attachment,"Task_Actual_Date":dateselected,"Task_Due_Date":taskdate, "Task_HeaderId":0]
                    
                    let data: [String : Any] = ["_objTask": postData]
                    let arrayData: NSArray = [data]
                    savetaskmethod(postData: postData, selecteddate: dateselected)
                }
            } else
            {
                AlertView.showNoInternetAlert()
            }
        }
        else
        {
            let initialAlert = "Please enter title and content!"
            //let indexpath = sender.tag
            let alertViewController = UIAlertController(title: alertTitle, message: initialAlert, preferredStyle: UIAlertControllerStyle.alert)
            
            alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
                alertViewController.dismiss(animated: true, completion: nil)
            }))
            self.present(alertViewController, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //attachmentFiles.removeAll()
        self.statuslabel.tintColor = .clear
        self.duedatelabel.tintColor = .clear
        self.due = getDateFromString(dateString: dateselected)
        contenttext.layer.cornerRadius = 10.0
        contenttext.layer.borderWidth = 1.0
        contenttext.layer.borderColor = UIColor.gray.cgColor
        titletext.layer.cornerRadius = 10.0
        titletext.layer.borderWidth = 1.0
        titletext.layer.borderColor = UIColor.gray.cgColor
        
        //duedatelabel.isEnabled = false
        
        //statuslabel.isEnabled = false
        self.addTimePicker()
        duedatelabel.inputView = toTimePicker
        duedatelabel.text = dateselected
        let year: String = String(dateselected.prefix(4))
        let tempmonth: String = String(dateselected.suffix(5))
        let month: String = String(tempmonth.prefix(2))
        let date: String = String(tempmonth.suffix(2))
        duedatelabel.text = date + "/" + month + "/" + year
        scrollView.addSubview(content)
        self.view.addSubview(scrollView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.delegate = self
        self.tableView.reloadData()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.autoresizingMask = UIViewAutoresizing.flexibleHeight;
        status.isHidden = true
        statusview.isHidden = true
        setemptystate()
        pickerView = UIPickerView()
        pickerView.backgroundColor = UIColor.lightGray
        pickerView.delegate = self
        statuslabel.inputView = pickerView
        pickerdone()
        //collectionView.heightAnchor.constraint(equalToConstant: 0.0)
        self.tableView.reloadData()
        if(iseditnotes && !isedittask )
        {
            self.scrollView.alpha = 0.35
            addBarButtonItem()
            duedate.isHidden = true
            status.isHidden = true
            statusview.isHidden = true
            duedateview.isHidden = true
            adddoc.isEnabled = false
            addattach.isEnabled = false
            savebtn.isHidden = true
            removeallbtn.isEnabled = false
            let model = editlist
            titletext.text = model.value(forKey:"Title") as! String
            let notes = model.value(forKey: "lstNotes") as! NSArray
            let temp = notes[0] as! NSDictionary
            contenttext.text = temp.value(forKey: "Notes_Description") as! String
            titletext.isEnabled = false
            contenttext.isUserInteractionEnabled = false
            status.isEnabled = false
            duedate.isEnabled = false
            collectionView.isUserInteractionEnabled = false
            if(model.value(forKey: "lstNotesTags") != nil)
            {
                let doctorview = model.value(forKey: "lstNotesTags") as! NSArray
                if(doctorview.count > 0)
                {
                    for i in doctorview
                    {   let dict: NSDictionary = [:]
                        let temp : CustomerMasterModel = CustomerMasterModel(dict:dict)
                        temp.Customer_Code = (i as! NSDictionary).value(forKey:"Customer_Code") as! String
                        temp.Customer_Name = (i as! NSDictionary).value(forKey:"Doctor_Name") as! String
                        self.DoctorList.append(temp)
                    }
                    // DoctorList = doctorview[0] as! [CustomerMasterModel]
                    //  self.tableView.reloadData()
                }
            }
            if (model.value(forKey: "lstAttachments") != nil)
            {
                let attachment = model.value(forKey: "lstAttachments") as! NSArray
                if(attachment.count > 0)
                {
                    
                    for i in attachment
                    {
                        let temp : Bloburl = Bloburl()
                        temp.bloburl = (i as! NSDictionary).value(forKey:"Attachment_URL") as! String
                        temp.filename = (i as! NSDictionary).value(forKey:"File_Name") as! String
                        self.attachementList.append(temp)
                    }
                }
            }
        }
        else if (isedittask && !iseditnotes)
        {
            self.scrollView.alpha = 0.35
            addBarButtonItem()
            titletext.isEnabled = false
            contenttext.isUserInteractionEnabled = false
            status.isEnabled = false
            duedate.isEnabled = false
            adddoc.isEnabled = false
            addattach.isEnabled = false
            savebtn.isHidden = true
            removeallbtn.isEnabled = false
            collectionView.isUserInteractionEnabled = false
            let model = editlist
            titletext.text = model.value(forKey:"Title") as! String
            let notes = model.value(forKey: "lstTasks") as! NSArray
            let temp = notes[0] as! NSDictionary
            contenttext.text = temp.value(forKey: "Tasks_Description") as! String
            duedatelabel.text = model.value(forKey:"Task_Due_Date") as! String
            statusview.isHidden = false
            status.isHidden = false
            statusview.isUserInteractionEnabled = false
            duedateview.isUserInteractionEnabled = false
            statuslabel.text = model.value(forKey:"Task_Status") as! String
            if(model.value(forKey: "lstTaskTags") != nil)
            {
                let doctorview = model.value(forKey: "lstTaskTags") as! NSArray
                if(doctorview.count > 0)
                {
                    for i in doctorview
                    {   let dict: NSDictionary = [:]
                        let temp : CustomerMasterModel = CustomerMasterModel(dict:dict)
                        temp.Customer_Code = (i as! NSDictionary).value(forKey:"Customer_Code") as! String
                        temp.Customer_Name = (i as! NSDictionary).value(forKey:"Doctor_Name") as! String
                        self.DoctorList.append(temp)
                    }
                    setemptystate()
                    // DoctorList = doctorview[0] as! [CustomerMasterModel]
                    //self.tableView.reloadData()
                }
            }
            if(model.value(forKey: "lstAttachments") != nil)
            {
                let attachment = model.value(forKey: "lstAttachments") as! NSArray
                if(attachment.count > 0)
                {
                    
                    for i in attachment
                    {
                        let temp : Bloburl = Bloburl()
                        temp.bloburl = (i as! NSDictionary).value(forKey:"Attachment_URL") as! String
                        temp.filename = (i as! NSDictionary).value(forKey:"File_Name") as! String
                        self.attachementList.append(temp)
                    }
                }
            }
        }
        setemptystate()
        
        self.collectionView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if(isfromnotes == true && !isfromtask && !isedittask)
        {
            duedate.isHidden = true
            status.isHidden = true
            statusview.isHidden = true
            duedateview.isHidden = true
            
        }
        else if(isfromtask && !isedittask)
        {
            status.isHidden = true
            statusview.isHidden = true
        }
        
        var list : [NotesAttachment] = []
        list = DBHelper.sharedInstance.getAttachmentNotes()!
        if(list != nil )
        {
            if(list.count > 0)
            {
                for i in list
                {
                    Upload(model: i)
                }
            }
            DBHelper.sharedInstance.deleteNotesAttachment()
        }
        setemptystate()
        if(self.DoctorList.count < 1)
        {
            self.removeallbtn.isHidden = true
        }
        else
        {
            self.removeallbtn.isHidden = false
        }
        self.tableView.reloadData()
        self.collectionView.reloadData()
        self.addTimePicker()
        // self.tableviewhgt.constant = self.tableView.contentSize.height
        self.tableView.autoresizingMask = UIViewAutoresizing.flexibleHeight;
    }
    func addBarButtonItem()
    {
        editbtn = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editAction))
        self.navigationItem.rightBarButtonItem = editbtn
    }
    func editAction()
    {
        self.scrollView.alpha = 1
        titletext.isEnabled = true
        contenttext.isUserInteractionEnabled = true
        status.isEnabled = true
        duedate.isEnabled = true
        adddoc.isEnabled = true
        addattach.isEnabled = true
        savebtn.isHidden = false
        statusview.isUserInteractionEnabled = true
        duedateview.isUserInteractionEnabled = true
        editbtn.title =  ""
        editbtn.isEnabled = false
        removeallbtn.isEnabled = true
        collectionView.isUserInteractionEnabled = true
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerdone()
    {
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action:
            #selector(done))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancel))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statusArray.count
    }
    @objc func done()
    {
        statuslabel.text = statusArray[self.selectedRow] as! String
        if(statusArray[self.selectedRow] as! String == "")
        {
            statuslabel.text = "Open"
        }
    }
    @objc func cancel()
    {
        self.statuslabel.resignFirstResponder()
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statusArray[row] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedRow = row
        statuslabel.text = statusArray[row] as! String
        if (statusArray[row] as! String == "")
        {
            statuslabel.text = "Open"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return SCREEN_WIDTH
    }
    private func addTimePicker()
    {
        let timePicker = UIDatePicker()
        let locale = NSLocale(localeIdentifier: "en_US")
        timePicker.locale = locale as Locale
        timePicker.datePickerMode = UIDatePickerMode.date
        //timePicker.date = getDateFromString(dateString: dateselected)
        timePicker.frame.size.height = timePickerHeight
        timePicker.backgroundColor = UIColor.lightGray
        //timePicker.minimumDate = Date()
        let dateFormatter = DateFormatter()
        
        if(isedittask)
        {
            let model = editlist
            let retaineddate = model.value(forKey:"Task_Actual_Date") as! String
            let temp: String = retaineddate
            let year: String = String(temp.suffix(4))
            let tempmonth: String = String(temp.prefix(5))
            let month: String = String(tempmonth.suffix(2))
            let day: String = String(tempmonth.prefix(2))
            var dateString = year + "-" + month + "-" + day
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let s = dateFormatter.date(from: dateString)
            timePicker.minimumDate = s
        }
        else
        {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let s = dateFormatter.date(from: dateselected)
            timePicker.minimumDate = s
        }
        toTimePicker = timePicker
        
        let doneToolbar = getToolBar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(NotesTaskViewController.doneBtnClicked))
        let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(NotesTaskViewController.cancelBtnClicked))
        doneToolbar.items = [flexSpace, done, cancel]
        doneToolbar.sizeToFit()
        
        duedatelabel.inputAccessoryView = doneToolbar
        duedatelabel.inputView = toTimePicker
        timePicker.addTarget(self, action: #selector(NotesTaskViewController.setTimeDetails), for: UIControlEvents.valueChanged)
    }
    @objc func doneBtnClicked()
    {
        self.setTimeDetails(sender: toTimePicker)
        self.resignResponderForTxtField()
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.DoctorList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell =  UITableViewCell()
        let doctor = DoctorList[indexPath.row]
        cell.textLabel?.text = "  " + doctor.Customer_Name as String
        cell.textLabel?.textColor = UIColor(red: 0/255, green: 114/255, blue: 229/255, alpha: 1.0)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 25
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.collectionView.collectionViewLayout.invalidateLayout()
        return self.attachementList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotesCollectionCell", for: indexPath) as! NotesCollectionViewCell
        
        cell.activityIndicatorView.isHidden = false
        
        if(getAttachmentType(filePath: String(attachementList[indexPath.item].filename))  == Constants.AttachmentType.image)
        {
            cell.fileNameLbl.text = ""
            
            cell.activityIndicatorView.isHidden = true
            cell.imageView.image = UIImage(named: "icon-image")
            cell.fileNameLbl.text = attachementList[indexPath.item].filename
            self.downloadImage(objAttachment: attachementList[indexPath.item], imageView: cell.imageView, fileNameLbl: cell.fileNameLbl)
        }
        else if(getAttachmentType(filePath: attachementList[indexPath.item].bloburl)  == Constants.AttachmentType.excel)
        {
            cell.activityIndicatorView.isHidden = true
            cell.imageView.image = UIImage(named: "icon-excel")
            cell.fileNameLbl.text = attachementList[indexPath.item].filename
        }
        else if(getAttachmentType(filePath: attachementList[indexPath.item].bloburl)  == Constants.AttachmentType.word)
        {
            cell.activityIndicatorView.isHidden = true
            cell.imageView.image = UIImage(named: "icon-word")
            cell.fileNameLbl.text = attachementList[indexPath.item].filename
        }
        else if(getAttachmentType(filePath: attachementList[indexPath.item].bloburl)  == Constants.AttachmentType.pdf)
        {
            cell.activityIndicatorView.isHidden = true
            cell.imageView.image = UIImage(named: "icon-pdf")
            cell.fileNameLbl.text = attachementList[indexPath.item].filename
        }
        else if(getAttachmentType(filePath: attachementList[indexPath.item].bloburl)  == Constants.AttachmentType.zip)
        {
            cell.activityIndicatorView.isHidden = true
            cell.imageView.image = UIImage(named: "icon-zip")
            cell.fileNameLbl.text = attachementList[indexPath.item].filename
        }
        cell.closeBut.tag = indexPath.item
        //but.setTitle("MODIFY", for: .normal)
        cell.closeBut.addTarget(self, action: #selector(delete(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let localPath =  attachementList[indexPath.item].bloburl
        navigateTowebView(siteUrl: localPath,title:attachementList[indexPath.item].filename)
    }
    
    func navigateTowebView(siteUrl:String, title:String)
    {
        let sb = UIStoryboard(name: mainSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: webViewVCID) as! WebViewController
        vc.siteURL = siteUrl
        vc.title = title
        getAppDelegate().root_navigation.pushViewController(vc, animated: true)
    }
    
    private func downloadImage(objAttachment: Bloburl, imageView: UIImageView, fileNameLbl: UILabel)
    {
        let imageView = imageView
        
        if (checkNullAndNilValueForString(stringData: objAttachment.bloburl) != EMPTY)
        {
            //            DownloadManager.sharedInstance.downLoadImageForUrl(urlString: objAttachment.Blob_Url, additionalDetail: imageView, completionHandler: { (downloadedImage, url) in
            //                if (downloadedImage != nil)
            //                {
            //                    imageView.image = downloadedImage! //Bl_Attachment.sharedInstance.imageResize(imageObj: downloadedImage!)
            //                    fileNameLbl.text = EMPTY
            //                }
            //            })
            
            ImageLoadingWithCache.sharedInstance.getImage(url: objAttachment.bloburl, imageView: imageView, textLabel: fileNameLbl)
        }
    }
    
    
    @objc func setTimeDetails(sender : UIDatePicker)
    {
        let datePic = sender.date
        endDate = datePic
        self.duedatelabel.text = stringDateFormat(date1: datePic)
    }
    
    func stringDateFormat(date1: Date) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = defaultDateFomat
        formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        formatter.timeZone = NSTimeZone.local
        return formatter.string(from: date1)
    }
    
    @objc func cancelBtnClicked()
    {
        self.resignResponderForTxtField()
    }
    
    @objc func resignResponderForTxtField()
    {
        self.duedatelabel.resignFirstResponder()
        //self.leaveReason.resignFirstResponder()
    }
    func savenotesmethod(postData: [String:Any], selecteddate: String)
    {
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: "Loading...")
            WebServiceHelper.sharedInstance.createnotes( postData: postData, key: "_objNotes",  completion: { (apiObj) in
                if apiObj.Status == SERVER_SUCCESS_CODE
                {
                    removeCustomActivityView()
                    self.navigationController?.popViewController(animated: true)
                }
                else
                {
                    removeCustomActivityView()
                }
            },date: selecteddate)
        }
        //  removeCustomActivityView()
    }
    
    func savetaskmethod(postData: [String:Any], selecteddate: String)
    {
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: "Loading...")
            WebServiceHelper.sharedInstance.createTasks( postData: postData, key: "_objTask",  completion: { (apiObj) in
                if apiObj.Status == SERVER_SUCCESS_CODE
                {
                    removeCustomActivityView()
                    self.navigationController?.popViewController(animated: true)
                }
                else
                {
                    removeCustomActivityView()
                }
            },date: selecteddate)
        }
        // removeCustomActivityView()
    }
    func editnotesmethod(postData: [String:Any], selecteddate: String, id: Int)
    {
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: "Loading...")
            WebServiceHelper.sharedInstance.editnotes( postData: postData, key: "_objNotes", id: id,  completion: { (apiObj) in
                if apiObj.Status == SERVER_SUCCESS_CODE
                {
                    removeCustomActivityView()
                    self.navigationController?.popViewController(animated: true)
                }
                else
                {
                    removeCustomActivityView()
                }
            },date: selecteddate)
        }
        // removeCustomActivityView()
    }
    
    func edittaskmethod(postData: [String:Any], selecteddate: String ,id: Int)
    {
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: "Loading...")
            WebServiceHelper.sharedInstance.editTasks( postData: postData, key: "_objTask", id: id,  completion: { (apiObj) in
                if apiObj.Status == SERVER_SUCCESS_CODE
                {
                    removeCustomActivityView()
                    self.navigationController?.popViewController(animated: true)
                }
                else
                {
                    removeCustomActivityView()
                }
            },date: selecteddate)
        }
        // removeCustomActivityView()
    }
    func Upload(model: NotesAttachment)
    {
        if(checkInternetConnectivity())
        {
            let filePath = Bl_Attachment.sharedInstance.getAttachmentFileURL(fileName: model.AttachmentName!)
            if filePath != ""
            {
                if let getFileData = NSData(contentsOfFile: filePath)
                {
                    if checkInternetConnectivity()
                    {
                        showCustomActivityIndicatorView(loadingText: "Loading...")
                        let formatter = DateFormatter()
                        formatter.dateFormat = "ddMMyyyyhhmmssSSS"
                        let _:String = formatter.string(from: getCurrentDateAndTime())
                        let outputFilename = "\(model.AttachmentName!)"
                        
                        var fileExtension: String!
                        let fileSplittedString = model.AttachmentName?.components(separatedBy: ".")
                        if (fileSplittedString?.count)! > 0
                        {
                            fileExtension = fileSplittedString?.last
                        }
                        else
                        {
                            fileExtension = png
                        }
                        
                        let urlString = wsRootUrl + "QuickNoteApi/Attachment/Upload/" + getCompanyCode()
                        print("URL \(urlString)")
                        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
                        request.httpMethod = "POST"
                        request.timeoutInterval = 60.0
                        
                        let boundary = generateBoundaryString()
                        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                        
                        let params = ["localFileName":model.AttachmentName]
                        print("Params \(params)")
                        // Post parameters K1.QNAttachmentInfo (for File)
                        //K2.localFileName(for file Name)
                        var body = Data()
                        for (key, value) in params
                        {
                            body.append("--\(boundary)\r\n")
                            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                            body.append("\(value)\r\n")
                        }
                        
                        body.append("--\(boundary)\r\n")
                        body.append("Content-Disposition: form-data; name=\"QNAttachmentInfo\"; filename=\"\(outputFilename)\"\r\n")
                        let contentType = Bl_Attachment.sharedInstance.getFileContentType(fileExtension: fileExtension)
                        body.append("Content-Type: \(contentType)\r\n\r\n")
                        body.append(getFileData as Data)
                        body.append("\r\n")
                        body.append("--\(boundary)--\r\n")
                        
                        
                        
                        
                        //                    for (key, value) in params {
                        //                        body.append("--\(boundary)\r\n")
                        //                        body.append("Content-Disposition: form-data; localFileName=\"\(key)\"\r\n\r\n")
                        //                        body.append("\(value)\r\n")
                        //
                        //                    }
                        //                    //Content-Disposition: form-data; name="QNAttachmentInfo"; filename="attachment" " Content-Transfer-Encoding: binary Content-Type: */*
                        //                    body.append("--\(boundary)\r\n")
                        //                    body.append("Content-Disposition: form-data; QNAttachmentInfo=\"\(outputFilename)\"\r\n")
                        //                    let contentType = Bl_Attachment.sharedInstance.getFileContentType(fileExtension: fileExtension)
                        //                    body.append("Content-Type: \(contentType)\r\n\r\n")
                        //                    body.append(getFileData as Data)
                        //                    body.append("\r\n")
                        //
                        //                    body.append("--\(boundary)--\r\n")
                        
                        request.httpBody = body
                        
                        let session = URLSession(configuration: URLSessionConfiguration.default)
                        var task = URLSessionDataTask()
                        
                        let blockOperation = BlockOperation(block: {
                            
                            task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                                
                                OperationQueue.main.addOperation({
                                    
                                    if error != nil
                                    {
                                        let getError = error as NSError?
                                        print("Service error \(String(describing: getError?.code))")
                                        if getError?.code == -1009
                                        {
                                            // self.showInternetErrorToast()
                                        }
                                        else
                                        {
                                            // self.updateFailureStatus(model: model)
                                        }
                                    }
                                    else
                                    {
                                        if data != nil
                                        {
                                            if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode
                                            {
                                                print(response)
                                                if let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                                                {
                                                    print(json)
                                                    if let jsonDict = json as? NSDictionary
                                                    {
                                                        if let listarray = jsonDict.value(forKey: "list") as? NSArray
                                                        {
                                                            if listarray.count > 0
                                                            {
                                                                let dictionary = listarray[0] as! NSDictionary
                                                                let temp : Bloburl = Bloburl()
                                                                temp.bloburl = dictionary.value(forKey: "Attachment_URL") as! String
                                                                temp.filename = dictionary.value(forKey: "FileName") as! String
                                                                self.attachementList.append(temp)
                                                                
                                                                self.setemptystate()
                                                                self.collectionView.reloadData()
                                                                removeCustomActivityView()
                                                                //self.attachmentFiles.append(file)
                                                            }
                                                            else
                                                            {
                                                                //self.updateFailureStatus(model: model)
                                                            }
                                                        }
                                                        else
                                                        {
                                                            //self.updateFailureStatus(model: model)
                                                        }
                                                    }
                                                    else
                                                    {
                                                        //.updateFailureStatus(model: model)
                                                    }
                                                }
                                                else
                                                {
                                                    //self.updateFailureStatus(model: model)
                                                }
                                            }
                                            else
                                            {
                                                //self.updateFailureStatus(model: model)
                                            }
                                        }
                                        else
                                        {
                                            // self.updateFailureStatus(model: model)
                                        }
                                    }
                                    
                                })
                            }
                            
                            task.resume()
                        })
                        
                        queue.addOperation(blockOperation)
                    }
                    else
                    {
                        print("No internet connection")
                        //self.showInternetErrorToast()
                    }
                }
                else
                {
                    print("Invalid file data")
                    //self.updateFailureStatus(model: model)
                }
            }
            else
            {
                print("File path is empty")
                //self.updateFailureStatus(model: model)
            }
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    
    func setemptystate()
    {
        if(self.attachementList.count > 0)
        {
            self.noattachments.isHidden = true
        }
        else
        {
            self.noattachments.isHidden = false
        }
        if (self.DoctorList.count > 0)
        {
            self.nodoctors.isHidden = true
        }
        else
        {
            self.nodoctors.isHidden = false
        }
    }
    func getAttachmentType(filePath: String) -> String
    {
        var type: String = EMPTY
        
        if (checkNullAndNilValueForString(stringData: filePath) != EMPTY)
        {
            let fileExtension = getFileComponent(fileName: filePath, separatedBy: ".").lowercased()
            
            if (filePath.contains(".png") || filePath.contains(".jpg") || filePath.contains(".jpeg") || filePath.contains(".gif") || filePath.contains(".tif") || filePath.contains(".tiff"))
            {
                type = Constants.AttachmentType.image
            }
            else if (filePath.contains(".xls") || (filePath.contains(".xlsx")))
            {
                type = Constants.AttachmentType.excel
            }
            else if (filePath.contains(".doc") || (filePath.contains(".docx")))
            {
                type = Constants.AttachmentType.word
            }
            else if (filePath.contains(".pdf"))
            {
                type = Constants.AttachmentType.pdf
            }
            else if (filePath.contains(".zip"))
            {
                type = Constants.AttachmentType.zip
            }
        }
        
        return type
    }
    private func getFileComponent(fileName: String, separatedBy: String) -> String
    {
        var component: String = EMPTY
        let componentsArr = fileName.components(separatedBy: separatedBy)
        
        if let ext = componentsArr.last
        {
            component = ext
        }
        
        return component
    }
    @objc func delete(sender:UIButton)
    {
        let initialAlert = "Are you sure to Delete"
        let indexpath = sender.tag
        let alertViewController = UIAlertController(title: alertTitle, message: initialAlert, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { alertAction in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
            self.deleteattachment(index: indexpath)
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    func deleteattachment(index: Int)
    {
        self.attachementList.remove(at: index)
        self.collectionView.reloadData()
    }
}

class  Bloburl: NSObject
{
    var bloburl: String = ""
    var filename: String = ""
}
