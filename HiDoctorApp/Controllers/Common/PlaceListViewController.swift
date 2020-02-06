//
//  PlaceListViewController.swift
//  HiDoctorApp
//
//  Created by Vignaya on 11/1/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

protocol AddWorkPlaceDelegate
{
    func setSelectedWorkPlace(placeObj : PlaceMasterModel)
}

class PlaceListViewController: UIViewController , UITableViewDelegate , UITableViewDataSource,UISearchBarDelegate
{    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar : UISearchBar!
    
    @IBOutlet weak var searchBarHgtConst: NSLayoutConstraint!
    @IBOutlet weak var addBtn: UIBarButtonItem!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var refreshLabel: UILabel!
    @IBOutlet weak var refreshLblHeightConstraint: NSLayoutConstraint!
    
    var placeList : [PlaceMasterModel] = []
    var currentList : [PlaceMasterModel] = []
    var searchList : [PlaceMasterModel] = []
    var delegate : AddWorkPlaceDelegate?
    var navigationTitle : String = "Places"
    var navigationScreenname : String = ""
    var refreshBtn : UIBarButtonItem!
    var getRegion = String()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.searchBar.layer.borderWidth = 1
        self.searchBar.layer.borderColor = UIColor.white.cgColor
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.navigationController?.isNavigationBarHidden = false
        self.changeCurrentArray(list: placeList,type : 0)
        self.navigationItem.title = navigationTitle
        self.navigationController?.navigationBar.topItem?.title = "Back"
        self.emptyStateView.isHidden  = true
        self.refreshLblHeightConstraint.constant = 0
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if (navigationScreenname == addTravelFromPlace || navigationScreenname == addTravelToPlace)
        {
            if BL_SFC.sharedInstance.placeListAddBtnHidden()
            {
                addBtn.isEnabled = false
                addBtn.tintColor = UIColor.clear
            }
            else
            {
                addBtn.isEnabled = true
                addBtn.tintColor = nil
            }
        }
        else if (navigationScreenname == addTPTravelFromPlace || navigationScreenname == addTPTravelToPlace)
        {
            self.refreshLblHeightConstraint.constant = 16
            self.addRefreshBtn()
            self.syncRefreshDate()
            
            if BL_TP_SFC.sharedInstance.placeListAddBtnHidden()
            {
                self.navigationItem.rightBarButtonItems = [refreshBtn]
            }
            else
            {
                self.navigationItem.rightBarButtonItems = [addBtn, refreshBtn]
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return currentList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let placeObj = currentList[indexPath.row]
        cell.textLabel?.text = (placeObj.placeName)
        cell.textLabel?.textColor = UIColor(red: 63/255, green: 63/255, blue: 63/255, alpha: 1.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let placeObj = currentList[indexPath.row]
        
        if (navigationScreenname == addTravelFromPlace || navigationScreenname == addTravelToPlace || navigationScreenname == addTPTravelFromPlace || navigationScreenname == addTPTravelToPlace)
        {
            if navigationScreenname == addTravelFromPlace
            {
                BL_SFC.sharedInstance.fromPlace = placeObj.placeName
            }
            else if navigationScreenname == addTravelToPlace
            {
                BL_SFC.sharedInstance.toPlace = placeObj.placeName
            }
            else if navigationScreenname == addTPTravelFromPlace
            {
                BL_TP_SFC.sharedInstance.fromPlace = placeObj.placeName
            }
            else if navigationScreenname == addTPTravelToPlace
            {
                BL_TP_SFC.sharedInstance.toPlace = placeObj.placeName
            }
            
            var fromPlace = ""
            var toPlace = ""
            
            if (navigationScreenname == addTravelFromPlace || navigationScreenname == addTravelToPlace)
            {
                fromPlace = BL_SFC.sharedInstance.fromPlace
                toPlace = BL_SFC.sharedInstance.toPlace
                
            }
            else if (navigationScreenname == addTPTravelFromPlace || navigationScreenname == addTPTravelToPlace)
            {
                fromPlace = BL_TP_SFC.sharedInstance.fromPlace
                toPlace = BL_TP_SFC.sharedInstance.toPlace
            }
            
            var travelMode : String? = ""
            var distance : Float? = 0.0
            var sfcVersion : Int? = 0
            var sfcCategory : String? = ""
            var sfcRegionCode : String? = getRegionCode()
            var distanceFareCode : String? = ""
            var validSFC : Bool = false
            
            if fromPlace != "" && toPlace != ""
            {
                var modelArr = [SFCMasterModel]()
                
                if (navigationScreenname == addTravelFromPlace || navigationScreenname == addTravelToPlace)
                {
                    modelArr = BL_SFC.sharedInstance.getSFCDetail()!
                }
                else if (navigationScreenname == addTPTravelFromPlace || navigationScreenname == addTPTravelToPlace)
                {
                    modelArr = BL_TP_SFC.sharedInstance.getSFCDetail()!
                }
                
                if modelArr.count == 1
                {
                    travelMode = modelArr[0].Travel_Mode
                    distance = modelArr[0].Distance
                    sfcVersion = modelArr[0].SFC_Version
                    sfcCategory = modelArr[0].Category_Name
                    sfcRegionCode = modelArr[0].Region_Code
                    distanceFareCode = modelArr[0].Distance_Fare_Code
                    validSFC = true
                    popViewControllers(travelMode: travelMode!, distance: distance!, sfcVersion: sfcVersion!, sfcCategory: sfcCategory, sfcRegionCode: sfcRegionCode, distancefareCode: distanceFareCode, isValidSFC: validSFC)
                }
                else if (modelArr.count) > 1
                {
                    let sb = UIStoryboard(name: addTravelDetailSb, bundle: nil)
                    let vc = sb.instantiateViewController(withIdentifier: travelSuggestionVcID) as! TravelModeSuggestionController
                    if (navigationScreenname == addTPTravelFromPlace || navigationScreenname == addTPTravelToPlace) {
                        vc.isComingForTp = true
                    }
                    vc.suggestionList = modelArr
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else
                {
                    popViewControllers(travelMode: travelMode!, distance: distance!, sfcVersion: sfcVersion!, sfcCategory: sfcCategory, sfcRegionCode: sfcRegionCode, distancefareCode: distanceFareCode, isValidSFC: validSFC)
                }
            }
            else
            {
                popViewControllers(travelMode: travelMode!, distance: distance!, sfcVersion: sfcVersion!, sfcCategory: sfcCategory, sfcRegionCode: sfcRegionCode, distancefareCode: distanceFareCode, isValidSFC: validSFC)
            }
            
        } else
        {
            if !BL_WorkPlace.sharedInstance.selected_Workplace_Array.contains(placeObj.placeName) {
            BL_WorkPlace.sharedInstance.selected_Workplace_Array.append(placeObj.placeName)
            }
            self.delegate?.setSelectedWorkPlace(placeObj:placeObj)
            _ = navigationController?.popViewController(animated: false)
        }
    }
    
    func popViewControllers(travelMode : String, distance : Float, sfcVersion : Int, sfcCategory : String?, sfcRegionCode : String?, distancefareCode : String?, isValidSFC : Bool)
    {
        if let navigationController = self.navigationController
        {
            let viewControllers = navigationController.viewControllers
            
            for vc in  viewControllers
            {
                if vc.isKind(of: AddTravelDetailsController.self)
                {
                    let controller = vc as! AddTravelDetailsController
                    controller.fromPlace = BL_SFC.sharedInstance.fromPlace
                    controller.toPlace = BL_SFC.sharedInstance.toPlace
                    controller.travelMode = travelMode
                    controller.distance = distance
                    controller.distanceFareCode = distancefareCode
                    controller.sfcVersion = sfcVersion
                    controller.sfcCategory = sfcCategory
                    controller.sfcRegionCode = sfcRegionCode
                    controller.validSFC = isValidSFC
                    _ = self.navigationController?.popToViewController(vc, animated: false)
                    return
                }
                else if vc.isKind(of: TPTravelDetailsViewController.self)
                {
                    let controller = vc as! TPTravelDetailsViewController
                    controller.fromPlace = BL_TP_SFC.sharedInstance.fromPlace
                    controller.toPlace = BL_TP_SFC.sharedInstance.toPlace
                    controller.travelMode = travelMode
                    controller.distance = distance
                    controller.distanceFareCode = distancefareCode
                    controller.sfcVersion = sfcVersion
                    controller.sfcCategory = sfcCategory
                    controller.sfcRegionCode = sfcRegionCode
                    controller.validSFC = isValidSFC
                    _ = self.navigationController?.popToViewController(vc, animated: false)
                    return
                }
            }
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
        self.changeCurrentArray(list: placeList,type : 0)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if (searchBar.text?.count)! > 0
        {
            sortCurrentList(searchText: searchBar.text!)
        }
    }
    
    func sortCurrentList(searchText:String)
    {
        searchList = placeList.filter{ (placeNameObj) -> Bool in
            let lowerCasedText = searchText.lowercased()
            let placeName =  placeNameObj.placeName.lowercased()
            return placeName.contains(lowerCasedText)
        }
        self.changeCurrentArray(list: searchList , type : 1)
    }
    
    @IBAction func addWorkPlaceBtnAction(_ sender: AnyObject)
    {
        let sb = UIStoryboard(name: workPlaceDetailsSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier:AddFlexiWorkPlaceVcID) as! AddFlexiWorkPlaceViewController
        vc.navigationScreenname = navigationScreenname
        if let navigationController = self.navigationController
        {
            navigationController.popViewController(animated: false)
            navigationController.pushViewController(vc, animated: false)
        }
    }
    
    
    func changeCurrentArray(list: [PlaceMasterModel] , type : Int)
    {
        if list.count > 0
        {
            self.currentList = list
            self.tableView.isHidden = false
            self.emptyStateView.isHidden = true
            self.tableView.reloadData()
        }
        else
        {
            self.tableView.isHidden = true
            self.emptyStateView.isHidden = false
        }
        self.setSearchBarHeightConst(type: type)
    }
    
    func setSearchBarHeightConst(type : Int)
    {
        if type == 0 && currentList.count == 0
        {
            self.searchBarHgtConst.constant = 0
        }
        else
        {
            self.searchBarHgtConst.constant = 40
        }
    }
    
    func addRefreshBtn()
    {
        
        refreshBtn = UIBarButtonItem(image: UIImage(named: "icon-refresh"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(refreshAction))
    }
    @objc func refreshAction()
    {
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: "Loading SFC data...")
            
            BL_MasterDataDownload.sharedInstance.downloadSFCData(masterDataGroupName: EMPTY, completion: { (status) in
                removeCustomActivityView()
                
                if status == SERVER_SUCCESS_CODE
                {
                    self.syncRefreshDate()
                    self.placeList = []
                    self.placeList = BL_TP_SFC.sharedInstance.convertToSFCPlaceModel(regionCode: self.getRegion)!
                    self.tableView.reloadData()
                    AlertView.showAlertView(title: "SUCCESS", message: "SFC data are downloaded successfully")
                }
                else
                {
                    showToastView(toastText: "Unable to load the contact data")
                }
            })
        }
        else
        {
            showToastView(toastText: internetOfflineMessage)
        }
    }
    
    func syncRefreshDate()
    {
        let apiModel = BL_TPStepper.sharedInstance.getLastSyncDate(apiName: ApiName.SFCData.rawValue)
        
        if(apiModel != nil)
        {
            if(apiModel.Download_Date != nil)
            {
                let date = convertDateIntoLocalDateString(date: apiModel.Download_Date)
                let time = stringFromDate(date1: apiModel.Download_Date)
                self.refreshLabel.text = "Last Modified: \(date) \(time)"
                self.refreshLblHeightConstraint.constant = 16
            }
            else
            {
                self.refreshLabel.text = EMPTY
                self.refreshLblHeightConstraint.constant = 0
            }
        }
    }
}
