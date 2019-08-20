//
//  BusinessStatusViewController.swift
//  HiDoctorApp
//
//  Created by SwaaS on 23/03/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

protocol BusinessStatusSelectDelegate
{
    func selectBusinessActivity(indexPath: IndexPath?, selectedStatus: BusinessStatusModel, isCallObjective: Bool)
    func seletCampaign(indexpath:IndexPath?,campaignObj:MCHeaderModel)
}

class BusinessStatusViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var businessStatusList: [BusinessStatusModel] = []
    var businessStatusPageSource: Int! = nil
    var delegate: BusinessStatusSelectDelegate?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    var indexPath: IndexPath?
    var isCallObjective: Bool = false
    var isCampaignSelect: Bool = false
    var campaignHeaderList: [MCHeaderModel] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 500
        tableView.reloadData()
        
        
        let dict = ["Campaign_Code":"","Campaign_Name":"Select Campaign"]
        let firstObj = MCHeaderModel(dict: dict as NSDictionary)
        
        
        
        if(!isCampaignSelect)
        {
            if (!isCallObjective)
            {
                self.title = "Choose Status"
            }
            else
            {
                self.title = "Choose Call Objective"
            }
        }
        else
        {
            self.title = "Choose Campaign"
            campaignHeaderList = DBHelper.sharedInstance.getMCListForDoctor(dcrActualDate: DCRModel.sharedInstance.dcrDateString, doctorCode: DCRModel.sharedInstance.customerCode, doctorRegionCode: DCRModel.sharedInstance.customerRegionCode)
            if campaignHeaderList.count > 0
            {
                campaignHeaderList.insert(firstObj, at: 0)
                self.tableView.isHidden = false
                self.tableView.reloadData()
                self.emptyLabel.isHidden = true
                self.emptyLabel.text = ""
            }
            else
            {
                self.tableView.isHidden = true
                self.emptyLabel.isHidden = false
                self.emptyLabel.text = "No Campaign"
            }
        }
        
        addCustomBackButtonToNavigationBar()
        
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
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

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(isCampaignSelect)
        {
            return campaignHeaderList.count
        }
        else
        {
            return businessStatusList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessStatusCell") as! BusinessStatusCell
        
        if(isCampaignSelect)
        {
            cell.statusLabel.text = campaignHeaderList[indexPath.row].Campaign_Name
        }
        else
        {
            cell.statusLabel.text = businessStatusList[indexPath.row].Status_Name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(isCampaignSelect)
        {
            let campaignObj = campaignHeaderList[indexPath.row]
            self.delegate?.seletCampaign(indexpath: self.indexPath, campaignObj: campaignObj)
        }
        else
        {
        let objStatus = businessStatusList[indexPath.row]
        self.delegate?.selectBusinessActivity(indexPath: self.indexPath, selectedStatus: objStatus, isCallObjective: self.isCallObjective)
        }
    }
}
