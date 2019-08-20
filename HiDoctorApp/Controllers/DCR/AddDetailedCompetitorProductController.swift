//
//  AddDetailedCompetitorProductController.swift
//  HiDoctorApp
//
//  Created by Sabari on 14/06/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class AddDetailedCompetitorProductController: UIViewController,UITextViewDelegate,selectCompetitorDelegate,UITextFieldDelegate{
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var remarkTxt: UITextView!
    @IBOutlet weak var valueTxt: UITextField!
    @IBOutlet weak var probalilityTxt: UITextField!
    @IBOutlet weak var competitorLbl: UILabel!
    @IBOutlet weak var productLbl: UILabel!
    @IBOutlet weak var productAddBut: UIButton!
    @IBOutlet weak var competitorAddBut: UIButton!
    
    
    var selectedProductObj : DetailProductMaster!
    var selectedCompetitorObj : CompetitorModel!
    var selectedCompetitorProductObj : ProductModel!
    var isFromUpdate: Bool!
    var dcrDetailedCompetitorObj :DCRCompetitorDetailsModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.productAddBut.isHidden = true
        self.valueTxt.delegate = self
        self.probalilityTxt.delegate = self
        self.setDefaults()

        NotificationCenter.default.addObserver(self, selector: #selector(AddDetailedCompetitorProductController.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddDetailedCompetitorProductController.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setDefaults()
    {
        if(isFromUpdate)
        {
            self.productAddBut.isHidden = false
           self.competitorLbl.text = self.dcrDetailedCompetitorObj.Competitor_Name
            self.productLbl.text = self.dcrDetailedCompetitorObj.Product_Name
            self.valueTxt.text = "\(self.dcrDetailedCompetitorObj.Value!)"
            self.probalilityTxt.text = "\(self.dcrDetailedCompetitorObj.Probability!)"
            self.remarkTxt.text = self.dcrDetailedCompetitorObj.Remarks
            
        }
        
    }
    
    
    
    @IBAction func saveDetailCompetitor(_ sender:UIButton)
    {
        self.saveValidation()
    }
    
    func saveValidation()
    {
        var probability = Float()
        var value = Int()
        
         if(self.valueTxt.text == nil || self.valueTxt.text == EMPTY)
        {
            value = 0
            //AlertView.showAlertView(title: alertTitle, message: "Please enter value", viewController: self)
        }
        else
         {
            value = Int(self.valueTxt.text!)!
        }
        if(self.probalilityTxt.text == nil || self.probalilityTxt.text == EMPTY)
        {
            probability = 0.0
           // AlertView.showAlertView(title: alertTitle, message: "Please enter probability", viewController: self)
        }
        else
        {
           probability = (probalilityTxt.text! as NSString).floatValue
        }
        
        
        if(self.competitorLbl.text == "Select Competitor" || self.competitorLbl.text == nil || self.competitorLbl.text == EMPTY)
        {
            AlertView.showAlertView(title: alertTitle, message: "Please select competitor", viewController: self)
        }
        else if(self.productLbl.text == "Select Product" || self.productLbl.text == nil || self.productLbl.text == EMPTY)
        {
            AlertView.showAlertView(title: alertTitle, message: "Please select product", viewController: self)
        }
        else if(value >= 9999999)
        {
           
           AlertView.showAlertView(title: alertTitle, message: "Value should be less than 8 digits", viewController: self)
        }
        else if(probability >= 9999)
        {
            probability = (probalilityTxt.text! as NSString).floatValue
          AlertView.showAlertView(title: alertTitle, message: "Probability value should be less than 5 digits", viewController: self)
        }
        else
        {
            
            if(isFromUpdate)
            {
                let value = valueTxt.text
                let probability = (probalilityTxt.text! as NSString).floatValue
                
                let dict = ["DCR_Doctor_Visit_Code":"","DCR_Doctor_Visit_Id":DCRModel.sharedInstance.doctorVisitId,"DCR_Product_Detail_Id":dcrDetailedCompetitorObj.DCR_Product_Detail_Id,"Sale_Product_Code":dcrDetailedCompetitorObj.DCR_Product_Detail_Code,"DCR_Id":DCRModel.sharedInstance.dcrId,"DCR_Code":DCRModel.sharedInstance.dcrCode,"Competitor_Code":dcrDetailedCompetitorObj.Competitor_Code,"Competitor_Name":dcrDetailedCompetitorObj.Competitor_Name,"Product_Name":dcrDetailedCompetitorObj.Product_Name,"Product_Code":dcrDetailedCompetitorObj.Product_Code,"Value":Int(value!) ?? 0,"Probability":probability,"Remarks":self.remarkTxt.text] as [String : Any]
                
                
                
                let dcrDetailCompetitorObj = DCRCompetitorDetailsModel.init(dict: dict as NSDictionary)
                BL_DetailedProducts.sharedInstance.updateDcrDetailedCompetitor(dcrDetailCompetitorObj: dcrDetailCompetitorObj, competitorDetailId: dcrDetailedCompetitorObj.Competitor_Detail_Id!)
                
                _ = self.navigationController?.popViewController(animated: false)
            }
            else
            {
                let value = valueTxt.text
                let probability = (probalilityTxt.text! as NSString).floatValue
                
                let dict = ["DCR_Doctor_Visit_Code":"","DCR_Doctor_Visit_Id":DCRModel.sharedInstance.doctorVisitId,"DCR_Product_Detail_Id":"","Sale_Product_Code":self.selectedProductObj.Product_Code,"DCR_Id":DCRModel.sharedInstance.dcrId,"DCR_Code":DCRModel.sharedInstance.dcrCode,"Competitor_Code":self.selectedCompetitorObj.Competitor_Code!,"Competitor_Name":self.selectedCompetitorObj.Competitor_Name,"Product_Name":self.selectedCompetitorProductObj.Product_Name,"Product_Code":self.selectedCompetitorProductObj.Product_Code,"Value":Int(value!) ?? 0,"Probability":probability,"Remarks":self.remarkTxt.text] as [String : Any]
                
                BL_DetailedProducts.sharedInstance.insertDcrDetailedCompetitor(dict: dict as NSDictionary)
                _ = self.navigationController?.popViewController(animated: false)
            }
           
        }
    }
    
    
    @IBAction func competitorSelectBut(_ sender: UIButton)
    {
        let sb = UIStoryboard(name: detailProductSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier:CompetitorListViewControllerID ) as! CompetitorListViewController
        vc.isFromProductSelection = false
        vc.delegate = self
        vc.selectedProductObj = selectedProductObj 
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func ProductSelectBut(_ sender: UIButton)
    {
        if(self.competitorLbl.text != "Select Competitor" && self.competitorLbl.text != nil && self.competitorLbl.text != EMPTY)
        {
            let sb = UIStoryboard(name: detailProductSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier:CompetitorListViewControllerID ) as! CompetitorListViewController
            vc.isFromProductSelection = true
            vc.delegate = self
            vc.selectedProductObj = selectedProductObj
            if(isFromUpdate)
            {
                vc.competitorCode =   dcrDetailedCompetitorObj.Competitor_Code
            }
            else
            {
                vc.competitorCode = selectedCompetitorObj.Competitor_Code
            }
            self.navigationController?.pushViewController(vc, animated: false)
        }
        else
        {
           AlertView.showAlertView(title: alertTitle, message: "Please select competitor", viewController: self)
        }
    }
    
    @IBAction func competitorAddBut(_ sender: UIButton)
    {
        let sb = UIStoryboard(name: detailProductSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier:CreateCpmpetitorProductControllerID ) as! CreateCpmpetitorProductController
        vc.isFromProduct = false
//        self.productLbl.text = ""
      //  vc.competitorName = ""
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func ProductAddBut(_ sender: UIButton)
    {
        if(self.competitorLbl.text != "Select Product" && self.competitorLbl.text != nil && self.competitorLbl.text != EMPTY)
        {
            let sb = UIStoryboard(name: detailProductSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier:CreateCpmpetitorProductControllerID ) as! CreateCpmpetitorProductController
            vc.isFromProduct = true
            if(isFromUpdate)
            {
                vc.competitor = self.dcrDetailedCompetitorObj.Competitor_Name
                vc.competitorCode = self.dcrDetailedCompetitorObj.Competitor_Code
            }
            else
            {
                vc.competitor = self.selectedCompetitorObj.Competitor_Name
                vc.competitorCode = self.selectedCompetitorObj.Competitor_Code
                
            }
            //  vc.competitorName = ""
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
    }
    
    func getSelectedCompetitor(selectedCompetitor: CompetitorModel) {
        self.selectedCompetitorObj = selectedCompetitor
        self.productAddBut.isHidden = false
        self.competitorLbl.text = self.selectedCompetitorObj.Competitor_Name
        if(isFromUpdate)
        {
            self.dcrDetailedCompetitorObj.Competitor_Name = self.selectedCompetitorObj.Competitor_Name
            self.dcrDetailedCompetitorObj.Competitor_Code = self.selectedCompetitorObj.Competitor_Code
             self.productLbl.text = ""
        }
    }
    
    func getSelectedCompetitorProduct(selectedCompetitor: ProductModel) {
        self.selectedCompetitorProductObj = selectedCompetitor
        self.productAddBut.isHidden = false
        self.productLbl.text = self.selectedCompetitorProductObj.Product_Name
        if(isFromUpdate)
        {
            self.dcrDetailedCompetitorObj.Product_Name = self.selectedCompetitorProductObj.Product_Name
            self.dcrDetailedCompetitorObj.Product_Code = self.selectedCompetitorProductObj.Product_Code
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    //MARK:- Keyboard Action
    @objc func keyboardWillShow(notification: NSNotification)
    {
        if ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil
        {
            //self.view.frame.origin.y -= keyboardSize.height
            var userInfo = notification.userInfo!
            var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            keyboardFrame = self.view.convert(keyboardFrame, from: nil)
            
            var contentInset:UIEdgeInsets = self.scrollView.contentInset
            contentInset.bottom = keyboardFrame.size.height
            self.scrollView.contentInset = contentInset
            
            //get indexpath
            // let indexpath = IndexPath(row: 1, section: 0)
            //  self.tableView.scrollToRow(at: indexpath, at: UITableViewScrollPosition.top, animated: true)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        let contentInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
  
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        let pointInTable:CGPoint = textView.superview!.convert(textView.frame.origin, to: scrollView)
        var contentOffset:CGPoint = scrollView.contentOffset
        contentOffset.y  = pointInTable.y
        if let accessoryView = textView.inputAccessoryView
        {
            contentOffset.y -= accessoryView.frame.size.height + 100
        }
        scrollView.contentOffset = contentOffset
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        if(string == "-")
//        {
//            if(textField.text?.contains("-"))!
//            {
//                return false
//            }
//        }
        let decimalPlacesLimit = 2
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            return true
        }
        
        let dotArray = textField.text?.components(separatedBy: ".")
        print(textField.tag)
        
        if (dotArray?.count)! > 2
        {
            AlertView.showAlertView(title: alertTitle, message: "Please enter valid quantity", viewController: self)
            return false
            
        }
        else if isValidNumberForPobAmt(string: string)
        {
            if (dotArray?.count)! > 1
            {
                print(string)
                let decimalPart = dotArray![1]
                if (decimalPart.count >= decimalPlacesLimit)
                {
                    return false
                }
            }
            return true
        }
        return false
    }

}
