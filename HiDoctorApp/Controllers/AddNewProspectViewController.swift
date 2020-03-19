//
//  AddNewProspectViewController.swift
//  HiDoctorApp
//
//  Created by SSPLLAP-011 on 19/03/20.
//  Copyright © 2020 swaas. All rights reserved.
//

import UIKit

class AddNewProspectViewController: UIViewController {

    //MARK:- Outlets
    
    @IBOutlet weak var viewAccountName: UIView!
    @IBOutlet weak var viewProspectName: UIView!
    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var viewCity: UIView!
    @IBOutlet weak var viewState: UIView!
    @IBOutlet weak var viewZip: UIView!
    @IBOutlet weak var viewPhoneNumber: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewStatus: UIView!
    
    @IBOutlet weak var txtAccountName: UITextField!
    @IBOutlet weak var txtProspectName: UITextField!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtZip: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var segmentStatus: UISegmentedControl!
    
    //MARK:- Variables

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func act_Save(_ sender: UIButton) {
        self.doValidation()
    }
    
    func doValidation()
    {
        if txtAccountName.text?.count == 0 {
            AlertView.showAlertView(title: "Account Name", message: "Please enter account name")
        } else if txtProspectName.text?.count == 0 {
            AlertView.showAlertView(title: "Prospect Name", message: "Please enter prospect name")
        } else if txtTitle.text?.count == 0 {
            AlertView.showAlertView(title: "Title", message: "Please enter title")
        } else if txtCity.text?.count == 0 {
            AlertView.showAlertView(title: "City", message: "Please enter city")
        } else if txtState.text?.count == 0 {
            AlertView.showAlertView(title: "State", message: "Please enter state")
        } else if txtZip.text?.count == 0 {
            AlertView.showAlertView(title: "Zip", message: "Please enter zip")
        } else if txtPhoneNumber.text?.count == 0 {
            AlertView.showAlertView(title: "Phone Number", message: "Please enter phone number")
        } else if txtEmail.text?.count == 0 {
            AlertView.showAlertView(title: "Email ", message: "Please enter email")
        } else {
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
