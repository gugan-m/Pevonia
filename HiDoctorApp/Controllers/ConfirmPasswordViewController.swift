//
//  ConfirmPasswordViewController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 20/02/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class ConfirmPasswordViewController: UIViewController {

    
    @IBOutlet weak var displayLabel : UILabel!
    @IBOutlet weak var pedTextField : UITextField!
   
    var messageString : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayLabel.text = messageString
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recr
    }

    @IBAction func confirmPwd(_ sender: UIButton)
    {
        if pedTextField.text! == EMPTY
        {
            //Alert
            AlertView.showAlertView(title: alertTitle, message: "Please Enter Password", viewController: self)
            
        }
        else
        {
            showCustomActivityIndicatorView(loadingText: "Confirm Password")
            WebServiceHelper.sharedInstance.confirmPassword(password: pedTextField.text!, completion: { (apiResponseObject) in
                if(apiResponseObject.Status == SERVER_SUCCESS_CODE)
                {
                    BL_Password.sharedInstance.getUserAccountDetailsForVersionUpgrader(completion: { (status) in
                        if(status == SERVER_SUCCESS_CODE)
                        {
                            removeCustomActivityView()
                            let appDelegate = getAppDelegate()
                            appDelegate.allocateRootViewController(sbName: landingViewSb, vcName: landingVcID)
                        }
                    })
                }
                else
                {
                    removeCustomActivityView()
                    AlertView.showAlertView(title: alertTitle, message: apiResponseObject.Message, viewController: self)
                }
            })
        }
        
    }
}

