//
//  CodeOfConductViewController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 28/05/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit
import WebKit

class CodeOfConductViewController: UIViewController {
    
    @IBOutlet weak var web_sourceView: UIView!
    @IBOutlet weak var agreeLabel: UILabel!
    @IBOutlet weak var nextBut: UIButton!
    @IBOutlet weak var agreeImage: UIImageView!
    @IBOutlet weak var centerVertical: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!

    var codeOfConductObj = NSDictionary()
    var isComingFromCompanyLogin : Bool = false
    var webKitView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideAll(value: true)
        self.nextBut.isHidden = true
        self.centerVertical.constant = 45
        
        webKitView = WKWebView(frame: self.web_sourceView.frame)
        self.webKitView.uiDelegate = self
        self.webKitView.navigationDelegate = self
        self.web_sourceView.addSubview(webKitView)
        
        getCodeOfConduct()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func navigateToPrepareMYDevice(_ sender: AnyObject) {
        self.acknowledgeAgree()
    }
    
    @IBAction func logOut(_ sender: AnyObject) {
        BL_Logout.sharedInstance.clearAllData()
        if(self.isComingFromCompanyLogin)
        {
            BL_MenuAccess.sharedInstance.logout(viewController: self)
        }
        else
        {
            let sb = UIStoryboard(name: MoreViewMasterSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: LogoutVcID) as! LogoutViewController
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    @IBAction func accknowledgeAction(_ sender: AnyObject) {
        if(agreeImage.image == UIImage(named: "icon-checkbox-blank"))
        {
            agreeImage.image = UIImage(named: "icon-checkbox")
            self.nextBut.isHidden = false
            self.centerVertical.constant = 0
        }
        else
        {
            agreeImage.image = UIImage(named: "icon-checkbox-blank")
            self.nextBut.isHidden = true
            self.centerVertical.constant = 45
        }
    }
    
    func getCodeOfConduct()
    {
        BL_InitialSetup.sharedInstance.checkCodeOfConduct { (response) in
            if(response)
            {
                let codeOfConductList = BL_InitialSetup.sharedInstance.codeOfConductObj.list
                self.codeOfConductObj = codeOfConductList![0] as! NSDictionary
                self.titleLabel.text = "\n" + (self.codeOfConductObj.value(forKey:"File_Title") as? String)! + "\n\n" + (self.codeOfConductObj.value(forKey:"File_Instructions") as! String)
                self.title = self.codeOfConductObj.value(forKey:"File_Title") as? String
                let urlFile = self.codeOfConductObj.value(forKey:"File_Name") as! String
                let urlString = "https://dev1.hidoctor.me/Content/CodeofContent/" + getCompanyCode().lowercased() + "/" + urlFile
                let req = NSURLRequest(url: URL(string:urlString)!)
                self.agreeLabel.text = (self.codeOfConductObj.value(forKey:"Ack_Option") as! String)
                self.webKitView.load(req as URLRequest)
                showCustomActivityIndicatorView(loadingText: "Loading....")
            }
            else
            {
                BL_InitialSetup.sharedInstance.codeOfConductObj = nil
            }
        }
    }
    
    func acknowledgeAgree()
    {
        let postData = ["User_Type_Code":getUserTypeCode(),"User_Code":getUserCode(),"File_Id":self.codeOfConductObj.value(forKey: "File_Id")] as! [String:Any]
        if(checkInternetConnectivity())
        {
            showCustomActivityIndicatorView(loadingText: "Loading...")
            WebServiceHelper.sharedInstance.postCOdeOFConductAccknowledgement(postData: postData) { (apiObj) in
                if(apiObj.Status == SERVER_SUCCESS_CODE)
                {
                    removeCustomActivityView()
                    UserDefaults.standard.set(Date(),forKey: "CodeOfConduct")
                    if(self.isComingFromCompanyLogin)
                    {
                        let appDelegate = getAppDelegate()
                        appDelegate.allocatePrepareAsRoot()
                    }
                    else
                    {
                        self.dismiss(animated: false, completion: nil)
                    }
                }
                else
                {
                    removeCustomActivityView()
                    AlertView.showAlertView(title: errorTitle, message: apiObj.Message, viewController: self)
                }
            }
        }
        else
        {
            AlertView.showAlertView(title: internetOfflineTitle, message: internetOfflineMessage, viewController: self)
        }
    }
    
    func hideAll(value: Bool)
    {
        agreeLabel.isHidden = value
        agreeImage.isHidden = value
        titleLabel.isHidden = value
        
    }
}

extension CodeOfConductViewController : WKUIDelegate,WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        removeCustomActivityView()
        self.hideAll(value: false)
    }
}
