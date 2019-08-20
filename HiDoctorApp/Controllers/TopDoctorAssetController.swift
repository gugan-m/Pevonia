//
//  TopDoctorAssetController.swift
//  HiDoctorApp
//
//  Created by Vijay on 30/06/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class TopDoctorAssetController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewHeightConst: NSLayoutConstraint!
    var doctorModel: DashboardTopDoctor!
    var imageList: [String: UIImage] = [String: UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.isHidden = true
        if doctorModel != nil
        {
            setDefaults()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- Set Defaults
    private func setDefaults()
    {
        setDoctorProfileImg()
        titleLbl.text = doctorModel.Doctor_Name
        if doctorModel.Category_Name != ""
        {
            descLbl.text = "\(doctorModel.MDL_No!) | \(doctorModel.Doctor_Speciality!) | \(doctorModel.Category_Name!)"
        }
        else
        {
            descLbl.text = "\(doctorModel.MDL_No!) | \(doctorModel.Doctor_Speciality!)"
        }
    }
    
    private func setDoctorProfileImg()
    {
        if doctorModel.Profile_Img != ""
        {
            ImageLoader.sharedLoader.imageForUrl(urlString: doctorModel.Profile_Img) {(image) in
                self.profilePic.image = image
            }
        }
        else
        {
            self.profilePic.image = UIImage(named: "profile-placeholder-image")
        }
    }
    
    private func getThumbnailImg(urlString: String)
    {
        ImageLoader.sharedLoader.imageForUrl(urlString: urlString) {(image) in
            if image != nil
            {
                self.imageList[urlString] = image
                self.tableView.reloadData()
            }
        }
    }
    
    private func setTableViewHeight()
    {
        tableView.layoutIfNeeded()
        tableViewHeightConst.constant = tableView.contentSize.height
    }
    
    //MARK:- Tableview delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctorModel.Asset_List.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let assetModel = doctorModel.Asset_List[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.TopDoctorAssetCell) as! TopDoctorAssetCell
        cell.nameLbl.text = assetModel.Asset_Name
        cell.noTimesLbl.text = "\(assetModel.No_Of_Views!) Times"
        cell.durationLbl.text = getPlayTime(timeVal: "\(assetModel.Duration!)")
        
        if assetModel.Asset_Thumbnail != ""
        {
            if assetModel.Asset_Thumbnail != EMPTY
            {
                ImageLoader.sharedLoader.imageForUrl(urlString: assetModel.Asset_Thumbnail) { (image) in
                    if image != nil
                    {
                        DispatchQueue.main.async {
                            cell.assetThumbImg.image = image
                        }
                    }
                }
            }
        }
        else
        {
            cell.assetThumbImg.image = BL_AssetModel.sharedInstance.getThumbnailImage(docType: assetModel.Asset_Type)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        setTableViewHeight()
    }
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: false)
    }
}
