//
//  AssetMenuListViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 18/05/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class AssetMenuListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate
{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var assetMenuList : [AssetsMenuModel] = []
    var assetObj : AssetHeader!
    var isToShowList : Bool = false
    var delegate : AssetsSelectedDelegate?
    var isComingFromDigitalAssets : Bool = false
    var showListObj = ShowListModel()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setAssetMenuList()
        addTapGestureForView()
        NotificationCenter.default.addObserver(self, selector: #selector(updateDownloadStatus(_:)), name: NSNotification.Name(rawValue: assetNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: assetNotification), object: nil)
    }
    
    
    override func viewDidLayoutSubviews()
    {
        self.tableView.layoutIfNeeded()
        self.tableViewHeight.constant = tableView.contentSize.height
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return assetMenuList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.AssetsMenuListCell, for: indexPath) as! AssetsMenuListTableViewCell
        
        let assetMenuObj = assetMenuList[indexPath.row]
        cell.menuNameLbl.text = assetMenuObj.menuName
        cell.menuImg.image = UIImage(named : assetMenuObj.menuLeftIcon)
        
      
        if isToShowList{
            if showListObj.storyEnabled{
            cell.rightIcon.image = UIImage(named: "icon-movie")
            }else{
            cell.rightIcon.image = getAssetThumbnailIcon(docType: showListObj.assetDetail.docType)
            }
        }else{
        cell.rightIcon.image = getAssetThumbnailIcon(docType: assetObj.docType)
        }
        cell.switchBtnWidth.constant = 0
        cell.rightIconWidth.constant = 0
        cell.activityIndicatorWidth.constant = 0
        cell.switchBtn.isHidden = true
        cell.sepView.isHidden = true
        cell.sepViewLeadingConst.constant = 0
        
        if indexPath.row ==  menuIndex.assetName
        {
            cell.rightIconWidth.constant = 20
        }
        
        if indexPath.row == menuIndex.assetName || indexPath.row == menuIndex.play || indexPath.row == menuIndex.showList
        {
            cell.sepView.isHidden = false
            if assetMenuObj.menuId == 2  || assetMenuObj.menuId == 3
            {
                cell.sepViewLeadingConst.constant = 32
            }
        }
        
        if isToShowList && showListObj.storyEnabled{
            return cell
        }
        
        if (assetMenuObj.menuId == 4 && assetObj.isDownloadable == 1)
        {
            cell.switchBtnWidth.constant = 49
            if assetObj.isDownloaded == isFileDownloaded.completed.rawValue || checkNullAndNilValueForString(stringData: assetObj.localUrl) != EMPTY
            {
               cell.switchBtn.setOn(true, animated: true)
            }
            cell.switchBtn.isHidden = false
        }
        
        if assetObj.isDownloaded == isFileDownloaded.progress.rawValue && assetMenuObj.menuId == 4
        {
            cell.activityIndicatorWidth.constant = 20
            cell.switchBtn.isUserInteractionEnabled = false
            cell.switchBtn.alpha = 0.5
            cell.switchBtn.setOn(true, animated: true)
        }
        
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let assetMenuObj = assetMenuList[indexPath.row]
        
        if isToShowList && showListObj.storyEnabled{
            dismissViewController()
            delegate?.navigateToSelectedList(type: assetMenuObj.menuId, isMenu: true)
        }else{
        
        if  assetMenuObj.menuId != 4
        {
            if (getDocTypeVal(docType: (assetObj.docType)!) == Constants.DocType.zip) && (checkNullAndNilValueForString(stringData: assetObj.localUrl) == EMPTY) && ( assetMenuObj.menuId == 2) && (assetObj.isDownloaded != isFileDownloaded.progress.rawValue)
            {
                    dismissViewController()
                    delegate?.navigateToSelectedList(type: assetMenuObj.menuId, isMenu: true)
            }
            else if !((getDocTypeVal(docType: (assetObj.docType)!) == Constants.DocType.zip) && (assetObj.isDownloaded == isFileDownloaded.progress.rawValue) && (assetMenuObj.menuId == 2))
            {
                dismissViewController()
                delegate?.navigateToSelectedList(type: assetMenuObj.menuId, isMenu: true)
            }
        }
      }
    }

    private func setAssetMenuList()
    {
        var assetname = ""
        if isToShowList{
            if showListObj.storyEnabled {
                assetname = showListObj.storyObj.storyObj.Story_Name
            }else{
                assetObj = showListObj.assetDetail
                assetname = assetObj.daName
            }
        }else{
        assetname = assetObj.daName
        }
        
        assetMenuList = BL_AssetModel.sharedInstance.getAssetsMenuList(assetName : assetname)
        if isToShowList 
        {
            self.assetMenuList.remove(at: menuIndex.showList)
        }
        
        if isToShowList && showListObj.storyEnabled{
            self.assetMenuList.remove(at: menuIndex.availableOffline - 1)
        }else{
            
        if !isToShowList{
           self.assetMenuList.removeLast()
        }
            
        if assetObj.isDownloadable == 0
        {
            if isComingFromDigitalAssets
            {
                self.assetMenuList.remove(at: menuIndex.showList)

            }
            else
            {
              self.assetMenuList.remove(at: menuIndex.availableOffline)
            }
        }
      }
        
        if isComingFromDigitalAssets{
            
            self.assetMenuList.remove(at: menuIndex.preview)
            self.assetMenuList.remove(at: menuIndex.preview)
            
        }
            if showListObj.storyEnabled {
                self.assetMenuList.removeLast()
            }

    }
    
    @IBAction func switchBtnAction(_ sender: UISwitch)
    {
        if sender.isOn
        {
            if checkInternetConnectivity()
            {
                if assetObj.isDownloadable == 1
                {
                    showToastView(toastText: assetDownloadMessage)
                    downloadAssetsForMenu()
                }
                else
                {
                    showToastView(toastText: "Selected resources cannot be downloaded")
                    sender.setOn(false, animated: true)
                    reloadIndex()
                }
            }
            else
            {
                showToastView(toastText: internetOfflineMessage)
                sender.setOn(false, animated: true)
                reloadIndex()
            }
        }
        else
        {
            assetObj.isDownloaded = isFileDownloaded.pending.rawValue
            assetObj.localUrl = EMPTY
            BL_AssetModel.sharedInstance.updateDownloadStatus(selectedList: [assetObj], status: isFileDownloaded.pending.rawValue)
            BL_AssetDownloadOperation.sharedInstance.deleteAssetFile(fileName: assetObj.localUrl, subFolder: "\(assetObj.daCode!)")
            BL_AssetModel.sharedInstance.deleteAssetsByDacode(daCode :"\(assetObj.daCode!)")
            delegate?.navigateToSelectedList(type: 4, isMenu: true)
            reloadIndex()
        }
    }
    
    private func downloadAssetsForMenu()
    {
        assetObj.isDownloaded = isFileDownloaded.progress.rawValue
        BL_AssetModel.sharedInstance.updateDownloadStatus(selectedList: [assetObj], status: isFileDownloaded.progress.rawValue)
        if BL_AssetDownloadOperation.sharedInstance.statusList.count == 0
        {
            BL_AssetDownloadOperation.sharedInstance.initiateOperation()
        }
        delegate?.navigateToSelectedList(type:4, isMenu: true)
        reloadIndex()
    }
    
    private func reloadIndex()
    {
        self.tableView.reloadData()
    }
    
    private func addTapGestureForView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissViewController))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissViewController()
    {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func updateDownloadStatus(_ notification: NSNotification)
    {
        assetObj = BL_AssetModel.sharedInstance.getAssetByDaCode(daCode: assetObj.daCode)
        reloadIndex()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.tableView) == true {
            return false
        }
        return true
    }
    
//    @IBAction func sectionCoverBtnAction(_ sender: UIButton)
//    {
//        let section = sender.tag
//        let assetMenuObj = assetMenuList[section]
//        assetMenuObj.isExpanded = !assetMenuObj.isExpanded
//        self.tableView.reloadData()
//        self.tableView.layoutIfNeeded()
//        self.tableViewHeight.constant = tableView.contentSize.height
//    }
    
}
