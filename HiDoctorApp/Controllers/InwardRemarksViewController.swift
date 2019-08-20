//
//  InwardRemarksViewController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 28/03/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class InwardRemarksViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var batchNameLbl: UILabel!
    @IBOutlet weak var batchNumber: UILabel!
    @IBOutlet weak var totalSentQty: UILabel!
    @IBOutlet weak var createdOn: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var topView: UIView!
     @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    
    var headerId = Int()
    var batchNum = String()
    var remarkHistoryData :[InwardAccknowledgmentRemark] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setDefaults()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.remarkHistoryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "InwardRemarksTableViewCell") as! InwardRemarksTableViewCell
        let inwardRemarkObj = self.remarkHistoryData[indexPath.row]
        let modifiedInwardDate = convertDateIntoString(dateString: inwardRemarkObj.Modified_Inward_Actual_Date)
        let appFormatModifiyDate = convertDateIntoString(date: modifiedInwardDate)
        
        let modifiedOn = convertDateIntoString(dateString: inwardRemarkObj.Modified_On)
        let appFormatModifiyOn = convertDateIntoString(date: modifiedOn)
        
        cell.ackType.text = inwardRemarkObj.Acknowledgement_Type
        cell.modifiedInwardDate.text = appFormatModifiyDate
        cell.modifiedOn.text = appFormatModifiyOn
        cell.remarks.text = inwardRemarkObj.Remarks
        cell.quantity.text = "\(inwardRemarkObj.Quantity!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let inwardRemarkObj = self.remarkHistoryData[indexPath.row]
        
        let getRemarkSize = getTextSize(text: inwardRemarkObj.Remarks, fontName: fontRegular, fontSize: 15, constrainedWidth: SCREEN_WIDTH - 28).height
        
        
        return CGFloat(270) + CGFloat(getRemarkSize)
    }
    
    func setDefaults()
    {
        if(checkInternetConnectivity())
        {
            showCustomActivityIndicatorView(loadingText: "Loading InWard Details")
            WebServiceHelper.sharedInstance.getInwardRemarkDetails(detailId: headerId,batchNumber:batchNum){ (apiObj) in
                if(apiObj.Status == SERVER_SUCCESS_CODE)
                {
                    removeCustomActivityView()
                    if(apiObj.list.count > 0)
                    {
                        self.emptyStateView.isHidden = true
                        self.emptyStateLbl.text = ""
                        self.tableView.isHidden = false
                        //self.topView.isHidden = false
                        self.settopViewData(apiObj: apiObj.list)
                    }
                    else
                    {
                        self.emptyStateView.isHidden = false
                        self.emptyStateLbl.text = "No Remarks Found"
                        self.tableView.isHidden = true
                        //self.topView.isHidden = true
                    }
                    
                }
                else
                {
                    removeCustomActivityView()
                    self.emptyStateView.isHidden = false
                    self.emptyStateLbl.text = "Please Try again"
                    self.tableView.isHidden = true
                                  }
            }
        }
        else
        {
            self.emptyStateView.isHidden = false
            self.emptyStateLbl.text = "Please Check your Connection"
            self.tableView.isHidden = true
            self.topView.isHidden = true
        }
    }
    func settopViewData(apiObj:NSArray)
    {
        let inwardDataList = self.convertToInwardRemarkModel(responseList:apiObj)
        self.remarkHistoryData = inwardDataList[0].lstInwardRemarksDetails
        if(self.remarkHistoryData.count == 0 )
        {
            self.emptyStateView.isHidden = false
            self.emptyStateLbl.text = "No Remarks Found"
            self.tableView.isHidden = true
        }
        self.productName.text = inwardDataList[0].Product_Name
        self.totalSentQty.text = "\(inwardDataList[0].Total_Sent_Quantity!)"
        self.batchNameLbl.text = "Batch Number:"
        self.batchNumber.text = inwardDataList[0].Batch_Number
        self.createdOn.text = convertDateIntoString(date: convertDateIntoString(dateString: inwardDataList[0].Created_On))
        self.tableView.reloadData()
        var getTopViewHeight = getTextSize(text: inwardDataList[0].Product_Name, fontName: fontRegular, fontSize: 15, constrainedWidth: SCREEN_WIDTH - 200).height
        if inwardDataList[0].Batch_Number == EMPTY{
            self.batchNameLbl.text = EMPTY
            self.batchNumber.text = EMPTY
            getTopViewHeight += getTextSize(text: inwardDataList[0].Batch_Number, fontName: fontRegular, fontSize: 15, constrainedWidth: SCREEN_WIDTH - 200).height
        }
        topViewHeightConstraint.constant = 90 + getTopViewHeight
        
    }
    func convertToInwardRemarkModel(responseList: NSArray) ->[InwardAccknowledgmentRemarkData]
    {
        var inWardAckRemarkData :[InwardAccknowledgmentRemarkData] = []
        
        for (index,_) in responseList.enumerated()
        {
            let obj = responseList[index] as! NSDictionary
            let inWardAckObj  = InwardAccknowledgmentRemarkData()
            let inwardAckDetails = (responseList[index] as AnyObject).value(forKey:"lstInwardRemarksDetails") as! NSArray
            var inwardDataList:[InwardAccknowledgmentRemark] = []
            
            
            for (index,_) in inwardAckDetails.enumerated()
            {
                let inwardData = InwardAccknowledgmentRemark()
                let obj = inwardAckDetails[index] as! NSDictionary
                inwardData.Modified_Inward_Actual_Date = obj.value(forKey: "Modified_Inward_Actual_Date") as! String
                inwardData.Modified_On = obj.value(forKey: "Modified_On") as! String
                inwardData.Quantity = obj.value(forKey: "Quantity") as! Int
                inwardData.Acknowledgement_Type = obj.value(forKey: "Acknowledgement_Type") as! String
                inwardData.Remarks = obj.value(forKey: "Remarks") as! String
                inwardDataList.append(inwardData)
            }
            inWardAckObj.Product_Name = obj.value(forKey: "Product_Name")as! String //Batch_Number
            if let batchNum = obj.value(forKey: "Batch_Number")as? String
            {
              inWardAckObj.Batch_Number = batchNum
            }
            else
            {
               inWardAckObj.Batch_Number = EMPTY
            }
            inWardAckObj.Total_Sent_Quantity = obj.value(forKey: "Total_Sent_Quantity")as!Int
            inWardAckObj.Created_On = obj.value(forKey: "Created_On")as! String
            inWardAckObj.Created_For = obj.value(forKey: "Created_For")as! String
            inWardAckObj.lstInwardRemarksDetails = inwardDataList
            inWardAckRemarkData.append(inWardAckObj)
        }
        
        
        
        
        return inWardAckRemarkData
    }
    
}
