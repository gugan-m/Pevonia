//
//  AccompanistModifyListViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 22/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class AccompanistModifyListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SaveActionToastDelegate
{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var headerLbl: UILabel!
    
    
    var dcrAccompanistList : [DCRAccompanistModel] = []
    var nextBtn : UIBarButtonItem!
    var doneBtn : UIBarButtonItem!
    var isCmngFromScreenType : Int = 0
    var showToast : Bool = false

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.addBarButtonItem()
        addBackButtonView()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        self.validateToShowAddAccompanist()
        self.showToastForView()
        self.getDCRAccompanistList()
        self.headerLbl.text = "Field-RCPA | \(convertDateIntoString(date: DCRModel.sharedInstance.dcrDate!))"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.getDCRAccompanistList()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Table View Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dcrAccompanistList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let accompanistObj = dcrAccompanistList[indexPath.row]
        var defaultHeight : CGFloat = 53
        let bottomViewHeight : CGFloat = 70
        let accompanistLblHeight = getTextSize(text: accompanistObj.Acc_User_Name, fontName: fontRegular, fontSize: 15, constrainedWidth: SCREEN_WIDTH - 40).height
        if accompanistObj.Is_Only_For_Doctor == "1"
        {
            defaultHeight += 22
        }
        return defaultHeight + bottomViewHeight + accompanistLblHeight
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccompanistModifyListCell, for: indexPath) as! AccompanistModifyListTableViewCell
        
        let acccompanistObj = dcrAccompanistList[indexPath.row]
      
        cell.accompanistNameLbl.text = acccompanistObj.Employee_Name! as String
        if acccompanistObj.Acc_Start_Time != ""
        {
            let startTime = acccompanistObj.Acc_Start_Time! as String
            let EndTime = acccompanistObj.Acc_End_Time! as String
            let accompanistObj = "\(startTime)-\(EndTime)"
            cell.timeLbl.text = String(accompanistObj)
        }
        else
        {
            cell.timeLbl.text = "\(NOT_APPLICABLE) - \(NOT_APPLICABLE)"
        }
        let indePendentFlag = acccompanistObj.Is_Only_For_Doctor
        if indePendentFlag != nil
        {
            if indePendentFlag == "1"
            {
                cell.independentLabel.text = "Independent Call"
            }
            else
            {
                cell.independentLabel.text = nil
            }
        }
        cell.modifyBtn.tag = indexPath.row
        cell.removeBtn.tag = indexPath.row
        
        cell.removeBtn.isHidden = false
        
        if (acccompanistObj.Is_TP_Frozen == 1)
        {
            cell.removeBtn.isHidden = true
        }
        else
        {
             let isTPFreezed = BL_DCRCalendar.sharedInstance.isFrozenTP(flag: DCRFlag.fieldRcpa.rawValue, date: convertDateIntoServerStringFormat(date: DCRModel.sharedInstance.dcrDate))
            
            cell.removeBtn.isHidden = false
            if (isTPFreezed == 1)
            {
                cell.removeBtn.isHidden = true
            }
        }
//        if (BL_Stepper.sharedInstance.isTPFreeseDay)
//        {
//            cell.removeBtn.isHidden = true
//        }
        
//        if (cell.removeBtn.isHidden == false)
//        {
//            if (BL_DCR_Doctor_Visit.sharedInstance.isDCRInheritanceEnabled() && !BL_DCR_Doctor_Visit.sharedInstance.isDCRInheritanceEditable() && acccompanistObj.Is_Customer_Data_Inherited == Constants.DCR_Inheritance_Acc_Data_Downloaded_IDs.Download_Success)
//            {
//                cell.removeBtn.isHidden = true
//            }
//        }

        return cell
    }
    
   private func getDCRAccompanistList()
   {
     dcrAccompanistList =  BL_DCR_Accompanist.sharedInstance.getDCRAccompanistList()!
      self.reloadTableView()
   }
    
    
    func sortDcrAccompanistList(list : [DCRAccompanistModel]) -> [DCRAccompanistModel]
    {
        return list.sorted { (($0).Employee_Name)!.localizedCaseInsensitiveCompare((($1).Employee_Name)! as String) == ComparisonResult.orderedAscending }
    }

    private func showEmptyStateView(show: Bool)
    {
        self.emptyStateView.isHidden = !show
        self.contentView.isHidden  = show
    }
    
    private func reloadTableView()
    {
        if self.dcrAccompanistList.count > 0
        {
            self.tableView.reloadData()
            self.showEmptyStateView(show: false)
        }
        else
        {
            self.showEmptyStateView(show: true)
        }
    }
    @IBAction func removeBtnAction(_ sender: AnyObject)
    {
        let accompanistObj = dcrAccompanistList[sender.tag]
        self.removeAccompanistDetails(accompanistObj: accompanistObj, indexPath: sender.tag)
    }
    
    private func removeAccompanistDetails(accompanistObj : DCRAccompanistModel, indexPath: Int)
    {
        let errorMsg = BL_DCR_Accompanist.sharedInstance.isAnyAccompaistDataUsedInDCR(dcrAccompanistObj: accompanistObj)
        
        let accompanistRegionCode = accompanistObj.Acc_Region_Code
        let accompanistUserCode = checkNullAndNilValueForString(stringData: accompanistObj.Acc_User_Code)
        
        if (errorMsg != EMPTY)
        {
            isCmngFromScreenType = 2
            let popUp_sb = UIStoryboard(name:dcrStepperSb, bundle: nil)
            let popUp_Vc = popUp_sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.RemoveAccompanistPopUpVcID) as! RemoveAccompanistPopUpViewController
            popUp_Vc.dcrAccompanistObj = accompanistObj
            popUp_Vc.delegate = self
            popUp_Vc.providesPresentationContextTransitionStyle = true
            popUp_Vc.definesPresentationContext = true
            popUp_Vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            self.present(popUp_Vc, animated: false, completion: nil)
        }
        else
        {
            BL_DCR_Accompanist.sharedInstance.removeDCRAccompanist(accompanistRegionCode: accompanistRegionCode!, accompanistUserCode: accompanistUserCode)
            self.dcrAccompanistList.remove(at: indexPath)
            self.reloadTableView()
            showToastView(toastText: "\(PEV_ACCOMPANIST) removed successfully")
            resetAccompanistRelatedData()
        }
    }
    
    @IBAction func modifyBtnAction(_ sender: AnyObject)
    {
        isCmngFromScreenType = 1
        let accompanistObj = dcrAccompanistList[sender.tag]
        let addAccompanist_sb = UIStoryboard(name: accompanistDetailsSb, bundle: nil)
        let addAccomapanist_vc = addAccompanist_sb.instantiateViewController(withIdentifier: AddAccompanistVcID) as! AddNewAccompanistViewController
        addAccomapanist_vc.modifyAccompanistObj = accompanistObj
        addAccomapanist_vc.isComingFromModifyPage = true
        addAccomapanist_vc.delegate = self
        self.navigationController?.pushViewController(addAccomapanist_vc, animated: true)
    }
    
    @objc func doneBtnAction()
    {
        _ = navigationController?.popViewController(animated: false)
    }
    
    
    @objc func addAccompanistBtnAction()
    {
        let addAccompanist_sb = UIStoryboard(name: accompanistDetailsSb, bundle: nil)
        let addAccomapanist_vc = addAccompanist_sb.instantiateViewController(withIdentifier: AddAccompanistVcID)
        self.navigationController?.pushViewController(addAccomapanist_vc, animated: true)
    }

    func addBarButtonItem()
    {
        nextBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(AccompanistModifyListViewController.addAccompanistBtnAction))
        doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(AccompanistModifyListViewController.doneBtnAction))
    }
    
    func validateToShowAddAccompanist()
    {
        if BL_DCR_Accompanist.sharedInstance.doMaximumAccompanistValidation()
        {
            if (BL_Stepper.sharedInstance.isTPFreeseDay)
            {
                self.navigationItem.rightBarButtonItems = [doneBtn]
            }
            else
            {
                self.navigationItem.rightBarButtonItems = [doneBtn,nextBtn]
            }
        }
        else
        {
            self.navigationItem.rightBarButtonItems = [doneBtn]
        }
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
    
    func showUpdateToastView()
    {
        self.showToast = true
        showToastForView()
    }
    
    private func showToastForView()
    {
        if showToast
        {
            if isCmngFromScreenType == 1
            {
                showToastView(toastText: "\(PEV_ACCOMPANIST) Updated Successfully")
            }
            else if isCmngFromScreenType == 2
            {
                showToastView(toastText: "\(PEV_ACCOMPANIST) removed successfully")
                getDCRAccompanistList()
                resetAccompanistRelatedData()
            }
            isCmngFromScreenType = 0
        }
    }
    
    private func resetAccompanistRelatedData()
    {
        self.validateToShowAddAccompanist()
        BL_Stepper.sharedInstance.getAccompanistDataPendingList()
    }
}
