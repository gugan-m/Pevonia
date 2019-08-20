//
//  ExpenseClaimSFCListViewController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 25/04/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class ExpenseClaimSFCListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var expenseSFCList : [ExpenseClaimSFC] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButtonView()
        self.title = "Expense SFC Detail"
        self.tableView.tableFooterView = UIView()

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
        return expenseSFCList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "StepperSFCCell") as! DCRStepperSFCTableViewCell
        let expenseSFCData = self.expenseSFCList[indexPath.row]
        cell.fromPlaceLabel.text = expenseSFCData.From_Place
        cell.toPlaceLabel.text = expenseSFCData.To_Place
        cell.distancePlaceLabel.text = "\(expenseSFCData.Distance!)"
        
        if(expenseSFCData.SFC_Visit_Count != nil && expenseSFCData.Actual_Visit_Count != nil)
        {
            cell.detailLabel.text = "Visit Count : \(expenseSFCData.SFC_Visit_Count!)  |  Actual Count: \(expenseSFCData.Actual_Visit_Count!)"
            cell.regionName.text = "Region Name : \(expenseSFCData.Region_Name!)"
            if(expenseSFCData.Trend == "Exceed")
            {
                cell.trendLabel.textColor = UIColor.red
            }
            else
            {
                cell.trendLabel.textColor = UIColor.darkGray
            }
            cell.trendLabel.text = expenseSFCData.Trend
            cell.travelModeLabel.text = expenseSFCData.Category
        }
        else
        {
            cell.travelModeLabel.text = ""
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
}
