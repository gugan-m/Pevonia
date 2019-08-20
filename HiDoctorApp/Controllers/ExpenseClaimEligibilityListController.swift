//
//  ExpenseClaimEligibilityListController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 26/04/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class ExpenseClaimEligibilityListController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var expenseEligibilityList : [ExpenseClaimEligibility] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButtonView()
        self.title = "Expense Eligibility"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenseEligibilityList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "eligibilityCell") as! UITableViewCell
        
        let expenseData = self.expenseEligibilityList[indexPath.row]
        let expenseTypeName = cell.viewWithTag(1) as! UILabel
         let elegibilityAmount = cell.viewWithTag(2) as! UILabel
         let approvedAmount = cell.viewWithTag(3) as! UILabel
         let applicableDays = cell.viewWithTag(4) as! UILabel
        
        expenseTypeName.text = expenseData.Expense_Type_Name
        elegibilityAmount.text = "\(expenseData.Eligibility_Amount!)"
        approvedAmount.text = "\(expenseData.Approved_Amount!)"
        applicableDays.text = "\(expenseData.Eligible_Amount_Per_Num_Of_Applicable_Days!)"
        
        
        return cell
        
        
 }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let expenseData = self.expenseEligibilityList[indexPath.row]
         let getRemarkSize = getTextSize(text: expenseData.Expense_Type_Name, fontName: fontRegular, fontSize: 15, constrainedWidth: SCREEN_WIDTH - 32).height
        return 140 + getRemarkSize
    }
}
