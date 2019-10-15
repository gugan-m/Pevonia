//
//  AssetShowListViewController.swift
//  HiDoctorApp
//
//  Created by Admin on 8/17/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

protocol  deleteOrAddShowListDelegate
{
    func didDeleteOrAddTheShowList()
}

class AssetShowListViewController : UIViewController,UITableViewDelegate,UITableViewDataSource,AssetsSelectedDelegate,StorySelectionDelegate
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateView : UIView!
    @IBOutlet weak var searchViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var emptyStateLbl : UILabel!
    @IBOutlet weak var tableViewWidth: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var containerView: UIView!
    
    var currentList : [ShowListModel] = []
    var assetMenuList : [AssetsMenuModel] = []
    var dragView : AssetsSelectionView = AssetsSelectionView()
    var selectedCount : Int = 0
    var isSelectionMode : Bool = false
    var selectedList : NSMutableArray = []
    var isFromAssetShowList : Bool = false
    var videoImage : [String : UIImage] = [:]
    var selectedDetailLabel = UILabel()
    var assetObj : AssetHeader?
    var showListObj = ShowListModel()
    var refreshControl: UIRefreshControl!
    var delegate : deleteOrAddShowListDelegate!
    var snapShot: UIView?
    var sourceIndexPath: NSIndexPath?
    var isForPreview = false
    var isComingFromDigitalAssets : Bool = false
    var assetSwapPrivValue: Int!
    var isComingFromPlayBtn : Bool = false
    var allowpreview : Bool = false
    var isFromPlus : Bool = false
    
    //var allowRemove : Bool = false
    //var assetMenuList : [AssetsMenuModel] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        addCustomBackButtonToNavigationBar()
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleTableViewLongGesture(sender:)) )
        tableView.addGestureRecognizer(longGesture)
        BL_AssetModel.sharedInstance.isForDigitalAssets = isComingFromDigitalAssets
              
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(updateDownloadStatus(_:)), name: NSNotification.Name(rawValue: assetNotification), object: nil)
        setAssetDetails()
        addFooterView()
        
        assetSwapPrivValue = BL_AssetModel.sharedInstance.getAssetSwapPrivilegeValue()
        //showAlertCheck()
       // view.perform(#selector(self.showAlertCheck), with: nil, afterDelay: 1.5)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        setDragAndDropView(cgsize: self.view.frame.size)
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        resetValue()
        removeDragView()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: assetNotification), object: nil)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        dragView.frame = getDragViewFrame(cgsize: size)
        
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    func isAssetNotOffline() -> Bool {
        let list1 = BL_AssetModel.sharedInstance.showList
        for data in list1 {
            let status = data.assetDetail.isDownloaded
            if status! == isFileDownloaded.pending.rawValue {
                return true
            }
        }
        return false
    }
    
    func showAlertCheck() {
        if isAssetNotOffline(){
            var downloadedStatusCheck : String = EMPTY
            downloadedStatusCheck = BL_AssetModel.sharedInstance.getDownloadStatus(isDownloaded:0)
            if (downloadedStatusCheck == "Online") {
                
                let alertViewController = UIAlertController(title: nil, message: "Few asset can be played after downloading.", preferredStyle: UIAlertControllerStyle.alert)
                alertViewController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction) -> Void in
                }))
                self.present(alertViewController, animated: false, completion: nil)
            }
        }else{
            
    }
    }
    
    func setAssetDetails()
    {
        //        var detailList : [AssetHeader] = []
        //        var type : Int = 0
        //            BL_AssetModel.sharedInstance.refreshShowList()
        //            detailList = AssetsDataManager.sharedManager.convertShowListModelToAssetHeader(showList: BL_AssetModel.sharedInstance.showList)
        //            detailList = detailList.sorted { $0.daName  < $1.daName }
        //
        //            detailList = detailList.sorted { $0.daName.localizedCaseInsensitiveCompare($1.daName )  == ComparisonResult.orderedAscending }
        //
        //            type = 3
        //
        
        BL_AssetModel.sharedInstance.refreshShowList()
        let list = BL_AssetModel.sharedInstance.showList
      //  showListObj.isPrefilled = false
        changeCurrentArray(list: list, type: 3)

        delegate.didDeleteOrAddTheShowList()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return currentList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 0
    } 
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let showObj = currentList[indexPath.section]
        
        if !showObj.storyEnabled
        {
            return 130
        }
        
        return 230
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let showObj = currentList[indexPath.section]
        
        if !showObj.storyEnabled
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.AssetsListCell, for: indexPath) as! AssetsListTableViewCell
            let assetsObj = showObj.assetDetail!
            var thumnailImg : UIImage = BL_AssetModel.sharedInstance.getThumbnailImage(docType : assetsObj.docType!)
            
            cell.assetNameLbl.text = assetsObj.daName!
            cell.indexLabel.text = "\(assetsObj.displayIndex)"
            cell.menuBtn.indexPath = indexPath
            cell.menuBtn.addTarget(self, action: #selector(didTapMenuBtn(button:)), for: .touchUpInside)
            cell.menuBtn.tag = indexPath.section
            
            var downloadedStatus : String = EMPTY
            let localUrl = checkNullAndNilValueForString(stringData:  assetsObj.localUrl)
            
            if localUrl != EMPTY
            {
                downloadedStatus = BL_AssetModel.sharedInstance.getDownloadStatus(isDownloaded:2)
                let localThumbnailUrl = BL_AssetDownloadOperation.sharedInstance.getAssetThumbnailURL(model :assetsObj)
                if localThumbnailUrl != EMPTY
                {
                    thumnailImg = UIImage(contentsOfFile: localThumbnailUrl)!
                }
            }
            else
            {
                downloadedStatus = BL_AssetModel.sharedInstance.getDownloadStatus(isDownloaded: assetsObj.isDownloaded!)
            }
            
            let thumbanailUrl = checkNullAndNilValueForString(stringData: assetsObj.thumbnailUrl)
            let image = BL_AssetModel.sharedInstance.thumbailImage[thumbanailUrl]
            
            if  thumbanailUrl != EMPTY && image != nil
            {
                thumnailImg = image!
            }
            else
            {
                getThumbnailImageForUrl(imageUrl: thumbanailUrl, indexPath: indexPath)
            }
            
            cell.assetsImg.image = thumnailImg
            cell.assetsDetailLbl.text = "\(String(format: "%.2f", assetsObj.daSize)) MB | \(getDocTypeVal(docType : assetsObj.docType)) | \(downloadedStatus)"
            cell.menuBtn.isUserInteractionEnabled = true
            cell.videoPlayBackView.constant = 0
            cell.activityIndicatorWidth.constant = 0
            cell.activityIndicator.startAnimating()
            
            
            if  assetsObj.isDownloaded == isFileDownloaded.progress.rawValue
            {
                cell.activityIndicatorWidth.constant = 20
            }
            
            return cell
        }
        else
        {
            let assetSubList = showObj.storyObj.assetList
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.AssetStoryMainCell, for: indexPath) as! AssetsStoryMainTableViewCell
            cell.assetList = assetSubList!
            cell.collectionView.tag = indexPath.section
            cell.collectionView.reloadData()
            cell.assetNameLbl.text = checkNullAndNilValueForString(stringData: showObj.storyObj.storyObj.Story_Name)
            cell.assetCountLbl.text = "No of asset : \(showObj.storyObj.assetList.count)"
            
            if let expiryDate = showObj.storyObj.storyObj.Effective_To
            {
                cell.assetCountLbl.text = "No of asset : \(showObj.storyObj.assetList.count)" + " | " + "Valid till \(convertDateIntoServerDisplayformat(date: expiryDate)) "
            }
            
            cell.targetLabel.text = "Target - " + BL_StoryModel.sharedInstance.getSpecialitynamesForStory(storyId: showObj.storyObj.storyObj.Story_Id)
            cell.menuBtn.isHidden = false
            cell.menuBtn.isUserInteractionEnabled = true
            cell.menuBtn.tag = indexPath.section
            cell.menuBtn.addTarget(self, action: #selector(didTapMenuBtn(button:)), for: .touchUpInside)
            cell.selectionStyle = .none
            //    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCell(gesture:)))
            cell.tag = indexPath.section
            cell.delegate = self
            //cell.addGestureRecognizer(tapGesture)
            
            //            cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
            //            cell.contentView.layer.borderWidth = 2
            //            cell.contentView.layer.shadowColor = UIColor(red: 225.0/255.0, green: 228.0/255.0, blue: 228.0/255.0, alpha: 1.0).cgColor
            //            cell.contentView.layer.shadowOpacity = 1.0
            //            cell.contentView.layer.shadowRadius = 5.0
            //            cell.contentView.layer.shadowOffset = CGSize(width: 5, height: 5)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if navigateValidationForShowList()
        {
            let showObj = currentList[indexPath.section]
            
            if showObj.storyEnabled
            {
                if showObj.storyObj.assetList.count > 0
                {
                    navigateToAssetPlayList(assetObj : showObj.storyObj.assetList.first! , storyObj:  showObj.storyObj)
                }
            }
            else
            {
                navigateValidationforAsset(assetObj: showObj.assetDetail)
            }
        }
    }
    
    func didTapCell(gesture : UITapGestureRecognizer)
    {
        let cell = gesture.view as! AssetsStoryMainTableViewCell
        
        if navigateValidationForShowList()
        {
            let showObj = currentList[cell.tag]
            
            if showObj.storyEnabled
            {
                if showObj.storyObj.assetList.count > 0
                {
                    navigateToAssetPlayList(assetObj : showObj.storyObj.assetList.first! , storyObj:  showObj.storyObj)
                }
            }
            else
            {
                navigateValidationforAsset(assetObj: showObj.assetDetail)
            }
        }
    }
    
    func didSelectItemAtCollectionView(indexPath : IndexPath)
    {
        if navigateValidationForShowList()
        {
            let showObj = currentList[indexPath.section]
            
            if showObj.storyEnabled
            {
                if showObj.storyObj.assetList.count > 0
                {
                    navigateToAssetPlayList(assetObj : showObj.storyObj.assetList[indexPath.row] , storyObj: showObj.storyObj)
                }
            }
            else
            {
                navigateValidationforAsset(assetObj: showObj.assetDetail)
            }
        }
    }
    
    func navigateValidationforAsset(assetObj : AssetHeader)
    {
        if (getDocTypeVal(docType: (assetObj.docType)!) == Constants.DocType.zip) && (checkNullAndNilValueForString(stringData: assetObj.localUrl) == EMPTY) && (assetObj.isDownloaded != isFileDownloaded.progress.rawValue)
        {
            showAlertViewToDownload(assetObj: assetObj)
        }
        else if (assetObj.isDownloaded != isFileDownloaded.progress.rawValue) && (getDocTypeVal(docType: (assetObj.docType)!) == Constants.DocType.zip)
        {
            navigateToAssetPlayList(assetObj : assetObj , storyObj:  AssetMandatoryListModel())
        }
        else if (getDocTypeVal(docType: (assetObj.docType)!) != Constants.DocType.zip)
        {
            navigateToAssetPlayList(assetObj : assetObj ,storyObj:  AssetMandatoryListModel())
        }
    }
    
    func navigateValidationForShowList() -> Bool
    {
        let status = BL_AssetModel.sharedInstance.checkForHTMLAssets()
        
        if status == 1
        {
            let alertViewController = UIAlertController(title: alertTitle, message: storyPendingAssetDownloadAlert, preferredStyle: UIAlertControllerStyle.alert)
            alertViewController.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction) -> Void in
                BL_AssetModel.sharedInstance.updateHTMLAssetDownloadStatus()
            }))
            alertViewController.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction) -> Void in
                
            }))
            
            self.present(alertViewController, animated: false, completion: nil)
        }
        else if status == 2
        {
            showToastView(toastText: storyProgressAssetDownloadAlert)
        }
        else if self.isComingFromPlayBtn != true && self.allowpreview != true {
            if (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.CAN_PLAY_ASSETS_IN_SEQUENCE) == PrivilegeValues.YES.rawValue)
            {
                AlertView.showAlertView(title: "Alert", message: "Asset play in sequence options is enabled for you. you can't play this asset directly.")
            }
                //self.isComingFromPlayBtn = false
                //self.allowpreview = false
                
            else
            {
                return true
            }
            
        }
        else
        {
            return true
        }
        
        setAssetDetails()
        
        return false
    }
    
    func navigateToAssetPlayList(assetObj : AssetHeader , storyObj : AssetMandatoryListModel)
    {
        let sb = UIStoryboard(name: AssetsPlaySb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AssetsPlayerVCID") as! AssetsPlayerViewController
        
        vc.assetObj = assetObj
        vc.showList = currentList
        vc.storyObj = storyObj
        var preview = 0
        
        if isForPreview  || isComingFromDigitalAssets
        {
            preview = 1
            self.allowpreview = true
        }
        
        isForPreview = false
        vc.isPreview = preview
        vc.isComingFromShowList = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getAllAssetListFromShowList() -> [AssetHeader]
    {
        let showList = BL_AssetModel.sharedInstance.showList
        var assetList = [AssetHeader]()
        
        for showListObj in showList
        {
            if showListObj.storyEnabled
            {
                assetList.append(contentsOf: showListObj.storyObj.assetList)
            }
            else
            {
                assetList.append(showListObj.assetDetail)
            }
        }
        
        return assetList
    }
    
    @objc func didTapMenuBtn(button: UIButton)
    {
        resetValue()
        showListObj = currentList[button.tag]
        if button.tag == menuIndex.preview
        {
            self.allowpreview = true
        }
        let popUp_sb = UIStoryboard(name:Constants.StoaryBoardNames.AssetsListSb, bundle: nil)
        let popUp_Vc = popUp_sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.AssetsMenuListVcID) as! AssetMenuListViewController
        
        popUp_Vc.isToShowList = true
        popUp_Vc.delegate = self
        popUp_Vc.showListObj = showListObj
        popUp_Vc.isComingFromDigitalAssets = isComingFromDigitalAssets
        popUp_Vc.providesPresentationContextTransitionStyle = true
        popUp_Vc.modalTransitionStyle = .coverVertical
        popUp_Vc.definesPresentationContext = true
        popUp_Vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        
        self.present(popUp_Vc, animated: true, completion: nil)
    }
    
    private func setTableViewWidth()
    {
        if SCREEN_WIDTH > 375
        {
            self.tableViewWidth.constant = SCREEN_WIDTH
        }
        else
        {
            self.tableViewWidth.constant = 375
        }
    }
    
    private func reloadTableViewAtSpecificIndex(indexPath: IndexPath)
    {
        
        if (indexPath.row < self.currentList.count)
        {
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    //MARK :-Search Bar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if let text = searchBar.text
        {
            searchListContent(text: text)
        }
        else
        {
            searchListContent(text: "")
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool
    {
        self.searchBar.showsCancelButton = true
        enableCancelButtonForSearchBar(searchBar:searchBar)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.showsCancelButton = false
        self.searchBar.text = nil
        self.searchBar.resignFirstResponder()
        setAssetDetails()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.resignFirstResponder()
    }
    
    private func searchListContent(text : String)
    {
        var searchList : [ShowListModel] = []
        var detailList : [ShowListModel] = []
        
        detailList = BL_AssetModel.sharedInstance.showList
        
        if text != ""
        {
            searchList = detailList.filter { (assetObj) -> Bool in
                let lowerCaseString = text.lowercased()
                return assetObj.assetDetail.daName.lowercased().contains(lowerCaseString)
            }
            changeCurrentArray(list:searchList, type: 2)
        }
        else
        {
            setAssetDetails()
        }
    }
    
    private func changeCurrentArray(list : [ShowListModel],type : Int)
    {
        if list.count > 0
        {
            currentList = list
            showEmptyStateView(show: false)
            self.tableView.reloadData()
            // self.present(alertViewController, animated: false, completion: nil)
        }
        else
        {
            showEmptyStateView(show: true)
        }
    }
    
    private func showEmptyStateView(show : Bool)
    {
        self.emptyStateView.isHidden = !show
        self.tableView.isHidden = show
    }
    
    private func setEmptyStateLbl(type : Int)
    {
        var emptyStateTxt  :String = ""
        searchViewHeightConst.constant = 44
        
        if type == 1
        {
            emptyStateTxt = "No asset Found"
            searchViewHeightConst.constant = 0
        }
        else if type == 2
        {
            emptyStateTxt = "No asset found. Clear your search and try again."
        }
        else
        {
            emptyStateTxt = ""
            searchViewHeightConst.constant = 0
        }
        self.emptyStateLbl.text = emptyStateTxt
    }
    
    private func setDragAndDropView(cgsize : CGSize)
    {
        dragView = AssetsSelectionView.loadNib()
        dragView.frame = self.getDragViewFrame(cgsize :cgsize)
        dragView.delegate = self
        dragView.isComingFromDigitalAssets = isComingFromDigitalAssets
        containerView.isHidden = true
        dragView.setDefaultDetails()
        let pangesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureHandleAction(sender:)))
        dragView.addGestureRecognizer(pangesture)
        self.containerView.addSubview(dragView)
    }
    
    private func getDragViewFrame(cgsize:CGSize) -> CGRect
    {
        //        let dragViewSize = CGSize(width: 150, height: 50)
        //        let dragViewPoint = CGPoint(x: (cgsize.width - dragViewSize.width)/2, y: cgsize.height - dragViewSize.height - 50 - 10)
        return containerView.bounds//CGRect(origin: dragViewPoint, size: dragViewSize)
    }
    
    @objc func panGestureHandleAction(sender : UIPanGestureRecognizer)
    {
        if sender.state == UIGestureRecognizerState.ended
        {
            if (sender.view!.center.x < SCREEN_WIDTH/4 || sender.view!.center.x > (SCREEN_WIDTH * 3/4 )) && sender.view!.frame.origin.y > getDragViewFrame(cgsize: self.view.frame.size).origin.y
            {
                //               showDragView(show: false)
                //               resetValue()
            }
            else
            {
                self.dragView.frame = self.getDragViewFrame(cgsize: self.view.frame.size)
                dragView.alpha = 1.0
            }
        }
        else
        {
            let translation = sender.translation(in: self.dragView)
            sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: self.dragView)
            
            dragView.alpha = 0.7
        }
    }
    
    @objc func handleLongPress(longPressGesture:UILongPressGestureRecognizer)
    {
        
    }
    
    func addFooterView()
    {
        let longPress : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(longPressGesture:)))
        longPress.minimumPressDuration = 1.0 // 1 second press
        self.tableView.addGestureRecognizer(longPress)
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
  
    @objc func updateDownloadStatus(_ notification: NSNotification)
    {
        DispatchQueue.main.async {
            self.setAssetDetails()
        }
    }
    
    func assetBtnAction()
    {
        resetValue()
        showDragView(show: false)
    }
    
    private func setDragViewText(text : String)
    {
        self.dragView.selectedLbl.text = "\(text) Selected"
    }
    
    private func checkIsToShowDragView()
    {
        if selectedList.count == 0
        {
            showDragView(show: false)
            isSelectionMode = false
        }
        else
        {
            self.setDragViewText(text: String(selectedCount))
            showDragView(show: true)
        }
    }
    
    private func showDragView(show : Bool)
    {
        self.containerView.isHidden = !show
    }
    
    private func covertToAssetsListModel(list : NSMutableArray) -> [AssetHeader]
    {
        var selectedAssetsList : [AssetHeader] = []
        for obj in list as! [AssetHeader]
        {
            selectedAssetsList.append(obj)
        }
        return selectedAssetsList
    }
    
    func resetValue()
    {
        self.isSelectionMode = false
        self.selectedList = []
    }
    
    private func removeDragView()
    {
        self.dragView.removeFromSuperview()
    }
    
    private func getThumbnailImgForVideo(videoUrl : String,indexPath : IndexPath)
    {
        BL_AssetModel.sharedInstance.thumbnailImgForVideo(videoUrl: videoUrl, additionalDetail: indexPath) { (image, url, indexpath) in
            
            if image != nil
            {
                self.videoImage[url] = image
                self.reloadTableViewAtSpecificIndex(indexPath: indexpath as! IndexPath)
            }
        }
    }
    
    private func getThumbnailImageForUrl(imageUrl : String,indexPath : IndexPath)
    {
        if imageUrl != EMPTY
        {
            ImageLoader.sharedLoader.imageForUrl(urlString: imageUrl) { (image) in
                if image != nil
                {
                    BL_AssetModel.sharedInstance.thumbailImage[imageUrl] = image
                    DispatchQueue.main.async {
                        self.reloadTableViewAtSpecificIndex(indexPath: indexPath)
                    }
                }
            }
        }
    }
    
    private func updateSelectedList()
    {
        for assetObj in BL_AssetModel.sharedInstance.showList
        {
            let filteredArray = BL_AssetModel.sharedInstance.assetList.filter {
                return $0.daCode == assetObj.assetDetail.daCode
            }
            for obj in filteredArray
            {
                selectedList.add(obj)
            }
        }
    }
    
    func navigateToSelectedList(type : Int,isMenu : Bool)
    {
        showDragView(show: false)
        
        if !isMenu
        {
            if type == 1
            {
                self.isFromAssetShowList = true
                navigateToAssetsPlaylist()
            }
            else
            {
                downloadSelectedList()
            }
        }
        else
        {
            setItemIndex(index: type)
            
        }
    }
    
    private func downloadSelectedList()
    {
        if selectedList.count > 0
        {
            startDownloadAssets(downloadList: covertToAssetsListModel(list: selectedList))
        }
        else
        {
            showToastView(toastText: "Select atleast anyone asset to proceed download")
        }
    }
    
    private func startDownloadAssets(downloadList : [AssetHeader])
    {
        if checkInternetConnectivity()
        {
            BL_AssetModel.sharedInstance.updateDownloadStatus(selectedList: downloadList,status: isFileDownloaded.progress.rawValue)
            selectedList = []
            DispatchQueue.main.async {
                self.setAssetDetails()
            }
            
            if BL_AssetDownloadOperation.sharedInstance.statusList.count == 0
            {
                BL_AssetDownloadOperation.sharedInstance.initiateOperation()
            }
        }
        else
        {
            showToastView(toastText:internetOfflineMessage)
        }
    }
    
    private func setItemIndex(index : Int)
    {
        switch index
        {
        case menuIndex.assetName:
            navigateToAssetsInfo()
        case menuIndex.play:
            
            if navigateValidationForShowList(){
                if showListObj.storyEnabled{
                    if showListObj.storyObj.assetList.count > 0{
                        navigateToAssetPlayList(assetObj : showListObj.storyObj.assetList.first! , storyObj: showListObj.storyObj)
                    }
                }else{
                    navigateValidationforAsset(assetObj: showListObj.assetDetail)
                }
            }
        case menuIndex.preview:
            self.allowpreview = true
            if navigateValidationForShowList(){
                isForPreview = true
                self.allowpreview = true
                if showListObj.storyEnabled{
                    self.allowpreview = true
                    if showListObj.storyObj.assetList.count > 0{
                        navigateToAssetPlayList(assetObj : showListObj.storyObj.assetList.first! , storyObj:  showListObj.storyObj)
                    }
                }else{
                    self.allowpreview = true
                    navigateValidationforAsset(assetObj: showListObj.assetDetail)
                }
            }
            
            
        case menuIndex.details :
            navigateToAssetsInfo()
        case menuIndex.delete:
            deleteTheAssetFromShowList()
        case menuIndex.availableOffline :
            setAssetDetails()
        default:
            print("\n")
        }
    }
    
    private func navigateToAssetsInfo()
    {
        let sb = UIStoryboard(name: Constants.StoaryBoardNames.AssetsListSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.AssetInfoVCID) as! AssetDetailController
        
        if !showListObj.storyEnabled
        {
            vc.assetModel = showListObj.assetDetail
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func navigateToAssetsPlaylist()
    {
        let sb = UIStoryboard(name:AssetsPlaySb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier:"AssetsPlayerVCID") as! AssetsPlayerViewController
        var assetList : [AssetHeader] = []
        assetList =  getAllAssetListFromShowList()
        
        vc.isPreview = 0
        let playListArray = BL_AssetModel.sharedInstance.getAssetPlayList(assetList: assetList, isShowList: true)
        vc.assetsArray = playListArray
        vc.assetObj = assetObj
        if playListArray.count > 0
        {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func addAssetObjectToShowList()
    {
        if assetObj != nil
        {
            let filteredArray = BL_AssetModel.sharedInstance.showList.filter{
                $0.assetDetail.daCode == assetObj!.daCode
            }
            
            if filteredArray.count == 0
            {
                // BL_AssetModel.sharedInstance.showList.append(AssetsDataManager.sharedManager.convertAssetHeaderToShowListObj(asset:assetObj!))
            }
            showToastView(toastText: "Added to show list")
            setAssetDetails()
        }
    }
    
    func navigateToPlayList()
    {
        if BL_AssetModel.sharedInstance.showList.count > 0
        {
            self.isComingFromPlayBtn = true
            // navigateToAssetsPlaylist()
            
            if navigateValidationForShowList()
            {   self.isComingFromPlayBtn = false
                let showObj = currentList.first!
                
                if showObj.storyEnabled
                {
                    if showObj.storyObj.assetList.count > 0
                    {
                        navigateToAssetPlayList(assetObj : showObj.storyObj.assetList.first! , storyObj:  showObj.storyObj)
                    }
                }
                else
                {
                    navigateValidationforAsset(assetObj: showObj.assetDetail)
                }
            }
        }
    }
    
    func deleteTheAssetFromShowList()
    {
        if self.assetSwapPrivValue == 2
        {
            DBHelper.sharedInstance.removeAssetFromShowListbyDaCode(daCode: showListObj.assetDetail.daCode)
        }
        else if self.assetSwapPrivValue == 1 //|| self.assetSwapPrivValue == 0
        {
            
            let defaults = UserDefaults.standard
            //  let myarray = defaults.stringArray(forKey: "SelectedListAssets") ?? [String]() //for string
            let myarray = defaults.array(forKey: "SelectedListAssets")  as? [Int] ?? [Int]() // for int
            print("\(myarray)")
            
            
            if myarray.contains(showListObj.assetDetail.daCode){
                DBHelper.sharedInstance.removeAssetFromShowListbyDaCode(daCode: showListObj.assetDetail.daCode)
            }else{
                showToastView(toastText: "You don't have the privilege to remove this asset.")
                return
            }
            
//            if showListObj.isPrefilled == false
//            {
//                //DBHelper.sharedInstance.removeAssetFromShowListByStoryId(storyId: showListObj.storyId)
//                DBHelper.sharedInstance.removeAssetFromShowListbyDaCode(daCode: showListObj.assetDetail.daCode)
//                //  showListObj.isPrefilled = true
//            }
//            else
//            {
//                showToastView(toastText: "You don't have the privilege to remove this asset.")
//                return //DBHelper.sharedInstance.removeAssetFromShowListByStoryId(storyId: showListObj.storyId)
//            }
            
        }
            
        else
        {
            let defaults = UserDefaults.standard
          //  let myarray = defaults.stringArray(forKey: "SelectedListAssets") ?? [String]() //for string
            let myarray = defaults.array(forKey: "SelectedListAssets")  as? [Int] ?? [Int]() // for int
            print("\(myarray)")
            
 
            if myarray.contains(showListObj.assetDetail.daCode){
               DBHelper.sharedInstance.removeAssetFromShowListbyDaCode(daCode: showListObj.assetDetail.daCode)
            }else{
                showToastView(toastText: "You don't have the privilege to remove this asset.")
                return
            }
            
            
//            if showListObj.isPrefilled == false
//            {
//                DBHelper.sharedInstance.removeAssetFromShowListbyDaCode(daCode: showListObj.assetDetail.daCode)
//                isFromPlus = false
//            }
//            else
//            {
//                showToastView(toastText: "You don't have the privilege to remove this asset.")
//                return
//            }
            //}
        }
        
        setAssetDetails()
    }
    
    func showAlertViewToDownload(assetObj : AssetHeader)
    {
        if checkInternetConnectivity()
        {
            let alertViewController = UIAlertController(title: nil, message: "This asset can be played after downloading.Do you want to download \"\(assetObj.daName!)\"?", preferredStyle: UIAlertControllerStyle.alert)
            alertViewController.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { alertAction in
                self.startDownloadAssets(downloadList: [assetObj])
                alertViewController.dismiss(animated: true, completion: nil)
            }))
            alertViewController.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: { alertAction in
                alertViewController.dismiss(animated: true, completion: nil)
            }))
            self.present(alertViewController, animated: true, completion: nil)
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    
    func updateTheDisplayOrder()
    {
        BL_AssetModel.sharedInstance.showList = currentList
        BL_AssetModel.sharedInstance.updateDisplayOrderInShowList()
        setAssetDetails()
    }
    
    //MARK:- Cell Drag & drop methods
    @objc func handleTableViewLongGesture(sender: UILongPressGestureRecognizer)
    {
        let state = sender.state
        let location = sender.location(in: tableView)
        var indexPath : IndexPath!
        if let currentIndexPath = tableView.indexPathForRow(at: location)  {
            indexPath = currentIndexPath
        }
        else
        {
            if location.y < 0
            {
                indexPath =  IndexPath(row: 0, section: 0)
            }
            else
            {
                indexPath =  IndexPath(row: 0, section: currentList.count - 1)
            }
        }
        
        switch state
        {
        case .began:
            sourceIndexPath = indexPath as NSIndexPath?
            guard let cell = tableView.cellForRow(at: indexPath) else {
                return
            }
            
            let showObj = currentList[indexPath.section]
            if (showObj.storyEnabled)
            {
                if (self.assetSwapPrivValue == 0 || self.assetSwapPrivValue == 1)
                {
                    return
                }
            }
            
            //Take a snapshot of the selected row using helper method.
            snapShot = customSnapShotFromView(inputView: cell)
            
            // Add the snapshot as subview, centered at cell's center...
            var center = CGPoint(x: cell.center.x, y: cell.center.y)
            snapShot?.center = center
            snapShot?.alpha = 0.0
            tableView.addSubview(snapShot!)
            UIView.animate(withDuration: 0.25, animations: {
                // Offset for gesture location.
                center.y = location.y
                self.snapShot?.center = center
                self.snapShot?.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                self.snapShot?.alpha = 0.98
                
                cell.alpha = 0.0
            }, completion: { _ in
                cell.isHidden = true
            })
            
        case .changed:
            guard let snapShot = snapShot else {
                return
            }
            guard let sourceIndexPathTmp = sourceIndexPath else {
                return
            }
            var center = snapShot.center
            center.y = location.y
            snapShot.center = center
            
            // Is destination valid and is it different from source?
            if !(indexPath == sourceIndexPathTmp as IndexPath) {
                //self made exchange method
                //objects.exchangeObjectAtIndex(indexPath.row, withObjectAtIndex: sourceIndexPathTmp.row)
                // ... move the rows.
                var swap: Bool = false
                let sourceObj = currentList [indexPath.section]
                
                if (sourceObj.storyEnabled)
                {
                    if (self.assetSwapPrivValue == 2)
                    {
                        swap = true
                    }
                    else if (self.self.assetSwapPrivValue == 0)
                    {
                        swap = false
                        
                    }
                        
                    else
                    {
                        swap = true
                    }
                    
                }
                else
                {
                    if (self.assetSwapPrivValue == 2)
                    {
                        swap = true
                    }
                        
                    else if (self.self.assetSwapPrivValue == 0)
                    {
                        swap = false
                        
                    }
                        
                    else
                        
                    {
                        swap = true
                        
                        //self.currentList.remove(at: menuIndex.delete)
                        //self.assetMenuList.remove(at: menuIndex.delete)
                    }
                }
                
                if (swap)
                {
                    
                    assetSwapPrivValue = BL_AssetModel.sharedInstance.getAssetSwapPrivilegeValue()
                    
                    if (assetSwapPrivValue == 1){
                        
                        let showObj = currentList[indexPath.section]
                        if showObj.storyEnabled{
                            
//                            (currentList[indexPath.section], currentList[sourceIndexPathTmp.section]) = (currentList[sourceIndexPathTmp.section], currentList[indexPath.section])
//                            //tableView.moveRow(at: sourceIndexPathTmp as IndexPath, to: indexPath)
//                            tableView.moveSection(sourceIndexPathTmp.section, toSection: indexPath.section)
//                            // ... and update source so it is in sync with UI changes.
//                            sourceIndexPath = indexPath as NSIndexPath?
                        }else{
                            (currentList[indexPath.section], currentList[sourceIndexPathTmp.section]) = (currentList[sourceIndexPathTmp.section], currentList[indexPath.section])
                            //tableView.moveRow(at: sourceIndexPathTmp as IndexPath, to: indexPath)
                            tableView.moveSection(sourceIndexPathTmp.section, toSection: indexPath.section)
                            // ... and update source so it is in sync with UI changes.
                            sourceIndexPath = indexPath as NSIndexPath?
                        }
                        
                    }else{
                        
                        //swap(&currentList[indexPath.section], &currentList[sourceIndexPathTmp.section])
                        (currentList[indexPath.section], currentList[sourceIndexPathTmp.section]) = (currentList[sourceIndexPathTmp.section], currentList[indexPath.section])
                        //tableView.moveRow(at: sourceIndexPathTmp as IndexPath, to: indexPath)
                        tableView.moveSection(sourceIndexPathTmp.section, toSection: indexPath.section)
                        // ... and update source so it is in sync with UI changes.
                        sourceIndexPath = indexPath as NSIndexPath?
                    }
                }
            }
            
        default:
            self.updateTheDisplayOrder()
            guard let sourceIndexPathTmp = sourceIndexPath else {
                return
            }
            guard let cell = tableView.cellForRow(at: sourceIndexPathTmp as IndexPath) else {
                if self.snapShot != nil{
                    self.snapShot?.removeFromSuperview()
                    self.snapShot = nil
                }
                return
            }
            cell.isHidden = false
            cell.alpha = 0.0
            
            UIView.animate(withDuration: 0.25, animations: {
                self.snapShot?.center = cell.center
                self.snapShot?.alpha = 0.0
                
                cell.alpha = 1.0
            }, completion: { _ in
                self.sourceIndexPath = nil
                self.snapShot?.removeFromSuperview()
                self.snapShot = nil
            })
        }
    }
    
    func customSnapShotFromView(inputView: UIView) -> UIImageView
    {
        // Make an image from the input view.
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let snapshot = UIImageView(image: image)
        snapshot.layer.masksToBounds = false
        snapshot.layer.cornerRadius = 0.0
        snapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        snapshot.layer.shadowRadius = 5.0
        snapshot.layer.shadowOpacity = 0.4
        
        return snapshot
    }
}

