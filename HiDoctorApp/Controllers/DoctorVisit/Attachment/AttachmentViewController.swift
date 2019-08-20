//
//  AttachmentViewController.swift
//  HiDoctorApp
//
//  Created by Vijay on 20/04/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class AttachmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DocumentDelegate {
    
    @IBOutlet weak var emptyStateWrapper: UIView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var isFromChemistDay = false
    var isfromLeave = false
    var  isFromNotes = false
    var attachmentList : [DCRAttachmentModel] = []
    var leaveAttachmentList : [DCRLeaveModel] = []

    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Attachments"
        NotificationCenter.default.addObserver(self, selector: #selector(self.iCloudObserverAction(_:)), name: NSNotification.Name(rawValue:"AttachmentViewRefresh"), object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadTableData()
    }
    
    func reloadTableData()
    {
       if(isFromChemistDay)
       {
        let attachmentArr = Bl_Attachment.sharedInstance.getDCRChemistAttachment(dcrId: DCRModel.sharedInstance.dcrId, chemistVisitId: ChemistDay.sharedInstance.chemistVisitId)
        
        let dcrAttachmentModel = Bl_Attachment.sharedInstance.convertToDCRAttachmentModel(list:attachmentArr!)
        if attachmentArr != nil
        {
            attachmentList = dcrAttachmentModel
        }
        }
        
        //isfromLeave
        
       else if(isfromLeave)
       {
        let attachmentArr = Bl_Attachment.sharedInstance.getDCRLeaveAttachment(dcrDate: DCRModel.sharedInstance.dcrDateString)
        //let dcrAttachmentModel = Bl_Attachment.sharedInstance.convertToDCRLeaveAttachmentModel(list: attachmentArr!)
        //getDCRLeaveAttachment(dcrDate: String) -> [DCRLeaveModel]? DCRModel.sharedInstance.dcrDateString
        if attachmentArr != nil
        {
            leaveAttachmentList = attachmentArr!
        }
        }
        
        else
       {
        let attachmentArr = Bl_Attachment.sharedInstance.getDCRAttachment(dcrId: DCRModel.sharedInstance.dcrId, doctorVisitId: DCRModel.sharedInstance.doctorVisitId)
        if attachmentArr != nil
        {
            attachmentList = attachmentArr!
        }
        }
        
        
        showHideViews()
    }
    
    //MARK:- Show/Hide views
    func showHideViews()
    {
        if(isfromLeave)
        {
            
            if leaveAttachmentList.count > 0
            {
                tableView.isHidden = false
                tableView.reloadData()
                emptyStateWrapper.isHidden = true
                
                
                loadFailedDownloads()
            }
            else
            {
                tableView.isHidden = true
                emptyStateWrapper.isHidden = false
                emptyStateLbl.text = attachmentEmptyMsg
            }
        }

        else
        {
        if attachmentList.count > 0
        {
            tableView.isHidden = false
            tableView.reloadData()
            emptyStateWrapper.isHidden = true
            
           
            loadFailedDownloads()

        }
        else
        {
            tableView.isHidden = true
            emptyStateWrapper.isHidden = false
            emptyStateLbl.text = attachmentEmptyMsg
        }
        }
    }
    
    func loadFailedDownloads()
    {
        if(isfromLeave)
        {
            for i in 0..<leaveAttachmentList.count
            {
                let model = leaveAttachmentList[i]
                if model.isFileDownloaded == 0
                {
                    getThumbImg(index: i)
                }
            }
        }
        
        else
        {
        for i in 0..<attachmentList.count
        {
            let model = attachmentList[i]
            if model.isFileDownloaded == 0
            {
                getThumbImg(index: i)
            }
        }
        }
    }
    
    //MARK:- Navigation bar button actions
    @IBAction func doneBtnClicked(_ sender: Any)
    {
        popController()
    }
    
    @IBAction func addBtnClicked(_ sender: Any)
    {
        if(isFromChemistDay)
        {
            self.showActionAndAlert(count: Bl_Attachment.sharedInstance.getChemistAttachmentCount())
        }
        
        else if(isfromLeave)
        {
            self.showActionAndAlert(count: Bl_Attachment.sharedInstance.getLeaveAttachmentCount())
        }
        else if(isFromNotes)
        {
            self.showActionAndAlert(count: 0)
        }
        else
        {
            
            self.showActionAndAlert(count: Bl_Attachment.sharedInstance.getAttachmentCount())
        }
    }
    
    func showActionAndAlert(count : Int)
    {
        if count < maxFileUploadCount
        {
            Attachment.sharedInstance.showAttachmentActionSheet(viewController: self)
            Attachment.sharedInstance.delegate = self
            Attachment.sharedInstance.isFromMessage = false
            Attachment.sharedInstance.isFromEditDoctor = false
        }
        else
        {
            AlertView.showAlertView(title: alertTitle, message: "You can not upload more than \(maxFileUploadCount) files")
        }
 
    }
    @IBAction func viewBtnClicked(_ sender: Any)
    {
        let index = (sender as AnyObject).tag
        showFileController(index: index!)
    }
    
    private func showFileController(index: Int)
    {
        
        if(isfromLeave)
        {
            //
            let model = leaveAttachmentList[index]
            if model.isFileDownloaded == -1
            {
                if(isfromLeave)
                {
                    Bl_Attachment.sharedInstance.updateLeaveAttachmentDownloadStatus(id: model.attachmentId, isDownloaded: 0)
                }
                
               // reloadTableData()
                getThumbImg(index: index)
            }
            else if model.isFileDownloaded == 1
            {
                let sb = UIStoryboard(name: Constants.StoaryBoardNames.AttachmentSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.FileViewVCID) as! FileViewController
                vc.leaveModel = model
                vc.isfromLeave = self.isfromLeave
                let navController = UINavigationController(rootViewController: vc)
                self.present(navController, animated: true, completion: nil)
            }

        }
       
        else
        {
        let model = attachmentList[index]
        if model.isFileDownloaded == -1
        {
            if(isFromChemistDay)
            {
                 Bl_Attachment.sharedInstance.updateChemsistAttachmentDownloadStatus(id: model.attachmentId, isDownloaded: 0)
            }
            else
            {
            Bl_Attachment.sharedInstance.updateAttachmentDownloadStatus(id: model.attachmentId, isDownloaded: 0)
            reloadTableData()
            }
            getThumbImg(index: index)
        }
        else if model.isFileDownloaded == 1
        {
            let sb = UIStoryboard(name: Constants.StoaryBoardNames.AttachmentSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.FileViewVCID) as! FileViewController
            vc.model = model
            vc.isFromChemistDay = self.isFromChemistDay
            let navController = UINavigationController(rootViewController: vc)
            self.present(navController, animated: true, completion: nil)
        }
        }
    }
    
    func getThumbImg(index: Int)
    {
        
        if(isfromLeave)
        {
            let model = leaveAttachmentList[index]
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async
                {
                    Bl_Attachment.sharedInstance.loadAttachmentImg(urlString: model.documentUrl!) { (data, url) in
                        DispatchQueue.main.async(execute:
                            {
                                if data != nil
                                {
                                    var fileExtension: String!
                                    var modifiedfileName: String!
                                    let fileSplittedString = model.documentUrl?.components(separatedBy: "/")
                                    
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "ddMMyyyyhhmmssSSS"
                                    let timestamp:String = formatter.string(from: getCurrentDateAndTime())
                                    
                                    if (fileSplittedString?.count)! > 0
                                    {
                                        let fileName = fileSplittedString?.last!
                                        fileExtension = png
                                        let extSplittedString = fileName?.components(separatedBy: ".")
                                        if (extSplittedString?.count)! > 0
                                        {
                                            fileExtension = extSplittedString?.last!
                                        }
                                        //modifiedfileName = "\(fileName!) - \(timestamp).\(fileExtension!)"
                                    }
                                    else
                                    {
                                        fileExtension = png
                                        //modifiedfileName = "\(timestamp)"
                                    }
                                    
                                    modifiedfileName = "\(timestamp).\(fileExtension!)"
                                    Bl_Attachment.sharedInstance.saveAttachmentFile(fileData: data!, fileName: modifiedfileName)
                                    Bl_Attachment.sharedInstance.updateLeaveAttachmentDownloadStatus(id: model.attachmentId, isDownloaded: 1)
                                    Bl_Attachment.sharedInstance.updateLeaveAttachmentName(id: model.attachmentId, fileName: modifiedfileName)
                                }
                                else
                                {
                                    Bl_Attachment.sharedInstance.updateLeaveAttachmentDownloadStatus(id: model.attachmentId, isDownloaded: -1)
                                }
                                
                                self.reloadTableData()
                        })
                    }
            }
        }
        else
        {
        
        let model = attachmentList[index]
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async
            {
                Bl_Attachment.sharedInstance.loadAttachmentImg(urlString: model.attachmentBlobUrl!) { (data, url) in
                    DispatchQueue.main.async(execute:
                        {
                            if data != nil
                            {
                                var fileExtension: String!
                                var modifiedfileName: String!
                                let fileSplittedString = model.attachmentBlobUrl?.components(separatedBy: "/")
                                
                                let formatter = DateFormatter()
                                formatter.dateFormat = "ddMMyyyyhhmmssSSS"
                                let timestamp:String = formatter.string(from: getCurrentDateAndTime())
                                
                                if (fileSplittedString?.count)! > 0
                                {
                                    let fileName = fileSplittedString?.last!
                                    fileExtension = png
                                    let extSplittedString = fileName?.components(separatedBy: ".")
                                    if (extSplittedString?.count)! > 0
                                    {
                                        fileExtension = extSplittedString?.last!
                                    }
                                    //modifiedfileName = "\(fileName!) - \(timestamp).\(fileExtension!)"
                                }
                                else
                                {
                                    fileExtension = png
                                    //modifiedfileName = "\(timestamp)"
                                }
                                
                                modifiedfileName = "\(timestamp).\(fileExtension!)"
                                Bl_Attachment.sharedInstance.saveAttachmentFile(fileData: data!, fileName: modifiedfileName)
                                Bl_Attachment.sharedInstance.updateAttachmentDownloadStatus(id: model.attachmentId, isDownloaded: 1)
                                Bl_Attachment.sharedInstance.updateAttachmentName(id: model.attachmentId, fileName: modifiedfileName)
                            }
                            else
                            {
                                Bl_Attachment.sharedInstance.updateAttachmentDownloadStatus(id: model.attachmentId, isDownloaded: -1)
                            }
                            
                            self.reloadTableData()
                    })
                }
        }
            
        }
    }
    
    @IBAction func removeBtnClicked(_ sender: Any)
    {
        let index = (sender as AnyObject).tag
        showRemoveAlert(tag: index!)
    }
    
    private func showRemoveAlert(tag: Int)
    {
        let alert = UIAlertController(title: "Alert", message: "Do you want to Remove?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Remove", style: .default, handler: { (action: UIAlertAction!) in
            self.removeAction(tag: tag)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func removeAction(tag: Int)
    {
        if(isfromLeave)
        {
          let model1 = leaveAttachmentList[tag]
            if(isfromLeave)
            {
                
                Bl_Attachment.sharedInstance.deleteLeaveAttachment(id: model1.attachmentId, fileName: model1.attachmentName!)
            }
        }
        else
        {
          let model = attachmentList[tag]
            if(isFromChemistDay)
            {
                Bl_Attachment.sharedInstance.deleteChemistAttachment(id: model.doctorVisitId, fileName: model.attachmentName!)
            }
            else
            {
                Bl_Attachment.sharedInstance.deleteAttachment(id: model.attachmentId, fileName: model.attachmentName!)
            }
        }
        reloadTableData()
        tableView.reloadData()
    }
    
    private func popController()
    {
        _ = navigationController?.popViewController(animated: false)
    }
    
    //MARK:- Attachment class delegate
    func getDocumentResponse() {
        reloadTableData()
    }
    
    //MARK:- Tableview delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isfromLeave)
        {
            return leaveAttachmentList.count
        }
        else
        {
            return attachmentList.count
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if(isfromLeave)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.AttachmentCell) as! AttachmentTableviewCell
            
            let model = leaveAttachmentList[indexPath.row]
            
            if model.isFileDownloaded == -1
            {
                let thumbFileURL = Bl_Attachment.sharedInstance.getAttachmentFileURL(fileName: model.attachmentName!)
                if thumbFileURL != ""
                {
                    Bl_Attachment.sharedInstance.updateLeaveAttachmentDownloadStatus(id: model.attachmentId, isDownloaded: 1)
                    reloadTableData()
                }
                else
                {
                    cell.imgBtn.isEnabled = true
                    cell.imgBtn.setImage(UIImage(named: "icon-fileDownload"), for: .normal)
                    cell.indicatorView.isHidden = true
                    if cell.indicatorView.isAnimating
                    {
                        cell.indicatorView.stopAnimating()
                    }
                }
            }
            else if model.isFileDownloaded == 0
            {
                cell.imgBtn.isEnabled = false
                cell.imgBtn.setImage(nil, for: .normal)
                cell.indicatorView.isHidden = false
                cell.indicatorView.startAnimating()
            }
            else if model.isFileDownloaded == 1
            {
                cell.imgBtn.isEnabled = true
                cell.imgBtn.setImage(nil, for: .normal)
                cell.indicatorView.isHidden = true
                if cell.indicatorView.isAnimating
                {
                    cell.indicatorView.stopAnimating()
                }
                
                let thumbFileURL = Bl_Attachment.sharedInstance.getAttachmentFileURL(fileName: model.attachmentName!)
                if thumbFileURL != ""
                {
                    if let image = UIImage(contentsOfFile: thumbFileURL)
                    {
                        if let thumbImg = Bl_Attachment.sharedInstance.thumbImageResize(image: image, newWidth: cell.imageWidthConst.constant)
                        {
                            cell.thumbImg.image = thumbImg
                        }
                        else
                        {
                            cell.thumbImg.image = UIImage(named: "image-placeholder")
                        }
                    }
                    else
                    {
                        cell.thumbImg.image = UIImage(named: "image-placeholder")
                    }
                }
                else
                {
                    cell.thumbImg.image = UIImage(named: "image-placeholder")
                }
            }
            cell.imageName.text = model.attachmentName
            if model.attachmentSize != ""
            {
                cell.imageSizeLbl.text = model.attachmentSize
            }
            else
            {
                cell.imageSizeLbl.text = NOT_APPLICABLE
            }
            cell.viewBtn.tag = indexPath.row
            cell.removeBtn.tag = indexPath.row
            cell.imgBtn.tag = indexPath.row
            
            return cell
            
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.AttachmentCell) as! AttachmentTableviewCell
        let model = attachmentList[indexPath.row]
        
        if model.isFileDownloaded == -1
        {
            let thumbFileURL = Bl_Attachment.sharedInstance.getAttachmentFileURL(fileName: model.attachmentName!)
            if thumbFileURL != ""
            {
                Bl_Attachment.sharedInstance.updateAttachmentDownloadStatus(id: model.attachmentId, isDownloaded: 1)
                reloadTableData()
            }
            else
            {
                cell.imgBtn.isEnabled = true
                cell.imgBtn.setImage(UIImage(named: "icon-fileDownload"), for: .normal)
                cell.indicatorView.isHidden = true
                if cell.indicatorView.isAnimating
                {
                    cell.indicatorView.stopAnimating()
                }
            }
        }
        else if model.isFileDownloaded == 0
        {
            cell.imgBtn.isEnabled = false
            cell.imgBtn.setImage(nil, for: .normal)
            cell.indicatorView.isHidden = false
            cell.indicatorView.startAnimating()
        }
        else if model.isFileDownloaded == 1
        {
            cell.imgBtn.isEnabled = true
            cell.imgBtn.setImage(nil, for: .normal)
            cell.indicatorView.isHidden = true
            if cell.indicatorView.isAnimating
            {
                cell.indicatorView.stopAnimating()
            }
            
            let thumbFileURL = Bl_Attachment.sharedInstance.getAttachmentFileURL(fileName: model.attachmentName!)
            if thumbFileURL != ""
            {
                if let image = UIImage(contentsOfFile: thumbFileURL)
                {
                    if let thumbImg = Bl_Attachment.sharedInstance.thumbImageResize(image: image, newWidth: cell.imageWidthConst.constant)
                    {
                        cell.thumbImg.image = thumbImg
                    }
                    else
                    {
                        cell.thumbImg.image = UIImage(named: "image-placeholder")
                    }
                }
                else
                {
                    cell.thumbImg.image = UIImage(named: "image-placeholder")
                }
            }
            else
            {
                cell.thumbImg.image = UIImage(named: "image-placeholder")
            }
        }
        
        cell.imageName.text = model.attachmentName
        if model.attachmentSize != ""
        {
            cell.imageSizeLbl.text = model.attachmentSize
        }
        else
        {
            cell.imageSizeLbl.text = NOT_APPLICABLE
        }
        cell.viewBtn.tag = indexPath.row
        cell.removeBtn.tag = indexPath.row
        cell.imgBtn.tag = indexPath.row
        
        return cell
        }
    }
    @objc func iCloudObserverAction(_ notification: NSNotification)
    {
        reloadTableData()
    }
}
