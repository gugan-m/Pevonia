//
//  ExpenseAttachmentListController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 16/04/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class ExpenseAttachmentListController: UIViewController,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    
    var claimCode = String()
    var expenseAttachmentList : [ExpenseAttachmentList] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emptyStateLabel.isHidden = true
        self.tableView.isHidden = true
        self.getExpenceDataList()
        addBackButtonView()
        self.title = "Expense Attachment"
        
        self.tableView.tableFooterView = UIView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getExpenceDataList()
    {
        if(checkInternetConnectivity())
        {
            showCustomActivityIndicatorView(loadingText: "Loading Attachment...")
            WebServiceHelper.sharedInstance.getExpenseApprovalAttachmentList(claimCode: claimCode, completion: { (apiObj) in
                if(apiObj.Status == SERVER_SUCCESS_CODE)
                {
                    removeCustomActivityView()
                    if(apiObj.list.count > 0)
                    {
                        let getAttachExpenseList = apiObj.list as! [NSDictionary]
                        self.expenseAttachmentList = []
                        for expenseObj in getAttachExpenseList
                        {
                            let expenseData = ExpenseAttachmentList()
                            expenseData.File_Name = checkNullAndNilValueForString(stringData: expenseObj.value(forKey: "File_Name") as? String)
                            expenseData.Claim_Code = checkNullAndNilValueForString(stringData:expenseObj.value(forKey: "Claim_Code") as? String)
                            expenseData.Image_File_Path = checkNullAndNilValueForString(stringData:expenseObj.value(forKey: "Image_File_Path") as? String)
                            self.expenseAttachmentList.append(expenseData)
                        }
                        self.emptyStateLabel.isHidden = true
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
                        
                    }
                    else
                    {
                        self.emptyStateLabel.isHidden = false
                        self.tableView.isHidden = true
                        self.emptyStateLabel.text = "No Expense attachment found"

                    }
                }
            })
        }
        else
        {
            //show empty state
            //No Internet connection
            self.emptyStateLabel.isHidden = false
            self.tableView.isHidden = true
            self.emptyStateLabel.text = "No Internet connection"
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenseAttachmentList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ExpenseAttachmentListID") as! UITableViewCell
        
        let getAttachmentData = expenseAttachmentList[indexPath.row]
        let attachmentName = cell.viewWithTag(1) as! UILabel
        let attachmentImage = cell.viewWithTag(2) as! UIImageView
        
        attachmentName.text = getAttachmentData.File_Name
//        // .jpeg, .jpg, .gif, .tif, .png, .pdf
        if(getAttachmentData.Image_File_Path.contains("png")||getAttachmentData.Image_File_Path.contains("jpg")||getAttachmentData.Image_File_Path.contains("jpeg"))
        {
            attachmentImage.image = #imageLiteral(resourceName: "image-placeholder")
        }
        else if(getAttachmentData.Image_File_Path.contains("pdf"))
        {
            attachmentImage.image = #imageLiteral(resourceName: "icon-pdf-thumbnail")
        }
        else
        {
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let getAttachmentData = self.expenseAttachmentList[indexPath.row]
        if let url = URL(string: getAttachmentData.Image_File_Path) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
//    //Mark:- Back Button
//    private func addBackButtonView()
//    {
//        
//        let backbutton = UIButton(type: .custom)
//        backbutton.setImage(UIImage(named: "navigation-arrow"), for: .normal) 
//        backbutton.setTitle("Back", for: .normal)
//        backbutton.setTitleColor(UIColor.white, for: .normal) // You can change the TitleColor
//        backbutton.addTarget(self, action: #selector(ExpenseAttachmentListController.backAction), for: .touchUpInside)
//        
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
//    }
//    
//    @objc func backAction() -> Void {
//        self.navigationController?.popViewController(animated: true)
//    }
}
