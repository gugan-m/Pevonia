//
//  DeleteDCRFilterViewController.swift
//  HiDoctorApp
//
//  Created by SwaaS on 13/03/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class DeleteDCRFilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    
    let filterArr : [String] = [applied, approved, drafted, unApproved]
    var indexArr: NSMutableArray = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        addCustomBackButtonToNavigationBar()
        addDoneButtonToNavigationBar()
        
        for index in DCRModel.sharedInstance.deleteDCRFilterList
        {
            if index == "\(DCRStatus.applied.rawValue)"
            {
                indexArr.add(applied)
            }
            else if index == "\(DCRStatus.approved.rawValue)"
            {
                indexArr.add(approved)
            }
            else if index == "\(DCRStatus.unApproved.rawValue)"
            {
                indexArr.add(unApproved)
            }
            else if index == "\(DCRStatus.drafted.rawValue)"
            {
                indexArr.add(drafted)
            }
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: deleteDCRFilterCell) as! DeleteDCRFilterTableViewCell
        cell.filterNameLabel.text = filterArr[indexPath.row]
        
        if indexArr.contains(filterArr[indexPath.row])
        {
            cell.selectionImageView.image = UIImage(named: "icon-check")
        }
        else
        {
            cell.selectionImageView.image = UIImage(named: "icon-uncheck")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let status = filterArr[indexPath.row]
        if indexArr.contains(status)
        {
            indexArr.remove(status)
        }
        else
        {
            indexArr.add(status)
        }
        
        reloadTableview()
    }
    
    func reloadTableview()
    {
        tableView.reloadData()
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
        if indexArr.count > 0
        {
            var filteredArray : [String] = []
            for status in indexArr
            {
                let getStatus = status as! String
                if getStatus == applied
                {
                    filteredArray.append("\(DCRStatus.applied.rawValue)")
                }
                else if getStatus == approved
                {
                    filteredArray.append("\(DCRStatus.approved.rawValue)")
                }
                else if getStatus == drafted
                {
                    filteredArray.append("\(DCRStatus.drafted.rawValue)")
                }
                else if getStatus == unApproved
                {
                    filteredArray.append("\(DCRStatus.unApproved.rawValue)")
                }
            }
            
            if containSameElements(firstArray: DCRModel.sharedInstance.deleteDCRFilterList, secondArray: filteredArray)
            {
                popController()
            }
            else
            {
                showCancelAlert()
            }
        }
        else
        {
            AlertView.showAlertView(title: alertTitle, message: filterErrorMsg, viewController: self)
        }
    }
    
    func showCancelAlert()
    {
        let alertViewController = UIAlertController(title: filterTitle, message: filterMsg, preferredStyle: UIAlertControllerStyle.alert)
        alertViewController.addAction(UIAlertAction(title: apply, style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction) -> Void in
                self.filteredListAction()
        }))
        alertViewController.addAction(UIAlertAction(title: skip, style: UIAlertActionStyle.cancel, handler: { (alert: UIAlertAction) -> Void in
                self.popController()
        }))
        self.present(alertViewController, animated: false, completion: nil)
    }
    
    func popController()
    {
        _ = navigationController?.popViewController(animated: false)
    }
    
    private func addDoneButtonToNavigationBar()
    {
        let doneButton = UIButton(type: UIButtonType.custom)
        
        doneButton.addTarget(self, action: #selector(self.doneButtonClicked), for: UIControlEvents.touchUpInside)
        doneButton.setTitle("Done", for: .normal)
        doneButton.sizeToFit()
        
        let rightBarButtonItem = UIBarButtonItem(customView: doneButton)
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func doneButtonClicked()
    {
        filteredListAction()
    }
    
    func filteredListAction()
    {
        if indexArr.count > 0
        {
            if DCRModel.sharedInstance.deleteDCRFilterList.count > 0
            {
                DCRModel.sharedInstance.deleteDCRFilterList = []
            }
            for status in indexArr
            {
                let getStatus = status as! String
                if getStatus == applied
                {
                    DCRModel.sharedInstance.deleteDCRFilterList.append("\(DCRStatus.applied.rawValue)")
                }
                else if getStatus == approved
                {
                    DCRModel.sharedInstance.deleteDCRFilterList.append("\(DCRStatus.approved.rawValue)")
                }
                else if getStatus == drafted
                {
                    DCRModel.sharedInstance.deleteDCRFilterList.append("\(DCRStatus.drafted.rawValue)")
                }
                else if getStatus == unApproved
                {
                    DCRModel.sharedInstance.deleteDCRFilterList.append("\(DCRStatus.unApproved.rawValue)")
                }
            }
            
            popController()
        }
        else
        {
            AlertView.showAlertView(title: alertTitle, message: filterErrorMsg, viewController: self)
        }
    }
}
