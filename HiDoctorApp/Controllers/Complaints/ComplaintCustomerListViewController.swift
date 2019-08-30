//
//  ComplaintCustomerListViewController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 17/05/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class ComplaintCustomerListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIScrollViewDelegate {


    var regionCode : String!
    var regionName : String!
    var doctorMasterList : [CustomerMasterModel] = []
    var tempDoctorMasterList : [CustomerMasterModel] = []
    var isFromComplaintTrack = Bool()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var searchBar : UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.tableView.tableFooterView = UIView()
        self.tableView.contentOffset =  CGPoint(x: 0.0, y: self.searchBar.frame.size.height - self.tableView.contentOffset.y);
        self.searchBar.delegate = self
        self.setDefaults()
        self.tableView.reloadData()
       // complaintCustomerDelegate?.setSelectedCustomerDetails(accompanistObj: [], isFromCc: true)
        // Do any additional setup after loading the view.
    }

   
    func setDefaults()
    {
        segmentView.setTitle("\(appDoctor)", forSegmentAt: 0)
        segmentView.setTitle("\(appChemist)", forSegmentAt: 1)
        segmentView.setTitle("\(appStockiest)", forSegmentAt: 2)
        segmentView.selectedSegmentIndex = 0
        
        doctorMasterList = BL_DCR_Doctor_Visit.sharedInstance.getDoctorMasterList(regionCode: regionCode)!
         tempDoctorMasterList = BL_DCR_Doctor_Visit.sharedInstance.getDoctorMasterList(regionCode: regionCode)!
        
        isShowEmptyState(masterList: doctorMasterList, title: appDoctor)
        
        
        
    }
    
    func isShowEmptyState(masterList:[CustomerMasterModel],title:String)
    {
        if(masterList.count > 0)
        {
            self.tableView.isHidden = false
            self.emptyStateLbl.text = ""
            self.tableView.reloadData()
        }
        else
        {
            self.tableView.isHidden = true
            self.emptyStateLbl.text = "No \(title) data available.Please download the data through manage Ride Along screen."
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctorMasterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CustomerComplaintCell") as! UITableViewCell
        
        let customerName = cell.viewWithTag(1) as! UILabel
        customerName.text = doctorMasterList[indexPath.row].Customer_Name
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(isFromComplaintTrack)
        {
            let sb = UIStoryboard(name: commonListSb, bundle: nil)
            let vc:ComplaintListViewController = sb.instantiateViewController(withIdentifier: ComplaintListViewControllerID) as! ComplaintListViewController
            //vc.regionCode = self.regionCode
             vc.regionCode = doctorMasterList[indexPath.row].Region_Code
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            BL_Customer_Complaint.sharedInstance.selectedCustomerDetail = doctorMasterList[indexPath.row]
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    @IBAction func segmentView(_ sender: UISegmentedControl) {
        
        if(sender.selectedSegmentIndex == 0)
        {
            doctorMasterList = BL_Customer_Complaint.sharedInstance.getCustomerMasterList(regionCode: regionCode,customerEntityType: DOCTOR)!
            tempDoctorMasterList = BL_Customer_Complaint.sharedInstance.getCustomerMasterList(regionCode: regionCode,customerEntityType: DOCTOR)!
                //BL_DCR_Doctor_Visit.sharedInstance.getDoctorMasterList(regionCode: regionCode)!
            isShowEmptyState(masterList: doctorMasterList, title: appDoctor)
        }
        else if(sender.selectedSegmentIndex == 1)
        {
            doctorMasterList = BL_Customer_Complaint.sharedInstance.getCustomerMasterList(regionCode: regionCode,customerEntityType: CHEMIST)!
            tempDoctorMasterList = BL_Customer_Complaint.sharedInstance.getCustomerMasterList(regionCode: regionCode,customerEntityType: CHEMIST)!
           isShowEmptyState(masterList: doctorMasterList, title: appChemist)
        }
        else if(sender.selectedSegmentIndex == 2)
        {
            doctorMasterList = BL_Customer_Complaint.sharedInstance.getCustomerMasterList(regionCode: regionCode,customerEntityType: "STOCKIEST")!
            tempDoctorMasterList = BL_Customer_Complaint.sharedInstance.getCustomerMasterList(regionCode: regionCode,customerEntityType: "STOCKIEST")!
            isShowEmptyState(masterList: doctorMasterList, title: appStockiest)
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
        self.doctorMasterList = self.tempDoctorMasterList
        
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
            
            self.doctorMasterList = self.tempDoctorMasterList
            
            self.emptyStateLbl.isHidden = true
            self.tableView.isHidden = false
            self.emptyStateLbl.text = ""
            tableView.reloadData()
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func sortCurrentList(searchText:String)
    {
        
        let filteredData = self.tempDoctorMasterList.filter {
            (obj) -> Bool in
            let lowerCaseText = searchText.lowercased()
            let empName  = (obj.Customer_Name).lowercased()
            if (empName.contains(lowerCaseText))
            {
                return true
            }
            
            return false
        }
        self.doctorMasterList = filteredData
        tableView.reloadData()
        self.emptyStateLbl.text = ""
        if(self.doctorMasterList.count>0)
        {
            self.emptyStateLbl.isHidden = true
            self.tableView.isHidden = false
            tableView.reloadData()
        }
        else
        {
            self.emptyStateLbl.isHidden = false
            self.tableView.isHidden = true
            self.emptyStateLbl.text = "No List found"
            tableView.reloadData()
        }
        
    }
    

}
