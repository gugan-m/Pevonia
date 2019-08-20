//
//  AddFlexiWorkPlaceViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 19/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class AddFlexiWorkPlaceViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate
{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var workPlaceTxtFld: UITextField!
    @IBOutlet weak var tableViewHgtConst: NSLayoutConstraint!
    
    @IBOutlet weak var sepViewHeightConstant: NSLayoutConstraint!
    
    var flexiWorkPlaceList : [FlexiPlaceModel] = []
    var navigationScreenname : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

          self.tableView.tableFooterView = UIView(frame: CGRect.zero)
          self.navigationItem.title = "Flexi Work Place"
          self.getFlexiPlaceList()
          self.addTapGestureForView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return flexiWorkPlaceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddFlexiWorkPlaceCell, for: indexPath)
        let flexiChemistObj = flexiWorkPlaceList[indexPath.row]
        cell.textLabel?.text = flexiChemistObj.Flexi_Place_Name as String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let flexiWorkPlaceObj = flexiWorkPlaceList[indexPath.row]
        
        if navigationScreenname == addTravelFromPlace || navigationScreenname == addTravelToPlace
        {
            navigateToTravelledPlaces(placeName: flexiWorkPlaceObj.Flexi_Place_Name)
        }
        else if navigationScreenname == addTPTravelFromPlace || navigationScreenname == addTPTravelToPlace
        {
            navigateToTravelledPlaces_TP(placeName: flexiWorkPlaceObj.Flexi_Place_Name)
        }
        else
        {
            navigateToWorkPlaceDetails(placeName: flexiWorkPlaceObj.Flexi_Place_Name)
        }
    }

    @IBAction func submitBtnAction(_ sender: Any)
    {
        resignResponserForTextField()
        
        let charSet = Constants.CharSet.Alphabet + Constants.CharSet.Numeric + " "
        
        if workPlaceTxtFld.text?.count == 0
        {
            AlertView.showAlertView(title: alertTitle, message: "Please Enter Flexi Place", viewController: self)
        }
        else if condenseWhitespace(stringValue: workPlaceTxtFld.text!).count == 0
        {
             AlertView.showAlertView(title: alertTitle, message: "Please Enter Flexi Place", viewController: self)
        }
        else if isSplCharAvailable(charSet: charSet, stringValue: workPlaceTxtFld.text!)
        {
            AlertView.showAlertView(title: alertTitle, message: "Please Enter Valid Flexi Place", viewController: self)
        }
        else if (workPlaceTxtFld.text?.count)! > flexiPlaceMaxLength
        {
            AlertView.showMaxLengthExceedAlertView(title: alertTitle, subject: "Place name", maxVal: flexiPlaceMaxLength, viewController: self)
        }
        else
        {
            let trimmedText = RemoveUnwantedSpaceInString(value: workPlaceTxtFld.text!)
            BL_WorkPlace.sharedInstance.saveFlexiWorkPlace(placeName: trimmedText)
            if navigationScreenname == addTravelFromPlace || navigationScreenname == addTravelToPlace
            {
                navigateToTravelledPlaces(placeName: trimmedText)
            }
            else if navigationScreenname == addTPTravelFromPlace || navigationScreenname == addTPTravelToPlace
            {
                navigateToTravelledPlaces_TP(placeName: trimmedText)
            }
            else
            {
                navigateToWorkPlaceDetails(placeName: trimmedText)
            }
        }
    }
    
    
    func getFlexiPlaceList()
    {
        flexiWorkPlaceList = BL_WorkPlace.sharedInstance.getFlexiWorkPlaceList()
        
        if flexiWorkPlaceList.count > 0
        {
            self.tableView.reloadData()
            self.tableViewHgtConst.constant = self.tableView.contentSize.height
            self.sepViewHeightConstant.constant = 1
        }
        else
        {
            self.sepViewHeightConstant.constant = 0
            self.tableViewHgtConst.constant = 0
        }

    }
   
    func navigateToTravelledPlaces(placeName : String)
    {
        if navigationScreenname == addTravelFromPlace
        {
            BL_SFC.sharedInstance.fromPlace = placeName
        }
        else if navigationScreenname == addTravelToPlace
        {
            BL_SFC.sharedInstance.toPlace = placeName
        }
        
        let travelMode : String? = ""
        let distance : Float? = 0.0
        let sfcVersion : Int? = 0
        let sfcCategory : String? = ""
        let userObj = getUserModelObj()
        let sfcRegionCode : String? = userObj?.Region_Code
        let distanceFareCode : String? = ""
        
        popViewControllers(travelMode: travelMode!, distance: distance!, sfcVersion: sfcVersion!, sfcCategory: sfcCategory, sfcRegionCode: sfcRegionCode, distancefareCode: distanceFareCode)
    }
    
    func navigateToTravelledPlaces_TP(placeName : String)
    {
        if navigationScreenname == addTPTravelFromPlace
        {
            BL_TP_SFC.sharedInstance.fromPlace = placeName
        }
        else if navigationScreenname == addTPTravelToPlace
        {
            BL_TP_SFC.sharedInstance.toPlace = placeName
        }
        
        let travelMode : String? = ""
        let distance : Float? = 0.0
        let sfcVersion : Int? = 0
        let sfcCategory : String? = ""
        let userObj = getUserModelObj()
        let sfcRegionCode : String? = userObj?.Region_Code
        let distanceFareCode : String? = ""
        
        popViewControllers(travelMode: travelMode!, distance: distance!, sfcVersion: sfcVersion!, sfcCategory: sfcCategory, sfcRegionCode: sfcRegionCode, distancefareCode: distanceFareCode)
    }
    
    func popViewControllers(travelMode : String, distance : Float, sfcVersion : Int, sfcCategory : String?, sfcRegionCode : String?, distancefareCode : String?)
    {
        if let navigationController = self.navigationController
        {
            let viewControllers = navigationController.viewControllers
            
            for vc in  viewControllers
            {
                if vc.isKind(of: AddTravelDetailsController.self)
                {
                    let controller = vc as! AddTravelDetailsController
                    controller.fromPlace = BL_SFC.sharedInstance.fromPlace
                    controller.toPlace = BL_SFC.sharedInstance.toPlace
                    controller.travelMode = travelMode
                    controller.distance = distance
                    controller.distanceFareCode = distancefareCode
                    controller.sfcVersion = sfcVersion
                    controller.sfcCategory = sfcCategory
                    controller.sfcRegionCode = sfcRegionCode
                    controller.validSFC = false
                    _ = self.navigationController?.popToViewController(vc, animated: false)
                    return
                }
                else if vc.isKind(of: TPTravelDetailsViewController.self)
                {
                    let controller = vc as! TPTravelDetailsViewController
                    controller.fromPlace = BL_TP_SFC.sharedInstance.fromPlace
                    controller.toPlace = BL_TP_SFC.sharedInstance.toPlace
                    // test
                    controller.travelMode = travelMode
                    controller.distance = distance
                    controller.distanceFareCode = distancefareCode
                    controller.sfcVersion = sfcVersion
                    controller.sfcCategory = sfcCategory
                    controller.sfcRegionCode = sfcRegionCode
                    controller.validSFC = false
                    _ = self.navigationController?.popToViewController(vc, animated: false)
                    return
                }
            }
        }
    }
    
    func navigateToWorkPlaceDetails(placeName : String)
    {
        if let navigationController = self.navigationController
        {
            let viewControllers = navigationController.viewControllers
            
            for viewController1 in viewControllers
            {
                if viewController1.isKind(of: WorkPlaceDetailsViewController.self)
                {
                    let workPlaceCtrl = viewController1 as! WorkPlaceDetailsViewController
                    workPlaceCtrl.placeName = placeName
                    workPlaceCtrl.isComingFromFlexiWorkPlace = true
                     navigationController.popToViewController(workPlaceCtrl, animated: false)
                }
                else if viewController1.isKind(of: TPWorkPlaceDetailViewController.self)
                {
                    let workPlaceCtrl = viewController1 as! TPWorkPlaceDetailViewController
                    workPlaceCtrl.placeName = placeName
                    workPlaceCtrl.isComingFromFlexiWorkPlace = true
                    navigationController.popToViewController(workPlaceCtrl, animated: false)
                }
            }
        }
    }
    
    func addTapGestureForView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.resignResponserForTextField))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
    
    
    @objc func resignResponserForTextField()
    {
        self.workPlaceTxtFld.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }

}
