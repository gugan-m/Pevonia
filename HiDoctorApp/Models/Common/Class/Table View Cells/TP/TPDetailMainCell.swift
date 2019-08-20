//
//  TPDetailMainCell.swift
//  HiDoctorApp
//
//  Created by Vijay on 26/07/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class TPDetailMainCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var seperator: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var emptyLbl: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var childTableView: UITableView!
    @IBOutlet weak var sepView: UIView!
    
    var selectedIndex: Int!
    var activity: Int!
    let acc:[UserMasterWrapperModel] = BL_TPStepper.sharedInstance.getSelectedAccompanists(tp_Entry_Id: TPModel.sharedInstance.tpEntryId)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    // MARK:- Table View Delegates
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // stepperObj = BL_Stepper.sharedInstance.stepperDataList[self.selectedIndex]
        
        if(activity == 1)
        {
            
            if(selectedIndex == 0)
            {
                return BL_TPCalendar.sharedInstance.callObjectDataList.count
                
            }
            else if(selectedIndex == 1)
            {
                
                return BL_TPCalendar.sharedInstance.Accompanist.count
                
            }
            else if(selectedIndex == 2)
            {
                return BL_TPCalendar.sharedInstance.tourPlannerSFC.count
                
            }
            else if(selectedIndex == 3)
            {
                
                return BL_TPCalendar.sharedInstance.tourPlannerDoctor.count
                
            }
            else
            {
                return 0
            }
            
        }
        else if(activity == 2)
        {
            
            if(selectedIndex == 0)
            {
                return BL_TPCalendar.sharedInstance.callObjectDataList.count
                
            }
          
            else
            {
                return BL_TPCalendar.sharedInstance.tourPlannerSFC.count
                
            }
          
        }
        else
        {
            
            return BL_TPCalendar.sharedInstance.callObjectDataList.count
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        let index = indexPath.row
        
        if(activity == 1)
        {
            
            if (selectedIndex == 0)
            {
                return BL_TPCalendar.sharedInstance.getChildTourPlanCellHeight()
                
            }
            else if (selectedIndex == 1)
            {
                return BL_TPCalendar.sharedInstance.getChildAccompaniestCellHeight()
            }
            else if (selectedIndex == 2)
            {
                return BL_TPCalendar.sharedInstance.getChildPlaceDetailsCellHeight()
            }
            else if (selectedIndex == 3)
            {
                return BL_TPCalendar.sharedInstance.getChildDoctorDetailsCellHeight(index: index)
            }
            else
            {
                return 0
            }
        }
        else if(activity == 2)
        {
            
            if (selectedIndex == 0)
            {
                return BL_TPCalendar.sharedInstance.getChildTourPlanCellHeight()
                
            }
            else
            {
                return BL_TPCalendar.sharedInstance.getChildPlaceDetailsCellHeight()
            }
            
        }
        else
        {
            return BL_TPCalendar.sharedInstance.getChildTourPlanCellHeight()
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(activity == 1)
        {
            if(selectedIndex == 0)
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TPActivityCell") as! TPActivityCell
                let callObjectModel = BL_TPCalendar.sharedInstance.callObjectDataList[indexPath.row]
                
                cell.line1Lbl.text = callObjectModel.objTitle
                cell.line2Lbl.text = callObjectModel.objName
                
                return cell
            }
            else if(selectedIndex == 1)
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TPAccompDetailCell") as! TPAccompanistDetailCell
                let accObjModel = BL_TPCalendar.sharedInstance.Accompanist[indexPath.row]
                
                cell.accompNameLbl.text = accObjModel.userObj.Employee_name
                
                return cell
            }
            else if(selectedIndex == 2)
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TPPlaceDetailCell") as! TPPlaceDetailCell
                let sfcObjModel = BL_TPCalendar.sharedInstance.tourPlannerSFC[indexPath.row]
                
                cell.fromPlaceLbl.text = sfcObjModel.From_Place
                cell.toPlaceLbl.text = sfcObjModel.To_Place
                cell.travelModeLbl.text = sfcObjModel.Travel_Mode
                
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TPDoctorDetailCell") as! TPDoctorDetailCell
                let doctorObjModel = BL_TPCalendar.sharedInstance.tourPlannerDoctor[indexPath.row]
                
                cell.doctorNameLbl.text = doctorObjModel.Doctor_Name
                cell.doctorDetailsLbl.text = String(format: "%@ | %@ | %@ | %@", doctorObjModel.MDL_Number!, doctorObjModel.Speciality_Name, doctorObjModel.Category_Name!, doctorObjModel.Doctor_Region_Name!)
                
                return cell
            }
        }
        else if(activity == 2)
        {
            if(selectedIndex == 0)
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TPActivityCell") as! TPActivityCell
                let index = indexPath.row
                let callObjectModel:CallObjectModel = BL_TPCalendar.sharedInstance.callObjectDataList[index]
                
                cell.line1Lbl.text = callObjectModel.objTitle
                cell.line2Lbl.text = callObjectModel.objName
                
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TPPlaceDetailCell") as! TPPlaceDetailCell
                let sfcObjModel = BL_TPCalendar.sharedInstance.tourPlannerSFC[indexPath.row]
                
                cell.fromPlaceLbl.text = sfcObjModel.From_Place
                cell.toPlaceLbl.text = sfcObjModel.To_Place
                cell.travelModeLbl.text = sfcObjModel.Travel_Mode
                
                return cell
            }
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TPActivityCell") as! TPActivityCell
            let index = indexPath.row
            let callObjectModel:CallObjectModel = BL_TPCalendar.sharedInstance.callObjectDataList[index]
            
            cell.line1Lbl.text = callObjectModel.objTitle
            cell.line2Lbl.text = callObjectModel.objName
            
            return cell
            
        }
    }
}

class TPActivityCell: UITableViewCell {
    
    @IBOutlet weak var line1Lbl: UILabel!
    @IBOutlet weak var line2Lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class TPAccompanistDetailCell: UITableViewCell {
    
    @IBOutlet weak var accompNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class TPPlaceDetailCell: UITableViewCell {
    
    @IBOutlet weak var fromPlaceLbl: UILabel!
    @IBOutlet weak var toPlaceLbl: UILabel!
    @IBOutlet weak var travelModeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class TPDoctorDetailCell: UITableViewCell {
    
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
