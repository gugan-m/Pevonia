//
//  ApprovalDoctorDetailMainTableViewCell.swift
//  HiDoctorApp
//
//  Created by Vignaya on 1/10/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

protocol SelectedChemistDelegate
{
    func getSelectedChemistDetails(chemistVisitCode : String , chemistVisitId  :Int, isChemistDay : Bool, ownProductId:Int)
}

protocol SelectedChemistpobDelegate
{
    func getSelectedChemistPobDetails(dataList: NSArray,isFromChemistPob: Bool)
}


class ApprovalDoctorDetailMainTableViewCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var subTableView: UITableView!
    @IBOutlet weak var subTitleView: UIView!
    var isFromChemistDay : Bool = false
    
    var dataList : NSArray = []
    var sectionType : DoctorDetailsHeaderType!
    var delegate : SelectedChemistDelegate?
     var pobDelegate : SelectedChemistpobDelegate?
    var isFromAttendance: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()

         self.subTableView.estimatedRowHeight = 1000
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let dict = dataList[indexPath.row] as! NSDictionary
        var entityType: String = ""
        if(isFromChemistDay)
        {
           entityType = Constants.CustomerEntityType.chemist
        }
        else
        {
            entityType = Constants.CustomerEntityType.doctor
        }

        if(sectionType == DoctorDetailsHeaderType.DigitalAssets && entityType == Constants.CustomerEntityType.doctor)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.DoctorAssetCell, for: indexPath) as! DoctorAssetTableViewCell
            cell.sepView.isHidden = false
            cell.viewedPagesWidthConst.constant = 0
            
            if dataList.count == 1
            {
                cell.sepView.isHidden = true
            }
            var docType = ""
            if (dict.object(forKey: "Doc_Type") as? Int != nil)
            {
            docType = getDocTypeVal(docType: dict.object(forKey: "Doc_Type") as! Int)
            }
             cell.assetNameLbl.text = "\(checkNullAndNilValueForString(stringData: dict.object(forKey: "DA_Name")as? String))(\(docType))"
            
            var totalViewPages = "0"
            var uniquesPages = "0"
            var playedTimeDuration = "0"
            
            
            if let duration = dict.object(forKey: "Total_Played_Time_Duration") as? Int
            {
                playedTimeDuration = String(duration)
            }
            
            cell.viewedPagesLbl.text = EMPTY
            cell.uniquePagesLbl.text = EMPTY
            
            if docType == Constants.DocType.document || docType == Constants.DocType.zip
            {
                 cell.viewedPagesWidthConst.constant = 90

                if let page = dict.object(forKey: "Total_Viewed_Pages") as? Int
                {
                    totalViewPages = String(page)
                }
                
                if let uniquePage = dict.object(forKey: "Total_Unique_Pages_Count") as? Int
                {
                    uniquesPages = String(uniquePage)
                }
                cell.viewedPagesLbl.text = totalViewPages
                cell.uniquePagesLbl.text = uniquesPages
            }
           
            cell.viewedDurationLbl.text  = getPlayTime(timeVal: playedTimeDuration)
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.ApprovalDoctorDetailSubCell, for: indexPath) as! ApprovalDoctorDetailSubTableViewCell
            var line1Text : String = ""
            var line2Text : String = ""
            //print(sectionType)
            cell.moreLblHeight.constant = 0
            cell.imgWidthConst.constant = 0
            if isFromAttendance
            {
                if sectionType == DoctorDetailsHeaderType.DoctorVisit
                {
                    cell.line1Lbl.font = UIFont(name: fontSemiBold, size: 13)
                    line1Text = dict.object(forKey: "SectionName") as! String!
                    var sectionVal  = checkNullAndNilValueForString(stringData: dict.object(forKey: "SectionValue") as? String)
                    if sectionVal == ""
                    {
                        sectionVal = NOT_APPLICABLE
                    }
                    line2Text = sectionVal
                }
                else if sectionType!.rawValue == 1
                {
                    cell.line1Lbl.font = UIFont(name: fontSemiBold, size: 12)
                    var productName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Product_Name") as? String)
                    if productName == ""
                    {
                        productName = NOT_APPLICABLE
                    }
                    line1Text = productName
                    var quantity = String()
                    
                    if let qty = dict.object(forKey: "Quantity_Provided") as? String
                    {
                        quantity = checkNullAndNilValueForString(stringData:qty)
                    }
                    else if let qtyInt = dict.object(forKey: "Quantity_Provided") as? Int
                    {
                        quantity = "\(qtyInt)"
                    }
                    if quantity == ""
                    {
                        quantity = NOT_APPLICABLE
                    }
                    line2Text = quantity + " units"
                }
                else if(sectionType!.rawValue == 2)
                {
                    cell.line1Lbl.font = UIFont(name: fontSemiBold, size: 12)
                    var activityName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Activity_Name") as? String)
                    var activityRemarks = checkNullAndNilValueForString(stringData: dict.object(forKey: "Activity_Remarks") as? String)
                    if activityName == ""
                    {
                        activityName = NOT_APPLICABLE
                    }
                    if activityRemarks == ""
                    {
                        activityRemarks = NOT_APPLICABLE
                    }
                    line1Text = activityName
                    line2Text =  "Remarks: \(activityRemarks)"
                }
                else if(sectionType!.rawValue == 3)
                {
                    cell.line1Lbl.font = UIFont(name: fontSemiBold, size: 12)
                    var activityName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Activity_Name") as? String)
                    var activityRemarks = checkNullAndNilValueForString(stringData: dict.object(forKey: "Activity_Remarks") as? String)
                    if activityName == ""
                    {
                        activityName = NOT_APPLICABLE
                    }
                    if activityRemarks == ""
                    {
                        activityRemarks = NOT_APPLICABLE
                    }
                    line1Text = activityName
                    line2Text =  "Remarks: \(activityRemarks)"
                }
            }
            else
            {
                
                if sectionType == DoctorDetailsHeaderType.DoctorVisit
                {
                    cell.line1Lbl.font = UIFont(name: fontSemiBold, size: 13)
                    line1Text = dict.object(forKey: "SectionName") as! String!
                    var sectionVal  = checkNullAndNilValueForString(stringData: dict.object(forKey: "SectionValue") as? String)
                    if sectionVal == ""
                    {
                        sectionVal = NOT_APPLICABLE
                    }
                    line2Text = sectionVal
                }
                else if sectionType == DoctorDetailsHeaderType.Accompanist
                {
                    cell.line1Lbl.font = UIFont(name: fontSemiBold, size: 12)
                    var employeeName  = checkNullAndNilValueForString(stringData: dict.object(forKey: "Acc_User_Name") as? String)
                    let isForDoctor = dict.object(forKey: "accompainedCall") as? Int
                    let isOnlyForDoctor = dict.object(forKey: "Is_Accompanied") as? String
                    if(isForDoctor == 1 || isOnlyForDoctor == "1")
                    {
                        if employeeName == ""
                        {
                            employeeName = NOT_APPLICABLE
                        }
                        line1Text = employeeName
                    }
                    else
                    {
                        line1Text = "No accompanist avilable"
                    }
                }
                else if sectionType == DoctorDetailsHeaderType.Sample
                {
                    cell.line1Lbl.font = UIFont(name: fontSemiBold, size: 12)
                    var productName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Product_Name") as? String)
                    if productName == ""
                    {
                        productName = NOT_APPLICABLE
                    }
                    line1Text = productName
                    var quantity = String()
                    
                    if let qty = dict.object(forKey: "Quantity_Provided") as? String
                    {
                        quantity = checkNullAndNilValueForString(stringData:qty)
                    }
                    else if let qtyInt = dict.object(forKey: "Quantity_Provided") as? Int
                    {
                        quantity = "\(qtyInt)"
                    }
                    if quantity == ""
                    {
                        quantity = NOT_APPLICABLE
                    }
                    line2Text = quantity + " units"
                }
                else if sectionType == DoctorDetailsHeaderType.DetailedProduct
                {
                    var detProduct = checkNullAndNilValueForString(stringData: dict.object(forKey: "Product_Name") as? String)
                    if detProduct == ""
                    {
                        detProduct = NOT_APPLICABLE
                    }
                    
                    let detProductAttr = checkNullAndNilValueForString(stringData: dict.object(forKey: "Product_Attr") as? String)
                    let combineAttributeString = NSMutableAttributedString()
                    combineAttributeString.append( attributedStringWithBold(boldText: detProduct, normalText: detProductAttr))
                    
                    cell.line1Lbl.font = UIFont(name: fontRegular, size: 12)
                    cell.line1Lbl.attributedText = combineAttributeString
                    cell.line2Lbl.text = EMPTY
                    if(entityType == Constants.CustomerEntityType.doctor)
                    {
                        cell.moreLblHeight.constant = 15
                    }
                    else
                    {
                        cell.moreLblHeight.constant = 0
                    }
                    if let competitorDetailList = dict.object(forKey: "Competitor_Products") as? [DCRCompetitorDetailsModel]
                    {
                        
                        if(competitorDetailList.count > 0)
                        {
                            cell.moreBut.isHidden = false
                        }
                        else
                        {
                            cell.moreBut.isHidden = true
                        }
                    }
                    return cell
                }
                else if (sectionType == DoctorDetailsHeaderType.ChemistVisit && entityType == Constants.CustomerEntityType.chemist)
                {
                    cell.line1Lbl.font = UIFont(name: fontSemiBold, size: 12)
                    var chemistName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Chemist_Name") as? String)
                    if chemistName == ""
                    {
                        chemistName = NOT_APPLICABLE
                    }
                    
                    line1Text = chemistName
                    
                    var pob : String = ""
                    if let pobAmount =  dict.object(forKey: "POB_Amount") as? Float
                    {
                        pob = String(pobAmount)
                    }
                    if pob == ""
                    {
                        pob = "0.0"
                    }
                    var pobProduct : String = ""
                    if let Produt = dict.object(forKey: "DCR_Chemist_Visit_Id") as? Int
                    {
                        pobProduct = String(Produt)
                    }
                    else
                    {
                        pobProduct = "0"
                    }
                    
                    line2Text = "POB Amount: " + pob + " | " + "No Of Product: " + pobProduct
                    cell.moreLblHeight.constant = 15
                }
                else if(sectionType == DoctorDetailsHeaderType.callType)
                {
                    cell.line1Lbl.font = UIFont(name: fontSemiBold, size: 12)
                    var activityName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Activity_Name") as? String)
                    var activityRemarks = checkNullAndNilValueForString(stringData: dict.object(forKey: "Activity_Remarks") as? String)
                    if activityName == ""
                    {
                        activityName = NOT_APPLICABLE
                    }
                    if activityRemarks == ""
                    {
                        activityRemarks = NOT_APPLICABLE
                    }
                    line1Text = activityName
                    line2Text =  "Remarks: \(activityRemarks)"
                }
                else if(sectionType == DoctorDetailsHeaderType.mcActivity)
                {
                    cell.line1Lbl.font = UIFont(name: fontSemiBold, size: 12)
                    var activityName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Activity_Name") as? String)
                    var activityRemarks = checkNullAndNilValueForString(stringData: dict.object(forKey: "Activity_Remarks") as? String)
                    if activityName == ""
                    {
                        activityName = NOT_APPLICABLE
                    }
                    if activityRemarks == ""
                    {
                        activityRemarks = NOT_APPLICABLE
                    }
                    line1Text = activityName
                    line2Text =  "Remarks: \(activityRemarks)"
                }
                else if(sectionType == DoctorDetailsHeaderType.DigitalAssets && entityType == Constants.CustomerEntityType.chemist)
                {
                    
                    cell.line1Lbl.font = UIFont(name: fontSemiBold, size: 12)
                    var customerName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Customer_Name") as? String)
                    let productName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Product_Name") as? String)
                    if customerName == ""
                    {
                        customerName = NOT_APPLICABLE
                    }
                    
                    line1Text = customerName
                    
                    var quantity =  dict.object(forKey: "Qty") as? Float
                    if quantity == 0.0 || quantity == nil
                    {
                        quantity = 0.0
                    }
                    line2Text = "Own Product: \(productName) | Own Product Qty:  \(quantity!)"
                    cell.moreLblHeight.constant = 15
                    
                }
                else if (sectionType == DoctorDetailsHeaderType.ChemistVisit && entityType == Constants.CustomerEntityType.doctor)
                {
                    cell.line1Lbl.font = UIFont(name: fontSemiBold, size: 12)
                    var chemistName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Chemist_Name") as? String)
                    if chemistName == ""
                    {
                        chemistName = NOT_APPLICABLE
                    }
                    
                    line1Text = chemistName
                    
                    var pob : String = ""
                    if let pobAmount =  dict.object(forKey: "POB_Amount") as? Double
                    {
                        pob = String(pobAmount)
                    }
                    if pob == ""
                    {
                        pob = "0.0"
                    }
                    
                    line2Text = "POB " + pob + " | " + "RCPA"
                    cell.moreLblHeight.constant = 15
                }
                else if (sectionType == DoctorDetailsHeaderType.pob && entityType == Constants.CustomerEntityType.doctor)
                {
                    cell.line1Lbl.font = UIFont(name: fontSemiBold, size: 12)
                    var chemistName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Chemist_Name") as? String)
                    if chemistName == ""
                    {
                        chemistName = NOT_APPLICABLE
                    }
                    
                    line1Text = chemistName
                    
                    var pob : String = ""
                    if let pobAmount =  dict.object(forKey: "POB_Amount") as? Float
                    {
                        pob = String(pobAmount)
                    }
                    if pob == ""
                    {
                        pob = "0.0"
                    }
                    var pobProduct : String = ""
                    if let Produt = dict.object(forKey: "DCR_Chemist_Visit_Id") as? Int
                    {
                        pobProduct = String(Produt)
                    }
                    else
                    {
                        pobProduct = "0"
                    }
                    
                    line2Text = "POB Amount: " + pob + " | " + "No Of Product: " + pobProduct
                    cell.moreLblHeight.constant = 15
                }
                else if sectionType == DoctorDetailsHeaderType.FollowUps
                {
                    cell.line1Lbl.font = UIFont(name: fontRegular, size: 13)
                    let followUpsText = checkNullAndNilValueForString(stringData: dict.object(forKey: "Tasks") as? String)
                    line1Text = followUpsText
                    let getDueDate = checkNullAndNilValueForString(stringData: dict.object(forKey: "Due_Date") as? String)
                    if getDueDate != ""
                    {
                        let dueDate = convertDateIntoString(dateString: getDueDate)
                        let dueDateString = convertDateIntoString(date: dueDate)
                        line2Text = dueDateString
                    }
                    else
                    {
                        line2Text = ""
                    }
                }
                else if sectionType == DoctorDetailsHeaderType.Attachment
                {
                    line1Text = checkNullAndNilValueForString(stringData: dict.object(forKey: "Uploaded_File_Name") as? String)
                    cell.imgWidthConst.constant = 15
                }
            }
            
            cell.line1Lbl.text = line1Text
            cell.line2Lbl.text = line2Text
            
            return cell
        }
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        let dict = dataList[indexPath.row] as! NSDictionary
        var entityType: String = ""
        if(isFromChemistDay)
        {
            entityType = Constants.CustomerEntityType.chemist
        }
        else
        {
            entityType = Constants.CustomerEntityType.doctor
        }

        if(!isFromChemistDay)
        {
            if (sectionType == DoctorDetailsHeaderType.DigitalAssets && entityType == Constants.CustomerEntityType.doctor)
            {
                return BL_Approval.sharedInstance.getLineHeightForAsset(dict: dict)
            }
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dict = dataList[indexPath.row] as! NSDictionary
        var chemistId  : Int = 0
        var ownProductId : Int = 0
        var entityType: String = ""
        var chemistPob : NSArray = NSArray()
        if !isFromAttendance
        {
            if(isFromChemistDay)
            {
                entityType = Constants.CustomerEntityType.chemist
            }
            else
            {
                entityType = Constants.CustomerEntityType.doctor
            }
            
            if (sectionType ==  DoctorDetailsHeaderType.ChemistVisit && entityType == Constants.CustomerEntityType.doctor)
            {
                let chemistCode = checkNullAndNilValueForString(stringData: dict.object(forKey: "DCR_Chemists_Code") as? String)
                
                if let id = dict.object(forKey: "DCR_Chemist_Visit_Id") as? Int
                {
                    chemistId = id
                }
                delegate?.getSelectedChemistDetails(chemistVisitCode: chemistCode,chemistVisitId  : chemistId, isChemistDay : isFromChemistDay,ownProductId:0)
            }
            else if (sectionType ==  DoctorDetailsHeaderType.DigitalAssets && entityType == Constants.CustomerEntityType.chemist)
            {
                
                if let ownId = dict.object(forKey: "Chemist_RCPA_OWN_Product_Id") as? Int
                {
                    ownProductId = ownId
                }
                
                if let id = dict.object(forKey: "CV_Visit_Id") as? Int
                {
                    chemistId = id
                }
                delegate?.getSelectedChemistDetails(chemistVisitCode: "",chemistVisitId  : chemistId, isChemistDay : isFromChemistDay, ownProductId : ownProductId)
                
            }
            else if (sectionType ==  DoctorDetailsHeaderType.ChemistVisit && entityType == Constants.CustomerEntityType.chemist) || (sectionType ==  DoctorDetailsHeaderType.pob && entityType == Constants.CustomerEntityType.doctor)
            {
                if let chemistPobData = dict.object(forKey: "Chemist_RCPA_OWN_Product_Id") as? NSArray
                {
                    chemistPob = chemistPobData
                }
                
                pobDelegate?.getSelectedChemistPobDetails(dataList: (dict.object(forKey: "Orderdetails") as? NSArray)!, isFromChemistPob: true)
            }
            else if sectionType == DoctorDetailsHeaderType.Attachment
            {
                let url = checkNullAndNilValueForString(stringData: dict.object(forKey: "Blob_Url") as? String)
                if let requestUrl = URL(string: url)
                {
                    UIApplication.shared.openURL(requestUrl)
                }
            }
            else if (sectionType ==  DoctorDetailsHeaderType.DetailedProduct && entityType == Constants.CustomerEntityType.doctor)
            {
                //            let dict = dataList[indexPath.row] as! NSDictionary
                //
                //            let dcrDetailedCompetitorList = dict.value(forKey: "") as! NSArray
                //            var dcrDetailedCompetitorReportList :[DCRCompetitorDetailsModel] = []
                //
                //            for competitorObj in dcrDetailedCompetitorList
                //            {
                //            let dict = ["":"","":"","":"",]
                //            let dcrDetailCompetitorObj = DCRCompetitorDetailsModel(dict: dict as NSDictionary)
                //            dcrDetailedCompetitorReportList.append(dcrDetailCompetitorObj)
                //            }
                let competitorDetailList =  dict.object(forKey: "Competitor_Products") as? [DCRCompetitorDetailsModel]
                
                let sb = UIStoryboard(name: detailProductSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier:"DetailedCompetitorReportControllerID" ) as! DetailedCompetitorReportController
                vc.dcrDetailedCompetitorList = competitorDetailList!
                getAppDelegate().root_navigation.pushViewController(vc, animated: true)
                
                
            }
        }
    }
    
    func attributedStringWithBold(boldText: String, normalText: String)->NSAttributedString
    {
        let boldText  = boldText
        let attrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
        
        let normalText = normalText
        let normalString = NSMutableAttributedString(string:normalText)
        
        attributedString.append(normalString)
        return attributedString
    }
}
