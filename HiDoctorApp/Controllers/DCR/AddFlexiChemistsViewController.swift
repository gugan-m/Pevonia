//
//  AddFlexiChemistsViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 02/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class AddFlexiChemistsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate
{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHgtConst: NSLayoutConstraint!
    @IBOutlet weak var chemistsNameTxtFld: UITextField!
    @IBOutlet weak var chemistLbl: UILabel!
    @IBOutlet weak var recentlyAddedLbl: UILabel!
   
    var flextChemistList : [FlexiChemistModel] = []
    var isChemistDay : Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        chemistLbl.text = "\(appChemist) Name"
        recentlyAddedLbl.text = "Recently added (Flexi \(appChemistPlural))"
        
        self.getFlexiChemistList()
        self.addTapGestureForView()
          self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
       
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return flextChemistList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddFlexiChemistCell, for: indexPath)
       let flexiChemistObj = flextChemistList[indexPath.row]
        cell.textLabel?.text = flexiChemistObj.Flexi_Chemist_Name as String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let flexiChemistObj = flextChemistList[indexPath.row]

        let sb = UIStoryboard(name: chemistsSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: AddChemistsVisitVcID) as! AddChemistsVisitViewController
        vc.flexiChemistObj = flexiChemistObj
        if let navigationController = self.navigationController
        {
//            navigationController.popViewController(animated: false)
//            navigationController.popViewController(animated: false)
            navigationController.pushViewController(vc, animated: false)
        }

    }
    
    @IBAction func saveBtnAction(_ sender: Any)
    {
        if (chemistsNameTxtFld.text?.count)! == 0
        {
            AlertView.showAlertView(title: alertTitle, message: "Please Add \(appChemist) Name", viewController: self)
        }
        else if condenseWhitespace(stringValue: chemistsNameTxtFld.text!).count == 0
        {
            AlertView.showAlertView(title: alertTitle, message: "Please Add \(appChemist) Name", viewController: self)
        }
        else if (chemistsNameTxtFld.text?.count)! > flexiChemistMaxLength
        {
            AlertView.showMaxLengthExceedAlertView(title: alertTitle, subject: "\(appChemist) name", maxVal: flexiChemistMaxLength, viewController: self)
        }
        else
        {
            if !isChemistDay
            {
          BL_DCR_Chemist_Visit.sharedInstance.saveFlexiChemist(chemistName: chemistsNameTxtFld.text!)
            let sb = UIStoryboard(name: chemistsSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: AddChemistsVisitVcID) as! AddChemistsVisitViewController
            vc.titleName =  RemoveUnwantedSpaceInString(value: chemistsNameTxtFld.text!)
            if let navigationController = self.navigationController
            {
                navigationController.popViewController(animated: false)
                navigationController.popViewController(animated: false)
                navigationController.pushViewController(vc, animated: false)
            }
            }
            else
            {
                let sb = UIStoryboard(name: ChemistDaySB, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: ChemistDayVcID) as! ChemistDayStepperController
                vc.customerMasterModel = convertToCustomerMasterModel(chemistname: chemistsNameTxtFld.text!)
                if let navigationController = self.navigationController
                {
                    navigationController.popViewController(animated: false)
                    navigationController.popViewController(animated: false)
                    navigationController.pushViewController(vc, animated: false)
                }
            }
            }
    }

    func getFlexiChemistList()
    {
        flextChemistList = BL_DCR_Chemist_Visit.sharedInstance.getFlexiChemist()!
        if flextChemistList.count > 0
        {
            self.tableView.reloadData()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func addTapGestureForView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.resignResponserForTextField))
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
    
    
    @objc func resignResponserForTextField()
    {
        self.chemistsNameTxtFld.resignFirstResponder()
    }
 
    func convertToCustomerMasterModel(chemistname: String) -> CustomerMasterModel?
    {
        DCRModel.sharedInstance.customerEntityType = Constants.CustomerEntityType.chemist
        let dict = ["Customer_Name":chemistname]
        let customerObj = CustomerMasterModel(dict: dict as NSDictionary)
        return customerObj
    }
}
