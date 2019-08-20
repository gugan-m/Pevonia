//
//  DCRRefreshPopupController.swift
//  HiDoctorApp
//
//  Created by Vijay on 13/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
protocol dismissViewDelegate
{
    func dismissFunction(vcID : String)
}

class DCRRefreshPopupController: UIViewController {

    @IBOutlet weak var uploadCheck: UIImageView!
    @IBOutlet weak var refreshCheck: UIImageView!
    
    var uploadCheckFlag : Bool = true
    var delegate : dismissViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeBtnAction(_ sender: AnyObject)
    {
        self.dismissController()
    }
    
    @IBAction func uploadDCRAction(_ sender: AnyObject)
    {
        if uploadCheckFlag == false
        {
            uploadCheckFlag = true
            uploadCheck.image = UIImage(named: "icon-checkbox")
            refreshCheck.image = UIImage(named: "icon-checkbox-blank")
        }
    }

    @IBAction func refreshAction(_ sender: AnyObject)
    {
        if uploadCheckFlag == true
        {
            uploadCheckFlag = false
            uploadCheck.image = UIImage(named: "icon-checkbox-blank")
            refreshCheck.image = UIImage(named: "icon-checkbox")
        }
    }
    
    @IBAction func cancelAction(_ sender: AnyObject)
    {
        self.dismissController()
    }
    
    @IBAction func proceedAction(_ sender: AnyObject)
    {
       /* if uploadCheckFlag == true
        {
            dismissController()
            delegate?.dismissFunction(vcID: DCRUploadVcID)
        }
        else
        {
            showDCRRefreshAlert()
        }*/
        
        self.dismissController()
        self.delegate?.dismissFunction(vcID: RefreshVcID)
        
    }
    
    private func showDCRRefreshAlert()
    {
        let alert = UIAlertController(title: "Alert", message: dcrRefreshErrorMsg, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "PROCEED", style: .default, handler: { (action: UIAlertAction!) in
            self.dismissController()
            self.delegate?.dismissFunction(vcID: RefreshVcID)
        }))
        
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (action: UIAlertAction!) in
            self.dismissController()
        }))
        
        present(alert, animated: true, completion: nil)
    }

    private func dismissController()
    {
        self.dismiss(animated: false, completion: nil)
    }
}
