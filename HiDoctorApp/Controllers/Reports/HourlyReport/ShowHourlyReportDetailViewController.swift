//
//  ShowHourlyReportDetailViewController.swift
//  HiDoctorApp
//
//  Created by SwaaS on 10/03/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import MapKit

class ShowHourlyReportDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    //MARK:- Outlets
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var doctorDetailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainVieW: UIView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var emptyStateTitleLabel: UILabel!
    @IBOutlet weak var headerDateLbl: UILabel!
    
    //MARK:- Local Variables
    var objDoctorVisit: HourlyReportDoctorVisitModel!
    var hourlyReportList: [HourlyReportDoctorVisitModel] = []
    var selectedEmployeeName: String!
    var selectedDate: String!
    var isComingFromGeo : Bool = false
    
    //MARK:- Life Cycle Events
    override func viewDidLoad()
    {
        super.viewDidLoad()
        doInitialSetup()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Initial Setup()
    
    private func doInitialSetup()
    {
        addBackButtonView()
        if(isComingFromGeo)
        {
            self.title = "Geo Location Report Details"
        }
        else
        {
        self.title = "Live Tracker Report Details"
        }
        tableView.estimatedRowHeight = 500
        showHeaderData()
        reloadTableView()
    }
    
//    private func addBackButtonView()
//    {
//        let backButton = UIButton(type: UIButtonType.custom)
//        
//        backButton.addTarget(self, action: #selector(self.backButtonAction), for: UIControlEvents.touchUpInside)
//        backButton.setImage(UIImage(named: "navigation-arrow"), for: .normal)
//        backButton.sizeToFit()
//        
//        let backButtonItem = UIBarButtonItem(customView: backButton)
//        
//        self.navigationItem.leftBarButtonItem = backButtonItem
//    }
//    
//    @objc func backButtonAction()
//    {
//        _ = navigationController?.popViewController(animated: false)
//    }
    
    private func showHeaderData()
    {
        doctorNameLabel.text = objDoctorVisit.Doctor_Name
        
        var detailText: String = EMPTY
        let mdlNumber = checkNullAndNilValueForString(stringData: objDoctorVisit.MDL_Number)
        let spltyName = checkNullAndNilValueForString(stringData: objDoctorVisit.Speciality_Name)
        let categoryName = checkNullAndNilValueForString(stringData: objDoctorVisit.Category_Name)
        let localArea = checkNullAndNilValueForString(stringData: objDoctorVisit.Local_Area)
        let regionName = checkNullAndNilValueForString(stringData: objDoctorVisit.Doctor_Region_Name)
//        
//        if (mdlNumber != EMPTY)
//        {
//            detailText = mdlNumber
//        }
        
        if (detailText != EMPTY && spltyName != EMPTY)
        {
            detailText = detailText + " | " + spltyName
        }
        else if (detailText == EMPTY && spltyName != EMPTY)
        {
            detailText = spltyName
        }
        
        if (categoryName != EMPTY)
        {
            detailText = detailText + " | " + categoryName
        }
        
        if (localArea != EMPTY)
        {
            detailText = detailText + " | " + localArea
        }
        
        if (regionName != EMPTY)
        {
            detailText = detailText + " | " + regionName
        }
        
        doctorDetailLabel.text = detailText
        
        let visitDate = getStringInFormatDate(dateString: checkNullAndNilValueForString(stringData: selectedDate))
        let visitDateString = convertDateIntoString(date: visitDate)
        
        headerDateLbl.text = visitDateString
    }
    
    private func reloadTableView()
    {
        if (hourlyReportList.count > 0)
        {
            tableView.reloadData()
            showMainView()
        }
        else
        {
            setEmptyStateText(message: "No live tracker report details found.")
            showEmptyStateView()
        }
    }
    
    private func showMainView()
    {
        emptyStateView.isHidden = true
        mainVieW.isHidden = false
    }
    
    private func showEmptyStateView()
    {
        mainVieW.isHidden = true
        emptyStateView.isHidden = false
    }
    
    private func setEmptyStateText(message: String)
    {
        emptyStateTitleLabel.text = message
    }
    
    //MARK:- Button Actions
    @IBAction func viewOnMapAction(sender: AnyObject)
    {
        let objHoulyReport = hourlyReportList[sender.tag]
        
        let sb = UIStoryboard(name: Constants.StoaryBoardNames.HourlyReportSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.HourlyReportGoogleMapViewVc) as! HourlyReportGoogleMapViewController
        
        vc.doctorListWithLocations = [objHoulyReport]
        vc.isSingleMap = true
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        //        let latitude: CLLocationDegrees = objHoulyReport.Lattitude
        //        let longitude: CLLocationDegrees = objHoulyReport.Longitude
        //
        //        let regionDistance:CLLocationDistance = 10000
        //        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        //        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        //        let options = [
        //            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
        //            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        //        ]
        //        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        //        let mapItem = MKMapItem(placemark: placemark)
        //        mapItem.name = " "
        //        mapItem.openInMaps(launchOptions: options)
    }
    
    //MARK:- Table View Delegates
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return hourlyReportList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyReportDetailCell") as! HourlyReportDetailTableViewCell
        let objHourlyReport = hourlyReportList[indexPath.row]
        
        cell.enteredDateTimeLabel.text = objHourlyReport.Entered_DateTime
        cell.syncUpDateTimeLabel.text = objHourlyReport.SyncUp_DateTime
//        cell.addressLabel.text = objHourlyReport.Doctor_Address
        
        if (objHourlyReport.Lattitude > 0 && objHourlyReport.Longitude > 0)
        {
            cell.latitudeLongitudeLabel.text = String(objHourlyReport.Lattitude) + " - " + String(objHourlyReport.Longitude)
            cell.mapButton.isHidden = false
        }
        else
        {
            cell.latitudeLongitudeLabel.text = NOT_APPLICABLE
            cell.mapButton.isHidden = true
        }
        
        cell.mapButton.tag = indexPath.row
        
        cell.selectionStyle = .none
        
        return cell
    }
}
