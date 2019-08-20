//
//  TravelModeSuggestionController.swift
//  HiDoctorApp
//
//  Created by Vijay on 24/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class TravelModeSuggestionController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var suggestionList : [SFCMasterModel] = []
    
    let cellIdentifier : String = "travelSuggestionCell"
    var isComingForTp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addBackButtonView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestionList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TravelModeSuggestionCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! TravelModeSuggestionCell
        let model = suggestionList[indexPath.row]
        
        var regionName : String = ""
        let userObj = getUserModelObj()
        if model.Region_Code == userObj?.Region_Code
        {
            regionName = (userObj?.Region_Name)!
        }
        else
        {
            if isComingForTp{
            regionName = DAL_TP_SFC.sharedInstance.getRegionNameforRegionCode(code: model.Region_Code)
            }else{
            regionName = DAL_SFC.sharedInstance.getRegionNameforRegionCode(code: model.Region_Code)
            }
        }
        cell.regionName.text = regionName
        cell.categoryName.text = model.Category_Name
        cell.fromPlaceLabel.text = model.From_Place
        cell.toPlaceLabel.text = model.To_Place
        cell.travelModeLabel.text = model.Travel_Mode
        cell.distanceLabel.text = String(format : "%.2f KM", model.Distance)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = suggestionList[indexPath.row]
        
        popViewControllers(travelMode: model.Travel_Mode, distance: model.Distance, sfcVersion: model.SFC_Version, sfcCategory: model.Category_Name, sfcRegionCode: model.Region_Code, distancefareCode: model.Distance_Fare_Code)
    }
    
    func popViewControllers(travelMode : String, distance : Float, sfcVersion : Int, sfcCategory : String?, sfcRegionCode : String?, distancefareCode : String?)
    {
        if let navigationController = self.navigationController
        {
            let viewControllers = navigationController.viewControllers
            
            for vc in viewControllers
            {
                if isComingForTp{
                    if vc.isKind(of: TPTravelDetailsViewController.self)
                    {
                    let controller = vc as! TPTravelDetailsViewController
                    controller.fromPlace = BL_TP_SFC.sharedInstance.fromPlace
                    controller.toPlace = BL_TP_SFC.sharedInstance.toPlace
                    controller.travelMode = travelMode
                    controller.distance = distance
                    controller.distanceFareCode = distancefareCode
                    controller.sfcVersion = sfcVersion
                    controller.sfcCategory = sfcCategory
                    controller.sfcRegionCode = sfcRegionCode
                    controller.validSFC = true
                    _ = self.navigationController?.popToViewController(vc, animated: false)
                    return
                    }
                    
                }else{
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
                    controller.validSFC = true
                    _ = self.navigationController?.popToViewController(vc, animated: false)
                    return
                }
            }
            }
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
        if let navigationController = self.navigationController
        {
            let viewControllers = navigationController.viewControllers
            
            for vc in viewControllers
            {
                if isComingForTp{
                if vc.isKind(of: TPTravelDetailsViewController.self)
                    {
                        _ = self.navigationController?.popToViewController(vc, animated: false)
                        return
                    }

                }else{
                if vc.isKind(of: AddTravelDetailsController.self)
                {
                    _ = self.navigationController?.popToViewController(vc, animated: false)
                    return
                }
              }
            }
        }
    }

}
