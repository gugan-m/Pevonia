//
//  AccompanistPopUpViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 01/02/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit


protocol SelectedAccompanistPopUpDelegate
{
    func getselectedAccompanist(selectedAccompanist : [DCRAccompanistModel],type : Int)
}

class AccompanistPopUpViewController: UIViewController,UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHgtConstant: NSLayoutConstraint!
    
    var dcrAccompanistList : [DCRAccompanistModel] = []
    var selectedDcrAccompanistList : NSMutableArray = []
    
    var delegate : SelectedAccompanistPopUpDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 200
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.tableView.reloadData()
    }
    
        
    override func viewDidLayoutSubviews()
    {
        self.tableView.layoutIfNeeded()
        self.tableViewHgtConstant.constant = tableView.contentSize.height
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dcrAccompanistList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.AccompanistPopUpCell, for: indexPath) as! AccompanistPopUpTableViewCell
        let accompanistObj = dcrAccompanistList[indexPath.row]
        let employeeName = checkNullAndNilValueForString(stringData: accompanistObj.Employee_Name)
        let regionName = checkNullAndNilValueForString(stringData : accompanistObj.Region_Name)
        
        cell.accompanistNameLbl.text =  employeeName
        cell.regionNameLbl.text = regionName
     
        if selectedDcrAccompanistList.contains(accompanistObj)
        {
            cell.selectedImg.image = UIImage(named: "icon-tick")
        }
        else
        {
            cell.selectedImg.image = UIImage(named: "icon-unselected")
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let accompanistObj = dcrAccompanistList[indexPath.row]
        if !selectedDcrAccompanistList.contains(accompanistObj)
        {
            selectedDcrAccompanistList.add(accompanistObj)
        }
        else if selectedDcrAccompanistList.count > 0
        {
            selectedDcrAccompanistList.remove(accompanistObj)
        }
        
        self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
    }
    
    private func canDownloadAccompanistData() -> Bool
    {
        let pendingDownlodCount = MAX_ACCOMPANIST_DATA_DOWNLOAD_COUNT - (getDownloadedAccompanistCount() + selectedDcrAccompanistList.count)
        
        if (pendingDownlodCount >= 0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    private func getDownloadedAccompanistCount() -> Int
    {
        return BL_PrepareMyDeviceAccompanist.sharedInstance.getAccompanistDataDownloadedRegions().count
    }
    
    @IBAction func laterBtnAction(_ sender: Any)
    {
        delegate?.getselectedAccompanist(selectedAccompanist: dcrAccompanistList ,type : 1)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func downloadBtnAction(_ sender: Any)
    {
        if (selectedDcrAccompanistList.count > 0)
        {
            if (canDownloadAccompanistData())
            {
                delegate?.getselectedAccompanist(selectedAccompanist: convertSelectedAccompanist() , type : 2)
                self.dismiss(animated: false, completion: nil)
            }
            else
            {
                showToastView(toastText: "You have already downloaded \(getDownloadedAccompanistCount()) accompanists' data. You can download maximum of \(MAX_ACCOMPANIST_DATA_DOWNLOAD_COUNT) accompanists data only")
            }
        }
        else
        {
            showToastView(toastText: "Please select atleast one accompanist")
        }
    }
    
    func convertSelectedAccompanist() -> [DCRAccompanistModel]
    {
        var dcrSelectedAccompanistList : [DCRAccompanistModel] = []
        for obj in selectedDcrAccompanistList
        {
            dcrSelectedAccompanistList.append(obj as! DCRAccompanistModel)
        }
        return dcrSelectedAccompanistList
    }

}
