//
//  AddCompetitorProductViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 08/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class AddCompetitorProductViewController: UIViewController,UITextFieldDelegate
{
    
    @IBOutlet weak var competitorProduct : UITextField!
    var competitorList : [CompetitorProductModel] = []
    var productCode : String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func saveBtnAction(_ sender: Any)
    {
        
        if (competitorProduct.text?.count)! == 0
        {
            AlertView.showAlertView(title: alertTitle, message: "Please Enter Competitor Product Name", viewController: self)
        }
        else if condenseWhitespace(stringValue: competitorProduct.text!).count == 0
        {
            AlertView.showAlertView(title: alertTitle, message: "Please Enter Competitor Product Name", viewController: self)
        }
        else if (competitorProduct.text?.count)! > compProdMaxLength
        {
            AlertView.showMaxLengthExceedAlertView(title: alertTitle, subject: "Competitor Product Name", maxVal: compProdMaxLength, viewController: self)
        }
        else
        {
            if let navigationController = self.navigationController
            {
                let viewControllers = navigationController.viewControllers
                
                for viewController1 in viewControllers
                {
                    if viewController1.isKind(of: AddChemistRCPAViewController.self)
                    {
                        let dcrController = viewController1 as! AddChemistRCPAViewController
                        self.convertToCompetitorModel()
                        dcrController.competitorList = competitorList
                        dcrController.isComingFromFlexiCompetitor = true
                        navigationController.popToViewController(dcrController, animated: false)
                        break
                    }
                }
                
            }
            
        }
    }
    
    func convertToCompetitorModel()
    {
        let trimmedText = RemoveUnwantedSpaceInString(value: competitorProduct.text!)
        let dict : NSDictionary = ["Competitor_Product_Id":"0","Competitor_Product_Code" : "","Competitor_Product_Name" : trimmedText ,"Own_Product_Code" : productCode]
        let obj :CompetitorProductModel = CompetitorProductModel(dict: dict)
        competitorList.append(obj)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
}
