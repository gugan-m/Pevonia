//
//  TPTravelDetailListViewController.swift
//  HiDoctorApp
//
//  Created by Admin on 8/10/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class TPTravelDetailListViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var addBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    let cellIdentifier : String = "travelListCell"
    var travelDetailList : [TourPlannerSFC] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addBackButtonView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var flagVal : String!
        let flag = TPModel.sharedInstance.tpFlag
        
        if flag == 1
        {
            flagVal = fieldRcpa
        } else if flag == 2
        {
            flagVal = attendance
        }
        
        let tpDateVal = convertDateIntoString(date: TPModel.sharedInstance.tpDate)
        
        subTitle.text = String(format: "%@ | %@", flagVal, tpDateVal)
 
        
        travelDetailList = DAL_TP_SFC.sharedInstance.getTravelledDetailList()
    }
    
    private func setEmptyViewVisibility()
    {
        if travelDetailList.count > 0
        {
            tableView.isHidden = false
            emptyView.isHidden = true
        }
        else
        {
            tableView.isHidden = true
            emptyView.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travelDetailList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var heightVal : CGFloat! = 180.0

        let model = travelDetailList[indexPath.row]
        
        let fromPlaceHeight = getTextSize(text: model.From_Place, fontName: fontRegular, fontSize: 15.0, constrainedWidth: SCREEN_WIDTH - 156.0).height
        let toPlaceHeight = getTextSize(text: model.To_Place, fontName: fontRegular, fontSize: 15.0, constrainedWidth: SCREEN_WIDTH - 156.0).height
        if (fromPlaceHeight + toPlaceHeight) > 50.0
        {
            heightVal = heightVal + (fromPlaceHeight + toPlaceHeight - 50.0)
        }
        
        return heightVal
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TravelListCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! TravelListCell
        let model = travelDetailList[indexPath.row]
        
        cell.fromPlaceLabel.text = model.From_Place
        cell.toPlaceLabel.text = model.To_Place
        cell.travelMode.text = model.Travel_Mode
        cell.distance?.text = String(model.Distance)
        
        cell.modifyBtn.tag = indexPath.row
        cell.removebtn.tag = indexPath.row
        cell.wrapper.backgroundColor = UIColor.white
        cell.removeBtnWrapper.constant = 55.0
        cell.autoCircleText.text = nil
        cell.modifyBtn.isHidden = false
        cell.removebtn.isHidden = false
        
        return cell
    }
    
    @IBAction func addBtnAction(_ sender: AnyObject)
    {
        let enteredSFCList = BL_TP_SFC.sharedInstance.getTPEnteredSFCList()
        
        BL_TP_SFC.sharedInstance.fromPlace = EMPTY
        BL_TP_SFC.sharedInstance.toPlace = EMPTY
        
        if enteredSFCList.count == 0 || BL_TP_SFC.sharedInstance.checkIntermediateStatus()
        {
            if let navigationController = self.navigationController
            {
                let sb = UIStoryboard(name: TPStepperSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: TPTravelDetailsVCID)
                
                navigationController.popViewController(animated: false)
                navigationController.pushViewController(vc, animated: false)
            }
        }
        else
        {
            showToastView(toastText: sfcIntermediateErrorMsg)
        }
    }
    
    @IBAction func doneAction(_ sender: AnyObject)
    {
        saveAction()
    }
    
    private func saveAction()
    {
        let statusMsg = BL_TP_SFC.sharedInstance.saveTravelledPlaces()
        
        if statusMsg != ""
        {
            AlertView.showAlertView(title: alertTitle, message: statusMsg, viewController: self)
        }
        else
        {
            _ = navigationController?.popViewController(animated: false)
        }
    }
    
    @IBAction func modifyAction(_ sender: AnyObject)
    {
        let model = travelDetailList[sender.tag]
        
        let checkSFCVersionModel: [SFCMasterModel] = [] //DAL_SFC.sharedInstance.checkForNewSFCVersion(distanceFareCode: model.Distance_Fare_Code!, sfcVersion: model.SFC_Version!)
        if checkSFCVersionModel.count > 0
        {
            if let navigationController = self.navigationController
            {
                let sb = UIStoryboard(name: TPStepperSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: TPTravelDetailsVCID) as! TPTravelDetailsViewController
                vc.fromPlace = (checkSFCVersionModel.last?.From_Place)!
                vc.toPlace = (checkSFCVersionModel.last?.To_Place)!
                vc.travelMode = checkSFCVersionModel.last?.Travel_Mode
                vc.distance = (checkSFCVersionModel.last?.Distance)!
                vc.distanceFareCode = checkSFCVersionModel.last?.Distance_Fare_Code
                vc.sfcVersion = checkSFCVersionModel.last?.SFC_Version
                vc.sfcCategory = checkSFCVersionModel.last?.Category_Name
                vc.sfcRegionCode = checkSFCVersionModel.last?.Region_Code
                vc.travelId = model.TP_SFC_Id
                vc.validSFC = false
                vc.isUpdatedSFC = true
                if sender.tag > 0
                {
                    vc.modifyFromplaceFlag = true
                }
                
                navigationController.popViewController(animated: false)
                navigationController.pushViewController(vc, animated: false)
            }
        } else
        {
            if let navigationController = self.navigationController
            {
                let sb = UIStoryboard(name: TPStepperSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: TPTravelDetailsVCID) as! TPTravelDetailsViewController
                vc.fromPlace = model.From_Place
                vc.toPlace = model.To_Place
                vc.travelMode = model.Travel_Mode
                vc.distance = model.Distance
                vc.distanceFareCode = model.Distance_fare_Code
                vc.sfcVersion = model.SFC_Version
                vc.sfcCategory = model.SFC_Category_Name
                vc.sfcRegionCode = model.Region_Code
                vc.travelId = model.TP_SFC_Id
                vc.validSFC = false
                if sender.tag > 0
                {
                    vc.modifyFromplaceFlag = true
                }
                
                navigationController.popViewController(animated: false)
                navigationController.pushViewController(vc, animated: false)
            }
        }
    }
    
    @IBAction func deleteAction(_ sender: AnyObject)
    {
        showRemoveAlert(tag: sender.tag)
    }
    
    func showRemoveAlert(tag: Int)
    {
        let alert = UIAlertController(title: "Alert", message: "Do you want to Remove?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Remove", style: .default, handler: { (action: UIAlertAction!) in
            self.removeAction(tag: tag)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func removeAction(tag: Int)
    {
        let model = travelDetailList[tag]
        let travelId = model.TP_SFC_Id
        
        DAL_TP_SFC.sharedInstance.deleteCurrentNextTravelledDetail(travelId: travelId!)
        BL_TPStepper.sharedInstance.changeTPStatusToDraft(tpEntryId: TPModel.sharedInstance.tpEntryId)
        
        travelDetailList = DAL_TP_SFC.sharedInstance.getTravelledDetailList()
        
        tableView.reloadData()
        setEmptyViewVisibility()
        showToastView(toastText: "Travel place deleted successfully")
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
        saveAction()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
