//
//  AddChemistRCPAViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 06/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class AddChemistRCPAViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,selectedCompetitorListDelgate,UITextFieldDelegate
{
    var selectedProductObj : DetailProductMaster!
    var competitorList : [CompetitorProductModel] = []
    @IBOutlet weak  var tableView : UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ownProductLbl: UILabel!
    @IBOutlet weak var ownProductQtyLbl: UILabel!
    @IBOutlet weak var tableViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var ownProductTextFiedl: UITextField!
    
    var qty : Int = 0
    var dcrRCPAObj : DCRRCPAModel!
    var dcrChemistDayRCPAObj : DCRChemistRCPAOwn?
    var isComingFromModifyRCPA : Bool = false
    var isComingFromModifyCompetitor : Bool = false
    var isComingFromFlexiCompetitor : Bool = false
    var chemistVisitId : Int!
    var doctorObj: CustomerMasterModel?
    var isFromChemistDayRCPA: Bool = false
    var modifyChemistDayRCPA: Bool = false
    var currentTextFieldTag: Int!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableViewHeightConst.constant = 50
        self.setOwnProductDetails()
        
        self.ownProductTextFiedl.tag = -1
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.setCompetitorList()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddRCPAHeaderCell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return competitorList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddRCPAListCell, for: indexPath) as! AddChemistRCPATableViewCell
        let competitiorObj = competitorList[indexPath.row]
        let competitorId = competitiorObj.Competitor_Product_Id
        cell.compProductQtyTextFiedl.addHideinputAccessoryView()
        cell.compProductQtyTextFiedl.delegate = self
        cell.compProductQtyTextFiedl.tag = indexPath.row
        
        if isFromChemistDayRCPA || modifyChemistDayRCPA
        {
            cell.productNameLbl.text = competitiorObj.Competitor_Product_Name
            if competitiorObj.Qty_Given != nil
            {
                let qty = Int(competitiorObj.Qty_Given)
                cell.compProductQtyTextFiedl.text = String(qty)
            }
            else
            {
                competitiorObj.Qty_Given = 0
                cell.compProductQtyTextFiedl.text = "0"
            }
        }
        else
        {
            if competitorId != nil
            {
                cell.productNameLbl.text = competitiorObj.Competitor_Product_Name
                if competitiorObj.Qty_Given != nil
                {
                    let qty = Int(competitiorObj.Qty_Given)
                    cell.compProductQtyTextFiedl.text = String(qty)
                }
                else
                {
                    competitiorObj.Qty_Given = 0
                    cell.compProductQtyTextFiedl.text = "0"
                }
            }
        }
        
        cell.stepUpBtn.tag = indexPath.row
        cell.stepDownBtn.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    @IBAction func stepUpBtnAction(_ sender: UIButton)
    {
        let productDetail = competitorList[sender.tag]
        let indexPath = IndexPath(row: sender.tag, section: 0)
        if !maxNumberValidationCheck(value: String(productDetail.Qty_Given!), maxVal: rcpaCompProdMaxVal)
        {
            AlertView.showNumberExceedAlertView(title: alertTitle, subject: "Competitor Product Quantity", maxVal: rcpaCompProdMaxVal, viewController: self)
        }
        else
        {
            productDetail.Qty_Given! += 1
            tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
        }
    }
    
    @IBAction func stepDownBtnAction(_ sender: UIButton)
    {
        let productDetail = competitorList[sender.tag]
        let indexPath = IndexPath(row: sender.tag, section: 0)
        if productDetail.Qty_Given > 0
        {
            productDetail.Qty_Given! -= 1
        }
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
    }
    
    @IBAction func saveBtnAction(_ sender: Any)
    {
        if (condenseWhitespace(stringValue: ownProductTextFiedl.text!) == EMPTY)
        {
            AlertView.showAlertView(title: errorTitle, message: "Please enter own product quantity")
            return
        }
        
        if (!isValidIntegerNumber(value: ownProductTextFiedl.text!))
        {
            AlertView.showAlertView(title: errorTitle, message: "Please enter valid own product quantity")
            return
        }
        
        if (ownProductTextFiedl.text!.count > 6)
        {
            AlertView.showAlertView(title: errorTitle, message: "Own product quantity can't exceed 999999")
            return
        }
        
        let competitorList = getCompetitorList()
        
        for obj in self.competitorList
        {
            let intQty = Int(obj.Qty_Given)
            let strQty = String(intQty)
            
            if (strQty.count > 6)
            {
                AlertView.showAlertView(title: errorTitle, message: "Competitor product quantity can't exceed 999999 for the product \(obj.Competitor_Product_Name!)")
                return
            }
        }
        
        let ownProductQty = Int(ownProductTextFiedl.text!)
        var ownProductId : Int = 0
        var ownProdutctName : String = ""
        var ownProductCode : String = ""
        
        if isFromChemistDayRCPA
        {
            if(modifyChemistDayRCPA)
            {
                if dcrRCPAObj != nil
                {
                    ownProductCode = dcrRCPAObj.Own_Product_Code!
                    ownProdutctName = dcrRCPAObj.Own_Product_Name
                }
                else if selectedProductObj != nil
                {
                    ownProductId = selectedProductObj.Detail_Product_Id
                    ownProductCode = selectedProductObj.Product_Code
                    ownProdutctName = selectedProductObj.Product_Name
                }
                if dcrRCPAObj != nil
                {
                    chemistVisitId = dcrRCPAObj.DCR_Chemist_Visit_Id
                }
                let dict = ["Product_Code":ownProductCode,"Product_Name":ownProdutctName]
                let detailProductObj = DetailProductMaster(dict: dict as NSDictionary)
                
                BL_DCR_Chemist_Visit.sharedInstance.updateChemistDayRCPADetails(chemistRCPAOwnId: (dcrChemistDayRCPAObj?.DCRChemistRCPAOwnId)!, objOwnProduct: detailProductObj, doctorCode: (dcrChemistDayRCPAObj?.DoctorCode!)!, doctorRegionCode: (dcrChemistDayRCPAObj?.DoctorRegionCode)!, doctorName: (dcrChemistDayRCPAObj?.DoctorName)!, specialtyName: (dcrChemistDayRCPAObj?.DoctorSpecialityName)!, categoryName: (dcrChemistDayRCPAObj?.DoctorCategoryName)!, mdlNumber: (dcrChemistDayRCPAObj?.DoctorMDLNumber)!, ownProductQty: Float(ownProductQty!), competitorProductArray: competitorList)
                _ = navigationController?.popViewController(animated: false)
            }
            else
            {
                ownProductId = selectedProductObj.Detail_Product_Id
                ownProductCode = selectedProductObj.Product_Code
                ownProdutctName = selectedProductObj.Product_Name
                
                let dict = ["Product_Code":ownProductCode,"Product_Name":ownProdutctName]
                let detailProductObj = DetailProductMaster(dict: dict as NSDictionary)
                
                BL_DCR_Chemist_Visit.sharedInstance.saveChemistDayRCPADetails(objOwnProduct: detailProductObj, doctorCode: (doctorObj?.Customer_Code)!, doctorRegionCode: (doctorObj?.Region_Code)!, doctorName: (doctorObj?.Customer_Name)!, specialtyName: (doctorObj?.Speciality_Name)!, categoryName: (doctorObj?.Category_Name)!, mdlNumber: (doctorObj?.MDL_Number)!, ownProductQty: Float(ownProductQty!), competitorProductArray: competitorList)
                
                if let navigationController = self.navigationController
                {
                    navigationController.popViewController(animated: true)
                }
            }
        }
        else
        {
            if isComingFromModifyRCPA || isComingFromModifyCompetitor
            {
                if dcrRCPAObj != nil
                {
                    ownProductId = dcrRCPAObj.Own_Product_Id
                    ownProductCode = dcrRCPAObj.Product_Code!
                    ownProdutctName = dcrRCPAObj.Own_Product_Name
                }
                else if selectedProductObj != nil
                {
                    ownProductId = selectedProductObj.Detail_Product_Id
                    ownProductCode = selectedProductObj.Product_Code
                    ownProdutctName = selectedProductObj.Product_Name
                }
                if dcrRCPAObj != nil
                {
                    chemistVisitId = dcrRCPAObj.DCR_Chemist_Visit_Id
                }
                
                BL_DCR_Chemist_Visit.sharedInstance.updateRCPADetails(dcrChemistVisitId: chemistVisitId, ownProductId:ownProductId, productCode: ownProductCode, ownProductName: ownProdutctName, ownProductQty: Float(ownProductQty!), competitorProductArray: competitorList)
                
                _ = navigationController?.popViewController(animated: false)
            }
            else
            {
                ownProductId = selectedProductObj.Detail_Product_Id
                ownProductCode = selectedProductObj.Product_Code
                ownProdutctName = selectedProductObj.Product_Name
                
                BL_DCR_Chemist_Visit.sharedInstance.saveRCPADetails(dcrChemistVisitId: BL_DCR_Chemist_Visit.sharedInstance.getLastDCRChemistVisitId(), ownProductId:ownProductId,ownProductCode : ownProductCode, ownProductName : ownProdutctName, ownProductQty: Float(ownProductQty!), competitorProductArray: competitorList)
                
                if let navigationController = self.navigationController
                {
                    let viewControllers = navigationController.viewControllers
                    
                    if viewControllers.count >= 3
                    {
                        let viewController1 = viewControllers[viewControllers.count - 2]
                        
                        if viewController1.isKind(of: AddChemistsVisitViewController.self)
                        {
                            let dcrController = viewController1 as! AddChemistsVisitViewController
                            dcrController.isComingFromAddRCPAPage = true
                            
                            navigationController.popViewController(animated: false)
                        }
                    }
                }
            }
            
            //        BL_DCR_Doctor_Visit.sharedInstance.insertDoctorVisitTracker(modifiedEntity: Constants.DoctorVisitTrackerEntityIDs.Chemist_RCPA_Modified)
        }
    }
    
    @IBAction func ownProductStepUpBtnAction(_ sender: Any)
    {
        qty =  Int(ownProductTextFiedl.text!)!
        if !maxNumberValidationCheck(value: ownProductTextFiedl.text!, maxVal: rcpaOwnProdMaxVal)
        {
            AlertView.showNumberExceedAlertView(title: alertTitle, subject: "Own Product Quantity", maxVal: rcpaOwnProdMaxVal, viewController: self)
        }
        else
        {
            qty += 1
            ownProductTextFiedl.text = String(describing: qty)
        }
    }
    
    @IBAction func ownProductStepDownBtnAction(_ sender: Any)
    {
        var qty = Int(ownProductTextFiedl.text!)
        if qty! > 0
        {
            qty! -= 1
            ownProductTextFiedl.text = String(describing: qty!)
        }
    }
    
    func getCompetitorList() -> NSArray
    {
        var selectedList : NSArray = NSArray()
        let selectedCompetitorList : NSMutableArray = NSMutableArray(array: selectedList)
        var dict : NSMutableDictionary = NSMutableDictionary()
        for obj in competitorList
        {
            var  competitorProductId = ""
            if(isFromChemistDayRCPA || modifyChemistDayRCPA)
            {
                competitorProductId = ""
            }
            else
            {
                competitorProductId =  String(describing: obj.Competitor_Product_Id!)
            }
            dict = ["Competitor_Product_Id":competitorProductId,"Competitor_Product_Code":obj.Competitor_Product_Code!,"Competitor_Product_Name":obj.Competitor_Product_Name,"Qty_Given":obj.Qty_Given]
            selectedCompetitorList.add(dict)
        }
        selectedList = selectedCompetitorList
        return selectedCompetitorList
    }
    
    func setOwnProductDetails()
    {
        var productName : String = ""
        self.ownProductTextFiedl.text = "0"
        
        if isComingFromModifyRCPA && dcrRCPAObj != nil
        {
            productName = dcrRCPAObj.Own_Product_Name as String
            var qtyGiven : Int = 0
            if dcrRCPAObj.Qty_Given != nil
            {
                qtyGiven = Int(dcrRCPAObj.Qty_Given!)
            }
            else
            {
                qtyGiven = 0
            }
            self.ownProductTextFiedl.text = String(qtyGiven)
        }
        else if(modifyChemistDayRCPA && dcrRCPAObj != nil)
        {
            productName = dcrRCPAObj.Own_Product_Name as String
            var qtyGiven : Int = 0
            if dcrRCPAObj.Qty_Given != nil
            {
                qtyGiven = Int(dcrRCPAObj.Qty_Given!)
            }
            else
            {
                qtyGiven = 0
            }
            self.ownProductTextFiedl.text = String(qtyGiven)
            
        }
        else
        {
            productName = selectedProductObj.Product_Name
        }
        self.ownProductLbl.text = productName
    }
    
    func getSelectedCompetitorList(list : [CompetitorProductModel])
    {
        if list.count > 0
        {
            competitorList = list
            self.tableView.reloadData()
            self.tableViewHeightConst.constant = self.tableView.contentSize.height
        }
    }
    @IBAction func addCompetitorBtnAction(_ sender: Any)
    {
        var productCode : String = ""
        let sb = UIStoryboard(name: chemistsSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: competitorProductListVcID) as! CompetitorProductListViewController
        vc.userSelectedProduct = getSelectedProductCode()
        
        if isComingFromModifyRCPA || modifyChemistDayRCPA
        {
            vc.isComingFromModifyPage = true
            self.isComingFromModifyCompetitor = true
            
            if dcrRCPAObj != nil
            {
                productCode = dcrRCPAObj.Product_Code!
            }
            else
            {
                productCode = selectedProductObj.Product_Code
            }
        }
        else
        {
            productCode = selectedProductObj.Product_Code
            vc.productList = competitorList
        }
        
        vc.productCode = productCode
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getSelectedProductCode() -> [CompetitorProductModel]
    {
        var list : [CompetitorProductModel] = []
        for obj in competitorList
        {
            list.append(obj)
        }
        return list
    }
    
    func setCompetitorList()
    {
        if isComingFromModifyRCPA && !isComingFromFlexiCompetitor && !isComingFromModifyCompetitor && dcrRCPAObj != nil
        {
            competitorList = convertCompetitorList(list: BL_DCR_Chemist_Visit.sharedInstance.getDCRRCPAByOwnProductId(dcrChemistVisitId: dcrRCPAObj.DCR_Chemist_Visit_Id, ownProductCode: dcrRCPAObj.Product_Code!))
        }
        else if modifyChemistDayRCPA && !isComingFromFlexiCompetitor && !isComingFromModifyCompetitor && dcrRCPAObj != nil
        {
            competitorList = convertChemistDayCompetitorList(list: BL_DCR_Chemist_Visit.sharedInstance.getDCRRCPAByOwnProductId(ownProductId: dcrRCPAObj.Own_Product_Id!))
        }
        
        self.tableView.reloadData()
        self.tableViewHeightConst.constant = self.tableView.contentSize.height
    }
    
    func convertCompetitorList(list : [DCRRCPAModel]) -> [CompetitorProductModel]
    {
        var dcrCompetitorList : [CompetitorProductModel] = []
        for dcrObj in list
        {
            if dcrObj.Competitor_Product_Id != nil
            {
                let dict : NSDictionary = ["Competitor_Product_Id":String(dcrObj.Competitor_Product_Id!),"Competitor_Product_Code" :dcrObj.Competitor_Product_Code!,"Competitor_Product_Name" :dcrObj.Competitor_Product_Name!,"Own_Product_Code" : dcrObj.Own_Product_Code]
                let competitorObj : CompetitorProductModel = CompetitorProductModel(dict: dict)
                competitorObj.Qty_Given = dcrObj.Qty_Given
                dcrCompetitorList.append(competitorObj)
            }
        }
        return dcrCompetitorList
    }
    
    func convertChemistDayCompetitorList(list : [DCRChemistRCPACompetitor]) -> [CompetitorProductModel]
    {
        var dcrCompetitorList : [CompetitorProductModel] = []
        for dcrObj in list
        {
            let dict : NSDictionary = ["Competitor_Product_Code" :dcrObj.CompetitorProductCode!,"Competitor_Product_Name" :dcrObj.CompetitorProductName!,"Own_Product_Code" : dcrObj.OwnProductCode]
            let competitorObj : CompetitorProductModel = CompetitorProductModel(dict: dict)
            competitorObj.Qty_Given = dcrObj.Quantity
            dcrCompetitorList.append(competitorObj)
            
        }
        return dcrCompetitorList
    }
    
    //MARK:- Text Field Delegates
    private func setCompQty(index: Int, text: String)
    {
        var text = text
        let productDetail = competitorList[index]
        //let indexPath = IndexPath(row: index, section: 0)
        productDetail.Qty_Given! = 0
        
        if (text != EMPTY)
        {
            if (!isValidIntegerNumber(value: text))
            {
                AlertView.showAlertView(title: errorTitle, message: "Please enter valid competitor quantity")
                return
            }
            
            text = condenseWhitespace(stringValue: text)
            productDetail.Qty_Given! = Float(text)!
            
            //tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if (textField.tag >= 0)
        {
            let productDetail = competitorList[textField.tag]
            productDetail.Qty_Given! = 0
            
            if (condenseWhitespace(stringValue: textField.text!) == EMPTY)
            {
                AlertView.showAlertView(title: errorTitle, message: "Please enter competitor quantity")
                textField.text = "0"
                return
            }
            
            setCompQty(index: textField.tag, text: textField.text!)
            
            if (!isValidIntegerNumber(value: textField.text!))
            {
                textField.text = "0"
                return
            }
            
            let intQty = Int(textField.text!)
            let strQty = String(intQty!)
            
            if (strQty.count > 6)
            {
                AlertView.showAlertView(title: errorTitle, message: "Competitor quantity can't exceed 999999")
                return
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if (textField.tag >= 0)
        {
            self.currentTextFieldTag = textField.tag
            setCompQty(index: textField.tag, text: textField.text!)
        }
    }
    
    //MARK:- Keyboard Action
    @objc func keyboardWillShow(notification: NSNotification)
    {
        if ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil
        {
            if (self.currentTextFieldTag != nil && self.currentTextFieldTag >= 0)
            {
                var userInfo = notification.userInfo!
                var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
                keyboardFrame = self.view.convert(keyboardFrame, from: nil)
                
                var contentInset:UIEdgeInsets = self.tableView.contentInset
                contentInset.bottom = keyboardFrame.size.height + 16
                self.scrollView.contentInset = contentInset
                self.tableView.contentInset = contentInset
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        tableView.contentInset = UIEdgeInsets.zero
        tableView.scrollIndicatorInsets = UIEdgeInsets.zero
        scrollView.contentInset = UIEdgeInsets.zero
    }
}
