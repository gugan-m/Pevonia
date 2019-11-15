//
//  AssetStoryListViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 22/06/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class AssetStoryListViewController:  UIViewController,UITableViewDelegate,UITableViewDataSource,AssetsSelectedDelegate
{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateView : UIView!
    @IBOutlet weak var searchViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var emptyStateLbl : UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var bottomBarHeightConst: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var addBarBtnItem: UIBarButtonItem!
    var currentList : [AssetsWrapperModel] = []
    var dragView : AssetsSelectionView = AssetsSelectionView()
    var selectedCount : Int = 0
    var isSelectionMode : Bool = false
    var selectedList : NSMutableArray = []
    var videoImage : [String : UIImage] = [:]
    var selectedDetailLabel = UILabel()
    var assetObj : AssetHeader?
    var refreshControl: UIRefreshControl!
    var playBtn : UIBarButtonItem!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        addCustomBackButtonToNavigationBar()
        addBarButtonItem()
        setDefaultDetails()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateDownloadStatus(_:)), name: NSNotification.Name(rawValue: assetNotification), object: nil)
        setAssetDetails()
        addFooterView()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        removeDragView()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: assetNotification), object: nil)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    private func setDefaultDetails()
    {
        self.navigationItem.title = "Story List"
    }
    
    private func setAssetDetails()
    {
       // var detailList : [AssetHeader] = []
       // var type : Int = 0
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return currentList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return currentList[section].assetList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.AssetsSectionCell)
        let obj = currentList[section]
        cell?.textLabel?.text = obj.assetTag
        cell?.textLabel?.textColor = UIColor.darkGray
        cell?.textLabel?.font = UIFont(name: fontRegular, size: 14)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.AssetsListCell, for: indexPath) as! AssetsListTableViewCell
        
        let assetsObj = currentList[indexPath.section].assetList[indexPath.row]
        var thumnailImg : UIImage = BL_AssetModel.sharedInstance.getThumbnailImage(docType : assetsObj.docType!)
        
        cell.assetNameLbl.text = assetsObj.daName
        cell.menuBtn.indexPath = indexPath
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
        let size = (assetsObj.Total_Measure ?? "0") + " " + assetsObj.Measured_Unit
        cell.assetsDetailLbl.text = "\(String(format: "%.2f", assetsObj.daSize)) MB | \(getDocTypeVal(docType : assetsObj.docType)) | \(size) | \(downloadedStatus)"
        cell.menuBtn.isUserInteractionEnabled = true
        cell.videoPlayBackView.constant = 0
        cell.activityIndicatorWidth.constant = 0
        
        if selectedList.contains(assetsObj)
        {
            cell.mainView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
        }
        else
        {
            cell.mainView.backgroundColor = UIColor.white
        }
        
        if isSelectionMode
        {
            cell.menuBtn.isUserInteractionEnabled = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    @IBAction func menuBtnAction(_ sender: MyButton)
    {
        let indexPath = sender.indexPath
        assetObj = currentList[(indexPath?.section)!].assetList[(indexPath?.row)!]
        let popUp_sb = UIStoryboard(name:Constants.StoaryBoardNames.AssetsListSb, bundle: nil)
        let popUp_Vc = popUp_sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.AssetsMenuListVcID) as! AssetMenuListViewController
        popUp_Vc.delegate = self
        popUp_Vc.assetObj = assetObj
        popUp_Vc.providesPresentationContextTransitionStyle = true
        popUp_Vc.modalTransitionStyle = .coverVertical
        popUp_Vc.definesPresentationContext = true
        popUp_Vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(popUp_Vc, animated: true, completion: nil)
    }
    
    
    private func reloadTableViewAtSpecificIndex(indexPath: IndexPath)
    {
        
        if (indexPath.section < self.currentList.count) && indexPath.row < self.currentList[indexPath.section].assetList.count
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
        var searchList : [AssetHeader] = []
        var detailList : [AssetHeader] = []
        
        
        if text != ""
        {
            searchList = detailList.filter { (assetObj) -> Bool in
                let lowerCaseString = text.lowercased()
                return assetObj.daName.lowercased().contains(lowerCaseString)
            }
            changeCurrentArray(list: BL_AssetModel.sharedInstance.getWrapperAssetList(list: searchList), type: 2)
        }
        else
        {
            setAssetDetails()
        }
    }
    
    private func changeCurrentArray(list : [AssetsWrapperModel],type : Int)
    {
        if list.count > 0
        {
            currentList = list
            showEmptyStateView(show: false)
            self.tableView.reloadData()
        }
        else
        {
            setEmptyStateLbl(type: type)
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
            emptyStateTxt = "No digital resource Found"
            searchViewHeightConst.constant = 0
        }
        else if type == 2
        {
            emptyStateTxt = "No digital resource found. Clear your search and try again."
        }
        else
        {
            emptyStateTxt = "No show list found"
            searchViewHeightConst.constant = 0
        }
        self.emptyStateLbl.text = emptyStateTxt
    }
    
    
    
    func panGestureHandleAction(sender : UIPanGestureRecognizer)
    {
        
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
        setAssetDetails()
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
    
    
    private func addSelectedListToShowList()
    {
//        BL_AssetModel.sharedInstance.showList =
//             AssetsDataManager.sharedManager.convertAssetHeaderToShowListModel(assetList:  covertToAssetsListModel(list: selectedList))
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
        
        //        if !isMenu
        //        {
        //            if type == 1
        //            {
        //                addSelectedListToShowList()
        //                navigateToAssetsPlaylist()
        //            }
        //            else
        //            {
        //                downloadSelectedList()
        //            }
        //        }
        //        else
        //        {
        //            setItemIndex(index: type)
        //        }
    }
    
    private func downloadSelectedList()
    {
        if selectedList.count > 0
        {
            if checkInternetConnectivity()
            {
                BL_AssetModel.sharedInstance.updateDownloadStatus(selectedList: covertToAssetsListModel(list: selectedList), status: isFileDownloaded.progress.rawValue)
                setAssetDetails()
                selectedList = []
                if BL_AssetDownloadOperation.sharedInstance.statusList.count == 0
                {
                    BL_AssetDownloadOperation.sharedInstance.initiateOperation()
                }
                self.tableView.reloadData()
            }
            else
            {
                showToastView(toastText:internetOfflineMessage)
            }
        }
        else
        {
            showToastView(toastText: "Select atleast anyone digital resource to proceed download")
        }
    }
    
    
    //    private func setItemIndex(index : Int)
    //    {
    //        switch index
    //        {
    //        case assetMenuId.imageInfo:
    //            navigateToAssetsInfo()
    //        case assetMenuId.play:
    //            navigateToAssetsPlaylist()
    //        case assetMenuId.addToShowList:
    //            addAssetObjectToShowList()
    //        case assetMenuId.details:
    //            navigateToAssetsInfo()
    //        case 8 :
    //            setAssetDetails()
    //        default:
    //            print("\n")
    //        }
    //    }
    
    private func navigateToAssetsInfo()
    {
        let sb = UIStoryboard(name: Constants.StoaryBoardNames.AssetsListSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.AssetInfoVCID) as! AssetDetailController
        vc.assetModel = assetObj
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToAssetsPlaylist()
    {
        addSelectedListToShowList()
        let sb = UIStoryboard(name:AssetsPlaySb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier:"AssetsPlayerVCID") as! AssetsPlayerViewController
        vc.assetObj = assetObj
        self.navigationController?.pushViewController(vc, animated: true)
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
//                BL_AssetModel.sharedInstance.showList.append(  AssetsDataManager.sharedManager.convertAssetHeaderToShowListObj(asset: assetObj!) )
            }
            showToastView(toastText: "Added to show list")
            setAssetDetails()
        }
    }
    
    
    func refresh()
    {
        if checkInternetConnectivity()
        {
            BL_MasterDataDownload.sharedInstance.getDigitalAssetsData(masterDataGroupName: "Assets Refresh") { (status) in
                self.endRefresh()
                DispatchQueue.main.async {
                    if status == SERVER_SUCCESS_CODE
                    {
                        showToastView(toastText: "Refreshed Successfully")
                        self.setAssetDetails()
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
            showToastView(toastText: internetOfflineMessage)
        }
    }
    
    func addBarButtonItem()
    {
        let rightBarButton = UIButton(type: UIButtonType.custom)
        
        rightBarButton.addTarget(self, action: #selector(self.navigateToPlayList), for: UIControlEvents.touchUpInside)
        rightBarButton.setImage(UIImage(named: "icon-asset-play"), for: .normal)
        rightBarButton.sizeToFit()
        
        playBtn = UIBarButtonItem(customView: rightBarButton)
    }
    
    @objc func navigateToPlayList()
    {
        if BL_AssetModel.sharedInstance.showList.count > 0
        {
            navigateToAssetsPlaylist()
        }
    }
    
    
    func endRefresh()
    {
        if self.refreshControl.isRefreshing
        {
            refreshControl.endRefreshing()
        }
    }
    
    @IBAction func addBtnAction(_ sender: Any) {
    }
    
    
    
}
