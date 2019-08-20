//
//  POBDetailsViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 28/11/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class POBDetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- IBoutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- variable
    let sectionArray = ["\(appStockiest) Details","Due Date","Sale Product","Remarks","No of Products"]
    
    //MARK:- View Controller LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        BL_POB_Stepper.sharedInstance.getCurrentArray()
        self.navigationItem.title = " POB Order Details "
        addBackButtonView()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- TableView Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(sectionArray[section] == "Sale Product")
        {
            return (BL_POB_Stepper.sharedInstance.salesProduct?.count)!
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionCell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.POBSectionHeaderCell) as! POBSectionTableViewCell
        sectionCell.sectionTitleLabel.text = sectionArray[section]
        return sectionCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(indexPath.section == 0 || indexPath.section == 1)
        {
            return 40
        }
        else if(indexPath.section == 2)
        {
            let getSalesProductHeight = BL_POB_Stepper.sharedInstance.getSalesProductCellHeight(index: indexPath.row) - 20
            return getSalesProductHeight
        }
        else if(indexPath.section == 3)
        {
            let getRemarksHeight = BL_POB_Stepper.sharedInstance.getRemarksCellHeight()
            return getRemarksHeight
        }
        else
        {
            return 50
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(indexPath.section == 0)
        {
            let sectionCell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.POBDetailCell) as! POBDetailTableViewCell
            let stockiestObj = BL_POB_Stepper.sharedInstance.stockiestObj
            let stockiestName = stockiestObj?.Stockiest_Name
            sectionCell.detailsLabel.text = stockiestName
            return sectionCell
            
        }
        else if (indexPath.section == 1)
        {
            let sectionCell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.POBDetailCell) as! POBDetailTableViewCell
            sectionCell.detailsLabel.text = convertDateIntoString(date: BL_POB_Stepper.sharedInstance.dueDate!)
            return sectionCell
            
        }
        else if(indexPath.section == 2)
        {
            let sectionCell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.POBDetailCell) as! POBDetailTableViewCell
            let obj = BL_POB_Stepper.sharedInstance.salesProduct?[indexPath.row]
            let str:String! = "ProductName: \(obj!.Product_Name!)\n UnitRate: \( obj!.Product_Unit_Rate!)|| Quantity: \(obj!.Product_Qty!)\n Amount: \(obj!.Product_Amount!)"
            sectionCell.detailsLabel.text = str
            return sectionCell
            
        }
        else if(indexPath.section == 3)
        {
            let sectionCell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.POBDetailCell) as! POBDetailTableViewCell
            sectionCell.detailsLabel.text = BL_POB_Stepper.sharedInstance.remarks
            return sectionCell
        }
        else
        {
            let sectionCell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.POBAmountDetailsCell) as! POBAmountDetailTableViewCell
            var count :Int!
            var amount: Double!
            count = BL_POB_Stepper.sharedInstance.salesProduct?.count
            sectionCell.productsCountLabel.text = "\(count!)"
            amount = BL_POB_Stepper.sharedInstance.totalAmountcalculation(orderEntryId: BL_POB_Stepper.sharedInstance.orderEntryId)
            sectionCell.amountLabel.text = "\(amount!)"
            return sectionCell
        }
        
    }
    
    //MARK:- Adding Custom Back Button
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
