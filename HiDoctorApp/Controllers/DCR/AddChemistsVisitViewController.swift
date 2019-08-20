//
//  AddChemistsVisitViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 05/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class AddChemistsVisitViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate
{
    
    @IBOutlet weak var scrollViewBottomConst: NSLayoutConstraint!
    @IBOutlet weak var pobAmtTxtFld: UITextField!
    @IBOutlet weak var chemistsPlaceNameLbl: UILabel!
    @IBOutlet weak var doctorNameLbl: UILabel!
    @IBOutlet weak var visitDateLbl: UILabel!
    @IBOutlet weak var emptyStateHgtConst: NSLayoutConstraint!
    @IBOutlet weak var moreViewHgtConst: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewHgtConst: NSLayoutConstraint!
    @IBOutlet weak var scrollView : UIScrollView!
    
    @IBOutlet weak var cardView: CornerRadiusWithShadowView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var outerView : UIView!
    @IBOutlet weak var tableViewHgtConst: NSLayoutConstraint!
    
    @IBOutlet weak var detailView: UIView!
    
    @IBOutlet weak var pobView: RoundedCornerRadiusView!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var rcpaView: RoundedCornerRadiusView!
    
    @IBOutlet weak var saveChemistBtn: UIButton!
    
    
    var chemistsRCPAList : [DCRRCPAModel] = []
    var chemistObj : CustomerMasterModel!
    var flexiChemistObj : FlexiChemistModel!
    var isExpanded : Bool = false
    var isChemistVisitSaved : Bool = false
    var isComingFromAddRCPAPage : Bool = false
    var isComingFromModifyPage : Bool = false
    var modifyObj : DCRChemistVisitModel?
    var titleLabel : UILabel = UILabel()
    var titleName : String = ""

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.getRCPADetails()
        self.addKeyBoardObserver()
        self.addTapGestureForView()
        self.setDefaultDetails()
        addBackButtonView()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.isExpanded = false
        
        pobAmtTxtFld.delegate = self
       
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
        if chemistsRCPAList.count > 0
        {
            return 25
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChemistsRCPAHeaderCell) as! ChemistsRCPAHeaderTableViewCell
        if chemistsRCPAList.count > 1
        {
            cell.stepImgHgtConst.constant = 24
            if isExpanded
            {
                cell.stepImg.image = UIImage(named: "icon-stepper-up-arrow")
            }
            else
            {
                cell.stepImg.image = UIImage(named: "icon-stepper-down-arrow")
            }
        }
        else
        {
            cell.stepImgHgtConst.constant = 0
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return chemistsRCPAList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let defaultHeight : CGFloat = 47
        return defaultHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChemistsRCPAListsCell, for: indexPath) as! ChemistsRCPAListCell
        let rcpaObj = chemistsRCPAList[indexPath.row]
        var rcpaName : String = ""
        
        if checkNullAndNilValueForString(stringData: rcpaObj.Competitor_Product_Name) == ""
        {
            rcpaName = rcpaObj.Own_Product_Name as String
        }
        else
        {
            rcpaName = rcpaObj.Competitor_Product_Name! as String
        }
        cell.rcpaNameLbl.text =  rcpaName
        if rcpaObj.Qty_Given != nil
        {
            var qty  = (String(describing: rcpaObj.Qty_Given!)) as String
            if qty != ""
            {
                qty = "\(qty) Units"
            }
            else
            {
                qty = "0"
            }
            cell.popAmountLbl.text = qty
        }
        else
        {
            cell.popAmountLbl.text = "0 Units"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.reloadTableView()
    }
    
    @IBAction func AddRCPABtnAction(_ sender: UIButton)
    {
        self.pobAmtTxtFld.resignFirstResponder()
        self.navigationController?.navigationBar.isHidden = false
        if (self.pobAmtTxtFld.text?.count)! > 0 && !maxNumberValidationCheck(value: pobAmtTxtFld.text!, maxVal: chemistPOBMaxVal)
        {
            AlertView.showNumberExceedAlertView(title: alertTitle, subject: "POB Amount", maxVal: chemistPOBMaxVal, viewController: self)
        }
        else
        {
            self.saveChemistsVisitDetails()
        }
        let sb = UIStoryboard(name: detailProductSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: DetailProductVcID) as! DetailedProductViewController
        vc.isComingFromChemistRCPA = true
        vc.isComingFromModifyRCPAPage = isComingFromModifyPage
        if isComingFromModifyPage
        {
            vc.chemistVisitId = (modifyObj?.DCR_Chemist_Visit_Id)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func modifyBtnAction(_ sender: Any)
    {
        var chemistId : Int = 0
        self.navigationController?.navigationBar.isHidden = false
        if isComingFromModifyPage
        {
            chemistId = (modifyObj?.DCR_Chemist_Visit_Id)!
        }
        else
        {
            chemistId = BL_DCR_Chemist_Visit.sharedInstance.getLastDCRChemistVisitId()
        }
        let sb = UIStoryboard(name: chemistsSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: ModifyRCPAVcID) as! ModifyRCPAViewController
        vc.dcrChemistVisitId = chemistId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getRCPADetails()
    {
        var chemistId : Int = 0
        if isComingFromModifyPage
        {
            chemistId = (modifyObj?.DCR_Chemist_Visit_Id)!
        }
        else if isComingFromAddRCPAPage
        {
            chemistId = BL_DCR_Chemist_Visit.sharedInstance.getLastDCRChemistVisitId()
        }
        if isComingFromAddRCPAPage || isComingFromModifyPage
        {
            chemistsRCPAList = BL_DCR_Chemist_Visit.sharedInstance.getDCRRCPADetails(dcrChemistVisitId: chemistId)!
            if chemistsRCPAList.count > 0
            {
                self.tableView.clipsToBounds = false
                self.rcpaView.backgroundColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1.0)
                self.emptyStateHgtConst.constant = 0
                self.setMoreViewHgt()
                self.tableView.reloadData()
                self.setHeightForTableView(type: 0)
            }
            else
            {
                self.setEmptyStateView()
                self.rcpaView.backgroundColor = UIColor.darkGray
            }
        }
        else
        {
            self.setEmptyStateView()
        }
    }
    
    func setDefaultDetails()
    {
        saveChemistBtn.setTitle("SAVE \(appChemist.uppercased()) VISIT", for: .normal)
        
        var chemistName : String = ""
       
       
        if isComingFromModifyPage
        {
            chemistName = (modifyObj?.Chemist_Name)!
            let pobAmount : String =  String(describing: (modifyObj?.POB_Amount)!)
            self.pobAmtTxtFld.text = pobAmount
        }
        else
        {
            if chemistObj != nil
            {
                chemistName = chemistObj.Customer_Name!
            }
            else if flexiChemistObj != nil
            {
                chemistName = flexiChemistObj.Flexi_Chemist_Name 
            }
            else
            {
                chemistName = titleName
            }
        }
        
      
        self.navigationItem.title = chemistName
        self.setHeaderDetails()
    }
    
    func setHeaderDetails()
    {
        var regionName : String  = ""
        var doctorName : String = ""
        let dcrDateVal = convertDateIntoString(date: DCRModel.sharedInstance.dcrDate)
        let doctorObj = BL_DCR_Doctor_Visit.sharedInstance.getDoctorVisitDetailByDoctorVisitId(doctorVisitId: DCRModel.sharedInstance.doctorVisitId)
        if doctorObj != nil
        {
           doctorName = checkNullAndNilValueForString(stringData: doctorObj?.Doctor_Name)
           let placeName = checkNullAndNilValueForString(stringData: doctorObj?.Doctor_Region_Name)
            if placeName != ""
            {
                regionName = placeName
            }
            else
            {
                regionName = BL_InitialSetup.sharedInstance.regionName
            }
        }
        
        self.visitDateLbl.text = String(format: "visit date : %@", dcrDateVal)
        self.headerView.backgroundColor = brandColor
        self.doctorNameLbl.text = "\(doctorName)"
        self.chemistsPlaceNameLbl.text = regionName
    }
    
    @IBAction func headerBtnAction(_ sender: Any)
    {
        self.navigationController?.navigationBar.isHidden = false
        self.reloadTableView()
    }
    
    @IBAction func rowBtnAction(_ sender: Any) {
        self.reloadTableView()
    }
    func reloadTableView()
    {
        self.isExpanded = !isExpanded
        if isExpanded
        {
            self.setHeightForTableView(type: 1)
        }
        else
        {
            self.setHeightForTableView(type: 0)
        }
        self.tableView.reloadData()
    }
    
    //MARK:- KeyBoard function
    
    func addKeyBoardObserver()
    {
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(keyboardDidShow(_:)),
                           name: .UIKeyboardDidShow,
                           object: nil)
        
        center.addObserver(self,
                           selector: #selector(keyboardWillHide(_:)),
                           name: .UIKeyboardWillHide,
                           object: nil)
    }
    
    @objc func keyboardDidShow(_ notification: NSNotification)
    {
        
        if let userInfo = notification.userInfo
        {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            {
                self.scrollViewBottomConst.constant = keyboardSize.height
                self.view.layoutIfNeeded()
                //let currentScrollHeight = self.scrollView.frame.height - keyboardSize.height
                
                let viewPresentPosition = self.pobAmtTxtFld.convert(self.pobAmtTxtFld.bounds, to: self.contentView)
                
                let scrollViewHeight = self.scrollView.frame.height
                
                let finalContentOffset = (viewPresentPosition.origin.y + viewPresentPosition.height) - scrollViewHeight
                var contentOffset = self.scrollView.contentOffset
                
                if finalContentOffset > 0
                {
                    contentOffset.y = finalContentOffset + 40
                }
                self.scrollView.contentOffset = contentOffset
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification)
    {
        self.scrollViewBottomConst.constant = 0
    }
    
    func addTapGestureForView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddChemistsVisitViewController.resignResponderForTxtField))
        view.addGestureRecognizer(tap)
    }
    
    @objc func resignResponderForTxtField()
    {
        self.pobAmtTxtFld.resignFirstResponder()
    }
    
    @IBAction func saveChemistBtnAction(_ sender: Any)
    {
        if (self.pobAmtTxtFld.text?.count)! > 0 && !isValidFloatNumber(value: self.pobAmtTxtFld.text!)
        {
            AlertView.showAlertView(title: alertTitle, message: "Enter valid POB Amount", viewController: self)
        }
        else if (self.pobAmtTxtFld.text?.count)! > 0 && !maxNumberValidationCheck(value: pobAmtTxtFld.text!, maxVal: chemistPOBMaxVal)
        {
            AlertView.showNumberExceedAlertView(title: alertTitle, subject: "POB Amount", maxVal: chemistPOBMaxVal, viewController: self)
        }
        else
        {
        self.navigationController?.navigationBar.isHidden = false
        self.saveChemistsVisitDetails()
        _ = navigationController?.popViewController(animated: false)
        }
    }
    
    func saveChemistsVisitDetails()
    {
        if !isChemistVisitSaved
        {
            var pobAmt : Double = 0.0
            if (self.pobAmtTxtFld.text?.count)! > 0
            {
                pobAmt = NSString(string: pobAmtTxtFld.text!).doubleValue
            }
            if isComingFromModifyPage
            {
                modifyObj?.POB_Amount = pobAmt
                BL_DCR_Chemist_Visit.sharedInstance.updateDCRChemistVisit(dcrChemistVisitObj: modifyObj!)
            }
            else
            {
                var customerName : String = ""
                var customerID : Int = 0
                var CustomerCode : String = ""
                if flexiChemistObj != nil
                {
                    customerName = flexiChemistObj.Flexi_Chemist_Name
                    customerID = flexiChemistObj.Flexi_Chemist_Id
                }
                else if chemistObj != nil
                {
                    customerID = chemistObj.Customer_Id
                    customerName = chemistObj.Customer_Name
                    CustomerCode = chemistObj.Customer_Code
                }
                else
                {
                    customerName = titleName
                }
                BL_DCR_Chemist_Visit.sharedInstance.saveDCRChemistVisit(chemistId: customerID, chemistCode:CustomerCode, chemistName: customerName, pobAmount: pobAmt)
                self.isChemistVisitSaved = true
            }
        }
    }
    
   
   

    
    func setEmptyStateView()
    {
        self.emptyStateHgtConst.constant = 70
        self.bottomViewHgtConst.constant = 0
        self.bottomView.clipsToBounds = true
        self.tableViewHgtConst.constant = 0
        self.cardView.isHidden = true
    }
    
    func setMoreViewHgt()
    {
        var moreViewHgt : CGFloat = 0
        let bottomViewHgt : CGFloat = 40
        
        if !isExpanded && chemistsRCPAList.count > 1
        {
            moreViewHgt = 20
        }
        else
        {
            
        }
        self.moreViewHgtConst.constant = moreViewHgt
        self.bottomViewHgtConst.constant = moreViewHgt + bottomViewHgt
        self.bottomView.clipsToBounds = false

    }
    
    func setHeightForTableView(type : Int)
    {
        self.cardView.isHidden = false
        if type == 0
        {
            self.tableViewHgtConst.constant = 70
            self.tableView.isScrollEnabled = false
            self.setMoreViewHgt()
        }
        else
        {
            self.tableViewHgtConst.constant = self.tableView.contentSize.height
            self.tableView.isScrollEnabled = true
            self.setMoreViewHgt()
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
         if textField == pobAmtTxtFld
        {
            if(string == ".")
            {
                if(textField.text?.contains("."))!
                {
                    
                    return false
                }
            }
            
            if(textField.text?.contains("."))!
            {
                if var str = textField.text
                {
                    str.insert(string.first ?? " ", at: str.index(str.startIndex, offsetBy: range.location))
                    let stringArray = str.components(separatedBy: ".")
                    
                    if Int(stringArray[0]) ?? 0 > Int(doctorPOBMaxVal)
                    {
                        if string != EMPTY
                        {
                            return false
                        }
                    }
                    
                    if Int(stringArray[1]) ?? 0 > 99
                    {
                        if string != EMPTY
                        {
                            return false
                        }
                    }
                    if stringArray[1].count > 2
                    {
                        if string != EMPTY
                        {
                            return false
                        }
                    }
                }
            }
            else
            {
                if textField.text?.count ?? 0 > 10
                {
                    if(string != ".")
                    {
                        if string != EMPTY
                        {
                            return false
                        }
                    }
                }
                //return isValidNumberForPobAmt(string : string)
                
            }
            
            let aSet = NSCharacterSet(charactersIn:"0123456789.").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered
        }
        
        return true
    }
}
