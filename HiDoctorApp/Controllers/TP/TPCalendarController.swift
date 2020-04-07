//
//  TPCalendarController.swift
//  HiDoctorApp
//
//  Created by Vijay on 21/07/17.
//  Copyright © 2017 swaas. All rights reserved.
//defaultDateFomat

import UIKit
import JTAppleCalendar

class TPCalendarController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var pickerTextfield: TextField!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var emptyStateWrapper: UIView!
    @IBOutlet weak var emptyStateDateLbl: UILabel!
    @IBOutlet weak var holidayLbl: UILabel!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    @IBOutlet weak var emptyStateHeaderView: CornerRadiusWithShadowView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tpHeaderView: UIView!
    
    @IBOutlet weak var tpHeaderViewBtn: UIButton!
    @IBOutlet weak var tpDateLbl: UILabel!
    
    @IBOutlet weak var tpActivityLbl: UILabel!
    @IBOutlet weak var tpStatusLbl: UILabel!
    @IBOutlet weak var tpBtmWrapper: UIView!
    @IBOutlet weak var tpBtmHeightConst: NSLayoutConstraint!
    @IBOutlet weak var tableWrapperHeightConst: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentViewHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var deleteBut: UIButton!
    @IBOutlet weak var editBut: UIButton!
    @IBOutlet weak var bottomHeaderSeperatorView: UIView!
    @IBOutlet weak var tpHeaderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tpBtmWrapper1: UIView!
    
    @IBOutlet weak var bg_BlurView: UIView!
    @IBOutlet weak var planning_alertView: UIView!
    @IBOutlet weak var lblPlanningHeader: UILabel!
    
    var pickerView: UIPickerView!
    var selectedRow: Int = -1
    var outerTableReturnCounr: Int = 0
    var monthArray:NSArray = []
    var startDate: Date!
    var beforeMiddleDate: Date!
    var endDate: Date!
    var afterMiddleDate: Date!
    var middleDate: Date!
    var selectedDate: Date!
    var selectedDateString: String!
    var scrollPrevStartDate: Date!
    var didScroll: Bool = false
    
    var numberOfRowsCalendar = 5
    var currentCalendar = Calendar.current
    var generateInDates: InDateCellGeneration = .forAllMonths
    var generateOutDates: OutDateCellGeneration = .tillEndOfRow
    let firstDayOfWeek: DaysOfWeek = .sunday
    var getActivity : Int = 0
    
    
    //MARK:- Application Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.planning_alertView.layer.cornerRadius = 10.0
        selectedDate = getServerFormattedDate(date: getCurrentDateAndTime())
        self.hidePlanningPopup()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        tpBtmWrapper.roundCorners([.bottomLeft,.bottomRight], radius: 5)
        setDefaults()
        BL_TPCalendar.sharedInstance.getTPCalendarModel()
        self.hidePlanningPopup()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews()
    {
        removeVersionToastView()
        showVersionToastView(textColor: UIColor.darkGray)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        orientationCalendarReloadData()
    }
    
    func orientationCalendarReloadData()
    {
        if selectedDate != nil
        {
            BL_TPCalendar.sharedInstance.getTPCalendarModel()
            calendarView.scrollToDate(Date() as Date, triggerScrollToDateDelegate: false, animateScroll: false)
            calendarView.scrollDirection = .horizontal
            calendarView.scrollingMode = .stopAtEachCalendarFrame
            moveToMonthSegment(date: selectedDate)
            calendarView.reloadData()
        }
    }
    
    //MARK:- Default functions
    private func setDefaults()
    {
        self.tableView.separatorColor = UIColor.clear
        scrollView.isHidden = true
        let dictionary = BL_TPCalendar.sharedInstance.getTPMonth()
        monthArray = dictionary.value(forKey: "monthArray") as! NSArray
        startDate = dictionary.value(forKey: "startDate") as! Date
        beforeMiddleDate = dictionary.value(forKey: "beforeMiddleDate") as! Date
        endDate = dictionary.value(forKey: "endDate") as! Date
        afterMiddleDate = dictionary.value(forKey: "afterMiddleDate") as! Date
        middleDate = dictionary.value(forKey: "middleDate") as! Date
        
        pickerView = UIPickerView()
        pickerView.backgroundColor = UIColor.lightGray
        pickerView.delegate = self
        pickerView.selectRow(1, inComponent: 0, animated: false)
        
        let pickerToolbar = UIToolbar()
        let doneButton : UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(TPCalendarController.doneClicked))
        
        BL_TPCalendar.sharedInstance.getTPCalendarModel()
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        pickerToolbar.setItems([spaceButton, doneButton], animated: false)
        pickerToolbar.sizeToFit()
        pickerTextfield.inputView = pickerView
        pickerTextfield.inputAccessoryView = pickerToolbar
        
//        calendarView.register(UINib(nibName: Constants.NibNames.AssetsChildTableViewCell, bundle: nil), forCellWithReuseIdentifier: <#T##String#>)
        
        calendarView.register(UINib(nibName: "CalendarDateCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        calendarView.scrollToDate(Date() as Date, triggerScrollToDateDelegate: false, animateScroll: false)
        calendarView.scrollDirection = .horizontal
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        //calendarView.cellInset = CGPoint(x: 0, y: 0)
        moveToMonthSegment(date: selectedDate)
       // calendarView.selectDates([selectedDate])
        DispatchQueue.main.async {
            self.calendarView.reloadData()
        }
        
        //loadTPDetails()
    }
    
    @objc func doneClicked()
    {
        if selectedRow == 0
        {
            moveToMonthSegment(date: startDate)
        }
        else if selectedRow == 1
        {
            moveToMonthSegment(date: beforeMiddleDate)
        }
        else if selectedRow == 2
        {
            moveToMonthSegment(date: middleDate)
        }
        else if selectedRow == 3
        {
            moveToMonthSegment(date: afterMiddleDate)
        }
        else if selectedRow == 4
        {
            moveToMonthSegment(date: endDate)
        }
        pickerTextfield.resignFirstResponder()
    }
    
    private func moveToMonthSegment(date: Date)
    {
        self.calendarView.scrollToDate(date, animateScroll: false) {
            self.calendarView.visibleDates({ (visibleDates: DateSegmentInfo) in
                self.setupViewsOfCalendar(from: visibleDates)
            })
        }
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo)
    {
        visibleDates.monthDates.last?.date
        guard let endDate = visibleDates.monthDates.last else {
            return
        }
        let currentEndDate = getServerFormattedDate(date: endDate.date)
        let month = currentCalendar.dateComponents([.month], from: currentEndDate).month!
        let monthName = DateFormatter().shortMonthSymbols[(month-1) % 12]
        let year = currentCalendar.component(.year, from: currentEndDate)
        monthLabel.text = monthName + " " + String(year)
        
        if month == currentCalendar.dateComponents([.month], from: startDate).month!
        {
            pickerView.selectRow(0, inComponent: 0, animated: false)
        }
        else if month == currentCalendar.dateComponents([.month], from: beforeMiddleDate).month!
        {
            pickerView.selectRow(1, inComponent: 0, animated: false)
        }
        else if month == currentCalendar.dateComponents([.month], from: middleDate).month!
        {
            pickerView.selectRow(2, inComponent: 0, animated: false)
        }
        else if month == currentCalendar.dateComponents([.month], from: afterMiddleDate).month!
        {
            pickerView.selectRow(3, inComponent: 0, animated: false)
        }
        else if month == currentCalendar.dateComponents([.month], from: endDate.date).month!
        {
            pickerView.selectRow(4, inComponent: 0, animated: false)
        }
    }
    
    //MARK:- Pickerview delegates
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return monthArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return monthArray[row] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedRow = row
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return 36.0
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat
    {
        return SCREEN_WIDTH
    }
    
    //MARK:- JTAppleCalendarView delegates
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
        
        (cell as? CalendarDateCell)?.setupCellBeforeDisplay(cellState, date: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "cell", for: indexPath) as! CalendarDateCell
        (cell as CalendarDateCell).setupCellBeforeDisplay(cellState, date: date)
        return cell
    }
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleCell, date: Date, cellState: CellState)
    {
        (cell as? CalendarDateCell)?.setupCellBeforeDisplay(cellState, date: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo)
    {
        if didScroll == true
        {
            let scrollStartDate = visibleDates.monthDates.first
            
            if scrollStartDate!.date > scrollPrevStartDate
            {
                selectedDate = Calendar.current.date(byAdding: .day, value: 7, to: selectedDate)
                if selectedDate <= endDate && selectedDate >= startDate
                {
                    calendarView.reloadData()
                    setupViewsOfCalendar(from: visibleDates)
                }
            }
            else if scrollStartDate!.date < scrollPrevStartDate
            {
                selectedDate = Calendar.current.date(byAdding: .day, value: -7, to: selectedDate)
                if selectedDate <= endDate && selectedDate >= startDate
                {
                    calendarView.reloadData()
                    setupViewsOfCalendar(from: visibleDates)
                }
            }
        }
        
        if didScroll == false
        {
            didScroll = true
        }
        
        scrollPrevStartDate = visibleDates.monthDates.first?.date
    }
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        (cell as? CalendarDateCell)?.cellSelectionChanged(cellState, date: date)
        //selectedDate = convertDateToDate(date: date, dateFormat: dateTimeWithoutMilliSec, timeZone: localTimeZone)
        selectedDate = getServerFormattedDate(date: date)
        selectedDateString = convertDateIntoServerStringFormat(date: selectedDate)
        self.calendarCellClickAction()
        loadTPDetails()
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState)
    {
        (cell as? CalendarDateCell)?.cellSelectionChanged(cellState, date: date)
    }
    
    //MARK:- Navigation bar button actions
    @IBAction func backBtnAction(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: true)
    }
    
    // MARK:-- Navigation Functions
    private func navigateToNextScreen(stoaryBoard: String, viewController:String)
    {
        let sb = UIStoryboard(name: stoaryBoard, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: viewController)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addBtnAction(_ sender: Any)
    {
        let userDetails = DBHelper.sharedInstance.getUserDetail()
        var userStartDate = Date()
        if let getstartDate = userDetails?.startDate
        {
            userStartDate = getstartDate
        }
        
        if(userStartDate <= self.selectedDate)
        {
            let tpMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let array = BL_TPCalendar.sharedInstance.getTPEntryOptions()
            
            for title  in array
            {
                let categoryAction = UIAlertAction(title: title , style: .default, handler: {
                    (alert: UIAlertAction) -> Void in
                    
                    if(title  == fieldRcpa)
                    {
                        self.calendarActionSheetSelectionAction(date: self.selectedDateString,flag: TPFlag.fieldRcpa.rawValue)
                        self.navigateToNextScreen(stoaryBoard: TPStepperSb, viewController: TPStepperVCID)
                    }
                    else if(title == attendance)
                    {
                        self.calendarActionSheetSelectionAction(date: self.selectedDateString,flag: 2)
                        self.navigateToNextScreen(stoaryBoard: TPStepperSb, viewController: TPAttendanceStepperVCID)
                    }
                    else if(title == "Not Working")
                    {
                        self.calendarActionSheetSelectionAction(date: self.selectedDateString,flag: 3)
                        self.navigateToNextScreen(stoaryBoard: TPStepperSb, viewController: TPLeaveEntryVcID)
                    }
                })
                tpMenu.addAction(categoryAction)
            }
            
            let cancelAction = UIAlertAction(title: CANCEL, style: .cancel, handler:{
                (alert: UIAlertAction) -> Void in
                
                _=self.dismiss(animated: false, completion: nil)
                
            })
            tpMenu.addAction(cancelAction)
            
            if SwifterSwift().isPhone
            {
                self.present(tpMenu, animated: true, completion: nil)
            }
            else
            {
                if let currentPopoverpresentioncontroller = tpMenu.popoverPresentationController{
                    currentPopoverpresentioncontroller.sourceView = self.view
                    currentPopoverpresentioncontroller.sourceRect = CGRect(x:self.view.frame.size.width-50,y:0, width:100,height:100)
                    currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.up
                    self.present(tpMenu, animated: true, completion: nil)
                }
            }
        }
        else
        {
            let alertViewController = UIAlertController(title: alertTitle, message: "Not allowed to enter PR before your joining Date.", preferredStyle: UIAlertControllerStyle.alert)
            
            alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
                alertViewController.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alertViewController, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func moreAction(_ sender: Any)
    {
        let tpMoreMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let refreshAction = UIAlertAction(title: TPMoreName.refresh.rawValue, style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            self.navigateToNextScreen(stoaryBoard: TourPlannerSB, viewController: Constants.ViewControllerNames.TPRefreshVCID)
        })
        tpMoreMenu.addAction(refreshAction)
        
        let uploadAction = UIAlertAction(title: TPMoreName.upload.rawValue, style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            self.navigateToNextScreen(stoaryBoard: Constants.StoaryBoardNames.TPUploadSb, viewController: Constants.ViewControllerNames.TPUploadSelectVCID)
        })
        tpMoreMenu.addAction(uploadAction)
        
        let knowyourcalendar = UIAlertAction(title: "Know your calendar", style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            self.navigateToNextScreen(stoaryBoard: Constants.StoaryBoardNames.TPCalendarSb, viewController: TPKYCalendarVcID)
        })
        tpMoreMenu.addAction(knowyourcalendar)
        
        let cancelAction = UIAlertAction(title: CANCEL, style: .cancel, handler:{
            (alert: UIAlertAction) -> Void in
            
            _=self.dismiss(animated: false, completion: nil)
            
        })
        tpMoreMenu.addAction(cancelAction)
        
        if SwifterSwift().isPhone{
            self.present(tpMoreMenu, animated: true, completion: nil)
        }else{
            if let currentPopoverpresentioncontroller = tpMoreMenu.popoverPresentationController{
                currentPopoverpresentioncontroller.sourceView = self.view
                currentPopoverpresentioncontroller.sourceRect = CGRect(x:self.view.frame.size.width-50,y:0, width:100,height:100)
                currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.up
                self.present(tpMoreMenu, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func tpDeleteAction(_ sender: Any)
    {
        let alertViewController = UIAlertController(title: alertTitle, message: "Do you want to delete the PR ?", preferredStyle: UIAlertControllerStyle.alert)
        alertViewController.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.default, handler: { alertAction in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
            BL_TPStepper.sharedInstance.deleteTP(tpEntryId: TPModel.sharedInstance.tpEntryId)
            BL_TPCalendar.sharedInstance.getTPCalendarModel()
            self.loadTPDetails()
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    @IBAction func tpEditAction(_ sender: Any)
    {
        if tpActivityLbl.text == "Field"
        {
            BL_TPStepper.sharedInstance.setSelectedTpDataInContext(date: selectedDateString, tpFlag: TPFlag.fieldRcpa.rawValue)
            
            navigateToNextScreen(stoaryBoard: TPStepperSb, viewController: TPStepperVCID)
        }
        else if tpActivityLbl.text == "Office"
        {
            BL_TPStepper.sharedInstance.setSelectedTpDataInContext(date: selectedDateString, tpFlag: TPFlag.attendance.rawValue)
            
            navigateToNextScreen(stoaryBoard: TPStepperSb, viewController: TPAttendanceStepperVCID)
        }
        else if tpActivityLbl.text == "Prospecting"
        {
               self.calendarActionSheetSelectionAction(date: self.selectedDateString,flag: TPFlag.fieldRcpa.rawValue)
                let sb = UIStoryboard(name: TPStepperSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: TPStepperVCID) as! TPStepperViewController
                vc.isProspect = true
                self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            BL_TPStepper.sharedInstance.setSelectedTpDataInContext(date: selectedDateString, tpFlag: TPFlag.leave.rawValue)
            
            navigateToNextScreen(stoaryBoard: TPStepperSb, viewController: TPLeaveEntryVcID)
        }
    }
    
    @IBAction func act_ClosePlanning(_ sender: UIButton) {
        self.hidePlanningPopup()
    }
    
    @IBAction func act_Field(_ sender: UIButton) {
        self.calendarActionSheetSelectionAction(date: self.selectedDateString,flag: TPFlag.fieldRcpa.rawValue)
        self.navigateToNextScreen(stoaryBoard: TPStepperSb, viewController: TPStepperVCID)
    }
    
    @IBAction func act_Prospect(_ sender: UIButton) {
        self.calendarActionSheetSelectionAction(date: self.selectedDateString,flag: TPFlag.fieldRcpa.rawValue)
        let sb = UIStoryboard(name: TPStepperSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: TPStepperVCID) as! TPStepperViewController
        vc.isProspect = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func act_Office(_ sender: UIButton) {
        self.calendarActionSheetSelectionAction(date: self.selectedDateString,flag: 2)
        self.navigateToNextScreen(stoaryBoard: TPStepperSb, viewController: TPAttendanceStepperVCID)
    }
    
    @IBAction func act_NotWorking(_ sender: UIButton) {
        self.calendarActionSheetSelectionAction(date: self.selectedDateString,flag: 3)
        self.navigateToNextScreen(stoaryBoard: TPStepperSb, viewController: TPLeaveEntryVcID)
    }
    
    func showPlanningPopup(selectedDate: String) {
       // let newButtonWidth: CGFloat = 60
        self.planning_alertView.isHidden = false
        self.bg_BlurView.isHidden = false
        self.lblPlanningHeader.text = "Planning for " + selectedDate
        UIView.animate(withDuration: 0.5, //1
            delay: 0.0, //2
            usingSpringWithDamping:0.1, //3
            initialSpringVelocity: 3, //4
            options: UIView.AnimationOptions.curveEaseInOut, //5
            animations: ({ //6
               // self.planning_alertView.frame = CGRect(x: 0, y: 0, width: newButtonWidth, height: newButtonWidth)
                self.planning_alertView.center = self.view.center
        }), completion: nil)
    }
    
    func hidePlanningPopup() {
        self.planning_alertView.isHidden = true
        self.bg_BlurView.isHidden = true
    }
    
    func loadTPDetails()
    {
        var holidayName: String = ""
        let tourPlannerHeaderModelData:TourPlannerHeader? = BL_TPStepper.sharedInstance.getTPDataForSelectedDate(date: selectedDateString)
        
        emptyStateLbl.text = noTourAvailable
        //addBtn.isHidden = false
        editBut.isHidden = false
        deleteBut.isHidden = false
        bottomHeaderSeperatorView.isHidden = false
         tpDateLbl.text = BL_TPCalendar.sharedInstance.convertDateIntoDCRDisplayformat(date: selectedDate)
        emptyStateDateLbl.text = BL_TPCalendar.sharedInstance.convertDateIntoDCRDisplayformat(date: selectedDate)
        if tourPlannerHeaderModelData != nil
        {
            TPModel.sharedInstance.tpEntryId = tourPlannerHeaderModelData!.TP_Entry_Id
            let activity = tourPlannerHeaderModelData!.Activity
            BL_TPCalendar.sharedInstance.activityCode = activity!
            BL_TPCalendar.sharedInstance.generateDataArray(activity!,objTPHeader: tourPlannerHeaderModelData)
            
            let tpFlag = tourPlannerHeaderModelData!.Activity!
            
            if (tpFlag > 0) // Means no Holiday or Weekend
            {
                emptyStateWrapper.isHidden = true
                scrollView.isHidden = false
              //  addBtn.isHidden = true
                 
               
                //BL_DCRCalendar.sharedInstance.convertDateIntoDCRDisplayformat(date: selectedDate)
                // Applied
                if tourPlannerHeaderModelData!.Status == TPStatus.applied.rawValue
                {
                    tpHeaderView.backgroundColor = TPCellColor.appliedBgColor.color
                    
                    if tourPlannerHeaderModelData!.TP_Id == 0 as Int!
                    {
                    tpStatusLbl.text = "Applied(Offline)"
                    }
                    else
                    {
                     tpStatusLbl.text = tpApplied
                    }
                        tpBtmWrapper.isHidden = true
                    tpBtmWrapper1.isHidden = true
                    tpHeaderHeightConstraint.constant = 90
                    
                }
                else  if tourPlannerHeaderModelData!.Status == TPStatus.approved.rawValue
                {
                    tpHeaderView.backgroundColor = TPCellColor.approvedBgColor.color
                    tpStatusLbl.text = tpApproved
                    //tpBtmHeightConst.constant = 0.0
                    tpBtmWrapper.isHidden = true
                    tpBtmWrapper1.isHidden = true
                    tpHeaderHeightConstraint.constant = 90
                }
                else  if tourPlannerHeaderModelData!.Status == TPStatus.unapproved.rawValue
                {
                    tpHeaderView.backgroundColor = TPCellColor.unApprovedBgColor.color
                    tpStatusLbl.text = tpUnApplied
                    tpHeaderHeightConstraint.constant = 110
                    tpBtmWrapper.isHidden = false
                    tpBtmWrapper1.isHidden = false
                    editBut.isHidden = false
                    deleteBut.isHidden = false
                    //                    if(TPModel.sharedInstance.tpId == 0)
                    //                    {
                    //                        editBut.isHidden = false
                    //                        deleteBut.isHidden = false
                    //                    }
                    //                    else
                    //                    {
                    //                        editBut.isHidden = false
                    //                        deleteBut.isHidden = true
                    //                        bottomHeaderSeperatorView.isHidden = true
                    //                    }
                }
                else  if tourPlannerHeaderModelData!.Status == TPStatus.drafted.rawValue
                {
                    tpHeaderView.backgroundColor = TPCellColor.draftedBgColor.color
                    tpStatusLbl.text = tpDraftYetToApplied
                    tpHeaderHeightConstraint.constant = 110
                    tpBtmWrapper.isHidden = false
                    tpBtmWrapper1.isHidden = false
                    editBut.isHidden = false
                    deleteBut.isHidden = false
                    //                    if(TPModel.sharedInstance.tpId == 0)
                    //                    {
                    //                        editBut.isHidden = false
                    //                        deleteBut.isHidden = false
                    //                    }
                    //                    else
                    //                    {
                    //                        editBut.isHidden = false
                    //                        deleteBut.isHidden = true
                    //                        bottomHeaderSeperatorView.isHidden = true
                    //                    }
                    
                }
                
                // Activity check::
                if(activity == 1)
                {
                    // Field
                    outerTableReturnCounr = 3
                    if tourPlannerHeaderModelData?.TpType != nil {
                       if tourPlannerHeaderModelData?.TpType == "F"{
                            tpActivityLbl.text = "Field"
                            getActivity = 1
                        } else {
                            tpActivityLbl.text = "Prospecting"
                           getActivity = 1
                        }
                    } else {
                        tpActivityLbl.text = "Field"
                        getActivity = 1
                    }
                    
                    
                }
                else if(activity == 2)
                {
                    //Attendance
                    outerTableReturnCounr = 1
                    tpActivityLbl.text = "Office"
                    getActivity = 2
                }
                else if(activity == 3)
                {
                    //Leave
                    outerTableReturnCounr = 1
                    tpActivityLbl.text = "Not Working"
                    getActivity = 3
                }
                
                self.tableView.reloadData()
            }
            if(activity! == 0)
            {
                if(BL_TPCalendar.sharedInstance.isCPVisitFrequencyEnabled())
                {
                    //addBtn.isHidden = false
                }
                else
                {
                    //addBtn.isHidden = true
                }
                if (tourPlannerHeaderModelData!.Is_Holiday == 1)
                {
                    holidayName = "Holiday - \(BL_TPCalendar.sharedInstance.getHolidayName(dcrDate: selectedDate))"
                    emptyStateWrapper.isHidden = false
                    scrollView.isHidden = true
                    emptyStateHeaderView.backgroundColor = TPCellColor.holidayBgColor.color
                }
                else if(tourPlannerHeaderModelData!.Is_Weekend == 1)
                {
                    emptyStateWrapper.isHidden = false
                    scrollView.isHidden = true
                    emptyStateHeaderView.backgroundColor = TPCellColor.weekEndBgColor.color
                    holidayName = weekendOff
                }
                
            }
        }
        else
        {
            emptyStateWrapper.isHidden = false
            scrollView.isHidden = true
            emptyStateHeaderView.backgroundColor = TPCellColor.draftedBgColor.color
            let selectedDateDisplay =  convertDateIntoString(date: self.selectedDate)
            self.showPlanningPopup(selectedDate: selectedDateDisplay)
            holidayName = yetToPlan
        }
        
        holidayLbl.text = holidayName
    }
    
    // Tableview Delegates
    
    // MARK:- Table View Delegates
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        reloadTableView()
    }
    
    func reloadTableView()
    {
        self.tableView.layoutIfNeeded()
        self.tableWrapperHeightConst.constant = tableView.contentSize.height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return outerTableReturnCounr
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let index = indexPath.row
        var tempObj:[DCRStepperModel] = []
        tempObj = BL_TPCalendar.sharedInstance.stepperDataList
        let stepperObj = tempObj[index]
        tempObj = BL_TPCalendar.sharedInstance.stepperDataList
        
        if (stepperObj.recordCount == 0)
        {
            if(getActivity == 1)
            {
                if (index == 2)
                {
                    return 0
                }
            } else {
                if (index == 1)
                {
                    return 0
                }
            }
            
            
            
            return BL_TPCalendar.sharedInstance.getEmptyStateHeight(selectedIndex: index)
        }
        else
        {
            if(getActivity == 1)
            {
                if (index == 0)
                {
                    return BL_TPCalendar.sharedInstance.getTourPlanCellHeight()
                }
                else if (index == 1)
                {
                    return BL_TPCalendar.sharedInstance.getAccompaniestCellHeight(selectedIndex: index)
                }
                else if (index == 2)
                {
                    return BL_TPCalendar.sharedInstance.getPlaceDetailsCellHeight(selectedIndex: index)
                }
                else if (index == 3)
                {
                    return BL_TPCalendar.sharedInstance.getDoctorDetailsCellHeight(selectedIndex: index)
                }
                else
                {
                    return 0
                }
            }
            else if(getActivity == 2)
            {
                if (index == 0)
                {
                    return BL_TPCalendar.sharedInstance.getTourPlanCellHeight()
                }
                else
                {
                    return BL_TPCalendar.sharedInstance.getPlaceDetailsCellHeight(selectedIndex: index)
                }
            }
            else
            {
                return BL_TPCalendar.sharedInstance.getTourPlanCellHeight()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TPDetailCell") as! TPDetailMainCell
        
        let index = indexPath.row
        var tempObj:[DCRStepperModel] = []
        
        tempObj = BL_TPCalendar.sharedInstance.stepperDataList
        let stepperObj = tempObj[index]
        
        cell.selectedIndex = index
        
        if tpActivityLbl.text == "Prospecting" {
           cell.isProspect = true
        } else {
            cell.isProspect = false
        }
        
        cell.activity = getActivity
        cell.titleLbl.text = stepperObj.sectionTitle
        cell.iconView.image = UIImage(named: stepperObj.sectionIconName)
        
        if (stepperObj.recordCount == 0)
        {
            cell.childTableView.isHidden = true
            cell.emptyLbl.isHidden = false
        }
        else
        {
            cell.childTableView.isHidden = false
            cell.emptyLbl.isHidden = true
        }
        
        if(indexPath.row == outerTableReturnCounr-1 )
        {
            cell.sepView.isHidden = true
            cell.layer.cornerRadius = 5
            cell.layer.masksToBounds = true
        }
        
        cell.childTableView.reloadData()
        
        return cell
    }
    
    //MARK:- Get TPheaderData for selected date
    
    func calendarCellClickAction()
    {
        let tpHeaderObj = BL_TPStepper.sharedInstance.getTPDataForSelectedDate(date: selectedDateString)
        if (tpHeaderObj != nil)
        {
            BL_TPStepper.sharedInstance.setSelectedTpDataInContext(date: selectedDateString, tpFlag: (tpHeaderObj?.Activity)!)
            self.summaryView.isHidden = false
        }
    }
    func calendarActionSheetSelectionAction(date: String,flag: Int)
    {
        BL_TPStepper.sharedInstance.setSelectedTpDataInContext(date: date, tpFlag: flag)
    }
    
    
    
    @IBAction func act_View(_ sender: UIButton) {
         let tourPlannerHeaderModelData:TourPlannerHeader? = BL_TPStepper.sharedInstance.getTPDataForSelectedDate(date: selectedDateString)
        if tourPlannerHeaderModelData != nil
               {
                if tourPlannerHeaderModelData!.Status == TPStatus.approved.rawValue
                {
                    if tpActivityLbl.text == "Field"
                    {
                        BL_TPStepper.sharedInstance.setSelectedTpDataInContext(date: selectedDateString, tpFlag: TPFlag.fieldRcpa.rawValue)
                        let sb = UIStoryboard(name: TPStepperSb, bundle: nil)
                        let vc = sb.instantiateViewController(withIdentifier: TPStepperVCID) as! TPStepperViewController
                        vc.IS_VIEW_MODE = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else if tpActivityLbl.text == "Office"
                    {
                        BL_TPStepper.sharedInstance.setSelectedTpDataInContext(date: selectedDateString, tpFlag: TPFlag.attendance.rawValue)
                        let sb = UIStoryboard(name: TPStepperSb, bundle: nil)
                        let vc = sb.instantiateViewController(withIdentifier: TPAttendanceStepperVCID) as! TPAttendanceStepperViewController
                        vc.IS_VIEW_MODE = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else if tpActivityLbl.text == "Prospecting"
                    {
                           self.calendarActionSheetSelectionAction(date: self.selectedDateString,flag: TPFlag.fieldRcpa.rawValue)
                            let sb = UIStoryboard(name: TPStepperSb, bundle: nil)
                            let vc = sb.instantiateViewController(withIdentifier: TPStepperVCID) as! TPStepperViewController
                            vc.isProspect = true
                            vc.IS_VIEW_MODE = true
                            self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else
                    {
                        BL_TPStepper.sharedInstance.setSelectedTpDataInContext(date: selectedDateString, tpFlag: TPFlag.leave.rawValue)
                        let sb = UIStoryboard(name: TPStepperSb, bundle: nil)
                        let vc = sb.instantiateViewController(withIdentifier: TPLeaveEntryVcID) as! TPLeaveEntryViewController
                        vc.IS_VIEW_MODE = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
        }
    }
}

