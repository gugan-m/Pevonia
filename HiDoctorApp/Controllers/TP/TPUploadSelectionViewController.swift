//
//  TPUploadSelectionViewController.swift
//  HiDoctorApp
//
//  Created by SwaaS on 11/08/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class TPUploadSelectionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    
    //MARK:- Variable
    var uploadList : [TPUploadModel] = []
    
    //MARK:- View Controller Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "\(PEV_TP) Upload"
        uploadList = BL_TPUpload.sharedInstance.getMonthWisePendingTPCount()
        updateViews()
        addBackButtonView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        uploadList = BL_TPUpload.sharedInstance.getMonthWisePendingTPCount()
        updateViews()
    }
    
    //MARk:- TableView DataSource and Delegate
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return uploadList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TPUploadSelectCell", for: indexPath) as! TPUploadSelectionTableViewCell
        let uploadObj = uploadList[indexPath.row]
        
        cell.monthWithActivityFlagLbl.text = "\(getMonthName(monthNumber: uploadObj.Month!)) \(uploadObj.Year!)"
        cell.tpActivityCountLbl.text = "\(uploadObj.Count!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let uploadObj = uploadList[indexPath.row]
        let uploadSB = UIStoryboard(name: Constants.StoaryBoardNames.TPUploadSb, bundle: nil)
        let vc = uploadSB.instantiateViewController(withIdentifier: Constants.ViewControllerNames.TPUploadDetailsVCID) as! TPUploadDetailsViewController
        
        vc.uploadList = BL_TPUpload.sharedInstance.getPendingTPForSelectedMonth(month: uploadObj.Month!, year: uploadObj.Year)
        vc.selectedMonth = uploadObj.Month
        vc.selectedYear = uploadObj.Year
        vc.navigationTitle = "\(getMonthName(monthNumber: uploadObj.Month!)) \(uploadObj.Year!)"
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    private func updateViews()
    {
        if uploadList.count == 0
        {
            self.emptyStateView.isHidden = false
            self.emptyStateLabel.text = "No PR Data available for upload"
            self.tableView.isHidden = true
        }
        else
        {
            self.emptyStateView.isHidden = true
            self.tableView.isHidden = false
            
            tableView.reloadData()
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
        if let navigationController = self.navigationController
        {
            let vcList = navigationController.viewControllers
            var index = 0
            var isFound: Bool = false
            
            for currentVC: UIViewController in vcList
            {
                if (currentVC is TPStepperViewController)
                {
                    isFound = true
                    break
                }
                else if (currentVC is TPAttendanceStepperViewController)
                {
                    isFound = true
                    break
                }
                
                index += 1
            }
            
            if (isFound)
            {
                self.navigationController?.viewControllers.remove(at: index)
            }
        }
        
        _ = navigationController?.popViewController(animated: false)
    }
}
