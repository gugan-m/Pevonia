//
//  ExpensesListViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 17/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit


class ExpensesListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var emptyStateView: UIView!
    
    
    var dcrExpenseList : [DCRExpenseModel] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.getDCRExpenseList()
        addBackButtonView()
        self.navigationItem.title = "Expenses List"
    }
    
    //MARK: - Table View Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dcrExpenseList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let expenseObj = dcrExpenseList[indexPath.row]
        let defaultHeight : CGFloat = 48
        var bottomViewHeight : CGFloat = 50
        let expenseLblHeight = getTextSize(text: expenseObj.Expense_Type_Name, fontName: fontRegular, fontSize: 15, constrainedWidth: SCREEN_WIDTH - 40).height
        if expenseObj.Is_Prefilled == 1  && expenseObj.Is_Editable == 0
        {
           bottomViewHeight = 10
        }
        return defaultHeight + bottomViewHeight + expenseLblHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: expensesListCell, for: indexPath) as! ExpensesListTableViewCell
        
        let expenseObj = dcrExpenseList[indexPath.row]
        cell.expenseTypeLbl.text = expenseObj.Expense_Type_Name
        cell.expenseAmountLbl.text = "Rs.\(String(expenseObj.Expense_Amount))"
        cell.modifyBtn.tag = indexPath.row
        cell.removeBtn.tag = indexPath.row
        cell.bottomViewHeight.constant = 50
        cell.sepViewHgtConst.constant = 1
        if expenseObj.Is_Prefilled == 1  && expenseObj.Is_Editable == 0
        {
            cell.bottomViewHeight.constant = 0
            cell.sepViewHgtConst.constant = 0
        }
        else if expenseObj.Is_Prefilled == 1 && expenseObj.Is_Editable == 1
        {
            cell.removeBtnHeight.constant = 0
        }
        else if expenseObj.Is_Prefilled == 0 && expenseObj.Is_Editable == 0
        {
            cell.modifyBtnHeight.constant = 0
        }
        
        return cell
        
    }
    
    @IBAction func modifyBtnAction(_ sender: Any)
    {
        let indexPath = (sender as AnyObject).tag
       let expenseObj = dcrExpenseList[indexPath!]
        self.navigateToModifyExpensePage(expenseObj: expenseObj)
    }
    
    @IBAction func removeBtnAction(_ sender: Any)
    {
        let indexPath = (sender as AnyObject).tag
        let expenseObj = dcrExpenseList[indexPath!]
        let expenseName = expenseObj.Expense_Type_Name as String
        let alertViewController = UIAlertController(title: nil, message: "Do you want to remove expense \"\(expenseName)\"", preferredStyle: UIAlertControllerStyle.alert)
        alertViewController.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { alertAction in
            self.removeExpenseDetails(expenseObj: expenseObj)
            self.dcrExpenseList.remove(at: indexPath!)
            self.reloadTableView()
            showToastView(toastText: "Expense details removed successfully")
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        alertViewController.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: { alertAction in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func getDCRExpenseList()
    {
        BL_Expense.sharedInstance.calculateFareForPrefillTypeExpenses()
        let expenseList = BL_Expense.sharedInstance.getDCRExpenses()
        if (expenseList?.count)! > 0
        {
             dcrExpenseList = expenseList!
             self.reloadTableView()
        }
    }
    
    func navigateToModifyExpensePage(expenseObj :DCRExpenseModel)
    {
        let sb = UIStoryboard(name: addExpenseDetailsSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: AddExpenseVcID) as! ExpenseViewController
        vc.expenseModifyObj = expenseObj
        vc.isFromExpenseList = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func addExpenseBtnAction(_ sender: Any)
    {
        let sb = UIStoryboard(name:addExpenseDetailsSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: AddExpenseVcID)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func removeExpenseDetails(expenseObj : DCRExpenseModel)
    {
       BL_Expense.sharedInstance.deleteDCRExpense(expenseTypeCode: expenseObj.Expense_Type_Code)
    }
    
    func showEmptyStateView(show: Bool)
    {
        self.emptyStateView.isHidden = !show
        self.contentView.isHidden  = show
    }
    
    func reloadTableView()
    {
        if self.dcrExpenseList.count > 0
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
}

