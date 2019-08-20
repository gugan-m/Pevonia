//
//  DeleteSampleListViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 21/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class DeleteSampleListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var userDCRProductList : [DCRSampleModel] = []
    var selectedProductList : NSMutableArray = []
    var currentList : [DCRSampleModel] = []
    var isComingFromTP: Bool = false
    var isComingFromChemistDay : Bool = false
    var iscomingFromModify: Bool = false
    var isComingFromAttendanceDoctor: Bool = false
    var doctorVisitId = Int()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setSelectedList()
        self.addBackButtonView()
        self.changeCurrentList(list: userDCRProductList)
        self.navigationItem.title = "\(String(userDCRProductList.count)) Selected"
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let productDetail = currentList[indexPath.row]
        var rowHeight : CGFloat = 60
        let productNameTextHeight = getTextSize(text: productDetail.sampleObj.Product_Name, fontName: fontRegular, fontSize: 16, constrainedWidth: SCREEN_WIDTH - 65).height
        rowHeight += productNameTextHeight
        
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:DeleteSampleListCell, for: indexPath) as! SampleProductListTableViewCell
        let productDetail = currentList[indexPath.row]
        
        let productName  =  productDetail.sampleObj.Product_Name as String
        let currentStock =  String(productDetail.sampleObj.Current_Stock)
        var productCount : String = ""
        if productDetail.sampleObj.Product_Type_Name != nil
        {
            productCount  = productDetail.sampleObj.Product_Type_Name as String
        }
        var divisionName = String()
        if(productDetail.sampleObj.Division_Name == nil)
        {
            divisionName = ""
        }
        
        cell.productNameLbl.text = "\(productName)(\(currentStock))"
        if divisionName != ""
        {
            cell.productCountLbl.text = "\(productCount) | \(divisionName)"
        }
        else
        {
            cell.productCountLbl.text = "\(productCount) | Drug Division"
        }
        
        if selectedProductList.contains(productDetail)
        {
            cell.selectedImageView.image = UIImage(named: "icon-tick")
        }
        else
        {
            cell.selectedImageView.image = UIImage(named: "icon-unselected")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productDetail = currentList[indexPath.row]
        if self.selectedProductList.contains(productDetail)
        {
            self.selectedProductList.remove(productDetail)
        }
        else
        {
            self.selectedProductList.add(productDetail)
        }
        let selectedCount = selectedProductList.count
        if selectedCount > 0
        {
            self.navigationItem.title = "\(String(selectedCount)) Selected"
        }
        else
        {
            self.navigationItem.title = "Samples/Input List"
        }
        self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
    }
    
    func setSelectedList()
    {
        for sampleObj in userDCRProductList
        {
            self.selectedProductList.add(sampleObj)
        }
    }

    @IBAction func doneBtnAction(_ sender: AnyObject)
    {
        let sample_sb = UIStoryboard(name: sampleProductListSb, bundle: nil)
        let sample_nc = sample_sb.instantiateViewController(withIdentifier:sampleDCRListVcID) as! SampleDetailsViewController
        sample_nc.currentList = getUserProductList()
        sample_nc.isComingFromDeletePage = true
        sample_nc.isComingFromTpPage = self.isComingFromTP
        sample_nc.isComingFromChemistDay = self.isComingFromChemistDay
        sample_nc.isComingFromModifyPage = self.iscomingFromModify
        sample_nc.isComingFromAttendanceDoctor = self.isComingFromAttendanceDoctor
        sample_nc.doctorVisitId = doctorVisitId
        
        if let navigationController = self.navigationController
        {
            navigationController.popViewController(animated: false)
            navigationController.pushViewController(sample_nc, animated: false)
        }
    }
    
    func getUserProductList() -> [DCRSampleModel]
    {
        var selectedList : [DCRSampleModel] = []
        for obj in selectedProductList
        {
            selectedList.append(obj as! DCRSampleModel)
        }
        return selectedList
    }
    
    func changeCurrentList(list: [DCRSampleModel])
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
            self.searchBar.resignFirstResponder()
        }
    }
    
    func showEmptyStateView(show : Bool)
    {
        self.emptyStateView.isHidden = !show
        self.contentView.isHidden = show
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
        self.changeCurrentList(list: userDCRProductList)
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
        var searchList : [DCRSampleModel] = []
        searchList = userDCRProductList.filter{ (productDetails) -> Bool in
            let lowerCasedText = searchText.lowercased()
            let productName = (productDetails.sampleObj.Product_Name).lowercased()
            return productName.contains(lowerCasedText)
        }
        self.changeCurrentList(list: searchList)
    }
    
//    func addBackButtonView()
//    {
//        let backButton = UIBarButtonItem(image: UIImage(named: "navigation-arrow"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(DeleteSampleListViewController.backButtonClicked))
//        self.navigationItem.leftBarButtonItem = backButton
//    }
    
//    @objc func backButtonClicked()
//    {
//        _ = navigationController?.popViewController(animated: false)
//    }

}
