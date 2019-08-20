//
//  FileViewController.swift
//  HiDoctorApp
//
//  Created by Vijay on 15/05/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class FileViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var emptyStateWrapper: UIView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    var isFromChemistDay = false
    var isfromLeave = false
    
    var model: DCRAttachmentModel?
    var leaveModel: DCRLeaveModel?
    var fileURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = model?.attachmentName
        addCustomBackButtonToNavigationBar()
        loadFile()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadFile()
    {
        if(isfromLeave)
        {
             fileURL = Bl_Attachment.sharedInstance.getAttachmentFileURL(fileName: (leaveModel?.attachmentName)!)
        }
        else
        {
             fileURL = Bl_Attachment.sharedInstance.getAttachmentFileURL(fileName: (model?.attachmentName)!)
        }
        
//        let fileURL = Bl_Attachment.sharedInstance.getAttachmentFileURL(fileName: (model?.attachmentName)!)
        if let encodedUrl = fileURL.addingPercentEncoding(withAllowedCharacters: getCharacterSet() as CharacterSet)
        {
            if let checkedUrl = URL(string: encodedUrl)
            {
                showActivityIndicator()
                let req = NSURLRequest(url: checkedUrl)
                self.webView.loadRequest(req as URLRequest)
            }
            else
            {
                setMainViewVisibility(isEmpty: true, text: attachWebTryAgainMsg)
            }
        }
        else
        {
            setMainViewVisibility(isEmpty: true, text: attachWebTryAgainMsg)
        }
    }
    
    //MARK:- Webview delegates
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        hideActivityIndicator()
        setMainViewVisibility(isEmpty: false, text: "")
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        return true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        hideActivityIndicator()
        setMainViewVisibility(isEmpty: true, text: attachWebTryAgainMsg)
    }
    
    func showActivityIndicator()
    {
        if webView.isHidden == false
        {
            webView.isHidden = true
        }
        if emptyStateWrapper.isHidden == false
        {
            emptyStateWrapper.isHidden = true
        }
        
        showCustomActivityIndicatorView(loadingText: "Loading the attachment..")
    }
    
    func hideActivityIndicator()
    {
        removeCustomActivityView()
    }
    
    func setMainViewVisibility(isEmpty: Bool, text: String)
    {
        if isEmpty
        {
            webView.isHidden = true
            emptyStateWrapper.isHidden = false
            emptyStateLbl.text = text
        }
        else
        {
            webView.isHidden = false
            emptyStateWrapper.isHidden = true
        }
    }
    
    private func addCustomBackButtonToNavigationBar()
    {
        let backButton = UIButton(type: UIButtonType.custom)
        
        backButton.addTarget(self, action: #selector(self.backButtonClicked), for: UIControlEvents.touchUpInside)
        backButton.setImage(UIImage(named: "icon-close"), for: .normal)
        backButton.sizeToFit()
        
        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func backButtonClicked()
    {
        self.dismiss(animated: true, completion: nil)
    }

}
