//
//  TPStepperDoctorTableViewCell.swift
//  HiDoctorApp
//
//  Created by Admin on 7/27/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class TPStepperDoctorTableViewCell: UITableViewCell ,UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var line1Text: UILabel!
    @IBOutlet weak var line2Text: UILabel!
    @IBOutlet weak var removeDoctorBtn: UIButton!
    @IBOutlet weak var addSampleBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sampleLabel: UILabel!
    @IBOutlet weak var companyIcon: UIImageView!
    @IBOutlet weak var sectionToggleImageView: TintColorForImageView!
    
    var currentIndex = 0
    var isFromTp = false
    var sampleList = [SampleBatchProductModel]()
    var sampleList1 = [DCRSampleModel]()
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(isFromTp)
        {
            return 1
        }
        else
        {
            return self.sampleList.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(isFromTp)
        {
            return sampleList1.count
        }
        else
        {
        return sampleList[section].sampleList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: DoctorSampleTVCell)
        
        let sample : DCRSampleModel!
        if(isFromTp)
        {
            sample = sampleList1[indexPath.row]
        }
        else
        {
            sample = sampleList[indexPath.section].sampleList[indexPath.row]
        }
        cell!.textLabel!.text = sample.sampleObj.Product_Name + "(" + "\(sample.sampleObj.Quantity_Provided!)" + ")"
        cell!.textLabel!.font = UIFont(name: fontRegular, size: 12)
        cell!.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(!isFromTp)
        {
           return 20
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor.white
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.font = UIFont(name: fontRegular, size: 12)
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(!isFromTp)
        {
            if(sampleList[section].isShowSection)
            {
                return sampleList[section].title
            }
            else
            {
                return ""
            }
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 20
    }
}
