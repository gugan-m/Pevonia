//
//  DCRRefreshController.swift
//  HiDoctorApp
//
//  Created by Vijay on 13/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class DCRRefreshController: UIViewController, DCRRefreshDelegate
{
    func getInwardAlert(statusCode: Int,isNavigate:Bool) {
        if(isNavigate)
        {
            let sb = UIStoryboard(name:commonListSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: InwardAccknowledgementID) as! InwardChalanListViewController
            BL_Upload_DCR.sharedInstance.isFromDCRUpload = true
            vc.isFromUpload = BL_Upload_DCR.sharedInstance.isFromDCRUpload
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            //Show popUpview
        }
    }
    
    var refreshMode : DCRRefreshMode!
    var endDate : String!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.navigationItem.title = "DCR Refresh"
        BL_Upload_DCR.sharedInstance.isFromDCRUpload = false
        
        if refreshMode == DCRRefreshMode.MERGE_DRAFT_AND_UNAPPROVED_DATA
        {
            refreshAPICall()
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startAction(_ sender: AnyObject)
    {
        uploadAnalyticsDuringDCRRefresh = false
        navigateToAttachmentUpload = false
        refreshAPICall()
    }
    
    private func refreshAPICall()
    {
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: authenticationTxt)
            
            BL_MenuAccess.sharedInstance.getCheckUserExist(viewController: self, completion: { (apiResponseObj) in
                
                removeCustomActivityView()
                
                if apiResponseObj.list.count > 0
                {
                    showCustomActivityIndicatorView(loadingText: "Refreshing DCR data")
                    BL_DCR_Refresh.sharedInstance.dcrRefreshAPICall(refreshMode: self.refreshMode, endDate: self.endDate)
                    BL_DCR_Refresh.sharedInstance.delegate = self
                    BL_PrepareMyDevice.sharedInstance.getbussinessStatusPotential()
                }
//                else
//                {
//                    AlertView.showAlertView(title: errorTitle, message: authenticationMsg, viewController: self)
//                }
            })
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    
    func getServiceStatus(message: String, statusCode: Int)
    {
        //removeCustomActivityView()
        showToastView(toastText: message)
    }
}
