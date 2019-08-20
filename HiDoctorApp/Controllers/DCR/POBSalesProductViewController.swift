//
//  POBSalesProductViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 24/04/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit


class POBSalesProductViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate
{
    //MARK:- IBOutlet
    @IBOutlet weak var noOfProductsLbl: UILabel!
    @IBOutlet weak var totalAmtLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var totalAmountValue: UILabel!
    @IBOutlet weak var noofProductsCount: UILabel!
    @IBOutlet weak var productCountViewHeight: NSLayoutConstraint!
    @IBOutlet weak var submitViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var submitBtn: UIButton!
    //MARK:- Variable
    var salesProductList : [DCRDoctorVisitPOBDetailsModel] = []
    var placeholder: String = "0.0"
    var isResignTxtField : Bool = false
    var amount:Double = 0.0
    var totalAmount:Double = 0.0
    var isComingFromModify:Bool = false
    var submitflag: Bool = false
    var productQuanity:NSMutableArray = []
    
    //MARK:- View Controller Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "Sale Products"
        addBackButtonView()
        self.updateList()
        self.tableView.estimatedRowHeight = 500
        self.noOfProductsLbl.text = "No of products : "
        self.noofProductsCount.text = "\(salesProductList.count)"
        self.updateTotalAmount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Sale Products"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Table View Delegate
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return salesProductList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.POBSalesProductCell, for: indexPath) as! POBSalesProductTableViewCell
        let obj = salesProductList[indexPath.row]
        let index = indexPath.row
        cell.productNameLbl.text = obj.Product_Name
        cell.unitRateLbl.text = String(obj.Product_Unit_Rate!)
        if obj.Product_Amount != nil
        {
            cell.amountLbl.text = String(describing: obj.Product_Amount!)
        }
        else
        {
            cell.amountLbl.text = "0.0"
        }
        if obj.Product_Qty != nil
        {
            let qty = Double(obj.Product_Qty)
            cell.productQtyTxtField.text = String(qty)
        }
        else
        {
            cell.productQtyTxtField.text = "0.0"
            cell.productQtyTxtField.textColor = UIColor.lightGray
            
        }
        
        cell.productQtyTxtField.tag = index
        cell.productQtyTxtField.delegate = self
        cell.removeBtn.tag = index
        //cell.productQtyTxtField.addTarget(self, action: #selector(getProductQuantity(index:)), for: .editingDidEnd)
        addToolbarToTextFld(textField: cell.productQtyTxtField)
        return cell
    }
    
    func getProductQuantity(index: UITextField)
    {
        
    }
    //MARK:- Remove Button Action
    @IBAction func removeProductBtnAction(_ sender: Any)
    {
        let index  = (sender as AnyObject).tag
        let saleProductObj = salesProductList[index!]
        if isComingFromModify == true
        {
            BL_POB_Stepper.sharedInstance.deletePOBDetailsForOrderDetailId(orderEntryId: saleProductObj.Order_Entry_Id, orderDetailId: saleProductObj.Order_Detail_Id)
            self.updateTotalAmountForDelete(index: index!)
            self.tableView.reloadData()
        }
        else
        {
            self.updateTotalAmountForDelete(index: index!)
            self.tableView.reloadData()
        }
        if salesProductList.count == 0
        {
            self.showEmptyStateView(show : true)
        }
    }
    
    //MARK:- Submit button action
    @IBAction func submitBtnAction(_ sender : UIButton)
    {
        self.submitValidation()
        self.popVCs()
    }
    
    //MARK:- TextField delegates
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        if textField.text == placeholder
        {
            textField.textColor = UIColor.black
            textField.text = nil
        }
//        self.tableView.scrollToRow(at: IndexPath(row: textField.tag, section: 0), at: .top, animated: true)
    
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let decimalPlacesLimit = 2
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            return true
        }
        
        let dotArray = textField.text?.components(separatedBy: ".")
        print(textField.tag)
        
        if (dotArray?.count)! > 2
        {
            AlertView.showAlertView(title: alertTitle, message: "Please enter valid quantity", viewController: self)
            return false
            
        }
        else if isValidNumberForPobAmt(string: string)
        {
            if (dotArray?.count)! > 1
            {
                print(string)
                let decimalPart = dotArray![1]
                if (decimalPart.count > decimalPlacesLimit)
                {
                    AlertView.showAlertView(title: alertTitle, message: "Please enter valid quantity", viewController: self)
                    return false
                }
            }
            return true
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        print(textField.tag)
        self.getTextFieldTag(textField: textField)
        print(salesProductList[textField.tag].Product_Qty)
        print(salesProductList[textField.tag].Product_Amount)
        //let indexPath = IndexPath(row: textField.tag, section: 0)
//        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    
    func getTextFieldTag(textField: UITextField)
    {
        if ((textField.text!.count) > 0) && (textField.text! != "0") && (textField.text! != placeholder)
        {
            if (salesProductList.count > textField.tag)
            {
                let obj = salesProductList[textField.tag]
                if obj.Product_Qty != nil && obj.Product_Amount != nil
                {
                    totalAmount = totalAmount - (obj.Product_Unit_Rate * obj.Product_Qty)
                    obj.Product_Qty = 0
                    obj.Product_Amount = 0.0
                }
                amount = obj.Product_Unit_Rate * Double(textField.text!)!
                salesProductList[textField.tag].Product_Qty = Double(textField.text!)
                salesProductList[textField.tag].Product_Amount = amount
                self.totalAmountCalc()
            }
        }
        else
        {
            if (salesProductList.count > textField.tag)
            {
                let obj = salesProductList[textField.tag]
                if obj.Product_Qty != nil
                {
                    amount = obj.Product_Amount
                    totalAmount = totalAmount - amount
                    amount = 0.0
                    salesProductList[textField.tag].Product_Qty = 0
                    salesProductList[textField.tag].Product_Amount = amount
                    obj.Product_Amount = amount
                    self.totalAmountCalc()
                }
            }
        }
    }
    
    //MARK:- Addind DoneToolBar
    private func addToolbarToTextFld(textField : UITextField)
    {
        isResignTxtField = false
        let doneToolbar = getToolBar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        doneToolbar.sizeToFit()
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(POBSalesProductViewController.doneBtnClicked(sender: )))
        done.tag = textField.tag
        doneToolbar.items = [flexSpace, done]
        
        textField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneBtnClicked(sender: UIBarButtonItem)
    {
        let index = sender.tag
        let indexPath = IndexPath(row: index, section: 0)
        let cell: POBSalesProductTableViewCell = self.tableView.cellForRow(at: indexPath) as! POBSalesProductTableViewCell
        self.getTextFieldTag(textField: cell.productQtyTxtField)
        self.tableView.reloadRows(at: [indexPath], with: .none)
        self.view.endEditing(true)
    }
    
    //MARK:- Total Amount Calaculation and updation
    func updateTotalAmount()
    {
        if isComingFromModify
        {
            salesProductList = BL_POB_Stepper.sharedInstance.getPOBDetailsForOrderEntryId(orderEntryID: BL_POB_Stepper.sharedInstance.orderEntryId)
        }
        if salesProductList.count > 0
        {
            for obj in salesProductList
            {
                totalAmount += obj.Product_Amount ?? 0.0
            }
            self.totalAmtLbl.text = "Amount:"
            self.totalAmountValue.text = (String(totalAmount))
        }
    }
    
    func updateTotalAmountForDelete(index: Int)
    {
        if salesProductList.count > 0
        {
            let obj = self.salesProductList[index]
            if obj.Product_Amount != nil && obj.Product_Amount != 0.0
            {
                self.totalAmount = totalAmount - obj.Product_Amount
            }
            salesProductList.remove(at: index)
            self.totalAmount = 0.0
            self.updateTotalAmount()
            self.noofProductsCount.text = String(salesProductList.count)
        }
    }
    
    func totalAmountCalc()
    {
        if totalAmount == 0.0
        {
            totalAmount = amount
            self.totalAmtLbl.text = "Amount:"
            self.totalAmountValue.text = (String(totalAmount))
        }
        else
        {
            totalAmount = totalAmount + amount
            self.totalAmtLbl.text = "Amount:"
            self.totalAmountValue.text = (String(totalAmount))
        }
    }
    
    //MARK:- Validation Function
    func submitValidation()
    {
        for i in 0 ..< self.salesProductList.count
        {
            if(salesProductList[i].Product_Qty != nil && salesProductList[i].Product_Qty != 0 && salesProductList[i].Product_Qty != 0.0)
            {
                if(i == self.salesProductList.count-1)
                {
                    if isComingFromModify
                    {
                        BL_POB_Stepper.sharedInstance.deletePOBDetails(orderEntryId: BL_POB_Stepper.sharedInstance.orderEntryId)
                        BL_POB_Stepper.sharedInstance.insertPOBDetails(detailedProductList: salesProductList)
                    }
                    else
                    {
                        BL_POB_Stepper.sharedInstance.insertPOBDetails(detailedProductList: salesProductList)
                    }
                    
                    self.submitflag = true
                    
                }
                
            }
            else
            {
                AlertView.showAlertView(title: alertTitle, message: "Please enter quantity of product", viewController: self)
                break
            }
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
        if submitflag == true
        {
            self.popVCs()
        }
        else
        {
            self.submitValidation()
            self.popVCs()
        }
        
    }
    func popVCs()
    {
        _ = navigationController?.popViewController(animated: false)
        
    }
    
    //MARK:- Get Updated list
    func updateList()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(POBSalesProductViewController.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(POBSalesProductViewController.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        if isComingFromModify
        {
            self.salesProductList = BL_POB_Stepper.sharedInstance.getPOBDetailsForOrderEntryId(orderEntryID: BL_POB_Stepper.sharedInstance.orderEntryId)
            self.updateEmptyState()
        }
        else
        {
            self.updateEmptyState()
        }
    }
    
    //MARK:- Functions for updating views
    private func showEmptyStateView(show : Bool)
    {
        if show == false
        {
            self.emptyStateView.isHidden = true
            self.tableView.isHidden = false
            self.productCountViewHeight.constant = 60
            self.submitViewHeight.constant = 40
            self.submitBtn.isHidden = false
            
        }
        else
        {
            self.emptyStateView.isHidden = false
            self.emptyStateLabel.text = "No Sale Products found"
            self.tableView.isHidden = true
            self.productCountViewHeight.constant = 0
            self.submitViewHeight.constant = 0
            self.submitBtn.isHidden = true
        }
    }
    
    private func updateEmptyState()
    {
        if self.salesProductList.count == 0
        {
            self.showEmptyStateView(show : true)
        }
        else
        {
            self.reloadTableView()
        }
    }
    
    //MARK:- Keyboard Action
    @objc func keyboardWillShow(notification: NSNotification)
    {
        if ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil
        {
            //self.view.frame.origin.y -= keyboardSize.height
            var userInfo = notification.userInfo!
            var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            keyboardFrame = self.view.convert(keyboardFrame, from: nil)
            
            var contentInset:UIEdgeInsets = self.tableView.contentInset
            contentInset.bottom = keyboardFrame.size.height
            self.tableView.contentInset = contentInset
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        let contentInsets = UIEdgeInsets.zero
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
        self.reloadTableView()
    }
    
    private func reloadTableView()
    {
        _ = CGPoint(x: 0, y: 0)
        
        self.tableView.setContentOffset(CGPoint.zero, animated: false)
        self.tableView.reloadData()
    }
    
}
