//
//  DoctorVisitStepperMain.swift
//  HiDoctorApp
//
//  Created by Vijay on 08/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class DoctorVisitStepperMain: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

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
    
    // MARK:- Variables
    var selectedIndex: Int!
    var parentTableView: UITableView!
    var stepperObj: DCRStepperModel!
    var stepperIndex = BL_DCR_Doctor_Visit.sharedInstance.stepperIndex
    var isFromAttendance = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        childTableView.delegate = self
        childTableView.dataSource = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK:- Table View Delegates
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if(isFromAttendance)
        {
            if selectedIndex == stepperIndex.sampleIndex
            {
            stepperObj = BL_Doctor_Attendance_Stepper.sharedInstance.stepperDataList[self.selectedIndex]
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
        else
        {
            if selectedIndex == stepperIndex.sampleIndex
            {
                stepperObj = BL_DCR_Doctor_Visit.sharedInstance.stepperDataList[self.selectedIndex]
                
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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(isFromAttendance)
        {
            stepperObj = BL_Doctor_Attendance_Stepper.sharedInstance.stepperDataList[self.selectedIndex]
            if (stepperObj.recordCount == 0)
            {
                return 0
            }
            else
            {
                if selectedIndex == stepperIndex.sampleIndex
                {
                    return BL_Doctor_Attendance_Stepper.sharedInstance.sampleList[section].sampleList.count
                }
                if (stepperObj.isExpanded == false && selectedIndex != stepperIndex.detailedProduct)
                {
                    return 1
                }
                else
                {
                    return stepperObj.recordCount
                }
            }
        }
        else
        {
            stepperObj = BL_DCR_Doctor_Visit.sharedInstance.stepperDataList[self.selectedIndex]
            
            if (stepperObj.recordCount == 0)
            {
                return 0
            }
            else
            {
                if selectedIndex == stepperIndex.sampleIndex
                {
                    return BL_DCR_Doctor_Visit.sharedInstance.sampleList[section].sampleList.count
                }
                if (stepperObj.isExpanded == false && selectedIndex != stepperIndex.detailedProduct)
                {
                    return 1
                }
                else
                {
                    //                if selectedIndex == stepperIndex.sampleIndex
                    //                {
                    //                    return BL_DCR_Doctor_Visit.sharedInstance.sampleList[section].sampleList.count
                    //                }
                    //                else
                    //                {
                    return stepperObj.recordCount
                    //              }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(isFromAttendance)
        {
            if selectedIndex == stepperIndex.doctorVisitIndex
            {
                return BL_Doctor_Attendance_Stepper.sharedInstance.getDoctorVisitDetailSingleHeight()
            }
            else if selectedIndex == stepperIndex.sampleIndex
            {
                return BL_Doctor_Attendance_Stepper.sharedInstance.getSampleBatchSingleHeight(section: indexPath.section, row: indexPath.row)
            }
            else if selectedIndex == stepperIndex.activity
            {
                return BL_Doctor_Attendance_Stepper.sharedInstance.getDoctorVisitSampleSingleHeight(selectedIndex: indexPath.row, parentIndex: selectedIndex)
            }
            else
            {
                return 0
            }
        }
        else
        {
            if selectedIndex == stepperIndex.doctorVisitIndex
            {
                return BL_DCR_Doctor_Visit.sharedInstance.getDoctorVisitDetailSingleHeight()
            }
            else if selectedIndex == stepperIndex.accompanistIndex
            {
                return BL_DCR_Doctor_Visit.sharedInstance.getAccompanistSingleCellHeight(selectedIndex: indexPath.row)
            }
            else if selectedIndex == stepperIndex.detailedProduct || selectedIndex == stepperIndex.attachmentIndex
            {
                return BL_DCR_Doctor_Visit.sharedInstance.getCommonSingleCellHeight(selectedIndex: indexPath.row, parentIndex: selectedIndex)
            }
            else if (selectedIndex == stepperIndex.assetIndex && stepperIndex.assetIndex != 0)
            {
                return BL_DCR_Doctor_Visit.sharedInstance.getAssetSingleHeight(selectedIndex: indexPath.row)
            }
            else if selectedIndex == stepperIndex.sampleIndex
            {
                return BL_DCR_Doctor_Visit.sharedInstance.getSampleBatchSingleHeight(section: indexPath.section, row: indexPath.row)
            }
            else if selectedIndex == stepperIndex.sampleIndex || selectedIndex == stepperIndex.followUpIndex || selectedIndex == stepperIndex.pobIndex || selectedIndex == stepperIndex.activity
            {
                
                return BL_DCR_Doctor_Visit.sharedInstance.getDoctorVisitSampleSingleHeight(selectedIndex: indexPath.row, parentIndex: selectedIndex)
            }
            else if (selectedIndex == stepperIndex.chemistIndex && stepperIndex.chemistIndex != 0)
            {
                return BL_DCR_Doctor_Visit.sharedInstance.getDoctorVisitSampleSingleHeight(selectedIndex: indexPath.row, parentIndex: selectedIndex)
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
        if(isFromAttendance)
        {
            if(selectedIndex == stepperIndex.sampleIndex)
            {
                return BL_Doctor_Attendance_Stepper.sharedInstance.sampleList[section].title
            }
        }
        else
        {
            
            if(selectedIndex == stepperIndex.sampleIndex)
            {
                return BL_DCR_Doctor_Visit.sharedInstance.sampleList[section].title
            }
            else
            {
                return ""
            }
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var outputCell: UITableViewCell = UITableViewCell()
        
        if selectedIndex == stepperIndex.doctorVisitIndex
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "doctorVisitDetail") as! DoctorVisitDetailCell
            
            if(isFromAttendance)
            {
                let model = BL_Doctor_Attendance_Stepper.sharedInstance.doctorVisitList[indexPath.row]
                
                
                var businessStatus = String()
                var callObjective =  String()
                var campaignName = String()
                
                if(model.Business_Status_Name.count > 0)
                {
                    businessStatus = model.Business_Status_Name
                }
                else
                {
                    businessStatus = "N/A"
                }
                
                if (model.Call_Objective_Name.count > 0)
                {
                    callObjective = model.Call_Objective_Name
                }
                else
                {
                    callObjective = "N/A"
                }
                
                if (model.Campaign_Name.count > 0)
                {
                    campaignName = model.Campaign_Name
                }
                else
                {
                    campaignName = "N/A"
                }
                
                let combineAttributeString = NSMutableAttributedString()
                combineAttributeString.append( attributedStringWithBold(boldText: "Business Status\n\n ", normalText: businessStatus))
                combineAttributeString.append(attributedStringWithBold(boldText: "\n\nCall Objective\n\n ", normalText: callObjective))
                combineAttributeString.append(attributedStringWithBold(boldText: "\n\nCampaign Name\n\n ", normalText: campaignName))
                combineAttributeString.append(attributedStringWithBold(boldText: "\n\nRemarks", normalText: ""))
                
                if model.Visit_Time != ""
                {
                    cell.visitMode.text = "Visit Time"
                    //attributedStringWithBold(boldText: "Business Status: ", normalText: self.messageDataFromDetail.objMailMessageHeader.Sender_Employee_Name)
                    cell.visitModeLabel.text = model.Visit_Time!
                }
                else if model.Visit_Mode != ""
                {
                    cell.visitMode.text = "Visit Mode"
                    cell.visitModeLabel.text = model.Visit_Mode
                }
                else
                {
                    cell.visitMode.text = "Visit Time"
                    cell.visitModeLabel.text = "N/A"
                }
                
                cell.remarks.attributedText = combineAttributeString
                //"Remarks"
                cell.remarkslabel.text = model.Remarks
            }
            else
            {
                var model = BL_DCR_Doctor_Visit.sharedInstance.doctorVisitList[indexPath.row]
                
                var businessStatus = String()
                var callObjective =  String()
                var campaignName = String()
                
                if(model.Business_Status_Name.count > 0)
                {
                    businessStatus = model.Business_Status_Name
                }
                else
                {
                    businessStatus = "N/A"
                }
                
                if (model.Call_Objective_Name.count > 0)
                {
                    callObjective = model.Call_Objective_Name
                }
                else
                {
                    callObjective = "N/A"
                }
            
                if (model.Campaign_Name.count > 0)
                {
                    campaignName = model.Campaign_Name
                }
                else
                {
                    campaignName = "N/A"
                }
                
                let combineAttributeString = NSMutableAttributedString()
                combineAttributeString.append( attributedStringWithBold(boldText: "Business Status\n\n ", normalText: businessStatus))
                combineAttributeString.append(attributedStringWithBold(boldText: "\n\nCall Objective\n\n ", normalText: callObjective))
                combineAttributeString.append(attributedStringWithBold(boldText: "\n\nCampaign Name\n\n ", normalText: campaignName))
                combineAttributeString.append(attributedStringWithBold(boldText: "\n\nRemarks", normalText: ""))
                
                if model.Visit_Time != ""
                {
                    cell.visitMode.text = "Visit Time"
                    //attributedStringWithBold(boldText: "Business Status: ", normalText: self.messageDataFromDetail.objMailMessageHeader.Sender_Employee_Name)
                    cell.visitModeLabel.text = model.Visit_Time!
                }
                else if model.Visit_Mode != ""
                {
                    cell.visitMode.text = "Visit Mode"
                    cell.visitModeLabel.text = model.Visit_Mode
                }
                
                cell.remarks.attributedText = combineAttributeString
                //"Remarks"
                cell.remarkslabel.text = model.Remarks
            }
            
            outputCell = cell
        }
        else if selectedIndex == stepperIndex.accompanistIndex
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.DoctorVisitAccompanistCell) as! DoctorVisitAccompanistCell
            
            let model = BL_DCR_Doctor_Visit.sharedInstance.accompanistList[indexPath.row]
             //let model = BL_DCR_Doctor_Visit.sharedInstance.[indexPath.row]
            
            cell.accompName.text = model.Employee_Name
            
            if model.Is_Only_For_Doctor == "1"
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
                
                if model.Is_Accompanied == "99"
                {
                    cell.segmentedControl.selectedSegmentIndex = -1
                }
                else if model.Is_Accompanied == "1"
                {
                    cell.segmentedControl.selectedSegmentIndex = 0
                }
                else if model.Is_Accompanied == "0"
                {
                    cell.segmentedControl.selectedSegmentIndex = 1
                }
                else
                {
                    cell.segmentedControl.selectedSegmentIndex = -1
                }
            }
            
            let dcrAccompanistList = BL_Stepper.sharedInstance.accompanistList
            if (dcrAccompanistList.count > 0)
            {
                let filteredArray = dcrAccompanistList.filter{
                    $0.Acc_User_Code == model.Acc_User_Code! && ($0.Is_Customer_Data_Inherited == Constants.DCR_Inheritance_Acc_Data_Downloaded_IDs.Download_Success || $0.Is_Customer_Data_Inherited == Constants.DCR_Inheritance_Acc_Data_Downloaded_IDs.Download_Error || $0.Is_Customer_Data_Inherited == Constants.DCR_Inheritance_Acc_Data_Downloaded_IDs.Lock_Status)
                }
                
                if (filteredArray.count > 0)
                {
                    cell.segmentedControl.isUserInteractionEnabled = false
                }
            }
            
            cell.segmentedControl.tag = indexPath.row
            outputCell = cell
        }
        else if selectedIndex == stepperIndex.detailedProduct || selectedIndex == stepperIndex.attachmentIndex
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "doctorVisitCommon") as! DoctorVisitStepperCommon
   
            if selectedIndex == stepperIndex.detailedProduct
            {
                let model = BL_DCR_Doctor_Visit.sharedInstance.detailProductList[indexPath.row]
                var detProduct = model.Product_Name
                let detProductAttr = model.stepperDisplayData
                if detProduct == EMPTY
                {
                    detProduct = NOT_APPLICABLE
                }
                
                let combineAttributeString = NSMutableAttributedString()
                combineAttributeString.append( attributedStringWithBold(boldText: detProduct!, normalText: detProductAttr))
                
                cell.line1.font = UIFont(name: fontRegular, size: 15)
                cell.line1.attributedText = combineAttributeString
                
                if(BL_DetailedProducts.sharedInstance.isDetailedCompetitorPrivilegeEnabled())
                {
                    cell.moreButHeightConstraints.constant = 25
                    cell.moreButton.isHidden = false
                    cell.moreButton.addTarget(self, action: #selector(navigateToCompetiorProduct), for: .touchUpInside)
                    cell.moreButton.tag = indexPath.row
                    
                }
                else
                {
                    cell.moreButHeightConstraints.constant = 0
                    cell.moreButton.isHidden = true
                }
                
                
                return cell
                //cell.line1.text = model.Product_Name
            }
            else if selectedIndex == stepperIndex.attachmentIndex
            {
                let model = BL_DCR_Doctor_Visit.sharedInstance.attachmentList[indexPath.row]
                cell.line1.text = model.attachmentName
                cell.moreButHeightConstraints.constant = 0
                cell.moreButton.isHidden = true
            }
            
            outputCell = cell
        }
        else if (stepperIndex.assetIndex != 0 && selectedIndex == stepperIndex.assetIndex)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.DoctorVisitAssetCell) as! DoctorAssetTableViewCell
            
            let model = BL_DCR_Doctor_Visit.sharedInstance.assetList[indexPath.row]
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
        else if selectedIndex == stepperIndex.sampleIndex || (selectedIndex == stepperIndex.chemistIndex && stepperIndex.chemistIndex > 0) || selectedIndex == stepperIndex.followUpIndex || selectedIndex == stepperIndex.pobIndex || selectedIndex == stepperIndex.activity
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "doctorVisitSample") as! DoctorVisitSampleCell
            if selectedIndex == stepperIndex.activity
            {
                if isFromAttendance
                {
                    let modelObj = BL_Doctor_Attendance_Stepper.sharedInstance.activitStepperData[indexPath.row]
                    cell.line1.text = modelObj.activityName
                    cell.line2.text = modelObj.activityRemarks
                }
                else
                {
                    let modelObj = BL_DCR_Doctor_Visit.sharedInstance.activitStepperData[indexPath.row]
                    cell.line1.text = modelObj.activityName
                    cell.line2.text = modelObj.activityRemarks
                }
            }
            else if selectedIndex == stepperIndex.sampleIndex
            {
                if isFromAttendance
                {
                    let modelObj = BL_Doctor_Attendance_Stepper.sharedInstance.sampleList[indexPath.section].sampleList[indexPath.row]
                    var productName = String()
                    if(BL_Doctor_Attendance_Stepper.sharedInstance.sampleList[indexPath.section].isShowSection)
                    {
                        productName = modelObj.sampleObj.Batch_Name
                    }
                    else
                    {
                        productName = modelObj.sampleObj.Product_Name
                    }
                    cell.line1.text = productName
                    cell.line2.text = String(format: "%d units", modelObj.sampleObj.Quantity_Provided)
                }
                else
                {
                    let modelObj = BL_DCR_Doctor_Visit.sharedInstance.sampleList[indexPath.section].sampleList[indexPath.row]
                    var productName = String()
                    if(BL_DCR_Doctor_Visit.sharedInstance.sampleList[indexPath.section].isShowSection)
                    {
                        productName = modelObj.sampleObj.Batch_Name
                    }
                    else
                    {
                        productName = modelObj.sampleObj.Product_Name
                    }
                    
                    cell.line1.text = productName
                    cell.line2.text = String(format: "%d units", modelObj.sampleObj.Quantity_Provided)
                }
            }
            else if selectedIndex == stepperIndex.chemistIndex
            {
                let model = BL_DCR_Doctor_Visit.sharedInstance.chemistVisitList[indexPath.row]
                cell.line1.text = model.Chemist_Name
                var pobAmount : Double = 0
                if model.POB_Amount != nil
                {
                    pobAmount = model.POB_Amount!
                }
                
                let rcpaCount = BL_DCR_Doctor_Visit.sharedInstance.getRCPACountforDoctorVisit(chemistId: model.DCR_Chemist_Visit_Id)
                if rcpaCount > 0
                {
                    cell.line2.text = String(format: "POB: %.2f | RCPA", pobAmount)
                }
                else
                {
                    cell.line2.text = String(format: "POB: %.2f", pobAmount)
                }
            }
            else if selectedIndex == stepperIndex.followUpIndex
            {
                let model = BL_DCR_Doctor_Visit.sharedInstance.followUpList[indexPath.row]
                cell.line1.text = model.Follow_Up_Text
                cell.line2.text = convertDateIntoString(date: model.Due_Date)
            }
            else if selectedIndex == stepperIndex.pobIndex
            {
                
                let orderEntryId = BL_DCR_Doctor_Visit.sharedInstance.pobDataList[indexPath.row].Order_Entry_Id
                
                let stockiestName = BL_DCR_Doctor_Visit.sharedInstance.pobDataList[indexPath.row].Stockiest_Name
                
                let noOfProduct = BL_POB_Stepper.sharedInstance.getNoOfProducts(orderEntryId: orderEntryId!)
                let totalAmount = BL_POB_Stepper.sharedInstance.totalAmountcalculation(orderEntryId: orderEntryId!)
                
                let quantityText = String(format: "POB: "+"%f"+"| No Of Product: "+"%d", totalAmount,noOfProduct)
                cell.line1.text = stockiestName
                cell.line2.text = quantityText
            }
            
            outputCell = cell
        }
        
        return outputCell
    }
    //MARK:- String to attributed string
    func attributedStringWithBold(boldText: String, normalText: String)->NSAttributedString
    {
        let boldText  = boldText
        let attrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15)]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
        
        let normalText = normalText
        let attrsNormal = [NSAttributedStringKey.font:UIFont(name: fontRegular, size: 13)]
        let normalString = NSMutableAttributedString(string:normalText)
        
        attributedString.append(normalString)
        return attributedString
    }
    
    @objc func navigateToCompetiorProduct(_ sender: UIButton)
    {
        let rowIndex = sender.tag
        let sb = UIStoryboard(name: detailProductSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier:CompetitorProductDetailViewControllerID ) as! CompetitorProductDetailViewController
        vc.selectedProductObj = BL_DCR_Doctor_Visit.sharedInstance.detailProductList[rowIndex]
         getAppDelegate().root_navigation.pushViewController(vc, animated: true)
        
    }
}
