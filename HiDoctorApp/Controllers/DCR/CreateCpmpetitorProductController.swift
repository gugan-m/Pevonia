//
//  CreateCpmpetitorProductController.swift
//  HiDoctorApp
//
//  Created by Sabari on 19/06/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class CreateCpmpetitorProductController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet weak var competitorName: UITextField!
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var speciality: UITextField!
    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var brand: UITextField!
    @IBOutlet weak var uomname: UITextField!
    @IBOutlet weak var uomType: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var specialityPicker = UIPickerView()
    var categoryPicker = UIPickerView()
    var brandPicker = UIPickerView()
    var uomPicker = UIPickerView()
    var uomTypePicker = UIPickerView()
    var selectedIndex = Int()
    var isFromProduct :Bool!
    var specialityCode = String()
    var categoryCode = String()
    var brandCode = String()
    var uomCode = String()
    var uomTypeCode = String()
    var competitor = String()
    var competitorCode = Int()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if(isFromProduct)
        {
           self.competitorName.text = competitor
            self.competitorName.isUserInteractionEnabled = false
        }
        else
        {
           self.competitorName.isUserInteractionEnabled = true
        }
        self.getAllSpeciality()
        self.setDefaults()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setDefaults()
    {
        specialityPicker.delegate = self
        specialityPicker.dataSource = self
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        brandPicker.delegate = self
        brandPicker.dataSource = self
        uomPicker.delegate = self
        uomPicker.dataSource = self
        uomTypePicker.delegate = self
        uomTypePicker.dataSource = self
        
        speciality.inputView = specialityPicker
        category.inputView = categoryPicker
        brand.inputView = brandPicker
        uomname.inputView = uomPicker
        uomType.inputView = uomTypePicker
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateCpmpetitorProductController.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateCpmpetitorProductController.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.hideKeyboardWhenTappedAround()
    
    }
    
    func getAllSpeciality()
    {
        if(checkInternetConnectivity())
        {
            showCustomActivityIndicatorView(loadingText: "Loading Data...")
            
            WebServiceHelper.sharedInstance.getAllSpeciality { (apiObj) in
                if(apiObj.Status == SERVER_SUCCESS_CODE)
                {
                    BL_CompetitorProducts.sharedInstance.specialityArray = NSMutableArray()
                    let dict : NSDictionary = [ "Speciality_Code":"0","Speciality_Name" : "Select Position"]
                    BL_CompetitorProducts.sharedInstance.specialityArray.add(dict)
                    let specialityListValue = apiObj.list!
                    for specialityValue in specialityListValue
                    {
                        BL_CompetitorProducts.sharedInstance.specialityArray.add(specialityValue)
                    }
                    
                    WebServiceHelper.sharedInstance.getAllCategory(completion: { (apiObj) in
                        if(apiObj.Status == SERVER_SUCCESS_CODE)
                        {
                            BL_CompetitorProducts.sharedInstance.categoryArray = NSMutableArray()
                            let dict : NSDictionary = [ "Category_Code":"0","Category_Name" : "Select Category","Category_Status":0]
                            BL_CompetitorProducts.sharedInstance.categoryArray.add(dict)
                            let categoryListValue = apiObj.list!
                            for categoryValue in categoryListValue
                            {
                                BL_CompetitorProducts.sharedInstance.categoryArray.add(categoryValue)
                            }
                            WebServiceHelper.sharedInstance.getAllBrand(completion: { (apiObj) in
                                if(apiObj.Status == SERVER_SUCCESS_CODE)
                                {
                                    BL_CompetitorProducts.sharedInstance.brandArray = NSMutableArray()
                                    let dict : NSDictionary = [ "Brand_Code":"0","Brand_Name" : "Select Brand","Brand_Status":0]
                                    BL_CompetitorProducts.sharedInstance.brandArray.add(dict)
                                    let brandListValue = apiObj.list!
                                    for brandValue in brandListValue
                                    {
                                        BL_CompetitorProducts.sharedInstance.brandArray.add(brandValue)
                                    }
                                    WebServiceHelper.sharedInstance.getAllUOM(completion: { (apiObj) in
                                        if(apiObj.Status == SERVER_SUCCESS_CODE)
                                        {
                                            BL_CompetitorProducts.sharedInstance.uomArray = NSMutableArray()
                                            let dict : NSDictionary = [ "UOM_Code":"0","UOM_Name" : "Select UOM","UOM_Status":0]
                                            BL_CompetitorProducts.sharedInstance.uomArray.add(dict)
                                            let uomListValue = apiObj.list!
                                            for uomValue in uomListValue
                                            {
                                                BL_CompetitorProducts.sharedInstance.uomArray.add(uomValue)
                                            }
                                            WebServiceHelper.sharedInstance.getAllUOMType(completion: { (apiObj) in
                                                if(apiObj.Status == SERVER_SUCCESS_CODE)
                                                {
                                                    BL_CompetitorProducts.sharedInstance.uomTypeArray = NSMutableArray()
                                                    let dict : NSDictionary = [ "UOM_Type_Code":"0","UOM_Type_Name" : "Select UOM Type","UOM_Type_Status":0]
                                                    BL_CompetitorProducts.sharedInstance.uomTypeArray.add(dict)
                                                    let uomTypeListValue = apiObj.list!
                                                    for uomTypeValue in uomTypeListValue
                                                    {
                                                        BL_CompetitorProducts.sharedInstance.uomTypeArray.add(uomTypeValue)
                                                    }
                                                    removeCustomActivityView()
                                                }
                                                else
                                                {
                                                    removeCustomActivityView()
                                                    self.showAlert()
                                                }
                                            })
                                        }
                                        else
                                        {
                                            removeCustomActivityView()
                                            self.showAlert()
                                        }
                                    })
                                }
                                else
                                {
                                    removeCustomActivityView()
                                    self.showAlert()
                                }
                            })
                        }
                        else
                        {
                            removeCustomActivityView()
                            self.showAlert()
                        }
                    })
                }
                else
                {
                    removeCustomActivityView()
                    self.showAlert()
                }
            }
            
        }
        else
        {
            AlertView.showAlertView(title: internetOfflineTitle, message: internetOfflineMessage, viewController: self)
        }
        
    }
    
    func showAlert()
    {
        // Create the alert controller
        let alertController = UIAlertController(title: errorTitle, message: "Problem while connecting to server", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            _ = self.navigationController?.popViewController(animated: false)
        }
 
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if(pickerView == self.specialityPicker)
        {
            return BL_CompetitorProducts.sharedInstance.specialityArray.count
        }
        else if(pickerView == self.categoryPicker)
        {
            return BL_CompetitorProducts.sharedInstance.categoryArray.count
        }
        else if(pickerView == self.brandPicker)
        {
            return BL_CompetitorProducts.sharedInstance.brandArray.count
        }
        else if(pickerView == self.uomPicker)
        {
            return BL_CompetitorProducts.sharedInstance.uomArray.count
        }
        else if(pickerView == self.uomTypePicker)
        {
            return BL_CompetitorProducts.sharedInstance.uomTypeArray.count
        }
        else
        {
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if(pickerView == self.specialityPicker)
        {
            let name = BL_CompetitorProducts.sharedInstance.specialityArray.value(forKey: "Speciality_Name") as! NSArray
            return name[row] as? String
        }
        else if(pickerView == self.categoryPicker)
        {
            let name = BL_CompetitorProducts.sharedInstance.categoryArray.value(forKey: "Category_Name") as! NSArray
            return name[row] as? String
        }
        else if(pickerView == self.brandPicker)
        {
            let name = BL_CompetitorProducts.sharedInstance.brandArray.value(forKey: "Brand_Name") as! NSArray
            return name[row] as? String
        }
        else if(pickerView == self.uomPicker)
        {
            let name = BL_CompetitorProducts.sharedInstance.uomArray.value(forKey: "UOM_Name") as! NSArray
            return name[row] as? String
        }
            
        else if(pickerView == self.uomTypePicker)
        {
            let name = BL_CompetitorProducts.sharedInstance.uomTypeArray.value(forKey: "UOM_Type_Name") as! NSArray
            return name[row] as? String
        }
        else
        {
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if(pickerView == self.specialityPicker)
        {
            let name = BL_CompetitorProducts.sharedInstance.specialityArray.value(forKey: "Speciality_Name") as! NSArray
            let code = BL_CompetitorProducts.sharedInstance.specialityArray.value(forKey: "Speciality_Code") as! NSArray
            self.speciality.text = name[row] as? String
            self.specialityCode = (code[row] as? String)!
        }
        else if(pickerView == self.categoryPicker)
        {
            let name = BL_CompetitorProducts.sharedInstance.categoryArray.value(forKey: "Category_Name") as! NSArray
            let code = BL_CompetitorProducts.sharedInstance.categoryArray.value(forKey: "Category_Code") as! NSArray
           self.category.text = name[row] as? String
            self.categoryCode = (code[row] as? String)!
        }
        else if(pickerView == self.brandPicker)
        {
            let name = BL_CompetitorProducts.sharedInstance.brandArray.value(forKey: "Brand_Name") as! NSArray
            let code = BL_CompetitorProducts.sharedInstance.brandArray.value(forKey: "Brand_Code") as! NSArray
            self.brand.text = name[row] as? String
            self.brandCode = (code[row] as? String)!
        }
        else if(pickerView == self.uomPicker)
        {
            let name = BL_CompetitorProducts.sharedInstance.uomArray.value(forKey: "UOM_Name") as! NSArray
            let code = BL_CompetitorProducts.sharedInstance.uomArray.value(forKey: "UOM_Code") as! NSArray
            self.uomname.text = name[row] as? String
            self.uomCode = (code[row] as? String)!
        }
            
        else if(pickerView == self.uomTypePicker)
        {
            let name = BL_CompetitorProducts.sharedInstance.uomTypeArray.value(forKey: "UOM_Type_Name") as! NSArray
            let code = BL_CompetitorProducts.sharedInstance.uomTypeArray.value(forKey: "UOM_Type_Code") as! NSArray
            self.uomType.text = name[row] as? String
            self.uomTypeCode = (code[row] as? String)!
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
    
    @IBAction func saveBut(_ sender: UIButton)
    {
        self.validation()
    }
    
    func validation()
    {
        if(self.competitorName.text == EMPTY)
        {
            AlertView.showAlertView(title: alertTitle, message: "Please enter Competitor Name", viewController: self)
        }
        else if(self.productName.text == EMPTY)
        {
            AlertView.showAlertView(title: alertTitle, message: "Please enter Product Name", viewController: self)
        }
        else if(self.speciality.text == EMPTY || self.speciality.text == "Select Position")
        {
            AlertView.showAlertView(title: alertTitle, message: "Please select position", viewController: self)
        }
        else if(self.category.text == EMPTY || self.category.text == "Select Category")
        {
            AlertView.showAlertView(title: alertTitle, message: "Please select category", viewController: self)
        }
        else if(self.brand.text == EMPTY || self.brand.text == "Select Brand")
        {
            AlertView.showAlertView(title: alertTitle, message: "Please select brand", viewController: self)
        }
        else if(self.uomname.text == EMPTY || self.uomname.text == "Select UOM")
        {
            AlertView.showAlertView(title: alertTitle, message: "Please select UOM", viewController: self)
        }
        else if(self.uomType.text == EMPTY || self.uomType.text == "Select UOM Type")
        {
            AlertView.showAlertView(title: alertTitle, message: "Please select UOM Type", viewController: self)
        }
        else
        {
            
            let postData = ["Competitor_Name":self.competitorName.text!,"Competitor_Code":competitorCode,"Product_Name":self.productName.text!,"Product_Group_Code":"","Speciality_Code":specialityCode,"Brand_Code":brandCode,"Category_Code":categoryCode,"UOM_Type":"","UOM":"","UOM_Code":uomCode,"UOM_Type_Code":uomTypeCode] as [String : Any]
            if(checkInternetConnectivity())
            {
                showCustomActivityIndicatorView(loadingText: "Loading...")
                WebServiceHelper.sharedInstance.newProductAndCompetitor(postData: postData) { (apiObj) in
                    if(apiObj.Status == SERVER_SUCCESS_CODE)
                    {
                        BL_MasterDataDownload.sharedInstance.downloadProductData(masterDataGroupName: EMPTY, completion: { (status) in
                            
                            removeCustomActivityView()
                             showToastView(toastText: "Competitor Product created successfully")
                            _ = self.navigationController?.popViewController(animated: false)
                        })
                       
                    }
                    else
                    {
                        BL_MasterDataDownload.sharedInstance.downloadProductData(masterDataGroupName: EMPTY, completion: { (status) in
                            removeCustomActivityView()
                            AlertView.showAlertView(title: errorTitle, message: apiObj.Message, viewController: self)
                        })
                    }
                }
            }
            else
            {
                AlertView.showAlertView(title: internetOfflineTitle, message: internetOfflineMessage, viewController: self)
            }
            
        }
    }
    
}
