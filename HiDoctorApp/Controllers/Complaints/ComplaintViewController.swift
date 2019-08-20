//
//  ComplaintViewController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 17/05/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class ComplaintViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Complaint"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func riseComplaintBut(_ sender: UIButton) {
        
        let sb = UIStoryboard(name: commonListSb, bundle: nil)
        let vc:ComplaintFormViewController = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.ComplaintFormViewControllerID) as! ComplaintFormViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func trackComplaintBut(_ sender:UIButton)
    {
        if isManager()
        {
            let sb = UIStoryboard(name: commonListSb, bundle: nil)
            let vc:UserListViewController = sb.instantiateViewController(withIdentifier: userListVcID) as! UserListViewController
            vc.navigationScreenName = doctorMasterVcID
            vc.isFromDCR = false
            vc.isFromComplaint = true
            vc.isFromComplaintTrack = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let sb = UIStoryboard(name: commonListSb, bundle: nil)
            let vc:ComplaintListViewController = sb.instantiateViewController(withIdentifier: ComplaintListViewControllerID) as! ComplaintListViewController
            //vc.regionCode = self.regionCode
            vc.regionCode = getRegionCode()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
   
}
