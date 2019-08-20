//
//  DocumentController.swift
//  HiDoctorApp
//
//  Created by Swaas on 29/01/19.
//  Copyright © 2019 swaas. All rights reserved.
//

import UIKit

class DocumentController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyState: UILabel!
    
    var documentList: [MyDocumentModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getDocument()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 300
        self.tableView.tableFooterView = UIView()
        self.title = "Documents"
        // Do any additional setup after loading the view.
    }

    
    
    func getDocument()
    {
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: "Loading...")
            WebServiceHelper.sharedInstance.getDocumentData { [weak self] (apiResponse) in
                removeCustomActivityView()
                if apiResponse.Status == SERVER_SUCCESS_CODE
                {
                    self?.emptyState.text = ""
                    self?.tableView.isHidden = false
                    if apiResponse.list.count > 0
                    {
                        self?.documentList = []
                        
                        for obj in apiResponse.list{
                            
                            let dict = obj as! [String:Any]
                            let responseObj = MyDocumentModel()
                            responseObj.Doc_Id = dict["Doc_Id"] as? Int ?? 0
                            responseObj.Doc_Name = dict["Doc_Name"] as? String ?? ""
                            responseObj.Doc_Type_Name = dict["Doc_Type_Name"] as? String ?? ""
                            responseObj.Doc_Year = dict["Doc_Year"] as? Int ?? 0
                            responseObj.File_Url = dict["File_Url"] as? String ?? ""
                            self?.documentList.append(responseObj)
                        }
                        self?.tableView.isHidden = false
                        self?.tableView.reloadData()
                    }
                    else
                    {
                        self?.tableView.isHidden = true
                        self?.emptyState.text = "No Document list found"
                    }
                }
                else
                {
                    AlertView.showAlertView(title: errorTitle, message: apiResponse.Message)
                }
            }
        }
        else
        {
            AlertView.showNoInternetAlert()
            self.tableView.isHidden = true
            self.emptyState.text = "Please check your network connection"
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.documentList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "MyDocumentCell") as! MyDocumentTableViewCell
        let documentObj = self.documentList[indexPath.row]
        cell.title.text = documentObj.Doc_Name
        cell.subTitle.text = documentObj.Doc_Type_Name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let documentObj = self.documentList[indexPath.row]
        
        guard let url = URL(string: documentObj.File_Url) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    func navigateTowebView(siteUrl:String, title:String)
    {
        let sb = UIStoryboard(name: mainSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: webViewVCID) as! WebViewController
        vc.siteURL = siteUrl
        vc.webViewTitle = title
        getAppDelegate().root_navigation.pushViewController(vc, animated: true)
        
    }
}



class MyDocumentTableViewCell: UITableViewCell
{
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
}

class MyDocumentModel:NSObject
{
    var Doc_Id: Int!
    var File_Url: String!
    var Doc_Name:String!
    var Doc_Type_Name: String!
    var Doc_Year: Int!
    
}

