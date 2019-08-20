//
//  DashboardDigitalAssetTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 09/06/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

protocol SelectedAssetOptionInDashboard
{
    func getSelectedAssetOption(type : Int,assetObj : DashboardHeaderAssetModel)
}

struct SelectedAssetOption {
    static let NoOfDetailedAssets : Int = 0
    static let NoOfNonDetailedAssets : Int = 1
}

class DashboardDigitalAssetTableViewCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource
{

    @IBOutlet weak var headerImg: UIImageView!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var emptyStateView: UIView!
    
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    
    @IBOutlet weak var nonDetailedAssetsLbl: UILabel!
    @IBOutlet weak var detailedAssetsLbl: UILabel!
    @IBOutlet weak var top10DoctorLbl: UILabel!
    @IBOutlet weak var top10AssetsLbl: UILabel!
    
    @IBOutlet weak var eDetailingBtnConst: NSLayoutConstraint!
    
    @IBOutlet weak var eDetailingBtn: UIButton!
    var dashboardAssetList : [DashboardHeaderAssetModel] = []
    var selectedIndex : Int = 0
    var delegate : SelectedAssetOptionInDashboard?

    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        if SwifterSwift().isPhone
        {
           self.eDetailingBtnConst.constant = 120
        }
        else
        {
            self.eDetailingBtnConst.constant = 240
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dashboardAssetList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return BL_Dashboard.sharedInstance.getDashboardAssetSingleCellHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.DashboardHeaderAssetSubCell, for: indexPath) as! DashboardHeaderSubTableViewCell
        let obj = dashboardAssetList[indexPath.row]
        cell.descriptionLbl.text = obj.assetHeaderType
        cell.countLbl.text = obj.assetCount
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let assetObj = dashboardAssetList[indexPath.row]
        if Int(assetObj.assetCount)! > 0
        {
            delegate?.getSelectedAssetOption(type: indexPath.row,assetObj : assetObj)
        }
    }
}
