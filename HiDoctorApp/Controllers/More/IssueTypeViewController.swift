//
//  IssueTypeViewController.swift
//  HiDoctorApp
//
//  Created by SwaaS on 09/01/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

protocol IssueTypeDelegate
{
    func getIssueType(issueType: String)
}

class IssueTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var dataArray: [String] = []
    var delegdate: IssueTypeDelegate!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        prepdareDataArray()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.title = "Issue Type"
        addBackButtonView()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    private func prepdareDataArray()
    {
        dataArray = [PEV_DCR_ENTRY, PEV_TOUR_PLAN, PEV_UPLOAD_MY_DCR, "Master Data Download", PEV_DCR_REFRESH, "Reports", "Change Password", "Others"]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IssueTypeCell") as! IssueTypeTableViewCell
        
        cell.issueTypeLabel.text = dataArray[indexPath.row]
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.delegdate.getIssueType(issueType: dataArray[indexPath.row])
        _ = self.navigationController?.popViewController(animated: true)
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
