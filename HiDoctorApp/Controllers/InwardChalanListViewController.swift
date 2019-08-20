//
//  InwardChalanListViewController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 27/03/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class InwardChalanListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var emptyStateLbl: UILabel!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var inwardSkipRemark: UIView!
    var inwardDataList : [InwardAccknowledgmentProductData] = []
    var isFromUpload: Bool = false
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.registerTableCell()
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 500
        self.title = "Inward Acknowledgement"
        addCustomBackButtonToNavigationBar()
        self.inwardSkipRemark.isHidden = true
        self.textView.layer.borderColor = UIColor.gray.cgColor
        self.textView.layer.borderWidth = 0.5
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        self.setDefaults()
    }
    
    func setDefaults()
    {
        getInwardData()
    }
    
    func registerTableCell()
    {
        self.tableView.register(UINib(nibName: Constants.NibNames.CommonDoubleLineCell, bundle: nil), forCellReuseIdentifier: "doctorVisitSample")
    }
    
    func getInwardData()
    {
        if(checkInternetConnectivity())
        {
            showCustomActivityIndicatorView(loadingText: "Loading Inward Details")
            WebServiceHelper.sharedInstance.getInwardChalanListWithProduct{ (apiObj) in
                if(apiObj.Status == SERVER_SUCCESS_CODE)
                {
                    removeCustomActivityView()
                    if(apiObj.list.count > 0)
                    {
                        self.emptyStateView.isHidden = true
                        self.emptyStateLbl.text = ""
                        self.tableView.isHidden = false
                        self.inwardDataList = self.convertToInwardModel(responseList:apiObj.list)
                        self.tableView.reloadData()
                    }
                    else
                    {
                        self.emptyStateView.isHidden = false
                        self.emptyStateLbl.text = "No Pending Inward Acknowledgement"
                        self.tableView.isHidden = true
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
        }
    }
    
    func convertToInwardModel(responseList: NSArray) ->[InwardAccknowledgmentProductData]
    {
        var inWardAckData :[InwardAccknowledgmentProductData] = []
        
        for (index,_) in responseList.enumerated()
        {
            let obj = responseList[index] as! NSDictionary
            let inWardAckObj  = InwardAccknowledgmentProductData()
            let inwardAckDetails = (responseList[index] as AnyObject).value(forKey:"lstInwardAckDetails") as! NSArray
            var inwardDataList:[InwardAccknowledgment] = []
            
            
            for (index,_) in inwardAckDetails.enumerated()
            {
                let inwardData = InwardAccknowledgment()
                let obj = inwardAckDetails[index] as! NSDictionary
                inwardData.Details_Id = obj.value(forKey: "Details_Id") as! Int
                inwardData.Pending_Quantity = obj.value(forKey: "Pending_Quantity") as! Int
                inwardData.Product_Code = obj.value(forKey: "Product_Code") as! String
                inwardData.Product_Name = obj.value(forKey: "Product_Name") as! String
                inwardData.Product_Type = obj.value(forKey: "Product_Type") as! String
                inwardData.Received_Quantity =  obj.value(forKey: "Received_Quantity") as! Int
                inwardData.Received_So_Far = obj.value(forKey: "Received_So_Far") as! Int
                inwardData.Sent_Quantity = obj.value(forKey: "Sent_Quantity") as! Int
                if let batchNumber = obj.value(forKey: "Batch_Number") as? String
                {
                    inwardData.Batch_Number = batchNumber
                }
                else
                {
                    inwardData.Batch_Number = EMPTY
                }
                inwardDataList.append(inwardData)
            }
            inWardAckObj.Delivery_Challan_Number = obj.value(forKey: "Delivery_Challan_Number")as! String
            inWardAckObj.Header_Id = obj.value(forKey: "Header_Id")as!Int
            inWardAckObj.Inward_Upload_Actual_Date = obj.value(forKey: "Inward_Upload_Actual_Date")as! String
            inWardAckObj.Server_Current_Date = obj.value(forKey: "Server_Date")as! String
            inWardAckObj.lstInwardAckDetails = inwardDataList
            inWardAckData.append(inWardAckObj)
        }
        return inWardAckData
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inwardDataList.count

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  =  self.tableView.dequeueReusableCell(withIdentifier: "doctorVisitSample") as! DoctorVisitSampleCell
            let inwarddata = inwardDataList[indexPath.row]
        cell.line1.text = "Delivery Challan No: " + "\(inwarddata.Delivery_Challan_Number!)"
        let uploadDate = convertDateIntoString(dateString: inwarddata.Inward_Upload_Actual_Date!)
        let appFormat = convertDateIntoString(date: uploadDate)
      //  convertDateIntoString(dateString: inwardDataList.Inward_Upload_Actual_Date)
        
        cell.line2.text = "Delivery Challan Date: " + "\(appFormat)"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let inwarddata = inwardDataList[indexPath.row]
        let sb = UIStoryboard(name: commonListSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: InwardChalanDetailViewControllerID) as!InwardChalanDetailViewController
        vc.inwardDataList = inwarddata
        
        self.navigationController?.pushViewController(vc, animated: false)
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
        if BL_Upload_DCR.sharedInstance.isFromDCRUpload == true
        {
            self.inwardSkipRemark.isHidden = false
        }
        else
        {
            _ = navigationController?.popViewController(animated: false)
        }
    }
    
    //Inward skip remarks
    @IBAction func submitInwardRemarks(_ sender: UIButton)
    {
        if(self.textView.text == EMPTY)
        {
            AlertView.showAlertView(title: "Alert", message: "Please enter remarks", viewController: self)
        }
        else if(self.textView.text.count > 250)
        {
            AlertView.showAlertView(title: alertTitle, message: "Skip remarks cannot exceed 250 characters", viewController: self)
        }
        else if isSpecialCharacterExist(remarks:self.textView.text)
        {
            let restrictedCharacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
            AlertView.showSpecialCharacterAlertview(title: alertTitle, subject: "Remarks for Inward Skip", restrictedVal: restrictedCharacter, viewController: self)
        }
        else if(self.textView.text == EMPTY)
        {
            AlertView.showAlertView(title: "Alert", message: "Please enter remarks", viewController: self)
        }
        else
        {
            BL_Upload_DCR.sharedInstance.isFromDCRUpload = false
            let dict = ["User_Code":getUserCode(),"Region_Code":getRegionCode(),"Remarks":textView.text] as [String : Any]
            WebServiceHelper.sharedInstance.inWardSkipRemarks(postData:dict) { (apiObj) in
                if(apiObj.Status == SERVER_SUCCESS_CODE)
                {
                    print("inward skip remarks success")
                }
            }
            self.inwardSkipRemark.isHidden = true
        }
    }
    
    //Inward skip remarks
    @IBAction func cancelInwardRemarks(_ sender: UIButton)
    {
       self.inwardSkipRemark.isHidden = true
    }
    
    func isSpecialCharacterExist(remarks:String) -> Bool
    {
        let restrictedChatacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
        
        if (remarks.count > 0)
        {
            if restrictedChatacter != ""
            {
                return checkIfSpecialCharacterFound(restrictedCharacter: restrictedChatacter, remarkTxt: remarks)
            }
        }
        return false
    }
}
