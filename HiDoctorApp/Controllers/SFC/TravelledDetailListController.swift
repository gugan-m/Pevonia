//
//  TravelledDetailListController.swift
//  HiDoctorApp
//
//  Created by Vijay on 24/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class TravelledDetailListController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var addBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!

    let cellIdentifier : String = "travelListCell"
    var travelDetailList : [DCRTravelledPlacesModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addBackButtonView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var flagVal : String!
        let flag = DCRModel.sharedInstance.dcrFlag
        
        if flag == 1
        {
            flagVal = fieldRcpa
        }
        else if flag == 2
        {
            flagVal = attendance
        }
        
        let dcrDateVal = convertDateIntoString(date: DCRModel.sharedInstance.dcrDate)
        
        subTitle.text = String(format: "%@ | %@", flagVal, dcrDateVal)
        
//        if BL_SFC.sharedInstance.travelDetailAddBtnHidden()
//        {
//            addBtn.isEnabled = false
//            addBtn.tintColor = UIColor.clear
//        } else
//        {
//            addBtn.isEnabled = true
//            addBtn.tintColor = nil
//        }
        
        travelDetailList = DAL_SFC.sharedInstance.getTravelledDetailList()!
        
        self.addBtn.isEnabled = true
        
        if (DCRModel.sharedInstance.dcrFlag == DCRFlag.fieldRcpa.rawValue)
        {
            if (BL_Stepper.sharedInstance.isTPFreeseDay)
            {
                self.addBtn.isEnabled = BL_Stepper.sharedInstance.stepperDataList[2].showLeftButton
            }
        }
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
        
        var heightVal : CGFloat!
        let model = travelDetailList[indexPath.row]
        
        if model.Is_Circular_Route_Complete == 1
        {
            heightVal = 125.0 + 14.0
        }
        else
        {
            heightVal = 180.0
        }
        
        let fromPlaceHeight = getTextSize(text: model.From_Place, fontName: fontRegular, fontSize: 15.0, constrainedWidth: SCREEN_WIDTH - 156.0).height
        let toPlaceHeight = getTextSize(text: model.To_Place, fontName: fontRegular, fontSize: 15.0, constrainedWidth: SCREEN_WIDTH - 156.0).height
        if (fromPlaceHeight + toPlaceHeight) > 50.0
        {
            heightVal = heightVal + (fromPlaceHeight + toPlaceHeight - 50.0)
        }
        
        return heightVal
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : TravelListCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! TravelListCell
        let model = travelDetailList[indexPath.row]
        
        cell.fromPlaceLabel.text = model.From_Place
        cell.toPlaceLabel.text = model.To_Place
        cell.travelMode.text = model.Travel_Mode
        cell.distance.text = String(model.Distance)
        
        cell.modifyBtn.tag = indexPath.row
        cell.removebtn.tag = indexPath.row
        
        if model.Is_Circular_Route_Complete == 1
        {
            cell.wrapper.backgroundColor = UIColor(red: 57.0/255.0, green: 160.0/255.0, blue: 128.0/255.0, alpha: 1.0)
            cell.removeBtnWrapper.constant = 0.0
            cell.autoCircleText.text = sfcAutoCompleteText
            cell.modifyBtn.isHidden = true
            cell.removebtn.isHidden = true
        }
        else
        {
            cell.wrapper.backgroundColor = UIColor.white
            cell.removeBtnWrapper.constant = 55.0
            cell.autoCircleText.text = nil
            cell.modifyBtn.isHidden = false
            cell.removebtn.isHidden = false
        }
        
        cell.removebtn.isHidden = false
        cell.modifyBtn.isHidden = false
        
        if (BL_Stepper.sharedInstance.isTPFreeseDay)
        {
            if (model.Is_TP_SFC == 1)
            {
                cell.removebtn.isHidden = true
                
                if (checkNullAndNilValueForString(stringData: model.Distance_Fare_Code) == EMPTY) // Check for flexi SFC
                {
                    let canEditDistance = BL_SFC.sharedInstance.canEditDistance()
                    
                    if (!canEditDistance)
                    {
                        cell.modifyBtn.isHidden = true
                    }
                }
                else
                {
                    cell.modifyBtn.isHidden = true
                }
            }
        }
        
        return cell
    }
    
    @IBAction func addBtnAction(_ sender: AnyObject)
    {
        let status = BL_SFC.sharedInstance.checkAutoCompleteValidation()
        if status != ""
        {
            showToastView(toastText: sfcCircularRouteErrorMsg)
        }
        else
        {
            if DAL_SFC.sharedInstance.getTravelledDetailList()!.count == 0 || BL_SFC.sharedInstance.checkIntermediateStatus()
            {
                if let navigationController = self.navigationController
                {
                    let sb = UIStoryboard(name: addTravelDetailSb, bundle: nil)
                    let vc = sb.instantiateViewController(withIdentifier: addTravelDetailVcId)
                    
                    navigationController.popViewController(animated: false)
                    navigationController.pushViewController(vc, animated: false)
                }
            }
            else
            {
                showToastView(toastText: sfcIntermediateErrorMsg)
            }
        }
    }
    
    @IBAction func doneAction(_ sender: AnyObject)
    {
        saveAction()
    }
    
    private func saveAction()
    {
        let statusMsg = BL_SFC.sharedInstance.saveTravelledPlaces()
        if statusMsg != ""
        {
            AlertView.showAlertView(title: alertTitle, message: statusMsg, viewController: self)
        } else
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
                let sb = UIStoryboard(name: addTravelDetailSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: addTravelDetailVcId) as! AddTravelDetailsController
                vc.fromPlace = (checkSFCVersionModel.last?.From_Place)!
                vc.toPlace = (checkSFCVersionModel.last?.To_Place)!
                vc.travelMode = checkSFCVersionModel.last?.Travel_Mode
                vc.distance = (checkSFCVersionModel.last?.Distance)!
                vc.distanceFareCode = checkSFCVersionModel.last?.Distance_Fare_Code
                vc.sfcVersion = checkSFCVersionModel.last?.SFC_Version
                vc.sfcCategory = checkSFCVersionModel.last?.Category_Name
                vc.sfcRegionCode = checkSFCVersionModel.last?.Region_Code
                vc.travelId = model.DCR_Travel_Id
                vc.validSFC = false
                vc.isUpdatedSFC = true
                vc.isComingFromModify = true
                if sender.tag > 0
                {
                    vc.modifyFromplaceFlag = true
                }
                
                navigationController.popViewController(animated: false)
                navigationController.pushViewController(vc, animated: false)
            }
        }
        else
        {
            if let navigationController = self.navigationController
            {
                let sb = UIStoryboard(name: addTravelDetailSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: addTravelDetailVcId) as! AddTravelDetailsController
                vc.fromPlace = model.From_Place
                vc.toPlace = model.To_Place
                vc.travelMode = model.Travel_Mode
                vc.distance = model.Distance
                vc.distanceFareCode = model.Distance_Fare_Code
                vc.sfcVersion = model.SFC_Version
                vc.sfcCategory = model.SFC_Category_Name
                vc.sfcRegionCode = model.Region_Code
                vc.travelId = model.DCR_Travel_Id
                vc.validSFC = false
                vc.isComingFromModify = true
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
        let sfcValidationVal = BL_SFC.sharedInstance.getSFCValidationPrivVal()
        let travelId = model.DCR_Travel_Id
        
        if sfcValidationVal.contains(DCRModel.sharedInstance.expenseEntityName)
        {
            DAL_SFC.sharedInstance.deleteCurrentNextTravelledDetail(travelId: travelId!)
        }
        else
        {
            let status = BL_SFC.sharedInstance.checkAutoCompleteValidation()
            if status != ""
            {
                DAL_SFC.sharedInstance.deleteCurrentNextTravelledDetail(travelId: travelId!)
            }
            else
            {
                DAL_SFC.sharedInstance.deleteTravelledDetail(travelId: travelId!)
            }
        }
        
        travelDetailList = DAL_SFC.sharedInstance.getTravelledDetailList()!
        
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
