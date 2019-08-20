//
//  DoctorListViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 02/02/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class DoctorListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate
{
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarHeightConst: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateView : UIView!
    @IBOutlet weak var contentView : UIView!
    @IBOutlet weak var emptyStateLbl : UILabel!
    
    var currentList : [CustomerMasterModel] = []
    var sortedList : [CustomerMasterModel] = []
    var doctorList : [CustomerMasterModel] = []
    var regionCode : String = ""
    var navigationTitle : String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 500
        
        if navigationTitle == ""
        {
            navigationTitle = "\(appDoctorPlural) List"
        }
        
        self.title = navigationTitle
        
        addCustomBackButtonToNavigationBar()
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        setMasterDoctorList()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return currentList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.DoctorListCell, for: indexPath) as! DoctorListTableViewCell
        let doctorObj = currentList[indexPath.row]
        
        cell.doctorNameLbl.text = doctorObj.Customer_Name as String
        
        let doctorDetails = "\(ccmNumberPrefix)\(checkNullAndNilValueForString(stringData: doctorObj.MDL_Number) as String) | \(checkNullAndNilValueForString(stringData: doctorObj.Speciality_Name) as String) | \(checkNullAndNilValueForString(stringData: doctorObj.Category_Name) as String) | \(checkNullAndNilValueForString(stringData: doctorObj.Region_Name) as String) | \(checkNullAndNilValueForString(stringData: doctorObj.Hospital_Name) as String)"
        
        cell.doctorDetailsLbl.text = doctorDetails
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let doctorObj = currentList[indexPath.row]
        
        BL_DoctorList.sharedInstance.regionCode = doctorObj.Region_Code
        BL_DoctorList.sharedInstance.customerCode = doctorObj.Customer_Code
        
        let sb = UIStoryboard(name: MoreViewMasterSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.DoctorDetailsVcID) as! DoctorDetailsViewController
        vc.title = doctorObj.Customer_Name
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setMasterDoctorList()
    {
        doctorList = BL_DCR_Doctor_Visit.sharedInstance.getDoctorMasterSortList(regionCode: regionCode, sortFieldCode: 0, sortTypeCode: 0)!
        changeCurrentArray(list:doctorList , type: 1)
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
        self.changeCurrentArray(list: doctorList,type : 1)
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
        else
        {
            self.changeCurrentArray(list: doctorList,type : 1)
        }
    }
    
    func sortCurrentList(searchText:String)
    {
        sortedList = doctorList.filter{ (obj) -> Bool in
            let lowerCasedText = searchText.lowercased()
            let doctorName = obj.Customer_Name.lowercased()
            let regionName = checkNullAndNilValueForString(stringData: obj.Region_Name).lowercased()
            let mdlNumber = checkNullAndNilValueForString(stringData: obj.MDL_Number).lowercased()
            let categoryName = checkNullAndNilValueForString(stringData: obj.Category_Name).lowercased()
            let specialityName = obj.Speciality_Name.lowercased()
            //let HospitalName = checkNullAndNilValueForString(stringData: obj.Hospital_Name).lowercased()
            
            return doctorName.contains(lowerCasedText) || (regionName.contains(lowerCasedText)) ||
                (mdlNumber.contains(lowerCasedText)) ||
                (specialityName.contains(lowerCasedText) || (categoryName.contains(lowerCasedText)))
        }
        self.changeCurrentArray(list: sortedList,type: 2)
    }
    
    func changeCurrentArray(list : [CustomerMasterModel] , type : Int)
    {
        if list.count > 0
        {
            currentList = list
            self.tableView.reloadData()
            showEmptyStateView(show: false)
        }
        else
        {
            showEmptyStateView(show: true)
            setEmptyStateLabel(type: type)
        }
    }
    
    func showEmptyStateView(show : Bool)
    {
        self.emptyStateView.isHidden = !show
        self.contentView.isHidden = show
    }
    
    func setEmptyStateLabel(type : Int)
    {
        if type == 1
        {
            self.searchBarHeightConst.constant = 0
            self.emptyStateLbl.text = "No \(appDoctor) found"
        }
        else if type == 2
        {
            self.emptyStateLbl.text = "No \(appDoctor) found. Clear your search and try again."
        }
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
}
