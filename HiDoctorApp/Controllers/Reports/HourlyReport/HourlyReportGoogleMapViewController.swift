//
//  HourlyReportGoogleMapViewController.swift
//  HiDoctorApp
//
//  Created by Vijay on 03/10/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class HourlyReportGoogleMapViewController: UIViewController,GMSMapViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var shoeDetailheightConstraint: NSLayoutConstraint!
    @IBOutlet weak var showDetailView: UIView!

    let path = GMSMutablePath()
    var address : String = ""
    var doctorListWithLocations: [HourlyReportDoctorVisitModel] = []
    var markers = [GMSMarker]()
    var tappedState = HourlyReportDoctorVisitModel()
    var filteredDoctorListWithLocations: [HourlyReportDoctorVisitModel] = []
    var isSingleMap :Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 500
        shoeDetailheightConstraint.constant = 0
        
        if(doctorListWithLocations.count > 0)
        {
            self.loadMultiMarkerMap()
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
//    func loadSingleMarkerMap()
//    {
//        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15.0)
//        
//        mapView.camera = camera
//        mapView.delegate = self
//        
//        let marker1 = GMSMarker()
//        
//        marker1.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        marker1.title = self.address
//        marker1.map = mapView
//        
//    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool
    {
        
        if(doctorListWithLocations.count > 0)
        {
            
            if let index = markers.index(of: marker)
            {
                filteredDoctorListWithLocations = []
                tappedState = doctorListWithLocations[index]
                
                let filterContent = doctorListWithLocations.filter{
                    $0.Lattitude == doctorListWithLocations[index].Lattitude && $0.Longitude == doctorListWithLocations[index].Longitude
                }
                filteredDoctorListWithLocations = filterContent
                if(filteredDoctorListWithLocations.count >= 3)
                {
                    shoeDetailheightConstraint.constant = CGFloat(3 * 90)
                }
                else
                {
                    shoeDetailheightConstraint.constant = CGFloat(filteredDoctorListWithLocations.count * 90)
                }
                self.tableView.reloadData()
            }
        }
        return false
    }
    func loadMultiMarkerMap()
    {
//        let camera = GMSCameraPosition.camera(withLatitude: doctorListWithLocations[0].Lattitude, longitude: doctorListWithLocations[0].Longitude, zoom: 20)
//        mapView.camera = camera
        mapView.delegate = self
        
        self.mark()
    }
    func mark()
    {
        let filteredArray = self.doctorListWithLocations.filter
        {
            $0.Entered_DateTime == EMPTY || $0.Entered_DateTime == NOT_APPLICABLE
        }
        if (filteredArray.count == 0)
        {
            self.doctorListWithLocations = self.doctorListWithLocations.sorted(by: { $0.Time! < $1.Time! })
        }
        
        for i in 0..<doctorListWithLocations.count
        {
            let markerView = UIView(frame:CGRect(x:0, y:0, width:27, height:45))
            let markerImage = UIImageView(frame: CGRect(x:0, y:0, width:27, height:45))
            
            if (doctorListWithLocations[i].Customer_Entity_Type == "C"){
                markerImage.image = UIImage(named: "ic_maps_markerGreen")
            }else if (doctorListWithLocations[i].Customer_Entity_Type == "S"){
                markerImage.image = UIImage(named: "ic_maps_marker")
            }else{
                markerImage.image = UIImage(named: "ic_maps_markerBlue")
            }
            
            
            markerView.addSubview(markerImage)
            
            let markerLbl = UILabel(frame: CGRect(x:0, y:12, width:25, height:10))
            
            markerLbl.font = UIFont.boldSystemFont(ofSize: 12)
            markerLbl.textColor = UIColor.white
            
            if(!isSingleMap)
            {
                markerLbl.text = "\(i+1)"
            }
            
            markerLbl.textAlignment = NSTextAlignment.center
            markerView.addSubview(markerLbl)
            
            let marker1 = GMSMarker()
            
            marker1.position = CLLocationCoordinate2D(latitude: doctorListWithLocations[i].Lattitude, longitude: doctorListWithLocations[i].Longitude)
            marker1.title = ""
            marker1.snippet = ""
            marker1.map = mapView
            marker1.icon = imageFromView(aView: markerView)
            markers.append(marker1)
            path.addLatitude(doctorListWithLocations[i].Lattitude, longitude:doctorListWithLocations[i].Longitude)
        }
        
        let polyline = GMSPolyline(path: path)
        let bounds = GMSCoordinateBounds(path: path)
        
        if SwifterSwift().isPhone
        {
            self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 20.0))
        }
        else
        {
            self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 0.0))
        }
        
        polyline.strokeColor = .blue
        polyline.strokeWidth = 2.0
        if(filteredArray.count == 0)
        {
            polyline.map = mapView
        }
    }
    
    private func imageFromView(aView:UIView) -> UIImage
    {
        if UIScreen.main.responds(to: #selector(NSDecimalNumberBehaviors.scale))
        {
            UIGraphicsBeginImageContextWithOptions(aView.frame.size, false, UIScreen.main.scale)
        }
        else
        {
            UIGraphicsBeginImageContext(aView.frame.size)
        }
        
        aView.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDoctorListWithLocations.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "mapMarkerTableViewCell", for: indexPath) as! MarkerTableViewCell
        let doctorData = self.filteredDoctorListWithLocations[indexPath.row]
        let getDate = doctorData.Entered_DateTime.components(separatedBy: " ")
        if(getDate.count > 2)
        {
            cell.doctorName.text = doctorData.Doctor_Name + " @\(getDate[1] + " " + getDate[2])"
        }
        else
        {
           cell.doctorName.text = doctorData.Doctor_Name
        }
//        cell.doctorDetail.text = "\(doctorData.MDL_Number) | \(doctorData.Speciality_Name) | \(doctorData.Category_Name) | \(doctorData.Lattitude) | \(doctorData.Longitude) | \(doctorData.Doctor_Region_Name)"
        cell.doctorDetail.text = "\(doctorData.Speciality_Name) | \(doctorData.Category_Name) | \(doctorData.Lattitude) | \(doctorData.Longitude) | \(doctorData.Doctor_Region_Name)"
        let index = doctorListWithLocations.index(of: doctorData)!
        cell.countlabel.text = String(index+1)
        return cell
        
    }
}
