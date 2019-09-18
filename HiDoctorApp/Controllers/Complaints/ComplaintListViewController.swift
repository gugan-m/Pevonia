//
//  ComplaintListViewController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 20/05/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class ComplaintListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    @IBOutlet weak var segmentView : UISegmentedControl!
    @IBOutlet weak var searchBar : UISearchBar!
    var regionCode = String()
    var complaintList : [ComplaintList] = []
    var complaintListOpened : [ComplaintList] = []
    var complaintListClosed : [ComplaintList] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Complaint List"
        self.tableView.tableFooterView = UIView()
        self.tableView.contentOffset = CGPoint(x: 0.0, y: self.searchBar.frame.size.height - self.tableView.contentOffset.y);

            //CGPointMake(0,  self.searchBar.frame.size.height - self.tableView.contentOffset.y);
        searchBar.delegate = self
        self.getComplaintList()
        // Do any additional setup after loading the view.
    }

   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.complaintList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ComplaintTableViewCell") as! ComplaintTableViewCell
        let complaintValue = self.complaintList[indexPath.row]
        
        cell.customerName.text = "Name: " + complaintValue.Customer_Name
        cell.regionLbl.text = "Region: " + complaintValue.Region_Name
        let datevalue = complaintValue.Complaint_Date.components(separatedBy: " ")
        if(datevalue.count > 0)
        {
            let dateFromValue = convertDateIntoString(dateString: datevalue[0])
            let appFormatDate = convertDateIntoString(date: dateFromValue)
            cell.dateLabel.text = appFormatDate
            let existingFromTime = getTimeIn12HrFormat(date: getDateFromString(dateString: complaintValue.Complaint_Date), timeZone: NSTimeZone.local)
            
            cell.timeLabel.text = existingFromTime
        }
       
        else
        {
            cell.dateLabel.text = ""
        }
        
        cell.problemTxt.text = complaintValue.Problem_Short_Description
        var type = String()
        if(complaintValue.Customer_Entity_Type.lowercased() == "doctor")
        {
            type = appDoctor
        }
        else if(complaintValue.Customer_Entity_Type.lowercased() == "chemist")
        {
           type = appChemist
        }
        else
        {
            type = appStockiest
        }
        cell.typeLbl.text =  "Type: \(type)"
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //ComplaintDetailViewControllerID
        let sb = UIStoryboard(name: commonListSb, bundle: nil)
        let vc:ComplaintDetailViewController = sb.instantiateViewController(withIdentifier: ComplaintDetailViewControllerID) as! ComplaintDetailViewController
        vc.complaintValue = self.complaintList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getComplaintList()
    {
        if(checkInternetConnectivity())
        {
           showCustomActivityIndicatorView(loadingText: "Loading Complaints...")
            WebServiceHelper.sharedInstance.getCustomerComplaints(regionCode: regionCode) { (apiResponseObj) in
                if(apiResponseObj.Status == SERVER_SUCCESS_CODE)
                {
                    removeCustomActivityView()
                    if(apiResponseObj.list.count>0)
                    {
                        var complaintList : [ComplaintList] = []
                        for (index,element) in apiResponseObj.list.enumerated()
                        {
                            let getComplaint = apiResponseObj.list[index] as! NSDictionary
                            
                            let complaintObj = ComplaintList()
                            
                            complaintObj.Complaint_Date = getComplaint.value(forKey: "Complaint_Date") as! String
                            complaintObj.Customer_Name = getComplaint.value(forKey: "Customer_Name") as! String
                            complaintObj.Customer_Entity_Type = getComplaint.value(forKey: "Customer_Entity_Type") as! String
                            complaintObj.Problem_Description = getComplaint.value(forKey: "Problem_Description") as! String
                            complaintObj.Problem_Short_Description = getComplaint.value(forKey: "Problem_Short_Description") as! String
                            complaintObj.Complaint_Status = getComplaint.value(forKey: "Complaint_Status") as! Int
                            complaintObj.Resolution_By = checkNullAndNilValueForString(stringData: getComplaint.value(forKey: "Resolution_By") as? String)
                            let dateFromValue =  checkNullAndNilValueForString(stringData: getComplaint.value(forKey: "Resolution_Date") as? String)
                            if(dateFromValue != "")
                            {
                            complaintObj.Resolution_Date = convertDateIntoString(dateString:dateFromValue)
                            }
                            
                            complaintObj.Resolution_Remarks = checkNullAndNilValueForString(stringData: getComplaint.value(forKey: "Resolution_Remarks") as? String)
                            complaintObj.Region_Name = checkNullAndNilValueForString(stringData: getComplaint.value(forKey: "Customer_Region_Name") as? String)
                            
                            complaintList.append(complaintObj)
                            
                        }
                        self.complaintListOpened = complaintList.filter{$0.Complaint_Status == 1}
                        self.complaintListClosed = complaintList.filter{$0.Complaint_Status != 1}
                        
                        self.complaintListClosed = self.complaintListClosed.sorted(by: {
                            $0.Resolution_Date! > $1.Resolution_Date!
                        })
                        
                        self.complaintList = []
                        self.complaintList = self.complaintListOpened
                        self.tableView.reloadData()
                    }
                    else
                    {
                        self.isShowEmptyState(complaintList:self.complaintList)
                    }
                }
                else
                {
                    removeCustomActivityView()
                    AlertView.showAlertView(title: internetOfflineMessage, message : errorTitle, viewController: self)
                    
                }
            }
        }
        else
        {
            AlertView.showAlertView(title: internetOfflineMessage, message: internetOfflineMessage, viewController: self)
        }
    }
    @IBAction func segmentView(_ sender: UISegmentedControl) {
        
        if(sender.selectedSegmentIndex == 0)
        {
            self.complaintList = []
            self.complaintList = self.complaintListOpened
            isShowEmptyState(complaintList:self.complaintList)
            self.tableView.reloadData()
        }
        else if(sender.selectedSegmentIndex == 1)
        {
            self.complaintList = []
            self.complaintList = self.complaintListClosed
            isShowEmptyState(complaintList:self.complaintList)
            self.tableView.reloadData()
        }
    }
    
    func isShowEmptyState(complaintList:[ComplaintList])
    {
        if(complaintList.count > 0)
        {
            self.tableView.isHidden = false
            self.emptyStateLbl.text = ""
            self.tableView.reloadData()
        }
        else
        {
            self.tableView.isHidden = true
            self.emptyStateLbl.text = "No complaint found."
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
        if(segmentView.selectedSegmentIndex == 0)
        {
            self.complaintList = self.complaintListOpened
        }
        else
        {
            self.complaintList = self.complaintListClosed
        }
        
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
            
            if(segmentView.selectedSegmentIndex == 0)
            {
                self.complaintList = self.complaintListOpened
            }
            else
            {
                self.complaintList = self.complaintListClosed
            }
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
        if(segmentView.selectedSegmentIndex == 0)
        {
            let filteredData = self.complaintListOpened.filter {
                (obj) -> Bool in
                let lowerCaseText = searchText.lowercased()
                let empName  = (obj.Customer_Name).lowercased()
                if (empName.contains(lowerCaseText))
                {
                    return true
                }
                
                return false
            }
            self.complaintList = filteredData
        }
        else
        {
            let filteredData = self.complaintListClosed.filter {
                (obj) -> Bool in
                let lowerCaseText = searchText.lowercased()
                let empName  = (obj.Customer_Name).lowercased()
                if (empName.contains(lowerCaseText))
                {
                    return true
                }
                
                return false
            }
            self.complaintList = filteredData
        }
        tableView.reloadData()
        self.emptyStateLbl.text = ""
        if(self.complaintList.count>0)
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
