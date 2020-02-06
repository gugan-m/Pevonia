//
//  ComplaintDetailViewController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 20/05/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class ComplaintDetailViewController: UIViewController {
    
    var complaintValue = ComplaintList()
    
    @IBOutlet weak var remarkHeightConst: NSLayoutConstraint!
     @IBOutlet weak var remarkHeightConst1: NSLayoutConstraint!
    @IBOutlet weak var solurionRemarkHeightConst: NSLayoutConstraint!
    @IBOutlet weak var scrollViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var problemLbl : UILabel!
    @IBOutlet weak var remarkLbl : UILabel!
    @IBOutlet weak var solutionGivenTitle : UILabel!
    @IBOutlet weak var solutionGivenView : UIView!
    @IBOutlet weak var solutionGivenLbl : UILabel!
    @IBOutlet weak var regionLbl : UILabel!
    @IBOutlet weak var customerNameLbl : UILabel!
    @IBOutlet weak var typeLbl : UILabel!
    @IBOutlet weak var complaintDateLbl : UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Complaint Details"
        addBackButtonView()
        self.setDefaults()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setDefaults()
    {
        problemLbl.text = complaintValue.Problem_Short_Description
        remarkLbl.text = complaintValue.Problem_Description
        customerNameLbl.text = "Name: " + complaintValue.Customer_Name
        regionLbl.text = "Territory: " + complaintValue.Region_Name
        var type = String()
        if(complaintValue.Customer_Entity_Type.lowercased() == "doctor")
        {
            type = appDoctor
        }
        else if(complaintValue.Customer_Entity_Type.lowercased() == "chemist")
        {
            type = appChemist
        }
        else
        {
            type = appStockiest
        }
        typeLbl.text = "Type: " + type
        
        let datevalue = complaintValue.Complaint_Date.components(separatedBy: " ")
        if(datevalue.count > 0)
        {
            let dateFromValue = convertDateIntoString(dateString: datevalue[0])
            let appFormatDate = convertDateIntoString(date: dateFromValue)
            
            let existingFromTime = getTimeIn12HrFormat(date: getDateFromString(dateString: complaintValue.Complaint_Date), timeZone: NSTimeZone.local)
            
            complaintDateLbl.text = "Complaint Date: " + appFormatDate + " " + existingFromTime
        }
            
        else
        {
            complaintDateLbl.text = ""
        }
        
        let getHeight = getTextSize(text: complaintValue.Problem_Description, fontName: fontRegular, fontSize: 14, constrainedWidth: SCREEN_WIDTH - 20).height
        let getRemarkHeight = getTextSize(text: complaintValue.Problem_Short_Description, fontName: fontRegular, fontSize: 14, constrainedWidth: SCREEN_WIDTH - 20).height
        if(getHeight > 90)
        {
            remarkHeightConst.constant = getHeight + 90
            scrollViewHeightConst.constant = 748 + getHeight
        }
        if(getRemarkHeight > 90)
        {
            
            scrollViewHeightConst.constant += getRemarkHeight
            remarkHeightConst1.constant = getRemarkHeight + 90
        }
        if(complaintValue.Resolution_Remarks == EMPTY && complaintValue.Resolution_By == EMPTY && complaintValue.Resolution_Date == nil)
        {
            solutionGivenTitle.isHidden = true
            solutionGivenView.isHidden = true
            solutionGivenLbl.isHidden = true
            
            solutionGivenLbl.text = ""
        }
        else
        {
            solutionGivenTitle.isHidden = false
            solutionGivenView.isHidden = false
            solutionGivenLbl.isHidden = false
            var appFormat = String()
            if(complaintValue.Resolution_Date != nil)
            {
                if(datevalue.count > 0)
                {
                    
                    let appFormatDate = convertDateIntoString(date: complaintValue.Resolution_Date!)
                    appFormat = appFormatDate
                }
                    
                else
                {
                    appFormat = ""
                }
            }
            
            var solutionRemark = complaintValue.Resolution_Remarks!
            if(solutionRemark == EMPTY)
            {
                solutionRemark = NOT_APPLICABLE
            }
            let solutionText = "Solution By: \(complaintValue.Resolution_By!) \n\nSolution Date: \(appFormat)\n\nSolution Remark:\n\(solutionRemark)"
            solutionGivenLbl.text = solutionText
            let getHeight = getTextSize(text: solutionText, fontName: fontRegular, fontSize: 14, constrainedWidth: SCREEN_WIDTH - 20).height
            if(getHeight > 150)
            {
                solurionRemarkHeightConst.constant += getHeight
                scrollViewHeightConst.constant += getHeight
            }
        }
        
    }
   

}
