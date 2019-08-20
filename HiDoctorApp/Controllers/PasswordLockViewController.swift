//
//  PasswordLockViewController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 20/02/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class PasswordLockViewController: UIViewController {

    @IBOutlet weak var displayMsg : UILabel!
    
    var messageString : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       displayMsg.text = messageString

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}
