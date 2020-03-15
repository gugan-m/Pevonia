//
//  DCRAttachmentUploadController.swift
//  HiDoctorApp
//
//  Created by Vijay on 10/05/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class DCRAttachmentUploadController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var attachmentList: [DCRAttachmentModel] = []
    var leaveAttachmentList: [DCRLeaveModel] = []
    var tpAttachmentList: [TPAttachmentModel] = []
    var isfromLeave = false
    var isfromTP = false
    
    @IBOutlet weak var emptyStateWrapper: UIView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Upload Attachments"
        
        tableView.estimatedRowHeight = 500
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateAttachmentStatus(_:)), name: NSNotification.Name(rawValue: attachmentNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateChemistAttachmentStatus(_:)), name: NSNotification.Name(rawValue: chemistAttachmentNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateChemistAttachmentStatus(_:)), name: NSNotification.Name(rawValue: chemistAttachmentNotification), object: nil)
        
        addCustomBackButtonToNavigationBar()
        if isfromTP {
            DBHelper.sharedInstance.updateFailureTPAttachmentStatus()
            let tpAttachment = DBHelper.sharedInstance.getUploadableTPAttachments()
            tpAttachmentList = tpAttachment
            
            if BL_AttachmentOperation.sharedInstance.statusList.count == 0
            {
                BL_AttachmentOperation.sharedInstance.initiateTPOperation()
            }
            
        } else {
            DBHelper.sharedInstance.updateFailureAttachmentStatus()
            let doctorAttachment = DBHelper.sharedInstance.getUploadableAttachments()
            let chemistAttachment = DBHelper.sharedInstance.getChemistUploadableAttachments()
            let convertedChemistAttachments = convertChemistAttachmentToDoctorAttachment(lstChemistAttachment: chemistAttachment)
            let leaveAttachment = DBHelper.sharedInstance.getLeaveUploadableAttachments(dcrDate: DCRModel.sharedInstance.dcrDateString)
            
            leaveAttachmentList = leaveAttachment
            
            attachmentList = doctorAttachment
            attachmentList.append(contentsOf: convertedChemistAttachments)
            
            if BL_AttachmentOperation.sharedInstance.statusList.count == 0
            {
                BL_AttachmentOperation.sharedInstance.initiateOperation()
            }
            
            if (BL_Chemist_AttachmentOperation.sharedInstance.statusList.count == 0)
            {
                BL_Chemist_AttachmentOperation.sharedInstance.initiateOperation()
            }
            if BL_Leave_AttachmentOperation.sharedInstance.statusList.count == 0
            {
                BL_Leave_AttachmentOperation.sharedInstance.initiateOperation()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if (isfromTP){
        
        if tpAttachmentList.count > 0
        {
            tableView.isHidden = false
            emptyStateWrapper.isHidden = true
        }
        else
        {
            tableView.isHidden = true
            emptyStateWrapper.isHidden = false
            
            if checkInternetConnectivity()
            {
                emptyStateLbl.text = "No Attachments to upload"
            }
            else
            {
                emptyStateLbl.text = internetOfflineMessage
            }
        }
        
        }else if(isfromLeave)
        {
            if leaveAttachmentList.count > 0
            {
                tableView.isHidden = false
                emptyStateWrapper.isHidden = true
            }
            else
            {
                tableView.isHidden = true
                emptyStateWrapper.isHidden = false
                
                if checkInternetConnectivity()
                {
                    emptyStateLbl.text = "No Attachments to upload"
                }
                else
                {
                    emptyStateLbl.text = internetOfflineMessage
                }
            }
        }
        else
        {
         
            if attachmentList.count > 0
            {
                tableView.isHidden = false
                emptyStateWrapper.isHidden = true
            }
            else
            {
                tableView.isHidden = true
                emptyStateWrapper.isHidden = false
                
                if checkInternetConnectivity()
                {
                    emptyStateLbl.text = "No Attachments to upload"
                }
                else
                {
                    emptyStateLbl.text = internetOfflineMessage
                }
            }
        }
        
//        if attachmentList.count > 0
//        {
//            tableView.isHidden = false
//            emptyStateWrapper.isHidden = true
//        }
//        else
//        {
//            tableView.isHidden = true
//            emptyStateWrapper.isHidden = false
//
//            if checkInternetConnectivity()
//            {
//                emptyStateLbl.text = "No Attachments to upload"
//            }
//            else
//            {
//                emptyStateLbl.text = internetOfflineMessage
//            }
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func updateAttachmentStatus(_ notification: NSNotification)
    {
        if let attachmentId = notification.userInfo?["id"] as? Int
        {
            if let status = notification.userInfo?["status"] as? Int
            {
                attachmentList = Bl_Attachment.sharedInstance.updateAttendanceStatus(id: attachmentId, status: status, attachmentModel: attachmentList, isChemistAttachment: false)
                tableView.reloadData()
            }
        }
    }
    
    @objc func updateChemistAttachmentStatus(_ notification: NSNotification)
    {
        if let attachmentId = notification.userInfo?["id"] as? Int
        {
            if let status = notification.userInfo?["status"] as? Int
            {
                attachmentList = Bl_Attachment.sharedInstance.updateAttendanceStatus(id: attachmentId, status: status, attachmentModel: attachmentList, isChemistAttachment: true)
                tableView.reloadData()
            }
        }
    }
    
    @objc func updateTPAttachmentStatus(_ notification: NSNotification)
    {
        if let attachmentId = notification.userInfo?["id"] as? Int
        {
            if let status = notification.userInfo?["status"] as? Int
            {
                tpAttachmentList = Bl_Attachment.sharedInstance.updateTPAttachmentStatus(id: attachmentId, status: status, attachmentModel: tpAttachmentList)
                tableView.reloadData()
            }
        }
    }
    
    //MARK:- Tableview delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isfromTP){
            return tpAttachmentList.count
        }else if(isfromLeave)
        {
            return leaveAttachmentList.count
        }
        else
        {
            return attachmentList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.DCRAttachmentUploadCell) as! AttachmentUploadCell
        
        if (isfromTP){
            let model = tpAttachmentList[indexPath.row]
             cell.attachmentName.text = model.attachmentName
            if model.isSuccess == 1
            {
                cell.statusImgView.image = UIImage(named: "icon-attachment-tick")
                cell.statusImgView.isHidden = false
                
                if cell.activityIndicator.isAnimating
                {
                    cell.activityIndicator.stopAnimating()
                }
                
                cell.activityIndicator.isHidden = true
            }
            else if model.isSuccess == 0
            {
                cell.statusImgView.image = UIImage(named: "icon-attachment-close")
                cell.statusImgView.isHidden = false
                
                if cell.activityIndicator.isAnimating
                {
                    cell.activityIndicator.stopAnimating()
                }
                
                cell.activityIndicator.isHidden = true
            }
            else
            {
                cell.statusImgView.image = nil
                cell.statusImgView.isHidden = true
                cell.activityIndicator.startAnimating()
                cell.activityIndicator.isHidden = false
            }
        } else  {
            let model = attachmentList[indexPath.row]
            
            cell.attachmentName.text = model.attachmentName
            cell.attachmentSize.text = model.attachmentSize
            cell.attachmentDate.text = model.dcrDate
            
            if (!model.isChemistAttachment)
            {
                cell.doctorDetail.text = "\(model.doctorName!)-\(model.doctorSpecialityName!)"
            }
            else
            {
                cell.doctorDetail.text = EMPTY
            }
            
            if model.isSuccess == 1
            {
                cell.statusImgView.image = UIImage(named: "icon-attachment-tick")
                cell.statusImgView.isHidden = false
                
                if cell.activityIndicator.isAnimating
                {
                    cell.activityIndicator.stopAnimating()
                }
                
                cell.activityIndicator.isHidden = true
            }
            else if model.isSuccess == 0
            {
                cell.statusImgView.image = UIImage(named: "icon-attachment-close")
                cell.statusImgView.isHidden = false
                
                if cell.activityIndicator.isAnimating
                {
                    cell.activityIndicator.stopAnimating()
                }
                
                cell.activityIndicator.isHidden = true
            }
            else
            {
                cell.statusImgView.image = nil
                cell.statusImgView.isHidden = true
                cell.activityIndicator.startAnimating()
                cell.activityIndicator.isHidden = false
            }
        }
        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: attachmentNotification), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: chemistAttachmentNotification), object: nil)
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
    
    private func convertChemistAttachmentToDoctorAttachment(lstChemistAttachment: [DCRChemistAttachment]) -> [DCRAttachmentModel]
    {
        var lstDoctorAttachment: [DCRAttachmentModel] = []
        
        for objChemistAttachment in lstChemistAttachment
        {
            let dict: NSDictionary = ["DCR_Visit_Code": EMPTY, "DCR_Id": objChemistAttachment.DCRId, "DCR_Code": objChemistAttachment.DCRCode, "Visit_Id": objChemistAttachment.DCRChemistDayVisitId, "Attachment_Size": EMPTY, "Blob_Url": objChemistAttachment.BlobUrl, "Uploaded_File_Name": objChemistAttachment.UploadedFileName, "DCR_Actual_Date": getServerFormattedDateString(date: objChemistAttachment.DCRActualDate), "Doctor_Name": EMPTY, "Speciality_Name": EMPTY, "IsFile_Downloaded": -1]
            let objDoctorAttachment: DCRAttachmentModel = DCRAttachmentModel(dict: dict)
            objDoctorAttachment.attachmentId = objChemistAttachment.DCRChemistAttachmentId
            objDoctorAttachment.isChemistAttachment = true
            
            lstDoctorAttachment.append(objDoctorAttachment)
        }
        
        return lstDoctorAttachment
    }
}
