//
//  TPCopyTourPlanMainTableViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 18/08/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class TPCopyTourPlanMainTableViewCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var sepView: UIView!
    @IBOutlet weak var childTableView: UITableView!
    @IBOutlet weak var emptyState: UIView!
    @IBOutlet weak var emptyLbl: UILabel!
    
    var callObjList:[HeaderCallObjModel] = BL_TP_CopyTpStepper.sharedInstance.callObjectDataList
    var sfcObjList:[CopyTpAccSFC] = BL_TP_CopyTpStepper.sharedInstance.tourPlannerSFCAcc
    var docObjList:[CopyAccDoctorDetails] = BL_TP_CopyTpStepper.sharedInstance.tourPlannerDoctorDetailsAcc
    var selectedIndex: Int!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //MARK:- TableView Datasource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(selectedIndex == 0)
        {

            return 2
            
        }
        else if(selectedIndex == 1)
        {
            
            return sfcObjList.count
            
        }
        else
        {
            return docObjList.count
            
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        let index = indexPath.row
        if (selectedIndex == 0)
        {
            return BL_TP_CopyTpStepper.sharedInstance.getChildTPActivityCellHeight()
            
        }
        else if (selectedIndex == 1)
        {
            return BL_TP_CopyTpStepper.sharedInstance.getChildTPTravelDetailsCellHeight()
        }
        else if (selectedIndex == 2)
        {
            return BL_TP_CopyTpStepper.sharedInstance.getChildDoctorDetailsCellHeight(selectedIndex: selectedIndex)
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(selectedIndex == 0)
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TPCopyActivityCell") as! TPCopyActivityCell
            
            let callObjectModel = callObjList[indexPath.row]
            cell.titleLbl.text = callObjectModel.objTitle
            cell.activityTypeLbl.text = callObjectModel.objName
            return cell
        }
        else if(selectedIndex == 1)
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TPCopyTravelDetailCell") as! TPCopyPlaceDetailCell
            
            let sfcObjModel = sfcObjList[indexPath.row]
            cell.fromPlaceLbl.text = sfcObjModel.from_Place
            cell.toPlaceLbl.text = sfcObjModel.to_Place
            cell.travelModeLbl.text = sfcObjModel.travel_Mode
            cell.distanceLbl.text = sfcObjModel.distance
            return cell
        }
        else
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TPCopyDoctorDetailCell") as! TPCopyDoctorDetailCell
            
            let docObjModel = docObjList[indexPath.row]
            cell.doctorNameLbl.text = docObjModel.doctor_Name
            cell.doctorDetailsLbl.text = String(format: "%@ | %@ | %@ | %@", docObjModel.mdl, docObjModel.doctorSpeciality, docObjModel.category_Name, docObjModel.doctor_Region_Code)
            return cell
        }
    }
    
    

}
class TPCopyActivityCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var activityTypeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class TPCopyPlaceDetailCell: UITableViewCell {
    
    @IBOutlet weak var fromPlaceLbl: UILabel!
    @IBOutlet weak var toPlaceLbl: UILabel!
    @IBOutlet weak var travelModeLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class TPCopyDoctorDetailCell: UITableViewCell {
    
    @IBOutlet weak var doctorNameLbl: UILabel!
    @IBOutlet weak var doctorDetailsLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

