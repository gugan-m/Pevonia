//
//  AboutUsViewController.swift
//  HiDoctorApp
//
//  Created by Vignaya on 1/31/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {
    
    @IBOutlet weak var companyUrl : UITextView!
    @IBOutlet weak var versionLbl: UILabel!
    @IBOutlet weak var companyEmail: UITextView!
    @IBOutlet weak var mobileNo: UITextView!
   
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.setDefaultDetails()
        addBackButtonView()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func setDefaultDetails()
    {
         self.versionLbl.text = "Version : v\(getCurrentAppVersion())"
         self.title = "About Us"
        setLinkToCompanyUrlTxtView()
       // self.setCompanyNumber()
       // setCompanyEmail()
    }
    
    func setLinkToCompanyUrlTxtView()
    {
        let companyUrl = "www.swaas.net"
        self.companyUrl.text = companyUrl
        self.companyUrl.textContainerInset = UIEdgeInsets.zero
        self.companyUrl.textContainer.lineFragmentPadding = 0
        self.companyUrl.dataDetectorTypes = UIDataDetectorTypes.all
        let hyperlinkColor = UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1.0)
        self.companyUrl.linkTextAttributes = [NSAttributedStringKey.underlineStyle.rawValue : NSUnderlineStyle.styleSingle.rawValue,NSAttributedStringKey.foregroundColor.rawValue : hyperlinkColor ]
    }
    
    func setCompanyNumber()
    {
        self.mobileNo.textContainerInset = UIEdgeInsets.zero
        self.mobileNo.text = "+91 90254-07475"
        self.mobileNo.textContainer.lineFragmentPadding = 0
    }
    
    func setCompanyEmail()
    {
        self.companyEmail.textContainerInset = UIEdgeInsets.zero
        self.companyEmail.text = "Pevonia.support@swaas.net"
        self.companyEmail.textContainer.lineFragmentPadding = 0
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
