//
//  DPMCustomerProductListController.swift
//  HiDoctorApp
//
//  Created by Swaas on 28/12/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class DPMCustomerProductListController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    @IBOutlet weak var searchBar : UISearchBar!
    
    var selectedRegionCode: String!
    var mappingRegionCode: String!
    var selectedType:String!
    var selectedMode: String!
    var customerToProd = "Partner product mapping"
    var productToCust = "Product partner mapping"
    var customerList: [CustomerMasterModel] = []
    var detailedProductList: [DetailProductMaster] = []
    var selectedMCValue: MCAllDetailsModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 500
        self.tableView.contentOffset = CGPoint(x: 0.0, y: self.searchBar.frame.size.height - self.tableView.contentOffset.y);
        searchBar.delegate = self
        
        // Do any additional setup after loading the view.
    }
        
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.contentOffset = CGPoint(x: 0, y: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setDafaults()
    }
    
    func setDafaults()
    {
        if customerToProd == selectedMode
        {
            if selectedType == Constants.Doctor_Product_Mapping_Ref_Types.Marketing_Campaign
            {
                customerList =  BL_DoctorProductMapping.sharedInstance.getDPMMarketingCampaignCustomerList(mappedRegionCode: mappingRegionCode, regionCode: selectedRegionCode, refType: selectedType, mcCode: selectedMCValue.Campaign_Code)
               
                
            }
            else
            {
                customerList =  BL_DoctorProductMapping.sharedInstance.getDPMCustomerList(regionCode: mappingRegionCode, refType: selectedType,selectedRegionCode: selectedRegionCode)
            }
            
            if customerList.count > 0
            {
                self.tableView.isHidden = false
                self.emptyStateLbl.isHidden = true
                self.tableView.reloadData()
                self.searchBar.isHidden = false
            }
            else
            {
                self.emptyStateLbl.isHidden = false
                self.tableView.isHidden = true
                 self.searchBar.isHidden = true
            }
            BL_DoctorProductMapping.sharedInstance.customerList = self.customerList
        }
        else
        {
            if selectedType == Constants.Doctor_Product_Mapping_Ref_Types.Marketing_Campaign
            {
                detailedProductList = BL_DoctorProductMapping.sharedInstance.getDPMMarketingCampaignProductList(mappedRegionCode: mappingRegionCode, regionCode: selectedRegionCode, refType: selectedType, mcCode: selectedMCValue.Campaign_Code)
            }
            else
            {
                detailedProductList = BL_DoctorProductMapping.sharedInstance.getDPMProductList(mappedRegionCode: mappingRegionCode, refType: selectedType, customerRegionCode: selectedRegionCode)
            }
            
            if detailedProductList.count > 0
            {
                self.tableView.isHidden = false
                self.emptyStateLbl.isHidden = true
                self.tableView.reloadData()
                 self.searchBar.isHidden = false
            }
            else
            {
                self.emptyStateLbl.isHidden = false
                self.tableView.isHidden = true
                 self.searchBar.isHidden = true
            }
            BL_DoctorProductMapping.sharedInstance.detailedProductList = self.detailedProductList
        }
    }
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if customerToProd == selectedMode
        {
           return customerList.count
        }
        else
        {
          return detailedProductList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "DPMCusProList") as! DPMCusProListCell
        
        cell.viewButton.tag = indexPath.row
        cell.deleteButton.tag = indexPath.row
        if customerToProd == selectedMode
        {
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
            if customerObj.isViewEnable
            {
                cell.viewButton.isHidden = false
                cell.deleteButton.isHidden =  false
            }
            else
            {
                cell.viewButton.isHidden = true
                cell.deleteButton.isHidden =  true
            }
            
            cell.viewButton.addTarget(self, action: #selector(viewButAction(_:)), for: .touchUpInside)
            cell.deleteButton.addTarget(self, action: #selector(deleteAction(_:)), for: .touchUpInside)
        }
        else
        {
            let productObj = self.detailedProductList[indexPath.row]
            
            cell.title.text = productObj.Product_Name
            if productObj.isViewEnable
            {
                cell.viewButton.isHidden = false
                cell.deleteButton.isHidden =  false
            }
            else
            {
                cell.viewButton.isHidden = true
                cell.deleteButton.isHidden =  true
            }
            
            cell.viewButton.addTarget(self, action: #selector(viewButAction(_:)), for: .touchUpInside)
            cell.deleteButton.addTarget(self, action: #selector(deleteAction(_:)), for: .touchUpInside)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sb =  UIStoryboard(name: "NoticeBoardViewController", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "DPMMappingViewController") as! DPMMappingViewController
        vc.mappedRegionCode = self.mappingRegionCode
        vc.selectedRegionCode = self.selectedRegionCode
        vc.refType = selectedType
        
        if customerToProd == selectedMode
        {
            let customerObj = self.customerList[indexPath.row]
            vc.customerCode = customerObj.Customer_Code
            vc.customerName = customerObj.Customer_Name
            vc.isFromProduct = false
        }
        else
        {
            let productObj = self.detailedProductList[indexPath.row]
            vc.productCode = productObj.Product_Code
            vc.productName = productObj.Product_Name
            vc.isFromProduct = true
        }
        if selectedType == Constants.Doctor_Product_Mapping_Ref_Types.Marketing_Campaign
        {
            vc.mcCode = selectedMCValue.Campaign_Code
        }
        else
        {
            vc.mcCode = ""
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func viewButAction(_ sender: UIButton)
    {
        
        let sb = UIStoryboard(name: "NoticeBoardViewController", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "DMPMappedListController") as! DMPMappedListController
       
        vc.mappedRegionCode = self.mappingRegionCode
        vc.selectedRegionCode = self.selectedRegionCode
        vc.refType = selectedType
        if customerToProd == selectedMode
        {
            let customerObj = self.customerList[sender.tag]
            vc.customerCode = customerObj.Customer_Code
        }
        else
        {
            let productObj = self.detailedProductList[sender.tag]
            vc.productCode = productObj.Product_Code
            vc.isFromProduct = true
        }
        if selectedType == Constants.Doctor_Product_Mapping_Ref_Types.Marketing_Campaign
        {
            vc.mcCode = selectedMCValue.Campaign_Code
        }
        else
        {
            vc.mcCode = ""
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func deleteAction(_ sender: UIButton)
    {
        showCustomActivityIndicatorView(loadingText: "Loading...")
        var dict :[String:Any] = [:]
        var campaignCode = String()
        if selectedType == Constants.Doctor_Product_Mapping_Ref_Types.Marketing_Campaign
        {
            campaignCode = selectedMCValue.Campaign_Code
        }
        else
        {
            campaignCode = ""
        }
        if customerToProd == selectedMode
        {
            let customerObj = self.customerList[sender.tag]
            dict  = ["Campaign_Code":campaignCode,"CompanyCode":getCompanyCode(),"Current_Region_Code":getRegionCode(),"Customer_Code":customerObj.Customer_Code,"Mapped_Region_Code":mappingRegionCode,"Mapping_Type":selectedType,"Mode":"DOCTOR_PRODUCT","Selected_Region_Code":selectedRegionCode]
        }
        else
        {
            let productObj = self.detailedProductList[sender.tag]
            dict  = ["Campaign_Code":campaignCode,"CompanyCode":getCompanyCode(),"Current_Region_Code":getRegionCode(),"Customer_Code":"","Mapped_Region_Code":mappingRegionCode,"Mapping_Type":selectedType,"Mode":"PRODUCT_DOCTOR","Selected_Region_Code":selectedRegionCode,"Product_Code":productObj.Product_Code]
        }
        
        BL_DoctorProductMapping.sharedInstance.deleteDoctorProductMapping(postData: dict) { (apiObj) in
            if apiObj.Status == SERVER_SUCCESS_CODE
            {
                
                BL_PrepareMyDeviceAccompanist.sharedInstance.beginDownloadFromMasterDataDownload()
                BL_PrepareMyDevice.sharedInstance.getDoctorProductMapping(masterDataGroupName: EMPTY, selectedRegionCode: EMPTY, completion: { (status) in
                    if status == SERVER_SUCCESS_CODE
                    {
                        self.setDafaults()
                        removeCustomActivityView()
                        AlertView.showAlertView(title: alertTitle, message: "Deleted Successfully", viewController: self)
                    }
                })
            }
            else
            {
                removeCustomActivityView()
                AlertView.showAlertView(title: alertTitle, message: "Problem while delete", viewController: self)
            }
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
        self.setDafaults()
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
            self.emptyStateLbl.text = ""
            self.setDafaults()
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func sortCurrentList(searchText:String)
    {
        if customerToProd == selectedMode
        {
            let filteredData = BL_DoctorProductMapping.sharedInstance.customerList.filter {
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
                self.emptyStateLbl.text = ""
                self.tableView.isHidden = false
                tableView.reloadData()
            }
            else
            {
                self.emptyStateLbl.text = "No list found"
                self.tableView.isHidden = false
                self.tableView.isHidden = true
            }
        }
        else
        {
            let filteredData = BL_DoctorProductMapping.sharedInstance.detailedProductList.filter {
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
                self.emptyStateLbl.text = ""
                self.tableView.isHidden = false
                tableView.reloadData()
            }
            else
            {
                self.emptyStateLbl.text = "No list found"
                self.tableView.isHidden = true
            }
        }
    }
}
