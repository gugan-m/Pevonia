//
//  ChemistDayStepperMain.swift
//  HiDoctorApp
//
//  Created by Vijay on 21/11/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class ChemistDayStepperMain: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    
    // MARK:- Outlets
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var verticalView: UIView!
    @IBOutlet weak var stepperNumberLabel: UILabel!
    @IBOutlet weak var sectionTitleImageView: UIImageView!
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var sectionToggleImageView: UIImageView!
    @IBOutlet weak var moreLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var coverButtonView: UIView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var emptyStateSectionTitleLabel: UILabel!
    @IBOutlet weak var emptyStateSubTitleLabel: UILabel!
    @IBOutlet weak var emptyStateAddButton: UIButton!
    @IBOutlet weak var emptyStateSkipButton: UIButton!
    @IBOutlet weak var childTableView: UITableView!
    @IBOutlet weak var sectionTitleView: UIView!
    @IBOutlet weak var moreView: UIView!
    @IBOutlet weak var sectionCoverButton: UIButton!
    @IBOutlet weak var moreViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonViewHeight: NSLayoutConstraint!
    @IBOutlet weak var commonSectionTitleHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var accompEmptyStateView: UIView!
    @IBOutlet weak var accompEmptyLbl: UILabel!
    @IBOutlet weak var coverBtnWidthConst: NSLayoutConstraint!
    @IBOutlet weak var btmSepView: UIView!
    
    
    var selectedIndex: Int!
    var stepperObj: DCRStepperModel!
    var parentTableView: UITableView!
    let stepperIndex = BL_Common_Stepper.sharedInstance.stepperIndex
    var isFromActivity =  Bool()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.childTableView.delegate = self
        self.childTableView.dataSource = self
        self.childTableView.register(UINib(nibName: Constants.NibNames.CommonTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.TableViewCellIdentifier.CommonCell)
        self.childTableView.register(UINib(nibName: Constants.NibNames.CommonSingleLineTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.TableViewCellIdentifier.CommonCell1)
        self.childTableView.register(UINib(nibName: Constants.NibNames.AccompanistCommonTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.TableViewCellIdentifier.AccompanistCommonCell)
        self.childTableView.register(UINib(nibName: Constants.NibNames.VisitCell, bundle: nil), forCellReuseIdentifier: Constants.TableViewCellIdentifier.VisitCell)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // MARK:- Table View Delegates
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if selectedIndex == stepperIndex.sampleIndex
        {
            stepperObj = BL_Common_Stepper.sharedInstance.stepperDataList[self.selectedIndex]
            
            if (stepperObj.recordCount == 0)
            {
                return 0
            }
            else
            {
                return stepperObj.recordCount
            }
        }
        else
        {
        return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(isFromActivity)
        {
            stepperObj = BL_Activity_Stepper.sharedInstance.stepperDataList[self.selectedIndex]
            if (stepperObj.recordCount == 0)
            {
                return 0
            }
            else
            {
                return stepperObj.recordCount
            }
        }
        else
        {
            stepperObj = BL_Common_Stepper.sharedInstance.stepperDataList[self.selectedIndex]
            
            if (stepperObj.recordCount == 0)
            {
                return 0
            }
            else
            {
                if (stepperObj.isExpanded == false && selectedIndex != stepperIndex.detailedProduct)
                {
                    return 1
                }
                else
                {
                    if selectedIndex == stepperIndex.sampleIndex
                    {
                        return BL_Common_Stepper.sharedInstance.sampleList[section].chemistSamplePromotion.count
                    }
                    else
                    {
                        return stepperObj.recordCount
                    }
                }
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(isFromActivity)
        {
            if selectedIndex == 0
            {
              return BL_Activity_Stepper.sharedInstance.getDoctorVisitSampleSingleHeight(selectedIndex: indexPath.row, parentIndex: selectedIndex)
            }
            else
            {
               return BL_Activity_Stepper.sharedInstance.getDoctorVisitSampleSingleHeight(selectedIndex: indexPath.row, parentIndex: selectedIndex)
            }
        }
        else
        {
            if selectedIndex == stepperIndex.doctorVisitIndex
            {
                return BL_Common_Stepper.sharedInstance.getDoctorVisitDetailSingleHeight()
                
            }
            else if selectedIndex == stepperIndex.accompanistIndex
            {
                return BL_Common_Stepper.sharedInstance.getAccompanistSingleCellHeight(selectedIndex: indexPath.row)
            }
            else if  selectedIndex == stepperIndex.chemistIndex || selectedIndex == stepperIndex.followUpIndex || selectedIndex == stepperIndex.pobIndex || selectedIndex == stepperIndex.rcpaDetailIndex
            {
                return BL_Common_Stepper.sharedInstance.getDoctorVisitSampleSingleHeight(selectedIndex: indexPath.row, parentIndex: selectedIndex)
            }
            else if selectedIndex == stepperIndex.sampleIndex
            {
                return BL_Common_Stepper.sharedInstance.getSampleBatchSingleHeight(section: indexPath.section, row: indexPath.row)
            }
            else if selectedIndex == stepperIndex.detailedProduct || selectedIndex == stepperIndex.attachmentIndex
            {
                return BL_Common_Stepper.sharedInstance.getCommonSingleCellHeight(selectedIndex: indexPath.row, parentIndex: selectedIndex)
            }
            else if (selectedIndex == stepperIndex.assetIndex && stepperIndex.assetIndex != 0)
            {
                return BL_Common_Stepper.sharedInstance.getAssetSingleHeight(selectedIndex: indexPath.row)
            }
            else
            {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor.white
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(selectedIndex == stepperIndex.sampleIndex)
        {
            return 40
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(selectedIndex == stepperIndex.sampleIndex)
        {
            return BL_Common_Stepper.sharedInstance.sampleList[section].title
        }
        else
        {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var outputCell: UITableViewCell = UITableViewCell()
        
        if(isFromActivity)
        {
            if selectedIndex == 0
            {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.CommonCell) as! DoctorVisitSampleCell
           
                let modelObj = BL_Activity_Stepper.sharedInstance.callTypeList[indexPath.row]
                cell.line1.text = modelObj.Customer_Activity_Name
                cell.line2.text = "Remarks" + "\n" + modelObj.Activity_Remarks
                
                outputCell = cell
            }
            else if selectedIndex == 1
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.CommonCell) as! DoctorVisitSampleCell
                
                let modelObj = BL_Activity_Stepper.sharedInstance.mcActivityList[indexPath.row]
                let mcName = modelObj.Campaign_Name
                let activityname = modelObj.MC_Activity_Name
                cell.line1.text = mcName! + "\n" + activityname!
                cell.line2.text = "Remarks" + "\n" + modelObj.MC_Activity_Remarks
                
                outputCell = cell
            }
        }
        else
        {
            if selectedIndex == stepperIndex.doctorVisitIndex
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.VisitCell) as! DoctorVisitDetailCell
                let model = BL_Common_Stepper.sharedInstance.chemistVisitList[indexPath.row]
                
                if model.VisitTime != ""
                {
                    cell.visitMode.text = "Visit Time"
                    if( model.VisitTime.contains("AM") || model.VisitTime.contains("PM"))
                    {
                        cell.visitModeLabel.text = model.VisitTime
                    }
                    else
                    {
                        cell.visitModeLabel.text = model.VisitTime + " " + model.VisitMode
                    }
                }
                else if model.VisitMode != ""
                {
                    cell.visitMode.text = "Visit Mode"
                    cell.visitModeLabel.text = model.VisitMode
                }
                
                cell.remarks.text = "Remarks"
                cell.remarkslabel.text = model.Remarks
                
                return cell
            }
            else if (selectedIndex == stepperIndex.accompanistIndex && stepperIndex.accompanistIndex != 0)
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.AccompanistCommonCell) as! DoctorVisitAccompanistCell
                
                let model = BL_Common_Stepper.sharedInstance.accompanistList[indexPath.row]
                cell.accompName.text = model.EmployeeName
                
                if model.IsOnlyForChemist == "1"
                {
                    cell.callType.text = "Accompanied call"
                    cell.segmentedControl.isHidden = true
                    cell.independentStatus.isHidden = false
                    cell.independentStatus.text = "No"
                }
                else
                {
                    cell.callType.text = "Accompanied call"
                    cell.segmentedControl.isHidden = false
                    cell.independentStatus.isHidden = true
                    
                    if model.IsAccompaniedCall == 99
                    {
                        cell.segmentedControl.selectedSegmentIndex = -1
                    }
                    else if model.IsAccompaniedCall == 1
                    {
                        cell.segmentedControl.selectedSegmentIndex = 0
                    }
                    else if model.IsAccompaniedCall == 0
                    {
                        cell.segmentedControl.selectedSegmentIndex = 1
                    }
                }
                
                cell.segmentedControl.tag = indexPath.row
                
                cell.segmentedControl.addTarget(self, action: #selector(self.accompanistSegment(button:)), for: .valueChanged)
                outputCell = cell
            }
            else if (selectedIndex == stepperIndex.detailedProduct && stepperIndex.sampleIndex != 0) || (selectedIndex == stepperIndex.attachmentIndex && stepperIndex.attachmentIndex != 0)
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "doctorVisitCommon") as! DoctorVisitStepperCommon
                
                if selectedIndex == stepperIndex.detailedProduct
                {
                    let model = BL_Common_Stepper.sharedInstance.detailProductList[indexPath.row]
                    cell.line1.text = model.Product_Name
                } else if selectedIndex == stepperIndex.attachmentIndex
                {
                    let model = BL_Common_Stepper.sharedInstance.attachmentList[indexPath.row]
                    cell.line1.text = model.UploadedFileName
                }
                
                outputCell = cell
            }
            else if (stepperIndex.assetIndex != 0 && selectedIndex == stepperIndex.assetIndex)
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.DoctorVisitAssetCell) as! DoctorAssetTableViewCell
                
                let model = BL_Common_Stepper.sharedInstance.assetList[indexPath.row]
                var assetTypeName = ""
                
                if model.assetType != nil{
                    assetTypeName = getDocTypeVal(docType: model.assetType)
                }
                cell.assetNameLbl.text = model.assetsName + "(\(assetTypeName))"
                cell.viewedDurationLbl.text = viewedDuration + getPlayTime(timeVal: model.totalPlayedDuration)
                
                if assetTypeName != Constants.DocType.image && assetTypeName != Constants.DocType.video && assetTypeName != Constants.DocType.audio
                {
                    cell.viewedPagesTopConst.constant = 5
                    cell.uniquePagesTopConst.constant = 5
                    cell.viewedPagesLbl.text = viewedPages + model.totalPagesViewed
                    cell.uniquePagesLbl.text = uniquePages + model.totalUniquePagesCount
                }
                else
                {
                    cell.viewedPagesTopConst.constant = 0
                    cell.uniquePagesTopConst.constant = 0
                    cell.viewedPagesLbl.text = ""
                    cell.uniquePagesLbl.text = ""
                }
                
                outputCell = cell
            }
            else if selectedIndex == stepperIndex.sampleIndex || selectedIndex == stepperIndex.chemistIndex || selectedIndex == stepperIndex.followUpIndex || selectedIndex == stepperIndex.pobIndex || selectedIndex == stepperIndex.rcpaDetailIndex
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.CommonCell) as! DoctorVisitSampleCell
                if selectedIndex == stepperIndex.sampleIndex
                {
                    let modelObj = BL_Common_Stepper.sharedInstance.sampleList[indexPath.section].chemistSamplePromotion[indexPath.row]
                    var productName = String()
                    if(BL_Common_Stepper.sharedInstance.sampleList[indexPath.section].isShowSection)
                    {
                        productName = modelObj.BatchName
                    }
                    else
                    {
                        productName = modelObj.ProductName
                    }
                    cell.line1.text = productName
                    cell.line2.text = String(format: "%d units", modelObj.QuantityProvided)
                }
                else if selectedIndex == stepperIndex.rcpaDetailIndex
                {
                    let modelObj = BL_Common_Stepper.sharedInstance.rcpaDataList[indexPath.row]
                    cell.line1.text = modelObj.DoctorName
                    cell.line2.text = "MDL Number: \(modelObj.DoctorMDLNumber!)"
                    
                }
                    //            else if selectedIndex == stepperIndex.chemistIndex
                    //            {
                    //                let model = BL_Common_Stepper.sharedInstance.chemistVisitList[indexPath.row]
                    //              //  cell.line1.text = model.Chemist_Name
                    //                var pobAmount : Float = 0
                    //                if model.POB_Amount != nil
                    //                {
                    //                    pobAmount = model.POB_Amount!
                    //                }
                    //                
                    //                let rcpaCount = BL_Common_Stepper.sharedInstance.getRCPACountforDoctorVisit(chemistId: model.DCR_Chemist_Visit_Id)
                    //                if rcpaCount > 0
                    //                {
                    //                    cell.line2.text = String(format: "POB: %.2f | RCPA", pobAmount)
                    //                }
                    //                else
                    //                {
                    //                    cell.line2.text = String(format: "POB: %.2f", pobAmount)
                    //                }
                    //            }
                else if selectedIndex == stepperIndex.followUpIndex
                {
                    let model = BL_Common_Stepper.sharedInstance.followUpList[indexPath.row]
                    cell.line1.text = model.Task
                    cell.line2.text = convertDateIntoString(date: model.DueDate)
                }
                else if selectedIndex == stepperIndex.pobIndex
                {
                    
                    let orderEntryId = BL_Common_Stepper.sharedInstance.pobDataList[indexPath.row].Order_Entry_Id
                    
                    let stockiestName = BL_Common_Stepper.sharedInstance.pobDataList[indexPath.row].Stockiest_Name
                    
                    let noOfProduct = BL_POB_Stepper.sharedInstance.getNoOfProducts(orderEntryId: orderEntryId!)
                    let totalAmount = BL_POB_Stepper.sharedInstance.totalAmountcalculation(orderEntryId: orderEntryId!)
                    
                    let quantityText = String(format: "POB: "+"%f"+"| No Of Product: "+"%d", totalAmount,noOfProduct)
                    cell.line1.text = stockiestName
                    cell.line2.text = quantityText
                }
                
                
                outputCell = cell
            }
        }
        
        return outputCell
    }
    @objc func accompanistSegment(button: UISegmentedControl){
        BL_Common_Stepper.sharedInstance.updateAccompanistCall(index: button.tag, selectedIndex: button.selectedSegmentIndex)
        BL_Common_Stepper.sharedInstance.getAccompanistData()
        BL_Common_Stepper.sharedInstance.dynamicArrayValue = 0
        BL_Common_Stepper.sharedInstance.showAddButton = 0
        BL_Common_Stepper.sharedInstance.generateDataArray()
    }

}
