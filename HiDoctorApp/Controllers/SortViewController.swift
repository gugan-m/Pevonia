//
//  SortViewController.swift
//  HiDoctorApp
//
//  Created by Vijay on 18/05/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

protocol SortDelegate
{
    func getSelectedIndex(index: Int, name: String)
}

class SortViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var delegate : SortDelegate?
    var sortList : [String] = ["Name", ccmNumberCaption, "Speciality", "Category", "Work Place", "Organisation"]
    var selectedIndex: Int = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.SHOW_ORGANISATION_IN_CUSTOMER) == PrivilegeValues.YES.rawValue)
        {
            sortList = ["Name", ccmNumberCaption, "Speciality", "Category", "Work Place", "Organisation"]
        }
        else
        {
            sortList = ["Name", ccmNumberCaption, "Speciality", "Category", "Work Place"]
        }
            // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sortList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.SortCell)
        
        cell?.textLabel?.text = sortList[indexPath.row]
        cell?.textLabel?.textColor = UIColor.darkGray
        
        if selectedIndex == indexPath.row
        {
            cell?.accessoryType = .checkmark
            cell?.textLabel?.font = UIFont(name: fontSemiBold, size: 14.0)
        }
        else
        {
            cell?.accessoryType = .none
            cell?.textLabel?.font = UIFont(name: fontRegular, size: 14.0)
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let name = sortList[indexPath.row]
        if delegate != nil
        {
            delegate?.getSelectedIndex(index: indexPath.row, name: name)
        }
        
        self.dismiss(animated: false, completion: nil)
    }
}
