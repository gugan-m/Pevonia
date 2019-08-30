//
//  RemoveAccompanistPopUpViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 26/04/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class RemoveAccompanistPopUpViewController: UIViewController {
    
    @IBOutlet weak var line1TxtLbl : UILabel!
    @IBOutlet weak var line2TxtLbl : UILabel!
  
    var dcrAccompanistObj : DCRAccompanistModel!
    var delegate : SaveActionToastDelegate?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        setDetails()
    }

    func setDetails()
    {
        self.line1TxtLbl.attributedText = getHtmlAttributedString(htmlString :"\(getBodyTagString())You are trying to remove <b>\(dcrAccompanistObj.Employee_Name!)</b> from the Ride Along list</body>")
        
        self.line2TxtLbl.attributedText = getHtmlAttributedString(htmlString : "\(getBodyTagString())1. If any visit of \(appDoctor)/\(appChemist) that belong to this Ride Along/region is available in this DVR, system will remove the \(appDoctor)/\(appChemist) visit.<br/>2. If you have marked this Ride Along/region name in \(appDoctor) Ride Along, those records will be removed.<br/>3. The CP, SFC records and visit of \(appChemist) who belongs to this Ride Along/region name will be removed.<br/>Click <b>OK</b> to continue<br/>Click <b>CANCEL</b> to retain this Ride Along/region and related \(appDoctor)/\(appChemist) visits.")
    }
    
    @IBAction func okBtnAction(_ sender: AnyObject)
    {
        BL_DCR_Accompanist.sharedInstance.removeAccompanitsDataUsedInDCR(accompanistRegionCode:dcrAccompanistObj.Acc_Region_Code, accompanistUserCode: dcrAccompanistObj.Acc_User_Code!)
       self.dismiss(animated: false, completion: nil)
       delegate?.showUpdateToastView()
    }
    
    @IBAction func cancelBtnAction(_ sender: AnyObject)
    {
        self.dismiss(animated: false, completion: nil)
    }

    func getHtmlAttributedString(htmlString : String) -> NSAttributedString?
    {
        guard let data = htmlString.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
        guard let html = try? NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else { return nil }
        return html
    }
    
    private func getBodyTagString() -> String
    {
       return "<body style=\"color: #555555;font-family: '\(fontRegular)', sans-serif;font-size: 14 \">"
    }
}
