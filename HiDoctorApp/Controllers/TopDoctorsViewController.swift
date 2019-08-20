//
//  TopDoctorsViewController.swift
//  HiDoctorApp
//
//  Created by Admin on 6/30/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class TopDoctorsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var emptyStateView: UIView!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    
    var topDoctorList = [DashboardTopDoctor]()
    var assetList = [DashboardTopAssets]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        doInitialSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doInitialSetup()  {
        showMainView()
        self.tableView.register(UINib.init(nibName: "TopDoctorTableviewCell", bundle: nil), forCellReuseIdentifier: "TopDoctorTableviewCell")
        getAssetandDoctorServiceCall()
        addCustomBackButtonToNavigationBar()
        self.navigationItem.title = "Top 10 \(appDoctorPlural)"
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
    
    @objc func backButtonClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func getAssetandDoctorServiceCall()
    {
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: "Loading..")
            BL_DashboardAsset.sharedInstance.getTopDoctorData(completion: { (topDoctorList, errorMsg) in
                removeCustomActivityView()

                if errorMsg == ""{
                     if topDoctorList.count > 0
                     {
                    self.topDoctorList = topDoctorList
                    self.tableView.reloadData()
                    self.showMainView()
                    }
                    else
                     {
                        self.showEmptyStateView(emptyStateText: "No \(appDoctorPlural) found")
                    }
                }
                else
                {
                   self.showEmptyStateView(emptyStateText: errorMsg)
                }
               
            })
        }else{
            showEmptyStateView(emptyStateText: internetOfflineMessage)
        }
    }
    
    
    private func showMainView()
    {
        mainView.isHidden = false
        emptyStateView.isHidden = true
    }
    
    private func showEmptyStateView(emptyStateText: String)
    {
        mainView.isHidden = true
        emptyStateView.isHidden = false
        emptyStateLabel.text = emptyStateText
    }
    
    @objc func moveToDoctorDetailAssetasController(button : UIButton){
        
        let sb = UIStoryboard(name: Constants.StoaryBoardNames.DashboardAssetSb , bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.TopDoctorAssetVCID) as! TopDoctorAssetController
        vc.doctorModel = topDoctorList[button.tag]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension TopDoctorsViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return topDoctorList.count
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopDoctorTableviewCell", for: indexPath) as! TopDoctorTableviewCell
        let doctorDetail = topDoctorList[indexPath.section]
        cell.nameLabel.text = doctorDetail.Doctor_Name
        cell.indexLabel.text = "\(indexPath.section + 1)"
        cell.durationLabel.text = getPlayTime(timeVal: "\(doctorDetail.Duration!)") 
        cell.specialistLabel.text = "\(doctorDetail.Doctor_Speciality!) | \(doctorDetail.Category_Name!)"
        cell.viewBtn.tag = indexPath.section
        cell.viewBtn.addTarget(self, action: #selector(moveToDoctorDetailAssetasController(button:)), for: .touchUpInside)
        if doctorDetail.Profile_Img != EMPTY
        {
            ImageLoader.sharedLoader.imageForUrl(urlString: doctorDetail.Profile_Img) { (image) in
                if image != nil
                {
                    DispatchQueue.main.async {
                        cell.profilePicImgVw.image = image
                    }
                }
            }
        }
        cell.selectionStyle = .none
    
        return cell
    }
    
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? TopDoctorTableviewCell else { return }
        
        assetList = topDoctorList[indexPath.section].Asset_List
        
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.section)
        tableViewCell.willDisplayCell()
        
//        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
     guard let tableViewCell = cell as? TopDoctorTableviewCell else { return }
        
        tableViewCell.didEndDisplayCell()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
     func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard cell is TopDoctorTableviewCell else { return }
        
//        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
}

extension TopDoctorsViewController: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topDoctorList[collectionView.tag].Asset_List.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopDoctorCollectionviewCell", for: indexPath) as! TopDoctorCollectionviewCell
       let asset = topDoctorList[collectionView.tag].Asset_List[indexPath.row]
        
        if asset.Asset_Thumbnail != EMPTY
        {
            ImageLoader.sharedLoader.imageForUrl(urlString: asset.Asset_Thumbnail) { (image) in
                if image != nil
                {
                    DispatchQueue.main.async {
                        cell.imgVw.image = image
                    }
                }else{
                    cell.imgVw.image = BL_AssetModel.sharedInstance.getThumbnailImage(docType: asset.Asset_Type)
                }
            }
        }else{
            cell.imgVw.image = BL_AssetModel.sharedInstance.getThumbnailImage(docType: asset.Asset_Type)

        }
        cell.durationLabel.text =  getPlayTime(timeVal:  "\(  asset.Duration!)")
        cell.descriptionLabel.text = asset.Asset_Name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: 185, height: 150)
        return size
    }
    
}

