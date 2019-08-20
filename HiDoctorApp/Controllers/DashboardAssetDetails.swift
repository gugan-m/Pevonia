//
//  DashboardAssetDetails.swift
//  HiDoctorApp
//
//  Created by Vijay on 09/06/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class DashboardAssetDetails: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var emptyStateWrapper: UIView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var isDetailed: Bool = false
    var count: Int!
    var entityType: Int!
    var userCode: String!
    var userName: String!
    var assetList : [DashboardAssetModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addCustomBackButtonToNavigationBar()
        
        if userName != nil
        {
            self.title = userName
        }

        if isDetailed == true
        {
            mainTitle.text = "Detailed Assets"
            entityType = 3
        }
        else
        {
            mainTitle.text = "Non-Detailed Assets"
            entityType = 4
        }
        countLbl.text = "\(count!)"
        
        tableView.estimatedRowHeight = 500
        
        getAssetServiceCall()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAssetServiceCall()
    {
        if checkInternetConnectivity()
        {
            showActivityIndicatorView()
            BL_DashboardAsset.sharedInstance.getAssetData(entityType: entityType, userCode: userCode) {(assetListData, errorMsg) in
                removeCustomActivityView()
                
                if self.assetList.count > 0
                {
                    self.assetList = []
                    
                }
                self.assetList = assetListData
                if self.assetList.count > 0
                {
                    self.setEmptyState(assetList: self.assetList, emptyStateMsg: "")
                }
                else
                {
                    if errorMsg != ""
                    {
                        self.setEmptyState(assetList: [], emptyStateMsg: errorMsg)
                    }
                    else
                    {
                        if self.isDetailed == true
                        {
                            self.setEmptyState(assetList: [], emptyStateMsg: "No assets have been detailed..")
                        }
                        else
                        {
                            self.setEmptyState(assetList: [], emptyStateMsg: "All assets have been detailed..")
                        }
                    }
                }
            }
        }
        else
        {
            setEmptyState(assetList: [], emptyStateMsg: internetOfflineMessage)
        }
    }
    
    func showActivityIndicatorView()
    {
        showCustomActivityIndicatorView(loadingText: "Loading..")
        if emptyStateWrapper.isHidden == false
        {
            emptyStateWrapper.isHidden = true
        }
        
        if mainView.isHidden == false
        {
            mainView.isHidden = true
        }
    }
    
    func setEmptyState(assetList: [DashboardAssetModel], emptyStateMsg: String)
    {
        if assetList.count > 0
        {
            mainView.isHidden = false
            emptyStateWrapper.isHidden = true
            tableView.reloadData()
        }
        else
        {
            mainView.isHidden = true
            emptyStateWrapper.isHidden = false
            emptyStateLbl.text = emptyStateMsg
        }
    }
    
    //MARK:- Tableview delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assetList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: dashboardAssetCell) as! DashboardAssetCell
        
        let model = assetList[indexPath.row]
        
        let docType = getDocTypeVal(docType: model.DA_Type)
        cell.assetName.text = "\(model.DA_Name!)"
        if model.DA_Size > 0.0
        {
            cell.assetSize.text = "\(docType) | \(model.DA_Size!) MB"
        }
        else
        {
            cell.assetSize.text = NOT_APPLICABLE
        }
        
        if model.DA_Thumbnail_Url != EMPTY
        {
            ImageLoader.sharedLoader.imageForUrl(urlString: model.DA_Thumbnail_Url) { (image) in
                if image != nil
                {
                    DispatchQueue.main.async {
                        cell.thumbnailImgVw.image = image
                    }
                }else{
                    cell.thumbnailImgVw.image = BL_AssetModel.sharedInstance.getThumbnailImage(docType: model.DA_Type)
                }
            }
        }else{
            cell.thumbnailImgVw.image = BL_AssetModel.sharedInstance.getThumbnailImage(docType: model.DA_Type)
            
        }
        
        if model.Uploaded_Date != ""
        {
            let dateString = model.Uploaded_Date
            let convertedDate = getDateAndTimeInFormat(dateString: dateString!)
            let convertedDateString = convertDateIntoServerStringFormat(date: convertedDate)
            cell.assetDate.text = convertedDateString
        }
        else
        {
            cell.assetDate.text = ""
        }
        
        return cell
    }

    @IBAction func refreshAction(_ sender: Any)
    {
        if checkInternetConnectivity()
        {
            getAssetServiceCall()
        }
        else
        {
            AlertView.showNoInternetAlert()
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
        _ = navigationController?.popViewController(animated: false)
    }
}
