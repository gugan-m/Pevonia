//
//  LeaveEntryDropDownViewController.swift
//  HiDoctorApp
//
//  Created by Vignaya on 12/8/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

protocol leaveEntryListDelegate
{
    func getLeaveEntrySelectedObj(obj : LeaveTypeMaster)
}

class LeaveEntryDropDownViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var currentList : [LeaveTypeMaster] = []
    var leaveSelectedType : NSMutableArray = []
    var delegate : leaveEntryListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        currentList = BL_DCR_Leave.sharedInstance.getLeaveTypes()!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: LeaveEntryDropDownCell, for: indexPath) as! LeaveEntryDropDownTableViewCell
        let cellObj = currentList[indexPath.row]
        let leaveType = cellObj.Leave_Type_Name as String
        Cell.leaveTypeLbl.text = leaveType
        return Cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let listObj = currentList[indexPath.row]
        delegate?.getLeaveEntrySelectedObj(obj: listObj)
        _ = navigationController?.popViewController(animated: false)
    }

}
