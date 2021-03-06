//
//  WebViewController.swift
//  HiDoctorApp
//
//  Created by Vijay on 17/03/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit


class WebViewController: UIViewController, UIWebViewDelegate {
    
   // @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var emptyStateWrapper: UIView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    var localURL :Bool = false
    var siteURL : String!
    var webViewTitle: String!
    var pageSource: Int = 0
    var isFromKennect : Bool = false
    var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = UIWebView(frame: self.view.frame)
        webView.scalesPageToFit = true
        webView.delegate = self
        self.view.addSubview(webView)
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = webViewTitle
        addCustomBackButtonToNavigationBar()
        addRightBarButtonItem()
        removeVersionToastView()
        loadSite()
        
        if siteURL == dashboardWebLink{
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadSite()
    {
        if let encodedUrl = siteURL.addingPercentEncoding(withAllowedCharacters: getCharacterSet() as CharacterSet)
        {
            if localURL == false
            {
                if checkInternetConnectivity()
                {
                    if let checkedUrl = URL(string: encodedUrl)
                    {
                        showActivityIndicator()
                        var req = NSURLRequest(url: checkedUrl)
                        //                        if isFromKennect
                        //                        {
                        //                           let urlValue =  URL(string:siteURL)
                        //                            req = NSURLRequest(url: urlValue!)
                        //                        }
                        let urlValue =  checkedUrl
                        req = NSURLRequest(url: urlValue)
                        self.webView.loadRequest(req as URLRequest)
                    }
                    else
                    {
                        setMainViewVisibility(isEmpty: true, text: webTryAgainMsg)
                    }
                }
                else
                {
                    setMainViewVisibility(isEmpty: true, text: internetOfflineMessage)
                }
            }
            else
            {
                if let checkedUrl = URL(string: encodedUrl)
                {
                    showActivityIndicator()
                    let req = NSURLRequest(url: checkedUrl)
                    self.webView.loadRequest(req as URLRequest)
                }
                else
                {
                    setMainViewVisibility(isEmpty: true, text: webTryAgainMsg)
                }
            }
        }
        else
        {
            setMainViewVisibility(isEmpty: true, text: webTryAgainMsg)
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
        if localURL == false{
            if checkInternetConnectivity()
            {
                setMainViewVisibility(isEmpty: true, text: webTryAgainMsg)
            }
            else
            {
                setMainViewVisibility(isEmpty: true, text: internetOfflineMessage)
            }
        }
        else
        {
            setMainViewVisibility(isEmpty: true, text: webTryAgainMsg)
        }
        
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
        
        showCustomActivityIndicatorView(loadingText: "Loading the content..")
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
    
    @IBAction func refreshAction(_ sender: Any)
    {
        if localURL == false
        {
            if checkInternetConnectivity()
            {
                loadSite()
            }
            else
            {
                AlertView.showNoInternetAlert()
            }
        }
        else
        {
            loadSite()
        }
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
        // _ = navigationController?.popViewController(animated: false)
        
        navigationController?.popViewController(animated: false)
        dismiss(animated: false, completion: nil)
    }
    
    private func addRightBarButtonItem()
    {
        if (self.pageSource == 1)
        {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(self.backButtonClicked))
        }
    }
}


