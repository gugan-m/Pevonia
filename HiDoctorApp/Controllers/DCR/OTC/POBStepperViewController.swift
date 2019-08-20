//
//  POBStepperViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 19/04/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit


struct StepperPOBIndex
{
    static let StockiestIndex : Int = 0
    static let DueDateIndex : Int = 1
    static let POBSalesIndex : Int = 2
    static let RemarksIndex : Int = 3
}

class POBStepperViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,selectedStockiestListDelegate
{
    //MARK:- IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitViewHgtConst: NSLayoutConstraint!
    
    // MARK:- Variables
    var stepperDataList: [StepperPOBModel] = []
    var dueDatePicker : UIDatePicker!
    var isResignTextField : Bool = false
    var modify : Bool = false
    
    //MARK:- View Controller LifeCycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        addCustomBackButtonToNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationItem.title = "POB Sales"
        BL_POB_Stepper.sharedInstance.getCurrentArray()
        reloadTableView()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:-- Reload Functions
    private func reloadTableView()
    {
        tableView.reloadData()
        if BL_POB_Stepper.sharedInstance.salesProduct != nil
        {
            if (BL_POB_Stepper.sharedInstance.salesProduct?.count)! > 0
            {
                self.submitViewHgtConst.constant = 40
            }
            else
            {
                self.submitViewHgtConst.constant = 0
            }
        }
        else
        {
            self.submitViewHgtConst.constant = 0
        }
    }
    
    private func reloadTableViewAtIndexPath(index: Int)
    {
        let indexPath: NSIndexPath = NSIndexPath(row: index, section: 0)
        
        tableView.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.fade)
    }
    
    
    // MARK:- Table View Delegates
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return BL_POB_Stepper.sharedInstance.stepperDataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let stepperObj = BL_POB_Stepper.sharedInstance.stepperDataList[indexPath.row]
        let index = indexPath.row
        
        if (stepperObj.recordCount == 0)
        {
            return BL_POB_Stepper.sharedInstance.getEmptyStateHeight(selectedIndex: index)
        }
        else
        {
            if (index == StepperPOBIndex.StockiestIndex || index == StepperPOBIndex.DueDateIndex)
            {
                return BL_POB_Stepper.sharedInstance.getStockiestsOrDueDateCellHeight(selectedIndex:index)
            }
            else if (index == StepperPOBIndex.POBSalesIndex)
            {
                return BL_POB_Stepper.sharedInstance.getCommonCellHeight(selectedIndex: index)
            }
            else if (index == StepperPOBIndex.RemarksIndex)
            {
                return BL_POB_Stepper.sharedInstance.getGeneralRemarksCellHeight(selectedIndex: index)
            }
            else
            {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.POBStepperMainCell) as! POBStepperTableViewCell
        
        // Round View
        cell.roundView.layer.cornerRadius = 12.5
        cell.roundView.layer.masksToBounds = true
        cell.stepperNumberLabel.text = String(indexPath.row + 1)
        
        // Vertical view
        cell.verticalView.isHidden = false
        
        if (indexPath.row == BL_POB_Stepper.sharedInstance.stepperDataList.count - 1)
        {
            cell.verticalView.isHidden = true
        }
        
        let rowIndex = indexPath.row
        let objStepperModel: StepperPOBModel = BL_POB_Stepper.sharedInstance.stepperDataList[rowIndex]
        
        cell.selectedIndex = rowIndex
        
        cell.cardView.isHidden = true
        cell.emptyStateView.isHidden = true
        cell.emptyStateView.clipsToBounds = true
        cell.stockiestsView.isHidden = true
        cell.dueDateView.isHidden = true
        cell.pobAmtHeightonst.constant = 0
        cell.pobAmtView.isHidden = true
        
        if (objStepperModel.recordCount == 0)
        {
            if indexPath.row == StepperPOBIndex.StockiestIndex
            {
                cell.sectionTitleLabel.text = objStepperModel.sectionTitle
                cell.roundView.backgroundColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1.0)
                cell.emptyStateView.isHidden = true
                cell.stockiestsView.isHidden = false
                let stockiestName = "SELECT \(appStockiest.uppercased())"
                cell.stockiestNameLbl.text = stockiestName
                cell.stockiestsSectionTitleLAbel.text = objStepperModel.sectionTitle
                
            }
            else
            {
                cell.emptyStateSectionTitleLabel.text = objStepperModel.emptyStateTitle
                cell.emptyStateSubTitleLabel.text = objStepperModel.emptyStateSubTitle
                
                
                cell.emptyStateAddButton.isHidden = !objStepperModel.showEmptyStateAddButton
                
                
                cell.emptyStateView.isHidden = false
                cell.cardView.isHidden = true
                cell.cardView.clipsToBounds = true
                
                cell.roundView.backgroundColor = UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1)
            }
        }
        else if objStepperModel.recordCount > 0
        {
            cell.sectionTitleLabel.text = objStepperModel.sectionTitle
            cell.roundView.backgroundColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1.0)
            cell.emptyStateView.isHidden = true
            
            if indexPath.row == StepperPOBIndex.StockiestIndex
            {
                cell.stockiestsView.isHidden = false
                let stockiestObj = BL_POB_Stepper.sharedInstance.stockiestObj
                let stockiestName = stockiestObj?.Stockiest_Name
                cell.stockiestNameLbl.text = stockiestName
                cell.stockiestsSectionTitleLAbel.text = objStepperModel.sectionTitle
                
            }
            else if indexPath.row == StepperPOBIndex.DueDateIndex
            {
                cell.dueSectionTitleLabel.text = objStepperModel.sectionTitle
                cell.dueDateView.isHidden = false
                setDueDatePicker(textField: cell.dueDateTxtField)
                setPlaceHolderForFromTxtFld(textField: cell.dueDateTxtField)
                
                let dueDate = BL_POB_Stepper.sharedInstance.dueDate
                
                cell.dueDateTxtField.text = convertDateIntoString(date: dueDate!)
                setDefaultRowinDatePicker(dueDate : dueDate)
                
                if isResignTextField
                {
                    cell.dueDateTxtField.resignFirstResponder()
                }
            }
            else
            {
                cell.cardView.isHidden = false
                cell.cardView.clipsToBounds = false
                cell.sectionTitleImageView.image = UIImage(named: objStepperModel.sectionIconName)
                
                cell.rightButton.isHidden = !objStepperModel.showRightButton
                cell.leftButton.isHidden = !objStepperModel.showLeftButton
                
                cell.parentTableView = tableView
                cell.childTableView.reloadData()
                cell.commonSectionTitleHeightConstraint.constant = 30
                
                if indexPath.row == StepperPOBIndex.POBSalesIndex
                {
                    cell.pobAmtHeightonst.constant = 60
                    cell.pobAmtView.isHidden = false
                    let count = BL_POB_Stepper.sharedInstance.getNoOfProducts(orderEntryId: BL_POB_Stepper.sharedInstance.orderEntryId)
                    cell.noOfProductsLbl.text = "No of Products\n\(count)"
                    let totalAmount = BL_POB_Stepper.sharedInstance.totalAmountcalculation(orderEntryId: BL_POB_Stepper.sharedInstance.orderEntryId)
                    cell.productsAmtLbl.text = "Amount\n\(totalAmount)"
                }
            }
        }
        
        cell.sectionToggleImageView.isHidden = true
        cell.sectionToggleImageView.clipsToBounds = true
        
        if (objStepperModel.recordCount > 1)
        {
            if (objStepperModel.isExpanded == true)
            {
                cell.sectionToggleImageView.image = UIImage(named: "icon-stepper-up-arrow")
            }
            else
            {
                cell.sectionToggleImageView.image = UIImage(named: "icon-stepper-down-arrow")
            }
            
            cell.sectionToggleImageView.isHidden = false
            cell.sectionToggleImageView.clipsToBounds = false
        }
        
        cell.moreView.isHidden = true
        cell.moreView.clipsToBounds = true
        cell.moreViewHeightConstraint.constant = 0
        cell.bottomViewHeight.constant = 20
        
        if indexPath.row == 2 || indexPath.row == 3
        {
            if (objStepperModel.isExpanded == false && objStepperModel.recordCount > 1)
            {
                cell.moreView.isHidden = false
                cell.moreView.clipsToBounds = false
                cell.moreViewHeightConstraint.constant = 20
            }
        }
        
        cell.sectionCoverButton.tag = rowIndex
        cell.leftButton.tag = rowIndex
        cell.rightButton.tag = rowIndex
        cell.emptyStateAddButton.tag = rowIndex
        return cell
    }
    
    //MARK:- Button Action
    
    @IBAction func submitBtnAction(_ sender: UIButton)
    {
        _ = navigationController?.popViewController(animated: false)
    }
    
    
    @IBAction func expandBtnAction(_ sender: UIButton)
    {
        let index = sender.tag
        let stepperObj = BL_POB_Stepper.sharedInstance.stepperDataList[index]
        
        if (stepperObj.recordCount > 1)
        {
            stepperObj.isExpanded = !stepperObj.isExpanded
            reloadTableViewAtIndexPath(index: index)
        }
        
    }
    
    @IBAction func emptyStateAddBtnAction(_ sender: UIButton)
    {
        let index = sender.tag
        if index == StepperPOBIndex.POBSalesIndex
        {
            let sb = UIStoryboard(name: detailProductSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: DetailProductVcID) as!
            DetailedProductViewController
            vc.isFromPOB = true
            self.navigationController?.pushViewController(vc,animated: true)
        }
        else if index == StepperPOBIndex.RemarksIndex
        {
            let sb = UIStoryboard(name: Constants.StoaryBoardNames.POBSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.POBRemarksVCID) as!
            POBRemarksViewController
            self.navigationController?.pushViewController(vc,animated: true)
        }
        else
        {
            let sb = UIStoryboard(name: stockiestsSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: StockiestsListVcID) as! StockiestsListViewController
            vc.isFromPOB = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func addBtnAction(_ sender: UIButton)
    {
        let index = sender.tag
        if index == StepperPOBIndex.POBSalesIndex
        {
            let sb = UIStoryboard(name: detailProductSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: DetailProductVcID) as!
            DetailedProductViewController
            vc.isFromPOB = true
            vc.orderEntryId = BL_POB_Stepper.sharedInstance.orderEntryId
            self.navigationController?.pushViewController(vc,animated: true)
        }
    }
    
    @IBAction func ModifyBtnAction(_ sender: UIButton)
    {
        let index = sender.tag
        if index == StepperPOBIndex.POBSalesIndex
        {
            let sb = UIStoryboard(name: Constants.StoaryBoardNames.POBSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.POBSalesProductVcID) as! POBSalesProductViewController
            vc.isComingFromModify = true
            self.navigationController?.pushViewController(vc,animated: true)
        }
        else
        {
            let sb = UIStoryboard(name: Constants.StoaryBoardNames.POBSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.POBRemarksVCID) as!
            POBRemarksViewController
            vc.isComingFromModify = true
            self.navigationController?.pushViewController(vc,animated: true)
        }
    }
    
    @IBAction func addStockiestBtnAction(_ sender: UIButton)
    {
        if modify == true
        {
            let sb = UIStoryboard(name: stockiestsSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: StockiestsListVcID) as! StockiestsListViewController
            vc.isFromPOB = true
            vc.isFromModify = true
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let sb = UIStoryboard(name: stockiestsSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: StockiestsListVcID) as! StockiestsListViewController
            vc.isFromPOB = true
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    private func setDueDatePicker(textField : UITextField)
    {
        self.isResignTextField = false
        dueDatePicker = getDatePickerView()
        dueDatePicker.minimumDate = DCRModel.sharedInstance.dcrDate
        
        let doneToolbar = getToolBar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        doneToolbar.sizeToFit()
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(POBStepperViewController.dueDatePickerDoneAction))
        let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(POBStepperViewController.cancelBtnClicked))
        
        doneToolbar.items = [flexSpace, done, cancel]
        
        textField.inputAccessoryView = doneToolbar
        textField.inputView = dueDatePicker
    }
    
    @objc func dueDatePickerDoneAction()
    {
        //BL_POB_Stepper.sharedInstance.dueDate = dueDatePicker.date
        let dateString = getServerFormattedDateString(date: dueDatePicker.date)
        if BL_POB_Stepper.sharedInstance.orderEntryId != nil && BL_POB_Stepper.sharedInstance.orderEntryId != 0
        {
            BL_POB_Stepper.sharedInstance.updateDueDateInPOBHeader(dueDate: dateString, orderEntryId: BL_POB_Stepper.sharedInstance.orderEntryId)
            let obj = BL_POB_Stepper.sharedInstance.getPOBHeaderforOrderEntryId(orderEntryID: BL_POB_Stepper.sharedInstance.orderEntryId)
             BL_POB_Stepper.sharedInstance.dueDate = obj.Order_Due_Date
        }
        self.isResignTextField = true
        reloadTableViewAtIndexPath(index: 1)
    }
    
    @objc func cancelBtnClicked()
    {
        self.isResignTextField = true
        reloadTableViewAtIndexPath(index: 1)
    }
    
    private func setPlaceHolderForFromTxtFld(textField : UITextField)
    {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.image = UIImage(named: "icon-calendar")
        imageView.contentMode = UIViewContentMode.center
        imageView.tintColor = UIColor.lightGray
        textField.leftView = imageView
        textField.leftViewMode = UITextFieldViewMode.always
    }
    
    private func setDefaultRowinDatePicker(dueDate : Date?)
    {
        if dueDate != nil
        {
            dueDatePicker.setDate(dueDate!, animated: false)
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
    
    func selectedStockiestListDelegate(modify : Bool)
    {
        self.modify = modify
    }
}
