//
//  ExpenseClaimCalandarListController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 26/04/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class ExpenseClaimCalandarListController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var tableView : UITableView!
    var expenseCalandarEventList:[NSArray] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButtonView()
        self.title = "Expense Calendar List"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return expenseCalandarEventList.count
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenseCalandarEventList[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        let cell1 = self.tableView.dequeueReusableCell(withIdentifier: "ExpenseClaimSectionCellID") as! ExpenseClaimSectionCell
        
        if(section == 0)
        {
            cell1.titleLbl.text = "Field"
            
        }
        else if(section == 1)
        {
            cell1.titleLbl.text = "Office"
            
        }
        else if(section == 2)
        {
            cell1.titleLbl.text = "WeekEnd"
            
        }
        else if(section == 3)
        {
            cell1.titleLbl.text = "Holidays"
            
        }
        
        return cell1
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell1 = self.tableView.dequeueReusableCell(withIdentifier: "ExpenseClaimDetailTableViewCellID") as! ExpenseClaimDetailTableViewCell
        let expenseClaimDetail = expenseCalandarEventList[indexPath.section]
        let cellData = expenseClaimDetail[indexPath.row] as! [String:Any]
        cell1.valueLbl.isHidden = false
        cell1.valueTxt.isHidden = true
        if(indexPath.section == 3 )
        {
            let uploadDate = convertDateIntoString(dateString: (cellData["Holiday_Date"] as? String)!)
            let appFormat = convertDateIntoString(date: uploadDate)
            cell1.valueLbl.text = cellData["Holiday_Name"] as? String
            cell1.titleLbl.text = appFormat
        }
       else if(indexPath.section == 2 )
        {
            let uploadDate = convertDateIntoString(dateString: (cellData["Date"] as? String)!)
            let appFormat = convertDateIntoString(date: uploadDate)
            cell1.valueLbl.text = ""
            cell1.titleLbl.text = appFormat
        }
        else
        {
            let uploadDate = convertDateIntoString(dateString: (cellData["Dcr_Actual_Date"] as? String)!)
            let appFormat = convertDateIntoString(date: uploadDate)
            cell1.valueLbl.text = ""
            cell1.titleLbl.text = appFormat
        }
        return cell1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

}
