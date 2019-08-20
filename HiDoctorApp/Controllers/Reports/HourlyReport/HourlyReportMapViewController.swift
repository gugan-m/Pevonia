//
//  HourlyReportMapViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 26/05/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class HourlyReportMapViewController: UIViewController, MKMapViewDelegate
{
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = MapViewLocationManager()
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.getUserLocation()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if (annotation is MKUserLocation)
        {
            return nil
        }
        
        if let annotateView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "pin")
        {
            return annotateView
        }
        else
        {
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            
            if #available(iOS 9.0, *)
            {
                annotationView.pinTintColor = UIColor.green
            }
            else
            {
                // Fallback on earlier versions
            }
            annotationView.canShowCallout = true
            
            return annotationView
        }
    }
    
    private func getUserLocation()
    {
        let location = CLLocation(latitude: self.latitude, longitude: self.longitude)
        
        self.getLocationDetail(location)
    }
    
    private func addAnnotationToMap(location : CLLocation, placeMark : CLPlacemark)
    {
        let locality = self.trimString(text: placeMark.locality)
        let country = self.trimString(text: placeMark.country)
        print(locality,country)
        
        let pinAnnotation = MKPointAnnotation()
        pinAnnotation.coordinate = location.coordinate
        pinAnnotation.title = locality
        pinAnnotation.subtitle = country
        
        self.mapView.addAnnotation(pinAnnotation)
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
    
    private func getLocationDetail(_ location : CLLocation)
    {
        self.locationManager.getPlacemarkDetailForLocation(location) { (placeMark, error) in
            if let placeMarkDetail = placeMark?.first
            {
                self.addAnnotationToMap(location: location, placeMark : placeMarkDetail)
            }
        }
    }
    
    func trimString(text : String?) -> String
    {
        if text != nil
        {
            return text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        return ""
    }
}
