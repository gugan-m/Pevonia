//
//  ApproveErrorTypeOneController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 16/02/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class ApproveErrorTypeOneController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var errorLabel : UILabel!
    @IBOutlet weak var buttonViewHeightContstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var cancelButt: UIButton!
    @IBOutlet weak var unLockButt: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var emptyStateTitleLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    var approvalUserObj: ApprovalUserMasterModel!
    var approveErrorList : [ApproveErrorTypeOne] = []
    var approveErrorSearchList = [ApproveErrorTypeOne]()
    var errorMessage = String()
    var isFromMC = Bool()
    var editMode: Bool = false
    var approveErrorListref : [ApproveErrorTypeOne] = []
    var doctorApprovalData: [DoctorApprovalModelDict] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: Constants.NibNames.CommonSelectCell, bundle: nil), forCellReuseIdentifier: "LockReleaseCell")
        errorLabel.text = errorMessage
        tableView.estimatedRowHeight = 500
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.searchView.isHidden = true
        self.searchViewHeightConst.constant = 0
        approveErrorListref = approveErrorList
        if(approveErrorListref.count>0)
        {
            emptyStateView.isHidden = true
            mainView.isHidden = false
        }
        else
        {
            emptyStateView.isHidden = false
            mainView.isHidden = true
        }
        if(isFromMC)
        {
            self.addSelectBut()
            self.searchView.isHidden = false
            self.searchViewHeightConst.constant = 40
            cancelButt.setTitle("Exclude Selected", for: .normal)
            unLockButt.setTitle("Reject All", for: .normal)
            cancelButt.isHidden = true
            //editMode = true
        }
        removeVersionToastView()
        doInitialSetup()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func doInitialSetup()
    {
        addBackButtonView()
        hideButtonView()
    }
    
    //MARK:-- Nav Bar Button Functions
//    private func addBackButtonView()
//    {
//        let backButton = UIButton(type: UIButtonType.custom)
//        
//        backButton.addTarget(self, action: #selector(self.backButtonAction), for: UIControlEvents.touchUpInside)
//        backButton.setImage(UIImage(named: "navigation-arrow"), for: .normal)
//        backButton.sizeToFit()
//        
//        let backButtonItem = UIBarButtonItem(customView: backButton)
//        
//        self.navigationItem.leftBarButtonItem = backButtonItem
//    }
//    
//    @objc func backButtonAction()
//    {
//        _ = navigationController?.popViewController(animated: false)
//    }
//    
    private func hideButtonView()
    {
        if(isFromMC)
        {
            buttonViewHeightContstraint.constant = 45
            buttonView.isHidden = false
        }
        else
        {
            buttonViewHeightContstraint.constant = 0
            buttonView.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return approveErrorListref.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LockReleaseCell1") as! LockReleaseTableViewCell
        let objdoctorData = approveErrorListref[indexPath.row]
      
        cell.lockDateLabel.text = objdoctorData.Customer_Name
        
        cell.actualDateLabel.text = getDoctorDetails(objdoctorData:objdoctorData)
        if (!editMode)
        {
            cell.selectionViewWidthConstraint.constant = 0
            cell.selectionView.isHidden = true
        }
        else
        {
            cell.selectionViewWidthConstraint.constant = 40
            cell.selectionView.isHidden = false
        }
        if (objdoctorData.isSelected)
        {
            cell.selectionImageView.image = UIImage(named: "icon-check")
        }
        else
        {
            cell.selectionImageView.image = UIImage(named: "icon-uncheck")
        }
        
        cell.selectionStyle = .none
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        var rowHeight : CGFloat = 0
        let objdoctorData = approveErrorListref[indexPath.row]
        
        let customerNameTextHeight = getTextSize(text: objdoctorData.Customer_Name, fontName: fontRegular, fontSize: 16, constrainedWidth: SCREEN_WIDTH - 56).height
        
        let customerDetailTextHeight = getTextSize(text: getDoctorDetails(objdoctorData:objdoctorData), fontName: fontRegular, fontSize: 16, constrainedWidth: SCREEN_WIDTH - 56).height
        
        rowHeight += customerNameTextHeight + customerDetailTextHeight + 10
        return rowHeight
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(isFromMC)
        {
           
            if (editMode)
            {
                approveErrorListref[indexPath.row].isSelected = !approveErrorListref[indexPath.row].isSelected
                tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                
                addSelectAllButton()
                
                var selectedCount: Int = 0
                for dict in approveErrorListref
                {
                    
                    if(dict.isSelected)
                    {
                        selectedCount += 1
                        
                    }
                    if (selectedCount > 0)
                    {
                        cancelButt.isHidden = false
                        break
                    }
                    else
                    {
                        cancelButt.isHidden = true
                    }
                }
            }
        }
    }
    
    func getDoctorDetails(objdoctorData:ApproveErrorTypeOne) -> String
    {
        
        var MDLNum = String()
        var specialityName = String()
        var categoryNamwe = String()
        var campaginName = String()
        var HospitalName = String()
        if let mdlNum = objdoctorData.MDL_Number
        {
            MDLNum = mdlNum
        }
        
        if let Hospital = objdoctorData.Hospital_Name
        {
            if HospitalName != EMPTY
            {
                HospitalName = "|\(Hospital)"
            }
            else
            {
                HospitalName = "\(Hospital)"
            }
        }
        
        if let speciality = objdoctorData.Speciality_Name
        {
            if MDLNum != EMPTY
            {
                specialityName = "|\(speciality)"
            }
            else
            {
                specialityName = "\(speciality)"
            }
        }
        
        if let category = objdoctorData.Category_Name
        {
            if specialityName != EMPTY
            {
                categoryNamwe = "|\(category)"
            }
            else
            {
                categoryNamwe = "\(category)"
            }
        }
        if(isFromMC)
        {
            if let campaign = objdoctorData.Campaign_Name
            {
                if categoryNamwe != EMPTY
                {
                    campaginName = "|\(campaign)"
                }
                else
                {
                    campaginName = "\(campaign)"
                }
            }
        }
         return MDLNum + HospitalName + specialityName + categoryNamwe + campaginName
    }
    
    
    //MARK:-Search Bar Delegate
    
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
        approveErrorListref = []
        approveErrorListref = approveErrorList
        emptyStateView.isHidden = true
        mainView.isHidden = false
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if (searchBar.text?.count)! > 0
        {
            sortCurrentList(searchText: searchBar.text!)
        }
        else if (searchBar.text?.count == 0 || searchText == EMPTY)
        {
            approveErrorListref = []
            approveErrorListref = approveErrorList
            tableView.reloadData()
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func sortCurrentList(searchText:String)
    {
        
        approveErrorSearchList = approveErrorList.filter {
            (obj) -> Bool in
            let lowerCaseText = searchText.lowercased()
            let empName  = (obj.Customer_Name).lowercased()
            let empCode = (obj.Customer_Code).lowercased()
            let speciality = (obj.Speciality_Name).lowercased()
            let category = (obj.Category_Name).lowercased()
            let mdlNum = (obj.MDL_Number).lowercased()
            if (empName.contains(lowerCaseText)) || (empCode.contains(lowerCaseText)) || (speciality.contains(lowerCaseText)) || (category.contains(lowerCaseText) || (mdlNum.contains(lowerCaseText)))
            {
                return true
            }
            self.searchView.isHidden = false
            return false
        }
        approveErrorListref = []
        approveErrorListref = approveErrorList
        tableView.reloadData()
        setEmptyStateTitle(message: "No \(appDoctor) found. Clear your search and try again.")
        if(approveErrorSearchList.count>0)
        {
            emptyStateView.isHidden = true
            mainView.isHidden = false
        }
        else
        {
            emptyStateView.isHidden = false
            mainView.isHidden = true
        }
        
    }
    //MARK:-- Label Title Functions
    private func setEmptyStateTitle(message: String)
    {
        emptyStateTitleLabel.text = message
    }
    
    @IBAction func cancelButtonAction()
    {
        //except selected doctor
        showCustomActivityIndicatorView(loadingText: "Loading...")
        var doctorData: [[String:String]] = []
        for doctorApproval in approveErrorList
        {
            if(doctorApproval.isSelected)
            {
                let dict: [String:String] = ["Customer_Code": doctorApproval.Customer_Code]
                doctorData.append(dict)
            }
        }
        
        for dict in doctorData
        {
            
            doctorApprovalData = doctorApprovalData.filter{
                $0.Customer_Code != dict["Customer_Code"]
            }
       
        }
        
        var doctorExculdeData: [[String:String]] = []
        for doctorApproval in doctorApprovalData
        {
              let dict: [String:String] = ["Customer_Code": doctorApproval.Customer_Code]
                doctorExculdeData.append(dict)
            }
        
      
        let postData : [String:Any] = ["lstCustomerCode":doctorExculdeData]
        self.rejectAndApprove(postData: postData)
        
    }
    
    func rejectAndApprove(postData: [String:Any])
    {
        WebServiceHelper.sharedInstance.doctorApproveReject(postData: postData, regionCode: approvalUserObj.Region_Code, customerStatus: 0, userConformation: 1){
            (apiResponseObj) in
            if (apiResponseObj.Status == SERVER_SUCCESS_CODE)
            {
                removeCustomActivityView()
                BL_MasterDataDownload.sharedInstance.downloadCustomerData(masterDataGroupName: "", completion: { (status) in
                    if(status == SERVER_SUCCESS_CODE)
                    {
                        self.showAlert()
                    }
                    else
                    {
                        self.showErrorAlert(apiResponseObj: apiResponseObj)
                    }
                })
                
            }
            else
            {
                removeCustomActivityView()
                self.showErrorAlert(apiResponseObj: apiResponseObj)
            }
        }
    }
    
    private func showErrorAlert(apiResponseObj: ApiResponseModel)
    {
        AlertView.showAlertView(title: "Error", message: apiResponseObj.Message)
    }
    
    @IBAction func unlockButtonAction()
    {
        showCustomActivityIndicatorView(loadingText: "Loading...")
        var doctorData: [[String:String]] = []
       
        for doctorApproval in doctorApprovalData
        {
            let dict: [String:String] = ["Customer_Code": doctorApproval.Customer_Code]
            doctorData.append(dict)
        }
       
        let postData : [String:Any] = ["lstCustomerCode":doctorData]
        self.rejectAndApprove(postData: postData)
    }
    func showAlert()
    {
        let alertViewController = UIAlertController (title: "Success", message: "Reject Successfully", preferredStyle: .alert)
        
        
        
        alertViewController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alertAction in
            let viewControllers = self.navigationController!.viewControllers as [UIViewController];
            
            for aViewController: UIViewController in viewControllers
            {
                if aViewController is ApprovalUserListViewController
                {
                    _ = self.navigationController?.popToViewController(aViewController, animated: true)
                    break
                }
            }
        }))
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertViewController, animated: true, completion: nil)
    }
    
    private  func addSelectBut()
    {
        self.navigationItem.rightBarButtonItem = nil
        
        let rightBarButton = UIButton(type: UIButtonType.custom)
        
        rightBarButton.addTarget(self, action: #selector(selectButtonAction), for: UIControlEvents.touchUpInside)
        rightBarButton.setTitle("Select", for: UIControlState.normal)
        rightBarButton.sizeToFit()
        
        let rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    private func addSelectAllButton()
    {
        self.navigationItem.rightBarButtonItem = nil
        
        let rightBarButton = UIButton(type: UIButtonType.custom)
        
        rightBarButton.addTarget(self, action: #selector(self.selectAllButtonAction), for: UIControlEvents.touchUpInside)
        rightBarButton.setTitle("Select All", for: UIControlState.normal)
        rightBarButton.sizeToFit()
        
        let rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    private func addDeselectAllButton()
    {
        self.navigationItem.rightBarButtonItem = nil
        
        let rightBarButton = UIButton(type: UIButtonType.custom)
        
        rightBarButton.addTarget(self, action: #selector(self.deSelectAllButtonAction), for: UIControlEvents.touchUpInside)
        rightBarButton.setTitle("Deselect All", for: UIControlState.normal)
        rightBarButton.sizeToFit()
        
        let rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func selectButtonAction()
    {
        setTableViewInEditMode()
    }
    
    @objc func selectAllButtonAction()
    {
        toggleSelection(select: true)
        setTableViewInEditMode()
        addDeselectAllButton()
    }
    
    @objc func deSelectAllButtonAction()
    {
        toggleSelection(select: false)
        setTableViewInEditMode()
        addSelectAllButton()
    }
    
    private func toggleSelection(select: Bool)
    {
        if(isFromMC)
        {
            for dict in approveErrorListref
            {
                
                dict.isSelected = select
            }
        }
        
        toggleButtonView()
    }
    
    private func toggleButtonView()
    {
        var selectedCount: Int = 0
        if(isFromMC)
        {
            for dict in approveErrorListref
            {
                
                if(dict.isSelected)
                {
                    selectedCount += 1
                    break
                }
                if (selectedCount > 0)
                {
                     cancelButt.isHidden = false
                    break
                }
                else
                {
                     cancelButt.isHidden = true
                }
            }
        }
        if (selectedCount > 0)
        {
            var selectedCount: Int = 0
            for dict in approveErrorListref
            {
                
                if(!dict.isSelected)
                {
                    selectedCount += 1
                }
            }
            if (selectedCount > 0)
            {
                cancelButt.isHidden = true
            }
            else
            {
                cancelButt.isHidden = false
            }
            showButtonView()
        }
        else
        {
            hideButtonView()
        }
    }
    
    private func showButtonView()
    {
        buttonViewHeightContstraint.constant = 45
        buttonView.isHidden = false
    }
    
    private func setTableViewInEditMode()
    {
        self.editMode = true
        addSelectAllButton()
        reloadTableView()
    }
    
    private func reloadTableView()
    {
        tableView.reloadData()
    }
    
}
