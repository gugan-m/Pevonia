//
//  ModifyRCPAViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 07/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class ModifyRCPAViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var emptyStateView: UIView!
    
    
    var uniqueDCRRCPAList : [DCRRCPAModel] = []
    var dcrRCPAList : [DCRRCPAModel] = []
    var  dcrChemistVisitId : Int = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.getDCRRCPADetails()
        self.getOwnProductDetails()
        addBackButtonView()
        self.navigationItem.title = "RCPA Entry"
    }
    
    //MARK: - Table View Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return uniqueDCRRCPAList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let defaultHeight : CGFloat = 84
        let bottomViewHeight : CGFloat = 60 + 10
        return defaultHeight + bottomViewHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: ModifyRCPAListCell, for: indexPath) as! ModifyRCPATableViewCell
        let rcpaObj = uniqueDCRRCPAList[indexPath.row]
        
        cell.ownProductNameLbl.text = rcpaObj.Own_Product_Name as String
        
        let productCode = rcpaObj.Product_Code!
        var ownProductQty: Float = 0
        var compProdutCount: Int = 0
        
        var filteredArray = dcrRCPAList.filter{
            productCode == $0.Product_Code! && checkNullAndNilValueForString(stringData: $0.Competitor_Product_Name) != ""
        }
        
        compProdutCount = filteredArray.count
        
        filteredArray = dcrRCPAList.filter{
            productCode == $0.Product_Code! && checkNullAndNilValueForString(stringData: $0.Competitor_Product_Name) == ""
        }
        
        if (filteredArray.count > 0)
        {
            ownProductQty = filteredArray[0].Qty_Given!
            rcpaObj.Qty_Given = ownProductQty
        }
        
        cell.competitorCountLabel.text = "\(String(compProdutCount)) more competitor products"
        cell.qty_given.text = String(ownProductQty)
        cell.modifyBtn.tag = indexPath.row
        cell.removeBtn.tag = indexPath.row
        
        return cell
    }

    @IBAction func modifyBtnAction(_ sender: UIButton)
    {
        let indexPath = (sender as AnyObject).tag
        let rcpaObj = uniqueDCRRCPAList[indexPath!]
        self.navigateToModifyExpensePage(rcpaObj: rcpaObj)
    }
    
    @IBAction func removeBtnAction(_ sender: UIButton)
    {
        let indexPath = (sender as AnyObject).tag
        let dcrRCPAObj = uniqueDCRRCPAList[indexPath!]
        let  productName = dcrRCPAObj.Own_Product_Name as String
        let alertViewController = UIAlertController(title: nil, message: "Do you want to remove RCPA \"\(productName)\"", preferredStyle: UIAlertControllerStyle.alert)
        alertViewController.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { alertAction in
            self.removeExpenseDetails(rcpaObj : dcrRCPAObj)
            self.uniqueDCRRCPAList.remove(at: indexPath!)
            self.reloadTableView()
            showToastView(toastText: "RCPA details removed successfully")
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        alertViewController.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: { alertAction in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        self.present(alertViewController, animated: true, completion: nil)
    }
   
    
    
    func getOwnProductDetails()
    {
        let uniqueOwnProducts = BL_DCR_Chemist_Visit.sharedInstance.getDCRRCPAUniqueOwnProducts(dcrChemistVisitId: dcrChemistVisitId)
        uniqueDCRRCPAList = uniqueOwnProducts!
        self.reloadTableView()
    }
    
    func getDCRRCPADetails()
    {
         dcrRCPAList =  BL_DCR_Chemist_Visit.sharedInstance.getDCRRCPADetails(dcrChemistVisitId:dcrChemistVisitId)!
    }
    
    func getCompetitorProductCount(productCode : String) -> Int
    {
        let competitorList = BL_DCR_Chemist_Visit.sharedInstance.getCompetitorProducts(ownProductCode: productCode)
        return (competitorList?.count)!
    }
    
    func navigateToModifyExpensePage(rcpaObj :DCRRCPAModel)
    {
        let sb = UIStoryboard(name: chemistsSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier:AddChemsistRCPAVcID ) as!
        AddChemistRCPAViewController
        vc.dcrRCPAObj = rcpaObj
        vc.isComingFromModifyRCPA = true
        if let navigationController = self.navigationController
        {
            navigationController.popViewController(animated: false)
            navigationController.pushViewController(vc, animated: false)
        }
    }
    
    @IBAction func addExpenseBtnAction(_ sender: Any)
    {
        let sb = UIStoryboard(name:addExpenseDetailsSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: AddExpenseVcID)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func removeExpenseDetails(rcpaObj : DCRRCPAModel)
    {
       BL_DCR_Chemist_Visit.sharedInstance.deleteRCPADetails(dcrChemistVisitId: rcpaObj.DCR_Chemist_Visit_Id, productCode: rcpaObj.Product_Code!)
    }
    
    func showEmptyStateView(show: Bool)
    {
        self.emptyStateView.isHidden = !show
        self.contentView.isHidden  = show
    }
    
    func reloadTableView()
    {
        if self.uniqueDCRRCPAList.count > 0
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
