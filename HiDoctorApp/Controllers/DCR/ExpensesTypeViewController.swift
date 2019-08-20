//
//  ExpensesTypeViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 17/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

protocol ExpenseTypeListDelegate {
    func setSelectedExpenseType(expenseObj : ExpenseGroupMapping?)
}

class ExpensesTypeViewController: UIViewController,UITableViewDelegate , UITableViewDataSource
{
    
    @IBOutlet weak var tableView : UITableView!
    
    var expenseTypeList : [ExpenseGroupMapping] = []
    var delegate : ExpenseTypeListDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.getExpensesType()
        self.navigationItem.title = "Expenses Type List"
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return expenseTypeList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell =  tableView.dequeueReusableCell(withIdentifier: expenseTypeListCell, for: indexPath)
        
        let expenseObj  = expenseTypeList[indexPath.row]
        cell.textLabel?.text = expenseObj.Expense_Type_Name as String
        cell.textLabel?.font = UIFont(name: fontRegular, size: 15)
        cell.textLabel?.textColor = UIColor.darkGray
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let expenseObj  = expenseTypeList[indexPath.row]
        delegate?.setSelectedExpenseType(expenseObj: expenseObj)
        _ = navigationController?.popViewController(animated: false)
    }
    
    
    func getExpensesType()
    {
        let expenseList = BL_Expense.sharedInstance.getUniqueExpenseTypes()
        if expenseList.count > 0
        {
            expenseTypeList = expenseList
        }
    }
}
