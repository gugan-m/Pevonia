//
//  AttendanceSampleReportViewController.swift
//  HiDoctorApp
//
//  Created by Swaas on 25/06/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class AttendanceSampleReportViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var sampleList: [DCRAttendanceSampleDetailsModel] = []
    var sampleBatchList = NSArray()
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setDefaults()
       
        // Do any additional setup after loading the view.
    }
    
    func setDefaults()
    {
        self.title = "Sample List"
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        if(sampleList.count == 0)
        {
            emptyStateLabel.text = "NO SAMPLES AVAILABLE"
            tableView.isHidden = true
        }
        else
        {
            emptyStateLabel.text = ""
            tableView.isHidden = false
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleBatchList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "samplecell", for: indexPath) as! AttendanceSampleTableViewCell
        
        let sampleBatchObj = self.sampleBatchList[indexPath.row] as! Dictionary<String,Any>
        
        
        cell.productName.text = checkNullAndNilValueForString(stringData: sampleBatchObj["Product_Name"] as? String)
        cell.productQuantity.text = "\(sampleBatchObj["Quantity_Provided"]!)"
        return cell
    }
  
   
}
