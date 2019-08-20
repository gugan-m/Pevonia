//
//  DetailedProductViewController.swift
//  HiDoctorApp
//
//  Created by Vignaya on 11/28/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class DetailedProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,UITextFieldDelegate,UITextViewDelegate,BusinessStatusSelectDelegate
{
    func seletCampaign(indexpath: IndexPath?, campaignObj: MCHeaderModel) {
        
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView : UIView!
    @IBOutlet weak var emptyStateView : UIView!
    
    var isComingFromModifyPage : Bool = false
    //var detailedList : [DetailProductMaster] = []
    var detailedList : [DetailProductMasterSectionModel] = []
    //var currentList : [DetailProductMaster] = []
    var currentList : [DetailProductMasterSectionModel] = []
    //var searchList : [DetailProductMaster] = []
    var searchList : [DetailProductMasterSectionModel] = []
    var customerModel: CustomerMasterModel?
    var userSelectedProduct : [String] = []
    var selectedList : NSMutableArray = []
    var selectedTitle : String = "0"
    var saveBtn : UIBarButtonItem!
    var isComingFromChemistRCPA : Bool = false
    var isComingFromModifyRCPAPage : Bool = false
    var chemistVisitId : Int!
    var isFromPOB: Bool = false
    var isFromChemistDay: Bool = false
    var isFromRCPA: Bool = false
    var orderEntryId: Int?
    var isFromDoctor: Bool = false //to show status and remarks
    //    var customerCode: String!
    //    var regionCode: String!
    var lstBusinessStatus: [BusinessStatusModel] = []
    var isFromBusinessStatusDelegage: Bool = false
    var isDetailCompetitorAvailable: Bool = false
    var objBusinessStatus: BusinessStatusModel?
    var obj2: BussinessPotential?
    var obj1: BussinessPotential?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        addBackButtonView()
        self.addBarButtonItem()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        NotificationCenter.default.addObserver(self, selector: #selector(DetailedProductViewController.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(DetailedProductViewController.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.hideKeyboardWhenTappedAround()
        self.getDetailedList()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        //self.getDetailedList()
        if (!isFromBusinessStatusDelegage)
        {
            if isFromPOB != true
            {
                self.getDCRSelectedList()
            }
            else
            {
                self.getPOBSelectedList()
            }
            self.navigationItem.rightBarButtonItem = nil
        }
        
        isFromBusinessStatusDelegage = false
        
        self.isDetailCompetitorAvailable = BL_DetailedProducts.sharedInstance.isDetailedCompetitorPrivilegeEnabled()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return currentList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let productList = currentList[section].lstDetailedProducs
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let obj = currentList[section]
        
        if (obj.Section_Title != EMPTY)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! DoctorListSectionTableViewCell
            cell.sectionNameLbl.text = obj.Section_Title
            
            return cell
        }
        else
        {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        let obj = currentList[section]
        
        if (obj.Section_Title != EMPTY)
        {
            if (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.SHOW_DETAILED_PRODUCTS_WITH_TAGS) == PrivilegeValues.YES.rawValue)
            {
                return 25
            }
            else
            {
                return 0
            }
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let defaultHeight : CGFloat = 35
        let sampleObj = currentList[indexPath.section].lstDetailedProducs[indexPath.row]  //currentList[indexPath.row]
        let nameLblHgt = getTextSize(text: sampleObj.Product_Name, fontName: fontSemiBold, fontSize: 14, constrainedWidth: SCREEN_WIDTH - 76).height
        var commonHeight = defaultHeight + nameLblHgt
        if(isFromDoctor)
        {
            if selectedList.contains(sampleObj)
            {
                if (canShowBusinessStatus(indexPath: indexPath))
                {
                    commonHeight += 205
                    
                    //return commonHeight
                }
                else
                {
                    commonHeight += 162
                    //return commonHeight
                }
                if(self.isDetailCompetitorAvailable)
                {
                    commonHeight += 48
                    return commonHeight
                }
                else
                {
                    return commonHeight
                }
            }
            else
            {
                return commonHeight
            }
        }
        else
        {
            return commonHeight
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let detailProductCell = tableView.dequeueReusableCell(withIdentifier: detailProductListCell, for: indexPath) as! DetailedProductsTableViewCell
        let detailObj = currentList[indexPath.section].lstDetailedProducs[indexPath.row]  //currentList[indexPath.row]
        let productName = detailObj.Product_Name as String
        detailProductCell.DetailProductNameLbl.text = productName
        detailProductCell.remarkViewHegConst.constant = 0
        detailProductCell.statusViewHegConst.constant = 0
        detailProductCell.textfieldViewHegConst.constant = 0
        detailProductCell.bottomViewHeight.constant = 0
        detailProductCell.businessPotentialTxtFld.isHidden = true
        
        if isFromRCPA
        {
            if userSelectedProduct.contains(detailObj.Product_Code) && !isComingFromModifyPage
            {
                detailProductCell.contentView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
                detailProductCell.DetailProductNameImg.image = UIImage(named: "icon-selected")
                // addd
               
            }
            else if selectedList.contains(detailObj)
            {
                detailProductCell.DetailProductNameImg.image = UIImage(named: "icon-tick")
            }
            else
            {
                detailProductCell.DetailProductNameImg.image = UIImage(named: "icon-unselected")
                detailProductCell.contentView.backgroundColor = UIColor.white
            }
            
            detailProductCell.selectedImgConst.constant = 0
        }
        else if isFromDoctor
        {
            detailProductCell.remarkTextView.addHideinputAccessoryView()
            detailProductCell.businessPotentialTxtFld.addHideinputAccessoryView()
            //detailProductCell.selectedImgConst.constant = 25
            detailProductCell.businessPotentialTxtFld.tag = indexPath.section * 1000 + indexPath.row
            detailProductCell.remarkTextView.tag = indexPath.section * 1000 + indexPath.row
            detailProductCell.statusBut.tag = indexPath.section * 1000 + indexPath.row
            detailProductCell.businessPotentialTxtFld.delegate = self
            detailProductCell.remarkTextView.delegate = self
            detailProductCell.statusBut.addTarget(self, action: #selector(self.statucButtonClicked(sender:)), for: .touchUpInside)
            detailProductCell.statusLabel.text = defaultBusinessStatusName
            
            if userSelectedProduct.contains(detailObj.Product_Code) && !isComingFromModifyPage
            {
                //detailProductCell.contentView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
                detailProductCell.DetailProductNameImg.image = UIImage(named: "icon-selected")
            }
            else if selectedList.contains(detailObj)
            {
                detailProductCell.bottomViewHeight.constant = 250
                if (canShowBusinessStatus(indexPath: indexPath))
                {//hits on tick
                    detailProductCell.statusViewHegConst.constant = 35
                    detailProductCell.statusLabel.text = defaultBusinessStatusName
                    
                    
                    if (detailObj.objWrapper.objBusinessStatus != nil)
                    {
                        detailProductCell.statusLabel.text = detailObj.objWrapper.objBusinessStatus!.Status_Name!
                        
                        if (detailProductCell.statusLabel.text == "" ){
                            detailProductCell.statusLabel.text = defaultBusinessStatusName
                        }else{
                            detailProductCell.statusLabel.text = detailObj.objWrapper.objBusinessStatus!.Status_Name!
                        }
                        
                    }
                    else
                    {// hits on tick
                        self.obj2 = DBHelper.sharedInstance.getbusinessstatuspotential(customercode: DCRModel.sharedInstance.customerCode, productcode: detailObj.Product_Code, regionCode: DCRModel.sharedInstance.customerRegionCode, entity_type: 2)
                        if (self.obj2 != nil)
                        {
                            detailProductCell.statusLabel.text = self.obj2?.Business_Status_Name
                            detailObj.objWrapper.objBusinessStatus?.Status_Name = (self.obj2?.Business_Status_Name)!
                            //let value: String = obj2?.Business_Potential as String
                            let myStringToTwoDecimals = String(format:"%.2f", (self.obj2?.Business_Potential)!)
                            detailProductCell.businessPotentialTxtFld.text  = myStringToTwoDecimals
                            // objBusinessStatus?.Status_Name = obj2?.Business_Status_Name
                            detailObj.objWrapper.businessPotential = myStringToTwoDecimals
                            detailObj.objWrapper.objBusinessStatus?.Business_Status_ID = self.obj2?.Business_Status_Id
                            detailObj.objWrapper.objBusinessStatus?.Status_Name = self.obj2?.Business_Status_Name
                            var objb: BusinessStatusModel = createBusinessStatusObj(id: (self.obj2?.Business_Status_Id)!, name: (self.obj2?.Business_Status_Name)!)

                            self.setdata(indexPath: indexPath, selectedStatus: objb, isCallObjective: true)
                        }else{
                            
                            self.obj1 = DBHelper.sharedInstance.getbusinessstatuspotential(customercode: DCRModel.sharedInstance.customerCode, productcode: detailObj.Product_Code, regionCode: DCRModel.sharedInstance.customerRegionCode, entity_type: 0)
                            if (self.obj1 != nil)
                            {
                                
                             //   detailProductCell.statusLabel.text = self.obj1?.Business_Status_Name
                                detailObj.objWrapper.objBusinessStatus?.Status_Name = (self.obj1?.Business_Status_Name)!
                                //let value: String = obj2?.Business_Potential as String
                                let myStringToTwoDecimals = String(format:"%.2f", (self.obj1?.Business_Potential)!)
                                detailProductCell.businessPotentialTxtFld.text  = myStringToTwoDecimals
                                // objBusinessStatus?.Status_Name = obj2?.Business_Status_Name
                                detailObj.objWrapper.businessPotential = myStringToTwoDecimals
                                detailObj.objWrapper.objBusinessStatus?.Business_Status_ID = self.obj1?.Business_Status_Id
                                detailObj.objWrapper.objBusinessStatus?.Status_Name = self.obj1?.Business_Status_Name
                                
                                var objb: BusinessStatusModel = createBusinessStatusObj(id: (self.obj1?.Business_Status_Id)!, name: (self.obj1?.Business_Status_Name)!)

                                self.setdata(indexPath: indexPath, selectedStatus: objb, isCallObjective: true)
                            }
                        }
//                        UserDefaults.standard.set("1", forKey: "CheckPotential")
//                        UserDefaults.standard.synchronize()
                    }
                }
                else
                {
                    self.obj2 = DBHelper.sharedInstance.getbusinessstatuspotential1(customercode: DCRModel.sharedInstance.customerCode, productcode: detailObj.Product_Code, regionCode: DCRModel.sharedInstance.customerRegionCode, entity_type: 0)
                    if (self.obj2 != nil)
                    {
                        //let value: String = obj2?.Business_Potential as String
                        let myStringToTwoDecimals = String(format:"%.2f", (self.obj2?.Business_Potential)!)
                        detailProductCell.businessPotentialTxtFld.text  = myStringToTwoDecimals
                        // objBusinessStatus?.Status_Name = obj2?.Business_Status_Name
                        // detailObj.objWrapper.objBusinessStatus!.Status_Name! = (obj2?.Business_Status_Name)!
                        detailObj.objWrapper.businessPotential = myStringToTwoDecimals
                        
//                        currentList[indexPath.section].lstDetailedProducs[indexPath.row].objWrapper.objBusinessStatus?.Status_Name = obj2?.Business_Status_Name
//                        currentList[indexPath.section].lstDetailedProducs[indexPath.row].objWrapper.objBusinessStatus?.Business_Status_ID = obj2?.Business_Status_Id

                    }
                    
                    if (detailObj.objWrapper.objBusinessStatus != nil)
                    {
                        detailProductCell.statusLabel.text = detailObj.objWrapper.objBusinessStatus!.Status_Name!
                    }
//                    UserDefaults.standard.set("0", forKey: "CheckPotential")
//                    UserDefaults.standard.synchronize()
                    detailProductCell.bottomViewHeight.constant = detailProductCell.bottomViewHeight.constant - 45
                }
                if (self.isDetailCompetitorAvailable)
                {
                    detailProductCell.competitorButHegConst.constant = 30
                    detailProductCell.competitorBut.isHidden = false
                    detailProductCell.competitorBut.layer.cornerRadius = 5
                    detailProductCell.competitorBut.layer.masksToBounds = true
                    detailProductCell.competitorBut.addTarget(self, action: #selector(self.navigateToCompetitorProductDetail), for: UIControlEvents.touchUpInside)
                }
                else
                {
                    detailProductCell.competitorButHegConst.constant = 0
                    detailProductCell.bottomViewHeight.constant = detailProductCell.bottomViewHeight.constant - 38
                    detailProductCell.competitorBut.isHidden = true
                }
                
                
                detailProductCell.textfieldViewHegConst.constant = 35
                detailProductCell.businessPotentialTxtFld.isHidden = false
                detailProductCell.remarkViewHegConst.constant = 90
                detailProductCell.DetailProductNameImg.image = UIImage(named: "icon-tick")
            }
            else
            {
                detailProductCell.DetailProductNameImg.image = UIImage(named: "icon-unselected")
            }
            
            detailProductCell.businessPotentialTxtFld.text = EMPTY
            
            if (detailObj.objWrapper.businessPotential != defaultBusinessPotential && detailObj.objWrapper.businessPotential != "-1")
            {
                detailProductCell.businessPotentialTxtFld.text = detailObj.objWrapper.businessPotential
            }
            
            detailProductCell.remarkTextView.text = detailObj.objWrapper.remarks
            
            //  obj2 = DBHelper.sharedInstance.getbusinessstatuspotential(customercode: DCRModel.sharedInstance.customerCode, productcode: detailObj.Product_Code, regionCode: DCRModel.sharedInstance.customerRegionCode, entity_type: 2)
//            if (obj2 != nil)
//            {
//                detailProductCell.statusLabel.text = obj2?.Business_Status_Name
//                //let value: String = obj2?.Business_Potential as String
//                let myStringToTwoDecimals = String(format:"%.2f", (obj2?.Business_Potential)!)
//
//                detailProductCell.businessPotentialTxtFld.text  = myStringToTwoDecimals
//                // objBusinessStatus?.Status_Name = obj2?.Business_Status_Name
//             //   detailObj.objWrapper.objBusinessStatus!.Status_Name! = (obj2?.Business_Status_Name)!
//                detailObj.objWrapper.businessPotential = myStringToTwoDecimals
//                currentList[indexPath.section].lstDetailedProducs[indexPath.row].objWrapper.objBusinessStatus?.Status_Name = obj2?.Business_Status_Name
//                currentList[indexPath.section].lstDetailedProducs[indexPath.row].objWrapper.objBusinessStatus?.Business_Status_ID = obj2?.Business_Status_Id
//
//            }
            
        }
        else if !isComingFromChemistRCPA
        {
            detailProductCell.selectedImgConst.constant = 25
            if userSelectedProduct.contains(detailObj.Product_Code) && !isComingFromModifyPage
            {
                detailProductCell.contentView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
                detailProductCell.DetailProductNameImg.image = UIImage(named: "icon-selected")
//
            }
            else if selectedList.contains(detailObj)
            {
                detailProductCell.DetailProductNameImg.image = UIImage(named: "icon-tick")
            }
            else
            {
                detailProductCell.DetailProductNameImg.image = UIImage(named: "icon-unselected")
                detailProductCell.contentView.backgroundColor = UIColor.white
            }
        }
        else
        {
            detailProductCell.selectedImgConst.constant = 0
        }
        
        return detailProductCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let detailObj = currentList[indexPath.section].lstDetailedProducs[indexPath.row]  //currentList[indexPath.row]
        
        if isFromPOB == true
        {
            if !userSelectedProduct.contains(detailObj.Product_Code)
            {
                if selectedList.contains(detailObj)
                {
                    selectedList.remove(detailObj)
                    selectedTitle = String(Int(selectedTitle)! - 1)
                }
                else
                {  // self.obj2 =
                    self.selectedList.add(detailObj)
                    
                    selectedTitle = String(Int(selectedTitle)! + 1)
                }
                
                if selectedTitle != "0"{
                    self.navigationItem.rightBarButtonItem = self.saveBtn
                }
                else if isComingFromModifyPage
                {
                    self.navigationItem.rightBarButtonItem = self.saveBtn
                }
                setNavigationTitle(Num : selectedTitle)
                self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
            }
        }
        else
        {
            if !isComingFromChemistRCPA && !isFromRCPA
            {
                if !userSelectedProduct.contains(detailObj.Product_Code)
                {
                    if selectedList.contains(detailObj)
                    {
                        selectedList.remove(detailObj)
                        selectedTitle = String(Int(selectedTitle)! - 1)
                    }
                    else
                    {
                        self.selectedList.add(detailObj)
                        //hits on tick
                        selectedTitle = String(Int(selectedTitle)! + 1)
                    }
                    
                    if selectedTitle != "0"{
                        self.navigationItem.rightBarButtonItem = self.saveBtn
                    }
                    else if isComingFromModifyPage
                    {
                        self.navigationItem.rightBarButtonItem = self.saveBtn
                    }
                    setNavigationTitle(Num : selectedTitle)
                    //self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                    self.tableView.reloadData()
                }
            }
            else
            {
                if isFromRCPA
                {
                    if !userSelectedProduct.contains(detailObj.Product_Code) && !isComingFromModifyPage
                    {
                        let sb = UIStoryboard(name: chemistsSb, bundle: nil)
                        let vc = sb.instantiateViewController(withIdentifier:AddChemsistRCPAVcID ) as!
                        AddChemistRCPAViewController
                        vc.selectedProductObj = detailObj
                        vc.doctorObj = customerModel
                        vc.isFromChemistDayRCPA = true
                        
                        if let navigationController = self.navigationController
                        {
                            navigationController.popViewController(animated: false)
                            navigationController.pushViewController(vc, animated: false)
                        }
                    }
                }
                else
                {
                    let sb = UIStoryboard(name: chemistsSb, bundle: nil)
                    let vc = sb.instantiateViewController(withIdentifier:AddChemsistRCPAVcID ) as!
                    AddChemistRCPAViewController
                    vc.selectedProductObj = detailObj
                    vc.isComingFromModifyRCPA = isComingFromModifyRCPAPage
                    vc.chemistVisitId = chemistVisitId
                    if let navigationController = self.navigationController
                    {
                        navigationController.popViewController(animated: false)
                        navigationController.pushViewController(vc, animated: false)
                    }
                }
            }
        }
    }
    
    @objc func navigateToCompetitorProductDetail(_ sender: UIButton)
    {
        let getPosition = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: getPosition)
        if(isComingFromModifyPage)
        {
            let detailObj = currentList[(indexPath?.section)!].lstDetailedProducs[(indexPath?.row)!]
            let sb = UIStoryboard(name: detailProductSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier:CompetitorProductDetailViewControllerID ) as! CompetitorProductDetailViewController
            vc.selectedProductObj = detailObj
            self.navigationController?.pushViewController(vc, animated: false)
        }
        else
        {
            self.insertDetailAddCompetitor(indexPath: indexPath!)
        }
        
    }
    
    @objc func saveBtnAction()
    {
        if isFromPOB != true
        {
            if isFromChemistDay
            {
                let selectedProductList = convertToDetailMaster(list: selectedList)
                
                if isComingFromModifyPage
                {
                    BL_DetailedProducts.sharedInstance.updateChemistDetailedProducts(detailedProductList : selectedProductList, chemistVisitId: ChemistDay.sharedInstance.chemistVisitId)
                }
                else
                {
                    let dcrChemistDetail = BL_DetailedProducts.sharedInstance.convertToDCRChemistDetailedProducts(selectedList: selectedProductList)
                    DBHelper.sharedInstance.insertDCRDoctorVisitChemistDetailedProductDetails(array: dcrChemistDetail as NSArray)
                }
                _ = navigationController?.popViewController(animated: false)
            }
            else
            {
                let selectedProductList = convertToDetailMaster(list: selectedList)
                
                for objProduct in selectedProductList
                {
//                    obj2 = DBHelper.sharedInstance.getbusinessstatuspotential(customercode: DCRModel.sharedInstance.customerCode, productcode: objProduct.Product_Code, regionCode: DCRModel.sharedInstance.customerRegionCode, entity_type: 2)
                   
                    if (objProduct.objWrapper.businessPotential != EMPTY)
                    {
                        if(!isValidDecimalValue(value: objProduct.objWrapper.businessPotential))
                        {
                            AlertView.showAlertView(title: errorTitle, message: "Please enter valid business potential for the product \(objProduct.Product_Name!)", viewController: self)
                            return
                        }
                        // if businessPotentialTxtFld.text == "" || statusLabel.text == "" {
                        // either textfield 1 or 2's text is empty
                        // }
                        let potenital = Double(objProduct.objWrapper.businessPotential)!
                        
                        if (potenital < Double(0.0) && potenital != Double(defaultBusinessPotential))
                        {
                            AlertView.showAlertView(title: errorTitle, message: "Business potential can not have negative values for the product \(objProduct.Product_Name!)", viewController: self)
                            return
                        }
                    }
                    
                    if (objProduct.objWrapper.remarks != EMPTY)
                    {
                        let restrictedCharacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
                        
                        if (checkIfSpecialCharacterFound(restrictedCharacter: restrictedCharacter, remarkTxt: objProduct.objWrapper.remarks))
                        {
                            AlertView.showSpecialCharacterAlertview(title: errorTitle, subject: "Potential remarks of \(objProduct.Product_Name!)", restrictedVal: restrictedCharacter, viewController: self)
                            return
                        }
                        
                        if (objProduct.objWrapper.remarks.count > 100)
                        {
                            AlertView.showAlertView(title: errorTitle, message: "Potential remarks can not exceed 100 characters for the product \(objProduct.Product_Name!)", viewController: self)
                            return
                        }
                    }
                    
                    
                    
                   
                    
//                    let strCheck = UserDefaults.standard.string(forKey: "CheckPotential")
//
//                    if (strCheck == "1"){
//
//                        if (objProduct.objWrapper.businessPotential != EMPTY && objProduct.objWrapper.objBusinessStatus?.Business_Status_ID == nil)
//                        {
//                            AlertView.showAlertView(title: alertTitle, message: "Please Select a Valid Business Status for the product \(objProduct.Product_Name!)", viewController: self)
//                            return
//                        }
//
//                        if (objProduct.objWrapper.objBusinessStatus?.Business_Status_ID != nil && objProduct.objWrapper.businessPotential == EMPTY)
//                        {
//                            // objProduct.objWrapper.businessPotential = "0.0"
//                            AlertView.showAlertView(title: alertTitle, message: "Please Select a Valid Business Potential for the product \(objProduct.Product_Name!)", viewController: self)
//                            return
//                        }
//
//
//                    if isComingFromModifyPage
//                    {
//
//
//                        if (objProduct.objWrapper.businessPotential != EMPTY && objProduct.objWrapper.objBusinessStatus?.Business_Status_ID == nil)
//                        {
//                            AlertView.showAlertView(title: alertTitle, message: "Please Select a Valid Business Status for the product \(objProduct.Product_Name!)", viewController: self)
//                            return
//                        }
//
//                        if (objProduct.objWrapper.objBusinessStatus?.Business_Status_ID != nil && objProduct.objWrapper.businessPotential == EMPTY)
//                        {
//                            // objProduct.objWrapper.businessPotential = "0.0"
//                            AlertView.showAlertView(title: alertTitle, message: "Please Select a Valid Business Potential for the product \(objProduct.Product_Name!)", viewController: self)
//                            return
//                        }
//
//                    }
//
//                }
//                else
//                    {
//
//
//                    }
                    
                }
                
                if isComingFromModifyPage
                {
                    BL_DetailedProducts.sharedInstance.updateDetailedProducts(detailedProductList: selectedProductList, doctorVisitId: DCRModel.sharedInstance.doctorVisitId)
                }
                else
                {
                    
                    
                    BL_DetailedProducts.sharedInstance.insertDetailedProducts(detailedProductList:selectedProductList, doctorVisitId: DCRModel.sharedInstance.doctorVisitId)
                }
                _ = navigationController?.popViewController(animated: false)
            }
        }
            
        else
        {
            let sb = UIStoryboard(name: Constants.StoaryBoardNames.POBSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier:Constants.ViewControllerNames.POBSalesProductVcID ) as!
            POBSalesProductViewController
            let list = convertToDetailMaster(list: selectedList)
            vc.salesProductList = BL_DetailedProducts.sharedInstance.convertToPOBSales(list: list)
            if let navigationController = self.navigationController
            {
                navigationController.popViewController(animated: false)
                navigationController.pushViewController(vc, animated: false)
            }
            
        }
        
        //        BL_DCR_Doctor_Visit.sharedInstance.insertDoctorVisitTracker(modifiedEntity: Constants.DoctorVisitTrackerEntityIDs.Detailed_Product_Modified)
        
        
    }
    //inserdetail product when addCompetitor
    func insertDetailAddCompetitor(indexPath: IndexPath)
    {
        let selectedProductList = convertToDetailMaster(list: selectedList)
        
        for objProduct in selectedProductList
        {
            if (objProduct.objWrapper.businessPotential != EMPTY)
            {
                if(!isValidDecimalValue(value: objProduct.objWrapper.businessPotential))
                {
                    AlertView.showAlertView(title: errorTitle, message: "Please enter valid business potential for the product \(objProduct.Product_Name!)", viewController: self)
                    return
                }
                
                let potenital = Double(objProduct.objWrapper.businessPotential)!
                
                if (potenital < Double(0.0) && potenital != Double(defaultBusinessPotential))
                {
                    AlertView.showAlertView(title: errorTitle, message: "Business potential can not have negative values for the product \(objProduct.Product_Name!)", viewController: self)
                    return
                }
            }
            
            if (objProduct.objWrapper.remarks != EMPTY)
            {
                let restrictedCharacter = BL_Expense.sharedInstance.checkToValidateSpecialCharacter()
                
                if (checkIfSpecialCharacterFound(restrictedCharacter: restrictedCharacter, remarkTxt: objProduct.objWrapper.remarks))
                {
                    AlertView.showSpecialCharacterAlertview(title: errorTitle, subject: "Potential remarks of \(objProduct.Product_Name!)", restrictedVal: restrictedCharacter, viewController: self)
                    return
                }
                
                if (objProduct.objWrapper.remarks.count > 100)
                {
                    AlertView.showAlertView(title: errorTitle, message: "Potential remarks can not exceed 100 characters for the product \(objProduct.Product_Name!)", viewController: self)
                    return
                }
            }
        }
        
        BL_DetailedProducts.sharedInstance.insertDetailedProducts(detailedProductList:selectedProductList, doctorVisitId: DCRModel.sharedInstance.doctorVisitId)
        
        
        let detailObj = currentList[(indexPath.section)].lstDetailedProducs[(indexPath.row)]
        let sb = UIStoryboard(name: detailProductSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier:CompetitorProductDetailViewControllerID ) as! CompetitorProductDetailViewController
        vc.selectedProductObj = detailObj
        if let navigationController = self.navigationController
        {
            navigationController.popViewController(animated: false)
            navigationController.pushViewController(vc, animated: false)
        }
    }
    
    func changeCurrentList(list : [DetailProductMasterSectionModel])
    {
        if list.count > 0
        {
            self.currentList = list
            self.tableView.reloadData()
            showEmptyStateView(show: false)
        }
        else
        {
            showEmptyStateView(show: true)
        }
    }
    
    func showEmptyStateView(show : Bool)
    {
        self.emptyStateView.isHidden = !show
        self.contentView.isHidden = show
        
    }
    
    func getDetailedList()
    {
        if isFromPOB == true
        {
            detailedList = BL_DetailedProducts.getMasterDetailedProductsPOB(productTypeName:"SALES",date:DCRModel.sharedInstance.dcrDateString)
            changeCurrentList(list: detailedList)
        }
        else
        {
            if !isComingFromModifyPage
            {
                //detailedList = BL_DetailedProducts.getMasterDetailedProducts()
                if (isFromDoctor)
                {
                    detailedList = BL_DetailedProducts.sharedInstance.getMasterDetailedProductsWithGroupBy(customerCode: checkNullAndNilValueForString(stringData: DCRModel.sharedInstance.customerCode), regionCode: checkNullAndNilValueForString(stringData: DCRModel.sharedInstance.customerRegionCode), dcrActualDate: DCRModel.sharedInstance.dcrDateString)
                }
                else
                {
                    if isFromChemistDay
                    {
                        detailedList = BL_DetailedProducts.sharedInstance.getMasterDetailedProducts(productTypeName: "ACTIVITY", date: DCRModel.sharedInstance.dcrDateString)
                    }
                    else
                    {
                        detailedList = BL_DetailedProducts.sharedInstance.getMasterDetailedProducts(productTypeName: "SALES", date: DCRModel.sharedInstance.dcrDateString)
                    }
                }
                
                if detailedList.count == 0
                {
                    searchBar.isHidden = true
                }
                changeCurrentList(list: detailedList)
            }
        }
    }
    
    //MARK:-Search Bar Delegate
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool
    {
        self.searchBar.showsCancelButton = true
        enableCancelButtonForSearchBar(searchBar:searchBar)
        return true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.showsCancelButton = false
        self.searchBar.text = nil
        self.searchBar.resignFirstResponder()
        self.changeCurrentList(list: detailedList)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if (searchBar.text?.count)! > 0
        {
            sortCurrentList(searchText: searchBar.text!)
        }
        else if searchBar.text?.count == 0
        {
            self.changeCurrentList(list: detailedList)
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.resignFirstResponder()
    }
    
    func sortCurrentList(searchText:String)
    {
        searchList = []
        var resultList: [DetailProductMaster] = []
        
        for objSection in detailedList
        {
            let filtered = objSection.lstDetailedProducs.filter{
                $0.Product_Name.lowercased().contains(searchText.lowercased())
            }
            
            if (filtered.count > 0)
            {
                for obj in filtered
                {
                    resultList.append(obj)
                }
            }
        }
        
        if (resultList.count > 0)
        {
            let objSection = DetailProductMasterSectionModel()
            
            objSection.Section_Title = ""
            objSection.lstDetailedProducs = resultList
            searchList.append(objSection)
        }
        
        self.changeCurrentList(list: searchList)
    }
    
    func convertToDetailMaster(list : NSMutableArray) -> [DetailProductMaster]
    {
        var selectedProductList : [DetailProductMaster] = []
        if list.count > 0
        {
            for obj in list
            {
                selectedProductList.append(obj as! DetailProductMaster)
            }
        }
        return selectedProductList
    }
    
    
    func getDCRSelectedList()
    {
        var dcrSelectedList:[DetailProductMaster] = []
        if isFromChemistDay
        {
            dcrSelectedList = BL_DetailedProducts.sharedInstance.getChemistDetailedProducts()
        }
        else if isFromRCPA
        {
            if customerModel != nil
            {
                dcrSelectedList = BL_DetailedProducts.sharedInstance.getChemistDayRCPAProducts(doctorCode: (customerModel?.Customer_Code)!, doctorRegionCode: (customerModel?.Region_Code)!, doctorname: (customerModel?.Customer_Name)!, docSpeciality: (customerModel?.Speciality_Name)!)
            }
        }
        else
        {
             dcrSelectedList = BL_DetailedProducts.sharedInstance.getDCRDetailedProducts(dcrId: DCRModel.sharedInstance.dcrId, doctorVisitId: DCRModel.sharedInstance.doctorVisitId)
        }
        
        for obj in dcrSelectedList
        {
            if isComingFromModifyPage
            {
                selectedList.add(obj)
            }
            else
            {
                userSelectedProduct.append(obj.Product_Code)
            }
        }
        selectedTitle = String(dcrSelectedList.count)
        setNavigationTitle(Num : selectedTitle)
        
        if isComingFromModifyPage
        {
            let objSection = DetailProductMasterSectionModel()
            
            objSection.Section_Title = ""
            objSection.lstDetailedProducs = dcrSelectedList
            self.detailedList = [objSection]
            
            //self.detailedList = dcrSelectedList
            //changeCurrentList(list: dcrSelectedList)
            changeCurrentList(list: self.detailedList)
        }
    }
    
    func getPOBSelectedList()
    {
        var pobSelectedList : [DetailProductMaster] = []
        if orderEntryId != nil
        {
            let pobDetailedList = BL_POB_Stepper.sharedInstance.getPOBDetailsBasedOnCustomer(dcrId: DCRModel.sharedInstance.dcrId,visitId: DCRModel.sharedInstance.customerVisitId,customerEntityType: DCRModel.sharedInstance.customerEntityType, orderEntryId: orderEntryId!)
            if ((pobDetailedList?.count)! > 0 && pobDetailedList != nil)
            {
                pobSelectedList = BL_DetailedProducts.sharedInstance.convertPOBsalesIntoDetailedProductMaster(pobDetailedList: pobDetailedList!)!
            }
        }
        
        for obj in pobSelectedList
        {
            if isComingFromModifyPage
            {
                selectedList.add(obj)
            }
            else
            {
                userSelectedProduct.append(obj.Product_Code)
            }
        }
        selectedTitle = String(describing: pobSelectedList.count)
        setNavigationTitle(Num : selectedTitle)
        
        if isComingFromModifyPage
        {
            let objSection = DetailProductMasterSectionModel()
            
            objSection.Section_Title = ""
            objSection.lstDetailedProducs = pobSelectedList
            self.detailedList = [objSection]
            
            //self.detailedList = pobSelectedList
            //changeCurrentList(list: pobSelectedList)
            changeCurrentList(list: self.detailedList)
        }
    }
    
    func setNavigationTitle(Num : String)
    {
        if Num == "0"
        {
            self.navigationItem.title = "Products List"
        }
        else
        {
            self.navigationItem.title = Num + " Selected"
        }
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
        _ = navigationController?.popViewController(animated: false)
    }
    
    func addBarButtonItem()
    {
        saveBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(DetailedProductViewController.saveBtnAction))
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
            
            var contentInset:UIEdgeInsets = self.tableView.contentInset
            contentInset.bottom = keyboardFrame.size.height
            self.tableView.contentInset = contentInset
            
            //get indexpath
            // let indexpath = IndexPath(row: 1, section: 0)
            //  self.tableView.scrollToRow(at: indexpath, at: UITableViewScrollPosition.top, animated: true)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        let contentInsets = UIEdgeInsets.zero
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func statucButtonClicked(sender:UIButton)
    {
        let section = sender.tag/1000
        let row = sender.tag%1000
        let indexPath = IndexPath(row: row, section: section)
        
        let sb = UIStoryboard(name: docotorVisitSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.BusinessStatusVcId) as! BusinessStatusViewController
        
        getBusinessStatusList(indexPath: indexPath)
        _ = canShowBusinessStatus(indexPath: indexPath)
        
        vc.businessStatusList = lstBusinessStatus
        vc.delegate = self
        vc.indexPath = indexPath
        vc.isCallObjective = false
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        let section = textView.tag/1000
        let row = textView.tag%1000
        let objProduct = currentList[section].lstDetailedProducs[row]
        
        objProduct.objWrapper.remarks = textView.text
        toggleSaveBtn()
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
        let section = textView.tag/1000
        let row = textView.tag%1000
        let objProduct = currentList[section].lstDetailedProducs[row]
        
        objProduct.objWrapper.remarks = textView.text
        toggleSaveBtn()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        let section = textField.tag/1000
        let row = textField.tag%1000
        let objProduct = currentList[section].lstDetailedProducs[row]
        
        if (checkNullAndNilValueForString(stringData: textField.text) != EMPTY)
        {
            objProduct.objWrapper.businessPotential = textField.text!
        }
        else
        {
            objProduct.objWrapper.businessPotential = defaultBusinessPotential
        }
        toggleSaveBtn()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        let section = textField.tag/1000
        let row = textField.tag%1000
        let objProduct = currentList[section].lstDetailedProducs[row]
        
        if (checkNullAndNilValueForString(stringData: textField.text) != EMPTY)
        {
            objProduct.objWrapper.businessPotential = textField.text!
        }
        else
        {
            objProduct.objWrapper.businessPotential = defaultBusinessPotential
        }
    }
    
    private func getBusinessStatusList(indexPath: IndexPath)
    {
        lstBusinessStatus.removeAll()
        lstBusinessStatus = BL_DCR_Doctor_Visit.sharedInstance.getProductBusinessStatusList()
        
        let obj = currentList[indexPath.section].lstDetailedProducs[indexPath.row]
        
        if (isComingFromModifyPage)
        {
            if (obj.objWrapper.objBusinessStatusEdit != nil)
            {
                if (obj.objWrapper.objBusinessStatusEdit!.Business_Status_ID != defaultBusineessStatusId)
                {
                    let filteredArray = lstBusinessStatus.filter{
                        $0.Business_Status_ID == obj.objWrapper.objBusinessStatusEdit!.Business_Status_ID!
                    }
                    
                    if (filteredArray.count == 0)
                    {
                        let objStatus = createBusinessStatusObj(id: obj.objWrapper.objBusinessStatusEdit!.Business_Status_ID!, name: obj.objWrapper.objBusinessStatusEdit!.Status_Name!)
                        lstBusinessStatus.append(objStatus)
                    }
                }
            }
        }
    }
    
    func selectBusinessActivity(indexPath: IndexPath?, selectedStatus: BusinessStatusModel, isCallObjective: Bool)
    {
        if let navigationController = self.navigationController
        {
            navigationController.popViewController(animated: true)
        }
        
        self.isFromBusinessStatusDelegage = true
        currentList[indexPath!.section].lstDetailedProducs[indexPath!.row].objWrapper.objBusinessStatus = selectedStatus
        self.tableView.reloadRows(at: [indexPath!], with: UITableViewRowAnimation.none)
        toggleSaveBtn()
    }
    
    func setdata(indexPath: IndexPath?, selectedStatus: BusinessStatusModel, isCallObjective: Bool)
    {

       // self.isFromBusinessStatusDelegage = true
        currentList[indexPath!.section].lstDetailedProducs[indexPath!.row].objWrapper.objBusinessStatus = selectedStatus
        self.tableView.reloadRows(at: [indexPath!], with: UITableViewRowAnimation.none)
       // toggleSaveBtn()
    }
    
    private func toggleSaveBtn()
    {
        if selectedTitle != "0"
        {
            self.navigationItem.rightBarButtonItem = self.saveBtn
        }
        else if isComingFromModifyPage
        {
            self.navigationItem.rightBarButtonItem = self.saveBtn
        }
    }
    
    private func isValidDecimalValue(value: String) -> Bool
    {
        return isValidFloatNumber(value: value)
    }
    
    private func canShowBusinessStatus(indexPath: IndexPath) -> Bool
    {
        var lstBusinessStatus = BL_DCR_Doctor_Visit.sharedInstance.getProductBusinessStatusList()
        let obj = currentList[indexPath.section].lstDetailedProducs[indexPath.row]
        var showBusinessStatus: Bool = false
        
        if (isComingFromModifyPage)
        {
            if (obj.objWrapper.objBusinessStatus != nil)
            {
                if (obj.objWrapper.objBusinessStatus!.Business_Status_ID != defaultBusineessStatusId)
                {
                    let filteredArray = lstBusinessStatus.filter{
                        $0.Business_Status_ID == obj.objWrapper.objBusinessStatus!.Business_Status_ID!
                    }
                    
                    if (filteredArray.count == 0)
                    {
                        let objStatus = createBusinessStatusObj(id: obj.objWrapper.objBusinessStatus!.Business_Status_ID!, name: obj.objWrapper.objBusinessStatus!.Status_Name!)
                        lstBusinessStatus.append(objStatus)
                        
                        showBusinessStatus = true
                    }
                }
                else
                {
                    showBusinessStatus = true
                }
            }

        }
        
        if (!showBusinessStatus)
        {
            if (lstBusinessStatus.count > 1)
            {
                showBusinessStatus = true
            }
        }
        
        return showBusinessStatus
    }
    
    private func createBusinessStatusObj(id: Int, name: String) -> BusinessStatusModel
    {
        let dict: NSDictionary = ["Business_Status_Id": id, "Status_Name": name, "Entity_Type_Description": DOCTOR, "Entity_Type": Constants.Call_Objective_Entity_Type_Ids.Doctor]
        let objStatus = BusinessStatusModel(dict: dict)
        
        return objStatus
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        //        let pointInTable:CGPoint = (tableView.superview?.convert(textView.frame.origin, to: self.tableView))!
        //        var contentOffset:CGPoint = tableView.contentOffset
        //        contentOffset.y  = pointInTable.y
        //        if let accessoryView = textView.inputAccessoryView {
        //            contentOffset.bo = 343
        //        }
        //        tableView.contentOffset = contentOffset
        
        let pointInTable:CGPoint = textView.superview!.convert(textView.frame.origin, to: tableView)
        var contentOffset:CGPoint = tableView.contentOffset
        contentOffset.y  = pointInTable.y
        if let accessoryView = textView.inputAccessoryView
        {
            contentOffset.y -= accessoryView.frame.size.height + 100
        }
        tableView.contentOffset = contentOffset
        return true
    }
    
    
}
