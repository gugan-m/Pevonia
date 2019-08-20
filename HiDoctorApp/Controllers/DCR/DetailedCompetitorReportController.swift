//
//  DetailedCompetitorReportController.swift
//  HiDoctorApp
//
//  Created by Sabari on 21/06/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class DetailedCompetitorReportController: UIViewController,UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    
    var dcrDetailedCompetitorList :[DCRCompetitorDetailsModel] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(dcrDetailedCompetitorList.count > 0)
        {
            self.tableView.isHidden = false
            self.emptyStateLbl.text = ""
            self.tableView.reloadData()
            self.tableView.tableFooterView = UIView()
        }
        else
        {
            self.tableView.isHidden = true
            self.emptyStateLbl.text = "No Competitor Product"
        }

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
        return self.dcrDetailedCompetitorList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CompetitorDetailTableViewCellID") as! CompetitorDetailTableViewCell
        let competitorObj = self.dcrDetailedCompetitorList[indexPath.row]
        cell.competitorName.text = competitorObj.Competitor_Name
        var productName = competitorObj.Product_Name
        var value = "\(competitorObj.Value!)"
        var probability = "\(competitorObj.Probability!)"
        var remarks = competitorObj.Remarks
        
        if(productName == EMPTY || productName == nil)
        {
            productName = NOT_APPLICABLE
        }
        if(value == EMPTY )
        {
            value = NOT_APPLICABLE
        }
        if(probability == EMPTY)
        {
            probability = NOT_APPLICABLE
        }
        if(remarks == EMPTY)
        {
            remarks = NOT_APPLICABLE
        }
        
        let combainedValue = "Product Name: \(productName!) | Value: \(value) | Probability: \(probability) | Remarks: \(remarks!)"

        cell.productName.text = combainedValue
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var heightVal : CGFloat = 156.0
        
        let competitorObj = self.dcrDetailedCompetitorList[indexPath.row]
        
        var productName = competitorObj.Product_Name
        var value = "\(competitorObj.Value!)"
        var probability = "\(competitorObj.Probability!)"
        var remarks = competitorObj.Remarks
        
        if(productName == EMPTY || productName == nil)
        {
            productName = NOT_APPLICABLE
        }
        if(value == EMPTY )
        {
            value = NOT_APPLICABLE
        }
        if(probability == EMPTY )
        {
            probability = NOT_APPLICABLE
        }
        
        if(remarks == EMPTY)
        {
            remarks = NOT_APPLICABLE
        }
        
        let combainedValue = "Product Name: \(productName!) | Value: \(value) | Probability: \(probability) | Remarks: \(remarks!)"

        
        let detailTextSize = getTextSize(text: combainedValue, fontName: fontRegular, fontSize: 14.0, constrainedWidth: SCREEN_WIDTH - 70.0)
        
        heightVal = heightVal + detailTextSize.height
        
        return heightVal
    }
    
    


}
