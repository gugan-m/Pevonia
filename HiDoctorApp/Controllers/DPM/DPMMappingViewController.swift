//
//  DPMMappingViewController.swift
//  HiDoctorApp
//
//  Created by Swaas on 03/01/19.
//  Copyright © 2019 swaas. All rights reserved.
//

import UIKit

class DPMMappingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UISearchBarDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar : UISearchBar!
    @IBOutlet weak var emptyState: UILabel!
    
    
    
    
    var mappedRegionCode: String!
    var selectedRegionCode: String!
    var refType: String!
    var productCode: String!
    var customerCode: String!
    var productName: String!
    var customerName: String!
    var mcCode: String!
    var isFromProduct:Bool = false
    var customerList: [CustomerMasterModel] = []
    var detailedProductList: [DetailProductMaster] = []
    var save : UIBarButtonItem!
    var selectAll: UIBarButtonItem!
    var isDeleteEnable: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 500
        self.setDefaults()
        self.addNavigationBarBut()
        self.tableView.contentOffset = CGPoint(x: 0.0, y: self.searchBar.frame.size.height - self.tableView.contentOffset.y);
        searchBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.contentOffset = CGPoint(x: 0, y: 0)
    }
    
    func setDefaults()
    {
        isDeleteEnable = false
        if isFromProduct
        {
            if refType == Constants.Doctor_Product_Mapping_Ref_Types.Marketing_Campaign
            {
                isDeleteEnable = true
                customerList = BL_DoctorProductMapping.sharedInstance.getMappingMarketingCustomerList(refType: refType, mappedRegion: mappedRegionCode, selectedRegion: selectedRegionCode, mcCode: mcCode, productCode: productCode)
            }
            else
            {
                customerList = BL_DoctorProductMapping.sharedInstance.getMappingCustomerList(mappedRegionCode: mappedRegionCode, refType: refType, selectedRegionCode: selectedRegionCode,productCode:productCode)
            }
        }
        else
        {
            if refType == Constants.Doctor_Product_Mapping_Ref_Types.Marketing_Campaign
            {
                detailedProductList = BL_DoctorProductMapping.sharedInstance.getMappingMarketingProductList(refType: refType, mappedRegion: mappedRegionCode, selectedRegion: selectedRegionCode, mcCode: mcCode, customerCode: customerCode)
            }
            else
            {
                detailedProductList = BL_DoctorProductMapping.sharedInstance.getMappingProductList(refType: refType, mappedRegion: mappedRegionCode, selectedRegion: selectedRegionCode, customerCode: customerCode)
            }
        }
        
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFromProduct
        {
            return customerList.count
        }
        else
        {
            return detailedProductList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isFromProduct
        {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "DPMMappingListCell") as! DPMMappingListCell
            let customerObj = self.customerList[indexPath.row]
            var displayStr = customerObj.Customer_Name + " | "
            if let custCategory = customerObj.Category_Name
            {
                displayStr += custCategory + " | "
            }
            if let custSpeciality = customerObj.Speciality_Name
            {
                displayStr += custSpeciality //+ " | "
            }
//            if let custMDL = customerObj.MDL_Number
//            {
//                displayStr += custMDL
//            }
            
            cell.title.text = displayStr
            cell.selectedImg.tintColor = UIColor.blue
            if customerObj.isViewEnable
            {
                if isDeleteEnable
                {
                    cell.selectedImg.image = UIImage(named:"icon-close1")
                }
                else
                {
                    cell.selectedImg.image = UIImage(named:"icon-checkbox")
                }
            }
            else
            {
                cell.selectedImg.image = UIImage(named:"icon-checkbox-blank")
            }
            cell.selectedBut.tag = indexPath.row
            cell.selectedBut.addTarget(self, action: #selector(changeState(_:)), for: .touchUpInside)
            
            cell.potentialTxt.tag = 2 * 1000 + indexPath.row
            cell.prescriptionTxt.tag = 1 * 1000 + indexPath.row
            cell.potentialTxt.delegate = self
            cell.prescriptionTxt.delegate = self
            
//            cell.prescriptionTxt.addTarget(self, action: #selector(noOfPrescription(_:)), for: .editingDidEnd)
//            cell.potentialTxt.addTarget(self, action: #selector(potentialPrescription(_:)), for: .editingDidEnd)
            cell.potentialTxt.text = customerObj.potentialPrescription
            cell.prescriptionTxt.text = customerObj.noOfPrescription
            return cell
            
        }
        else
        {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "DPMMappingListCellOne") as! DPMMappingListCell
            if self.detailedProductList.count > 0
            {
                let productObj = self.detailedProductList[indexPath.row]
                
                cell.title.text = productObj.Product_Name
                cell.selectedImg.tintColor = UIColor.blue
                if productObj.isViewEnable
                {
                    cell.selectedImg.image = UIImage(named:"icon-checkbox")
                }
                else
                {
                    cell.selectedImg.image = UIImage(named:"icon-checkbox-blank")
                }
                cell.selectedBut.tag = indexPath.row
                cell.selectedBut.addTarget(self, action: #selector(changeState(_:)), for: .touchUpInside)
                
                cell.priorityTxt.tag = 3 * 1000 + indexPath.row
                cell.potentialTxt.tag = 2 * 1000 + indexPath.row
                cell.prescriptionTxt.tag = 1 * 1000 + indexPath.row
                cell.potentialTxt.delegate = self
                cell.priorityTxt.delegate = self
                cell.prescriptionTxt.delegate = self
                
//                cell.prescriptionTxt.addTarget(self, action: #selector(noOfPrescription(_:)), for: .editingDidEnd)
//                cell.prescriptionTxt.addTarget(self, action: #selector(textFieldRespond(_:)), for: .editingDidBegin)
//                cell.potentialTxt.addTarget(self, action: #selector(textFieldRespond(_:)), for: .editingDidBegin)
//                cell.priorityTxt.addTarget(self, action: #selector(textFieldRespond(_:)), for: .editingDidBegin)
//                cell.potentialTxt.addTarget(self, action: #selector(potentialPrescription(_:)), for: .editingDidEnd)
//                cell.priorityTxt.addTarget(self, action: #selector(priorityNo(_:)), for: .editingDidEnd)
                cell.potentialTxt.text = productObj.potentialPrescription
                cell.prescriptionTxt.text = productObj.noOfPrescription
                if productObj.priorityOrder == 0 {
                    cell.priorityTxt.text = ""
                }else{
                    cell.priorityTxt.text = "\(productObj.priorityOrder)"
                }
                
                return cell
            }
            else
            {
                return UITableViewCell()
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let section = textField.tag/1000
        let row = textField.tag%1000
        
        
        if section == 3
        {
            if !isFromProduct
            {
                let productObj = self.detailedProductList[row]
                if let str = textField.text
                {
                    productObj.priorityOrder = Int(str) ?? 0
                }
                else
                {
                    productObj.priorityOrder = Int(0)
                }
            }
            let indexPath = IndexPath(row: row, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .none)
            
            for obj in self.detailedProductList
            {
                if obj.priorityOrder != 0 && obj.priorityOrder != productDefaultPriorityOrder
                {
                    let filteredValue = self.detailedProductList.filter{
                        $0.priorityOrder == obj.priorityOrder
                    }
                    if filteredValue.count > 1
                    {
                        let productObj = self.detailedProductList[row]
                        productObj.priorityOrder = Int(0)
                        AlertView.showAlertView(title: alertTitle, message: "Priority order value should not be same", viewController: self)
                        self.tableView.reloadRows(at: [indexPath], with: .none)

                    }
                }
            }
        }
        else if section == 1
        {
            
            if !isFromProduct
            {
                let productObj = self.detailedProductList[row]
                if let str = textField.text
                {
                    productObj.noOfPrescription = str
                }
                else
                {
                    productObj.noOfPrescription = EMPTY
                }
            }
            else
            {
                let customerObj = self.customerList[row]
                if let str = textField.text
                {
                    customerObj.noOfPrescription = str
                }
                else
                {
                    customerObj.noOfPrescription = EMPTY
                }
            }
            let indexPath = IndexPath(row: row, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        else if section == 2
        {
            if !isFromProduct
            {
                let productObj = self.detailedProductList[row]
                if let str = textField.text
                {
                    productObj.potentialPrescription = str
                }
                else
                {
                    productObj.potentialPrescription = EMPTY
                }
            }
            else
            {
                let customerObj = self.customerList[row]
                if let str = textField.text
                {
                    customerObj.potentialPrescription = str
                }
                else
                {
                    customerObj.potentialPrescription = EMPTY
                }
            }
            let indexPath = IndexPath(row: row, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        
    }
    @objc func changeState(_ sender: UIButton)
    {
        if isFromProduct
        {
            let customerObj = self.customerList[sender.tag]
            if customerObj.isViewEnable && isDeleteEnable
            {
                let dict = ["Campaign_Code":mcCode,"CompanyCode":getCompanyCode(),"Current_Region_Code":"","Customer_Code":customerObj.Customer_Code,"Mapped_Region_Code":mappedRegionCode,"Mapping_Type":"MARKETING_CAMPAIGN","Mode":"PRODUCT_DOCTOR","Product_Code":productCode,"Selected_Region_Code":selectedRegionCode]
                
                self.deleteCustomer(postData: dict as [String : Any])
            }
            else if !customerObj.isViewEnable && isDeleteEnable
            {
                if let campaignValue = BL_DoctorProductMapping.sharedInstance.campaignData
                {
                    if campaignValue.Campaign_Based_On == "Region" && campaignValue.Customer_Selection == "R"
                    {
                       let customerData = DBHelper.sharedInstance.getMappedCampaignCustomerList(refType: "MARKETING_CAMPAIGN", mappedRegion: mappedRegionCode, selectedRegion: selectedRegionCode, mcCode: mcCode)
                        let filteredValue :[CustomerMasterModel] = self.customerList.filter{
                            $0.isViewEnable == true
                        }
                        let totalValue = filteredValue.count + customerData.count
                        if campaignValue.Customer_Count < totalValue
                        {
                            //show alert
                            AlertView.showAlertView(title: alertTitle, message: "Maximum you have to select \(campaignValue.Customer_Count!)", viewController: self)
                        }
                        else
                        {
                           customerObj.isViewEnable.toggle()
                        }
                    }
                    else if campaignValue.Campaign_Based_On == "Role" && campaignValue.Customer_Selection == "R"
                    {
                        let customerData = DBHelper.sharedInstance.getMappedRoleCampaignCustomerList(refType: "MARKETING_CAMPAIGN", mappedRegion: mappedRegionCode, mcCode: mcCode)
                        //getMappedRoleCampaignCustomerList
                        let filteredValue :[CustomerMasterModel] = self.customerList.filter{
                            $0.isViewEnable == true
                        }
                        let totalValue = filteredValue.count + customerData.count
                        if campaignValue.Customer_Count < totalValue
                        {
                            //show alert
                            AlertView.showAlertView(title: alertTitle, message: "Maximum you have to select \(campaignValue.Customer_Count!)", viewController: self)
                        }
                        else
                        {
                            customerObj.isViewEnable.toggle()
                        }
                    }
                    else
                    {
                        customerObj.isViewEnable.toggle()
                    }
                }
            }
            else
            {
                customerObj.isViewEnable.toggle()
                
            }
            let filteredValue :[CustomerMasterModel] = self.customerList.filter{
                $0.isViewEnable == true
            }
            
            if filteredValue.count > 0
            {
                self.navigationItem.rightBarButtonItems = [save,selectAll]
            }
            else
            {
                self.navigationItem.rightBarButtonItems = [selectAll]
            }
        }
        else
        {
            let productObj = self.detailedProductList[sender.tag]
            productObj.isViewEnable.toggle()
            
            let filteredValue :[DetailProductMaster] = self.detailedProductList.filter{
                $0.isViewEnable == true
            }
            
            if filteredValue.count > 0
            {
                self.navigationItem.rightBarButtonItems = [save,selectAll]
            }
            else
            {
                self.navigationItem.rightBarButtonItems = [selectAll]
            }
        }
        let indexPath = IndexPath(row: sender.tag, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: .none)
        
    }

    
    func saveDPMCustomerToProduct()
    {
        
        //showCustomActivityIndicatorView(loadingText: "Loading...")
        let filteredList: [DetailProductMaster] = self.detailedProductList.filter{
            $0.isViewEnable == true
        }
        
        let productArray = NSMutableArray()
        
        for obj in filteredList
        {
            let dict = ["Potential_Quantity":obj.potentialPrescription,"Product_Code":obj.Product_Code,"Product_Name":obj.Product_Name ,"Support_Quantity":obj.noOfPrescription,"Product_Priority_No":obj.priorityOrder] as [String : Any]
            
            productArray.add(dict)
        }
        
            
        let dict: [String:Any] = ["Created_By":getUserName(),"Current_Region_Code":getRegionCode(),"Customer_Category_Code":"","Customer_Code":customerCode,"Customer_Name":customerName,"Mapped_Region_Code":mappedRegionCode,"Mapping_Type":refType,"RefType":"DOCTOR_PRODUCT","Selected_Region_Code":selectedRegionCode,"lstMappedDPMProducts":productArray]
        
        WebServiceHelper.sharedInstance.saveDPMCustomerMapping(postData: dict) { (apiObj) in
           
            if apiObj.Status ==  SERVER_SUCCESS_CODE
            {
                BL_PrepareMyDeviceAccompanist.sharedInstance.beginDownloadFromMasterDataDownload()
                BL_PrepareMyDevice.sharedInstance.getDoctorProductMapping(masterDataGroupName: EMPTY, selectedRegionCode: EMPTY, completion: { (status) in
                    if status == SERVER_SUCCESS_CODE
                    {
                        removeCustomActivityView()
                        let alertViewController = UIAlertController(title: infoTitle, message: "Mapped Successfully", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
                            
                            _ = self.navigationController?.popViewController(animated: true)
                        }))
                        
                        
                        self.present(alertViewController, animated: true, completion: nil)
                    }
                })

            }
            else
            {
                removeCustomActivityView()
                AlertView.showAlertView(title: alertTitle, message: "Problem while saving data", viewController: self)
            }
        }
    
    }
    
    func saveDPMProductToCustomer()
    {
        
        showCustomActivityIndicatorView(loadingText: "Loading...")
        let filteredList: [CustomerMasterModel] = self.customerList.filter{
            $0.isViewEnable == true
        }
        
        
        let customerList =  NSMutableArray()
        for obj in filteredList
        {
            let dict = ["Customer_Category_Code":obj.Category_Code ?? EMPTY,"Customer_Code":obj.Customer_Code,"Customer_Name":obj.Customer_Name ,"Support_Quantity":obj.noOfPrescription,"Potential_Quantity":obj.potentialPrescription] as [String : Any]
            
            customerList.add(dict)
        }
        
        
        
        let dict: [String:Any] = ["Created_By":getUserName(),"Current_Region_Code":getRegionCode(),"Product_Code":productCode,"Product_Name":productName,"Mapped_Region_Code":mappedRegionCode,"Mapping_Type":refType,"RefType":"PRODUCT_DOCTOR","Selected_Region_Code":selectedRegionCode,"lstMappedDoctors":customerList]
        
        WebServiceHelper.sharedInstance.saveDPMProductMapping(postData: dict) { (apiObj) in
            
            if apiObj.Status ==  SERVER_SUCCESS_CODE
            {
                BL_PrepareMyDeviceAccompanist.sharedInstance.beginDownloadFromMasterDataDownload()
                BL_PrepareMyDevice.sharedInstance.getDoctorProductMapping(masterDataGroupName: EMPTY, selectedRegionCode: EMPTY, completion: { (status) in
                    if status == SERVER_SUCCESS_CODE
                    {
                        removeCustomActivityView()
                        let alertViewController = UIAlertController(title: infoTitle, message: "Mapped Successfully", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
                            
                            _ = self.navigationController?.popViewController(animated: true)
                        }))
                        
                        
                        self.present(alertViewController, animated: true, completion: nil)
                    }
                })
                
            }
            else
            {
                removeCustomActivityView()
                AlertView.showAlertView(title: alertTitle, message: "Problem while saving data", viewController: self)
            }
        }
        
    }
    
    func saveDPMCampaignCustomerToProduct()
    {
        //showCustomActivityIndicatorView(loadingText: "Loading...")
        let filteredList: [DetailProductMaster] = self.detailedProductList.filter{
            $0.isViewEnable == true
        }
        
        let productArray = NSMutableArray()
        
        for obj in filteredList
        {
            let dict = ["Potential_Quantity":obj.potentialPrescription,"Product_Code":obj.Product_Code,"Product_Name":obj.Product_Name ,"Support_Quantity":obj.noOfPrescription,"Product_Priority_No":obj.priorityOrder] as [String : Any]
            
            productArray.add(dict)
        }
        
        
        let dict: [String:Any] = ["Campaign_Code":mcCode,"Created_By":getUserName(),"Current_Region_Code":getRegionCode(),"Customer_Category_Code":"","Customer_Code":customerCode,"Customer_Name":customerName,"Mapped_Region_Code":mappedRegionCode,"Mapping_Type":refType,"RefType":"DOCTOR_PRODUCT","Selected_Region_Code":selectedRegionCode,"lstMappedDPMProducts":productArray]
        
        WebServiceHelper.sharedInstance.saveDPMCampaignCustomerMapping(postData: dict) { (apiObj) in
            
            if apiObj.Status ==  SERVER_SUCCESS_CODE
            {
                BL_PrepareMyDeviceAccompanist.sharedInstance.beginDownloadFromMasterDataDownload()
                BL_PrepareMyDevice.sharedInstance.getDoctorProductMapping(masterDataGroupName: EMPTY, selectedRegionCode: EMPTY, completion: { (status) in
                    if status == SERVER_SUCCESS_CODE
                    {
                        removeCustomActivityView()
                        let alertViewController = UIAlertController(title: infoTitle, message: "Mapped Successfully", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
                            
                            _ = self.navigationController?.popViewController(animated: true)
                        }))
                        
                        
                        self.present(alertViewController, animated: true, completion: nil)
                    }
                })
                
            }
            else
            {
                removeCustomActivityView()
                AlertView.showAlertView(title: alertTitle, message: "Problem while saving data", viewController: self)
            }
        }
    }
    
    func saveDPMCampaignProductToCustomer()
    {
        showCustomActivityIndicatorView(loadingText: "Loading...")
        let filteredList: [CustomerMasterModel] = self.customerList.filter{
            $0.isViewEnable == true
        }
        
        
        let customerList =  NSMutableArray()
        for obj in filteredList
        {
            let dict = ["Customer_Category_Code":obj.Category_Code ?? EMPTY,"Customer_Code":obj.Customer_Code,"Customer_Name":obj.Customer_Name ,"Support_Quantity":obj.noOfPrescription,"Potential_Quantity":obj.potentialPrescription] as [String : Any]
            
            customerList.add(dict)
        }
        
        
        
        let dict: [String:Any] = ["Campaign_Code":mcCode,"Created_By":getUserName(),"Current_Region_Code":getRegionCode(),"Product_Code":productCode,"Product_Name":productName,"Mapped_Region_Code":mappedRegionCode,"Mapping_Type":refType,"RefType":"PRODUCT_DOCTOR","Selected_Region_Code":selectedRegionCode,"lstMappedDoctors":customerList]
        
        WebServiceHelper.sharedInstance.saveDPMCampaignProductMapping(postData: dict) { (apiObj) in
            
            if apiObj.Status ==  SERVER_SUCCESS_CODE
            {
                BL_PrepareMyDeviceAccompanist.sharedInstance.beginDownloadFromMasterDataDownload()
                BL_PrepareMyDevice.sharedInstance.getDoctorProductMapping(masterDataGroupName: EMPTY, selectedRegionCode: EMPTY, completion: { (status) in
                    if status == SERVER_SUCCESS_CODE
                    {
                        removeCustomActivityView()
                        let alertViewController = UIAlertController(title: infoTitle, message: "Mapped Successfully", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
                            
                            _ = self.navigationController?.popViewController(animated: true)
                        }))
                        
                        
                        self.present(alertViewController, animated: true, completion: nil)
                        
                    }
                })
            }
            else
            {
                removeCustomActivityView()
                AlertView.showAlertView(title: alertTitle, message: "Problem while saving data", viewController: self)
            }
        }
        
    }
    
    func deleteCustomer(postData:[String:Any])
    {
        showCustomActivityIndicatorView(loadingText: "Loading...")
        WebServiceHelper.sharedInstance.deleteDPMCampaignCustomer(postData: postData) { (apiResponse) in
            if apiResponse.Status ==  SERVER_SUCCESS_CODE
            {
                BL_PrepareMyDeviceAccompanist.sharedInstance.beginDownloadFromMasterDataDownload()
                BL_PrepareMyDevice.sharedInstance.getDoctorProductMapping(masterDataGroupName: EMPTY, selectedRegionCode: EMPTY, completion: { (status) in
                    if status == SERVER_SUCCESS_CODE
                    {
                        removeCustomActivityView()
                         _ = self.navigationController?.popViewController(animated: true)
                        
                    }
                })
            }
            
        }
    }
    
    func addNavigationBarBut()
    {
        selectAll = UIBarButtonItem(title: "Select All", style: .plain, target: self, action: #selector(selectAllAction))
        save = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveAction))
        self.navigationItem.rightBarButtonItems = [selectAll]
    }
    
    @objc func saveAction()
    {
        if !isFromProduct
        {
            if refType == Constants.Doctor_Product_Mapping_Ref_Types.Marketing_Campaign
            {
                self.saveDPMCampaignCustomerToProduct()
            }
            else
            {
                self.saveDPMCustomerToProduct()
            }
        }
        else
        {
            if refType == Constants.Doctor_Product_Mapping_Ref_Types.Marketing_Campaign
            {
                self.saveDPMCampaignProductToCustomer()
            }
            else
            {
                self.saveDPMProductToCustomer()
            }
        }
    }
    
    @objc func selectAllAction()
    {
        if !isFromProduct
        {
            for obj in self.detailedProductList
            {
                if selectAll.title == "Select All"
                {
                    obj.isViewEnable = true
                }
                else
                {
                    obj.isViewEnable = false
                }
            }
            
            self.tableView.reloadData()
        }
        else
        {
            for obj in self.customerList
            {
                if selectAll.title == "Select All"
                {
                    obj.isViewEnable = true
                    
                }
                else
                {
                    obj.isViewEnable = false
                }
            }
            
            
            self.tableView.reloadData()
        }
        
        if selectAll.title == "Select All"
        {
            self.navigationItem.rightBarButtonItems = [save,selectAll]
           selectAll.title = "Deselect All"
        }
        else
        {
            self.navigationItem.rightBarButtonItems = [selectAll]
            selectAll.title = "Select All"
        }
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
        self.setDefaults()
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
            
            self.tableView.isHidden = false
            self.emptyState.text = ""
            self.setDefaults()
            
        }
        tableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func sortCurrentList(searchText:String)
    {
        self.setDefaults()
        if isFromProduct
        {
            let filteredData = self.customerList.filter {
                (obj) -> Bool in
                let lowerCaseText = searchText.lowercased()
                let empName  = (obj.Customer_Name).lowercased()
                if (empName.contains(lowerCaseText))
                {
                    return true
                }
                
                return false
            }
            self.customerList = filteredData
            if customerList.count > 0
            {
                self.emptyState.text = ""
                self.tableView.isHidden = false
                tableView.reloadData()
            }
            else
            {
                self.emptyState.text = "No list found"
                self.tableView.isHidden = false
                self.tableView.isHidden = true
            }
        }
        else
        {
            let filteredData = self.detailedProductList.filter {
                (obj) -> Bool in
                let lowerCaseText = searchText.lowercased()
                let empName  = (obj.Product_Name).lowercased()
                if (empName.contains(lowerCaseText))
                {
                    return true
                }
                
                return false
            }
            self.detailedProductList = filteredData
            if detailedProductList.count > 0
            {
                self.emptyState.text = ""
                self.tableView.isHidden = false
                tableView.reloadData()
            }
            else
            {
                self.emptyState.text = "No list found"
                self.tableView.isHidden = false
                self.tableView.isHidden = true
            }
            
        }
       
        
        
    }
}
