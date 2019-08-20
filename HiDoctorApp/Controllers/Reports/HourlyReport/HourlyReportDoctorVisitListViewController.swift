//
//  HourlyReportDoctorVisitListViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 10/03/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class HourlyReportDoctorVisitListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate
{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var doctorNameLbl: UILabel!
    @IBOutlet weak var detail1Lbl: UILabel!
    @IBOutlet weak var drNameLblLeadingConst: NSLayoutConstraint!
    @IBOutlet weak var drNameLblTopConst: NSLayoutConstraint!
    @IBOutlet weak var headerHgtConst: NSLayoutConstraint!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var doctorVisitList : [ReportDoctorVisitListModel] = []
    var isComingFromGeo : Bool = false
    
    let maxHeaderHeight: CGFloat = 140
    let minHeaderHeight: CGFloat = 64
    
    var isScrollingDown : Bool = false
    var userObj : UserMasterModel!
    
    var previousScrollOffset: CGFloat = 0;
    
    override func viewDidLoad()
    {
       super.viewDidLoad()
        tableView.estimatedRowHeight = 500
        setHeaderDetails()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        setTableViewHgt()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func backBtnAction(_ sender: AnyObject)
    {
        self.navigationController?.isNavigationBarHidden = false
        _ = self.navigationController?.popViewController(animated: false)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return doctorVisitList.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.HourlyReportDoctorVisitCell, for: indexPath) as! HourlyReportDoctorVisitListTableViewCell
        
        let obj = doctorVisitList[indexPath.row]
        
        let visitDate = getStringInFormatDate(dateString: checkNullAndNilValueForString(stringData: obj.displayDate))
        let visitDateString = convertDateIntoString(date: visitDate)
        
        let headerTxt = "\(visitDateString) - \(obj.dcrStatus)"
        
        cell.headerLbl.text = headerTxt
        cell.descriptionLbl.text = "\(appDoctor) Visited/\(appChemist) Visited/\(appStockiest) Visited"
        
        var visitCount : String = obj.doctorVisitCount
        if Int(obj.doctorVisitCount)! > 99
        {
            visitCount = "99+"
        }
        
        cell.visitCountLbl.text = visitCount
        cell.visitCountLbl.layer.cornerRadius = 15
        cell.visitCountLbl.layer.masksToBounds = true

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) 
    {
        let obj = doctorVisitList[indexPath.row]

        if Int(obj.doctorVisitCount)! > 0
        {
            if checkInternetConnectivity()
            {
                self.navigationController?.isNavigationBarHidden = false
                
                let obj = doctorVisitList[indexPath.row]
                let sb = UIStoryboard(name: Constants.StoaryBoardNames.HourlyReportSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.HourlyReportVcID) as! ShowHourlyReportViewController
                vc.selectedDate = obj.displayDate
                vc.selectedEmployeeName = userObj.Employee_name
                vc.selectedUserCode = userObj.User_Code
                vc.isComingFromGeo = isComingFromGeo
                
                let strCheck = UserDefaults.standard.string(forKey: "GeoCheck")
                if (strCheck == "1"){
                    vc.geoDoctorList = obj.geoAllList
                    vc.geoCustomerList = obj.geoDoctorList
                    vc.geoChemistList = obj.geoChemistList
                    vc.geoStockistList = obj.geoStockistList
                    vc.geoAllList = obj.geoAllList
                }else{
                    vc.geoDoctorList = obj.geoDoctorList + obj.geoChemistList + obj.geoStockistList
                    vc.geoCustomerList = obj.geoDoctorList
                    vc.geoChemistList = obj.geoChemistList
                    vc.geoStockistList = obj.geoStockistList
                    vc.geoAllList = obj.geoDoctorList + obj.geoChemistList + obj.geoStockistList
                }
        
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                AlertView.showNoInternetAlert()
            }
        }
        else
        {
            AlertView.showAlertView(title: infoTitle, message: "No \(appDoctor) visit details available for this date", viewController: self)
        }
    }
    
    //MARK:- Expand Collapse
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollDiff = scrollView.contentOffset.y - self.previousScrollOffset
        
        let absoluteTop: CGFloat = 0;
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height;
        
        var isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
        
            // Calculate new header height
            var newHeight = self.headerHgtConst.constant
            if isScrollingDown {
                newHeight = max(self.minHeaderHeight, self.headerHgtConst.constant - abs(scrollDiff))
            } else if isScrollingUp {
                isScrollingDown = true
                newHeight = min(self.maxHeaderHeight, self.headerHgtConst.constant + abs(scrollDiff))
            }
            
            // Header needs to animate
            if newHeight != self.headerHgtConst.constant {
                self.headerHgtConst.constant = newHeight
                self.updateHeader()
                self.setScrollPosition(self.previousScrollOffset)
            }
            
            self.previousScrollOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidStopScrolling()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollViewDidStopScrolling()
        }
    }
    
    private func scrollViewDidStopScrolling() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let midPoint = self.minHeaderHeight + (range / 2)
        
        if self.headerHgtConst.constant > midPoint {
            self.expandHeader()
        } else {
            self.collapseHeader()
        }
    }
    
    private func canAnimateHeader(_ scrollView: UIScrollView) -> Bool
    {
        // Calculate the size of the scrollView when header is collapsed
        let scrollViewMaxHeight = scrollView.frame.height + self.headerHgtConst.constant - minHeaderHeight
        
        // Make sure that when header is collapsed, there is still room to scroll
        return scrollView.contentSize.height > scrollViewMaxHeight
    }
    
    
    private func collapseHeader()
    {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHgtConst.constant = self.minHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    private func expandHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHgtConst.constant = self.maxHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    private func setScrollPosition(_ position: CGFloat) {
        self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x, y: position)
    }
    
    
    private func updateHeader()
    {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let openAmount = self.headerHgtConst.constant - self.minHeaderHeight
        let percentage = openAmount / range
        
        self.headerView.alpha = percentage
        
        drNameLblLeadingConst.constant = ((1 - percentage) * 40) + 8
        drNameLblTopConst.constant =  (45 * percentage)
        let fontSize = (14 + (5 * percentage))
        self.doctorNameLbl.font = UIFont(name: "SF-UI-Text-Bold", size: fontSize)
        self.setTableViewHgt()
    }

    private func setTableViewHgt()
    {
        self.tableView.layoutIfNeeded()
        var tableViewHeight  = self.tableView.contentSize.height
        let minimumScrollHeight = self.view.frame.size.height - self.headerHgtConst.constant
        if tableViewHeight < minimumScrollHeight
        {
            tableViewHeight = minimumScrollHeight
        }
        self.tableViewHeight.constant = tableViewHeight
    }
    
    private func setHeaderDetails()
    {
       self.doctorNameLbl.text = checkNullAndNilValueForString(stringData: userObj.Employee_name)
       self.detail1Lbl.text = "UserId: \(checkNullAndNilValueForString(stringData: userObj.User_Name)) | Designation: \(checkNullAndNilValueForString(stringData: userObj.User_Type_Name)) | \(checkNullAndNilValueForString(stringData: userObj.Region_Name))"
    }
    

}
