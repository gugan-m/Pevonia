//
//  AssetsListViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 17/05/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit


struct menuIndex
{
    static let assetName : Int = 0
    static let play : Int = 1
    static let preview : Int = 2
    static let showList : Int = 3
    static let availableOffline : Int = 4
    static let details : Int = 5
    static let delete : Int = 6
}


class AssetsListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,AssetsSelectedDelegate
{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateView : UIView!
    @IBOutlet weak var searchViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var emptyStateLbl : UILabel!
    @IBOutlet weak var tableViewWidth: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var searchBarHgtConst: NSLayoutConstraint!
    
    @IBOutlet weak var assetPopUpView: UIView!
    @IBOutlet weak var dontShowImage: UIImageView!
    
    @IBOutlet var lblPleaseNote: UILabel!
    
    
    var currentList : [AssetsWrapperModel] = []
    var dragView : AssetsSelectionView = AssetsSelectionView()
    var selectedCount : Int = 0
    var isSelectionMode : Bool = false
    var selectedList : NSMutableArray = []
    var isToShowList : Bool = false
    var isComingFromDigitalAssets : Bool = false
    var isFromAssetShowList : Bool = false
    var isComingForSelection = false
    var videoImage : [String : UIImage] = [:]
    var selectedDetailLabel = UILabel()
    var assetObj : AssetHeader?
    var delegate : deleteOrAddShowListDelegate!
    var addBtn : UIBarButtonItem!
    var refreshControl: UIRefreshControl!
    var isForPreview = false
    var tempAssetObj :AssetHeader?
    var selectedListFinal : NSMutableArray = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if !isToShowList
        {
            BL_AssetModel.sharedInstance.clearList()
        }
        
        if isComingForSelection
        {
            searchBarHgtConst.constant = 0
            addBarButtonItem()
        }
        self.lblPleaseNote.text = PEV_DIGITAL_ASSET_PLS_LBL
        addBackButton()
        setDefaultDetails()
        pullDownRefresh()
    }
    
    
    
    
    func addBackButton()
    {
        let backButton = UIButton(type: UIButtonType.custom)
        
        backButton.addTarget(self, action: #selector(self.backButtonClick), for: UIControlEvents.touchUpInside)
        backButton.setImage(UIImage(named: "back-ic"), for: .normal)
        //backButton.setBackgroundImage(UIImage(named: "navigation-arrow"), for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.sizeToFit()
        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    @objc override func backButtonClick(sender : UIButton) {
        self.navigationController?.popViewController(animated: true);
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.assetPopUpView.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(updateDownloadStatus(_:)), name: NSNotification.Name(rawValue: assetNotification), object: nil)
        
        if (isComingFromDigitalAssets)
        {
            DBHelper.sharedInstance.deleteFromTable(tableName: TBL_CUSTOMER_TEMP_SHOWLIST)
        }
        
        setAssetDetails()
        addFooterView()
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
    
    func addBarButtonItem()
    {
        let rightBarButton = UIButton(type: UIButtonType.custom)
        
        rightBarButton.addTarget(self, action: #selector(addToShowList), for: UIControlEvents.touchUpInside)
        rightBarButton.setImage(UIImage(named: "icon-done"), for: .normal)
        rightBarButton.sizeToFit()
        
        addBtn = UIBarButtonItem(customView: rightBarButton)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        dragView.frame = getDragViewFrame(cgsize: size)
        
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    private func setDefaultDetails()
    {
        var title : String = EMPTY
        
        if isComingFromDigitalAssets
        {
            title = PEV_DIGITAL_ASSETS
        }
        else if isComingForSelection
        {
            title = "Digital Resource List"
        }
        
        self.navigationItem.title = title
    }
    
    func setAssetDetails()
    {
        var detailList : [AssetHeader] = []
        var type : Int = 0
        
        if !isToShowList
        {
            let customerCode: String = checkNullAndNilValueForString(stringData: BL_DoctorList.sharedInstance.customerCode)
            let regionCode: String = checkNullAndNilValueForString(stringData: BL_DoctorList.sharedInstance.regionCode)
            
            BL_AssetModel.sharedInstance.assetList = BL_AssetModel.sharedInstance.getAssetList(isFromDigitalAssets: self.isComingFromDigitalAssets, customerCode: customerCode, regionCode: regionCode)
            
            detailList =  BL_AssetModel.sharedInstance.assetList
            type = 1
        }
        
        let list = BL_AssetModel.sharedInstance.getWrapperAssetList(list: detailList)
        // updateSelectedList()
        changeCurrentArray(list: list, type: type)
        // setTableViewWidth()
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
        //        if !isToShowList
        //        {
        //            return 50
        //        }
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
        return 80
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
        if(downloadedStatus == "Offline")
        {
            cell.onlineImg.isHidden = true
        }
        else
        {
            cell.onlineImg.isHidden = false
        }
        cell.assetsImg.image = thumnailImg
        
        cell.assetsDetailLbl.text = "\(String(format: "%.2f", assetsObj.daSize)) MB | \(getDocTypeVal(docType : assetsObj.docType)) | \(downloadedStatus)"
        cell.menuBtn.isUserInteractionEnabled = true
        cell.videoPlayBackView.constant = 0
        cell.activityIndicatorWidth.constant = 0
        cell.activityIndicator.startAnimating()
        
        if selectedList.contains(assetsObj) && !isToShowList
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
        
        if isComingFromDigitalAssets && assetsObj.isDownloaded == isFileDownloaded.progress.rawValue
        {
            cell.activityIndicatorWidth.constant = 20
        }
        
        if isComingForSelection
        {
            cell.menuBtn.isHidden = true
            cell.mainView.backgroundColor = UIColor.white
            cell.checkMarkImgVw.isHidden = false
            
            if selectedList.contains(assetsObj) && !isToShowList
            {
                cell.checkMarkImgVw.image = UIImage(named: "icon-tick")
            }
            else
            {
                cell.checkMarkImgVw.image = UIImage(named: "icon-unselected")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        if isToShowList
        {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let assetObj = currentList[indexPath.section].assetList[indexPath.row]
        
        if !isComingForSelection
        {
            if isSelectionMode && !isToShowList
            {
                if(assetObj.isDownloaded == 0)
                {
                    if assetObj.isDownloadable == 1 && isComingFromDigitalAssets
                    {
                        if selectedList.contains(assetObj)
                        {
                            selectedList.remove(assetObj)
                        }
                        else
                        {
                            selectedList.add(assetObj)
                        }
                        selectedCount = selectedList.count
                        self.checkIsToShowDragView()
                        self.reloadTableViewAtSpecificIndex(indexPath: indexPath)
                    }
                    else if !isComingFromDigitalAssets
                    {
                        if selectedList.contains(assetObj)
                        {
                            selectedList.remove(assetObj)
                        }
                        else
                        {
                            selectedList.add(assetObj)
                        }
                        selectedCount = selectedList.count
                        self.checkIsToShowDragView()
                        self.reloadTableViewAtSpecificIndex(indexPath: indexPath)
                    }
                }
            }
            else
            {
                navigateValidationforAsset(assetObj: assetObj)
            }
        }
        else
        {
            if selectedList.contains(assetObj)
            {
                selectedList.remove(assetObj)
            }
            else
            {
                selectedList.add(assetObj)
            }
            selectedCount = selectedList.count
            checkForShowList()
            self.reloadTableViewAtSpecificIndex(indexPath: indexPath)
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
            navigateToAssetPlayList(assetObj : assetObj)
        }
        else if (getDocTypeVal(docType: (assetObj.docType)!) != Constants.DocType.zip)
        {
            navigateToAssetPlayList(assetObj : assetObj)
        }
    }
    
    func navigateToAssetPlayList(assetObj : AssetHeader)
    {
        let isAssetPopUpShow = UserDefaults.standard.bool(forKey:"isAssetPopUpShow")
        if(isAssetPopUpShow == nil || !isAssetPopUpShow)
        {
            UserDefaults.standard.set(false, forKey: "isAssetPopUpShow")
            tempAssetObj = assetObj
            self.assetPopUpView.isHidden = false
            //show popup
        }
        else
        {
            navigateToAssetPage(assetObj:assetObj)
        }
    }
    
    func navigateToAssetPage(assetObj : AssetHeader)
    {
        let sb = UIStoryboard(name: AssetsPlaySb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AssetsPlayerVCID") as! AssetsPlayerViewController
        vc.assetObj = assetObj
        var assetList : [AssetHeader] = []
        if !isToShowList
        {
            addSelectedListToShowList()
            assetList = BL_AssetModel.sharedInstance.assetList
        }
        
        let playListArray = BL_AssetModel.sharedInstance.getAssetPlayList(assetList: assetList, isShowList: isToShowList)
        vc.assetsArray = playListArray
        var preview : Int = 0
        if isComingFromDigitalAssets || isForPreview
        {
            preview = 1
        }
        isForPreview = false
        vc.isPreview = preview
        if playListArray.count > 0
        {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func navigateToAssetPage  (_ sender: Any)
    {
        if(dontShowImage.image == UIImage(named:"icon-checkbox-blank"))
        {
            UserDefaults.standard.set(false, forKey: "isAssetPopUpShow")
        }
        else
        {
            UserDefaults.standard.set(true, forKey: "isAssetPopUpShow")
        }
        if isManager()
        {
            let sb = UIStoryboard(name:commonListSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: userListVcID) as! UserListViewController
            vc.navigationScreenName = UserListScreenName.CustomerList.rawValue
            vc.navigationTitle = "Choose User"
            vc.isCustomerMasterEdit = false
            vc.doctorListPageSoruce = Constants.Doctor_List_Page_Ids.Customer_List
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            CustomerModel.sharedInstance.regionCode = getRegionCode()
            CustomerModel.sharedInstance.userCode = getUserCode()
            CustomerModel.sharedInstance.navTitle = "\(appDoctorPlural) List"
            setSplitViewRootController(backFromAsset: false, isCustomerMasterEdit: false, customerListPageSouce: Constants.Doctor_List_Page_Ids.Customer_List)
        }
    }
    
    @IBAction func understandButton  (_ sender: Any)
    {
        if(dontShowImage.image == UIImage(named:"icon-checkbox-blank"))
        {
            UserDefaults.standard.set(false, forKey: "isAssetPopUpShow")
        }
        else
        {
            UserDefaults.standard.set(true, forKey: "isAssetPopUpShow")
        }
        navigateToAssetPage(assetObj:tempAssetObj!)
    }
    
    @IBAction func dontShowButton  (_ sender: Any)
    {
        if(dontShowImage.image == UIImage(named:"icon-checkbox-blank"))
        {
          dontShowImage.image = UIImage(named:"icon-checkbox")
        }
        else
        {
            dontShowImage.image = UIImage(named:"icon-checkbox-blank")
        }
    }
    
    func checkForShowList()
    {
        if selectedList.count > 0
        {
            self.navigationItem.rightBarButtonItem = addBtn
        }
        else
        {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc func addToShowList()
    {
        showListBtnAction()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuBtnAction(_ sender: MyButton)
    {
        resetValue()
        let indexPath = sender.indexPath
        assetObj = currentList[(indexPath?.section)!].assetList[(indexPath?.row)!]
        let popUp_sb = UIStoryboard(name:Constants.StoaryBoardNames.AssetsListSb, bundle: nil)
        let popUp_Vc = popUp_sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.AssetsMenuListVcID) as! AssetMenuListViewController
        popUp_Vc.isToShowList = isToShowList
        popUp_Vc.delegate = self
        popUp_Vc.assetObj = assetObj
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
        
        if !isToShowList
        {
            
            detailList = BL_AssetModel.sharedInstance.assetList
        }
        
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
            emptyStateTxt = "No Digital Resource Found"
            searchViewHeightConst.constant = 0
        }
        else if type == 2
        {
            emptyStateTxt = "No Digital Resource found. Clear your search and try again."
        }
        else
        {
            emptyStateTxt = "No show list found"
            searchViewHeightConst.constant = 0
        }
        self.emptyStateLbl.text = emptyStateTxt
    }
    
    private func setDragAndDropView(cgsize : CGSize)
    {
        dragView =  AssetsSelectionView.loadNib()
        dragView.frame = self.getDragViewFrame(cgsize :cgsize)
        dragView.delegate = self
        dragView.isComingFromDigitalAssets = isComingFromDigitalAssets
        containerView.isHidden = true
        dragView.isComingFromDigitalAssets = isComingFromDigitalAssets
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
        if !isToShowList
        {
            let p = longPressGesture.location(in: self.tableView)
            let indexPath = self.tableView.indexPathForRow(at: p)
            var assetObj : AssetHeader!
            if indexPath == nil {
                print("Long press on table view, not row.")
            }
            else if (longPressGesture.state == UIGestureRecognizerState.began)
            {
                assetObj = currentList[(indexPath!.section)].assetList[(indexPath!.row)]
                let downloadable = assetObj.isDownloadable
                
                if(assetObj.isDownloaded == 0)
                {
                    if isComingFromDigitalAssets && downloadable == 1
                    {
                        if selectedList.contains(assetObj)
                        {
                            selectedList.remove(assetObj)
                        }
                        else
                        {
                            selectedList.add(assetObj)
                        }
                    }
                    else if !isComingFromDigitalAssets
                    {
                        if selectedList.contains(assetObj)
                        {
                            selectedList.remove(assetObj)
                        }
                        else
                        {
                            selectedList.add(assetObj)
                        }
                    }
                    selectedCount = selectedList.count
                    if selectedCount > 0
                    {
                        self.isSelectionMode = true
                    }
                    self.checkIsToShowDragView()
                    self.reloadTableViewAtSpecificIndex(indexPath: indexPath!)
                }
            }
        }
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
        if isToShowList || isComingFromDigitalAssets || isComingForSelection
        {
            _ = navigationController?.popViewController(animated: false)
        }
        else
        {
            setSplitViewRootController(backFromAsset: true, isCustomerMasterEdit: false, customerListPageSouce: Constants.Doctor_List_Page_Ids.Customer_List)
        }
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
    
    func showListBtnAction()
    {
        addSelectedListToShowList()
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
        if !isToShowList
        {
            BL_AssetModel.sharedInstance.thumbailImage = [:]
        }
    }
    
    private func addSelectedListToShowList()
    {
        let selectedShowList = covertToAssetsListModel(list: self.selectedList)
        
        var listCount = DBHelper.sharedInstance.getMaxDisplayOrderForShowList() ?? 0
        
        

        for showListObj in selectedShowList
        {
            var isExist = false
            for assetObj in BL_AssetModel.sharedInstance.showList
            {
                if assetObj.assetDetail?.daCode == showListObj.daCode
                {
                    isExist = true
                    break
                }
            }
            
            if !isExist
            {
                listCount += 1
                let dict = NSMutableDictionary()
                dict.setValue( -1 ,forKey: "Story_Id")
                dict.setValue( showListObj.daCode ,forKey: "DA_Code")
                dict.setValue( listCount ,forKey: "Display_Order")
                let insertObj = AssetShowList(dict: dict)
                DBHelper.sharedInstance.insertCustomerShowList1(showListObj: insertObj)
            }
            
            selectedListFinal.add(showListObj.daCode)
            
        }
        
        let defaults = UserDefaults.standard
        defaults.set(selectedListFinal, forKey: "SelectedListAssets")
        defaults.synchronize()
        
        BL_AssetModel.sharedInstance.refreshShowList()
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
                addSelectedListToShowList()
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
            showToastView(toastText: "Select atleast anyone digital resource to proceed download")
        }
    }
    
    private func startDownloadAssets(downloadList : [AssetHeader])
    {
        if checkInternetConnectivity()
        {
            BL_AssetModel.sharedInstance.updateDownloadStatus(selectedList: downloadList,status: isFileDownloaded.progress.rawValue)
            selectedList = []
            BL_AssetDownloadOperation.sharedInstance.downloadFailed = false
            let filteredAssetList : [AssetHeader] = DBHelper.sharedInstance.getAssetsByInProgressStatus(downloadStatus: isFileDownloaded.progress.rawValue)
            BL_AssetDownloadOperation.sharedInstance.totalAssetCount = filteredAssetList.count
            
            DispatchQueue.main.async {
                self.setAssetDetails()
            }
            if BL_AssetDownloadOperation.sharedInstance.statusList.count == 0
            {
                BL_AssetDownloadOperation.sharedInstance.initiateOperation()
            }
            showToastView(toastText:"Please stay on this screen inorder to digital resource download faster")
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
            navigateValidationforAsset(assetObj: assetObj!)
        case menuIndex.preview:
            isForPreview = true
            navigateValidationforAsset(assetObj: assetObj!)
            
        case menuIndex.showList:
            if assetObj?.isDownloadable == 0 && isComingFromDigitalAssets
            {
                navigateToAssetsInfo()
            }
            else
            {
                addAssetObjectToShowList()
            }
            
        case menuIndex.details:
            navigateToAssetsInfo()
            
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
        vc.assetModel = assetObj
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToAssetsPlaylist()
    {
        addSelectedListToShowList()
        let sb = UIStoryboard(name:AssetsPlaySb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier:"AssetsPlayerVCID") as! AssetsPlayerViewController
        var assetList : [AssetHeader] = []
        if isToShowList || isFromAssetShowList
        {
            //   assetList =  AssetsDataManager.sharedManager.   convertShowListModelToAssetHeader(showList: BL_AssetModel.sharedInstance.showList)
            
        }
        else
        {
            assetList = BL_AssetModel.sharedInstance.assetList
        }
        var preview : Int = 0
        if isComingFromDigitalAssets
        {
            preview = 1
        }
        vc.isPreview = preview
        let playListArray = BL_AssetModel.sharedInstance.getAssetPlayList(assetList: assetList, isShowList: isToShowList)
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
            let listCount = BL_AssetModel.sharedInstance.showList.count
            BL_AssetModel.sharedInstance.refreshShowList()
            var isExist = false
            
            for showListObj in BL_AssetModel.sharedInstance.showList{
                if assetObj?.daCode == showListObj.assetDetail?.daCode{
                    isExist = true
                    break
                }
                
            }
            if !isExist{
                
                let dict = NSMutableDictionary()
                dict.setValue( -1 ,forKey: "Story_Id")
                dict.setValue( assetObj!.daCode ,forKey: "DA_Code")
                dict.setValue( listCount ,forKey: "Display_Order")
                let insertObj = AssetShowList(dict: dict)
                DBHelper.sharedInstance.insertCustomerShowList1(showListObj: insertObj)
                showToastView(toastText: "Added to show list")
                
            }else{
                showToastView(toastText: "Already exist")
                
            }
            setAssetDetails()
        }
    }
    
    private func pullDownRefresh()
    {
        if !isToShowList
        {
            refreshControl = UIRefreshControl()
            refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            
            refreshControl.addTarget(self, action: #selector(AssetsListViewController.refresh), for: UIControlEvents.valueChanged)
            tableView.addSubview(refreshControl)
        }
    }
    
    @objc func refresh()
    {
        showDragView(show: false)
        resetValue()
        if checkInternetConnectivity()
        {
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
                        DispatchQueue.main.async {
                            showToastView(toastText: "Refreshed Successfully")
                            self.setAssetDetails()
                        }
                    }
                }
                else
                {
                    self.endRefresh()
                    showToastView(toastText: serverSideError)
                }
            }
            
            navigateToAttachmentUpload = false
            BL_UploadAnalytics.sharedInstance.checkAnalyticsStatus()
        }
        else
        {
            self.endRefresh()
            showToastView(toastText: internetOfflineMessage)
        }
    }
    
    func navigateToPlayList()
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
    
    func showAlertViewToDownload(assetObj : AssetHeader)
    {
        if checkInternetConnectivity()
        {
            let alertViewController = UIAlertController(title: nil, message: "This digital resource can be played after downloading.Do you want to download \"\(assetObj.daName!)\"?", preferredStyle: UIAlertControllerStyle.alert)
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
}

class MyButton: UIButton
{
    var indexPath: IndexPath!
}
