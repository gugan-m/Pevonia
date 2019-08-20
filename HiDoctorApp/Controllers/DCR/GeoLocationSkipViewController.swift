//
//  GeoLocationSkipViewController.swift
//  HiDoctorApp
//
//  Created by SwaaS on 14/03/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

protocol GeoFencingSkipDelegate
{
    func saveSkipRemarks(remarks: String, isCancelled: Bool, indexPath: IndexPath, currentLocation: GeoLocationModel)
}

class GeoLocationSkipViewController: UIViewController,UITextViewDelegate
{
    @IBOutlet weak var textView: UITextView!
    var delegate: GeoFencingSkipDelegate?
    var indexPath: IndexPath!
    var currentLocation: GeoLocationModel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        textView.layer.borderWidth = 1
        textView.layer.borderColor =  UIColor.darkGray.cgColor
        textView.delegate = self
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveButtonAction(sender: UIButton)
    {
        let remarks = condenseWhitespace(stringValue: textView.text)
        
        if (remarks.count == 0)
        {
            AlertView.showAlertView(title: alertTitle, message: "Please enter reason", viewController: self)
            return
        }
        
        if (remarks.count > 100)
        {
            AlertView.showAlertView(title: alertTitle, message: "Reason can't exceed 100 characters", viewController: self)
            return
        }
        
        let restrictedChatacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
        if restrictedChatacter != EMPTY
        {
            if (checkIfSpecialCharacterFound(restrictedCharacter: restrictedChatacter, remarkTxt: remarks))
            {
                AlertView.showSpecialCharacterAlertview(title: alertTitle, subject: "Reason", restrictedVal: restrictedChatacter, viewController: self)
                return
            }
        }
        
        self.delegate?.saveSkipRemarks(remarks: remarks, isCancelled: false, indexPath: self.indexPath, currentLocation: self.currentLocation)
        
        closeThisView()
    }
    
    @IBAction func cancelButtonAction(sender: UIButton)
    {
        self.delegate?.saveSkipRemarks(remarks: EMPTY, isCancelled: true, indexPath: self.indexPath, currentLocation: self.currentLocation)
        
        closeThisView()
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    private func closeThisView()
    {
        self.dismiss(animated: false, completion: nil)
    }
}
