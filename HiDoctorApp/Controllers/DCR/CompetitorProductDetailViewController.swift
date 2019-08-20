//
//  CompetitorProductDetailViewController.swift
//  HiDoctorApp
//
//  Created by Sabari on 14/06/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class CompetitorProductDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    
    
    var addButton : UIBarButtonItem!
    var selectedProductObj : DetailProductMaster!
    var dcrDetailedCompetitorList :[DCRCompetitorDetailsModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButtonView()
        self.title = selectedProductObj.Product_Name
        self.addCompetitorBtn()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setDefaults()
    {
        
        dcrDetailedCompetitorList = BL_CompetitorProducts.sharedInstance.getDcrDetailCompetitorList(productCode:selectedProductObj.Product_Code)
        self.tableView.reloadData()
        self.setEmptyViewVisibility()
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setDefaults()
    }
    
    
    func addCompetitorBtn()
    {
        addButton = UIBarButtonItem(image: UIImage(named: "icon-plus"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(addAction))
        
        self.navigationItem.rightBarButtonItems = [addButton]
    }

    @objc func addAction()
    {
        //Redirect to add competitor
        let sb = UIStoryboard(name: detailProductSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier:AddDetailedCompetitorProductControllerID ) as! AddDetailedCompetitorProductController
        vc.selectedProductObj = self.selectedProductObj
        vc.isFromUpdate = false
        
        self.navigationController?.pushViewController(vc, animated: false)
        
    }

    func getDcrDetailCompetitorList() -> [DCRCompetitorDetailsModel]
    {
        let dcrDetailCompetitorList = BL_DetailedProducts.sharedInstance.getDcrDetailedCompetitorList(dcrId: BL_DetailedProducts.sharedInstance.getDcrId(), dcrDoctorVisitId: BL_DetailedProducts.sharedInstance.getDCRDoctorVisitId(), productCode: selectedProductObj.Product_Code)
        
        return dcrDetailCompetitorList
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
        
        let combainedValue = "Product Name: \(productName!) | Value: \(value) | Probability: \(probability)"
        cell.productName.text = combainedValue
        cell.modifyBtn.tag = indexPath.row
        cell.removeBtn.tag = indexPath.row
        
        cell.modifyBtn.addTarget(self, action: #selector(updateCompetitorDetail), for: .touchUpInside)
        
        cell.removeBtn.addTarget(self, action: #selector(removeCompetitorDetail), for: .touchUpInside)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var heightVal : CGFloat = 156.0
        
         let competitorObj = self.dcrDetailedCompetitorList[indexPath.row]
        
        var productName = competitorObj.Product_Name
        var value = "\(competitorObj.Value!)"
        var probability = "\(competitorObj.Probability!)"
        
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
        
        let combainedValue = "Product Name: \(productName!) | Value: \(value) | Probability: \(probability)"
        
        let detailTextSize = getTextSize(text: combainedValue, fontName: fontRegular, fontSize: 14.0, constrainedWidth: SCREEN_WIDTH - 70.0)
        
        heightVal = heightVal + detailTextSize.height
        
        return heightVal
    }
    
    
    @objc func updateCompetitorDetail(_ sender: UIButton)
    {
        
        let indexPathRow = sender.tag
        let competitorObj = self.dcrDetailedCompetitorList[indexPathRow]
        let sb = UIStoryboard(name: detailProductSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier:AddDetailedCompetitorProductControllerID ) as! AddDetailedCompetitorProductController
        vc.selectedProductObj = self.selectedProductObj
        vc.isFromUpdate = true
        vc.dcrDetailedCompetitorObj = competitorObj
        self.navigationController?.pushViewController(vc, animated: false)
       // var dcrDetailedCompetitorObj :DCRCompetitorDetailsModel!
    }
    
    @objc func removeCompetitorDetail(_ sender: UIButton)
    {
        showRemoveAlert(tag: sender.tag)
    }
    func showRemoveAlert(tag: Int)
    {
        let alert = UIAlertController(title: "Alert", message: "Do you want to Remove?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Remove", style: .default, handler: { (action: UIAlertAction!) in
            self.removeAction(tag: tag)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func removeAction(tag: Int)
    {
        let detailCompetitorId = self.dcrDetailedCompetitorList[tag].Competitor_Detail_Id
        BL_DetailedProducts.sharedInstance.deleteDCRDetailedCompetitor(competitorDetailId: detailCompetitorId!)
        self.dcrDetailedCompetitorList = self.getDcrDetailCompetitorList()
        setEmptyViewVisibility()
        tableView.reloadData()
        showToastView(toastText: "Competitor deleted successfully")
    }
    
    private func setEmptyViewVisibility()
    {
        if dcrDetailedCompetitorList.count > 0
        {
            tableView.isHidden = false
            emptyStateLbl.isHidden = true
            emptyStateLbl.text = ""
        }
        else
        {
            tableView.isHidden = true
            emptyStateLbl.isHidden = false
            emptyStateLbl.text = "No Competitor details found"
        }
    }
}
