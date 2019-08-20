//
//  TravelTrackingReportMapViewController.swift
//  HiDoctorApp
//
//  Created by SwaaS on 30/04/19.
//  Copyright © 2019 swaas. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class TravelTrackingReportMapViewController: UIViewController,GMSMapViewDelegate {
    
 //   @IBOutlet weak var tableView: UITableView!
   
    
    @IBOutlet weak var mapViewTravel: GMSMapView!
    
    @IBOutlet weak var viewMenuLeft: UIView!
    //    @IBOutlet weak var mapViewTravelReport: GMSMapView!
//    @IBOutlet weak var shoeDetailheightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var showDetailView: UIView!
    
    let path = GMSMutablePath()
    var address : String = ""
    var doctorListWithLocations: [HourlyReportDoctorVisitModel] = []
    var markers = [GMSMarker]()
    var tappedState = HourlyReportDoctorVisitModel()
    var filteredDoctorListWithLocations: [HourlyReportDoctorVisitModel] = []
    var isSingleMap :Bool = false
    var objTravel: [travelTrackingReport] = []
    
    var arrDoctor: NSArray = []
    var arrChemist: NSArray = []
    var arrStockist: NSArray = []
    var arrTravelReport: NSArray = []
    
    var arrsample: [AnyHashable] = []
    
    var arrDATABASEvalue: [AnyHashable] = []
    
    var arrFinalLat: [AnyHashable] = []
    var arrFinalLong: [AnyHashable] = []
    var arrfinalType: [AnyHashable] = []
    var arrfinalEnteredTime: [AnyHashable] = []
    
    var arrAssendingDetails: [AnyHashable] = []

    var addBtn : UIBarButtonItem!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.set("HIDE", forKey: "RightbtnCheck")
        UserDefaults.standard.synchronize()

        
        let button: UIButton = UIButton(type: UIButtonType.custom)
        button.setImage(UIImage(named: "icon-drop-down-arrow"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(addToShowList), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton

        viewMenuLeft.isHidden = true
        
        for i in 0..<arrDoctor.count{
            let strLat = (arrDoctor[i] as AnyObject).object(forKey:"Latitude") as! String
            let strLon = (arrDoctor[i] as AnyObject).object(forKey:"Longitude") as! String
            let strTime = (arrDoctor[i] as AnyObject).object(forKey:"Entered_DateTime") as! String
            let type = ("D") as! String
            
            let dict1  = ["Latitude":strLat,"Longitude":strLon,"Entered_DateTime":strTime,"type":type]
            arrDATABASEvalue.append(dict1)
            
//            self.arrFinalLat.append(strLat)
//            arrFinalLong.append(strLon)
//            arrfinalType.append(type)
//            arrfinalEnteredTime.append(strTime)
        }
    
        for i in 0..<arrChemist.count{
            let strLat = (arrChemist[i] as AnyObject).object(forKey:"Latitude") as! String
            let strLon = (arrChemist[i] as AnyObject).object(forKey:"Longitude") as! String
            let strTime = (arrChemist[i] as AnyObject).object(forKey:"Entered_DateTime") as! String
            let type = ("C") as! String
            
            let dict1  = ["Latitude":strLat,"Longitude":strLon,"Entered_DateTime":strTime,"type":type]
            arrDATABASEvalue.append(dict1)
            
//            self.arrFinalLat.append(strLat)
//            arrFinalLong.append(strLon)
//            arrfinalType.append(type)
//            arrfinalEnteredTime.append(strTime)

        }
        
        for i in 0..<arrStockist.count{
            let strLat = (arrStockist[i] as AnyObject).object(forKey:"Latitude") as! String
            let strLon = (arrStockist[i] as AnyObject).object(forKey:"Longitude") as! String
            let strTime = (arrStockist[i] as AnyObject).object(forKey:"Entered_DateTime") as! String
            let type = ("S") as! String
            
            let dict1  = ["Latitude":strLat,"Longitude":strLon,"Entered_DateTime":strTime,"type":type]
            arrDATABASEvalue.append(dict1)
 
//            self.arrFinalLat.append(strLat)
//            arrFinalLong.append(strLon)
//            arrfinalType.append(type)
//            arrfinalEnteredTime.append(strTime)
        }
        
        for i in 0..<arrTravelReport.count{
            let strLat = (arrTravelReport[i] as AnyObject).object(forKey:"Latitude") as! String
            let strLon = (arrTravelReport[i] as AnyObject).object(forKey:"Longitude") as! String
            let strTime = (arrTravelReport[i] as AnyObject).object(forKey:"Entered_DateTime") as! String
            let type = ("T") as! String
            
            let dict1  = ["Latitude":strLat,"Longitude":strLon,"Entered_DateTime":strTime,"type":type]
            arrDATABASEvalue.append(dict1)
            
            
            
//            self.arrFinalLat.append(strLat)
//            arrFinalLong.append(strLon)
//            arrfinalType.append(type)
//            arrfinalEnteredTime.append(strTime)
        }

        DBHelper.sharedInstance.deleteFromTable(tableName: Travel_Tracking_Report)
        DBHelper.sharedInstance.insertTravelTrackingReport(array: arrDATABASEvalue as NSArray)
        
 
        
        if(arrDATABASEvalue.count > 0)
        {
            self.loadMultiMarkerMap()
        }
        
    }
    
   
    
    @objc func addToShowList()
    {
         let strCheck = UserDefaults.standard.string(forKey: "RightbtnCheck")
        
        if (strCheck == "HIDE"){
            viewMenuLeft.isHidden = false
            UserDefaults.standard.set("", forKey: "RightbtnCheck")
            UserDefaults.standard.synchronize()
        }else{
            viewMenuLeft.isHidden = true
            UserDefaults.standard.set("HIDE", forKey: "RightbtnCheck")
            UserDefaults.standard.synchronize()
        }
//        showListBtnAction()
//        self.navigationController?.popViewController(animated: true)
    }

        func loadMultiMarkerMap()
        {
            //        let camera = GMSCameraPosition.camera(withLatitude: doctorListWithLocations[0].Lattitude, longitude: doctorListWithLocations[0].Longitude, zoom: 20)
            //        mapView.camera = camera
            mapViewTravel.delegate = self

            self.mark()
        }
        func mark()
        {
 //           let filteredArray = self.arrfinalType.filter
//            {
//                $0.Entered_DateTime == EMPTY || $0.Entered_DateTime == NOT_APPLICABLE
//            }
//            if (filteredArray.count == 0)
//            {
//                self.doctorListWithLocations = self.doctorListWithLocations.sorted(by: { $0.Time! < $1.Time! })
//            }

            var D = 0
            var C = 0
            var S = 0
            let TravelDetailsDetails = DBHelper.sharedInstance.getTravelTrackingReport()
            for i in 0..<TravelDetailsDetails!.count
            {
                let markerView = UIView(frame:CGRect(x:0, y:0, width:27, height:45))
                let markerImage = UIImageView(frame: CGRect(x:0, y:0, width:27, height:45))

                //let strType = "C" as String
                
                
                var resultArray = TravelDetailsDetails![i].type1
                
                
                if (TravelDetailsDetails![i].type1 == "C"){
                    markerImage.image = UIImage(named: "ic_maps_markerGreen")
                }else if (TravelDetailsDetails![i].type1 == "S"){
                    markerImage.image = UIImage(named: "ic_maps_marker")
                }else if (TravelDetailsDetails![i].type1 == "D"){
                    markerImage.image = UIImage(named: "ic_maps_markerBlue")
                }else{
                    markerImage.image = UIImage(named: "ic_map_Travel")
                }


                markerView.addSubview(markerImage)

                let markerLbl = UILabel(frame: CGRect(x:0, y:12, width:25, height:10))

                markerLbl.font = UIFont.boldSystemFont(ofSize: 12)
                markerLbl.textColor = UIColor.white

                if(!isSingleMap)
                {
                    if (TravelDetailsDetails![i].type1 == "D"){
                        D = D + 1
                        markerLbl.text = "\(D)"
                    }else if (TravelDetailsDetails![i].type1 == "C"){
                        C = C + 1
                        markerLbl.text = "\(C)"
                    }else if (TravelDetailsDetails![i].type1 == "S"){
                        S = S + 1
                        markerLbl.text = "\(S)"
                    }else{
                        //markerLbl.text = "\(i+1)"
                    }
                    
                }

                markerLbl.textAlignment = NSTextAlignment.center
                markerView.addSubview(markerLbl)

                let marker1 = GMSMarker()
                
                let strLat1 = TravelDetailsDetails![i].Latitude as! String
                let strLong1 = TravelDetailsDetails![i].Longitude as! String

                let doubleLat = Double(strLat1)
                let doubleLong = Double(strLong1)
                
                marker1.position = CLLocationCoordinate2D(latitude: doubleLat!, longitude: doubleLong!)
                marker1.title = ""
                marker1.snippet = ""
                marker1.map = mapViewTravel
                marker1.icon = imageFromView(aView: markerView)
                markers.append(marker1)
                path.addLatitude(doubleLat!, longitude: doubleLong!)
            }

            let polyline = GMSPolyline(path: path)
            let bounds = GMSCoordinateBounds(path: path)

            if SwifterSwift().isPhone
            {
                self.mapViewTravel!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 20.0))
            }
            else
            {
                self.mapViewTravel!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 0.0))
            }

            polyline.strokeColor = .blue
            polyline.strokeWidth = 2.0
//            if(filteredArray.count == 0)
//            {
                polyline.map = mapViewTravel
//            }
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


}
