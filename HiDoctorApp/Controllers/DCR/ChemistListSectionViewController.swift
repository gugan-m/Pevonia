//
//  ChemistListSectionViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 11/10/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class ChemistListSectionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    //MARK:- IBOutlet 
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var contentView : UIView!
    @IBOutlet weak var emptyStateView  :UIView!
    @IBOutlet weak var searchBarHgtConst: NSLayoutConstraint!
    
    @IBOutlet weak var emptyStateTitleLbl: UILabel!

    var currentList : [ChemistSectionListHeaderModel] = []
    var searchList : [CustomerMasterModel] = []
    var chemistsList : [CustomerMasterModel] = []
    var selectedChemistName : [String] = []
    var regionCode : String = ""
    var doctorLocalArea: String = EMPTY
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationItem.title = "\(appChemistPlural) List"
        addBackButtonView()
        self.getChemistList()
        self.getSelectedDCRChemist()
        self.searchBarHgtConst.constant = 44
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
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
        return currentList[section].dataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
//        let chemistsObj = currentList[indexPath.section].dataList[indexPath.row]
//        let defaultHeight : CGFloat = 38
//        let chemistNameLblHgt = getTextSize(text: chemistsObj.Customer_Name, fontName: fontSemiBold, fontSize: 15, constrainedWidth: SCREEN_WIDTH - 20).height
//        
//        return defaultHeight + chemistNameLblHgt
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let sectionCell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.ChemistListSectionCell) as! ChemistSectionTableViewCell
        let chemistsObj = currentList[section]
        sectionCell.sectionTitleLbl.text = chemistsObj.sectionTitle
//        sectionCell.sectionContentView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        return sectionCell
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.ChemsitListSectionContentCell, for: indexPath) as! ChemistSectionDetailTableViewCell
        let chemistsObj = currentList[indexPath.section].dataList[indexPath.row]
        
        let chemistsName = chemistsObj.Customer_Name as String
        cell.chemistsNameLbl.text = chemistsName
        let regionName = chemistsObj.Region_Name as String
        cell.chemistsPlaceLbl.text = regionName
        
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
        let chemistObj = currentList[indexPath.section].dataList[indexPath.row]
        let chemistsName = chemistObj.Customer_Name as String
        
        
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
    
    func changeCurrentArray(list : [CustomerMasterModel], type : Int)
    {
        if list.count > 0
        {
            currentList = preareArray(list: list)
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
        currentList.removeAll()
        chemistsList.removeAll()
        
        if regionCode != ""
        {
            chemistsList = BL_DCR_Chemist_Visit.sharedInstance.getChemistMasterList(regionCode: regionCode)!
        }

        changeCurrentArray(list: chemistsList, type: 0)
    }
    
    private func preareArray(list: [CustomerMasterModel]) -> [ChemistSectionListHeaderModel]
    {
        var resultList: [ChemistSectionListHeaderModel] = []
        
        if (list.count > 0)
        {
            var objChemistSection: ChemistSectionListHeaderModel!
            
            if (doctorLocalArea != EMPTY)
            {
                var filtered = list.filter{
                    $0.Local_Area?.uppercased() == doctorLocalArea.uppercased()
                }
                
                if (filtered.count > 0)
                {
                    objChemistSection = ChemistSectionListHeaderModel()
                    objChemistSection.sectionTitle = doctorLocalArea.uppercased()
                    objChemistSection.dataList = filtered
                    
                    resultList.append(objChemistSection)
                }
                
                filtered.removeAll()
                
                filtered = list.filter{
                    $0.Local_Area?.uppercased() != doctorLocalArea.uppercased()
                }
                
                if (filtered.count > 0)
                {
                    objChemistSection = ChemistSectionListHeaderModel()
                    objChemistSection.sectionTitle = "OTHERS"
                    objChemistSection.dataList = filtered
                    
                    resultList.append(objChemistSection)
                }
            }
        }
        
        return resultList
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
    func getSelectedDCRChemist()
    {
        let dcrChemistList = BL_DCR_Chemist_Visit.sharedInstance.getDCRChemistVisit()
        for obj in dcrChemistList!
        {
            selectedChemistName.append(obj.Chemist_Name!)
        }
    }
    @IBAction func addAction(_ sender: Any) {
        let sb = UIStoryboard(name: chemistsSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier:AddFlexiChemistVcID) as!
        AddFlexiChemistsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
}
