//
//  BL_Geo_Location.swift
//  HiDoctorApp
//
//  Created by SwaaS on 14/03/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit
import CoreLocation

class BL_Geo_Location: NSObject
{
    //MARK:- Variables
    static let sharedInstance = BL_Geo_Location()
    private let PROCEED_TO_DCR: Int = 1
    private let ERROR_STAY: Int = 0
    private let REMARKS_SCREEN: Int = 2
    private let ENABLE_GPS: Int = 3
    private let AUTO_SKIP_USER_LOCATION_NOT_FOUND : String = "AUTO_SKIP_USER_LOCATION_NOT_FOUND"
    private let AUTO_SKIP_ADDRESS_NOT_FOUND: String = "AUTO_SKIP_CUSTOMER_ADDRESS_NOT_FOUND"
    
    //MARK:- Public Functions
    func doGeoLocationAndFencingValidations(userLocation: GeoLocationModel, doctorLocationsList: [GeoLocationModel], viewController: UIViewController, customerName: String) -> GeoLocationValidationModel
    {
        if (!isGeoLocationMandatoryPrivEnabled())
        {
            return getGeoLocaitonValidationModel(status: PROCEED_TO_DCR, doctorLocation: nil, remarks: EMPTY)
        }
        
        if (canShowLocationMandatoryAlert())
        {
            return getGeoLocaitonValidationModel(status: ENABLE_GPS, doctorLocation: nil, remarks: EMPTY)
        }
        
        if (userLocation.Latitude == 0 && userLocation.Longitude == 0)
        {
            return getGeoLocaitonValidationModel(status: PROCEED_TO_DCR, doctorLocation: nil, remarks: AUTO_SKIP_USER_LOCATION_NOT_FOUND)
        }
        
        if (doctorLocationsList.count == 0)
        {
            if (isGeoFencingEnabled())
            {
                return getGeoLocaitonValidationModel(status: PROCEED_TO_DCR, doctorLocation: nil, remarks: AUTO_SKIP_ADDRESS_NOT_FOUND)
            }
            else
            {
                return getGeoLocaitonValidationModel(status: PROCEED_TO_DCR, doctorLocation: nil, remarks: EMPTY)
            }
        }
        
        for objDoctorLocation in doctorLocationsList
        {
            if (objDoctorLocation.Latitude == 0 && objDoctorLocation.Longitude == 0)
            {
                let privValue = getCustomerLocationEditPrivValue()
                
                if (privValue == PrivilegeValues.YES.rawValue)
                {
                    userLocation.Address_Id = objDoctorLocation.Address_Id!
                    return getGeoLocaitonValidationModel(status: PROCEED_TO_DCR, doctorLocation: userLocation, remarks: EMPTY)
                }
                else
                {
                    if (isGeoFencingEnabled())
                    {
                        return getGeoLocaitonValidationModel(status: PROCEED_TO_DCR, doctorLocation: nil, remarks: AUTO_SKIP_ADDRESS_NOT_FOUND)
                    }
                    else
                    {
                        return getGeoLocaitonValidationModel(status: PROCEED_TO_DCR, doctorLocation: nil, remarks: EMPTY)
                    }
                }
            }
        }
        
        let isUserInsideRange = checkGeoFencing(userLocation: userLocation, doctorLocationsList: doctorLocationsList)
        
        if (isUserInsideRange)
        {
            return getGeoLocaitonValidationModel(status: PROCEED_TO_DCR, doctorLocation: nil, remarks: EMPTY)
        }
        
        let privValue = geoFencingValidationModeValue()
        
        if (privValue == PrivilegeValues.RIGID.rawValue)
        {
            showGeoFencingDeviationAlertWithoutSkip(viewController: viewController, customerName: customerName)
            return getGeoLocaitonValidationModel(status: ERROR_STAY, doctorLocation: nil, remarks: EMPTY)
        }
        else //if (privValue == PrivilegeValues.FLEXI.rawValue)
        {
            return getGeoLocaitonValidationModel(status: REMARKS_SCREEN, doctorLocation: nil, remarks: EMPTY)
        }
    }
    
    func updateCustomerLocation(customerLocation: GeoLocationModel, pageSource: String)
    {
        DBHelper.sharedInstance.updateCustomerAddress(customerAddress: customerLocation, pageSource: pageSource)
    }
    
    func getCustomerAddress(customerCode: String, regionCode: String, customerEntityType: String) -> [CustomerAddressModel]
    {
        return DBHelper.sharedInstance.getCustomerAddress1(customerCode: customerCode, regionCode: regionCode, customerEntityType: customerEntityType)
    }
    
    func getCustomerAddress(regionCode: String, customerEntityType: String) -> [CustomerAddressModel]
    {
        return DBHelper.sharedInstance.getCustomerAddress2(regionCode: regionCode, customerEntityType: customerEntityType)
    }
    
    func checkIsAnyAddressDoesNotHaveLatLong(doctorLocations: [CustomerAddressModel]) -> Bool
    {
        let filteredArray = doctorLocations.filter{
            $0.Latitude == 0 && $0.Longitude == 0
        }
        
        if (filteredArray.count > 0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func uploadCustomerAddress(completion: @escaping (_ status: Int) -> ())
    {
        let postData = getCustomerAddressForUpSync()
        
        if (postData.count > 0)
        {
            WebServiceHelper.sharedInstance.uploadCustomerAddress(dataArray: postData) { (objApiResponse) in
                if (objApiResponse.Status == SERVER_SUCCESS_CODE)
                {
                    self.markCustomerAddressAsSynced()
                }
                
                completion(objApiResponse.Status)
            }
        }
        else
        {
            completion(SERVER_SUCCESS_CODE)
        }
    }
    
    //MARK:- Private Functions
    private func getGeoLocaitonValidationModel(status: Int, doctorLocation: GeoLocationModel?, remarks: String) -> GeoLocationValidationModel
    {
        let objValidationModel = GeoLocationValidationModel()
        
        objValidationModel.Status = status
        objValidationModel.Customer_Location = doctorLocation
        objValidationModel.Remarks = remarks
        
        return objValidationModel
    }
    
    //MARK:-- Privilege Functions
    func isGeoLocationMandatoryPrivEnabled() -> Bool
    {
        let privValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.APP_GEO_LOCATION_MANDATORY)
        
        if (privValue == PrivilegeValues.YES.rawValue)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func isGeoFencingEnabled() -> Bool
    {
        if (getGeoFencingDeviationValue() > 0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    private func getGeoFencingDeviationValue() -> Double
    {
        let privValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.GEO_FENCING_DEVIATION_LIMIT_IN_KM)
        
        return Double(privValue)!
    }
    
    private func getCustomerLocationEditPrivValue() -> String
    {
        return PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.CAN_EDIT_CUSTOMER_LOCATION)
    }
    
    func doesUserHasLocationEditPermission() -> Bool
    {
        let privValue = getCustomerLocationEditPrivValue()
        
        if (privValue == PrivilegeValues.YES.rawValue)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    private func geoFencingValidationModeValue() -> String
    {
        return PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.GEO_FENCING_VALIDATION_MODE)
    }
    
   
    //MARK:-- Geo fencing check functions
    private func checkGeoFencing(userLocation: GeoLocationModel, doctorLocationsList: [GeoLocationModel]) -> Bool
    {
        var isUserInsideRange: Bool = true
        
        if (isGeoFencingEnabled())
        {
            if (userLocation.Latitude != 0 && userLocation.Longitude != 0)
            {
                let userLatLong = CLLocation(latitude: userLocation.Latitude, longitude: userLocation.Longitude)
                let allowedRange = getGeoFencingDeviationValue()
                
                for objDoctorLocation in doctorLocationsList
                {
                    let doctorLatLong = CLLocation(latitude: objDoctorLocation.Latitude, longitude: objDoctorLocation.Longitude)
                    let distance = findDistanceBetweenTwoLocationsInKM(doctorLocation: doctorLatLong, userLocation: userLatLong)
                    
                    if (distance > allowedRange)
                    {
                        isUserInsideRange = false
                        break
                    }
                }
            }
        }
        
        return isUserInsideRange
    }
    
    private func findDistanceBetweenTwoLocationsInKM(doctorLocation: CLLocation, userLocation: CLLocation) -> Double
    {
        let distance = doctorLocation.distance(from: userLocation) / 1000
        return distance
    }
    
    //MARK:-- Alert Functions
    private func showGeoFencingDeviationAlertWithoutSkip(viewController: UIViewController, customerName: String)
    {
        let alertViewController = UIAlertController(title: alertTitle, message: "You are away from the \(customerName)'s location. You are not allowed to proceed further", preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alertAction in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        viewController.present(alertViewController, animated: true, completion: nil)
    }
    
    private func showGeoFencingDeviationAlertWithSkip(viewController: UIViewController)
    {
        let alertViewController = UIAlertController(title: alertTitle, message: "You are away from the \(appDoctor)'s location. \n\n Please tap on SKIP button to enter the remarks for skip and then proceed further \n\n Please tap on CANCEL button not to proceed further", preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.default, handler: { alertAction in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        alertViewController.addAction(UIAlertAction(title: "SKIP", style: UIAlertActionStyle.default, handler: { alertAction in
            self.skipAction(viewController: viewController)
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        viewController.present(alertViewController, animated: true, completion: nil)
    }
    
    private func skipAction(viewController: UIViewController)
    {
        let sb = UIStoryboard(name: dcrStepperSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.GeoFencingSkipRemarksVCId) as! GeoLocationSkipViewController
        
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        
        viewController.present(vc, animated: false, completion: nil)
    }
    
    //MARK:-- DB Functions
    private func markCustomerAddressAsSynced()
    {
        DBHelper.sharedInstance.markCustomerAddressSynced()
    }
    
    func getCustomerAddressForUpSync() -> NSMutableArray
    {
        let customerAddressList =  DBHelper.sharedInstance.getCustomerAddressForUpSync()
        let addressArray: NSMutableArray = []
        
        for objAddress in customerAddressList
        {
            let dict: NSDictionary = ["Address_Id": objAddress.Address_Id, "Latitude": objAddress.Latitude, "Longitude": objAddress.Longitude]
            addressArray.add(dict)
        }
        
        return addressArray
    }
}
