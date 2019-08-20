//
//  CompetitorListViewController.swift
//  HiDoctorApp
//
//  Created by Sabari on 16/06/18.
//  Copyright © 2018 swaas. All rights reserved.
//
protocol selectCompetitorDelegate {
    
    func getSelectedCompetitor(selectedCompetitor : CompetitorModel)
    func getSelectedCompetitorProduct(selectedCompetitor : ProductModel)
}
import UIKit

class CompetitorListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    var competitorList : [CompetitorModel] = []
    var competitorProductList: [ProductModel] = []
    var delegate : selectCompetitorDelegate?
    var isFromProductSelection : Bool!
     var dcrDetailedCompetitorList :[DCRCompetitorDetailsModel] = []
    var selectedProductObj : DetailProductMaster!
    var competitorCode: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.setDefaults()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setDefaults()
    {
        dcrDetailedCompetitorList = BL_CompetitorProducts.sharedInstance.getDcrDetailCompetitorList(productCode:selectedProductObj.Product_Code)
        if(isFromProductSelection)
        {
            self.competitorProductList = BL_DetailedProducts.sharedInstance.getCompetitorProductList(competitorCode: competitorCode!)
            
            for competitorObj in self.competitorProductList
            {
                for detailCompetitorObj in dcrDetailedCompetitorList
                {
                    if(competitorObj.Product_Code == detailCompetitorObj.DCR_Product_Detail_Code)
                    {
                        competitorObj.isSelected = true
                    }
                }
            }
            
            if(self.competitorProductList.count > 0)
            {
                self.tableView.isHidden = false
                self.tableView.reloadData()
                emptyLabel.text = ""
            }
            else
            {
                self.tableView.isHidden = true
                emptyLabel.text = "No Products found"
            }
        }
        else{
            self.competitorList = BL_DetailedProducts.sharedInstance.getCompetitorList()
            
            for competitorObj in self.competitorList
            {
                for detailCompetitorObj in dcrDetailedCompetitorList
                {
                    if(competitorObj.Competitor_Name == detailCompetitorObj.Competitor_Name)
                    {
                        competitorObj.isSelected = true
                    }
                }
            }
            
            if(self.competitorList.count > 0)
            {
                self.tableView.isHidden = false
                self.tableView.reloadData()
                emptyLabel.text = ""
            }
            else
            {
                self.tableView.isHidden = true
                emptyLabel.text = "No Competitor found"
            }
        }
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isFromProductSelection)
        {
            return self.competitorProductList.count
        }
        else
        {
          return self.competitorList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CompetitorCell") as! CompetitiorListTableViewCell
        
        if(isFromProductSelection)
        {
            let competitorProductObj = self.competitorProductList[indexPath.row]
            cell.competitorName.text = competitorProductObj.Product_Name
            if(competitorProductObj.isSelected == true)
            {
                cell.bgView.backgroundColor = UIColor.lightGray
            }
            else
            {
                cell.bgView.backgroundColor = UIColor.white
            }
        }
        else
        {
            let competitorObj = self.competitorList[indexPath.row]
            cell.competitorName.text = competitorObj.Competitor_Name
            if(competitorObj.isSelected == true)
            {
                cell.bgView.backgroundColor = UIColor.lightGray
            }
            else
            {
                cell.bgView.backgroundColor = UIColor.white
            }
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       

        if(isFromProductSelection)
        {
            let competitorProductObj = self.competitorProductList[indexPath.row]
            if(competitorProductObj.isSelected == false)
            {
                _ = self.navigationController?.popViewController(animated: false)
            self.delegate?.getSelectedCompetitorProduct(selectedCompetitor: competitorProductObj)
            }
        }
        else
        {
            let competitorObj = self.competitorList[indexPath.row]
            if(competitorObj.isSelected == false)
            {
                _ = self.navigationController?.popViewController(animated: false)
            self.delegate?.getSelectedCompetitor(selectedCompetitor: competitorObj)
            }
        }
    }
}
