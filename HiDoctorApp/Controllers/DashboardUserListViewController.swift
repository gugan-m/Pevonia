//
//  DashboardUserListViewController.swift
//  HiDoctorApp
//
//  Created by Sabari on 14/07/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class DashboardUserListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    var dashboardAppliedList :[DashBoardAppliedCount] = []
    var dashBoardListArray: [NSDictionary] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.estimatedRowHeight = 500
        self.tableview.tableFooterView = UIView()
        self.getNameList()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getNameList()
    {
        var uniqueNmae: [String] = []
        
        for objDashboardApplied in dashboardAppliedList
        {
            if (!uniqueNmae.contains(objDashboardApplied.UserName))
            {
                    uniqueNmae.append(objDashboardApplied.UserName)
            }
        }
        
        uniqueNmae.sort(by: { (date1, date2) -> Bool in
            date1 > date2
        })
        for name in uniqueNmae
        {
            
            var dataArray = dashboardAppliedList.filter{
                $0.UserName == name
            }
            
            dataArray = dataArray.sorted(by: { (obj1, obj2) -> Bool in
                obj1.UserName < obj2.UserName
            })
            
            let dict: NSDictionary = ["User_Name": name, "Data_Array": dataArray]
            
            dashBoardListArray.append(dict)
        }
        self.tableview.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dashBoardListArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userListCell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.DashBoardUserListCell, for: indexPath) as! ApprovalUserContentTableViewCell
        let dict: NSDictionary = dashBoardListArray[indexPath.row]
        let monthList = (dict.value(forKey: "Data_Array") as! [DashBoardAppliedCount])
        userListCell.userCount.layer.masksToBounds = true
        userListCell.userCount.layer.cornerRadius = (userListCell.userCount.frame.width)/2
        userListCell.userName.text = (dict.value(forKey: "User_Name") as! String)
         userListCell.userId.text = ""
        userListCell.userDesignation.text = ""
        userListCell.userCount.text = "\(monthList.count)"
        userListCell.userCount.layer.cornerRadius = 15
        
        return userListCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Dashboard", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.DashBoardPendingMonthApprovalViewControllerID) as! DashBoardPendingMonthApprovalViewController
        let dict: NSDictionary = dashBoardListArray[indexPath.row]
        vc.dashboardAppliedList = (dict.value(forKey: "Data_Array") as! [DashBoardAppliedCount])
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
