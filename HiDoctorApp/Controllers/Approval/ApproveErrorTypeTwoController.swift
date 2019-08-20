//
//  ApproveErrorTypeTwoController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 16/02/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class ApproveErrorTypeTwoController: UIViewController,UITableViewDataSource {

    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var errorLabel : UILabel!
    var approveErrorList : [ApproveErrorTypeTwo] = []
    var errorMessage = String()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.text = errorMessage
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return approveErrorList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ApproveErrorTypeTwo") as! ApproveErrorTableCellTwo
        
        cell.maximumDoctors.text = "Maximum \(appDoctor) Allowed"
        cell.maximumDoctorsCount.text = "\(approveErrorList[indexPath.row].Max_Count!)"
        cell.availableDoctors.text = "Available approved \(appDoctor)"
        cell.availableDoctorsCount.text = "\(approveErrorList[indexPath.row].Available_Count!)"
        cell.selectedApproval.text = "Selected for approval"
        cell.selectedApprovalCount.text = "\(approveErrorList[indexPath.row].Selected_Count!)"
        cell.excessDoctors.text = "Excess \(appDoctor)"
        cell.excessDoctorsCount.text = "\(approveErrorList[indexPath.row].Excess_Count!)"
        cell.entityName.text = approveErrorList[indexPath.row].Entity_Value + "(\(approveErrorList[indexPath.row].Entity_Type!))"
        
        return cell
    }

 
}
