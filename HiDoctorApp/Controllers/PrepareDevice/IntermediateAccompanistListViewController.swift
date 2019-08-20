//
//  IntermediateAccompanistListViewController.swift
//  HiDoctorApp
//
//  Created by Vignaya on 11/7/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class IntermediateAccompanistListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var downloadBtn : UIButton!
    @IBOutlet weak var accompanistHeaderLbl: UILabel!
    
    var accompanistList : [UserMasterWrapperModel] = []
    var selectedAccompanyList : NSMutableArray = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        accompanistHeaderLbl.text = "Following list shows your colleague names who have frequently accompanied you during \(appDoctor) visits. Select them to download their \(appDoctor) details to enter your DCRs without internet."
        
        getAccompanistList()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
        showVersionToastView(textColor : UIColor.white)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accompanistList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var defaultHeight : CGFloat = 27 + 8
        let constraintWidth = SCREEN_WIDTH - 116
        let accompanistObj = accompanistList[indexPath.row]
        let accompanistDetail = accompanistObj.userObj
        let employeeName = accompanistDetail.Employee_name
        let username = accompanistDetail.User_Name
        let designation = accompanistDetail.User_Type_Name + accompanistDetail.Region_Name
        
        defaultHeight += getTextSize(text: employeeName, fontName: fontSemiBold, fontSize: 15, constrainedWidth: constraintWidth).height
        
        defaultHeight += getTextSize(text: username, fontName: fontRegular, fontSize: 13, constrainedWidth: constraintWidth).height
        
        defaultHeight += getTextSize(text: designation, fontName: fontRegular, fontSize: 13, constrainedWidth: constraintWidth).height
        
        return defaultHeight
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "AccompanistCell", for: indexPath) as! IntermediateAccompanistTableViewCell
        
        let accompanistObj = accompanistList[indexPath.row]
        let accompanistDetail = accompanistObj.userObj
        let employeeName = accompanistDetail.Employee_name as String
        let username = accompanistDetail.User_Name as String
        let designation = accompanistDetail.User_Type_Name as String
        let regionName  = accompanistDetail.Region_Name as String
        
        cell.headerLbl.text = employeeName
        
        if username != ""
        {
            cell.userName.text = "User Name: \(username) | "
        }
        
        if designation != ""
        {
            cell.designationLbl.text = "Designation: \(designation) | \(regionName)"
        }
        
        if accompanistObj.isSelected
        {
            cell.imgView.image = UIImage(named: "icon-tick")
        }
        else
        {
            cell.imgView.image = UIImage(named: "icon-unselected")
        }
        
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let accompanistObj = accompanistList[indexPath.row]
        
        if accompanistObj.isSelected  == false
        {
            if selectedAccompanyList.count < 4
            {
                accompanistObj.isSelected = true
                selectedAccompanyList.add(accompanistObj)
            }
            else
            {
                accompanistObj.isSelected  = false
                AlertView.showAlertView(title: alertTitle, message: "You are allowed to choose maximum of four accompanists only", viewController: self)
            }
        }
        else
        {
            accompanistObj.isSelected = false
            if selectedAccompanyList.count > 0
            {
                selectedAccompanyList.remove(accompanistObj)
            }
        }
        
        self.setButtonTextColor()
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
        
    }
    
    @IBAction func showAllEmployeeBtnAction(_ sender: AnyObject)
    {
        removeVersionToastView()
        self.navigationController?.isNavigationBarHidden = false
        let accom_sb = UIStoryboard(name: commonListSb, bundle: nil)
        let accom_vc = accom_sb.instantiateViewController(withIdentifier: userListVcID) as! UserListViewController
        accom_vc.navigationScreenName = "accompanistList"
        accom_vc.navigationTitle = "Employee List"
        self.navigationController?.pushViewController(accom_vc, animated: false)
    }
    
    
    @IBAction func downloadBtnAction(_ sender: AnyObject)
    {
        let userMasterList = covertToUserMasterModel()
        if userMasterList.count > 0
        {
            self.navigationController?.navigationBar.isHidden = false
            let prepare_sb = UIStoryboard(name: prepareMyDeviceSb, bundle: nil)
            let prepare_vc = prepare_sb.instantiateViewController(withIdentifier: PrepareDeviceVcID) as! PrepareMyDeviceViewController
            prepare_vc.accompanistDataDownloadList = userMasterList
            prepare_vc.isComingFromAccompanistPage = true
            self.navigationController?.pushViewController(prepare_vc, animated: true)
        }
    }
    
    @IBAction func skipBtnAction(_ sender: AnyObject)
    {
        BL_PrepareMyDeviceAccompanist.sharedInstance.endAccomapnistDataDownload()
        
        if (!BL_Password.sharedInstance.isPasswordPolicyEnabled())
        {
            let appdelegate = getAppDelegate()
            appdelegate.allocateRootViewController(sbName: landingViewSb, vcName: landingVcID)
        }
        else
        {
            BL_Password.sharedInstance.getUserAccountDetailsForPMD(viewController: self, completion: { (serverTime) in
                if (serverTime != EMPTY)
                {
                    BL_Password.sharedInstance.checkPasswordStatusForPMD(viewController: self, serverTime: serverTime)
                }
            })
        }
    }
    
    func getAccompanistList()
    {
        accompanistList = convertToUserMasterModel(accompanistList: BL_PrepareMyDeviceAccompanist.sharedInstance.getFrequentAccompanists()!)
    }
    
    func convertToUserMasterModel(accompanistList : [AccompanistModel]) -> [UserMasterWrapperModel]
    {
        var userList: [UserMasterWrapperModel] = []
        
        if accompanistList.count > 0
        {
            for accompanistObj in accompanistList
            {
                let wrapObj : UserMasterWrapperModel = UserMasterWrapperModel()
                let userObj : UserMasterModel = UserMasterModel()
                userObj.Employee_name = accompanistObj.Employee_name
                userObj.Region_Name = accompanistObj.Region_Name
                userObj.Region_Code = accompanistObj.Region_Code
                userObj.User_Code = accompanistObj.User_Code
                userObj.User_Type_Name = accompanistObj.User_Type_Name
                userObj.User_Name = accompanistObj.User_Name
                wrapObj.userObj = userObj
                wrapObj.isSelected = false
                userList.append(wrapObj)
            }
        }
        return userList
        
    }
    
    func covertToUserMasterModel() -> [UserMasterModel]
    {
        var userMasterList : [UserMasterModel] = []
        if selectedAccompanyList.count > 0
        {
            for obj in selectedAccompanyList
            {
                var userObj : UserMasterModel = UserMasterModel()
                userObj = (obj as! UserMasterWrapperModel).userObj
                userMasterList.append(userObj)
            }
        }
        
        return userMasterList
    }
  
    func setButtonTextColor()
    {
        if selectedAccompanyList.count > 0
        {
            let textColor  = UIColor(red: 0/255, green: 150/255, blue: 136/255, alpha: 1.0)
            self.downloadBtn.setTitleColor(textColor, for: UIControlState.normal)
        }
    }
}

