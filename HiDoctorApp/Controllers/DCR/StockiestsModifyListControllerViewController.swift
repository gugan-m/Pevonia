//
//  StockiestsModifyListControllerViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 27/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class StockiestsModifyListControllerViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var dcrStockiestsList : [DCRStockistVisitModel] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "\(appStockiestPlural) List"
        emptyStateLbl.text = "No \(appStockiestPlural) Found"
        addBackButtonView()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.getStockiestList()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Table View Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dcrStockiestsList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let stockiestObj = dcrStockiestsList[indexPath.row]
        let defaultHeight : CGFloat = 48
        let bottomViewHeight : CGFloat = 60 + 10
        let stockNameLblHgt = getTextSize(text: stockiestObj.Stockiest_Name, fontName: fontRegular, fontSize: 15, constrainedWidth: SCREEN_WIDTH - 40).height

        return defaultHeight + bottomViewHeight + stockNameLblHgt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: StockiestsModifyListCell, for: indexPath) as! StockiestsModifyListTableViewCell
        let stockiestsObj = dcrStockiestsList[indexPath.row]
        let stockiestName = stockiestsObj.Stockiest_Name as String
        
        cell.stockiestsNameLbl.text = stockiestName
        var pobAmount : String = ""
        
        pobAmount = String(describing: stockiestsObj.POB_Amount!) as String
        var collectionAmount = String(describing: stockiestsObj.Collection_Amount!) as String
        
        var visittime = String(describing: stockiestsObj.Visit_Time!) as String
        var visitmode = String(describing: stockiestsObj.Visit_Mode!) as String
       
        if pobAmount == ""
        {
            pobAmount = "0.0"
        }
        
        if collectionAmount == ""
        {
            collectionAmount = "0.0"
        }
        
        if visittime == ""
        {
            visittime = ""
        }
        
        if visitmode == ""
        {
            visitmode = ""
        }
        
        
        if BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled()
            
        {
            cell.amountLbl.text = "POB : \(pobAmount) | Collection : \(collectionAmount) | \(visittime) \(visitmode)"
        }
        else if (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.DCR_STOCKIEST_VISIT_TIME) == PrivilegeValues.VISIT_TIME_MANDATORY.rawValue) && (!BL_DCR_Doctor_Visit.sharedInstance.isHourlyReportEnabled())
        {
            cell.amountLbl.text = "POB : \(pobAmount) | Collection : \(collectionAmount) | \(visittime) \(visitmode)"
        }
        else
        {
            cell.amountLbl.text = "POB : \(pobAmount) | Collection : \(collectionAmount) | \(visitmode)"
        }
        
        
        
        
        
        //cell.amountLbl.text = "POB : \(pobAmount) | Collection : \(collectionAmount)"
        cell.modifyBtn.tag = indexPath.row
        cell.removeBtn.tag = indexPath.row
        
        return cell
    }
    
    @IBAction func modifyBtnAction(_ sender: AnyObject)
    {
        let indexPath = sender.tag
        let stockiestsObj = dcrStockiestsList[indexPath!]

        let sb = UIStoryboard(name: stockiestsSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: AddStockiestsVcID) as! AddStockiestsViewController
        
        vc.stockiestsModifyObj = stockiestsObj
        vc.isComingFromModifyPage = true
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func removeBtnAction(_ sender: AnyObject)
    {
        let indexPath = sender .tag
        let stockiestsObj = dcrStockiestsList[indexPath!]
        let stockiestName = stockiestsObj.Stockiest_Name as String
        let alertViewController = UIAlertController(title: nil, message: "Do you want to remove \(appStockiest) \"\(stockiestName)\"", preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { alertAction in
            self.removeStockiestsDetails(stockiestsObj: stockiestsObj)
            self.dcrStockiestsList.remove(at: indexPath!)
            self.reloadTableView()
            showToastView(toastText: "\(appStockiest) details removed successfully")
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        alertViewController.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: { alertAction in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func removeStockiestsDetails(stockiestsObj : DCRStockistVisitModel)
    {
        BL_DCR_Stockiests.sharedInstance.deleteDCRStockiests(stockiestsCode: stockiestsObj.Stockiest_Code)
    }
    
    func navigateToModifyPage(expenseObj :DCRExpenseModel)
    {
        let sb = UIStoryboard(name: addExpenseDetailsSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: AddExpenseVcID) as! ExpenseViewController
        
        vc.expenseModifyObj = expenseObj
        vc.isFromExpenseList = true
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showEmptyStateView(show: Bool)
    {
        self.emptyStateView.isHidden = !show
        self.contentView.isHidden  = show
    }
    
    func reloadTableView()
    {
        if self.dcrStockiestsList.count > 0
        {
            self.tableView.reloadData()
            self.showEmptyStateView(show: false)
        }
        else
        {
            self.showEmptyStateView(show: true)
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
    
    func getStockiestList()
    {
        let stockiestsList = BL_DCR_Stockiests.sharedInstance.getDCRStockiestsList()
        self.dcrStockiestsList = stockiestsList
        self.reloadTableView()
    }
    
    @IBAction func addStockBtnAction(_ sender: AnyObject)
    {
        let sb = UIStoryboard(name: stockiestsSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: StockiestsListVcID)
        if let navigationController = self.navigationController
        {
            navigationController.popViewController(animated: false)
            navigationController.pushViewController(vc, animated: false)
        }
    }
}
