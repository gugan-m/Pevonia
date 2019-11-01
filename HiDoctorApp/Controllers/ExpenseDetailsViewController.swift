//
//  ExpenseDetailsViewController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 23/04/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class ExpenseDetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var expenseApprovalData = ExpenseApproval()
    var expenseDetileList : [ExpenseViewDCRWiseDetailList] = []
    var expenseAdditionalList : [ExpenseClaimAdditionalTypeList] = []
    var isComingAdditionalView = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButtonView()
        self.title = "Expense Detail"
        self.setExpenceDataList()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if(isComingAdditionalView)
        {
            setAdditionalExpenceDataList()
        }
        else
        {
        self.setExpenceDataList()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setExpenceDataList()
    {
        self.expenseDetileList = BL_ExpenseClaim.sharedInstance.expenseDCRDetailList
        self.tableView.isHidden = true
        self.emptyStateLabel.isHidden = true
        if(self.expenseDetileList.count > 0)
        {
            self.tableView.isHidden = false
            self.emptyStateLabel.isHidden = true
            self.tableView.reloadData()
        }
        else
        {
            self.tableView.isHidden = true
            self.emptyStateLabel.isHidden = false
            self.emptyStateLabel.text = "NO Expense Detail Found"
        }
    }
    
    func setAdditionalExpenceDataList()
    {
        self.expenseAdditionalList = BL_ExpenseClaim.sharedInstance.expenseAdditionalDetailList
        self.tableView.isHidden = true
        self.emptyStateLabel.isHidden = true
        if(self.expenseAdditionalList.count > 0)
        {
            self.tableView.isHidden = false
            self.emptyStateLabel.isHidden = true
            self.tableView.reloadData()
        }
        else
        {
            self.tableView.isHidden = true
            self.emptyStateLabel.isHidden = false
            self.emptyStateLabel.text = "NO Expense Detail Found"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isComingAdditionalView)
        {
            return self.expenseAdditionalList.count
        }
        else
        {
            return self.expenseDetileList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ExpenseClaimDCRWiseTableViewCell") as! ExpenseClaimDCRWiseTableViewCell
        if(isComingAdditionalView)
        {
            let expenseData = self.expenseAdditionalList[indexPath.row]
            
            
            let uploadDate = convertDateIntoString(dateString: expenseData.Dcr_Actual_Date)
            let appFormat = convertDateIntoString(date: uploadDate)
            let activity = expenseData.Dcr_Activity_Flag
            var displayActivity = String()
            cell.dateLbl.text = appFormat
            if(activity == "F")
            {
                displayActivity = "Field"
            }
            else if(activity == "L")
            {
                displayActivity = "Not Working"
            }
            else if(activity == "A")
            {
                displayActivity = "Office"
            }
            cell.infoLbl.text = "\(displayActivity) | \(expenseData.Expense_Type_Name!)"
            cell.expenseAmountLbl.text = "\(expenseData.Expense_Amount!)"
            cell.deductionLbl.text = "\(expenseData.Deduction_Amount!)"
            
            return cell
        }
        else
        {
           let expenseData = self.expenseDetileList[indexPath.row]
        
        
        let uploadDate = convertDateIntoString(dateString: expenseData.DCR_Date)
        let appFormat = convertDateIntoString(date: uploadDate)
        let activity = expenseData.DCR_Activity_Flag
        var displayActivity = String()
        cell.dateLbl.text = appFormat
        if(activity == "F")
        {
            displayActivity = "Field"
        }
        else if(activity == "L")
        {
            displayActivity = "Not Working"
        }
        else if(activity == "A")
        {
            displayActivity = "Office"
        }
        cell.infoLbl.text = "\(displayActivity) | \(expenseData.Expense_Type_Name!)"
        cell.expenseAmountLbl.text = "\(expenseData.Expense_Amount!)"
        cell.deductionLbl.text = "\(expenseData.Deduction_Amount!)"
        
        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: ApprovalSb, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ExpenseDCRDetailsEditControllerID") as! ExpenseDCRDetailsEditController
        vc.selectedIndexPath = indexPath.row
        vc.isFromAdditionalView = isComingAdditionalView
        vc.expenseApprovalData = expenseApprovalData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
  
}
