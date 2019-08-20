//
//  LocationManager.swift
//  LocationManager
//
//  Created by MacBook Pro on 22/08/16.
//  Copyright © 2016 MacBook Pro. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

enum LocationManagerError : Int
{
    case accessDenied = 101
    case locationSupportUnAvailable = 102
    case noLocation = 100
}

class MapViewLocationManager: NSObject, CLLocationManagerDelegate
{
    let manager: CLLocationManager
    let geoCoder : CLGeocoder
    var locationManagerClosures: [((_ userLocation: CLLocation? , _ error : NSError?) -> ())] = []
    
    override init()
    {
        self.manager = CLLocationManager()
        self.geoCoder = CLGeocoder()
        super.init()
        self.manager.delegate = self
    }
    
    /**
     Get the user current location
     
     - Returns : CLLocation or NSError closure
     */
    
    func getlocationForUser(_ userLocationClosure: @escaping ((_ userLocation: CLLocation? , _ error : NSError?) -> ()))
    {
        self.locationManagerClosures.append(userLocationClosure)
        
        //First need to check if the apple device has location services availabel. (i.e. Some iTouch's don't have this enabled)
        if CLLocationManager.locationServicesEnabled()
        {
            self.checkLocationAuthorizationState(CLLocationManager.authorizationStatus())
        }
        else
        {
            let accessDeniedError = NSError(domain: "Location Manager", code: LocationManagerError.locationSupportUnAvailable.rawValue, userInfo: [NSLocalizedDescriptionKey : "Your device doesnot support location."])
            self.userLocationAndError(nil, error: accessDeniedError)
        }
    }
    
    //MARK:- CLLocationManager Delegate methods
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        // status changed
        self.checkLocationAuthorizationState(status)
    }
    
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        if let newLocation = locations.first
        {
            self.userLocationAndError(newLocation, error: nil)
        }
        else
        {
          let error = NSError(domain: "Location Error", code: LocationManagerError.noLocation.rawValue, userInfo: [NSLocalizedDescriptionKey : "No location found."])
            self.userLocationAndError(nil, error: error)
        }
         self.manager.stopUpdatingLocation()
    }

    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        // No location found error
        self.userLocationAndError(nil, error: error as NSError?)
    }
    
    //MARK:-- Other functions
    
    /**
     Based on the CLAuthorizationStatus do required actions.
     
     - Parameter status: CLAuthorizationStatus
     */
    
    func checkLocationAuthorizationState(_ status: CLAuthorizationStatus)
    {
        if status == .notDetermined
        {
            self.manager.requestWhenInUseAuthorization()
        }
        else if status == .restricted || status == .denied
        {
            let accessDeniedError = NSError(domain: "Location Manager", code: LocationManagerError.accessDenied.rawValue, userInfo: [NSLocalizedDescriptionKey : "Location access denied."])
            self.userLocationAndError(nil, error: accessDeniedError)
        }
        else
        {
            self.manager.startUpdatingLocation()
        }
    }
    
    /**
     Return the closure with given location or error
     
     - Parameter location : CLLocation user location
     - Parameter error : NSError
     */
    
    func userLocationAndError(_ location : CLLocation? , error : NSError?)
    {
        let tempClosures = self.locationManagerClosures
        for closure in tempClosures
        {
            closure(location , error)
        }
        self.locationManagerClosures = []
    }
    
    /**
     Get the placemark detail for given location
     
     - Parameter location : CLLocation for which placemark detail needed
     - Parameter callBack : ((placeMark : [CLPlacemark]? , error : NSError?) -> ())
     */
    
    func getPlacemarkDetailForLocation(_ location : CLLocation , callBack : @escaping ((_ placeMark : [CLPlacemark]? , _ error : NSError?) -> ()))
    {
        self.geoCoder.reverseGeocodeLocation(location) { (placeMarkList, error) in
            callBack(placeMarkList, error as NSError?)
        }
    }
    
    /**
     Get the placemark detail for given address string
     
     - Parameter location : CLLocation for which placemark detail needed
     - Parameter callBack : ((placeMark : [CLPlacemark]? , error : NSError?) -> ())
     */
    
    func getLocationForAddress(_ addressString : String , callBack : @escaping ((_ placeMark : [CLPlacemark]? , _ error : NSError?) -> ()))
    {
        self.geoCoder.geocodeAddressString(addressString) { (placeMarkList, error) in
            callBack(placeMarkList, error as NSError?)
        }
    }
}
