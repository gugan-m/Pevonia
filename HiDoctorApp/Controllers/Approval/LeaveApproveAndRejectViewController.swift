//
//  LeaveApproveAndRejectViewController.swift
//  HiDoctorApp
//
//  Created by User on 24/07/19.
//  Copyright © 2019 swaas. All rights reserved.
//

import UIKit

class LeaveApproveAndRejectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,ApprovalPopUpDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var lblLeaveTypeDate: UILabel!
    @IBOutlet weak var lblLeaveType: UILabel!
    @IBOutlet weak var lblReason: UILabel!
    @IBOutlet weak var lblUnapprovedReason: UILabel!
    @IBOutlet weak var tableviewAttachmentList: UITableView!
    
    @IBOutlet weak var emptyStateview: CornerRadiusForButton!
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var btnApprove: UIButton!
    
    
    
    //MARK:- Variable Declaration
    var leaveEntryDate: String!
    var leaveType: String!
    var leaveReason: String!
    var leaveUnapprovedReason: String!
    var selectedUserName: String!
    //var arrAttachmentList: NSArray!
    var arrAttachmentList = NSArray()
    var appliedAndApproved: Bool!
    var popUpView : ApprovalPoPUp!
    var userLeaveObj : LeaveApprovalModel!
    var isFromLeave: Bool!
    var selectedUserCode: String!
    var selectedRegionCode: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableviewAttachmentList.dataSource = self
        self.tableviewAttachmentList.delegate = self
        self.tableviewAttachmentList.tableFooterView = UIView()
        self.navigationItem.title = self.selectedUserName
        
        if(appliedAndApproved == true)
        {
            btnApprove.isHidden = false
            
        }
        else
        {
            btnApprove.isHidden = true
        }
        
        
        lblLeaveTypeDate.text = leaveEntryDate
        lblLeaveType.text = leaveType
        lblReason.text = leaveReason
        if (leaveUnapprovedReason == ""){
            lblUnapprovedReason.text = "N/A"
        }else{
            lblUnapprovedReason.text = leaveUnapprovedReason
        }
        
    }
    
    //MARK:- View will Appear
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.leaveattachmentname()
        
    }
    
    func leaveattachmentname()
    {
        
        if(arrAttachmentList.count == 0)
        {
            emptyStateview.isHidden = false
            tableviewAttachmentList.isHidden = true
        }
            
        else
        {
            emptyStateview.isHidden = true
            tableviewAttachmentList.isHidden = false
        }
    }
    
    
    //MARK:- tableview delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAttachmentList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! UITableViewCell
        let lblAttachmentName = cell.viewWithTag(1) as! UILabel
        lblAttachmentName.text = (arrAttachmentList[indexPath.row] as AnyObject).value(forKey: "Attachment_Name") as! String
        return cell
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 39
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let imageString = (arrAttachmentList[indexPath.row] as AnyObject).value(forKey: "Attachment_Url") as! String
        
        print(imageString)
        
        if let url = URL(string: imageString),
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data) {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        
        isFromLeave = true
    }
    
    //MARK:- Save Image to Gallery
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    
    @IBAction func actionReject(_ sender: Any) {
        self.addKeyBoardObserver()
        self.showPopUpView(type: ApprovalButtonType.reject)
    }
    
    @IBAction func actionApprove(_ sender: Any) {
        
        self.addKeyBoardObserver()
        self.showPopUpView(type: ApprovalButtonType.approval)
    }





    //MARK:- Pop Up View
    private func showPopUpView(type : ApprovalButtonType)
    {
        popUpView = ApprovalPoPUp.loadNib()
        
        popUpView.frame = CGRect(x: (SCREEN_WIDTH - 250)/2 ,  y:  SCREEN_HEIGHT, width: 250, height: popUpView.approvalPopUpHeight)
        popUpView.delegate = self
        popUpView.tag = 9000
        popUpView.leaveUserObj = userLeaveObj
        popUpView.statusButtonType = type
        popUpView.setDefaultDetailsForLeave()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let blackScreen : UIView = UIView(frame: appDelegate.window!.bounds)
        blackScreen.backgroundColor = UIColor.black
        blackScreen.alpha = 0.6
        blackScreen.tag = 3000
        appDelegate.window!.addSubview(blackScreen)
        appDelegate.window!.addSubview(popUpView)
        
        UIView.animate(withDuration: 0.3) { () -> Void in
            self.popUpView.frame.origin.y = (SCREEN_HEIGHT - self.popUpView.approvalPopUpHeight)/2
        }
    }
    
    func hidePopUpView()
    {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.popUpView.frame.origin.y = SCREEN_HEIGHT
        }) { (value) -> Void in
            self.popUpView.removeFromSuperview()
            let appDelegate = getAppDelegate()
            let blackScreen = appDelegate.window?.viewWithTag(3000)
            blackScreen?.removeFromSuperview()
        }
    }
    
    //MARK:- KeyBoard function
    private func addKeyBoardObserver()
    {
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(keyboardDidShow(_:)),
                           name: .UIKeyboardDidShow,
                           object: nil)
        
        center.addObserver(self,
                           selector: #selector(keyboardWillHide(_:)),
                           name: .UIKeyboardWillHide,
                           object: nil)
    }
    
    private func removeKeyBoardObserver()
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardDidShow(_ notification: NSNotification)
    {
        if let userInfo = notification.userInfo
        {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            {
                let remainingHeight = SCREEN_HEIGHT - keyboardSize.height
                self.popUpView.frame.origin.y = (remainingHeight - self.popUpView.approvalPopUpHeight)/2
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification)
    {
        self.popUpView.frame.origin.y = (SCREEN_HEIGHT - self.popUpView.approvalPopUpHeight)/2
    }
    
    //MARK:- Setting POPUP button Action
    func setPopUpBtnAction(type : ApprovalButtonType)
    {
        removeKeyBoardObserver()
        if type == ApprovalButtonType.approval
        {
            
         updateDCRStatus(approvalStatus : 2)
            
        }
        else if type == ApprovalButtonType.reject
        {
            
        updateDCRStatus(approvalStatus : 0)

        }
        hidePopUpView()
    }
    
    //MARK:- Updating DCR aand TP Approval Status
    private func updateDCRStatus(approvalStatus : Int)
    {
        userLeaveObj.approvalStatus = approvalStatus
        let strCheck = UserDefaults.standard.string(forKey: "ApprovalENABLED")
        
        if (strCheck == "0"){
            userLeaveObj.IsChecked = 0
        }else{
            userLeaveObj.IsChecked = 1
        }
        userLeaveObj.userCode = selectedUserCode
        userLeaveObj.regionCode = selectedRegionCode
        
        BL_Approval.sharedInstance.updateLeaveStatus1(userList: [userLeaveObj], leaveObj: userLeaveObj, reason: condenseWhitespace(stringValue: popUpView.reasonTxtView.text)) { (apiResponseObject) in
        
        //BL_Approval.sharedInstance.updateLeaveStatus(userList : [userLeaveObj], userObj: userObj, leaveObj: userLeaveObj, reason: condenseWhitespace(stringValue: popUpView.reasonTxtView.text)) { (apiResponseObject) in
            if apiResponseObject.Status == SERVER_SUCCESS_CODE
            {
                var toastText = getPopUpMsg(Flag: DCRFlag.leave.rawValue, status: DCRStatus.approved.rawValue, type : "DVR")
                if approvalStatus == 0
                {
                    toastText = getPopUpMsg(Flag: DCRFlag.leave.rawValue, status: DCRStatus.unApproved.rawValue, type : "DVR")
                }
                showToastView(toastText: toastText)
                _ = self.navigationController?.popViewController(animated: false)
            }
            else if apiResponseObject.Status == 2
            {
                showToastView(toastText: apiResponseObject.Message)
                _ = self.navigationController?.popViewController(animated: false)
            }
            else
            {
                var toastText = getPopUpMsg(Flag: DCRFlag.leave.rawValue, status: 4, type : "DVR")
                if approvalStatus == 0
                {
                    toastText = getPopUpMsg(Flag: DCRFlag.leave.rawValue, status: 5, type : "DVR")
                }
                showToastView(toastText: toastText)
            }
            
        }
    }

    
}
