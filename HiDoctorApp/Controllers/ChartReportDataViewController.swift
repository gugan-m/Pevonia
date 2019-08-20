//
//  ChartReportDataViewController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 17/02/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit
import Charts

class DoctorCountDataModel: Codable
{
    var User_Code : String!
    var User_Name : String!
    var Employee_Name : String!
    var Region_Name : String!
    var User_Type_Name : String!
    var Visit_Count : Int!
}

class ChartReportDataViewController: UIViewController,ChartViewDelegate
{
    @IBOutlet weak var chartView : UIView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    @IBOutlet weak var emptyStateView: UIView!
    
    @IBOutlet weak var piChartView: PieChartView!
    let redcolor = UIColor(red: 251.0/255.0, green: 211.0/255.0, blue: 15.0/255.0, alpha: 1)
    let greencolor = UIColor(red: 76.0/255.0, green: 175.0/255.0, blue: 80.0/255.0, alpha: 1)
    var currentDate = String()
    var doctorCountList : [DoctorCountDataModel] = []
    var doctorListArray1 : [DoctorCountDataModel] = []
    var doctorListArray2 : [DoctorCountDataModel] = []
    
    var chartInfoString : [String]!
    var chartDisplayNum = [Int]()
    var chart = PieChartView()
    var chartColors : [UIColor] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        currentDate = BL_MasterDataDownload.sharedInstance.getCurrentDate()
        chartInfoString = ["Users started visiting \(appDoctor)","Users yet to start \(appDoctor) Visits"]
        chartColors.append(greencolor)
        chartColors.append(redcolor)
        self.getDoctorVisitCount(date:currentDate)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        //chart.removeFromSuperview()
       // self.updateChart(doctorCount: chartDisplayNum)
    }
    
    func getDoctorVisitCount(date: String)
    {
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: "Loading...")
            WebServiceHelper.sharedInstance.getDoctorVisitCount(date: date)
            {(apiResponseObject) in
                if(apiResponseObject.Status == SERVER_SUCCESS_CODE)
                {
                    if(apiResponseObject.list.count > 0)
                    {
                        guard let data = try? JSONSerialization.data(withJSONObject: apiResponseObject.list, options: []) else {
                            return
                        }
                        let doctorCountlData = String(data: data, encoding: String.Encoding.utf8)
                        self.doctorCountList = try! JSONDecoder().decode([DoctorCountDataModel].self, from: (doctorCountlData?.data(using: .utf8)!)!)
                        
                         self.doctorListArray1 = self.doctorCountList.filter{$0.Visit_Count == 0}
                         self.doctorListArray2 = self.doctorCountList.filter{$0.Visit_Count > 0}
                        if(self.doctorListArray2.count == 0)
                        {
                            self.chartDisplayNum.append(0)
                        }
                        else
                        {
                            self.chartDisplayNum.append(self.doctorListArray2.count)
                        }
                        if(self.doctorListArray1.count == 0)
                        {
                            self.chartDisplayNum.append(0)
                        }
                        else
                        {
                            self.chartDisplayNum.append(self.doctorListArray1.count)
                        }
                        self.updateChart(doctorCount: self.chartDisplayNum)
                    }
                    else
                    {
                        self.emptyStateLbl.text = "No Data availabe"
                    }
                }
                else
                {
                    self.showMessageForApiReponse(apiResponseObj: apiResponseObject)
                }
                removeCustomActivityView()
            }
        }
        else
        {
            AlertView.showNoInternetAlert()
            
        }
    }
    
    func updateChart(doctorCount:[Int])
    {
       // chart = PieChartView(frame: chartView.frame)
        piChartView.delegate = self
        var entries = [PieChartDataEntry]()
        var colors: [UIColor] = []

        for (index, value) in doctorCount.enumerated()
        {
            let entry = PieChartDataEntry()
            if(value > 0)
            {
                entry.y = Double(value)
                colors.append(chartColors[index])
                entry.label = chartInfoString[index]
                entries.append( entry)
            }
        }

        let set = PieChartDataSet( values: entries, label: "")
        set.colors = colors

        let data = PieChartData(dataSet: set)
        piChartView.data = data
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        data.setValueFormatter(DefaultValueFormatter(formatter:formatter))
        piChartView.noDataText =  "No data available"
        piChartView.isUserInteractionEnabled = true
        piChartView.centerText = "Visit Status"
        piChartView.holeRadiusPercent = 0.5
        piChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        piChartView.transparentCircleColor = UIColor.clear
        //chart.target(forAction: #selector(self.chartValue), withSender: "")
        piChartView.drawEntryLabelsEnabled = false
        piChartView.chartDescription?.text = ""
        //self.chartView.addSubview(chart)

    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight)
    {

        let dataEntry = entry as! PieChartDataEntry
        if(dataEntry.label == chartInfoString[0])
        {
            //Redirect for visit count list
            let sb = UIStoryboard(name: Constants.StoaryBoardNames.ReportsSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.ChartDoctorListVCID) as! ChartDoctorListViewController
            vc.doctorCountList = self.doctorListArray2
            vc.isNonVist = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if(dataEntry.label == chartInfoString[1])
        {
            //Redirect for non visit count list
            let sb = UIStoryboard(name: Constants.StoaryBoardNames.ReportsSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.ChartDoctorListVCID) as! ChartDoctorListViewController
            vc.doctorCountList = self.doctorListArray1
            vc.isNonVist = true
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    func showMessageForApiReponse(apiResponseObj : ApiResponseModel)
    {
        if apiResponseObj.Status == NO_INTERNET_ERROR_CODE
        {
            self.showEmptyStateView(show: true)
            self.emptyStateLbl.text = "No Internet Connection"
            
        }
        else
        {
            var emptyStateText : String = apiResponseObj.Message
            self.showEmptyStateView(show: true)
            
            if emptyStateText == ""
            {
                emptyStateText = "Unable to fetch data."
            }
            
            self.emptyStateLbl.text = emptyStateText
        }
        
    }
    
    func showEmptyStateView(show : Bool)
    {
        self.emptyStateView.isHidden = !show
        self.chartView.isHidden = show
    }
    
}
