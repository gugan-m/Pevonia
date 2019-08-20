//
//  DashBoardProductTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 05/05/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class DashBoardProductTableViewCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource
{

    @IBOutlet weak var salesDetailsLbl : UILabel!
    @IBOutlet weak var salesTimeLbl : UILabel!
    @IBOutlet weak var tableView  : UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var titleImg : UIImageView!
    @IBOutlet weak var collectionSalesView: UIView!
    @IBOutlet weak var totalSalesHgtConst: NSLayoutConstraint!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var collectionLbl: UILabel!
    @IBOutlet weak var outstandingLbl: UILabel!
    @IBOutlet weak var leftHeaderLblWidthConst: NSLayoutConstraint!
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var collectionDateLbl: UILabel!
    
    var productList : [DashboardPSDetailsModel] = []
    var salesList : [DashboardPSHeaderModel]  = []
    var selectedIndex : Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
       
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if selectedIndex == 0
        {
            return salesList.count
        }
        else if selectedIndex == 1
        {
            return productList.count
        }
       return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        var text : String = EMPTY
        
        if selectedIndex == 0
        {
            let salesObj = salesList[indexPath.row]
            text = checkNullAndNilValueForString(stringData: salesObj.Doc_Type_Name)
        }
        else if selectedIndex == 1
        {
            let productObj = productList[indexPath.row]
            text = checkNullAndNilValueForString(stringData: productObj.Product_Name)
        }
        
        return BL_Dashboard.sharedInstance.getProductSingleCellHeight(text:text)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.DashboardSalesSubProductCell) as! DCRAttendanceSubTableViewCell
        var line1Text : String = EMPTY
        var line2Text : String = "0"
        
        if selectedIndex == 0
        {
            let salesObj = salesList[indexPath.row]
            line1Text = "\(checkNullAndNilValueForString(stringData: salesObj.Doc_Type_Name)) :"
            if salesObj.Value != nil
            {
                line2Text = BL_Dashboard.sharedInstance.getAmountInThousand(amount: salesObj.Value)
            }
        }
        else if selectedIndex == 1
        {
            let productObj = productList[indexPath.row]
            line1Text = checkNullAndNilValueForString(stringData: productObj.Product_Name)
            line2Text =  BL_Dashboard.sharedInstance.getAmountInThousand(amount: productObj.Value)
        }
        
        cell.line1Label.text = line1Text
        cell.line2Label.text = line2Text
        
        return cell
    }
}
