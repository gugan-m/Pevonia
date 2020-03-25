//
//  DCRCalendarController.swift
//  HiDoctorApp
//
//  Created by Vijay on 05/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import JTAppleCalendar

class DCRCalendarController: UIViewController, JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, dismissViewDelegate, SSRadioButtonControllerDelegate {
    
    
    func didSelectButton(selectedButton: UIButton?) {
        
    }
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var contentViewBtmConst: NSLayoutConstraint!
    @IBOutlet weak var calendarContainerView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var holidayLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var pickerTextfield: UITextField!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var hidebtnHeightConst: NSLayoutConstraint!
    @IBOutlet var lblNoDcr: UILabel!
    
    @IBOutlet weak var bg_BlurView: UIView!
    @IBOutlet weak var planing_alertView: UIView!
    @IBOutlet weak var lbl_PlanningHeader: UILabel!
    
    @IBAction func closepopupaction() {
    
    self.hidePlanningPopup()
    
    }
    
    @IBOutlet weak var Radiobtnfeild: UIButton!
    @IBOutlet weak var Radiobtnprospect: UIButton!
    
    @IBOutlet weak var Radiobtnoffice: UIButton!
    
    @IBOutlet weak var Radiobtnnotworking: UIButton!
    @IBAction func Okbtnactionforpopup() {
        
        if (radioButtonController?.selectedButton() == Radiobtnfeild)
        {
            moveToNexstScreen(title: DCRActivityName.fieldRcpa.rawValue)
        }
        else if (radioButtonController?.selectedButton() == Radiobtnprospect)
        {
            moveToNexstScreen(title: DCRActivityName.prospect.rawValue)
        }
        else if (radioButtonController?.selectedButton() == Radiobtnoffice)
        {
            moveToNexstScreen(title: DCRActivityName.attendance.rawValue)
        }
        else if (radioButtonController?.selectedButton() == Radiobtnnotworking)
        {
            moveToNexstScreen(title: DCRActivityName.leave.rawValue)
        }
        self.hidePlanningPopup()
    }
    var buttonArray = [UIButton]()
    var pickerView: UIPickerView!
    var selectedRow: Int = -1
    var monthArray:NSArray = []
    var dcrDetailList : [DCRDetail] = []
    var rowHeightArr : NSMutableArray = []
    var startDate: Date!
    var endDate: Date!
    var middleDate: Date!
    var selectedDate: Date!
    var numberOfRowsCalendar = 6
    var currentCalendar = Calendar.current
    var generateInDates: InDateCellGeneration = .forAllMonths
    var generateOutDates: OutDateCellGeneration = .tillEndOfGrid
    let firstDayOfWeek: DaysOfWeek = .sunday
    let rowEditBtnHeight : CGFloat = 40.0
    var attendanceUnapprovedHeight : CGFloat!
    var rcpaUnapprovedHeight : CGFloat!
    var leaveUnapprovedHeight : CGFloat!
    let unApprovedViewHeight : CGFloat = 100.0
    var unApprovedTextConstWidth : CGFloat = 0.0
    var rcpaCellHeight : CGFloat = 0.0
    var variablercpaCellHeight : CGFloat!
    let attendanceCellHeight : CGFloat = 130.0
    var variableAttendanceCellHeight : CGFloat!
    let leaveCellHeight : CGFloat = 80.0
    var variableLeaveCellHeight : CGFloat!
    var tableViewHeight: CGFloat!
    let rcpaCellIdentifier : String = "rcpaCell"
    let attendanceCellIdentifier : String = "attendanceCell"
    let leaveCellIdentifier : String = "leaveCell"
    var currentConstraintHeight : CGFloat!
    let defaultRowHeight : CGFloat = 80.0
    let defaultHeaderHeight :  CGFloat = 65.0
    var unApprovedEditHidden : Bool!
    var currentStartDate : Date!
    var currentEndDate: Date!
    
    var doctorVisitCountText: String = "Total \(appDoctor) Visits:"
    var doctorPendingCountText: String = "Planned \(appDoctor) Pending Visits:"
    var hourlyreportdata: [HourlyReportModel] = []
    var dcrID: Int = 0
    var doctorobj : DCRDoctorVisitModel?
    var date: String = ""
    var dcrVisitidArray: [String] = []
    var Visitid: Int = 0
    var radioButtonController: SSRadioButtonsController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        calendarView.register(UINib(nibName: "DCRCalendarCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        //        let dictionary = BL_DCRCalendar.sharedInstance.getCPNMonth()
        //        monthArray = dictionary.value(forKey: "monthArray") as! NSArray
        //        startDate = dictionary.value(forKey: "startDate") as! Date
        //        endDate = dictionary.value(forKey: "endDate") as! Date
        //        middleDate = dictionary.value(forKey: "middleDate") as! Date
        //
        //        calendarView.calendarDelegate = self
        //        calendarView.calendarDataSource = self
        // Do any additional setup after loading the view.
        self.lblNoDcr.text = "No \(PEV_DCR) Entry is available for this day"
        loadCalendar()
        BL_Upload_DCR.sharedInstance.isFromDCRUpload = false
        self.planing_alertView.layer.cornerRadius = 10.0
        self.hidePlanningPopup()
        buttonArray.append(Radiobtnfeild)
        buttonArray.append(Radiobtnprospect)
        buttonArray.append(Radiobtnoffice)
        buttonArray.append(Radiobtnnotworking)
        Radiobtnnotworking.isEnabled = false
        Radiobtnoffice.isEnabled = false
        Radiobtnprospect.isEnabled = false
        Radiobtnfeild.isEnabled = false
        radioButtonController = SSRadioButtonsController(buttons: Radiobtnfeild,Radiobtnprospect,Radiobtnoffice,Radiobtnnotworking)
        radioButtonController!.delegate = self
        radioButtonController!.shouldLetDeSelect = true
        radioButtonController?.setButtonsArray(buttonArray)
    }
    func hidePlanningPopup() {
        self.planing_alertView.isHidden = true
        self.bg_BlurView.isHidden = true
    }
    func showPlanningPopup(selectedDate: String) {
        // let newButtonWidth: CGFloat = 60
         self.planing_alertView.isHidden = false
         self.bg_BlurView.isHidden = false
        self.lbl_PlanningHeader.text = "Entering for " + selectedDate.prefix(11)
         UIView.animate(withDuration: 0.5, //1
             delay: 0.0, //2
             usingSpringWithDamping:0.1, //3
             initialSpringVelocity: 3, //4
             options: UIView.AnimationOptions.curveEaseInOut, //5
             animations: ({ //6
                // self.planning_alertView.frame = CGRect(x: 0, y: 0, width: newButtonWidth, height: newButtonWidth)
                 self.planing_alertView.center = self.view.center
         }), completion: nil)
     }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = true
        showVersionToastView(textColor : UIColor.darkGray)
        
        // let value = UIInterfaceOrientation.portrait.rawValue
        //  UIDevice.current.setValue(value, forKey: "orientation")
        
        setDefaults()
        BL_DCRCalendar.sharedInstance.getCalendarModel()
        loadDCRDetails(viewHeight: self.view.frame.size.height - 64.0)
        
        BL_PrepareMyDevice.sharedInstance.getbussinessStatusPotential()
        
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = false
        
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        addBtn.isHidden = true
        calendarView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        orientationCalendarReloadData()
    }
    
    override func viewDidLayoutSubviews() {
        removeVersionToastView()
        showVersionToastView(textColor: UIColor.darkGray)
    }
    
    // Default styles
    func setDefaults()
    {
        let offset = CGPoint(x: 0, y: 0)
        scrollView.setContentOffset(offset, animated: false)
        pickerView = UIPickerView()
        pickerView.backgroundColor = UIColor.lightGray
        pickerView.delegate = self
        pickerView.selectRow(1, inComponent: 0, animated: false)
        let pickerToolbar = UIToolbar()
        let doneButton : UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(DCRCalendarController.doneClicked))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        pickerToolbar.setItems([spaceButton, doneButton], animated: false)
        pickerToolbar.sizeToFit()
        pickerTextfield.inputView = pickerView
        pickerTextfield.inputAccessoryView = pickerToolbar
        unApprovedTextConstWidth = SCREEN_WIDTH - 54.0 - 15.0 - 30.0
    }
    
    private func loadCalendar()
    {
        BL_DCRCalendar.sharedInstance.getCalendarModel()
        selectedDate = getcurrentdateforcalendar(date: Date())
        loadDCRDetails(viewHeight: self.view.frame.size.height - 64.0)
        
        calendarView.register(UINib(nibName: "DCRCalendarCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        let dictionary = BL_DCRCalendar.sharedInstance.getCPNMonth()
        monthArray = dictionary.value(forKey: "monthArray") as! NSArray
        startDate = dictionary.value(forKey: "startDate") as! Date
        endDate = dictionary.value(forKey: "endDate") as! Date
        middleDate = dictionary.value(forKey: "middleDate") as! Date
        
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        //        calendarView.scrollToDate(Date() as Date, triggerScrollToDateDelegate: false, animateScroll: false)
        //        //moveToMonthSegment(date: middleDate)
        //        moveToMonthSegment(date: selectedDate)
        //         calendarView.selectDates([selectedDate])
        //        //calendarView.deselectAllDates()
        //
        //        calendarView.reloadData()
        calendarView.scrollToDate(Date() as Date, triggerScrollToDateDelegate: false, animateScroll: false)
        calendarView.scrollDirection = .horizontal
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        //calendarView.cellInset = CGPoint(x: 0, y: 0)
        moveToMonthSegment(date: selectedDate)
        calendarView.selectDates([selectedDate])
    }
    
    func orientationCalendarReloadData()
    {
        if currentStartDate != nil
        {
            BL_DCRCalendar.sharedInstance.getCalendarModel()
            calendarView.scrollToDate(Date() as Date, triggerScrollToDateDelegate: false, animateScroll: false)
            calendarView.scrollDirection = .horizontal
            calendarView.scrollingMode = .stopAtEachCalendarFrame
            moveToMonthSegment(date: currentStartDate)
            calendarView.reloadData()
        }
        
    }
    func addaction(){
        Radiobtnnotworking.isEnabled = false
        Radiobtnoffice.isEnabled = false
        Radiobtnprospect.isEnabled = false
        Radiobtnfeild.isEnabled = false
        Radiobtnnotworking.isSelected = false
        Radiobtnprospect.isSelected = false
        Radiobtnoffice.isSelected = false
        Radiobtnfeild.isSelected = false
        Radiobtnnotworking.alpha = 0.3
        Radiobtnprospect.alpha = 0.3
        Radiobtnoffice.alpha = 0.3
        Radiobtnfeild.alpha = 0.3
        
        
        removeVersionToastView()
        
        let userStartDate : Date = getUserStartDate()
        
        if userStartDate.compare(selectedDate) == .orderedDescending
        {
            AlertView.showAlertView(title: alertTitle, message: addDCRErrorMsg, viewController: self)
        }
        else
        {
            print(selectedDate)
            if BL_DCRCalendar.sharedInstance.activityRestrictionValidation(dcrDate: selectedDate)
            {
                showActivityRestrictionAlert()
            }
                
            else
            {
                //DBHelper.sharedInstance.updateSessionId(sessionId: sessionId)
                print(DBHelper.sharedInstance.getUserDetail())
                
                
                let array:NSArray = BL_DCRCalendar.sharedInstance.dcrCategoryValidation(date: selectedDate)
                let dcrCategoryMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                for titles in array
                {
                    let categoryAction = UIAlertAction(title: titles as? String, style: .default, handler: {
                        (alert: UIAlertAction) -> Void in
                        
                        if (BL_DCRCalendar.sharedInstance.dcrEntryTPApprovalNeeded())
                        {
                            if BL_DCRCalendar.sharedInstance.canShowTPDownloadAlertApprovedTP(selectedDate: self.selectedDate!)
                            {
                                let modelData:[DCRCalendarModel] = BL_DCRCalendar.sharedInstance.dcrLWHAModel
                                if modelData.count > 0
                                {
                                    if modelData[0].Is_WeekEnd == 1 || modelData[0].Is_Holiday == 1
                                    {
                                        self.showTPDownloadAlert(title: titles as! String, showSkip: true)
                                    }
                                    else
                                    {
                                        self.showTPDownloadAlert(title: titles as! String, showSkip: false)
                                    }
                                }
                                else
                                {
                                    self.activityValidation(title: titles as! String)
                                }
                            }
                            else
                            {
                                self.activityValidation(title: titles as! String)
                            }
                        }
                        else if (BL_DCRCalendar.sharedInstance.isTpLockPrivilegeEnabled())
                        {
                            if BL_DCRCalendar.sharedInstance.canShowTPDownloadAlert(selectedDate: self.selectedDate!)
                            {
                                self.showTPDownloadAlert(title: titles as! String, showSkip: true)
                            }
                            else
                            {
                                self.activityValidation(title: titles as! String)
                            }
                        }
                        else
                        {
                            self.activityValidation(title: titles as! String)
                        }
                    })
                    dcrCategoryMenu.addAction(categoryAction)
                    let tpModelList = DBHelper.sharedInstance.getTpDataforDCRDate(date: selectedDate, activity: DCRActivity.fieldRcpa.rawValue, status: TPStatus.approved.rawValue)
                    if titles as! String == DCRActivityName.fieldRcpa.rawValue || title == "Field_RCPA"
                    {
                        
                        
                        if tpModelList.count > 0
                        {
                        if tpModelList[0].TpType == "F" || tpModelList[0].Project_Code == "Field_RCPA"
                        {
                            
                            Radiobtnfeild.isSelected = true
                        }
                        }
                        Radiobtnfeild.isEnabled = true
                        Radiobtnfeild.alpha = 1
                    }
                    else  if titles as! String == DCRActivityName.prospect.rawValue || title == "Field_RCPA"
                    {
                        if tpModelList.count > 0
                        {
                        if tpModelList[0].TpType == "P"
                        {
                            
                            Radiobtnprospect.isSelected = true
                        }
                        }
                        Radiobtnprospect.isEnabled = true
                        Radiobtnprospect.alpha = 1
                    }
                    else if titles as! String == DCRActivityName.attendance.rawValue
                    {
                        if tpModelList.count > 0
                        {
                        if tpModelList[0].Project_Code == "ATTENDANCE" || tpModelList[0].TpType == "A"
                        {
                            
                            Radiobtnoffice.isSelected = true
                        }
                        }
                        Radiobtnoffice.isEnabled = true
                        Radiobtnoffice.alpha = 1
                    }
                    else if titles as! String == DCRActivityName.leave.rawValue
                    {
                        if tpModelList.count > 0
                        {
                        if tpModelList[0].Project_Code == "LEAVE"  || tpModelList[0].TpType == "L"
                        
                        {
                            Radiobtnnotworking.isSelected = true
                        }
                        }
                        Radiobtnnotworking.isEnabled = true
                        Radiobtnnotworking.alpha = 1
                    }
                    
                    
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:{
                    (alert: UIAlertAction) -> Void in
                    showVersionToastView(textColor: UIColor.darkGray)
                })
                
                dcrCategoryMenu.addAction(cancelAction)
                
                
                if SwifterSwift().isPhone
                {
                    //self.present(dcrCategoryMenu, animated: true, completion: nil)
                }
                else
                {
                    if let currentPopoverpresentioncontroller = dcrCategoryMenu.popoverPresentationController{
                        currentPopoverpresentioncontroller.sourceView = self.view
                        currentPopoverpresentioncontroller.sourceRect = CGRect(x:self.view.frame.size.width-50,y:0, width:100,height:100)
                        currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.up
                       // self.present(dcrCategoryMenu, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    @IBAction func addAction(_ sender: AnyObject)
    {
        
        removeVersionToastView()
        
        let userStartDate : Date = getUserStartDate()
        
        if userStartDate.compare(selectedDate) == .orderedDescending
        {
            AlertView.showAlertView(title: alertTitle, message: addDCRErrorMsg, viewController: self)
        }
        else
        {
            print(selectedDate)
            if BL_DCRCalendar.sharedInstance.activityRestrictionValidation(dcrDate: selectedDate)
            {
                showActivityRestrictionAlert()
            }
                
            else
            {
                //DBHelper.sharedInstance.updateSessionId(sessionId: sessionId)
                print(DBHelper.sharedInstance.getUserDetail())
                
                
                let array:NSArray = BL_DCRCalendar.sharedInstance.dcrCategoryValidation(date: selectedDate)
                let dcrCategoryMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                for title in array
                {
                    let categoryAction = UIAlertAction(title: title as? String, style: .default, handler: {
                        (alert: UIAlertAction) -> Void in
                        
                        if (BL_DCRCalendar.sharedInstance.dcrEntryTPApprovalNeeded())
                        {
                            if BL_DCRCalendar.sharedInstance.canShowTPDownloadAlertApprovedTP(selectedDate: self.selectedDate!)
                            {
                                let modelData:[DCRCalendarModel] = BL_DCRCalendar.sharedInstance.dcrLWHAModel
                                if modelData.count > 0
                                {
                                    if modelData[0].Is_WeekEnd == 1 || modelData[0].Is_Holiday == 1
                                    {
                                        self.showTPDownloadAlert(title: title as! String, showSkip: true)
                                    }
                                    else
                                    {
                                        self.showTPDownloadAlert(title: title as! String, showSkip: false)
                                    }
                                }
                                else
                                {
                                    self.activityValidation(title: title as! String)
                                }
                            }
                            else
                            {
                                self.activityValidation(title: title as! String)
                            }
                        }
                        else if (BL_DCRCalendar.sharedInstance.isTpLockPrivilegeEnabled())
                        {
                            if BL_DCRCalendar.sharedInstance.canShowTPDownloadAlert(selectedDate: self.selectedDate!)
                            {
                                self.showTPDownloadAlert(title: title as! String, showSkip: true)
                            }
                            else
                            {
                                self.activityValidation(title: title as! String)
                            }
                        }
                        else
                        {
                            self.activityValidation(title: title as! String)
                        }
                    })
                    dcrCategoryMenu.addAction(categoryAction)
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:{
                    (alert: UIAlertAction) -> Void in
                    showVersionToastView(textColor: UIColor.darkGray)
                })
                
                dcrCategoryMenu.addAction(cancelAction)
                
                if SwifterSwift().isPhone
                {
                    self.present(dcrCategoryMenu, animated: true, completion: nil)
                }
                else
                {
                    if let currentPopoverpresentioncontroller = dcrCategoryMenu.popoverPresentationController{
                        currentPopoverpresentioncontroller.sourceView = self.view
                        currentPopoverpresentioncontroller.sourceRect = CGRect(x:self.view.frame.size.width-50,y:0, width:100,height:100)
                        currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.up
                        self.present(dcrCategoryMenu, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func showActivityRestrictionAlert()
    {
        let alertMsg = "Your first \(PEV_DCR) for this date \(convertDateIntoString(date: selectedDate)) is in approved mode, to apply a another DVR for this day, request your manager to unapprove the first \(PEV_DCR). Note: you can apply second \(PEV_DCR) only when the first \(PEV_DCR) is in applied or in unapproved mode"
        AlertView.showAlertView(title: alertTitle, message: alertMsg, viewController: self)
    }
    
    func activityValidation(title: String)
    {
        if !BL_DCRCalendar.sharedInstance.checkIsFutureDate(date: self.selectedDate)
        {
            if title != DCRActivityName.leave.rawValue
            {
                let seqValidationMsg :  String = BL_DCRCalendar.sharedInstance.getSequentialEntryValidation(startDate : self.currentStartDate, endDate: self.selectedDate, isEditMode: false)
                
                if seqValidationMsg != ""
                {
                    AlertView.showAlertView(title: alertTitle, message: seqValidationMsg, viewController: self)
                    return
                }
            }
            else
            {
                let message = BL_DCRCalendar.sharedInstance.doOfflineDCRCountValidation()
                
                if (message != EMPTY)
                {
                    AlertView.showAlertView(title: alertTitle, message: message, viewController: self)
                    return
                }
            }
        }
        else
        {
            let message = BL_DCRCalendar.sharedInstance.doOfflineDCRCountValidation()
            
            if (message != EMPTY)
            {
                AlertView.showAlertView(title: alertTitle, message: message, viewController: self)
                return
            }
        }
        
        if (BL_DCRCalendar.sharedInstance.dcrEntryTPApprovalNeeded())
        {
            let modelData:[DCRCalendarModel] = BL_DCRCalendar.sharedInstance.dcrLWHAModel
            
            if modelData.count > 0
            {
                if (BL_DCRCalendar.sharedInstance.isApprovedTPAvailableForSelectedDate(selectedDate: selectedDate) || modelData[0].Is_Holiday == 1 || modelData[0].Is_WeekEnd == 1)
                {
                    moveToNexstScreen(title: title)
                }
            }
            else
            {
                moveToNexstScreen(title: title)
            }
        }
            
        else
        {
            moveToNexstScreen(title: title)
        }
        
        let dcrCalendarObj = DBHelper.sharedInstance.getDcrLWHAStatus(dcrDate: self.selectedDate)
        
        if (dcrCalendarObj != nil)
        {
            if (dcrCalendarObj!.count > 0)
            {
                if (dcrCalendarObj![0].Is_LockLeave == 1)
                {
                    AlertView.showAlertView(title: alertTitle, message: "The selected date is locked. You can't enter \(PEV_DCR)", viewController: self)
                    return
                }
            }
        }
    }
    func insertHourlyReportData()
    {
        insertHourlyReportAccompanist()
        insertdoctorvisit()
        insertchemistvisit()
        insertstockiest()
    }
    func insertdoctorvisit()
    {
        
        var list: [DCRAccompanistModel] = []
        var accompanistList: [AccompanistModel] = []
        var doctorvisit: NSArray = []
        let hourlyreportdata1: [HourlyReportModel] = BL_MasterDataDownload.sharedInstance.downloadhourlyreport()!
        if hourlyreportdata1.count > 0
        {
            for data in hourlyreportdata1
            {
                
                let checkDoctorExists = DBHelper.sharedInstance.checkDoctorVisitExists(dcrId: dcrID, customerCode: data.Doctor_Code ?? EMPTY , regionCode: data.Doctor_Region_Code ?? EMPTY)
                
                if data.Customer_Entity_Type == "D"
                {
                    
                    let time = data.Doctor_Visit_Date_Time as! String
                    let visittime = String(time.suffix(8)) as! String
                    var visitMode = "AM"
                    let mode = Int(String(visittime.prefix(2)))!
                    if mode > 11
                    {
                        visitMode = "PM"
                    }
//                    let formatter = DateFormatter()
//                    formatter.dateFormat = "hh:mm a"
//                    let time12 = formatter.stringFromDate(time1)
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let date = dateFormatter.date(from: time)
                    dateFormatter.dateFormat = "hh:mm a"
                    let visitTime1 = dateFormatter.string(from: date!)
                    
                    
                    let dict = ["DCR_Id":String(self.dcrID),"DCR_Code":"","Doctor_Region_Code":data.Doctor_Region_Code ?? EMPTY,"Doctor_Code":data.Doctor_Code,"Doctor_Name":data.Doctor_Name,"Speciality_Name": data.Speciality_Name, "MDL_Number":checkNullAndNilValueForString(stringData:data.MDL_Number), "Hospital_Name":checkNullAndNilValueForString(stringData:data.Hospital_Name),"Category_Code":data.Category_Code,"Category_Name":data.Category_Name,"Visit_Mode":visitMode,"Visit_Time":String(visitTime1.prefix(5)),"POB_Amount": EMPTY, "Lattitude":checkNullAndNilValueForString(stringData:data.Latitude), "Longitude":checkNullAndNilValueForString(stringData:data.Longitude), "Customer_Entity_Type":"D"] as [String : Any]
                    
                    
                   
                    if checkDoctorExists == 0
                    {
                    
                    doctorobj = DCRDoctorVisitModel(dict: dict as NSDictionary)
                    self.Visitid = DBHelper.sharedInstance.insertDCRDoctorVisit(dcrDoctorVisitObj: doctorobj!)
                    
//                    let dcrId = DCRModel.sharedInstance.dcrId
                    
                    
                    if self.dcrVisitidArray.count > 0
                    {
                        for i in self.dcrVisitidArray
                        {
                            if data.Doctor_Region_Code == i
                            {
                                try? dbPool.read { db in
                                    let accompanistData = try DCRAccompanistModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_ACCOMPANIST) WHERE DCR_Id = ? AND Employee_Name != 'VACANT' AND Employee_Name != 'NOT ASSIGNED'  ", arguments: [self.dcrID])
                                    list = accompanistData
                                }
                                
                                
                                for j in list
                                
                                {
                                
                                if list.count > 0
                                {
                                    let dict: NSDictionary = ["DCR_Id": self.dcrID, "Acc_Region_Code": j.Acc_Region_Code, "Acc_User_Code": j.Acc_User_Code , "Acc_User_Name": j.Acc_User_Name, "Acc_User_Type_Name": j.Acc_User_Type_Name, "Employee_Name":j.Employee_Name,"Visit_ID": self.Visitid]
                                    
                                    let dcrAccompanistModelObj: DCRDoctorAccompanist = DCRDoctorAccompanist(dict: dict)
                                    DBHelper.sharedInstance.insertDoctorAccompanist(dcrDoctorAccompanistObj: dcrAccompanistModelObj)
                                    }
                                    
                                    
                                }
                            }
                        }
                    }
                    
                    
                }
                }
                
                // DBHelper.sharedInstance.deleteFromTable(tableName: Hourly_Report_Visit)
            }
        }
    }
    func insertchemistvisit()
    {
        
        var list: [DCRAccompanistModel] = []
        var accompanistList: [AccompanistModel] = []
        var chemistvisit: ChemistDayVisit
        var dcrchemistvisit: DCRChemistVisitModel
        let hourlyreportdata1: [HourlyReportModel] = BL_MasterDataDownload.sharedInstance.downloadhourlyreport()!
        if hourlyreportdata1.count > 0
        {
            for data in hourlyreportdata1
            {
                let checkDoctorExists = DBHelper.sharedInstance.checkDoctorVisitExists(dcrId: dcrID, customerCode: data.Doctor_Code ?? EMPTY , regionCode: data.Doctor_Region_Code ?? EMPTY)
                if data.Customer_Entity_Type == "C"
                {
                    let time = data.Doctor_Visit_Date_Time as! String
                    let visittime = String(time.suffix(8)) as! String
                    var visitMode = "AM"
                    let mode = Int(String(visittime.prefix(2)))!
                    if mode > 11
                    {
                        visitMode = "PM"
                    }
                    
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let date = dateFormatter.date(from: time)
                    dateFormatter.dateFormat = "hh:mm a"
                    let visitTime1 = dateFormatter.string(from: date!)
                    
                    let dict = ["Chemist_Code":data.Doctor_Code,"Chemist_Name":data.Doctor_Name,"Speciality_Name":data.Speciality_Name,"MDL_Number":data.MDL_Number,"Region_Name":data.Doctor_Region_Name,"Region_Code":data.Doctor_Region_Code,"Longitude":data.Longitude,"Lattitude":data.Latitude,"Visit_Mode":visitMode,"Visit_Time":String(visitTime1.prefix(5)),"DCR_Id":self.dcrID,"Customer_Entity_Type":"C","Category_Code":data.Category_Code,"Category_Name":data.Category_Name] as [String : Any]
                   
                    if checkDoctorExists == 0
                    {
                    chemistvisit = ChemistDayVisit(dict: dict as NSDictionary)
                    self.Visitid = DBHelper.sharedInstance.insertchemistvisitdata(dcrChemistVisitObj: chemistvisit)
                    
                    if self.dcrVisitidArray.count > 0
                    {
                        for i in self.dcrVisitidArray
                        {
                            if data.Doctor_Region_Code == i
                            {
                                try? dbPool.read { db in
                                    let accompanistData = try DCRAccompanistModel.fetchAll(db, "SELECT * FROM \(TRAN_DCR_ACCOMPANIST) WHERE DCR_Id = ? AND Employee_Name != 'VACANT' AND Employee_Name != 'NOT ASSIGNED' ", arguments: [self.dcrID])
                                    list = accompanistData
                                }
                               
                                
                                for k in list
                                
                                {
                                
                                if list.count > 0
                                {
                                    let dict: NSDictionary = ["DCR_Id": self.dcrID, "Acc_Region_Code": k.Acc_Region_Code, "Acc_User_Code": k.Acc_User_Code , "Acc_User_Name": k.Acc_User_Name, "Acc_User_Type_Name": k.Acc_User_Type_Name, "Employee_Name": k.Employee_Name,"DCR_Chemist_Day_Visit_Id": self.Visitid]
                                    
                                    let dcrAccompanistModelObj: DCRChemistAccompanist = DCRChemistAccompanist(dict: dict)
                                    DBHelper.sharedInstance.insertChemistAccompanist(dcrChemistAccompanistObj: dcrAccompanistModelObj)
                                }
                                    
                                }
                            }
                        }
                    
                        }
                        
                        }
                }
            }
            // DBHelper.sharedInstance.deleteFromTable(tableName: Hourly_Report_Visit)
        }
    }
    func insertstockiest()
    {
        var stockiestvisit: DCRStockistVisitModel
        let hourlyreportdata1: [HourlyReportModel] = BL_MasterDataDownload.sharedInstance.downloadhourlyreport()!
        if hourlyreportdata1.count > 0
        {
            for data in hourlyreportdata1
            {
                
                let checkDoctorExists = DBHelper.sharedInstance.checkDoctorVisitExists(dcrId: dcrID, customerCode: data.Doctor_Code ?? EMPTY , regionCode: data.Doctor_Region_Code ?? EMPTY)
                
                if data.Customer_Entity_Type == "S"
                {
                    let time = data.Doctor_Visit_Date_Time as! String
                    let visittime = String(time.suffix(8)) as! String
                    var visitMode = "AM"
                    let mode = Int(String(visittime.prefix(2)))!
                    if mode > 11
                    {
                        visitMode = "PM"
                    }
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let date = dateFormatter.date(from: time)
                    dateFormatter.dateFormat = "hh:mm a"
                    let visitTime1 = dateFormatter.string(from: date!)
                    
                    let dict = ["Stockiest_Code":data.Doctor_Code,"Stockiest_Name":data.Doctor_Name,"Longitude":data.Longitude,"Lattitude":data.Latitude,"Visit_Mode":visitMode,"Visit_Time":String(visitTime1.prefix(5)),"DCR_Id":self.dcrID,"Customer_Entity_Type":"S"] as [String : Any]
                    
                    if checkDoctorExists == 0
                    {
                    stockiestvisit = DCRStockistVisitModel(dict: dict as NSDictionary)
                    DBHelper.sharedInstance.insertDcrStockiestsVisit(dcrStockiestVisitObj: stockiestvisit)
                }
                
            }
            }
        }
    }
    func insertHourlyReportAccompanist()
    {
        getUniqueHourlyReportCustomerRegionCodes()
    }
    
    func getUniqueHourlyReportCustomerRegionCodes()
    {
        var DCRacompanist: [DCRAccompanistModel] = []
        var Stringlist: [String] = []
        var accompanistList: [AccompanistModel] = []
        let hourlyreportdata1: [HourlyReportModel] = BL_MasterDataDownload.sharedInstance.downloadhourlyreport()!
        if hourlyreportdata1.count > 0
        {
            for data in hourlyreportdata1
            {
                Stringlist.append(data.Doctor_Region_Code!)
            }
        }
        let unique = Array(Set(Stringlist))
        self.dcrVisitidArray = unique
        if unique.count > 0
        {
            for i in unique
            {
                try? dbPool.read { db in
                    let accompanistData = try AccompanistModel.fetchAll(db, "SELECT * FROM \(MST_ACCOMPANIST) WHERE Region_Code = ? ", arguments: [i])
                    accompanistList = accompanistData
                }
                if accompanistList.count > 0
                {
                    for j in accompanistList
                    {
                    let dict: NSDictionary = ["DCR_Id": self.dcrID, "Acc_Region_Code": j.Region_Code, "Acc_User_Code":j.User_Code , "Acc_User_Name": j.User_Name, "Acc_User_Type_Name": j.User_Type_Name, "Employee_Name":j.Employee_name]
                    
                    let dcrAccompanistModelObj: DCRAccompanistModel = DCRAccompanistModel(dict: dict)
                    DBHelper.sharedInstance.insertDCRAccompanist(dcrAccompanistModelObj: dcrAccompanistModelObj)
                    }
                }
            }
        }
    }
    func editaction()
    {
    let userStartDate : Date = getUserStartDate()
           
           if userStartDate.compare(selectedDate) == .orderedDescending
           {
               AlertView.showAlertView(title: alertTitle, message: addDCRErrorMsg, viewController: self)
           }
           else
           {
               if BL_DCRCalendar.sharedInstance.activityRestrictionValidation(dcrDate: selectedDate)
               {
                   showActivityRestrictionAlert()
               }
               else
               {
                   let detailModel = dcrDetailList[0]
                   
                   if !BL_DCRCalendar.sharedInstance.checkIsFutureDate(date: self.selectedDate)
                   {
                       if detailModel.dcrFlag != DCRFlag.leave.rawValue
                       {
                           let seqValidationMsg :  String = BL_DCRCalendar.sharedInstance.getSequentialEntryValidation(startDate : self.currentStartDate, endDate: self.selectedDate, isEditMode: true)
                           
                           if seqValidationMsg != ""
                           {
                               AlertView.showAlertView(title: alertTitle, message: seqValidationMsg, viewController: self)
                               return
                           }
                       }
                   }
                   
                   DCRModel.sharedInstance.dcrId = detailModel.dcrId
                   DCRModel.sharedInstance.dcrDate = selectedDate
                   DCRModel.sharedInstance.dcrDateString = convertDateIntoServerStringFormat(date: selectedDate)
                   DCRModel.sharedInstance.dcrFlag = detailModel.dcrFlag
                   DCRModel.sharedInstance.dcrStatus = detailModel.dcrStatus
                   DCRModel.sharedInstance.dcrCode = detailModel.dcrCode!
                   
                   if detailModel.dcrFlag == DCRFlag.fieldRcpa.rawValue
                   {
                       
                       DCRModel.sharedInstance.expenseEntityCode = detailModel.categoryCode
                       DCRModel.sharedInstance.expenseEntityName = detailModel.categoryName
                       BL_Stepper.sharedInstance.getAccompanistDataPendingList()
                       BL_DCRCalendar.sharedInstance.prefillDoctorsForDCRDate(selectedDate: selectedDate, dcrId: detailModel.dcrId)
                       self.navigateToNextScreen(storyBoard:dcrStepperSb , viewControllerId: "DCRStepperNew")
                       
                   }
                   else if detailModel.dcrFlag == DCRFlag.attendance.rawValue
                   {
                       DCRModel.sharedInstance.expenseEntityCode = detailModel.categoryCode
                       DCRModel.sharedInstance.expenseEntityName = detailModel.categoryName
                       self.navigateToNextScreen(storyBoard: attendanceStepperSb, viewControllerId: "DCRAttendancenew")
                   }
                   else if detailModel.dcrFlag == DCRFlag.leave.rawValue
                   {
                       navigateToNextScreen(storyBoard: leaveEntrySb, viewControllerId: "DCRLeaveEntryNew")
                   }
                   removeVersionToastView()
               }
           }
}
    @IBAction func editBtnAction(_ sender: AnyObject)
    {
        let userStartDate : Date = getUserStartDate()
        
        if userStartDate.compare(selectedDate) == .orderedDescending
        {
            AlertView.showAlertView(title: alertTitle, message: addDCRErrorMsg, viewController: self)
        }
        else
        {
            if BL_DCRCalendar.sharedInstance.activityRestrictionValidation(dcrDate: selectedDate)
            {
                showActivityRestrictionAlert()
            }
            else
            {
                let detailModel = dcrDetailList[sender.tag]
                
                if !BL_DCRCalendar.sharedInstance.checkIsFutureDate(date: self.selectedDate)
                {
                    if detailModel.dcrFlag != DCRFlag.leave.rawValue
                    {
                        let seqValidationMsg :  String = BL_DCRCalendar.sharedInstance.getSequentialEntryValidation(startDate : self.currentStartDate, endDate: self.selectedDate, isEditMode: true)
                        
                        if seqValidationMsg != ""
                        {
                            AlertView.showAlertView(title: alertTitle, message: seqValidationMsg, viewController: self)
                            return
                        }
                    }
                }
                
                DCRModel.sharedInstance.dcrId = detailModel.dcrId
                DCRModel.sharedInstance.dcrDate = selectedDate
                DCRModel.sharedInstance.dcrDateString = convertDateIntoServerStringFormat(date: selectedDate)
                DCRModel.sharedInstance.dcrFlag = detailModel.dcrFlag
                DCRModel.sharedInstance.dcrStatus = detailModel.dcrStatus
                DCRModel.sharedInstance.dcrCode = detailModel.dcrCode!
                
                if detailModel.dcrFlag == DCRFlag.fieldRcpa.rawValue
                {
                    
                    DCRModel.sharedInstance.expenseEntityCode = detailModel.categoryCode
                    DCRModel.sharedInstance.expenseEntityName = detailModel.categoryName
                    BL_Stepper.sharedInstance.getAccompanistDataPendingList()
                    BL_DCRCalendar.sharedInstance.prefillDoctorsForDCRDate(selectedDate: selectedDate, dcrId: detailModel.dcrId)
                    self.navigateToNextScreen(storyBoard:dcrStepperSb , viewControllerId: "DCRStepperNew")
                    
                }
                else if detailModel.dcrFlag == DCRFlag.attendance.rawValue
                {
                    DCRModel.sharedInstance.expenseEntityCode = detailModel.categoryCode
                    DCRModel.sharedInstance.expenseEntityName = detailModel.categoryName
                    self.navigateToNextScreen(storyBoard: attendanceStepperSb, viewControllerId: "DCRAttendancenew")
                }
                else if detailModel.dcrFlag == DCRFlag.leave.rawValue
                {
                    navigateToNextScreen(storyBoard: leaveEntrySb, viewControllerId: "DCRLeaveEntryNew")
                }
                removeVersionToastView()
            }
        }
    }
    
    func navigateToNextScreen(storyBoard:String, viewControllerId:String)
    {
        let sb = UIStoryboard(name: storyBoard, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: viewControllerId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func isCurrentDate() -> Bool
    {
        let dcrDate = DCRModel.sharedInstance.dcrDateString
        let currentDate = getCurrentDate()
        
        if (dcrDate == currentDate)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func moveToNexstScreen(title: String)
    {
        if title == DCRActivityName.fieldRcpa.rawValue || title == "Field_RCPA"
        {
            BL_DCRCalendar.sharedInstance.insertInitialDCR(flag: DCRActivity.fieldRcpa.rawValue, selectedDate: self.selectedDate)
            BL_Stepper.sharedInstance.getAccompanistDataPendingList()
            if  BL_DCR_Doctor_Visit.sharedInstance.isGeoLocationMandatory() && BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled() && isCurrentDate() && !BL_MenuAccess.sharedInstance.is_Punch_In_Out_Enabled()
            {
                self.dcrID = DCRModel.sharedInstance.dcrId
                insertHourlyReportData()
                //self.navigateToNextScreen(storyBoard: dcrStepperSb, viewControllerId: dcrStepperVcID)
            }
            self.navigateToNextScreen(storyBoard: dcrStepperSb, viewControllerId: "DCRStepperNew")
        }
            if title == DCRActivityName.prospect.rawValue || title == "Prospect"
            {
                BL_DCRCalendar.sharedInstance.insertInitialDCR(flag: DCRActivity.fieldRcpa.rawValue, selectedDate: self.selectedDate)
                BL_Stepper.sharedInstance.getAccompanistDataPendingList()
                if  BL_DCR_Doctor_Visit.sharedInstance.isGeoLocationMandatory() && BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled() && isCurrentDate() && !BL_MenuAccess.sharedInstance.is_Punch_In_Out_Enabled()
                {
                    self.dcrID = DCRModel.sharedInstance.dcrId
                    insertHourlyReportData()
                    //self.navigateToNextScreen(storyBoard: dcrStepperSb, viewControllerId: dcrStepperVcID)
                }
                let sb = UIStoryboard(name: dcrStepperSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "DCRStepperNew") as! DCRStepperNewViewController
                vc.isProspect = true
                self.navigationController?.pushViewController(vc, animated: true)
                //self.navigateToNextScreen(storyBoard: dcrStepperSb, viewControllerId: "DCRStepperNew")
            }
        else if title == DCRActivityName.attendance.rawValue
        {
            BL_DCRCalendar.sharedInstance.insertInitialDCR(flag: DCRActivity.attendance.rawValue, selectedDate: self.selectedDate)
            
            self.navigateToNextScreen(storyBoard: attendanceStepperSb, viewControllerId: "DCRAttendancenew")
        }
        else if title == DCRActivityName.leave.rawValue
        {
            if(checkInternetConnectivity())
            {
                BL_DCRCalendar.sharedInstance.insertLeaveTPDetails(selectedDate: self.selectedDate)
                //            self.navigateToNextScreen(storyBoard: leaveEntrySb, viewControllerId: LeaveEntryVcID)
                let sb = UIStoryboard(name: leaveEntrySb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "DCRLeaveEntryNew") as! LeaveEntryNewViewController
//                vc.isInsertedFromTP = true
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                AlertView.showAlertView(title: internetOfflineMessage, message: internetOfflineMessage, viewController: self)
            }
        }
        
        removeVersionToastView()
    }
    
    @IBAction func moreAction(_ sender: AnyObject)
    {
        removeVersionToastView()
        
        self.showAlertForMore()
    }
    
    func showTPCallbackAlert(activityTitle: String, message: String)
    {
        let alertViewController = UIAlertController(title: alertTitle, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertViewController.addAction(UIAlertAction(title: ok, style: UIAlertActionStyle.cancel, handler: { (alert: UIAlertAction) -> Void in
            self.activityValidation(title: activityTitle)
        }))
        
        self.present(alertViewController, animated: false, completion: nil)
    }
    
    func showTPDownloadAlert(title: String, showSkip: Bool)
    {
        let tpDownloadDesc = "You have not downloaded \(PEV_TP) for \(convertDateIntoString(date: selectedDate)). Do you want to download now?"
        var monthString : String = ""
        
        if let splittedMonthString : [String] = monthLabel.text?.components(separatedBy: " ")
        {
            if splittedMonthString.count > 0
            {
                monthString = splittedMonthString[0]
            }
        }
        
        let tpDownloadMonthMsg = "Download \(PEV_TP) for \(monthString) month"
        let tpDownloadDateMsg = "Download \(PEV_TP) only for \(convertDateIntoString(date: selectedDate))"
        let alertViewController = UIAlertController(title: alertTitle, message: tpDownloadDesc, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: tpDownloadMonthMsg, style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction) -> Void in
            self.getTPServiceCall(title: title, isMonth: true)
        }))
        
        alertViewController.addAction(UIAlertAction(title: tpDownloadDateMsg, style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction) -> Void in
            self.getTPServiceCall(title: title, isMonth: false)
        }))
        
        if (showSkip )
        {
            alertViewController.addAction(UIAlertAction(title: skip, style: UIAlertActionStyle.cancel, handler: { (alert: UIAlertAction) -> Void in
                self.activityValidation(title: title)
            }))
        }
        
        self.present(alertViewController, animated: false, completion: nil)
    }
    
    func getTPServiceCall(title: String, isMonth: Bool)
    {
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: "Downloading \(PEV_TP) data...")
            
            if isMonth
            {
                BL_DCRCalendar.sharedInstance.downloadTpDataForMonth(startDate: self.currentStartDate, endDate: self.currentEndDate) { (responseMsg) in
                    
                    removeCustomActivityView()
                    self.showTPCallbackAlert(activityTitle: title, message: responseMsg)
                }
            }
            else
            {
                BL_DCRCalendar.sharedInstance.downloadTpDataForDate(selectedDate: self.selectedDate) { (responseMsg) in
                    
                    removeCustomActivityView()
                    self.showTPCallbackAlert(activityTitle: title, message: responseMsg)
                }
            }
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    
    func showAlertForMore()
    {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Today", style: UIAlertActionStyle.default, handler: { alertAction in
            self.alertTodayAction()
            showVersionToastView(textColor: UIColor.darkGray)
        }))
        
        alert.addAction(UIAlertAction(title: "\(PEV_DCR) Refresh", style: UIAlertActionStyle.default, handler:{  alertAction in
            self.alertDCRRefreshAction()
        }))
        
        alert.addAction(UIAlertAction(title: "\(PEV_TP) Freeze & Lock Release", style: UIAlertActionStyle.default, handler:{  alertAction in
            self.lockReleaseAction()
        }))
        
        alert.addAction(UIAlertAction(title: "UnApproved \(PEV_DCR)", style: UIAlertActionStyle.default, handler:{  alertAction in
            self.unApprovedDCRRefreshAction()
        }))
        
        alert.addAction(UIAlertAction(title: "Delete \(PEV_DCR)", style: UIAlertActionStyle.default, handler:{  alertAction in
            self.navigateToDeleteDCRPage()
        }))
        
        
        
        //        if (BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled())
        //        {
        //            alert.addAction(UIAlertAction(title: "Send live tracker report", style: UIAlertActionStyle.default, handler:{  alertAction in
        //                self.sendHourlyReport()
        //                showVersionToastView(textColor: UIColor.darkGray)
        //            }))
        //        }
        
        if (BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled())
        {
            alert.addAction(UIAlertAction(title: "Get Hourly Report Customers", style: UIAlertActionStyle.default, handler:{  alertAction in
                self.gethourlyreportcustomer()
                showVersionToastView(textColor: UIColor.darkGray)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Know your calendar", style: UIAlertActionStyle.default, handler:{  alertAction in
            self.alertKnwYourCalendarAction()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:{  alertAction in
            alert .dismiss(animated: true, completion: nil)
        }))
        
        if SwifterSwift().isPhone
        {
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            if let currentPopoverpresentioncontroller = alert.popoverPresentationController{
                currentPopoverpresentioncontroller.sourceView = self.view
                currentPopoverpresentioncontroller.sourceRect = CGRect(x:self.view.frame.size.width-50,y:0, width:100,height:100)
                currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.up
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    func gethourlyreportcustomer()
    {
        let alert = UIAlertController(title: "Alert", message: "Do you want to download Hourly report Customer's", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:{  alertAction in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{  alertAction in
            self.gethourlycustomerAPI()
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func gethourlycustomerAPI()
    {
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: "Loading...")
            WebServiceHelper.sharedInstance.gethourlyReportCustomer( completion: { (apiObj) in
                if apiObj.Status == SERVER_SUCCESS_CODE
                {
                    // api response insert into 3 tables
                    DBHelper.sharedInstance.deleteFromTable(tableName: Hourly_Report_Visit)
                    let array = apiObj.list as NSArray
                    if apiObj.Count > 0
                    {
                        DBHelper.sharedInstance.insertHourlyReport(array: array)
                    }
                    removeCustomActivityView()
                    showToastViewWithShortTime(toastText: "Hourly Report Customers Downloaded Succesfully")
                    self.hourlyreportdata = BL_MasterDataDownload.sharedInstance.downloadhourlyreport()!
                    let data = self.hourlyreportdata
                }
                else
                {
                    AlertView.showAlertView(title: errorTitle, message: "Problem While connecting server", viewController: self)
                }
            })
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    
    func lockReleaseAction()
    {
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: "Loading...")
            BL_DCR_Refresh.sharedInstance.getDCRLockLeaves() { (status) in
                if status == SERVER_SUCCESS_CODE
                {
                    BL_DCR_Refresh.sharedInstance.getTPUnfreezeDate(refreshMode: DCRRefreshMode(rawValue: DCRRefreshMode.EMPTY.rawValue)!, endDate: EMPTY, completion: { (status) in
                        if status == SERVER_SUCCESS_CODE
                        {
                            self.setDefaults()
                            BL_DCRCalendar.sharedInstance.getCalendarModel()
                            self.loadDCRDetails(viewHeight: self.view.frame.size.height - 64.0)
                            removeCustomActivityView()
                        }
                        else
                        {
                            AlertView.showAlertView(title: errorTitle, message: "Problem While connecting server", viewController: self)
                        }
                    })
                }
            }
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    
    func unApprovedDCRRefreshAction()
    {
        navigateToDCRefresh(refreshMode: DCRRefreshMode.MERGE_LOCAL_AND_SERVER_DATA)
    }
    
    func alertTodayAction()
    {
        moveToMonthSegment(date: middleDate)
        selectedDate = getServerFormattedDate(date: getCurrentDateAndTime())
        
        loadDCRDetails(viewHeight: self.view.frame.size.height - 64.0)
    }
    
    func alertDCRRefreshAction()
    {
        if checkInternetConnectivity()
        {
            if BL_DCR_Refresh.sharedInstance.isAnyPendingDCRToUpload() || BL_DCR_Refresh.sharedInstance.isDraftDcrAvailable()
            {
                showDCRRefreshPopup()
            }
            else
            {
                navigateToDCRefresh(refreshMode: DCRRefreshMode.MERGE_LOCAL_AND_SERVER_DATA)
            }
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    
    func alertKnwYourCalendarAction()
    {
        let sb = UIStoryboard(name:DCRCalenderSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: KYCalendarVcID)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToDeleteDCRPage()
    {
        let sb = UIStoryboard(name:DCRCalenderSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.DeleteDCRVcID)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.hidebtnHeightConst.constant = self.view.frame.size.height
    }
    
    func getAddbtnVisiblity()
    {
        if BL_DCRCalendar.sharedInstance.isAddBtnHidden(date: selectedDate)
        {
            addBtn.isHidden = true
        } else
        {
            addBtn.isHidden = false
        }
    }
    
    @IBAction func backBtnAction(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func doneClicked()
    {
        if selectedRow == 0
        {
            moveToMonthSegment(date: startDate)
        } else if selectedRow == 1
        {
            moveToMonthSegment(date: middleDate)
        } else if selectedRow == 2
        {
            moveToMonthSegment(date: endDate)
        }
        
        self.hidebtnHeightConst.constant = 0
        pickerTextfield.resignFirstResponder()
    }
    
    func loadDCRDetails(viewHeight: CGFloat)
    {
        var holidayName: String = ""
        if BL_DCRCalendar.sharedInstance.isLockDCR(date: selectedDate)
        {
            holidayLabel.text = ""
        }
        else
        {
            let modelData:[DCRCalendarModel] = BL_DCRCalendar.sharedInstance.dcrLWHAModel
            if modelData.count > 0
            {
                if modelData[0].Is_Holiday == 1
                {
                    holidayName = "Holiday - \(BL_DCRCalendar.sharedInstance.getHolidayName(dcrDate: selectedDate))"
                }
            }
            holidayLabel.text = holidayName
        }
        
        //getAddbtnVisiblity()
        //unApprovedEditHidden = BL_DCRCalendar.sharedInstance.isUnapprovedEditBtnHidden(dcrDate: selectedDate)
        headerLabel.text = BL_DCRCalendar.sharedInstance.convertDateIntoDCRDisplayformat(date: selectedDate)
        
        if holidayLabel.text != ""
        {
            tableViewHeight = viewHeight - 306.0 - 16.0
        }
        else
        {
            tableViewHeight = viewHeight - 306.0
        }
        
        dcrDetailList = BL_DCRCalendar.sharedInstance.getDCRDetails(date: selectedDate)!
        
        if rowHeightArr.count > 0
        {
            rowHeightArr.removeAllObjects()
        }
        
        for _ in dcrDetailList
        {
            rowHeightArr.add(defaultRowHeight)
        }
        
        if dcrDetailList.count == 0
        {
            tableView.isHidden = true
            currentConstraintHeight = viewHeight
            contentViewHeightConst.constant = viewHeight
        }
        else
        {
            var dcrNewStatus : Int = 0
            
            for model in dcrDetailList
            {
                if model.dcrStatus == -1
                {
                    dcrNewStatus = dcrNewStatus + 1
                }
            }
            
            if (dcrDetailList.count == 1 && dcrNewStatus == 1) || (dcrDetailList.count == 2 && dcrNewStatus == 2)
            {
                tableView.isHidden = true
            }
            else
            {
                tableView.isHidden = false
                var variableHeight : CGFloat = CGFloat(dcrDetailList.count) * defaultRowHeight
                
                if variableHeight > tableViewHeight
                {
                    variableHeight = variableHeight - tableViewHeight + 50
                    currentConstraintHeight = viewHeight + variableHeight
                    contentViewHeightConst.constant = currentConstraintHeight
                }
                else
                {
                    currentConstraintHeight = viewHeight
                    contentViewHeightConst.constant = currentConstraintHeight
                }
            }
        }
        calendarView.reloadData()
        tableView.reloadData()
    }
    
    @IBAction func showDetailAction(_ sender: AnyObject)
    {
        editaction()
        let detailModel = dcrDetailList[sender.tag]
        let rowHeight = rowHeightArr.object(at: sender.tag) as! CGFloat
        var unapprovedText = "No Remarks"
        if detailModel.unapprovedBy != ""
        {
            unapprovedText = BL_DCRCalendar.sharedInstance.getUnapprovedTextformat(text: detailModel.unapprovedBy)
        }
        
        if detailModel.dcrFlag == DCRFlag.fieldRcpa.rawValue
        {
            let unApprovedTextHeight = getTextSize(text: unapprovedText, fontName: fontRegular, fontSize: 13.0, constrainedWidth: unApprovedTextConstWidth)
            rcpaUnapprovedHeight = unApprovedTextHeight.height + 50.0
            
            getRCPACellHeight(doctorVisitCount: detailModel.doctorVisitCount!, doctorPendingCount: detailModel.doctorPendingVisitCount!)
            
            if rowHeight == defaultRowHeight
            {
                if detailModel.dcrStatus == DCRStatus.applied.rawValue
                {
                    rowHeightArr.replaceObject(at: sender.tag, with: (rcpaCellHeight + defaultRowHeight) - rowEditBtnHeight)
                }
                else if detailModel.dcrStatus == DCRStatus.unApproved.rawValue
                {
                    BL_DCRCalendar.sharedInstance.isUnapprovedEditBtnHidden(dcrDate: selectedDate, isAttendanceLock: false, isLockLeave: false)
                    //                    if unApprovedEditHidden == true
                    //                    {
                    //                        rowHeightArr.replaceObject(at: sender.tag, with: (rcpaCellHeight + defaultRowHeight + rcpaUnapprovedHeight) - rowEditBtnHeight)
                    //                    }
                    if BL_DCRCalendar.sharedInstance.isUnapprovedEditBtnHidden(dcrDate: selectedDate, isAttendanceLock: false, isLockLeave: false)
                    {
                        rowHeightArr.replaceObject(at: sender.tag, with: (rcpaCellHeight + defaultRowHeight + rcpaUnapprovedHeight) - rowEditBtnHeight)
                    }
                    else
                    {
                        rowHeightArr.replaceObject(at: sender.tag, with: rcpaCellHeight + defaultRowHeight + rcpaUnapprovedHeight)
                    }
                }
                else
                {
                    rowHeightArr.replaceObject(at: sender.tag, with: rcpaCellHeight + defaultRowHeight)
                }
                tableView.reloadData()
                
                if tableViewHeight > tableView.contentSize.height
                {
                    variablercpaCellHeight = 80
                }
                else
                {
                    if detailModel.dcrStatus == DCRStatus.unApproved.rawValue
                    {
                        variablercpaCellHeight = rcpaCellHeight + rcpaUnapprovedHeight
                    }
                    else
                    {
                        variablercpaCellHeight = rcpaCellHeight
                    }
                }
                currentConstraintHeight = currentConstraintHeight + variablercpaCellHeight // 0
                contentViewHeightConst.constant = currentConstraintHeight
                
                //scrollToBottom()
            }
            else
            {
                rowHeightArr.replaceObject(at: sender.tag, with: defaultRowHeight)
                tableView.reloadData()
                currentConstraintHeight = currentConstraintHeight - variablercpaCellHeight
                contentViewHeightConst.constant = currentConstraintHeight
                //scrollToTop()
            }
            
        }
        else if detailModel.dcrFlag == DCRFlag.attendance.rawValue
        {
            let unApprovedTextHeight = getTextSize(text: unapprovedText, fontName: fontRegular, fontSize: 13.0, constrainedWidth: unApprovedTextConstWidth)
            attendanceUnapprovedHeight = unApprovedTextHeight.height + 50.0
            
            if rowHeight == defaultRowHeight
            {
                if detailModel.dcrStatus == DCRStatus.applied.rawValue
                {
                    rowHeightArr.replaceObject(at: sender.tag, with: (attendanceCellHeight + defaultRowHeight) - rowEditBtnHeight)
                }
                else if detailModel.dcrStatus == DCRStatus.unApproved.rawValue
                {
                    if BL_DCRCalendar.sharedInstance.isUnapprovedEditBtnHidden(dcrDate: selectedDate, isAttendanceLock: true, isLockLeave: false) == true
                    {
                        rowHeightArr.replaceObject(at: sender.tag, with: (attendanceCellHeight + defaultRowHeight + attendanceUnapprovedHeight) - rowEditBtnHeight)
                    }
                    else
                    {
                        rowHeightArr.replaceObject(at: sender.tag, with: attendanceCellHeight + defaultRowHeight + attendanceUnapprovedHeight)
                    }
                }
                else
                {
                    rowHeightArr.replaceObject(at: sender.tag, with: attendanceCellHeight + defaultRowHeight)
                }
                tableView.reloadData()
                
                if tableViewHeight > tableView.contentSize.height
                {
                    variableAttendanceCellHeight = 0
                }
                else
                {
                    if detailModel.dcrStatus == DCRStatus.unApproved.rawValue
                    {
                        variableAttendanceCellHeight = attendanceCellHeight + attendanceUnapprovedHeight
                    }
                    else
                    {
                        variableAttendanceCellHeight = attendanceCellHeight
                    }
                }
                
                currentConstraintHeight = currentConstraintHeight + variableAttendanceCellHeight
                contentViewHeightConst.constant = currentConstraintHeight + 80
                //scrollToBottom()
            }
            else
            {
                rowHeightArr.replaceObject(at: sender.tag, with: defaultRowHeight)
                tableView.reloadData()
                currentConstraintHeight = currentConstraintHeight - variableAttendanceCellHeight
                contentViewHeightConst.constant = currentConstraintHeight
                //scrollToTop()
            }
        }
        else if detailModel.dcrFlag == DCRFlag.leave.rawValue
        {
            let unApprovedTextHeight = getTextSize(text: unapprovedText, fontName: fontRegular, fontSize: 13.0, constrainedWidth: unApprovedTextConstWidth)
            
            leaveUnapprovedHeight = unApprovedTextHeight.height + 50.0
            
            if rowHeight == defaultRowHeight
            {
                if detailModel.dcrStatus == DCRStatus.applied.rawValue
                {
                    rowHeightArr.replaceObject(at: sender.tag, with: (leaveCellHeight + defaultRowHeight) - rowEditBtnHeight)
                }
                else if detailModel.dcrStatus == DCRStatus.unApproved.rawValue
                {
                    if BL_DCRCalendar.sharedInstance.getPayrollIntegratedVal() == ConfigValues.YES.rawValue
                    {
                        rowHeightArr.replaceObject(at: sender.tag, with: (leaveCellHeight + defaultRowHeight + leaveUnapprovedHeight) - rowEditBtnHeight)
                    }
                    else
                    {
                        //if unApprovedEditHidden == true
                        if BL_DCRCalendar.sharedInstance.isUnapprovedEditBtnHidden(dcrDate: selectedDate, isAttendanceLock: false, isLockLeave: false)
                        {
                            rowHeightArr.replaceObject(at: sender.tag, with: (leaveCellHeight + defaultRowHeight + leaveUnapprovedHeight) - rowEditBtnHeight)
                        }
                        else
                        {
                            rowHeightArr.replaceObject(at: sender.tag, with: leaveCellHeight + defaultRowHeight + leaveUnapprovedHeight)
                        }
                    }
                }
                else
                {
                    rowHeightArr.replaceObject(at: sender.tag, with: leaveCellHeight + defaultRowHeight)
                }
                
                tableView.reloadData()
                if tableViewHeight > tableView.contentSize.height
                {
                    variableLeaveCellHeight = 0
                }
                else
                {
                    if detailModel.dcrStatus == DCRStatus.unApproved.rawValue
                    {
                        variableLeaveCellHeight = leaveCellHeight + leaveUnapprovedHeight
                    }
                    else
                    {
                        variableLeaveCellHeight = leaveCellHeight
                    }
                }
                
                currentConstraintHeight = currentConstraintHeight + variableLeaveCellHeight
                contentViewHeightConst.constant = currentConstraintHeight
                //scrollToBottom()
            }
            else
            {
                rowHeightArr.replaceObject(at: sender.tag, with: defaultRowHeight)
                tableView.reloadData()
                currentConstraintHeight = currentConstraintHeight - variableLeaveCellHeight
                contentViewHeightConst.constant = currentConstraintHeight
                //scrollToTop()
            }
        }
        
        let height = rowHeightArr.object(at: sender.tag) as! CGFloat
        
        if (detailModel.dcrStatus != DCRStatus.unApproved.rawValue)
        {
            if (detailModel.isLocked == 1)
            {
                rowHeightArr.replaceObject(at: sender.tag, with: height - rowEditBtnHeight)
            }
        }
    }
    
    func getRCPACellHeight(doctorVisitCount: Int, doctorPendingCount: Int)
    {
        let doctorVisitText = "\(doctorVisitCountText) \(doctorVisitCount)"
        let doctorPendingText = "\(doctorPendingCountText) \(doctorPendingCount)"
        let doctorVisitHeight = getTextSize(text: doctorVisitText, fontName: fontRegular, fontSize: 14.0, constrainedWidth: SCREEN_WIDTH - 60.0).height
        let doctorPendingHeight = getTextSize(text: doctorPendingText, fontName: fontRegular, fontSize: 14.0, constrainedWidth: SCREEN_WIDTH - 60.0).height
        rcpaCellHeight = 267.0 + doctorVisitHeight + doctorPendingHeight
        rcpaCellHeight = 100
    }
    
    func moveToMonthSegment(date: Date)
    {
        self.calendarView.scrollToDate(date, animateScroll: false) {
            self.calendarView.visibleDates({ (visibleDates: DateSegmentInfo) in
                self.setupViewsOfCalendar(from: visibleDates)
            })
        }
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo)
    {
        currentStartDate = getServerFormattedDate(date: visibleDates.monthDates.first!.date)
        currentEndDate = getServerFormattedDate(date: visibleDates.monthDates.last!.date)
        
        if currentStartDate == startDate
        {
            pickerView.selectRow(0, inComponent: 0, animated: false)
        }
        else if currentStartDate == middleDate
        {
            pickerView.selectRow(1, inComponent: 0, animated: false)
        }
        else if currentStartDate == endDate
        {
            pickerView.selectRow(2, inComponent: 0, animated: false)
        }
        
        guard let startDate = visibleDates.monthDates.first else {
            return
        }
        let month = currentCalendar.dateComponents([.month], from: startDate.date).month!
        let monthName = DateFormatter().shortMonthSymbols[(month-1) % 12]
        let year = currentCalendar.component(.year, from: startDate.date)
        monthLabel.text = monthName + " " + String(year)
    }
    
    // JTAppleCalendarView Delegates
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters
    {
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: numberOfRowsCalendar,
                                                 calendar: currentCalendar,
                                                 generateInDates: generateInDates,
                                                 generateOutDates: generateOutDates,
                                                 firstDayOfWeek: firstDayOfWeek)
        return parameters
    }
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        // (cell as? DCRCalendarCellView)?.setupCellBeforeDisplay(cellState, date: date)
    }
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "cell", for: indexPath) as! DCRCalendarCellView
        (cell as DCRCalendarCellView).setupCellBeforeDisplay(cellState, date: date)
        return cell
    }
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleCell, date: Date, cellState: CellState)
    {
        (cell as? DCRCalendarCellView)?.setupCellBeforeDisplay(cellState, date: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo)
    {
        self.setupViewsOfCalendar(from: visibleDates)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState)
    {
        (cell as? DCRCalendarCellView)?.cellSelectionChanged(cellState, date: date)
        selectedDate = getServerFormattedDate(date: date)
        
        loadDCRDetails(viewHeight: self.view.frame.size.height - 64.0)
        dcrDetailList = BL_DCRCalendar.sharedInstance.getDCRDetails(date: selectedDate)!
        if (dcrDetailList.count == 0)
        {
            addaction()
            self.showPlanningPopup(selectedDate: getStringFromDate(date: selectedDate) )
        }
        else if (dcrDetailList.count > 0 && dcrDetailList[0].dcrStatus != 3 && dcrDetailList[0].dcrStatus != 2 && dcrDetailList[0].dcrStatus != 1 && dcrDetailList[0].dcrStatus != 0)
        {
            addaction()
            self.showPlanningPopup(selectedDate: getStringFromDate(date: selectedDate) )
        }
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        (cell as? DCRCalendarCellView)?.cellSelectionChanged(cellState, date: date)
    }
    
    // Tableview Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dcrDetailList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var heightVal : CGFloat = 0.0
        
        let dcrStatus = dcrDetailList[indexPath.row].dcrStatus
        if dcrStatus == -1
        {
            heightVal = 0
        } else
        {
            heightVal = self.rowHeightArr[indexPath.row] as! CGFloat
        }
        
        return heightVal
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var outputCell: UITableViewCell = UITableViewCell()
        
        let detailModel = dcrDetailList[indexPath.row]
        
        if detailModel.dcrFlag == DCRFlag.fieldRcpa.rawValue
        {
            getRCPACellHeight(doctorVisitCount: detailModel.doctorVisitCount!, doctorPendingCount: detailModel.doctorPendingVisitCount!)
            
            let cell:FieldRCPACell = tableView.dequeueReusableCell(withIdentifier: rcpaCellIdentifier) as! FieldRCPACell
            cell.dcrLabel.text = fieldRcpa

            if detailModel.dcrStatus == DCRStatus.drafted.rawValue
            {
                cell.headerView.backgroundColor = CellColor.draftedBgColor.color
                cell.dcrStatus.text = drafted
            }
            
//
//
//           else if detailModel.dcrStatus == DCRStatus.approved.rawValue && (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.DCR_AUTO_APPROVAL) == PrivilegeValues.YES.rawValue)
//
//            {
//                cell.headerView.backgroundColor = CellColor.approvedBgColor.color
//                cell.dcrStatus.text = "Approved(Offline)"
//            }
//
            else if detailModel.dcrStatus == DCRStatus.approved.rawValue
            {
                
                if detailModel.dcrStatus != 3 && detailModel.dcrCode != ""
                {
                
                cell.headerView.backgroundColor = CellColor.approvedBgColor.color
                cell.dcrStatus.text = approved
                    
                }
                
                else
                {
                    cell.headerView.backgroundColor = CellColor.approvedBgColor.color
                    cell.dcrStatus.text = "Approved(Offline)"
                }
                    
                    
                    
                    
            } else if detailModel.dcrStatus == DCRStatus.unApproved.rawValue
            {
                cell.headerView.backgroundColor = CellColor.unApprovedBgColor.color
                cell.dcrStatus.text = unApproved
            } else if detailModel.dcrStatus == DCRStatus.applied.rawValue
            {
                
                
                if detailModel.dcrStatus != 3 && detailModel.dcrCode != ""
                {
                    
                    cell.headerView.backgroundColor = CellColor.appliedBgColor.color
                    cell.dcrStatus.text = applied
                    
                }
                
                else
                {
                    cell.headerView.backgroundColor = CellColor.appliedBgColor.color
                    cell.dcrStatus.text = "Applied(Offline)"
                
                }
            }

            
            cell.detailBtn.tag = indexPath.row
            cell.editBtn.tag = indexPath.row
            if detailModel.dcrStatus == DCRStatus.approved.rawValue || (detailModel.dcrStatus == DCRStatus.applied.rawValue && detailModel.dcrCode != "")
            {
                cell.detailBtn.isUserInteractionEnabled = false
            } else {
                cell.detailBtn.isUserInteractionEnabled = true
            }
            
//            if detailModel.dcrStatus != 3 && detailModel.dcrCode != ""
//            {
//                cell.headerView.backgroundColor = CellColor.appliedBgColor.color
//                cell.dcrStatus.text = "Applied"
//            }
            
            
             if detailModel.dcrStatus == DCRStatus.applied.rawValue
             {
                let rowHeight = rowHeightArr[indexPath.row] as! CGFloat
                if rowHeight == defaultRowHeight
                {
                    cell.wrapperViewHeightConst.constant = defaultHeaderHeight
                    cell.bottomView.backgroundColor = UIColor.clear
                } else
                {
                    cell.wrapperViewHeightConst.constant = (rcpaCellHeight + defaultHeaderHeight) - rowEditBtnHeight
                    cell.btmViewHeightConst.constant = rcpaCellHeight - rowEditBtnHeight
                    cell.unApprovedHeightConst.constant = 0
                    cell.unapprovedView.isHidden = true
                    cell.bottomView.backgroundColor = UIColor.white
                    cell.editBtnWrapper.isHidden = true
                }
            }
            else if detailModel.dcrStatus == DCRStatus.unApproved.rawValue {
                let rowHeight = rowHeightArr[indexPath.row] as! CGFloat
                if rowHeight == defaultRowHeight
                {
                    cell.wrapperViewHeightConst.constant = defaultHeaderHeight
                    cell.bottomView.backgroundColor = UIColor.clear
                } else
                {
                    if BL_DCRCalendar.sharedInstance.isUnapprovedEditBtnHidden(dcrDate: selectedDate, isAttendanceLock: false, isLockLeave: false) == true
                    {
                        cell.wrapperViewHeightConst.constant = rcpaCellHeight + defaultHeaderHeight + rcpaUnapprovedHeight - rowEditBtnHeight
                        cell.editBtnWrapper.isHidden = true
                    } else
                    {
                        cell.wrapperViewHeightConst.constant = rcpaCellHeight + defaultHeaderHeight + rcpaUnapprovedHeight
                        cell.editBtnWrapper.isHidden = false
                    }
                    cell.btmViewHeightConst.constant = rcpaUnapprovedHeight + (rcpaCellHeight - rowEditBtnHeight)
                    cell.unApprovedHeightConst.constant = rcpaUnapprovedHeight
                    cell.unapprovedView.isHidden = false
                    cell.bottomView.backgroundColor = UIColor.white
                }
                if detailModel.unapprovedBy != ""
                {
                    let unapprovedText = BL_DCRCalendar.sharedInstance.getUnapprovedTextformat(text: detailModel.unapprovedBy)
                    cell.unapprovedBylabel.text = unapprovedText
                }
                else
                {
                    cell.unapprovedBylabel.text = "No Remarks"
                }
            } else
            {
                let rowHeight = rowHeightArr[indexPath.row] as! CGFloat
                if rowHeight == defaultRowHeight
                {
                    cell.wrapperViewHeightConst.constant = defaultHeaderHeight
                    cell.bottomView.backgroundColor = UIColor.clear
                } else
                {
                    cell.wrapperViewHeightConst.constant = rcpaCellHeight + defaultHeaderHeight
                    cell.btmViewHeightConst.constant = rcpaCellHeight - rowEditBtnHeight
                    cell.unApprovedHeightConst.constant = 0
                    cell.unapprovedView.isHidden = true
                    cell.bottomView.backgroundColor = UIColor.white
                    cell.editBtnWrapper.isHidden = false
                }
            }
            
            cell.doctorVisitCount.text = "\(doctorVisitCountText) \(detailModel.doctorVisitCount!)"
            if detailModel.doctorPendingVisitCount! > 0
            {
                cell.plannedDoctorVisit.text = "\(doctorPendingCountText) \(detailModel.doctorPendingVisitCount!)"
            }
            else
            {
                cell.plannedDoctorVisit.text = "\(doctorPendingCountText) 0"
            }
            if detailModel.workPlace != ""
            {
                cell.workPlace.text = detailModel.workPlace
            }
            if detailModel.cpName != ""
            {
                cell.cpName.text = detailModel.cpName
            }
            if detailModel.rcpaEntryCount! > 0
            {
                cell.rcpaTick.isHidden = false
            } else
            {
                cell.rcpaTick.isHidden = true
            }
            if detailModel.chemistEntryCount! > 0
            {
                cell.chemistTick.isHidden = false
            } else {
                cell.chemistTick.isHidden = true
            }
            
            let priviledge = BL_Stepper.sharedInstance.getDoctorCaptureValue()
            let privilegeArray = priviledge.components(separatedBy: ",")
            
            if privilegeArray.contains(Constants.ChemistDayCaptureValue.stockiest) || detailModel.stockiestEntryCount! > 0
            {
                cell.stockistView.isHidden = false
            }
            else
            {
                cell.stockistView.isHidden = true
            }
            
            if privilegeArray.contains(Constants.ChemistDayCaptureValue.expenses) || detailModel.expensesEntryCount! > 0
            {
                cell.expenseView.isHidden = false
            }
            else
            {
                cell.expenseView.isHidden = true
            }
            
            if detailModel.stockiestEntryCount! > 0
            {
                cell.stockiestTick.isHidden = false
            } else {
                cell.stockiestTick.isHidden = true
            }
            if detailModel.expensesEntryCount! > 0
            {
                cell.expensesTick.isHidden = false
            } else {
                cell.expensesTick.isHidden = true
            }
            outputCell = cell
        } else if detailModel.dcrFlag == DCRFlag.attendance.rawValue
        {
            let cell:AttendanceCell = tableView.dequeueReusableCell(withIdentifier: attendanceCellIdentifier) as! AttendanceCell
            
            cell.dcrlabel.text = attendance
            
            if detailModel.dcrStatus == DCRStatus.drafted.rawValue
            {
                cell.headerView.backgroundColor = CellColor.draftedBgColor.color
                cell.dcrStatus.text = drafted
            } else if detailModel.dcrStatus == DCRStatus.approved.rawValue
            {
                
                
                if detailModel.dcrStatus != 3 && detailModel.dcrCode != ""
                {
                    
                    cell.headerView.backgroundColor = CellColor.approvedBgColor.color
                    cell.dcrStatus.text = approved
                    
                }
                    
                else
                {
                    cell.headerView.backgroundColor = CellColor.approvedBgColor.color
                    cell.dcrStatus.text = "Approved(Offline)"
                }
                
                
//
//                cell.headerView.backgroundColor = CellColor.approvedBgColor.color
//                cell.dcrStatus.text = approved
            } else if detailModel.dcrStatus == DCRStatus.unApproved.rawValue
            {
                cell.headerView.backgroundColor = CellColor.unApprovedBgColor.color
                cell.dcrStatus.text = unApproved
            } else if detailModel.dcrStatus == DCRStatus.applied.rawValue
            {
                
                
                
                
                if detailModel.dcrStatus != 3 && detailModel.dcrCode != ""
                {
                    
                    cell.headerView.backgroundColor = CellColor.appliedBgColor.color
                    cell.dcrStatus.text = applied
                    
                }
                    
                else
                {
                    cell.headerView.backgroundColor = CellColor.appliedBgColor.color
                    cell.dcrStatus.text = "Applied(Offline)"
                    
                }
                
                
//                cell.headerView.backgroundColor = CellColor.appliedBgColor.color
//                cell.dcrStatus.text = applied
            }
            
            cell.detailBtn.tag = indexPath.row
            cell.editBtn.tag = indexPath.row
            if detailModel.dcrStatus == DCRStatus.approved.rawValue || (detailModel.dcrStatus == DCRStatus.applied.rawValue && detailModel.dcrCode != "")
            {
                cell.detailBtn.isUserInteractionEnabled = false
            } else {
                cell.detailBtn.isUserInteractionEnabled = true
            }
            
            if detailModel.dcrStatus == DCRStatus.applied.rawValue
            {
                let rowHeight = rowHeightArr[indexPath.row] as! CGFloat
                if rowHeight == defaultRowHeight
                {
                    cell.wrapperViewHeightConst.constant = defaultHeaderHeight
                    cell.bottomView.backgroundColor = UIColor.clear
                } else
                {
                    cell.wrapperViewHeightConst.constant = (attendanceCellHeight + defaultHeaderHeight) - rowEditBtnHeight
                    cell.btmViewHeightConst.constant = attendanceCellHeight - rowEditBtnHeight
                    cell.unApprovedHeightConst.constant = 0
                    cell.unapprovedView.isHidden = true
                    cell.bottomView.backgroundColor = UIColor.white
                    cell.editBtnWrapper.isHidden = true
                }
            } else if detailModel.dcrStatus == DCRStatus.unApproved.rawValue {
                let rowHeight = rowHeightArr[indexPath.row] as! CGFloat
                if rowHeight == defaultRowHeight
                {
                    cell.wrapperViewHeightConst.constant = defaultHeaderHeight
                    cell.bottomView.backgroundColor = UIColor.clear
                } else
                {
                    if BL_DCRCalendar.sharedInstance.isUnapprovedEditBtnHidden(dcrDate: selectedDate, isAttendanceLock: true, isLockLeave: false) == true
                    {
                        cell.wrapperViewHeightConst.constant = attendanceCellHeight + defaultHeaderHeight + attendanceUnapprovedHeight - rowEditBtnHeight
                        cell.editBtnWrapper.isHidden = true
                    } else
                    {
                        cell.wrapperViewHeightConst.constant = attendanceCellHeight + defaultHeaderHeight + attendanceUnapprovedHeight
                        cell.editBtnWrapper.isHidden = false
                    }
                    cell.btmViewHeightConst.constant = attendanceUnapprovedHeight + (attendanceCellHeight - rowEditBtnHeight)
                    cell.unApprovedHeightConst.constant = attendanceUnapprovedHeight
                    cell.unapprovedView.isHidden = false
                    cell.bottomView.backgroundColor = UIColor.white
                }
                if detailModel.unapprovedBy != ""
                {
                    let unapprovedText = BL_DCRCalendar.sharedInstance.getUnapprovedTextformat(text: detailModel.unapprovedBy)
                    cell.unapprovedBylabel.text = unapprovedText
                }
                else
                {
                    cell.unapprovedBylabel.text = "No Remarks"
                }
            } else
            {
                let rowHeight = rowHeightArr[indexPath.row] as! CGFloat
                if rowHeight == defaultRowHeight
                {
                    cell.wrapperViewHeightConst.constant = defaultHeaderHeight
                    cell.bottomView.backgroundColor = UIColor.clear
                } else
                {
                    cell.wrapperViewHeightConst.constant = attendanceCellHeight + defaultHeaderHeight
                    cell.btmViewHeightConst.constant = attendanceCellHeight - rowEditBtnHeight
                    cell.unApprovedHeightConst.constant = 0
                    cell.unapprovedView.isHidden = true
                    cell.bottomView.backgroundColor = UIColor.white
                    cell.editBtnWrapper.isHidden = false
                }
            }
            
            cell.workPlace.text = detailModel.workPlace
            if detailModel.attendanceActivityCount! > 0
            {
                cell.activityTick.isHidden = false
            } else
            {
                cell.activityTick.isHidden = true
            }
            outputCell = cell
        } else if detailModel.dcrFlag == DCRFlag.leave.rawValue
        {
            let cell:LeaveCell = tableView.dequeueReusableCell(withIdentifier: leaveCellIdentifier) as! LeaveCell
            
            cell.dcrLabel.text = leave
            
            if detailModel.dcrStatus == DCRStatus.drafted.rawValue
            {
                cell.headerView.backgroundColor = CellColor.draftedBgColor.color
                cell.dcrStatus.text = drafted
            } else if detailModel.dcrStatus == DCRStatus.approved.rawValue
            {
                
                if detailModel.dcrStatus != 3 && detailModel.dcrCode != ""
                {
                    
                    cell.headerView.backgroundColor = CellColor.approvedBgColor.color
                    cell.dcrStatus.text = approved
                    
                }
                    
                else
                {
                    cell.headerView.backgroundColor = CellColor.approvedBgColor.color
                    cell.dcrStatus.text = "Approved(Offline)"
                }
                
                
//                cell.headerView.backgroundColor = CellColor.approvedBgColor.color
//                cell.dcrStatus.text = approved
            } else if detailModel.dcrStatus == DCRStatus.unApproved.rawValue
            {
                cell.headerView.backgroundColor = CellColor.unApprovedBgColor.color
                cell.dcrStatus.text = unApproved
            } else if detailModel.dcrStatus == DCRStatus.applied.rawValue
            {
                
                
                if detailModel.dcrStatus != 3 && detailModel.dcrCode != ""
                {
                    
                    cell.headerView.backgroundColor = CellColor.appliedBgColor.color
                    cell.dcrStatus.text = applied
                    
                }
                    
                else
                {
                    cell.headerView.backgroundColor = CellColor.appliedBgColor.color
                    cell.dcrStatus.text = "Applied(Offline)"
                    
                }
//                cell.headerView.backgroundColor = CellColor.appliedBgColor.color
//                cell.dcrStatus.text = applied
            }
            
            cell.detailBtn.tag = indexPath.row
            cell.editBtn.tag = indexPath.row
            if detailModel.dcrStatus == DCRStatus.approved.rawValue || (detailModel.dcrStatus == DCRStatus.applied.rawValue && detailModel.dcrCode != "")
            {
                cell.detailBtn.isUserInteractionEnabled = false
            } else {
                cell.detailBtn.isUserInteractionEnabled = true
            }
            
            let rowHeight = rowHeightArr[indexPath.row] as! CGFloat
            if detailModel.dcrStatus == DCRStatus.applied.rawValue
            {
                if rowHeight == defaultRowHeight
                {
                    cell.wrapperViewHeightConst.constant = defaultHeaderHeight
                    cell.bottomView.backgroundColor = UIColor.clear
                } else
                {
                    cell.wrapperViewHeightConst.constant = (leaveCellHeight + defaultHeaderHeight) - rowEditBtnHeight
                    cell.btmViewHeightConst.constant = leaveCellHeight - rowEditBtnHeight
                    cell.unApprovedHeightConst.constant = 0
                    cell.unapprovedView.isHidden = true
                    cell.bottomView.backgroundColor = UIColor.white
                    cell.editBtnWrapper.isHidden = true
                }
            } else if detailModel.dcrStatus == DCRStatus.unApproved.rawValue {
                if rowHeight == defaultRowHeight
                {
                    cell.wrapperViewHeightConst.constant = defaultHeaderHeight
                    cell.bottomView.backgroundColor = UIColor.clear
                } else
                {
                    if BL_DCRCalendar.sharedInstance.getPayrollIntegratedVal() == ConfigValues.YES.rawValue
                    {
                        cell.wrapperViewHeightConst.constant = leaveCellHeight + defaultHeaderHeight + leaveUnapprovedHeight - rowEditBtnHeight
                        cell.editBtnWrapper.isHidden = true
                    }
                    else
                    {
                        //if unApprovedEditHidden == true
                        if BL_DCRCalendar.sharedInstance.isUnapprovedEditBtnHidden(dcrDate: selectedDate, isAttendanceLock: false, isLockLeave: false)
                        {
                            cell.wrapperViewHeightConst.constant = leaveCellHeight + defaultHeaderHeight + leaveUnapprovedHeight - rowEditBtnHeight
                            cell.editBtnWrapper.isHidden = true
                        }
                        else
                        {
                            cell.wrapperViewHeightConst.constant = leaveCellHeight + defaultHeaderHeight + leaveUnapprovedHeight
                            cell.editBtnWrapper.isHidden = false
                        }
                    }
                    cell.btmViewHeightConst.constant = leaveUnapprovedHeight + (leaveCellHeight - rowEditBtnHeight)
                    cell.unApprovedHeightConst.constant = leaveUnapprovedHeight
                    cell.unapprovedView.isHidden = false
                    cell.bottomView.backgroundColor = UIColor.white
                }
                if detailModel.unapprovedBy != ""
                {
                    let unapprovedText = BL_DCRCalendar.sharedInstance.getUnapprovedTextformat(text: detailModel.unapprovedBy)
                    cell.unapprovedBylabel.text = unapprovedText
                }
                else
                {
                    cell.unapprovedBylabel.text = "No Remarks"
                }
            } else
            {
                if rowHeight == defaultRowHeight
                {
                    cell.wrapperViewHeightConst.constant = defaultHeaderHeight
                    cell.bottomView.backgroundColor = UIColor.clear
                } else
                {
                    cell.wrapperViewHeightConst.constant = leaveCellHeight + defaultHeaderHeight
                    cell.btmViewHeightConst.constant = leaveCellHeight - rowEditBtnHeight
                    cell.unApprovedHeightConst.constant = 0
                    cell.unapprovedView.isHidden = true
                    cell.bottomView.backgroundColor = UIColor.white
                    cell.editBtnWrapper.isHidden = false
                }
            }
            
            cell.leaveName.text = detailModel.leaveName
            outputCell = cell
            
        }
        
        return outputCell
    }
    
    private func showDCRRefreshPopup()
    {
        let sb = UIStoryboard(name:DCRCalenderSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: RefreshPopupVcID) as! DCRRefreshPopupController
        vc.delegate = self
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    func dismissFunction(vcID: String) {
        if vcID == DCRUploadVcID
        {
            navigateToUploadDCR()
        }
        else if vcID == RefreshVcID
        {
            navigateToDCRefresh(refreshMode: DCRRefreshMode.TAKE_SERVER_DATA)
        }
    }
    
    private func navigateToUploadDCR()
    {
        let sb = UIStoryboard(name:DCRCalenderSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: DCRUploadVcID) as! DCRUploadController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToDCRefresh(refreshMode: DCRRefreshMode)
    {
        let sb = UIStoryboard(name:DCRCalenderSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: RefreshVcID) as! DCRRefreshController
        vc.refreshMode = refreshMode
        vc.endDate = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollToTop()
    {
        let topOffset = CGPoint(x: 0, y: tableView.frame.origin.y)
        scrollView.setContentOffset(topOffset, animated: true)
    }
    
    func scrollToBottom()
    {
        let bottomOffset = CGPoint(x: 0, y: tableView.frame.origin.y + tableView.contentSize.height)
        scrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    // Picker view delegates
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return monthArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return monthArray[row] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return SCREEN_WIDTH
    }
    
    
    //MARK:- Private Function
    
    private func sendHourlyReport()
    {
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: "Sending live tracker report..")
            BL_DCR_Doctor_Visit.sharedInstance.sendHourlyReport { (objApiResponse) in
                removeCustomActivityView()
                if objApiResponse.Status == SERVER_SUCCESS_CODE
                {
                    showToastView(toastText: "Live tracker report sent successfully")
                }
                else
                {
                    if objApiResponse.Message == EMPTY || objApiResponse.Message.uppercased() == errorTitle.uppercased()
                    {
                        showToastView(toastText: "Sorry unable to send live tracker report")
                    }
                    else
                    {
                        showToastView(toastText: objApiResponse.Message)
                    }
                }
            }
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
}

