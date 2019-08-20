//
//  POBStepperTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 20/04/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class POBStepperTableViewCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource
{
    //MARK:- @IBOutlet
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var verticalView: UIView!
    @IBOutlet weak var stepperNumberLabel: UILabel!
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var sectionTitleImageView: UIImageView!
    @IBOutlet weak var dueSectionTitleLabel: UILabel!
    @IBOutlet weak var stockiestsSectionTitleLAbel: UILabel!
    @IBOutlet weak var moreLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var stockiestsView: UIView!
    @IBOutlet weak var dueDateView: UIView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var emptyStateSectionTitleLabel: UILabel!
    @IBOutlet weak var emptyStateSubTitleLabel: UILabel!
    @IBOutlet weak var emptyStateAddButton: UIButton!
    @IBOutlet weak var childTableView: UITableView!
    @IBOutlet weak var sectionTitleView: UIView!
    @IBOutlet weak var sectionToggleImageView: UIImageView!
    @IBOutlet weak var moreView: UIView!
    @IBOutlet weak var sectionCoverButton: UIButton!
    @IBOutlet weak var moreViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var commonSectionTitleHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dueDateTxtField: TextField!
    @IBOutlet weak var stockiestNameLbl: UILabel!
    @IBOutlet weak var pobAmtHeightonst: NSLayoutConstraint!
    @IBOutlet weak var pobAmtView: UIView!
    @IBOutlet weak var noOfProductsLbl: UILabel!
    @IBOutlet weak var productsAmtLbl: UILabel!
    
    //MARK:- Variable
    var selectedIndex: Int!
    var parentTableView: UITableView!
    
    //MARK:- Lifecycle
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
    }
    
    // MARK:- Table View Delegates
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {

        let stepperObj = BL_POB_Stepper.sharedInstance.stepperDataList[self.selectedIndex]
        
        if (stepperObj.recordCount == 0)
        {
            return 0
        }
        else
        {
            if selectedIndex == StepperPOBIndex.StockiestIndex || selectedIndex == StepperPOBIndex.DueDateIndex
            {
                return 0
            }
            else
            {
                if (stepperObj.isExpanded == false)
                {
                    return 1
                }
                else
                {
                    return stepperObj.recordCount
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (selectedIndex == StepperPOBIndex.POBSalesIndex)
        {
            return BL_POB_Stepper.sharedInstance.getCommonSingleCellHeight(selectedIndex: selectedIndex)
        }
        else if (selectedIndex == StepperPOBIndex.RemarksIndex)
        {
            return BL_POB_Stepper.sharedInstance.getGeneralRemarksSingleCellHeight(selectedIndex: selectedIndex)
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (selectedIndex == StepperPOBIndex.POBSalesIndex)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier:Constants.TableViewCellIdentifier.POBStepperSubCell) as! DCRAttendanceSubTableViewCell
            let obj = BL_POB_Stepper.sharedInstance.salesProduct?[indexPath.row]
            
            var qty = "0.0"
            var amount = "0.0"
            
            if obj?.Product_Qty != nil
            {
               qty = String(format: "%.2f", (obj?.Product_Qty)!)
            }
            
            if obj?.Product_Amount != nil
            {
                amount = String(format: "%.2f", (obj?.Product_Amount)!)
            }
            
            let line1Text: String = (obj?.Product_Name)!
            let line2Text: String = "Qty: \(qty) | Amount: \(amount) "
            
            cell.line1Label.text = line1Text
            cell.line2Label.text = line2Text
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.POBStepperRemarksCell) as! DCRStepperRemarksTableViewCell
            
            if (BL_POB_Stepper.sharedInstance.remarks == EMPTY || BL_POB_Stepper.sharedInstance.remarks == nil)
            {
                cell.line1Label.text = NA
            }
            else
            {
            cell.line1Label.text = BL_POB_Stepper.sharedInstance.remarks
            }
            cell.line2Label.text = EMPTY
            
            return cell
        }
    }
    
}
