//
//  POBSalesProductsModifyListViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 21/04/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class POBSalesProductsModifyListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    //MARK:- IBOulet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateView : UIView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    
    //MARK:- variable
    var pobSalesModifyList : [DCRDoctorVisitPOBHeaderModel] = []
    
    //MARK:- View Controller LifeCycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 500
        addCustomBackButtonToNavigationBar()
        self.title = "Sales Products"
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        getSalesProductList()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK:- Table View Delegate
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return pobSalesModifyList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.POBSalesProductModifyCell, for: indexPath) as! ModifyAttendanceActivityTableViewCell
        let obj = pobSalesModifyList[indexPath.row]
        cell.activityNameLbl.text = obj.Stockiest_Name
        let productsCount = BL_POB_Stepper.sharedInstance.getNoOfProducts(orderEntryId: obj.Order_Entry_Id)
        let totalAmount = BL_POB_Stepper.sharedInstance.totalAmountcalculation(orderEntryId: obj.Order_Entry_Id)
        cell.activityTimeLbl.text = "No Of Products: \(productsCount) | POB Amount: \(totalAmount)"
        if obj.Order_Status == Constants.OrderStatus.complete
        {
            cell.removeBtn.isHidden = true
            cell.modifyBtn.setTitle("VIEW", for: .normal)
        }
        else
        {
            cell.modifyBtn.setTitle("MODIFY", for: .normal)
            cell.removeBtn.setTitle("REMOVE", for: .normal)
            cell.removeBtn.isHidden = false
            cell.removeBtn.tag = index
        }
        cell.modifyBtn.tag = index
        
        return cell
    }
    
    @IBAction func modifyBtnAction(_ sender: UIButton)
    {
        let index = (sender as AnyObject).tag
        let obj = pobSalesModifyList[index!]
        BL_POB_Stepper.sharedInstance.orderEntryId = obj.Order_Entry_Id
        if obj.Order_Status == Constants.OrderStatus.complete
        {
            let sb = UIStoryboard(name: Constants.StoaryBoardNames.POBSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.POBDetailsVCID) as! POBDetailsViewController
            if let navigationController = self.navigationController
            {
                //navigationController.popViewController(animated: false)
                navigationController.pushViewController(vc, animated: false)
            }
        }
        else
        {
            navigateToModifyPage()
        }
       
    }
    
    //MARK:- Remove Button Action
    @IBAction func removeBtnAction(_ sender: UIButton)
    {
        let indexPath = (sender as AnyObject).tag
        let orderObj = pobSalesModifyList[indexPath!]
        if orderObj.Order_Status == Constants.OrderStatus.complete
        {
            AlertView.showAlertView(title: "Order", message: "Order is completed cannot be removed")
        }
        if orderObj.Order_Status == Constants.OrderStatus.inprogress
        {
            BL_POB_Stepper.sharedInstance.updatePOBHeaderOrderStatus(orderEntryId: orderObj.Order_Entry_Id!, orderStatus: 0)
        }
        
        let alertViewController = UIAlertController(title: nil, message: "Do you want to remove order detail?", preferredStyle: UIAlertControllerStyle.alert)
        alertViewController.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { alertAction in
            self.removeSalesDetails(orderEntryID :orderObj.Order_Entry_Id,orderStatus: orderObj.Order_Status)
            self.pobSalesModifyList.remove(at: indexPath!)
            self.getSalesProductList()
            self.checkModifyList()
            showToastView(toastText: "Order details removed successfully")
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        alertViewController.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: { alertAction in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    private func removeSalesDetails(orderEntryID :Int,orderStatus: Int)
    {
        if (orderStatus != Constants.OrderStatus.complete && orderStatus != Constants.OrderStatus.inprogress)
        {
            BL_POB_Stepper.sharedInstance.deletePOBRemarks(orderEntryId: orderEntryID)
            BL_POB_Stepper.sharedInstance.deletePOBDetails(orderEntryId: orderEntryID)
            BL_POB_Stepper.sharedInstance.deletePOBHeader(orderEntryId: orderEntryID)
        }
    }
    
    //MARK:- Private function
    
    func getSalesProductList()
    {
        let list = BL_POB_Stepper.sharedInstance.getPOBHeaderForDCRId(dcrId: DCRModel.sharedInstance.dcrId, visitId: DCRModel.sharedInstance.customerVisitId,customerEntityType: DCRModel.sharedInstance.customerEntityType)
        pobSalesModifyList = []
        pobSalesModifyList = list
        self.checkModifyList()
    }
    
    private func checkModifyList()
    {
        if pobSalesModifyList.count > 0
        {
            showEmptyStateView(show : false)
            reloadTableView()
        }
        else
        {
            showEmptyStateView(show : true)
        }
    }
    
    private func attributedTextForText(firstString : String , secondString : String) -> NSAttributedString
    {
        let attributedString = NSMutableAttributedString(string: firstString, attributes: [NSAttributedStringKey.font: UIFont(name: fontSemiBold, size: 15.0)!  , NSAttributedStringKey.foregroundColor : UIColor.darkGray])
        let secondString = NSMutableAttributedString(string:secondString, attributes:[NSAttributedStringKey.font: UIFont(name: fontRegular, size: 15.0)! , NSAttributedStringKey.foregroundColor : UIColor.darkGray])
        attributedString.append(secondString)
        return attributedString
    }
    
    private func showEmptyStateView(show : Bool)
    {
        if show == false
        {
            self.emptyStateView.isHidden = true
            self.tableView.isHidden = false
        }
        else
        {
            self.emptyStateView.isHidden = false
            self.emptyStateLabel.text = "No Order Details available"
            self.tableView.isHidden = true
        }
    }
    
    private func navigateToModifyPage()
    {
        let sb = UIStoryboard(name: Constants.StoaryBoardNames.POBSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.POBStepperVcID) as! POBStepperViewController
        vc.modify = true
        if let navigationController = self.navigationController
        {
            //navigationController.popViewController(animated: false)
            navigationController.pushViewController(vc, animated: false)
        }
    }
    
    private func reloadTableView()
    {
        self.tableView.reloadData()
    }
    
    //MARK:- Adding Back Button
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
    
    //MARK:-  Add Button Action
    @IBAction func barBtnAction(_ sender: Any)
    {
        BL_POB_Stepper.sharedInstance.orderEntryId = 0
        BL_POB_Stepper.sharedInstance.dueDate = Date()
        let sb = UIStoryboard(name: Constants.StoaryBoardNames.POBSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.POBStepperVcID) as! POBStepperViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
