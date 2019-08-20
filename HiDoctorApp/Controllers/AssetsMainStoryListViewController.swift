 //
//  AssetsMainStoryListViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 28/06/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class AssetsMainStoryListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource , StorySelectionDelegate
{
    @IBOutlet weak var tableView : UITableView!
    
    @IBOutlet weak var emptyStateView: UIView!
    
    @IBOutlet weak var emptyStateLabel: UILabel!
    
    @IBOutlet weak var targetLabel: UILabel!
    var assetsList : [AssetMandatoryListModel] = []
    var isComingFromMandatory = false
    var isComingForSelection = false
    var refreshControl: UIRefreshControl!
    var selectedList : NSMutableArray = []
    var addBtn : UIBarButtonItem!
    var delegate : deleteOrAddShowListDelegate!
    var isComingFromDigitalAssets : Bool = false

    override func viewDidLoad()
    {
        super.viewDidLoad()
        pullDownRefresh()
        addCustomBackButtonToNavigationBar()
        addBarButtonItem()
        targetLabel.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        setStoryList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    
    private func addCustomBackButtonToNavigationBar()
    {
        let backButton = UIButton(type: UIButtonType.custom)
        
        backButton.addTarget(self, action: #selector(self.backButtonClicked), for: UIControlEvents.touchUpInside)
        backButton.setImage(UIImage(named: "navigation-arrow"), for: .normal)
        backButton.sizeToFit()
        
        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        self.navigationItem.title = "Play List"
    }
    
    @objc func backButtonClicked()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func addBarButtonItem()
    {
        let rightBarButton = UIButton(type: UIButtonType.custom)
        
        rightBarButton.addTarget(self, action: #selector(addToPlayList), for: UIControlEvents.touchUpInside)
        rightBarButton.setImage(UIImage(named: "icon-done"), for: .normal)
        rightBarButton.sizeToFit()
        
        addBtn = UIBarButtonItem(customView: rightBarButton)
    }
    
    
    @IBAction func didTapRefresBtn(_ sender: Any) {
        refresh()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return assetsList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 0
    }

    //MARK -> Header has been added to cell for row®
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
//    {
//        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.AssetStorySectionCell) as! AssetStorySectionTableViewCell
//     
//        if !isComingFromMandatory{
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapHeaderView(gesture:)))
//        cell.tag = section
//        cell.addGestureRecognizer(tapGesture)
//        }
//        
//        if isComingForSelection{
//        cell.checkMarkImgVw.frame.size.width = 25
//        cell.trailingImgVwCnst.constant = 10
//            
//        if selectedList.contains(obj)
//         {
//            cell.checkMarkImgVw.image = UIImage(named: "icon-tick")
//        }
//        else
//        {
//            cell.checkMarkImgVw.image = UIImage(named: "icon-unselected")
//        }
//        }
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 240
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let assetSubList = assetsList[indexPath.section].assetList
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.AssetStoryMainCell, for: indexPath) as! AssetsStoryMainTableViewCell
        cell.assetList = assetSubList!
        cell.collectionView.tag = indexPath.section
        cell.tag = indexPath.section
        cell.selectionStyle = .none
        if isComingForSelection{
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCell(gesture:)))
            cell.tag = indexPath.section
            cell.addGestureRecognizer(tapGesture)
        }
        let obj = assetsList[indexPath.section].storyObj
        cell.assetNameLbl.text = checkNullAndNilValueForString(stringData: obj?.Story_Name)
        cell.assetCountLbl.text = "No of Assets : \(assetSubList!.count)"
        
        if let expiryDate = obj?.Effective_To{
            cell.assetCountLbl.text = "No of Assets : \(assetSubList!.count)" + " | " + "Valid till \(convertDateIntoServerDisplayformat(date: expiryDate)) "
        }
        cell.targetLabel.text = "Target - " + BL_StoryModel.sharedInstance.getSpecialitynamesForStory(storyId: (obj?.Story_Id)!)
        
        cell.collectionView.reloadData()
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if !isComingForSelection{
        if !isComingFromMandatory{
        didSelectStoryList(indexPath: indexPath, isPlayEnabled: false)
        }
        }else{
            
        }
    }
    
    private func pullDownRefresh()
    {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refreshControl.addTarget(self, action: #selector(AssetsMainStoryListViewController.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func endRefresh()
    {
        if self.refreshControl.isRefreshing
        {
            refreshControl.endRefreshing()
        }
        removeCustomActivityView()

    }
    
    @objc func refresh()
    {
        if checkInternetConnectivity()
        {
            if !self.refreshControl.isRefreshing{
             showCustomActivityIndicatorView(loadingText: "Loading...")
            }
            BL_MasterDataDownload.sharedInstance.getDigitalAssetsData(masterDataGroupName: "Assets Refresh") { (status) in
                
                if status == SERVER_SUCCESS_CODE
                {
                    if BL_DCR_Doctor_Visit.sharedInstance.getStoryEnabledPrivVal().lowercased() == PrivilegeValues.YES.rawValue.lowercased()
                    {
                        BL_MasterDataDownload.sharedInstance.getStoryData(masterDataGroupName: "Story Refresh") { (status) in
                            self.endRefresh()
                            DispatchQueue.main.async {
                                if status == SERVER_SUCCESS_CODE
                                {
                                    showToastView(toastText: "Refreshed Successfully")
                                    self.setStoryList()
                                }
                                else
                                {
                                    showToastView(toastText: serverSideError)
                                }
                            }
                        }
                    }
                    else
                    {
                        self.endRefresh()
                        showToastView(toastText: "Refreshed Successfully")
                        self.setStoryList()

                    }
                }
                else
                {
                    self.endRefresh()
                    showToastView(toastText: serverSideError)
                }
            }
        }
        else
        {
            self.endRefresh()
            showToastView(toastText: internetOfflineMessage)
        }
    }
    
    func didTapHeaderView(gesture : UITapGestureRecognizer){
        
        let cell = gesture.view as! AssetStorySectionTableViewCell
        if !isComingForSelection{
            didSelectStoryList(indexPath: IndexPath(row: 0, section: cell.tag) , isPlayEnabled: false)

        }else{
            addToSelectedList(index: cell.tag, storyobj: assetsList[cell.tag].storyObj)
        }
    }
    
    @objc func didTapCell(gesture : UITapGestureRecognizer){
        
        let cell = gesture.view as! AssetsStoryMainTableViewCell
        if !isComingForSelection{
        didSelectStoryList(indexPath: IndexPath(row: 0, section: cell.tag) , isPlayEnabled: false)
        }else{
            addToSelectedList(index: cell.tag, storyobj: assetsList[cell.tag].storyObj)
        }
    }
    
    func didSelectItemAtCollectionView(indexPath : IndexPath){

        if !isComingForSelection{
            didSelectStoryList(indexPath: indexPath, isPlayEnabled: false)
        }else{
            addToSelectedList(index: indexPath.section, storyobj: assetsList[indexPath.section].storyObj)
        }
    }
    
    func addToSelectedList(index : Int , storyobj : StoryHeader){
        if selectedList.contains(storyobj)
        {
            selectedList.remove(storyobj)
        }
        else
        {
            selectedList.add(storyobj)
        }
//        self.tableView.reloadSections([index], with: .none)
        self.tableView.reloadData()
        checkForPlayList()
        
    }
    
    func checkForPlayList(){
        if selectedList.count > 0{
            self.navigationItem.rightBarButtonItem = addBtn
        }else{
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc func addToPlayList(){
        addSelectedListToPlayList()
        self.navigationController?.popViewController(animated: true)
    }
    
    private func addSelectedListToPlayList()
    {
        
        let selectedShowList = covertToAssetsListModel(list: self.selectedList)
        var listCount = DBHelper.sharedInstance.getMaxDisplayOrderForShowList() ?? 0
        for playListObj in selectedShowList{
            var isExist = false
            for assetObj in BL_AssetModel.sharedInstance.showList{
                if assetObj.storyId == playListObj.Story_Id{
                    isExist = true
                    break
                }
                
            }
            if !isExist{
                listCount += 1
                let dict = NSMutableDictionary()
                dict.setValue( playListObj.Story_Id ,forKey: "Story_Id")
                dict.setValue( -1 ,forKey: "DA_Code")
                dict.setValue( listCount ,forKey: "Display_Order")
                let insertObj = AssetShowList(dict: dict)
                DBHelper.sharedInstance.insertCustomerShowList1(showListObj: insertObj)
            }
            
        }
        
        BL_AssetModel.sharedInstance.refreshShowList()
        
    }
    
    
    private func covertToAssetsListModel(list : NSMutableArray) -> [StoryHeader]
    {
        var selectedAssetsList : [StoryHeader] = []
        for obj in list as! [StoryHeader]
        {
            selectedAssetsList.append(obj)
        }
        return selectedAssetsList
    }
    

    
    private func didSelectStoryList(indexPath : IndexPath, isPlayEnabled: Bool) {
        
        if isComingFromDigitalAssets{
            self.assetsList = BL_StoryModel.sharedInstance.getFullMasterStoryList()
        }else{
            self.assetsList = BL_StoryModel.sharedInstance.getMasterStoryList(ismandatory: isComingFromMandatory)
        }
        
        var getAssetList : [AssetHeader] = []
        if isPlayEnabled == true
        {
            for model in assetsList
            {
                for assetModel in model.assetList
                {
                    getAssetList.append(assetModel)
                }
            }
        }
        else
        {
            getAssetList = assetsList[indexPath.section].assetList
        }
        
        let status = BL_StoryModel.sharedInstance.checkForOfflineAssets(assetList: getAssetList)
        if status == 1
        {
            let alertViewController = UIAlertController(title: alertTitle, message: storyPendingAssetDownloadAlert, preferredStyle: UIAlertControllerStyle.alert)
            alertViewController.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction) -> Void in
                BL_StoryModel.sharedInstance.updateAssetDownloadStatus(downloadStatus: isFileDownloaded.progress.rawValue, assetList: getAssetList)
            }))
            alertViewController.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction) -> Void in
                
            }))
            self.present(alertViewController, animated: false, completion: nil)
        }
        else if status == 2
        {
            showToastView(toastText: storyProgressAssetDownloadAlert)
        }
        else
        {
            let sb = UIStoryboard(name:AssetsPlaySb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier:"AssetsPlayerVCID") as! AssetsPlayerViewController
            var preview = 0
            if isComingFromDigitalAssets {
                preview = 1
            }
            vc.isPreview = preview
            vc.storyObj = assetsList[indexPath.section]
            vc.assetObj = assetsList[indexPath.section].assetList[indexPath.row]
            vc.storyArray = assetsList
            vc.isComingFromMandatoryStory = isComingFromMandatory
            vc.isComingFromStory = true
            vc.mc_StoryId = assetsList[indexPath.section].storyObj.Story_Id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func setStoryList()
    {
        if BL_DCR_Doctor_Visit.sharedInstance.getStoryEnabledPrivVal().lowercased() == PrivilegeValues.YES.rawValue.lowercased()
        {
        if isComingFromDigitalAssets{
            self.assetsList = BL_StoryModel.sharedInstance.getFullMasterStoryList()
        }else{
        self.assetsList = BL_StoryModel.sharedInstance.getMasterStoryList(ismandatory: isComingFromMandatory)
        }
        }
        self.tableView.reloadData()
        
        if self.assetsList.count > 0 {
            self.tableView.isHidden = false
            self.emptyStateView.isHidden = true
        }else{
            self.tableView.isHidden = true
            self.emptyStateView.isHidden = false
            self.emptyStateLabel.text = "No marketing content found"
        }
        
        var index = 0
        for story in assetsList{
            for asset in story.assetList{
                index += 1
                asset.displayIndex = index
            }
            
        }
        
    }
    
    func playLatestStoryList()
    {
        didSelectStoryList(indexPath: IndexPath(row: 0, section: 0), isPlayEnabled: true)
    }
    
    @IBAction func menuBtnAction(_ sender: UIButton)
    {
        
    }
    
    @IBAction func addStoryBtnAction(_ sender: UIBarButtonItem)
    {
        
    }
    
    
}
