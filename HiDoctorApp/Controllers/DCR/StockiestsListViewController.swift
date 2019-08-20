//
//  StockiestsListViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 27/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

protocol  selectedStockiestListDelegate
{
    func selectedStockiestListDelegate(modify : Bool)
}

class StockiestsListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate ,UISearchBarDelegate
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarHgtConst: NSLayoutConstraint!
    var currentList : [CustomerMasterModel] = []
    var searchList : [CustomerMasterModel] = []
    var stockiestsList : [CustomerMasterModel] = []
    var userSelectedStockiestsCode : [String] = []
    var delegate : selectedStockiestListDelegate?
    var isFromPOB: Bool  = false
    var isFromModify : Bool = false
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "\(appStockiestPlural) List"
        emptyStateLbl.text = "No \(appStockiestPlural) found"
        self.tableView.estimatedRowHeight = 500
        self.getStockiestsList()
        addBackButtonView()
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return currentList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
//        let stockiestObj = currentList[indexPath.row]
//        let defaultHeight : CGFloat = 38
//        let stockNameLblHgt = getTextSize(text: stockiestObj.Customer_Name, fontName: fontBold, fontSize: 15, constrainedWidth: SCREEN_WIDTH - 20).height
        
        return UITableViewAutomaticDimension//defaultHeight + stockNameLblHgt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: StockiestsListCell, for: indexPath) as! StockiestsListTableViewCell
        let stockiestsObj = currentList[indexPath.row]
        if userSelectedStockiestsCode.contains(stockiestsObj.Customer_Code!)
        {
            cell.contentView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        }
        else
        {
            cell.contentView.backgroundColor = UIColor.white
        }
        let customerName = stockiestsObj.Customer_Name as String
        cell.stockiestsNameLbl.text = customerName
        let categoryName = stockiestsObj.Customer_Entity_Type! as String
        cell.categoryNameLbl.text = categoryName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let stockiestsObj = currentList[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.clear
        if !userSelectedStockiestsCode.contains(stockiestsObj.Customer_Code)
        {
            if isFromPOB != true
            {
            let sb = UIStoryboard(name: stockiestsSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: AddStockiestsVcID) as! AddStockiestsViewController
            vc.stockiestsObj = stockiestsObj
            if let navigationController = self.navigationController
            {
                navigationController.popViewController(animated: false)
                navigationController.pushViewController(vc, animated: false)
            }
            }
            else
            {
//                let sb = UIStoryboard(name: Constants.StoaryBoardNames.POBSb, bundle: nil)
//                let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.POBStepperVcID) as! POBStepperViewController
                if isFromModify
                {
                    let pobHeaderObj = BL_POB_Stepper.sharedInstance.getPOBHeaderforOrderEntryId(orderEntryID: BL_POB_Stepper.sharedInstance.orderEntryId)
                    if pobHeaderObj.Order_Status == Constants.OrderStatus.draft
                    {
                        BL_POB_Stepper.sharedInstance.deletePOBHeader(orderEntryId: pobHeaderObj.Order_Entry_Id)
                        BL_POB_Stepper.sharedInstance.deletePOBDetails(orderEntryId: pobHeaderObj.Order_Entry_Id)
                        BL_POB_Stepper.sharedInstance.deletePOBRemarks(orderEntryId: pobHeaderObj.Order_Entry_Id)
                        BL_POB_Stepper.sharedInstance.insertPOBHeaderForChemist(stockiestsObj: stockiestsObj, customerType: DCRModel.sharedInstance.customerEntityType)
                    }
                    
                    else if pobHeaderObj.Order_Status == Constants.OrderStatus.inprogress
                    {
                        BL_POB_Stepper.sharedInstance.updatePOBHeaderOrderStatus(orderEntryId: pobHeaderObj.Order_Entry_Id, orderStatus: 0)
                        BL_POB_Stepper.sharedInstance.insertPOBHeaderForChemist(stockiestsObj: stockiestsObj, customerType: DCRModel.sharedInstance.customerEntityType)
                    }
                    delegate?.selectedStockiestListDelegate(modify: true)
                    //vc.modify = true
                }
                else
                {
                    BL_POB_Stepper.sharedInstance.insertPOBHeaderForChemist(stockiestsObj: stockiestsObj, customerType: DCRModel.sharedInstance.customerEntityType)
                    
                    
                }
                if let navigationController = self.navigationController
                {
                    navigationController.popViewController(animated: false)
                    //navigationController.pushViewController(vc, animated: false)
                }

            }
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.clear
    
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.clear
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
        self.changeCurrentArray(list: stockiestsList,type:0)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if (searchBar.text?.count)! > 0
        {
            sortCurrentList(searchText: searchBar.text!)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.resignFirstResponder()
    }
    
    func sortCurrentList(searchText:String)
    {
        searchList = stockiestsList.filter{ (obj) -> Bool in
            let lowerCasedText = searchText.lowercased()
            let stockiestsName = obj.Customer_Name.lowercased()
            let categoryName = obj.Customer_Entity_Type?.lowercased()
            return stockiestsName.contains(lowerCasedText) || (categoryName?.contains(lowerCasedText))!
        }
        self.changeCurrentArray(list: searchList,type : 1)
    }
    
    func changeCurrentArray(list : [CustomerMasterModel],type : Int)
    {
        if list.count > 0
        {
            currentList = list
            self.showEmptyStateView(show: false)
            self.tableView.reloadData()
        }
        else
        {
            if type == 0
            {
                searchBarHgtConst.constant = 0
            }
            self.showEmptyStateView(show: true)
        }
    }
    
    func showEmptyStateView(show : Bool)
    {
        self.emptyStateView.isHidden = !show
        self.contentView.isHidden = show
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
    
    func getStockiestsList()
    {
        if !isFromPOB
        {
        stockiestsList = BL_DCR_Stockiests.sharedInstance.getMasterStockiestList()
        userSelectedStockiestsCode = BL_DCR_Stockiests.getSelectStockiestsCode()
            changeCurrentArray(list: stockiestsList,type : 0)
        }
        else
        {
            stockiestsList = BL_DCR_Stockiests.sharedInstance.getMasterStockiestList()
            userSelectedStockiestsCode = BL_DCR_Stockiests.getSelectedPOBStockiestCode()
            changeCurrentArray(list: stockiestsList,type : 0)
        }
    }
    
    private func addCustomSaveToNavigationBar()
    {
        let saveButton = UIButton(type: UIButtonType.custom)
        
        saveButton.addTarget(self, action: #selector(self.saveButtonClicked), for: UIControlEvents.touchUpInside)
        saveButton.setImage(UIImage(named: "icon_entry_tick"), for: .normal)
        saveButton.sizeToFit()
        
        let rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func saveButtonClicked()
    {
        _ = navigationController?.popViewController(animated: false)
    }

    
    
}
