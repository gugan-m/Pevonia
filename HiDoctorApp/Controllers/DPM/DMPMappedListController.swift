//
//  DMPMappedListController.swift
//  HiDoctorApp
//
//  Created by Swaas on 31/12/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class DMPMappedListController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    
    var mappedList : [DoctorProductMappingModel] = []
    var isFromProduct:Bool = false
    var mappedRegionCode: String!
    var selectedRegionCode: String!
    var refType: String!
    var productCode: String!
    var customerCode: String!
    var mcCode: String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 500
        setDefaults()
        
        // Do any additional setup after loading the view.
    }
    
    
    func setDefaults()
    {
        if isFromProduct
        {
            if refType == Constants.Doctor_Product_Mapping_Ref_Types.Marketing_Campaign
            {
                mappedList = BL_DoctorProductMapping.sharedInstance.getMappedCampaignProductListUsingCampaignCode(refType: refType, mappedRegion: mappedRegionCode, selectedRegion: selectedRegionCode, mcCode: mcCode, productCode: productCode)
            }
            else
            {
                mappedList = BL_DoctorProductMapping.sharedInstance.getMappedProductList(refType: refType, mappedRegion: mappedRegionCode, selectedRegion: selectedRegionCode, productCode: productCode)
            }
            if mappedList.count > 0
            {
                self.titleLbl.text = "Product Name: \(mappedList[0].Product_Name!)"
                self.subTitleLbl.text = "No of \(appDoctor) Mapped: \(mappedList.count)"
            }
        }
        else
        {
            if refType == Constants.Doctor_Product_Mapping_Ref_Types.Marketing_Campaign
            {
                mappedList = BL_DoctorProductMapping.sharedInstance.getMappedCampaignCustomerListUsingCampaignCode(refType: refType, mappedRegion: mappedRegionCode, selectedRegion: selectedRegionCode, mcCode: mcCode, customerCode: customerCode)
            }
            else
            {
                mappedList = BL_DoctorProductMapping.sharedInstance.getMappedCustomerList(refType: refType, mappedRegion: mappedRegionCode, selectedRegion: selectedRegionCode, customerCode: customerCode)
            }
            if mappedList.count > 0
            {
                self.titleLbl.text = "\(appDoctor) Name: \(mappedList[0].Customer_Name!)"
                self.subTitleLbl.text = "No of Products Mapped: \(mappedList.count)"
            }
        }
        self.tableView.reloadData()
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mappedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "DPMMappedListCell") as! DPMMappedListCell
        if isFromProduct
        {
            let productObj = self.mappedList[indexPath.row]
            cell.titleOne.text = "\(appDoctor) Name: \(productObj.Customer_Name!)"
            cell.titleTwo.text = "MDL No: \(checkNullAndNilValueForString(stringData:productObj.MDL_Number))"
            cell.titleThree.text = "Prescriptions: \(checkNullAndNilValueForString(stringData:(productObj.Support_Quantity)))"
            cell.titleFour.text = "Potential Prescriptions: \(checkNullAndNilValueForString(stringData:(productObj.Potential_Quantity!)))"
            cell.titleFive.text = "Mapped By: \(productObj.Created_By!)"
        }
        else
        {
            let custObj = self.mappedList[indexPath.row]
            
            cell.titleOne.text = "Product Name: \(custObj.Product_Name!)"
            cell.titleTwo.text = "Prescriptions: \(checkNullAndNilValueForString(stringData:(custObj.Support_Quantity)))"
            
            cell.titleThree.text = "Potential Prescriptions: \(checkNullAndNilValueForString(stringData:(custObj.Potential_Quantity!)))"
            if  custObj.Priority_Order! == productDefaultPriorityOrder
            {
                cell.titleFour.text = "Priority No: 0"
            }
            else
            {
                cell.titleFour.text = "Priority No: \(custObj.Priority_Order!)"
                
            }
            cell.titleFive.text = "Mapped By: \(custObj.Created_By!)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    
    
}
