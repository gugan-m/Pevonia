//
//  RcpaListController.swift
//  HiDoctorApp
//
//  Created by Vijay on 11/12/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class RcpaListController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var doctorList : [DCRDoctorVisitModel] = []
    var accompanistList : [DCRAccompanistModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.getRCPAList()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getRCPAList()
    {
       doctorList = BL_Common_Stepper.sharedInstance.getDoctorsList()
        accompanistList = BL_Common_Stepper.sharedInstance.getDCRAccompanists()
        self.tableView.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(section == 0)
        {
           return doctorList.count
        }
        else if(section == 1)
        {
            return accompanistList.count
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if(section == 0)
        {
            return "Visited \(appDoctor) of the day"
        }
        else if(section == 1)
        {
            return "Selected Accompanist of the day"
        }
        else
        {
            return "Mine"
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier:Constants.TableViewCellIdentifier.RCPAListCell) as! RCPAListTableCell
        if(indexPath.section == 0)
        {
            
            cell.nameLbl.text = doctorList[indexPath.row].Doctor_Name
            cell.descriptionLbl.text = "\(String(describing: doctorList[indexPath.row].MDL_Number!))|\(doctorList[indexPath.row].Speciality_Name!)|\(String(describing: doctorList[indexPath.row].Doctor_Region_Name!))"
            
            
        }
        else if (indexPath.section == 1)
        {
            cell.nameLbl.text = accompanistList[indexPath.row].Acc_User_Name
            cell.descriptionLbl.text = "\(String(describing: accompanistList[indexPath.row].Acc_User_Type_Name!))|\(String(describing: accompanistList[indexPath.row].Region_Name))"
        }
        else
        {
            cell.nameLbl.text = "Mine"
            let userObj = getUserModelObj()
            cell.descriptionLbl.text = "\(String(describing: userObj!.User_Name!))|\(userObj!.User_Type_Name!)|\(String(describing: userObj!.Region_Name!))"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.section == 0)
        {
            let convertedDoctorObj = convertDoctorToCustomerObjectModel(doctorObj: doctorList[indexPath.row])
            navigateToProduct(doctorObj: convertedDoctorObj)
        }
        else if(indexPath.section == 1)
            
        {
            navigateToDoctor(regionName: "" ,regionCode:accompanistList[indexPath.row].Acc_Region_Code )
        }
        else
        {
            let useObj = getUserModelObj()
            navigateToDoctor(regionName:(useObj?.Region_Name!)!  ,regionCode:(useObj?.Region_Code!)! )
        }
    }
    func convertDoctorToCustomerObjectModel(doctorObj : DCRDoctorVisitModel)->CustomerMasterModel
    {
        let convertObject : NSDictionary = ["Customer_Code" : doctorObj.Doctor_Code!,"Customer_Name":doctorObj.Doctor_Name,"Region_Code":doctorObj.Doctor_Region_Code!,"Region_Name":doctorObj.Doctor_Region_Name!,"Speciality_Code":"","Speciality_Name":doctorObj.Speciality_Name,"Category_Code":doctorObj.Category_Code!,"Category_Name":doctorObj.Category_Name!,"MDL_Number":doctorObj.MDL_Number!,"Local_Area":doctorObj.Local_Area!,"Hospital_Name":"","Customer_Entity_Type":"","Sur_Name":doctorObj.Sur_Name!,"Customer_Latitude":doctorObj.Lattitude!,"Customer_Longitude":doctorObj.Longitude!,"Anniversary_Date":"","DOB":""]
        let customerObject = CustomerMasterModel(dict: convertObject)
        
        return customerObject
    }
    func navigateToDoctor(regionName:String,regionCode:String)
    {
        let sb = UIStoryboard(name: doctorMasterSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: doctorMasterVcID) as! DoctorMasterController
        vc.isFromRCPA = true
        vc.regionCode = regionCode
        vc.regionName =  regionName
        if let navigationController = self.navigationController
        {
            navigationController.popViewController(animated: false)
            navigationController.pushViewController(vc, animated: false)
        }
    }
    
    func navigateToProduct(doctorObj: CustomerMasterModel)
    {
        let sb = UIStoryboard(name: detailProductSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: DetailProductVcID) as! DetailedProductViewController
        vc.customerModel = doctorObj
        vc.isFromRCPA = true
        if let navigationController = self.navigationController
        {
            navigationController.popViewController(animated: false)
            navigationController.pushViewController(vc, animated: false)
        }
        
    }
 
}
