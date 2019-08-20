//
//  ChemistsListViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 02/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class ChemistsListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate
{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var contentView : UIView!
    @IBOutlet weak var emptyStateView  :UIView!
    @IBOutlet weak var searchBarHgtConst: NSLayoutConstraint!
    
    @IBOutlet weak var emptyStateTitleLbl: UILabel!
    
    @IBOutlet weak var addFlexiChemist: UIBarButtonItem!
    var currentList : [CustomerMasterModel] = []
    var searchList : [CustomerMasterModel] = []
    var chemistsList : [CustomerMasterModel] = []
    var selectedChemistName : [String] = []
    var regionCode : String = ""
    var suffixConfigVal : [String]!
    var isComingFromChemistDay : Bool = false
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setDefaults()
        
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return currentList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let chemistsObj = currentList[indexPath.row]
        let defaultHeight : CGFloat = 38
        let chemistNameLblHgt = getTextSize(text: chemistsObj.Customer_Name, fontName: fontSemiBold, fontSize: 15, constrainedWidth: SCREEN_WIDTH - 20).height
        var chemistPlacelblHeight: CGFloat = 0
        var detailText : String = ""
        
        if chemistsObj.MDL_Number != EMPTY && chemistsObj.MDL_Number != nil
        {
            detailText = String(format: "%@ | %@ ",chemistsObj.MDL_Number, chemistsObj.Region_Name)
        }
        else
        {
            detailText = String(format: "%@ ",chemistsObj.Region_Name)
        }
        if suffixConfigVal.contains(ConfigValues.SUR_NAME.rawValue) && chemistsObj.Sur_Name != ""
        {
            detailText = String(format: "%@ | %@", detailText, chemistsObj.Sur_Name!)
        }
        
        if suffixConfigVal.contains(ConfigValues.LOCAL_AREA.rawValue) && chemistsObj.Local_Area != ""
        {
            detailText = String(format: "%@ | %@", detailText, chemistsObj.Local_Area!)
        }
        chemistPlacelblHeight = getTextSize(text: detailText, fontName: fontSemiBold, fontSize: 15, constrainedWidth: SCREEN_WIDTH - 20).height
        
        return defaultHeight + chemistNameLblHgt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: chemistsListCell, for: indexPath) as! ChemistsListTableViewCell
        let chemistsObj = currentList[indexPath.row]
        
        let chemistsName = chemistsObj.Customer_Name as String
        var detailText : String = ""
        
        if chemistsObj.MDL_Number != EMPTY && chemistsObj.MDL_Number != nil
        {
        detailText = String(format: "%@ | %@ ",chemistsObj.MDL_Number, chemistsObj.Region_Name)
        }
        else
        {
           detailText = String(format: "%@ ",chemistsObj.Region_Name)
        }
        if suffixConfigVal.contains(ConfigValues.SUR_NAME.rawValue) && chemistsObj.Sur_Name != ""
        {
            detailText = String(format: "%@ | %@", detailText, chemistsObj.Sur_Name!)
        }
        
        if suffixConfigVal.contains(ConfigValues.LOCAL_AREA.rawValue) && chemistsObj.Local_Area != ""
        {
            detailText = String(format: "%@ | %@", detailText, chemistsObj.Local_Area!)
        }
        cell.chemistsNameLbl.text = chemistsName
        cell.chemistsPlaceLbl.text = detailText
        
        if selectedChemistName.contains(chemistsName)
        {
            cell.mainView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        }
        else
        {
            cell.mainView.backgroundColor = UIColor.white
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let chemistObj = currentList[indexPath.row]
        let chemistsName = chemistObj.Customer_Name as String
        
        if(isComingFromChemistDay)
        {
            if !selectedChemistName.contains(chemistsName)
            {
                
                
                let cell = tableView.cellForRow(at: indexPath)
                cell?.contentView.backgroundColor = UIColor.clear
                
                let sb = UIStoryboard(name: ChemistDaySB, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: ChemistDayVcID) as! ChemistDayStepperController
                vc.customerMasterModel = chemistObj
                if let navigationController = self.navigationController
                {
                    navigationController.popViewController(animated: false)
                    navigationController.pushViewController(vc, animated: false)
                }
            }
            
        }
        else
        {
            if !selectedChemistName.contains(chemistsName)
            {
                
                let cell = tableView.cellForRow(at: indexPath)
                cell?.contentView.backgroundColor = UIColor.clear
                
                let sb = UIStoryboard(name: chemistsSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: AddChemistsVisitVcID) as! AddChemistsVisitViewController
                vc.chemistObj = chemistObj
                if let navigationController = self.navigationController
                {
                    navigationController.popViewController(animated: false)
                    navigationController.pushViewController(vc, animated: false)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.clear
        
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.clear
    }
    
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
        self.changeCurrentArray(list: chemistsList,type : 0)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if (searchBar.text?.count)! > 0
        {
            sortCurrentList(searchText: searchBar.text!)
        }
    }
    
    func sortCurrentList(searchText:String)
    {
        searchList = chemistsList.filter{ (obj) -> Bool in
            let lowerCasedText = searchText.lowercased()
            let stockiestsName = obj.Customer_Name.lowercased()
            let categoryName = obj.Region_Name?.lowercased()
            return stockiestsName.contains(lowerCasedText) || (categoryName?.contains(lowerCasedText))!
        }
        self.changeCurrentArray(list: searchList,type: 1)
    }
    
    func changeCurrentArray(list : [CustomerMasterModel],type : Int)
    {
        if list.count > 0
        {
            currentList = list
            self.showEmptyStateView(show: false)
            self.tableView.reloadData()
        }
        else
        {
            self.showEmptyStateView(show: true)
            self.setEmptyStateLbl(type: type)
        }
    }
    
    func showEmptyStateView(show : Bool)
    {
        self.emptyStateView.isHidden = !show
        self.contentView.isHidden = show
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
    
    func getChemistList()
    {
        if regionCode != ""
        {
            chemistsList = BL_DCR_Chemist_Visit.sharedInstance.getChemistMasterList(regionCode: regionCode)!
        }
        
        changeCurrentArray(list: chemistsList,type:0)
    }
    
    func setEmptyStateLbl(type : Int)
    {
        var text : String = ""
        if type == 0
        {
            text = "No \(appChemistPlural) found"
            self.searchBarHgtConst.constant = 0
        }
        else
        {
            text = "No \(appChemistPlural) found..Clear your search and try again"
            self.searchBarHgtConst.constant = 44
        }
        
        self.emptyStateTitleLbl.text = text
    }
    
    @IBAction func addChemistsBtnAction(_ sender: Any)
    {
    }
    
    func getSelectedDCRChemist()
    {
        if(isComingFromChemistDay)
        {
            let dcrChemistList = DBHelper.sharedInstance.getChemistDayVisitsForDCRId(dcrId: DCRModel.sharedInstance.dcrId)
            for obj in dcrChemistList!
            {
                selectedChemistName.append(obj.ChemistName!)
            }
            
        }
        else
        {
            let dcrChemistList = BL_DCR_Chemist_Visit.sharedInstance.getDCRChemistVisit()
            for obj in dcrChemistList!
            {
                selectedChemistName.append(obj.Chemist_Name!)
            }
        }
    }
    
    func setDefaults()
    {
        self.navigationItem.title = "\(appChemistPlural) List"
        addBackButtonView()
        suffixConfigVal = BL_DCR_Doctor_Visit.sharedInstance.getDoctorSuffixColumnName()
        self.getChemistList()
        self.getSelectedDCRChemist()
        self.searchBarHgtConst.constant = 44
        if isComingFromChemistDay
        {
            let isFlexiChemistAllowed = BL_Common_Stepper.sharedInstance.chemistListAddBtnHidden()
            if isFlexiChemistAllowed == false
            {
                self.addCustomAddButtonToNavigationBar()
            }
        }
        else
        {
            self.addCustomAddButtonToNavigationBar()
        }
    }
    
    private func addCustomAddButtonToNavigationBar()
    {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ChemistsListViewController.addButtonClicked))
        self.navigationItem.rightBarButtonItem = add
    }
    
    @objc func addButtonClicked()
    {
        let sb = UIStoryboard(name: chemistsSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier:AddFlexiChemistVcID) as!
        AddFlexiChemistsViewController
        vc.isChemistDay = self.isComingFromChemistDay
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
