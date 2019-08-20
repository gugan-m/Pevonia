//
//  ShowHourlyReportViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 03/03/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class ShowHourlyReportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewMapHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewOnMapsButton: UIButton!
    @IBOutlet weak var emptyStateLbl: UILabel!
    
    //MARK:- Private Variables
    var dataArray: [NSDictionary] = []
    let sectionTitleKeyName: String = "Section_Title"
    let dataKeyName: String = "Data_Array"
    var selectedEmployeeName: String!
    var selectedDate: String!
    var selectedUserCode: String!
    var hourlyReportList: [HourlyReportDoctorVisitModel] = []
    var doctorListWithLocations: [HourlyReportDoctorVisitModel] = []
    var isComingFromGeo : Bool = false
    var geoDoctorList : [DCRDoctorVisitModel] = []
    var geoCustomerList : [DCRDoctorVisitModel] = []
    var geoChemistList : [DCRDoctorVisitModel] = []
    var geoStockistList : [DCRDoctorVisitModel] = []
    var geoAllList : [DCRDoctorVisitModel] = []
     var attachBut : UIBarButtonItem!
    var titleStr = String()
    var filteredChemistArray = NSArray()
    var filteredCustomerArray = NSArray()
    var filteredStockistArray = NSArray()

    var allArray = NSArray()
    var visitDateString = String()
    
    //MARK:- Life Cycle Events
    override func viewDidLoad()
    {
        super.viewDidLoad()
        titleStr = "All"
        viewMapHeightConstraint.constant = 0
        viewOnMapsButton.isHidden = true
        addFilterBtn()
        doInitialSetup()
        
        self.getHourlyReportDetails()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Initial Setup Functions
    private func doInitialSetup()
    {
        addBackButtonView()
        let visitDate = getStringInFormatDate(dateString: checkNullAndNilValueForString(stringData:selectedDate))
        visitDateString = convertDateIntoString(date: visitDate)
        
        self.title = "\(titleStr) - \(visitDateString)"
        
        tableView.estimatedRowHeight = 500
    }
    
    
    
    //MARK:- API Functions
    private func getHourlyReportDetails()
    {
        if(!isComingFromGeo)
        {
            if (checkInternetConnectivity())
            {
                clearData()
                showLoader(message: "Fetching data. Please wait...")
                
                BL_HourlyReport.sharedInstance.getDoctorVisitDetailsByDate(userCode: selectedUserCode, startDate: selectedDate, completion: { (objApiResponse) in
                    
                    self.hideLoader()
                    
                    if (objApiResponse.Status == SERVER_SUCCESS_CODE)
                    {
                        let chemistPredicate = NSPredicate(format: "Customer_Entity_Type == %@","C")
                        let customerPredicate = NSPredicate(format: "Customer_Entity_Type == %@","D")
                        let StockistPredicate = NSPredicate(format: "Customer_Entity_Type == %@","S")
                        self.filteredChemistArray = objApiResponse.list.filtered(using: chemistPredicate) as NSArray
                        self.filteredCustomerArray = objApiResponse.list.filtered(using: customerPredicate) as NSArray
                        self.filteredStockistArray = objApiResponse.list.filtered(using: StockistPredicate) as NSArray
                        self.allArray = objApiResponse.list
                        self.prepareDataArray(reportList: objApiResponse.list)
                    }
                    else
                    {
                        self.showApiErrorMessage(objApiResponse: objApiResponse)
                    }
                })
            }
            else
            {
                AlertView.showNoInternetAlert()
            }
        }
        else
        {
            if(self.geoDoctorList.count > 0)
            {
                var arrayData : [AnyObject] = []
                
                for doctorList in geoDoctorList
                {
                    arrayData.append(doctorList)
                }
                
                self.prepareDataArray(reportList:arrayData as NSArray)
            }
            else
            {
                self.reloadTableView()
            }
        }
    }
    
    private func clearData()
    {
        dataArray = []
        hourlyReportList = []
        doctorListWithLocations = []
    }
    
    private func showLoader(message: String)
    {
        showCustomActivityIndicatorView(loadingText: message)
    }
    
    private func hideLoader()
    {
        removeCustomActivityView()
    }
    
    private func showErrorAlert(alertTitle: String, message: String)
    {
        AlertView.showAlertView(title: alertTitle, message: message, viewController: self)
    }
    
    private func showApiErrorMessage(objApiResponse: ApiResponseModel)
    {
        if (objApiResponse.Status == SERVER_ERROR_CODE)
        {
            showErrorAlert(alertTitle: errorTitle, message: "Unable to download report. Please try again")
        }
        else if (objApiResponse.Status == NO_INTERNET_ERROR_CODE)
        {
            showErrorAlert(alertTitle: errorTitle, message: "Internet connection error. Please try again")
        }
        else if (objApiResponse.Status == LOCAL_ERROR_CODE)
        {
            showErrorAlert(alertTitle: errorTitle, message: "Unable to download report. Please try again")
        }
    }
    
    private func prepareDataArray(reportList: NSArray)
    {
        self.hourlyReportList.removeAll()
        
        if(isComingFromGeo)
        {
            if (reportList.count > 0)
            {
                let hourlyReportLists = reportList as! [DCRDoctorVisitModel]
                var hourlyReport : HourlyReportDoctorVisitModel = HourlyReportDoctorVisitModel()
                
                for obj in hourlyReportLists
                {
                    hourlyReport = HourlyReportDoctorVisitModel()
                    hourlyReport.Category_Name = checkNullAndNilValueForString(stringData: obj.Category_Name)
                    hourlyReport.Doctor_Code = checkNullAndNilValueForString(stringData: obj.Doctor_Code)
                    hourlyReport.Doctor_Name = checkNullAndNilValueForString(stringData: obj.Doctor_Name)
                    hourlyReport.Speciality_Name = checkNullAndNilValueForString(stringData: obj.Speciality_Name)
                    hourlyReport.MDL_Number = checkNullAndNilValueForString(stringData: obj.MDL_Number)
                    hourlyReport.Doctor_Region_Name = checkNullAndNilValueForString(stringData: obj.Doctor_Region_Name)
                    hourlyReport.Local_Area = checkNullAndNilValueForString(stringData: obj.Local_Area)
                    hourlyReport.Customer_Entity_Type = checkNullAndNilValueForString(stringData: obj.Customer_Entity_Type)
                    
                    if (checkNullAndNilValueForString(stringData: obj.Lattitude) != "")
                    {
                        hourlyReport.Lattitude = Double(obj.Lattitude!)!
                    }
                    
                    if (checkNullAndNilValueForString(stringData: obj.Longitude) != "")
                    {
                        hourlyReport.Longitude = Double(obj.Longitude!)!
                    }
                    
                    hourlyReport.Doctor_Region_Code = obj.Doctor_Region_Code!
                    
                    var visitTime = checkNullAndNilValueForString(stringData: obj.Visit_Time)
                   
                    if visitTime.contains("pm PM")
                    {
                        let visitTimeArray = visitTime.components(separatedBy: " ")
                        visitTime = visitTimeArray[0]
                    }
                    if (visitTime != EMPTY)
                    {
                        let time = visitTime.components(separatedBy: ":")
                        if(Int(time[0])! <= 12)
                        {
                            if (visitTime.range(of:"PM") == nil && visitTime.range(of:"pm") == nil)  && (visitTime.range(of:"AM") == nil && visitTime.range(of:"am") == nil)
                            {
                                visitTime = visitTime + " " + obj.Visit_Mode.uppercased()
                            }
                        }
                        
                        let dcrDate = convertDateIntoString(dateString: obj.DCR_Actual_Date)
                        let date = convertDateIntoString(date: dcrDate)
                        let TwentyFourHrTime =  convert12HrTo24Hr(timeString: visitTime)
                        let enteredDateTime = date + " " + visitTime
                        
                        hourlyReport.Entered_DateTime = enteredDateTime
                        hourlyReport.Time = getDateAndTimeInFormat(dateString: obj.DCR_Actual_Date + " " + TwentyFourHrTime + ".00.000")
                    }
                    else
                    {
                        hourlyReport.Entered_DateTime = NOT_APPLICABLE
                        hourlyReport.Time = nil
                    }
                    
                    // hourlyReport.Time = obj.Visit_Time
                    
                    self.hourlyReportList.append(hourlyReport)
                }
            }
        }
        else
        {
            if (reportList.count > 0)
            {
                
                for obj in reportList
                {
                    self.hourlyReportList.append(HourlyReportDoctorVisitModel.init(dict: obj as! NSDictionary))
                }
            }
        }
        
        var sortedArray : [HourlyReportDoctorVisitModel] = []
        let count = self.hourlyReportList.count
        
        if (count > 0)
        {
            for i in 0..<count
            {
                let obj = self.hourlyReportList[i]
                
                if obj.Doctor_Code != EMPTY
                {
                    let filteredArray =  sortedArray.filter {
                        return obj.Doctor_Code == $0.Doctor_Code  && obj.Doctor_Region_Code == $0.Doctor_Region_Code
                    }
                    
                    if filteredArray.count == 0
                    {
                        sortedArray.append(obj)
                    }
                }
                else
                {
                    let filteredArray = sortedArray.filter{
                        return obj.Doctor_Name == $0.Doctor_Name && obj.Speciality_Name == $0.Speciality_Name
                    }
                    
                    if filteredArray.count == 0
                    {
                        sortedArray.append(obj)
                    }
                }
            }
        }
        
        doctorListWithLocations = self.hourlyReportList.filter{
            $0.Lattitude != 0.0 && $0.Longitude != 0.0
        }
        
        if (sortedArray.count > 0)
        {
            sortedArray.sort(by: { (obj1, obj2) -> Bool in
                obj1.Doctor_Name < obj2.Doctor_Name
            })
            
            var sectionArray: [Character] = []
            
            for objDV in sortedArray
            {
                let firstLetter = objDV.Doctor_Name.uppercased().first!
                
                if (!sectionArray.contains(firstLetter))
                {
                    sectionArray.append(firstLetter)
                }
            }
            
            for char in sectionArray
            {
                let filteredArray = sortedArray.filter{
                    $0.Doctor_Name.uppercased().first == char
                }
                
                let dataDict: NSDictionary = [sectionTitleKeyName: String(char), dataKeyName: filteredArray]
                
                dataArray.append(dataDict)
            }
        }
        
        if(doctorListWithLocations.count == 0)
        {
            viewMapHeightConstraint.constant = 0
            viewOnMapsButton.isHidden = true
        }
        else
        {
            viewMapHeightConstraint.constant = 50
            viewOnMapsButton.isHidden = false
        }
        
        if dataArray.count > 0
        {
            reloadTableView()
            self.emptyStateLbl.text = ""
        }
        else
        {
            self.reloadTableView()
            self.emptyStateLbl.text = "No \(titleStr) list."
        }
    }
    
    private func reloadTableView()
    {
        tableView.reloadData()
    }
    
    //MARK:- Table View Delegates
    func numberOfSections(in tableView: UITableView) -> Int
    {
        
        if (dataArray.count > 0){
            
        }else{
            self.emptyStateLbl.text = "No \(titleStr) list."
            viewOnMapsButton.isHidden = true
        }
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HourlyReportTableViewCell
        let dict: NSDictionary = self.dataArray[section]
        
        cell.selectionView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        cell.sectionTitleLabel.text = dict.value(forKey: sectionTitleKeyName) as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let dict: NSDictionary = self.dataArray[section]
        let dataArray = dict.value(forKey: dataKeyName) as! [DCRDoctorVisitModel]
        
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell") as! HourlyReportTableViewCell
        
        let dict: NSDictionary = self.dataArray[indexPath.section]
        let dataArray = dict.value(forKey: dataKeyName) as! [HourlyReportDoctorVisitModel]
        let objDoctorVisit = dataArray[indexPath.row]
        
        cell.doctorNameLabel.text = objDoctorVisit.Doctor_Name
        if((objDoctorVisit.Entered_DateTime == "N/A") || (objDoctorVisit.Entered_DateTime == EMPTY) || (objDoctorVisit.Entered_DateTime == "N/A"))
        {
            cell.visitDateAndTimeLbl.text = ""
        }
        else
        {
            let getTime = objDoctorVisit.Entered_DateTime.components(separatedBy: " ")
            cell.visitDateAndTimeLbl.text = getTime[getTime.count - 2] + getTime[getTime.count - 1]
        }
        var detailText: String = EMPTY
        let mdlNumber = checkNullAndNilValueForString(stringData: objDoctorVisit.MDL_Number)
        let spltyName = checkNullAndNilValueForString(stringData: objDoctorVisit.Speciality_Name)
        let categoryName = checkNullAndNilValueForString(stringData: objDoctorVisit.Category_Name)
        let localArea = checkNullAndNilValueForString(stringData: objDoctorVisit.Local_Area)
        let regionName = checkNullAndNilValueForString(stringData: objDoctorVisit.Doctor_Region_Name)
        
        if (mdlNumber != EMPTY)
        {
            detailText = mdlNumber
        }
        
        if (detailText != EMPTY && spltyName != EMPTY)
        {
            detailText = detailText + " | " + spltyName
        }
        else if (detailText == EMPTY && spltyName != EMPTY)
        {
            detailText = spltyName
        }
        
        if (categoryName != EMPTY)
        {
            detailText = detailText + " | " + categoryName
        }
        
        if (localArea != EMPTY)
        {
            detailText = detailText + " | " + localArea
        }
        
        if (regionName != EMPTY)
        {
            detailText = detailText + " | " + regionName
        }
        
//        if (objDoctorVisit.Entered_DateTime != EMPTY)
//        {
//            detailText = detailText + " | " + objDoctorVisit.Entered_DateTime
//        }
        
        cell.detailLabel.text = detailText
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let sbHoulyReport = UIStoryboard(name: Constants.StoaryBoardNames.HourlyReportSb, bundle: nil)
        let vcDoctorDetails = sbHoulyReport.instantiateViewController(withIdentifier: Constants.ViewControllerNames.HourlyReportDoctorDetailVcID) as! ShowHourlyReportDetailViewController
        let dict: NSDictionary = self.dataArray[indexPath.section]
        let dataArray = dict.value(forKey: dataKeyName) as! [HourlyReportDoctorVisitModel]
        let objDoctorVisit = dataArray[indexPath.row]
        
        let filteredArray = self.hourlyReportList.filter{
            if (checkNullAndNilValueForString(stringData: objDoctorVisit.Doctor_Code) != EMPTY)
            {
                return $0.Doctor_Code == objDoctorVisit.Doctor_Code && $0.Doctor_Region_Code == objDoctorVisit.Doctor_Region_Code
            }
            else
            {
               return  $0.Doctor_Name == objDoctorVisit.Doctor_Name && $0.Speciality_Name == objDoctorVisit.Speciality_Name
            }
        }
        
        vcDoctorDetails.selectedEmployeeName = self.selectedEmployeeName
        vcDoctorDetails.objDoctorVisit = objDoctorVisit
        vcDoctorDetails.hourlyReportList = filteredArray
        vcDoctorDetails.selectedDate = self.selectedDate
        vcDoctorDetails.isComingFromGeo = self.isComingFromGeo
        
        self.navigationController?.pushViewController(vcDoctorDetails, animated: true)
    }
    @IBAction func viweMapButton(_ sender: Any) {
        let sb = UIStoryboard(name: Constants.StoaryBoardNames.HourlyReportSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.HourlyReportGoogleMapViewVc) as! HourlyReportGoogleMapViewController
        vc.doctorListWithLocations = self.doctorListWithLocations
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func addFilterBtn()
    {
        attachBut = UIBarButtonItem(image: UIImage(named: "icon-filter"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(showActionSheet))
        
        self.navigationItem.rightBarButtonItems = [attachBut]
    }
    
    @objc func showActionSheet()
    {
        
        let alertController = UIAlertController(title: "Choose Option", message: "", preferredStyle: .actionSheet)
        
        let allAction = UIAlertAction(title: "All", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.titleStr = "All"
            self.title = "\(self.titleStr) - \(self.visitDateString)"
            self.dataArray = []
            if self.isComingFromGeo
            {
                self.geoDoctorList = self.geoAllList
                self.getHourlyReportDetails()
            }
            else
            {
                self.prepareDataArray(reportList: self.allArray)
            }
        })
        let customerVisitAction = UIAlertAction(title: "\(appDoctor)", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.titleStr = appDoctor
            self.title = "\(self.titleStr) - \(self.visitDateString)"
            self.dataArray = []
            if self.isComingFromGeo
            {
                self.geoDoctorList = self.geoCustomerList
                self.getHourlyReportDetails()
            }
            else
            {
                self.prepareDataArray(reportList: self.filteredCustomerArray)
            }
        })
        let chemistVisitAction = UIAlertAction(title: "\(appChemist)", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.titleStr = appChemist
             self.title = "\(self.titleStr) - \(self.visitDateString)"
            self.dataArray = []
            if self.isComingFromGeo
            {
                self.geoDoctorList = self.geoChemistList
                self.getHourlyReportDetails()
            }
            else
            {
                self.prepareDataArray(reportList: self.filteredChemistArray)
            }
        })
        
        let StockistVisitAction = UIAlertAction(title: "Stockist", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.titleStr = "Stockist"
            self.title = "Stockist - \(self.visitDateString)"
            self.dataArray = []
            if self.isComingFromGeo
            {
                self.geoDoctorList = self.geoStockistList
                self.getHourlyReportDetails()
            }
            else
            {
                self.prepareDataArray(reportList: self.filteredStockistArray)
            }
        })
        
        alertController.addAction(allAction)
        alertController.addAction(customerVisitAction)
        alertController.addAction(chemistVisitAction)
        alertController.addAction(StockistVisitAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
}
