    //
    //  TPAccompanistViewController.swift
    //  HiDoctorApp
    //
    //  Created by Admin on 7/25/17.
    //  Copyright © 2017 swaas. All rights reserved.
    //

    import UIKit


    class TPAccompanistViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate
    {
        
        // MARK:-- Outlet
        
        @IBOutlet weak var emptyStateImgViewHeightConstraint: NSLayoutConstraint!
        @IBOutlet weak var tableView: UITableView!
        @IBOutlet weak var searchBar : UISearchBar!
        @IBOutlet weak var emptyStateView : UIView!
        @IBOutlet weak var contentView : UIView!
        @IBOutlet weak var emptyStateTitleLbl: UILabel!
        @IBOutlet weak var searchBarHeightConst: NSLayoutConstraint!
        @IBOutlet weak var lastRefreshTimeLbl: UILabel!
        
        //MARK:-- Class
        
        var userProductList : [UserMasterModel] = []
        var userSelectedProductCode : [String] = []
        var userSelectedList : [UserMasterModel] = []
        var currentList : [UserMasterModel] = []
        var selectedAccompanistList : [TourPlannerAccompanist] = []
        var lastSyncDateTimeList : [ApiDownloadDetailModel]?
        var selectedAccompanistCount : Int = 0
        var nextBtn : UIBarButtonItem!
        var refreshBtn : UIBarButtonItem!
        var isComingForModify = false
        var isComingForAddDoctor = false
        var refreshDate:String!
        
        
        //MARK:- View  Controller Lifecycle
        
        override func viewDidLoad()
        {
            super.viewDidLoad()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            self.getProductList()
            self.addBackButtonView()
            self.addBarButtonItem()
            self.addRefreshBtn()
            self.navigationItem.rightBarButtonItems = [refreshBtn]
            updateRefreshTimeAndDate()
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
        //MARK:- TableView Datasource and Delegate Methods
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return currentList.count
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
        {
            let userDetail = currentList[indexPath.row]
            var rowHeight : CGFloat = 80
            let productNameTextHeight = getTextSize(text: userDetail.User_Name, fontName: fontRegular, fontSize: 16, constrainedWidth: SCREEN_WIDTH - 80).height
            rowHeight += productNameTextHeight
            return rowHeight
            
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TPAccompanistCell, for: indexPath) as! TPAccompanistTableViewCell
            let userDetail = currentList[indexPath.row]
            
            cell.userNameLbl.text = userDetail.Employee_name
            cell.subTitleLbl.text = userDetail.User_Name + " | " + userDetail.Region_Name
            cell.placeLabel.text = userDetail.Region_Code

            if userSelectedProductCode.contains(userDetail.User_Code)
            {
                cell.selectedImageView.image = UIImage(named: "icon-tick")
                cell.outerView.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1.0)
            }
            else if userSelectedList.contains(userDetail)
            {
                cell.selectedImageView.image = UIImage(named: "icon-tick")
                cell.outerView.backgroundColor = UIColor.white
            }
            else
            {
                cell.selectedImageView.image = UIImage(named: "icon-unselected")
                cell.outerView.backgroundColor = UIColor.white
            }
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        {
            let userDetail = currentList[indexPath.row]
            if !userSelectedProductCode.contains(userDetail.User_Code)
            {
                
                if self.userSelectedList.contains(userDetail)
                {
                    let index = userSelectedList.index(of: userDetail)
                    self.userSelectedList.remove(at: index!)
                }
                else
                {
                    self.userSelectedList.append(userDetail)
                }
                self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                var  selectedCount : Int = 0
                
                selectedCount = selectedAccompanistCount + userSelectedList.count
                if selectedCount > 0
                {
                    self.navigationItem.title = "\(String(selectedCount)) Selected"
                }
                else
                {
                    self.navigationItem.title = "User List"
                }
                if userSelectedList.count > 0
                {
                    self.navigationItem.rightBarButtonItems = [refreshBtn , nextBtn]

                }
                else
                {
                    self.navigationItem.rightBarButtonItems = [refreshBtn]

                }
            }
        }
        
        //MARK:- Updating Views
        
        func getProductList()
        {
//            if isComingForModify
//                {
//                    userProductList = getSelectedAccompanists()
//                }
//            else
//                {
//                userProductList = BL_TPStepper.sharedInstance.getAllAccompanistList()
//                }
//            selectedAccompanistCount = userSelectedProductCode.count
//            self.navigationItem.title = "Selected Accompanists"
//            changeCurrentList(list: userProductList,type : 0)
        }
        
        func changeCurrentList(list: [UserMasterModel],type : Int)
        {
            if list.count > 0
                {
                    currentList = list
                    self.tableView.reloadData()
                    self.showEmptyStateView(show: false)
                }
            else
                {
                    self.showEmptyStateView(show: true)
                    self.setEmptyStateText(type:type)
                    self.searchBar.resignFirstResponder()
                }
        }
        
        func showEmptyStateView(show : Bool)
        {
            self.emptyStateView.isHidden = !show
            self.contentView.isHidden = show
        }
        
        func setEmptyStateText(type : Int)
        {
            if type == 0
                {
                    self.emptyStateTitleLbl.text = "No Samples Products found"
                    self.searchBarHeightConst.constant = 0
                }
            else
                {
                    self.emptyStateTitleLbl.text = "No Samples Products found.Clear your search and try again."
                    self.searchBarHeightConst.constant = 44
                }
        }
        
        //MARK: - Search Bar Delegates
        
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
            self.changeCurrentList(list: userProductList,type : 0)
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
            var searchList : [UserMasterModel] = []
            searchList = userProductList.filter{ (userDetails) -> Bool in
                let lowerCasedText = searchText.lowercased()
                let userName = (userDetails.User_Name).lowercased()
                return userName.contains(lowerCasedText)
            }
            self.changeCurrentList(list: searchList ,type : 1)
        }
        
        
        //MARK:- Accompanist Add Action
        @objc func nextScreenBtnAction()
        {
//            var accList: NSMutableArray = []
//            self.insertTPheaderDetails(date: TPModel.sharedInstance.tpDateString, tpFlag:TPModel.sharedInstance.tpFlag )
//            for model in userSelectedList
//                {
//                    
//                    let dictionary : NSMutableDictionary = [:]
//                    dictionary.setValue(TPModel.sharedInstance.tpId, forKey: "TP_Id")
//                    dictionary.setValue(TPModel.sharedInstance.tpEntryId, forKey: "TP_Entry_Id")
//                    dictionary.setValue(TPModel.sharedInstance.tpDateString, forKey: "TP_Date")
//                    dictionary.setValue(model.User_Code, forKey: "Acc_User_Code")
//                    dictionary.setValue(model.User_Name, forKey: "Acc_User_Name")
//                    dictionary.setValue(model.Region_Code, forKey: "Acc_Region_Code")
//                    dictionary.setValue(model.User_Type_Name, forKey: "Acc_User_Type_Name")
//                    dictionary.setValue(model.Employee_name, forKey: "Acc_Employee_Name")
//                    dictionary.setValue(model.Region_Name, forKey: "Acc_Region_Name")
//                    accList.add(dictionary)
//                }
//            self.accompanistSaveAction(accArray: accList)
//            BL_TPStepper.sharedInstance.selectedAccompanistList.append(contentsOf: userSelectedList)
            self.navigationController?.popViewController(animated: true)
        }
        
       
        
        func addBarButtonItem()
        {
            nextBtn = UIBarButtonItem(image: UIImage(named: "icon-done"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(nextScreenBtnAction))
        }
        
        func addRefreshBtn(){
            refreshBtn = UIBarButtonItem(image: UIImage(named: "icon-refresh"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(refreshAction))
        }
        
        //MARK:- Accompanists List Webservice call
        @objc func refreshAction()
        {
            if checkInternetConnectivity()
            {
                BL_PrepareMyDevice.sharedInstance.getAccompanists(masterDataGroupName: EMPTY) {(status) in
                    if status == SERVER_SUCCESS_CODE
                        {
                            let apiModel = BL_TPStepper.sharedInstance.getLastSyncDate(apiName: ApiName.Accompanists.rawValue)
                            let date = convertDateIntoString(date: apiModel.Download_Date)
                            let time = stringFromDate(date1: apiModel.Download_Date)
                            self.refreshDate = "\(date) \(time)"
                            self.lastRefreshTimeLbl.text = self.refreshDate
                            AlertView.showAlertView(title: "SUCCESS", message: "\(PEV_ACCOMPANIST) data are downloaded successfully")
                        }
                    else
                        {
                            AlertView.showServerSideError()
                        }
                        }
               getProductList()
            }
            else
                {
                    AlertView.showNoInternetAlert()
                }
            }
        
        
        //MARK:- Functions To UpdateLastSyncedTime
        func updateRefreshTimeAndDate()
        {
            let apiModel = BL_TPStepper.sharedInstance.getLastSyncDate(apiName: ApiName.Accompanists.rawValue)
            if apiModel != nil
                {
                    let date = convertDateIntoString(date: apiModel.Download_Date)
                    let time = stringFromDate(date1: apiModel.Download_Date)
                    refreshDate = "\(date) \(time)"
                    self.lastRefreshTimeLbl.text = refreshDate
                }
            else
                {
                    self.lastRefreshTimeLbl.isHidden = true
                }
        }
        
//        //MARK:- Accompanist Save,Update and Delete Functions
//        
//        func accompanistSaveAction(accArray: NSMutableArray)
//        {
//            BL_TPStepper.sharedInstance.insertAccompanistData(accArray: accArray)
//        }
//        //MARK:-TPheader insertion
//        
//        func insertTPheaderDetails(date: String,tpFlag: Int)
//        {
//         BL_TPStepper.sharedInstance.insertTPheaderDetails(Date: date, tpFlag: tpFlag)
//        }
//        
//        //MARK:- Get userSelectedAccompanists
//        func getSelectedAccompanists() -> [UserMasterModel]
//        {
//            selectedAccompanistList = BL_TPStepper.sharedInstance.getSelectedAccompanists(tp_Entry_Id: TPModel.sharedInstance.tpEntryId)
//            for model in selectedAccompanistList
//            {
//                let selectedModel = UserMasterModel()
//                selectedModel.User_Code = model.User_Code
//                selectedModel.Region_Code = model.Acc_Region_Code
//                selectedModel.User_Name = model.Acc_User_Name
//                selectedModel.User_Type_Name = model.Acc_User_Type_Name
//                selectedModel.Employee_name = model.Acc_Employee_Name
//                selectedModel.Region_Name = model.Acc_Region_Name
//                userSelectedList.append(selectedModel)
//            }
//            return userSelectedList
//        }

        
        
        
    }


class TempUserMasterModel : NSObject{
    
    var userName = ""
    var subTitle = ""
    var place = ""
    var userCode : String!
}
