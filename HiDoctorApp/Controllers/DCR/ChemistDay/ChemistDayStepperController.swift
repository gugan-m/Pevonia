//
//  ChemistDayStepperController.swift
//  HiDoctorApp
//
//  Created by Vijay on 22/11/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class ChemistDayStepperController: UIViewController,UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var contentViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var saveDoctorView: UIView!
    @IBOutlet weak var doctorDetail: UILabel!
    @IBOutlet weak var doctorVisitDate: UILabel!
    @IBOutlet weak var tableviewBtmConst: NSLayoutConstraint!
    @IBOutlet weak var saveBtnHeightConst: NSLayoutConstraint!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var eDetailingButton: UIButton!
    @IBOutlet weak var eDetailingWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var eDetailingView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var eDetailingViewHeightConstraint: NSLayoutConstraint!
    
    
    var stepperIndex: DoctorVisitStepperIndex!
    var customerMasterModel:CustomerMasterModel!
    var flexiSpecialityName : String = ""
    var flexiChemistName : String = ""
    var isFromModify: Bool = false
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        addCustomBackButtonToNavigationBar()
        if !isFromModify
        {
            setChemistDetail()
            BL_Common_Stepper.sharedInstance.isModify = false
        }
        else
        {
            BL_Common_Stepper.sharedInstance.isModify = true
        }
        
        setDefaults()
        setChemistDayStepper()
        BL_Common_Stepper.sharedInstance.skipFromController = [Bool](repeating: false, count: BL_Common_Stepper.sharedInstance.dynmicOrderData.count)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.stepperUpdate()
        stepperIndex = BL_Common_Stepper.sharedInstance.stepperIndex
        
        self.saveDoctorButtonVisiblity()
        self.loadTableView()
        self.reloadTableView()
    }
    func stepperUpdate()
    {
        BL_Common_Stepper.sharedInstance.dynamicArrayValue = 0
        BL_Common_Stepper.sharedInstance.showAddButton = 0
        BL_Common_Stepper.sharedInstance.generateDataArray()
        BL_Common_Stepper.sharedInstance.updateStepperButtonStatus()
    }
    func setChemistDetail()
    {
        
        ChemistDay.sharedInstance.customerId = customerMasterModel.Customer_Id
        ChemistDay.sharedInstance.customerName = customerMasterModel.Customer_Name
        ChemistDay.sharedInstance.customerCode = customerMasterModel.Customer_Code
        ChemistDay.sharedInstance.regionCode = customerMasterModel.Region_Code
        ChemistDay.sharedInstance.regionName = customerMasterModel.Region_Name
        ChemistDay.sharedInstance.localArea = customerMasterModel.Local_Area
        DCRModel.sharedInstance.customerEntityType = Constants.CustomerEntityType.chemist
        ChemistDay.sharedInstance.SpecialityName = customerMasterModel.Speciality_Name
        DCRModel.sharedInstance.customerEntityType = Constants.CustomerEntityType.chemist
        
        
        
    }
    func setChemistDayStepper()
    {
       var chemistStepperString = Constants.ChemistDayCaptureValue.visit + "," +  BL_Common_Stepper.sharedInstance.getChemistDayCaptureValue()
        chemistStepperString = chemistStepperString.replacingOccurrences(of: " ", with: "")
        
        BL_Common_Stepper.sharedInstance.dynmicOrderData = chemistStepperString.components(separatedBy: ",")
    }
    func setDefaults()
    {
        if ChemistDay.sharedInstance.customerCode == ""
        {
            flexiChemistName = customerMasterModel.Customer_Name
            self.navigationItem.title = String(format: "%@", customerMasterModel.Customer_Name)
            ChemistDay.sharedInstance.customerName = flexiChemistName
            if !isFromModify
            {
            ChemistDay.sharedInstance.chemistVisitId = 0
            }
        }
        else
        {
            self.navigationItem.title = String(format: "%@", ChemistDay.sharedInstance.customerName)
            ChemistDay.sharedInstance.customerName = customerMasterModel.Customer_Name
        }
        
        //        let suffixConfigVal = BL_Common_Stepper.sharedInstance.getDoctorSuffixColumnName()
        var detailText : String = ""
        
        if ChemistDay.sharedInstance.customerCode == ""
        {
            let userObj = getUserModelObj()
            doctorDetail.text = String(format: "%@",(userObj?.Region_Name)!)
            ChemistDay.sharedInstance.SpecialityName = flexiSpecialityName
        }
        else
        {
            if customerMasterModel.MDL_Number != ""
            {
                var titleString = "\(customerMasterModel.MDL_Number!) "
                if(customerMasterModel.Category_Name! != EMPTY && customerMasterModel.Category_Name! != "NA")
                {
                    titleString += "| \(customerMasterModel.Category_Name!) "
                }
                if(customerMasterModel.Region_Name! != EMPTY && customerMasterModel.Region_Name! != "NA")
                {
                    titleString += "| \(customerMasterModel.Region_Name!) "
                }
                
                detailText = titleString
            }
            else
            {
                var titleString = String()
                if(customerMasterModel.Category_Name! != EMPTY)
                {
                    titleString += " \(customerMasterModel.Category_Name!) "
                }
                if(customerMasterModel.Region_Name! != EMPTY)
                {
                    titleString += "| \(customerMasterModel.Region_Name!) "
                }
                if(customerMasterModel.Region_Name! != EMPTY)
                {
                    titleString += "| \(customerMasterModel.Local_Area!) "
                }
                if(titleString.contains("|"))
                {
                    titleString =  titleString.trimFirstIndex
                }
                detailText = titleString
            }
            
            //            if suffixConfigVal.contains(ConfigValues.SUR_NAME.rawValue) && customerMasterModel.Sur_Name != ""
            //            {
            //                detailText = String(format: "%@ | %@", detailText, customerMasterModel.Sur_Name!)
            //            }
            //
            //            if suffixConfigVal.contains(ConfigValues.LOCAL_AREA.rawValue) && customerMasterModel.Local_Area != ""
            //            {
            //                detailText = String(format: "%@ | %@", detailText, customerMasterModel.Local_Area!)
            //            }
            
            doctorDetail.text = detailText
            
        }
        
        let dcrDateVal = convertDateIntoString(date: DCRModel.sharedInstance.dcrDate)
        doctorVisitDate.text = String(format: "Date: %@", dcrDateVal)
        
        saveBtn.setTitle("SAVE \(appChemist.uppercased()) VISIT", for: .normal)
        
        toggleEDetailingButton()
        
    }
    
    
    // MARK:-- EDetailing enable disable functions
    private func toggleEDetailingButton()
    {
        hideEDetailingButon()
        
        if (BL_Common_Stepper.sharedInstance.geteDetailingConfigVal().uppercased() == PrivilegeValues.YES.rawValue.uppercased())
        {
            if (DCRModel.sharedInstance.dcrDateString == getServerFormattedDateString(date: getCurrentDateAndTime()))
            {
                if (ChemistDay.sharedInstance.customerCode != EMPTY)
                {
                   // showEDetailingButton()
                }
            }
        }
    }
    
    private func showEDetailingButton()
    {
        eDetailingButton.isHidden = false
        eDetailingView.isHidden = false
        eDetailingWidthConstraint.constant = 200
        doctorVisitDate.isHidden = true
        
        var buttonHeight: CGFloat = 60
        
        if SwifterSwift().isPhone
        {
            buttonHeight = 40
        }
        
        eDetailingViewHeightConstraint.constant = buttonHeight
        
        let height = CGFloat(8 + getDetailLabelHeight() + 12 + buttonHeight + 12)
        
        headerViewHeightConstraint.constant = height
    }
    
    private func hideEDetailingButon()
    {
        eDetailingButton.isHidden = true
        eDetailingView.isHidden = true
        eDetailingWidthConstraint.constant = 0
        doctorVisitDate.isHidden = false
        
        let height = CGFloat(8 + getDetailLabelHeight() + 12 + 14 + 12)
        
        eDetailingViewHeightConstraint.constant = 0
        headerViewHeightConstraint.constant = height
    }
    
    private func getDetailLabelHeight() -> CGFloat
    {
        let height = getTextSize(text: doctorDetail.text, fontName: fontRegular, fontSize: 14, constrainedWidth: SCREEN_WIDTH - 32).height
        return height
    }
    
    // MARK:-- Load Tableview cell from xib
    func loadTableView()
    {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: Constants.NibNames.StepperTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.TableViewCellIdentifier.StepperMainCell)
        
    }
    
    @IBAction func saveDoctorAction(_ sender: AnyObject)
    {
        
        let chemistObj = DBHelper.sharedInstance.getChemistDayVisitsForDCRIdAndVisitId(dcrId: getDCRId(),chemistDayVisitId: ChemistDay.sharedInstance.chemistVisitId)?[0]
        if chemistObj != nil
        {
            let statusMsg = BL_Common_Stepper.sharedInstance.doAllCustomerValidationsForChemistObj(chemistObj: chemistObj!)
            if statusMsg != EMPTY
            {
                AlertView.showAlertView(title: alertTitle, message: statusMsg, viewController: self)
            }
            else
            {
                _ = navigationController?.popViewController(animated: false)
            }
        }
    }
    
    @IBAction func eDetailingAction()
    {
        
    }
    
    // MARK:-- Back button and navigation bar function
    private func addCustomBackButtonToNavigationBar()
    {
        let backButton = UIButton(type: UIButtonType.custom)
        
        backButton.addTarget(self, action: #selector(self.backButtonClicked), for: UIControlEvents.touchUpInside)
        backButton.setImage(UIImage(named: "navigation-arrow"), for: .normal)
        backButton.sizeToFit()
        
        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func backButtonClicked()
    {
        _ = navigationController?.popViewController(animated: false)
    }
    
    
    // MARK:-- Tableview Delegate
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return BL_Common_Stepper.sharedInstance.stepperDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.StepperMainCell) as! ChemistDayStepperMain
        
        
        // Round View
        cell.roundView.layer.cornerRadius = 12.5 //cell.roundView.frame.height / 2
        cell.roundView.layer.masksToBounds = true
        cell.stepperNumberLabel.text = String(indexPath.row + 1)
        
        // Vertical view
        cell.verticalView.isHidden = false
        if (indexPath.row == BL_Common_Stepper.sharedInstance.stepperDataList.count - 1)
        {
            cell.verticalView.isHidden = true
        }
        
        let rowIndex = indexPath.row
        
        let objStepperModel: DCRStepperModel = BL_Common_Stepper.sharedInstance.stepperDataList[rowIndex]
        
        cell.selectedIndex = rowIndex
        
        cell.cardView.isHidden = true
        cell.emptyStateView.isHidden = true
        cell.emptyStateView.clipsToBounds = true
        
        cell.accompEmptyStateView.isHidden = true
        
        if (objStepperModel.recordCount == 0)
        {
            cell.emptyStateSectionTitleLabel.text = objStepperModel.emptyStateTitle
            cell.emptyStateSubTitleLabel.text = objStepperModel.emptyStateSubTitle
            
            cell.sectionTitleLabel.text = objStepperModel.sectionTitle
            
            if (rowIndex == stepperIndex.accompanistIndex && stepperIndex.accompanistIndex != 0)
            {
                cell.emptyStateAddButton.isHidden = true
                cell.emptyStateSkipButton.isHidden = true
                if objStepperModel.showEmptyStateAddButton == true
                {
                    cell.emptyStateView.isHidden = true
                    cell.cardView.isHidden = false
                    cell.cardView.clipsToBounds = false
                    
                    cell.accompEmptyStateView.isHidden = false
                    cell.accompEmptyLbl.text = "No Ride Along available"
                    
                    if cell.parentTableView != nil
                    {
                        cell.parentTableView = tableView
                        cell.parentTableView.isHidden = false
                        cell.childTableView.reloadData()
                    }
                }
                else
                {
                    cell.parentTableView = tableView
                    cell.childTableView.reloadData()
                    cell.emptyStateView.isHidden = false
                    cell.cardView.isHidden = true
                    cell.cardView.clipsToBounds = true
                }
            }
            else
            {
                if(BL_Common_Stepper.sharedInstance.stepperDataList.count-1 == indexPath.row)
                {
                    cell.emptyStateAddButton.isHidden = !objStepperModel.showEmptyStateAddButton
                    cell.emptyStateSkipButton.isHidden = true
                }
                else
                {
                cell.emptyStateAddButton.isHidden = !objStepperModel.showEmptyStateAddButton
                cell.emptyStateSkipButton.isHidden = !objStepperModel.showEmptyStateSkipButton
                }
                
                cell.parentTableView = tableView
                cell.childTableView.reloadData()
                cell.emptyStateView.isHidden = false
                cell.cardView.isHidden = true
                cell.cardView.clipsToBounds = true
            }
            
            if objStepperModel.showEmptyStateAddButton == true
            {
                cell.roundView.backgroundColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1)
            }
            else
            {
                cell.roundView.backgroundColor = UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1)
            }
        }
        else
        {
            cell.sectionTitleLabel.text = objStepperModel.sectionTitle
            
            cell.emptyStateView.isHidden = true
            cell.cardView.isHidden = false
            cell.cardView.clipsToBounds = false
            
            cell.rightButton.isHidden = !objStepperModel.showRightButton
            cell.leftButton.isHidden = !objStepperModel.showLeftButton
            
            cell.parentTableView = tableView
            cell.childTableView.reloadData()
            
            cell.roundView.backgroundColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1)
            
            cell.leftButton.setTitle(objStepperModel.leftButtonTitle, for: UIControlState.normal)
        }
        
        cell.sectionTitleImageView.image = UIImage(named: objStepperModel.sectionIconName)
        
        if rowIndex == stepperIndex.doctorVisitIndex && objStepperModel.recordCount > 0
        {
            cell.sectionToggleImageView.isHidden = false
        }
        else
        {
            cell.sectionToggleImageView.isHidden = true
        }
        cell.sectionToggleImageView.clipsToBounds = true
        
        var checkRecordCount = 0
        
        if rowIndex == stepperIndex.doctorVisitIndex
        {
            checkRecordCount = 0
        }
        else
        {
            checkRecordCount = 1
        }
        
        if (objStepperModel.recordCount > checkRecordCount)
        {
            if rowIndex == stepperIndex.accompanistIndex || rowIndex == stepperIndex.detailedProduct
            {
                cell.sectionToggleImageView.isHidden = true
            }
            else
            {
                if (objStepperModel.isExpanded == true)
                {
                    cell.sectionToggleImageView.image = UIImage(named: "icon-stepper-up-arrow")
                }
                else
                {
                    cell.sectionToggleImageView.image = UIImage(named: "icon-stepper-down-arrow")
                }
                
                cell.sectionToggleImageView.isHidden = false
                cell.sectionToggleImageView.clipsToBounds = false
            }
        }
        
        cell.moreView.isHidden = true
        cell.moreView.clipsToBounds = true
        cell.moreViewHeightConstraint.constant = 0
        cell.buttonViewHeight.constant = 60
        
        if rowIndex == stepperIndex.accompanistIndex || rowIndex == stepperIndex.detailedProduct
        {
            cell.moreView.isHidden = true
            cell.moreViewHeightConstraint.constant = 0
            cell.sectionCoverButton.isHidden = true
            cell.coverBtnWidthConst.constant = 0.0
            if rowIndex == stepperIndex.accompanistIndex
            {
                cell.buttonViewHeight.constant = 0
                cell.leftButton.isHidden = true
                cell.rightButton.isHidden = true
            }
            else if rowIndex == stepperIndex.detailedProduct
            {
                cell.buttonViewHeight.constant = 40
                cell.leftButton.isHidden = false
                cell.rightButton.isHidden = false
            }
        }
        else
        {
            cell.leftButton.isHidden = false
            cell.rightButton.isHidden = false
            
            cell.sectionCoverButton.isHidden = false
            cell.coverBtnWidthConst.constant = SCREEN_WIDTH - 56.0
            if (objStepperModel.isExpanded == false && objStepperModel.recordCount > checkRecordCount)
            {
                cell.moreView.isHidden = false
                cell.moreView.clipsToBounds = false
                cell.moreViewHeightConstraint.constant = 20
            }
            else
            {
                cell.buttonViewHeight.constant = 40
            }
        }
        
        if (stepperIndex.assetIndex != 0 && rowIndex == stepperIndex.assetIndex)
        {
            if (objStepperModel.isExpanded == false && objStepperModel.recordCount > checkRecordCount)
            {
                cell.buttonViewHeight.constant = 20
                cell.moreViewHeightConstraint.constant = 20
            }
            else
            {
                cell.buttonViewHeight.constant = 0
                cell.moreViewHeightConstraint.constant = 0
            }
            
            cell.btmSepView.isHidden = true
            cell.leftButton.isHidden = true
            cell.rightButton.isHidden = true
        }
        
        cell.sectionCoverButton.tag = rowIndex
        cell.leftButton.tag = rowIndex
        cell.rightButton.tag = rowIndex
        cell.emptyStateAddButton.tag = rowIndex
        cell.emptyStateSkipButton.tag = rowIndex
        cell.emptyStateAddButton.addTarget(self, action: #selector(emptyStateAddButton(button:)), for: .touchUpInside)
        cell.emptyStateSkipButton.addTarget(self, action: #selector(emptyStateSkipButton(button:)), for: .touchUpInside)
        cell.sectionCoverButton.addTarget(self, action: #selector(coverButton(button:)), for: .touchUpInside)
        cell.leftButton.addTarget(self, action: #selector(emptyStateAddButton(button:)), for: .touchUpInside)
        cell.rightButton.addTarget(self, action: #selector(modifyAction(button:)), for: .touchUpInside)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let stepperObj = BL_Common_Stepper.sharedInstance.stepperDataList[indexPath.row]
        let index = indexPath.row
        
        if (stepperObj.recordCount == 0)
        {
            return BL_Common_Stepper.sharedInstance.getEmptyStateHeight(selectedIndex: index)
        }
            
        else
        {
            if index == stepperIndex.doctorVisitIndex
            {
                return BL_Common_Stepper.sharedInstance.getDoctorVisitDetailHeight(selectedIndex: index)
            }
                
            else if index == stepperIndex.accompanistIndex
            {
                return BL_Common_Stepper.sharedInstance.getAccompanistCellHeight(selectedIndex: index)
            }
                
            else if index == stepperIndex.chemistIndex || index == stepperIndex.followUpIndex || index == stepperIndex.pobIndex || index == stepperIndex.rcpaDetailIndex
            {
                return BL_Common_Stepper.sharedInstance.getDoctorVisitSampleHeight(selectedIndex: index)
            }
            else if index == stepperIndex.sampleIndex
            {
                return BL_Common_Stepper.sharedInstance.getSampleBatchHeight(selectedIndex: index)
            }
            else if index == stepperIndex.detailedProduct || index == stepperIndex.attachmentIndex
            {
                return BL_Common_Stepper.sharedInstance.getCommonCellHeight(selectedIndex: index)
            }
            else if (stepperIndex.assetIndex != 0 && index == stepperIndex.assetIndex)
            {
                return BL_Common_Stepper.sharedInstance.getAssetCellHeight(selectedIndex: index)
            }
                
            else
            {
                return 0
            }
        }
    }
    
    // MARK:-- Reload Functions
    private func reloadTableView()
    {
        tableView.reloadData()
    }
    
    private func reloadTableViewAtIndexPath(index: Int)
    {
        
        if(BL_Common_Stepper.sharedInstance.stepperDataList.count - 1 > index)
        {
            let indexPath: NSIndexPath = NSIndexPath(row: index, section: 0)
            tableView.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.fade)
        }
    }
    
    // MARK:-- Submit button show hide
    private func saveDoctorButtonVisiblity()
    {
        let doctorVisitCount = BL_Common_Stepper.sharedInstance.chemistVisitList
        if doctorVisitCount.count > 0
        {
            saveDoctorView.isHidden = false
            saveBtnHeightConst.constant = 40.0
        }
        else
        {
            saveDoctorView.isHidden = true
            saveBtnHeightConst.constant = 0
        }
    }
    
    @objc func coverButton(button: UIButton)
    {
        let index = button.tag
        if index != stepperIndex.attachmentIndex || index != stepperIndex.detailedProduct
        {
            let stepperObj = BL_Common_Stepper.sharedInstance.stepperDataList[index]
            
            if index == stepperIndex.doctorVisitIndex
            {
                if (stepperObj.recordCount > 0)
                {
                    stepperObj.isExpanded = !stepperObj.isExpanded
                    reloadTableViewAtIndexPath(index: index)
                }
            }
            else
            {
                if (stepperObj.recordCount > 1)
                {
                    stepperObj.isExpanded = !stepperObj.isExpanded
                    reloadTableViewAtIndexPath(index: index)
                }
                else if(index == stepperIndex.sampleIndex)
                {
                    stepperObj.isExpanded = !stepperObj.isExpanded
                    reloadTableViewAtIndexPath(index: index)
                }
            }
        }
        
    }
    
    @objc func emptyStateSkipButton(button: UIButton){
        
        
        
        switch button.tag
        {
        case stepperIndex.doctorVisitIndex:
            if ChemistDay.sharedInstance.customerCode == ""
            {
                var visitTime: String = EMPTY
                var visitMode: String = AM
                visitTime = self.getServerTime()
                visitMode = self.getVisitModeType(visitTime: visitTime)
                
                var isCurrentDate: Bool = false
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                
                if dateFormatter.string(from: DCRModel.sharedInstance.dcrDate) == dateFormatter.string(from: Date())
                    
                    //if DCRModel.sharedInstance.dcrDate == Date()
                {
                    isCurrentDate = true
                }
                
                if BL_DCR_Doctor_Visit.sharedInstance.isGeoLocationMandatory() && BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled() && isCurrentDate
                {
                    if(checkInternetConnectivity())
                    {
                        let postData: NSMutableArray = []
                        let userObj = getUserModelObj()
                        var latitudedeValue = "0.0"
                        var longitudeValue = "0.0"
                        if getLatitude() != EMPTY
                        {
                            latitudedeValue = getLatitude()
                        }
                        if getLongitude() != EMPTY
                        {
                            longitudeValue = getLongitude()
                        }
                        
                        let dict:[String:Any] = ["companyCode":getCompanyCode(),"userCode":getUserCode(),"Doctor_Code": EMPTY,"Doctor_Name":flexiChemistName,"regionCode":userObj?.Region_Code ?? EMPTY,"Speciality_Name":flexiSpecialityName,"Category_Code": EMPTY,"MDL_Number":EMPTY,"DCR_Actual_Date":DCRModel.sharedInstance.dcrDateString,"Doctor_Visit_Date_Time":DCRModel.sharedInstance.dcrDateString + " " + visitTime,"Lattitude":latitudedeValue,"Longitude":longitudeValue,"Modified_Entity":0,"Doctor_Region_Code":userObj?.Region_Code ?? EMPTY,"Customer_Entity_Type":"C","Source_Of_Entry":"iOS"]
                        
                        postData.add(dict)
                        
                        showCustomActivityIndicatorView(loadingText: "Loading...")
                        
                        WebServiceHelper.sharedInstance.sendHourlyReport(postData: postData, completion: { (apiObj) in
                            if(apiObj.Status == SERVER_SUCCESS_CODE)
                            {
                                removeCustomActivityView()
                                let getVisitDetails = apiObj.list[0] as! NSDictionary
                                let getVisitTime = getVisitDetails.value(forKey: "Synced_DateTime") as! String
                                var dateTimeArray = getVisitTime.components(separatedBy: " ")
                                let originalDate = convertDateIntoString(dateString: dateTimeArray[0])
                                let compare = NSCalendar.current.compare(originalDate, to: DCRModel.sharedInstance.dcrDate, toGranularity: .day)
                                if(compare == .orderedSame)
                                {
                                    let visitTimeArray = dateTimeArray[1].components(separatedBy: ":")
                                    let visitTime = visitTimeArray[0] + ":" + visitTimeArray[1]
                                    let userObj = getUserModelObj()
                                    
                                    BL_Common_Stepper.sharedInstance.saveFlexiChemistVisitDetails(chemistName: self.flexiChemistName, specialityName: self.flexiSpecialityName, visitTime: visitTime, visitMode: dateTimeArray[2], remarks:EMPTY, regionCode: userObj?.Region_Code, viewController: self)
                                    self.skipChemit(tag:button.tag)
                                    // self.skipDoctor(index:index)
                                }
                                else if(compare == .orderedDescending)
                                {
                                    visitTime = self.getServerTime()
                                    visitMode = self.getVisitModeType(visitTime: visitTime)
                                    let userObj = getUserModelObj()
                                    BL_Common_Stepper.sharedInstance.saveFlexiChemistVisitDetails(chemistName: self.flexiChemistName, specialityName: self.flexiSpecialityName, visitTime: visitTime, visitMode: visitMode, remarks:EMPTY, regionCode: userObj?.Region_Code, viewController: self)
                                    self.skipChemit(tag:button.tag)
                                    // self.skipDoctor(index:index)
                                }
                                else
                                {
                                    AlertView.showAlertView(title: alertTitle, message: "DVR Date is not a current date", viewController: self)
                                }
                            }
                            else
                            {
                                removeCustomActivityView()
                                AlertView.showAlertView(title: alertTitle, message: apiObj.Message, viewController: self)
                            }
                            
                            
                            
                            // visitTime = getServerTime()
                            //visitMode = getVisitModeType(visitTime: visitTime)
                        })
                        
                        //    let userObj = getUserModelObj()
                        //   BL_DCR_Doctor_Visit.sharedInstance.saveFlexiDoctorVisitDetails(doctorName: flexiDoctorName, specialityName: flexiSpecialityName, visitTime: visitTime, visitMode: visitMode, pobAmount: 0.0, remarks: EMPTY, regionCode: userObj?.Region_Code, viewController: self, businessStatusId: 0, businessStatusName: EMPTY, objCallObjective: nil)
                        
                    }
                    else
                    {
                        AlertView.showAlertView(title: internetOfflineTitle, message: internetOfflineMessage + " to save \(appDoctor)", viewController: self)
                    }
                }
                else
                {
                    let userObj = getUserModelObj()
                   BL_Common_Stepper.sharedInstance.saveFlexiChemistVisitDetails(chemistName: self.flexiChemistName, specialityName: self.flexiSpecialityName, visitTime: EMPTY, visitMode: AM, remarks:EMPTY, regionCode: userObj?.Region_Code, viewController: self)
                    self.skipChemit(tag:button.tag)
                }
            }
            else
            {
                var visitTime: String = EMPTY
                var visitMode: String = AM
                
                var isCurrentDate: Bool = false
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                
                if dateFormatter.string(from: DCRModel.sharedInstance.dcrDate) == dateFormatter.string(from: Date())
                    
                    //if DCRModel.sharedInstance.dcrDate == Date()
                {
                    isCurrentDate = true
                }
                
                if BL_DCR_Doctor_Visit.sharedInstance.isGeoLocationMandatory() && BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled() && isCurrentDate
                {
                    if(checkInternetConnectivity())
                    {
                        let postData: NSMutableArray = []
                        visitTime = self.getServerTime()
                        visitMode = self.getVisitModeType(visitTime: visitTime)
                        
                       
                        var latitudedeValue = "0.0"
                        var longitudeValue = "0.0"
                        if getLatitude() != EMPTY
                        {
                           latitudedeValue = getLatitude()
                        }
                        if getLongitude() != EMPTY
                        {
                            longitudeValue = getLongitude()
                        }
                        let dict:[String:Any] = ["companyCode":getCompanyCode(),"userCode":getUserCode(),"Doctor_Code": customerMasterModel.Customer_Code,"Doctor_Name":customerMasterModel.Customer_Name,"regionCode":customerMasterModel.Region_Code ?? EMPTY,"Speciality_Name":customerMasterModel.Speciality_Name,"Category_Code": customerMasterModel.Category_Name ?? EMPTY,"MDL_Number":customerMasterModel.MDL_Number,"DCR_Actual_Date":DCRModel.sharedInstance.dcrDateString,"Doctor_Visit_Date_Time":DCRModel.sharedInstance.dcrDateString + " " + visitTime,"Lattitude":latitudedeValue,"Longitude":longitudeValue,"Modified_Entity":0,"Doctor_Region_Code":customerMasterModel.Region_Code ?? EMPTY,"Customer_Entity_Type":"C","Source_Of_Entry":"iOS"]
                        
                        postData.add(dict)
                        
                        showCustomActivityIndicatorView(loadingText: "Loading...")
                        
                        WebServiceHelper.sharedInstance.sendHourlyReport(postData: postData, completion: { (apiObj) in
                            if(apiObj.Status == SERVER_SUCCESS_CODE)
                            {
                                removeCustomActivityView()
                                let getVisitDetails = apiObj.list[0] as! NSDictionary
                                let getVisitTime = getVisitDetails.value(forKey: "Synced_DateTime") as! String
                                var dateTimeArray = getVisitTime.components(separatedBy: " ")
                                let originalDate = convertDateIntoString(dateString: dateTimeArray[0])
                                let compare = NSCalendar.current.compare(originalDate, to: DCRModel.sharedInstance.dcrDate, toGranularity: .day)
                                if(compare == .orderedSame)
                                {
                                    let visitTimeArray = dateTimeArray[1].components(separatedBy: ":")
                                    let visitTime = visitTimeArray[0] + ":" + visitTimeArray[1]
                                   
                                     BL_Common_Stepper.sharedInstance.saveChemistVisitDetails(customerCode: ChemistDay.sharedInstance.customerCode, visitTime: visitTime, visitMode: dateTimeArray[2], entityType: "CHEMIST", remarks: EMPTY, regionCode: self.customerMasterModel.Region_Code, viewController: self)
                                    self.skipChemit(tag:button.tag)
                                    // self.skipDoctor(index:index)
                                }
                                else if(compare == .orderedDescending)
                                {
                                    visitTime = self.getServerTime()
                                    visitMode = self.getVisitModeType(visitTime: visitTime)
                                    
                                    BL_Common_Stepper.sharedInstance.saveChemistVisitDetails(customerCode: ChemistDay.sharedInstance.customerCode, visitTime: visitTime, visitMode: visitMode, entityType: "CHEMIST", remarks: EMPTY, regionCode: self.customerMasterModel.Region_Code, viewController: self)
                                    self.skipChemit(tag:button.tag)
                                    // self.skipDoctor(index:index)
                                }
                                else
                                {
                                    AlertView.showAlertView(title: alertTitle, message: "DVR Date is not a current date", viewController: self)
                                }
                            }
                            else
                            {
                                removeCustomActivityView()
                                AlertView.showAlertView(title: alertTitle, message: apiObj.Message, viewController: self)
                            }
                            
                            
                            
                            // visitTime = getServerTime()
                            //visitMode = getVisitModeType(visitTime: visitTime)
                        })
                    }
                }
                else
                {
                    BL_Common_Stepper.sharedInstance.saveChemistVisitDetails(customerCode: ChemistDay.sharedInstance.customerCode, visitTime: EMPTY, visitMode: AM, entityType: "CHEMIST", remarks: EMPTY, regionCode: customerMasterModel.Region_Code, viewController: self)
                    
                    self.skipChemit(tag:button.tag)
                }
            }
            
            
        default:
            
            
            
            print(1)
            if(BL_Common_Stepper.sharedInstance.stepperDataList.count-1 > button.tag)
            {

            BL_Common_Stepper.sharedInstance.skipFromController[button.tag] = true
            }
            self.stepperUpdate()
            reloadTableViewAtIndexPath(index: button.tag)
            reloadTableViewAtIndexPath(index: button.tag+1)
            
            
            if(BL_Common_Stepper.sharedInstance.stepperDataList[button.tag+1].recordCount > 0)
            {
                if(BL_Common_Stepper.sharedInstance.stepperDataList.count-1 > button.tag+2)
                {
                    BL_Common_Stepper.sharedInstance.skipFromController[button.tag+2] = true
                    self.stepperUpdate()
                    reloadTableViewAtIndexPath(index: button.tag+1)
                    reloadTableViewAtIndexPath(index: button.tag+2)
                }
            }
            
            if(button.tag == BL_Common_Stepper.sharedInstance.stepperIndex.accompanistIndex-1)
            {
                BL_Common_Stepper.sharedInstance.stepperDataList[button.tag+2].showEmptyStateAddButton = true
                BL_Common_Stepper.sharedInstance.stepperDataList[button.tag+2].showEmptyStateSkipButton = BL_Common_Stepper.sharedInstance.stepperDataList[button.tag+2].showEmptyStateSkipButton
                self.reloadTableViewAtIndexPath(index: button.tag+2)
            }
           /* BL_Common_Stepper.sharedInstance.stepperDataList[button.tag+1].showEmptyStateAddButton = true
            if(BL_Common_Stepper.sharedInstance.stepperDataList.count > button.tag+1)
            {
                
                BL_Common_Stepper.sharedInstance.stepperDataList[button.tag+1].showEmptyStateSkipButton = BL_Common_Stepper.sharedInstance.showSkipButton[button.tag+1]
                BL_Common_Stepper.sharedInstance.showAddButton += 1
            }
            self.reloadTableViewAtIndexPath(index: button.tag+1)
 */

        }
        
     /*   if(button.tag == BL_Common_Stepper.sharedInstance.stepperIndex.accompanistIndex-1)
        {
            BL_Common_Stepper.sharedInstance.stepperDataList[button.tag+2].showEmptyStateAddButton = true
            BL_Common_Stepper.sharedInstance.stepperDataList[button.tag+2].showEmptyStateSkipButton = BL_Common_Stepper.sharedInstance.showSkipButton[button.tag+2]
            self.reloadTableViewAtIndexPath(index: button.tag+2)
        }
            BL_Common_Stepper.sharedInstance.stepperDataList[button.tag+1].showEmptyStateAddButton = true
        if(BL_Common_Stepper.sharedInstance.stepperDataList.count > button.tag+1)
        {
            
            BL_Common_Stepper.sharedInstance.stepperDataList[button.tag+1].showEmptyStateSkipButton = BL_Common_Stepper.sharedInstance.showSkipButton[button.tag+1]
        BL_Common_Stepper.sharedInstance.showAddButton += 1
        }
            self.reloadTableViewAtIndexPath(index: button.tag+1)
 */
        
    }
    
    
    
    
    func skipChemit(tag:Int)
    {
        saveDoctorView.isHidden = false
        if(tag+1 != stepperIndex.accompanistIndex)
        {
            BL_Common_Stepper.sharedInstance.updateAddSkipButton(index: stepperIndex.doctorVisitIndex+1)
        }
        else
        {
            BL_Common_Stepper.sharedInstance.updateAddSkipButton(index: stepperIndex.doctorVisitIndex+2)
        }
        
        
        //BL_DCR_Chemist_Accompanists.sharedInstance.insertDCRChemistAccompanists(dcrAccompanistList: BL_DCR_Chemist_Accompanists.sharedInstance.getDCRAccompanists())
        BL_DCR_Chemist_Accompanists.sharedInstance.insertDCRChemistAccompanists(dcrAccompanistList: BL_DCR_Chemist_Accompanists.sharedInstance.getDCRAccompanistsVandNA())
        
        self.stepperUpdate()
        
        reloadTableViewAtIndexPath(index: stepperIndex.doctorVisitIndex)
        reloadTableViewAtIndexPath(index: stepperIndex.accompanistIndex)
        if(tag+1 != stepperIndex.accompanistIndex)
        {
            reloadTableViewAtIndexPath(index: stepperIndex.doctorVisitIndex+1)
        }
        else
        {
            reloadTableViewAtIndexPath(index: stepperIndex.doctorVisitIndex+2)
        }
        saveDoctorButtonVisiblity()
    }
// MARK:-- SegmentControl Action
    
    
    // MARK:-- Navigation to other ViewController
    
    @objc func emptyStateAddButton(button: UIButton){
        
        if (button.tag == stepperIndex.doctorVisitIndex )
        {
            navigateToAddDoctorVisit()
        }
        else if (button.tag == stepperIndex.accompanistIndex )
        {
            navigateToAddDoctorAccompanist()
        }
        else if (button.tag == stepperIndex.sampleIndex)
        {
            navigateToChemistSample()
        }
        else if(button.tag == stepperIndex.detailedProduct)
        {
            navigateToAddChemistDetailProduct(isModify: false)
        }
        else if(button.tag == stepperIndex.chemistIndex)
        {
            
        }
        else if(button.tag == stepperIndex.followUpIndex)
        {
            navigateToChemistFollowUp()
        }
        else if(button.tag == stepperIndex.attachmentIndex)
        {
            navigateToAddAttachment()
        }
        else if(button.tag == stepperIndex.pobIndex)
        {
            navigateToAddPOB()
        }
        else if(button.tag == stepperIndex.rcpaDetailIndex)
        {
            navigateToRCPA()
        }
        
    }
    
    @objc func modifyAction(button: UIButton){
        
        if (button.tag == stepperIndex.doctorVisitIndex )
        {
            navigateToEditDoctorVisit()
        }
        else if (button.tag == stepperIndex.accompanistIndex )
        {
            
        }
        else if (button.tag == stepperIndex.sampleIndex)
        {
            navigateToModifyChemistSample()
        }
        else if(button.tag == stepperIndex.detailedProduct)
        {
            navigateToAddChemistDetailProduct(isModify: true)
        }
        else if(button.tag == stepperIndex.chemistIndex)
        {
            
        }
        else if(button.tag == stepperIndex.followUpIndex)
        {
            navigateToModifyChemistFollowUp()
        }
        else if(button.tag == stepperIndex.attachmentIndex)
        {
            navigateToAttachmentList()
        }
        else if(button.tag == stepperIndex.pobIndex)
        {
            navigateToModifyPOB()
        }
        else if(button.tag == stepperIndex.rcpaDetailIndex)
        {
            navigateToModifyChemistRCPA()
        }
        
    }
    
    //Chemist Visit
    private func navigateToNextScreen(stoaryBoard: String, viewController:String)
    {
        let sb = UIStoryboard(name: stoaryBoard, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: viewController)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToAddDoctorVisit()
    {
        var doctorName : String = ""
        let sb = UIStoryboard(name: ChemistDaySB, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: ChemistDayVisitVcID) as! ChemistDayVisitController
        vc.specialityName = customerMasterModel.Speciality_Name
        if ChemistDay.sharedInstance.customerCode == nil
        {
            doctorName = customerMasterModel.Customer_Name
        }
        vc.chemistName = doctorName
        vc.customerMasterObj = customerMasterModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //Accompanist
    private func navigateToEditDoctorVisit()
    {
        let sb = UIStoryboard(name: ChemistDaySB, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: ChemistDayVisitVcID) as! ChemistDayVisitController
        vc.isComingFromModifyPage = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToAddDoctorAccompanist()
    {
        navigateToNextScreen(stoaryBoard: detailProductSb, viewController: DoctorAccompanistVcID)
    }
    
    //Samples
    private func navigateToChemistSample()
    {
        let sb = UIStoryboard(name: sampleProductListSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: sampleProductListVcID) as! SampleProductListViewController
        vc.isComingFromChemistDay = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToModifyChemistSample()
    {
        let sb = UIStoryboard(name: sampleProductListSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: sampleDCRListVcID) as! SampleDetailsViewController
        let chemistSampleList = BL_Common_Stepper.sharedInstance.getSampleDCRProducts(dcrId: getDCRId(), chemistVisitId: ChemistDay.sharedInstance.chemistVisitId)!
        vc.currentList = BL_Common_Stepper.sharedInstance.convertChemistSampleToDCRSample(list:chemistSampleList)
        vc.isComingFromModifyPage = true
        vc.isComingFromChemistDay = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //Detailed Products
    private func navigateToAddChemistDetailProduct(isModify : Bool)
    {
        let sb = UIStoryboard(name: detailProductSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: DetailProductVcID) as! DetailedProductViewController
        vc.isComingFromModifyPage = isModify
        vc.isFromChemistDay = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //FollowUP
    private func navigateToModifyChemistFollowUp()
    {
        let sb = UIStoryboard(name: Constants.StoaryBoardNames.FollowUpSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.ModifyFollowUpListVcID) as! ModifyFollowUpsListViewController
        vc.isFromChemistDay = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private  func navigateToChemistFollowUp()
    {
        let sb = UIStoryboard(name: Constants.StoaryBoardNames.FollowUpSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.AddFollowUpVcID) as! AddFollowUpsViewController
        vc.isFromChemistDay = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Add new attachment
    func navigateToAddAttachment()
    {
        if Bl_Attachment.sharedInstance.getChemistAttachmentCount() < maxFileUploadCount
        {
            Attachment.sharedInstance.showAttachmentActionSheet(viewController: self)
            Attachment.sharedInstance.isFromMessage = false
            Attachment.sharedInstance.isfromLeave = false
            Attachment.sharedInstance.isFromChemistDay = true
        }
        else
        {
            AlertView.showAlertView(title: alertTitle, message: "You can not upload more than \(maxFileUploadCount) files")
        }
        
    }
    
    func navigateToAttachmentList()
    {
        let sb = UIStoryboard(name: Constants.StoaryBoardNames.AttachmentSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.AttachmentVCID) as! AttachmentViewController
        vc.isFromChemistDay = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Add new POB
    func navigateToAddPOB()
    {
        BL_POB_Stepper.sharedInstance.orderEntryId = 0
        BL_POB_Stepper.sharedInstance.dueDate = Date()
        let sb = UIStoryboard(name: Constants.StoaryBoardNames.POBSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.POBStepperVcID) as! POBStepperViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK:- Modify POB
    
    func navigateToModifyPOB()
    {
        let list = BL_POB_Stepper.sharedInstance.getPOBHeaderForDCRId(dcrId: getDCRId() , visitId: DCRModel.sharedInstance.customerVisitId,customerEntityType:getCustomerEntityType())
        let sb = UIStoryboard(name: Constants.StoaryBoardNames.POBSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.POBSalesProductModifyVcID) as! POBSalesProductsModifyListViewController
        vc.pobSalesModifyList = list
        self.navigationController?.pushViewController(vc, animated: true)
    }

    //
    func navigateToRCPA()
    {
        let sb = UIStoryboard(name: ChemistDaySB, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.RcpaListVCID) as! RcpaListController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToModifyChemistRCPA()
    {
        let sb = UIStoryboard(name: Constants.StoaryBoardNames.FollowUpSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.ModifyFollowUpListVcID) as! ModifyFollowUpsListViewController
        vc.isFromChemistDayRCPA = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    private func getDCRId() -> Int
    {
        return DCRModel.sharedInstance.dcrId
    }
    
    private func getCustomerEntityType() -> String
    {
        return DCRModel.sharedInstance.customerEntityType
    }
    
    func getServerTime() -> String
    {
        let date = Date()
        return stringFromDate(date1: date)
    }
    
    func getVisitModeType(visitTime : String) -> String
    {
        let lastcharacterIndex = visitTime.index(visitTime.endIndex, offsetBy: -2)
        return visitTime.substring(from: lastcharacterIndex)
    }
    
}
extension String {
    var trimFirstIndex : String {
        mutating get {
            self.remove(at: self.startIndex)
            return self
        }
    }
}
