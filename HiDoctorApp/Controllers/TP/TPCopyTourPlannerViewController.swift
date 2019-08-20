//
//  TPCopyTourPlannerViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 18/08/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class TPCopyTourPlannerViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableWrapperView: CornerRadiusWithShadowView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var masterTableView: UITableView!
    
    @IBOutlet weak var masterViewTop: NSLayoutConstraint!
    @IBOutlet weak var wrapperViewHeight: NSLayoutConstraint!
    var stepperList:[TPCopyStepperModel]!
    var accDataList = UserMasterModel()
    var accDataArray = UserMasterModel()
    
    //MARK:- ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        BL_TP_CopyTpStepper.sharedInstance.clearArray()
        stepperList = BL_TP_CopyTpStepper.sharedInstance.stepperDataList
        emptyStateLbl.text  = EMPTY
        refresh()
        masterTableView.delegate = self
        masterTableView.dataSource = self
        addBackButtonView()
        if accDataList.Employee_name != nil
        {
        self.title = "\(accDataList.Employee_name!)(\(convertDateIntoString(date: TPModel.sharedInstance.tpDate)))"
        }
        else
        {
          self.title = "\(accDataArray.Employee_name!)(\(convertDateIntoString(date: TPModel.sharedInstance.tpDate)))"
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func copyBtnAction(_ sender: Any)
    {
        let headerArray = BL_TP_CopyTpStepper.sharedInstance.tourPlanHeaderAcc
        if headerArray.count > 0
        {
            if headerArray[0].copyAccess == 1
            {
                BL_TP_CopyTpStepper.sharedInstance.updateAccHeaderDetails(tp_Entry_Id: TPModel.sharedInstance.tpEntryId, cp_Code: headerArray[0].cp_Code, category_Code: headerArray[0].category_Code, work_Place: headerArray[0].work_Area, cp_Name: headerArray[0].cp_Name, meeting_Place: headerArray[0].meeting_Place!, meeting_Time: checkNullAndNilValueForString(stringData: headerArray[0].meeting_Time), category_Name: headerArray[0].work_Category_Name, remarks: checkNullAndNilValueForString(stringData: headerArray[0].remarks))
                
                BL_TP_CopyTpStepper.sharedInstance.deleteCopiedAccompanistSFC(tp_Entry_Id: TPModel.sharedInstance.tpEntryId)
                BL_TP_CopyTpStepper.sharedInstance.deleteCopiedAccompanistDoctor(tp_Entry_Id: TPModel.sharedInstance.tpEntryId)
                
                BL_TP_CopyTpStepper.sharedInstance.insertAccompanistDetails()
                
                popVCs()
            }
            else
            {
                showToastView(toastText: "This feature is not applicable for this Accompanist")
            }
        }
        else
        {
            self.emptyStateLbl.text = "No TP available"
            showEmptyStateView()
        }
    }
    
    func popVCs()
    {
        if let navigationController = self.navigationController
        {
            let vcList = navigationController.viewControllers
            var index = 0
            var isFound: Bool = false
            
            for currentVC: UIViewController in vcList
            {
                if (currentVC is AccompanistListViewController)
                {
                    isFound = true
                    break
                }
                
                index += 1
            }
            
            if (isFound)
            {
                self.navigationController?.viewControllers.remove(at: index)
            }
        }
        
        _ = navigationController?.popViewController(animated: false)
    }
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        
        _ = navigationController?.popViewController(animated: false)
    }
    
    
    //MARK:- TableView DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stepperList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let index = indexPath.row
        if (index == 0)
            {
                
                return BL_TP_CopyTpStepper.sharedInstance.getTourPlanCellHeight()
                
            }
            else if (index == 1)
            {
                
                return BL_TP_CopyTpStepper.sharedInstance.getPlaceDetailsCellHeight(selectedIndex: index)
                
            }
            else if (index == 2)
            {
                
                return BL_TP_CopyTpStepper.sharedInstance.getDoctorDetailsCellHeight(selectedIndex: index)
                
            }
            else
            {
                
                return 0
            }
        }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TPCopyTourPlanMainCell") as! TPCopyTourPlanMainTableViewCell
        let index = indexPath.row
        let objStepperModel: TPCopyStepperModel = BL_TP_CopyTpStepper.sharedInstance.stepperDataList[index]
        cell.selectedIndex = index
        cell.titleLbl.text = objStepperModel.sectionTitle
        cell.iconView.image = UIImage(named: objStepperModel.sectionIconName)
        let stepperObj = BL_TP_CopyTpStepper.sharedInstance.stepperDataList[index]
        
            if (stepperObj.recordCount == 0)
                {
                    cell.childTableView.isHidden = true
                    cell.emptyLbl.text = "N.A"
                    
            }
            else
                {
                    cell.childTableView.isHidden = false
                    cell.emptyLbl.isHidden = true
                }
        return cell
    }
    
    //MARK:- Webservice call
    func refresh()
    {
        if checkInternetConnectivity()
        {
        showActivityIndicator()
        BL_TP_CopyTpStepper.sharedInstance.postCopyTourPlanAccompanistDetails(user_code: accDataArray.User_Code, start_Date: convertDateIntoServerStringFormat(date: TPModel.sharedInstance.tpDate) , end_Date: convertDateIntoServerStringFormat(date: TPModel.sharedInstance.tpDate), region_Code: accDataArray.Region_Code) { (StatusMsg,Status,list) in
            removeCustomActivityView()
            if Status == SERVER_SUCCESS_CODE
            {
               if (BL_TP_CopyTpStepper.sharedInstance.showCopyTp >= 2)
                    {
                        BL_TP_CopyTpStepper.sharedInstance.generateDataArray()
                        self.stepperList = BL_TP_CopyTpStepper.sharedInstance.stepperDataList
                        self.showTablewrapperView()
                    }
                else
                    {
                        self.emptyStateLbl.text = "No TP available"
                        self.showEmptyStateView()
                    }
            }
            else
            {
                self.emptyStateLbl.text = StatusMsg
                self.showEmptyStateView()
            }
        }
        if BL_TP_CopyTpStepper.sharedInstance.stepperDataList.count > 0
        {
            self.showTablewrapperView()
        }
        else
        {
            emptyStateLbl.text = "No TP available"
            self.showEmptyStateView()
        }
        }
        else
        {
           AlertView.showNoInternetAlert()
        }
        }
        
    
    //MARK:- Functions for updating views
    func showActivityIndicator()
    {
        if tableWrapperView.isHidden == false
        {
            tableWrapperView.isHidden = true
        }
        
        if emptyStateView.isHidden == false
        {
            emptyStateView.isHidden = true
        }
        if bottomView.isHidden == false
        {
           bottomView.isHidden = true
        }
        
        showCustomActivityIndicatorView(loadingText: "Loading Accompanist data..")
        
    }
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

    private func showEmptyStateView()
    {
        tableWrapperView.isHidden = true
        bottomView.isHidden = true
        emptyStateView.isHidden = false
    }
    private func showTablewrapperView()
    {
        tableWrapperView.isHidden = false
        masterTableView.reloadData()
        bottomView.isHidden = false
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
