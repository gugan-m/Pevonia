//
//  ModifyFollowUpsListViewController.swift
//  HiDoctorApp
//
//  Created by SwaaS on 17/04/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class ModifyFollowUpsListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateView : UIView!
    
    @IBOutlet weak var emptyStateLbl: UILabel!
    var followUpModifyList : [DCRFollowUpModel] = []
    var isFromChemistDay: Bool = false
    var chemistfollowUpModifyList:[DCRChemistFollowup] = []
    var chemistDAyRCPAOwn :[DCRChemistRCPAOwn] = []
    var chemistDayRCPAObj : DCRChemistRCPAOwn?
    var isFromChemistDayRCPA:Bool = false
    var isfromRCPAown:Bool = false
    var docObj:CustomerModel?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 500
        addCustomBackButtonToNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.getModifyList()
        self.setNavigationTitle()
        self.checkModifyList()
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    func getModifyList()
    {
        if !isFromChemistDay
        {
            if isFromChemistDayRCPA
            {
                chemistDAyRCPAOwn = BL_DCR_Chemist_Visit.sharedInstance.getRCPAEnteredDoctorsList()
                followUpModifyList = self.convertRCPAToFollowupsModel(rcpaList: chemistDAyRCPAOwn)
            }
            else if isfromRCPAown
            {
                if chemistDayRCPAObj != nil
                {
                    chemistDAyRCPAOwn = BL_DCR_Chemist_Visit.sharedInstance.getRCPAEnteredDoctorsList(doctorCode: (chemistDayRCPAObj?.DoctorCode)!, doctorRegionCode: (chemistDayRCPAObj?.DoctorRegionCode)!, doctorName: (chemistDayRCPAObj?.DoctorName)!, specialtyName: (chemistDayRCPAObj?.DoctorSpecialityName)!)
                    followUpModifyList = self.convertRCPAToFollowupsModel(rcpaList: chemistDAyRCPAOwn)
                }
            }
            else
            {
                followUpModifyList = BL_DCR_Follow_Up.sharedInstance.getDCRFollowUpDetails()
            }
        }
        else
        {
            chemistfollowUpModifyList = BL_DCR_Follow_Up.sharedInstance.getChemistFollowUpDetails()
            followUpModifyList = BL_DCR_Follow_Up.sharedInstance.convertDCRChemistFollowupToDCRFollowup(chemistFollowupList: chemistfollowUpModifyList)
            
        }
    }
    
    //MARK:- Table View Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return followUpModifyList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.DCRDoctorVisitFollowUpCell, for: indexPath) as! ModifyAttendanceActivityTableViewCell
        
        let obj = followUpModifyList[indexPath.row]
        if isFromChemistDayRCPA || isfromRCPAown
        {
            cell.activityNameLbl.text = obj.Follow_Up_Text!
            cell.activityTimeLbl.text = obj.DCR_Code
            cell.removeBtn.tag = indexPath.row
            cell.modifyBtn.tag = indexPath.row
        }
        else
        {
            cell.activityNameLbl.attributedText = attributedTextForText(firstString: "Remarks:", secondString: " \(obj.Follow_Up_Text!)")
            let dueDate = convertDateIntoString(date: obj.Due_Date)
            cell.activityTimeLbl.attributedText = attributedTextForText(firstString: "Due Date:", secondString: " \(dueDate)")
            cell.modifyBtn.tag = indexPath.row
            cell.removeBtn.tag = indexPath.row
        }
        
        return cell
    }
    
    @IBAction func modifyBtnAction(_ sender: UIButton)
    {
        if isFromChemistDay
        {
            let indexPath = (sender as AnyObject).tag
            let followUpObj = chemistfollowUpModifyList[indexPath!]
            self.navigateToFollowUp(followupOBj: followUpObj)
        }
        else if isFromChemistDayRCPA
        {
            let indexPath = (sender as AnyObject).tag
            let ChemistDayRCPAObj = chemistDAyRCPAOwn[indexPath!]
            let sb = UIStoryboard(name: Constants.StoaryBoardNames.FollowUpSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.ModifyFollowUpListVcID) as! ModifyFollowUpsListViewController
            vc.isfromRCPAown = true
            vc.chemistDayRCPAObj = ChemistDayRCPAObj
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if isfromRCPAown
        {
            let indexPath = (sender as AnyObject).tag
            let ChemistDayRCPAObj = chemistDAyRCPAOwn[indexPath!]
            let sb = UIStoryboard(name: chemistsSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: AddChemsistRCPAVcID) as! AddChemistRCPAViewController
            vc.dcrRCPAObj = convertChemistDayRCPAToDCRRCPAModel(obj: ChemistDayRCPAObj)
            vc.dcrChemistDayRCPAObj = ChemistDayRCPAObj
            vc.isFromChemistDayRCPA = true
            vc.modifyChemistDayRCPA = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let indexPath = (sender as AnyObject).tag
            let followUpObj = followUpModifyList[indexPath!]
            self.navigateToModifyFollowUpPage(followUpObj: followUpObj)
        }
    }
    
    @IBAction func removeBtnAction(_ sender: UIButton)
    {
        if isFromChemistDay
        {
            let indexPath = (sender as AnyObject).tag
            let followUpObj = chemistfollowUpModifyList[indexPath!]
            
            let alertViewController = UIAlertController(title: nil, message: "Do you want to remove follow up detail?", preferredStyle: UIAlertControllerStyle.alert)
            alertViewController.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { alertAction in
                self.removeChemistFollowUpdetails(followupObj: followUpObj)
                self.followUpModifyList.remove(at: indexPath!)
                self.checkModifyList()
                showToastView(toastText: "Follow up details removed successfully")
                alertViewController.dismiss(animated: true, completion: nil)
            }))
            alertViewController.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: { alertAction in
                alertViewController.dismiss(animated: true, completion: nil)
            }))
            self.present(alertViewController, animated: true, completion: nil)
            
        }
        else if isFromChemistDayRCPA
        {
            let indexPath = (sender as AnyObject).tag
            let ChemistDayRCPAObj = chemistDAyRCPAOwn[indexPath!]
            let alertViewController = UIAlertController(title: nil, message: "Do you want to remove RCPA for this \(appDoctor) \(ChemistDayRCPAObj.DoctorName!)", preferredStyle: UIAlertControllerStyle.alert)
            alertViewController.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { alertAction in
                self.removeRCPAdetails(indexpath: indexPath!)
                self.followUpModifyList.remove(at: indexPath!)
                self.checkModifyList()
                showToastView(toastText: "RCPA removed successfully")
                alertViewController.dismiss(animated: true, completion: nil)
            }))
            alertViewController.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: { alertAction in
                alertViewController.dismiss(animated: true, completion: nil)
            }))
            self.present(alertViewController, animated: true, completion: nil)
        }
        else if isfromRCPAown
        {
            let indexPath = (sender as AnyObject).tag
            let alertViewController = UIAlertController(title: nil, message: "Do you want to this product?", preferredStyle: UIAlertControllerStyle.alert)
            alertViewController.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { alertAction in
                self.removeRCPAdetails(indexpath: indexPath!)
                self.followUpModifyList.remove(at: indexPath!)
                self.checkModifyList()
                showToastView(toastText: "Product removed successfully")
                alertViewController.dismiss(animated: true, completion: nil)
            }))
            alertViewController.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: { alertAction in
                alertViewController.dismiss(animated: true, completion: nil)
            }))
            self.present(alertViewController, animated: true, completion: nil)
        }
        else
        {
            let indexPath = (sender as AnyObject).tag
            let followUpObj = followUpModifyList[indexPath!]
            
            let alertViewController = UIAlertController(title: nil, message: "Do you want to remove follow up detail?", preferredStyle: UIAlertControllerStyle.alert)
            alertViewController.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { alertAction in
                self.removeFollowUpDetails(followUpObj: followUpObj)
                self.followUpModifyList.remove(at: indexPath!)
                self.checkModifyList()
                showToastView(toastText: "Follow up details removed successfully")
                alertViewController.dismiss(animated: true, completion: nil)
            }))
            alertViewController.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: { alertAction in
                alertViewController.dismiss(animated: true, completion: nil)
            }))
            self.present(alertViewController, animated: true, completion: nil)
        }
    }
    
    //MARK:- Private function
    
    private func checkModifyList()
    {
        if followUpModifyList.count > 0
        {
            showEmptyStateView(show : false)
            reloadTableView()
        }
        else
        {
            showEmptyStateView(show : true)
        }
        if !isfromRCPAown
        {
            self.navigationItem.rightBarButtonItem?.accessibilityElementsHidden = false
        }
        else
        {
            self.navigationItem.rightBarButtonItem?.accessibilityElementsHidden = true
        }
    }
    
    
    private func attributedTextForText(firstString : String , secondString : String) -> NSAttributedString
    {
        let attributedString = NSMutableAttributedString(string: firstString, attributes: [NSAttributedStringKey.font: UIFont(name: fontSemiBold, size: 15.0)!  , NSAttributedStringKey.foregroundColor : UIColor.darkGray])
        let secondString = NSMutableAttributedString(string:secondString, attributes:[NSAttributedStringKey.font: UIFont(name: fontRegular, size: 15.0)! , NSAttributedStringKey.foregroundColor : UIColor.darkGray])
        attributedString.append(secondString)
        return attributedString
    }
    
    private func showEmptyStateView(show : Bool)
    {
        self.emptyStateView.isHidden = !show
        self.tableView.isHidden = show
        if isfromRCPAown || isFromChemistDayRCPA
        {
            self.emptyStateLbl.text = "No products found"
        }
    }
    
    private func navigateToModifyFollowUpPage(followUpObj :DCRFollowUpModel?)
    {
        let sb = UIStoryboard(name: Constants.StoaryBoardNames.FollowUpSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.AddFollowUpVcID) as! AddFollowUpsViewController
        vc.modifyFollowUpObj = followUpObj
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToFollowUp(followupOBj:DCRChemistFollowup)
    {
        let sb = UIStoryboard(name: Constants.StoaryBoardNames.FollowUpSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.AddFollowUpVcID) as! AddFollowUpsViewController
        vc.modifyChemistFollowupObj = followupOBj
        vc.isFromChemistDay = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func removeFollowUpDetails(followUpObj : DCRFollowUpModel)
    {
        if !isFromChemistDay
        {
            BL_DCR_Follow_Up.sharedInstance.deleteFollowUpDetail(followUpObj: followUpObj)
        }
    }
    private func removeChemistFollowUpdetails(followupObj: DCRChemistFollowup)
    {
        BL_DCR_Follow_Up.sharedInstance.deleteChemistFollowUpDetail(followUpObj: followupObj)
        
    }
    
    
    private func reloadTableView()
    {
        self.tableView.reloadData()
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
    
    //MARK:- Button Action
    
    @IBAction func barBtnAction(_ sender: Any)
    {
        if !isFromChemistDay && !isFromChemistDayRCPA && !isfromRCPAown
        {
            navigateToModifyFollowUpPage(followUpObj : nil)
        }
        else
        {
            if isFromChemistDayRCPA
            {
                let sb = UIStoryboard(name: ChemistDaySB, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.RcpaListVCID) as! RcpaListController
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if isFromChemistDay
            {
                let sb = UIStoryboard(name: Constants.StoaryBoardNames.FollowUpSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.AddFollowUpVcID) as! AddFollowUpsViewController
                vc.isFromChemistDay = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                let sb = UIStoryboard(name: detailProductSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: DetailProductVcID) as! DetailedProductViewController
                vc.isFromRCPA = true
                let dict : NSMutableDictionary = [:]
                dict.setValue(chemistDayRCPAObj?.DoctorCode, forKey: "Customer_Code")
                dict.setValue(chemistDayRCPAObj?.DoctorName, forKey: "Customer_Name")
                dict.setValue(EMPTY, forKey: "Region_Name")
                dict.setValue(chemistDayRCPAObj?.DoctorSpecialityName, forKey: "Speciality_Name")
                dict.setValue(chemistDayRCPAObj?.DoctorCategoryName, forKey: "Category_Name")
                dict.setValue(chemistDayRCPAObj?.DoctorMDLNumber, forKey: "MDL_Number")
                dict.setValue(chemistDayRCPAObj?.DoctorRegionCode, forKey: "Region_Code")
                let customerModel = CustomerMasterModel.init(dict: dict)
                vc.customerModel = customerModel
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    func convertRCPAToFollowupsModel(rcpaList:[DCRChemistRCPAOwn]) -> [DCRFollowUpModel]
    {
        var chemistDayRCPA :[DCRFollowUpModel] = []
        for obj in rcpaList
        {
            var firstText = ""
            var speciality = "NA"
            var mdl = "NA"
            if isFromChemistDayRCPA
            {
                firstText = obj.DoctorName
                if obj.DoctorSpecialityName != EMPTY
                {
                    speciality = obj.DoctorSpecialityName
                }
                if obj.DoctorMDLNumber != EMPTY
                {
                    mdl = obj.DoctorMDLNumber
                }
                let tasksText = "\(speciality) | \(mdl)"
                let dict = ["Tasks":obj.DoctorName,"DCR_Code":tasksText]
                let dcrFollowUpObj = DCRFollowUpModel(dict: dict as NSDictionary)
                chemistDayRCPA.append(dcrFollowUpObj)
            }
            else
            {
                firstText = obj.ProductName
                if obj.Quantity != nil
                {
                    speciality = String(obj.Quantity)
                }
                let tasksText = "\(speciality)"
                let dict = ["Tasks":firstText,"DCR_Code":tasksText]
                let dcrFollowUpObj = DCRFollowUpModel(dict: dict as NSDictionary)
                chemistDayRCPA.append(dcrFollowUpObj)
            }
            
            
        }
        return chemistDayRCPA
    }
    
    func convertChemistDayRCPAToDCRRCPAModel(obj: DCRChemistRCPAOwn) -> DCRRCPAModel
    {
        let dict = ["Visit_Id":obj.DCRChemistDayVisitId,"Own_Product_Code":obj.ProductCode,"Own_Product_Name":obj.ProductName,"Qty_Given":obj.Quantity,"DCR_Chemists_Id":0,"DCR_Id":0,"Own_Product_Id":obj.DCRChemistRCPAOwnId] as [String : Any]
        let dcrRCPA = DCRRCPAModel(dict: dict as NSDictionary)
        return dcrRCPA
    }
    
    func removeRCPAdetails(indexpath: Int)
    {
        let obj = chemistDAyRCPAOwn[indexpath]
        var docList: [DCRChemistRCPAOwn] = []
        if !isfromRCPAown
        {
            let doctorCode = checkNullAndNilValueForString(stringData: obj.DoctorCode)
            let doctorRegionCode = checkNullAndNilValueForString(stringData: obj.DoctorRegionCode)
            docList = BL_DCR_Chemist_Visit.sharedInstance.getRCPAEnteredDoctorsList(doctorCode: doctorCode, doctorRegionCode: doctorRegionCode, doctorName: obj.DoctorName, specialtyName: obj.DoctorSpecialityName)
            for rcpaObj in docList
            {
                BL_DCR_Chemist_Visit.sharedInstance.deleteChemistDayRCPA(chemistRCPAOwnId: rcpaObj.DCRChemistRCPAOwnId)
            }
        }
        else
        {
            BL_DCR_Chemist_Visit.sharedInstance.deleteChemistDayRCPA(chemistRCPAOwnId: obj.DCRChemistRCPAOwnId)
        }
        
        chemistDAyRCPAOwn.remove(at: indexpath)
        
    }
    
    func setNavigationTitle()
    {
        if isFromChemistDayRCPA
        {
            self.title = "\(appChemist) RCPA List"
        }
        else if isfromRCPAown
        {
            var docName:String!
            docName  = "\((chemistDayRCPAObj?.DoctorName)!) | \(String(describing: (chemistDayRCPAObj?.DoctorMDLNumber)!)) "
            self.title = docName!
        }
        else
        {
            self.title = "Follow-Ups Details"
        }
    }
    
    
}
