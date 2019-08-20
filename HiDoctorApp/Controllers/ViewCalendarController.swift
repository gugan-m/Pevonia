import UIKit
import EventKit

class ViewCalendarController: UIViewController, CalendarViewDataSource, CalendarViewDelegate, UIActionSheetDelegate {

    
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var showpickerbtn: UIButton!
    
    //@IBOutlet weak var draftview: UIView!
    @IBOutlet weak var draftview: UIButton!
    var date: String = getCurrentDate()
    @IBAction func onclickshow() {
        if datePicker.isHidden == true
        {
            draftview.isHidden = true
            datePicker.isHidden = false
        }
        else
        {
            draftview.isHidden = false
            datePicker.isHidden = true
        }
    }
    @IBAction func onclicknotesview() {
        
        let sb = UIStoryboard(name: "calendar", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "NotesListViewVcID") as! NotesListViewController
        vc.selecteddate = self.date
        vc.date = self.date
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func addbtnclick() {
        
        let actionSheet = UIActionSheet(title: "", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Notes", "Task","Know your calendar")
        
        actionSheet.show(in: self.view)
    }
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int)
    {
        
        switch (buttonIndex){
            
        case 0: break
            //println("Cancel")
        case 1:
        let sb = UIStoryboard(name: "calendar", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "NotesVcid") as! NotesTaskViewController
        vc.isfromnotes = true
        vc.dateselected = self.date
        self.navigationController?.pushViewController(vc, animated: true)
        case 2: 
        let sb = UIStoryboard(name: "calendar", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "NotesVcid") as! NotesTaskViewController
        vc.dateselected = self.date
        vc.isfromtask = true
        self.navigationController?.pushViewController(vc, animated: true)
        case 3:
        let sb = UIStoryboard(name:"calendar", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "NotesCalendarVcID") as! NotesKnowYourCalendar
        self.navigationController?.pushViewController(vc, animated: true)
            
            //println("Delete")
        default: break
            //println("Default")
            //Some code here..
            
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        CalendarView.Style.cellShape                = .round
        CalendarView.Style.cellColorDefault         = UIColor.clear
        CalendarView.Style.cellColorToday           = UIColor(red: 99/255, green: 86/255, blue: 0/255, alpha: 1.0)
        CalendarView.Style.cellSelectedBorderColor  = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
        CalendarView.Style.cellEventColor           = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
        CalendarView.Style.headerTextColor          = UIColor.white
        CalendarView.Style.cellTextColorDefault     = UIColor.white
        CalendarView.Style.cellTextColorToday       = UIColor.orange
        
        CalendarView.Style.firstWeekday             = .sunday
        
        CalendarView.Style.locale                   = Locale(identifier: "en_US")
        
        CalendarView.Style.timeZone                 = TimeZone(abbreviation: "UTC")!
        
        CalendarView.Style.hideCellsOutsideDateRange = false
        CalendarView.Style.changeCellColorOutsideRange = false
        
        CalendarView.Style.cellFont = UIFont(name: "Helvetica", size: 20.0)
        CalendarView.Style.headerFont = UIFont(name: "Helvetica", size: 20.0)
        CalendarView.Style.subHeaderFont = UIFont(name: "Helvetica", size: 14.0)
        
        calendarView.dataSource = self
        calendarView.delegate = self
        
        calendarView.direction = .horizontal
        calendarView.multipleSelectionEnable = false
        calendarView.marksWeekends = true
        
        draftview.layer.cornerRadius = 5.0
        draftview.backgroundColor = UIColor(red: 53/255, green: 127/255, blue: 206/255, alpha: 1.0)
        calendarView.layer.cornerRadius = 0.0
        //calendarView.backgroundColor = UIColor(red:0.31, green:0.44, blue:0.47, alpha:1.00)
        calendarView.backgroundColor = UIColor(red: 32/255, green: 110/255, blue: 193/255, alpha: 1.0)
        //getnotes()
        getcalender(year: String(getCurrentDate().prefix(4)))
        addNavigationBarBut()
        calendarView.collectionView.reloadData()
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
       
        //CalendarView.loadEvents()
    }
    override open var shouldAutorotate: Bool {
        return false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getcalender(year: String(getCurrentDate().prefix(4)))
       calendarView.collectionView.reloadData()
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
       self.showpickerbtn.isHidden = true
    }
    
    func addNavigationBarBut()
    {
        let button = UIButton(type: .custom)
        //set image for button
        button.setImage(UIImage(named: "icon-plus"), for: .normal)
        //add function for button
        button.addTarget(self, action: #selector(addbtnclick), for: .touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 53, height: 51)
        
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
    }
    func getnotes()
    {
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: "Loading...")
            WebServiceHelper.sharedInstance.getcalendarnotes( completion: { (apiObj) in
                if apiObj.Status == SERVER_SUCCESS_CODE
                {
                    let list = apiObj.list
                    removeCustomActivityView()
                }
            })
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        let today = Date()
        datePicker.isHidden = true
        draftview.isHidden = false
        var tomorrowComponents = DateComponents()
        tomorrowComponents.day = 1
        
        
        let tomorrow = self.calendarView.calendar.date(byAdding: tomorrowComponents, to: today)!
        var dateString = self.date
        var dateFormatter = DateFormatter()
        //dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let s = dateFormatter.date(from: dateString)
        self.calendarView.selectDate(s!)
      
        
        #if KDCALENDAR_EVENT_MANAGER_ENABLED
        self.calendarView.loadEvents() { error in
            if error != nil {
                let message = "The calender could not load system events. It is possibly a problem with permissions"
                let alert = UIAlertController(title: "Events Loading Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        #endif
        
        
        self.calendarView.setDisplayDate(s!)
        
        self.datePicker.locale = CalendarView.Style.locale
        self.datePicker.timeZone = CalendarView.Style.timeZone
        self.datePicker.setDate(s!, animated: false)
        //getcalender(year: String(self.date.suffix(4)))
       // getcalender(year: String(self.date.suffix(4)))
        calendarView.collectionView.reloadData()
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }

    // MARK : KDCalendarDataSource
    
    func startDate() -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.year = -2
        
        let today = Date()
        
        let threeMonthsAgo = self.calendarView.calendar.date(byAdding: dateComponents, to: today)!
        
        return threeMonthsAgo
    }
    
    func endDate() -> Date {
        
        var dateComponents = DateComponents()
      
        dateComponents.year = 3
        let today = Date()
        let twoYearsFromNow = self.calendarView.calendar.date(byAdding: dateComponents, to: today)!
        
        return twoYearsFromNow
  
    }
    
    
    // MARK : KDCalendarDelegate
   
    func calendar(_ calendar: CalendarView, didSelectDate date : Date, withEvents events: [CalendarEvent]) {
        
       // print("Did Select: \(date)")
        self.date = convertDateIntoString(date: date)
        
        let temp: String = self.date
        let year: String = String(temp.suffix(4))
        let tempmonth: String = String(temp.prefix(5))
        let month: String = String(tempmonth.suffix(2))
        let day: String = String(tempmonth.prefix(2))
        self.date = year + "-" + month + "-" + day
        print("Did Select: \(self.date)")
        //getcalender(year: String(self.date.prefix(4)))
    }
    
//    func calendar
    
    func calendar(_ calendar: CalendarView, didScrollToMonth date : Date) {
        
        self.datePicker.setDate(date, animated: true)
    }
    
    
    // MARK : Events
    
    @IBAction func onValueChange(_ picker : UIDatePicker) {
        self.calendarView.setDisplayDate(picker.date, animated: true)
    }
    
    @IBAction func goToPreviousMonth(_ sender: Any) {
        self.calendarView.goToPreviousMonth()
    }
    @IBAction func goToNextMonth(_ sender: Any) {
        self.calendarView.goToNextMonth()
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    func getcalender(year: String)
    {
        
        if(checkInternetConnectivity())
        {
       
                self.calendarView.notesdateindex.removeAll()
                self.calendarView.taskdateindex.removeAll()
                self.calendarView.bothdateindex.removeAll()
                self.calendarView.holidaydateindex.removeAll()
                self.calendarView.weekenddateindex.removeAll()
        
        
                var y = Int(year.suffix(2))
                y = y! - 2
                var y1 = Int(year.suffix(2))
                y1 = y1! - 1
                var y2 = Int(year.suffix(2))
                var y3 = Int(year.suffix(2))
                y3 = y3! + 1
                var y4 = Int(year.suffix(2))
                y4 = y4! + 2
                var y5 = Int(year.suffix(2))
                y5 = y5! + 3
                var yearlist: [String] = []
                yearlist.append(year.prefix(2) + "\(y!)")
                yearlist.append(year.prefix(2) + "\(y1!)")
                yearlist.append(year.prefix(2) + "\(y2!)")
                yearlist.append(year.prefix(2) + "\(y3!)")
                yearlist.append(year.prefix(2) + "\(y4!)")
                yearlist.append(year.prefix(2) + "\(y5!)")
                for i in yearlist
                {
                    
                    showCustomActivityIndicatorView(loadingText: "Loading Calendar....")
                WebServiceHelper.sharedInstance.getcalendarnotesyear( year: i, completion: { (apiObj) in
                    if apiObj.Status == SERVER_SUCCESS_CODE
                    {
                        let list = apiObj.list
                        //removeCustomActivityView()
                        for i in list as! NSArray
                        {
                            var temp : Date = Date()
                            let date = (i as! NSDictionary).value(forKey: "Activity_Date") as! String
                            let dateFormatter = DateFormatter()
                            
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
                            let dateformat = dateFormatter.date(from: date)
                            if((i as! NSDictionary).value(forKey: "Is_Holiday") as! Int == 1)
                            {
                                self.calendarView.colorHoliday(dateformat!)
                            }
                            if((i as! NSDictionary).value(forKey: "Is_WeekEnd") as! Int == 1)
                            {
                                self.calendarView.colorWeekend(dateformat!)
                            }
                            if((i as! NSDictionary).value(forKey: "Activity_Count") as! Int != 0)
                            {
                                //  temp = CalendarView.indexPathForDate(((i as! NSDictionary).value(forKey: "Activity_Date")))
                                let date = (i as! NSDictionary).value(forKey: "Activity_Date") as! String
                                let dateFormatter = DateFormatter()
                                
                                dateFormatter.dateFormat = "yyyy-MM-dd"
                                dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
                                let dateformat = dateFormatter.date(from: date)
                                //let dateformat = getDateFromString(dateString: date)
                               // guard let temp = CalendarView.indexPathForDate(dateformat!) else { return }
                                //temp = CalendarView.indexPathForDate(dateformat)!
                                if((i as! NSDictionary).value(forKey: "DCR_Status") as! Int == 9)
                                {
                                    self.calendarView.colorDate(dateformat!)
                                }
                                else if((i as! NSDictionary).value(forKey: "DCR_Status") as! Int == 10)
                                {
                                    self.calendarView.colortask(dateformat!)
                                }
                                else if((i as! NSDictionary).value(forKey: "DCR_Status") as! Int == 11)
                                {
                                    self.calendarView.colorboth(dateformat!)
                                }
                                
                                
                                
                            }
                            
                        }
                        
                        removeCustomActivityView()
                    }
                })
                
            }
                //end for
        
            
    //removeCustomActivityView()
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
}






