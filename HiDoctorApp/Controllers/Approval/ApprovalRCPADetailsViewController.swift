//
//  ApprovalRCPADetailsViewController.swift
//  HiDoctorApp
//
//  Created by Vignaya on 1/11/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class ApprovalRCPADetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateView : UIView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    
    
    var DCRCode : String!
    var doctorVisitCode : String!
    var chemistVisitCode : String!
    var chemistVisitId : Int!
    var dataList : NSArray = NSArray()
    var isFromChemist : Bool = false
    var ownProductId : Int = 0
    var isFromChemistPob : Bool = false
    var chemistPobDataList : NSArray = NSArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDefaultDetails()
        self.tableView.estimatedRowHeight = 1000
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        if(isFromChemistPob)
        {
            self.title = "POB Details"
        }
        else
        {
            self.title = "RCPA Details"
        }
        addCustomBackButtonToNavigationBar()
    }
    
    func setDefaultDetails()
    {
        if(isFromChemistPob)
        {
            if chemistPobDataList.count > 0
            {
                self.dataList = chemistPobDataList as NSArray
                self.tableView.reloadData()
                self.showEmptyStateView(show: false)
            }
            else
            {
                self.showEmptyStateView(show: true)
                self.setEmptyStateText(type : 2)
            }
        }
        else
        {
            if DCRCode == ""
            {
                getOfflineRCPADetails()
            }
            else
            {
                chemistApiCall()
            }
        }
    }
    
    func getOfflineRCPADetails()
    {
        if(isFromChemist)
        {
           self.dataList = BL_Reports.sharedInstance.getChemistDayRCPACompetitorDetails(chemistVisitId: chemistVisitId, rcpaOwnId: ownProductId)
        }
        else
        {
            self.dataList = BL_Reports.sharedInstance.getDCRChemistRCPADetails(chemisVisitId: chemistVisitId)
        }
        if dataList.count > 0
        {
            self.showEmptyStateView(show: false)
        }
        else
        {
            self.showEmptyStateView(show: true)
            self.setEmptyStateText(type : 2)
        }
        
    }
    
    func chemistApiCall()
    {
        if checkInternetConnectivity()
        {
            if(isFromChemist)
            {
                 chemistDayApiCall()
            }
            else
            {
                showCustomActivityIndicatorView(loadingText: "Loading...")
                BL_Approval.sharedInstance.getDCRRCPADetailsForADoctorAndChemistVisit(DCRCode: DCRCode, doctorVisitCode: doctorVisitCode, chemistVisitCode: chemistVisitCode, completion: { (apiResponseObj) in
                    removeCustomActivityView()
                    if apiResponseObj.Status == SERVER_SUCCESS_CODE
                    {
                        if apiResponseObj.list.count > 0
                        {
                            self.dataList = apiResponseObj.list
                            self.tableView.reloadData()
                            self.showEmptyStateView(show: false)
                        }
                        else
                        {
                            self.showEmptyStateView(show: true)
                            self.setEmptyStateText(type : 2)
                        }
                    }
                })
            }
        }
        else
        {
            self.showEmptyStateView(show: true)
            self.setEmptyStateText(type : 1)
        }
    }
    
    func chemistDayApiCall()
    {
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: "Loading...")
            if checkInternetConnectivity()
            {
                BL_Approval.sharedInstance.getDCRRCPACompetitorProductsDetailsForChemistVisit(DCRCode:DCRCode,chemistVisitCode: doctorVisitCode) { (apiResponseObj) in
                    removeCustomActivityView()
                    if apiResponseObj.list.count > 0
                    {
                        let predicate = NSPredicate(format: "Chemist_RCPA_OWN_Product_Id == %d",self.ownProductId)
                        let filteredArray = apiResponseObj.list.filtered(using: predicate)
                        if filteredArray.count > 0
                        {
                            self.dataList = filteredArray as NSArray
                            self.tableView.reloadData()
                            self.showEmptyStateView(show: false)
                        }
                        else
                        {
                            self.showEmptyStateView(show: true)
                            self.setEmptyStateText(type : 2)
                        }
                        
                    }
                    else
                    {
                        self.showEmptyStateView(show: true)
                        self.setEmptyStateText(type : 2)
                    }
                }
            }
        }
        else
        {
            self.showEmptyStateView(show: true)
            self.setEmptyStateText(type : 1)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let appCell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.ApprovalRCPACell, for: indexPath) as! ApprovalRCPADetailTableViewCell
        let dict = dataList[indexPath.row] as! NSDictionary
        
        
        var productName : String = ""
        var qty : String = ""
        var qtyRate : String = ""
        var qtyAmount : String = ""
        
        if(isFromChemistPob)
        {
            productName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Product_Name") as? String)
            appCell.lbl1Text.font = UIFont(name: fontRegular, size: 12)
            
            appCell.lbl1Text.text = productName
            
            if let qtyGiven = dict.object(forKey: "Product_Qty") as? Double
            {
                qty = String(qtyGiven)
            }
            if let qtyRt = dict.object(forKey: "Product_Unit_Rate") as? Double
            {
                qtyRate = String(qtyRt)
            }
            if let qtyAmt = dict.object(forKey: "Product_Amount") as? Double
            {
                qtyAmount = String(qtyAmt)
            }
            appCell.lbl2Text.text = "\(qty) Units|Unit Rate:\(qtyRate)|Amount:\(qtyAmount)"

        }
        else
        {
        productName = checkNullAndNilValueForString(stringData: dict.object(forKey: "Competitor_Product_Name") as? String)
        appCell.lbl1Text.font = UIFont(name: fontRegular, size: 12)

        
        if productName == ""
        {
         productName =  checkNullAndNilValueForString(stringData: dict.object(forKey: "Own_Product_Name") as? String)
         appCell.lbl1Text.font = UIFont(name: fontBold, size: 12)

        }

        appCell.lbl1Text.text = productName
        
        if(isFromChemist)
        {
            if let qtyGiven = dict.object(forKey: "Qty") as? Float
            {
                qty = String(qtyGiven)
            }
        }
        else
        {
            if let qtyGiven = dict.object(forKey: "Qty_Given") as? Float
            {
                qty = String(qtyGiven)
            }
        }
         appCell.lbl2Text.text = "\(qty) Units"
        }
        
        
        return appCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func showEmptyStateView(show : Bool)
    {
        self.emptyStateView.isHidden = !show
        self.tableView.isHidden = show
    }
    
    func setEmptyStateText(type : Int)
    {
        var text : String  = ""
        if type == 1
        {
            text = "No internet Connection"
        }
        else
        {
            if(isFromChemist)
            {
                text = "No competitor RCPA details available"
            }
            else if(isFromChemistPob)
            {
                text = "No order details available"
            }
            else
            {
                text = "\(appChemist) RCPA details not available"
            }
        }
        
        self.emptyStateLbl.text = text
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
