//
//  DashboardAssetDoctorDetails.swift
//  HiDoctorApp
//
//  Created by Vijay on 09/06/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class DashboardAssetDoctorDetails: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var emptyStateWrapper: UIView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var userModelList: [DashboardAssetUserModel] = []
    var isDetailed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addCustomBackButtonToNavigationBar()
        
        if isDetailed == true
        {
            self.title = "Detailed users"
            //mainTitle.text = "Detailed users"
        }
        else
        {
            self.title = "Non detailed users"
            //mainTitle.text = "Non detailed users"
        }
        
        getUserData()
        
        tableView.estimatedRowHeight = 500
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserData()
    {
        let userList = BL_Dashboard.sharedInstance.dashBoardAssetCountListValues
        for dict in userList
        {
            if let dictionary = dict as? NSDictionary
            {
                let model = DashboardAssetUserModel()
                model.userCode = dictionary.value(forKey: "User_Code") as! String
                model.userName = checkNullAndNilValueForString(stringData: dictionary.value(forKey: "User_Name") as? String)
                if isDetailed == true
                {
                    if let detailedCountVal = dictionary.value(forKey: "Detailed_Assets") as? Int
                    {
                        model.count = detailedCountVal
                    }
                    else
                    {
                        model.count = 0
                    }
                }
                else
                {
                    if let nonDetailedCountVal = dictionary.value(forKey: "Non_Detailed_Assets") as? Int
                    {
                        model.count = nonDetailedCountVal
                    }
                    else
                    {
                        model.count = 0
                    }
                }
                
                userModelList.append(model)
            }
        }
        
        if userModelList.count > 0
        {
            setEmptyState(userList: userModelList, errorMsg: "")
        }
        else
        {
            if isDetailed == true
            {
                setEmptyState(userList: [], errorMsg: "No detailed users found..")
            }
            else
            {
                setEmptyState(userList: [], errorMsg: "No non detailed users found..")
            }
        }
    }
    
    func setEmptyState(userList: [DashboardAssetUserModel], errorMsg: String)
    {
        if userList.count > 0
        {
            mainView.isHidden = false
            emptyStateWrapper.isHidden = true
            tableView.reloadData()
        }
        else
        {
            mainView.isHidden = true
            emptyStateWrapper.isHidden = false
            emptyStateLbl.text = errorMsg
        }
    }
    
    //MARK:- Tableview delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userModelList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: dashboardAssetDoctorCell) as! DashboardAssetDoctorCell
        
        let model = userModelList[indexPath.row]
        
        cell.doctorName.text = model.userName
        cell.countLbl.text = "\(model.count!)"
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: Constants.StoaryBoardNames.DashboardAssetSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.DashboardAssetDetailsVCID) as! DashboardAssetDetails
        vc.isDetailed = isDetailed
        vc.count = userModelList[indexPath.row].count
        vc.userCode = userModelList[indexPath.row].userCode
        vc.userName = userModelList[indexPath.row].userName
        self.navigationController?.pushViewController(vc, animated: true)
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
