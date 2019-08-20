//
//  CampaignPlannerListViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 15/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

protocol CampaignPlannerDelegate
{
    func setSelectedCpName(cpModel : CampaignPlannerHeader?)
}
class CampaignPlannerListViewController: UIViewController , UITableViewDelegate , UITableViewDataSource ,UISearchBarDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar : UISearchBar!

    @IBOutlet weak var emptyStateView: UIView!
    
    @IBOutlet weak var contentView: UIView!
    var currentList : [CampaignPlannerHeader] = []
    var searchList : [CampaignPlannerHeader] = []
    var campaignList : [CampaignPlannerHeader] = []
    var delegate : CampaignPlannerDelegate?
    var isFromAccompanistPage : Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.changeCurrentArray(list: campaignList,type: 0)
        self.searchBar.delegate = self
        self.navigationItem.title = "\(appCp) List"
        addBackButtonView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return currentList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CampaignPlannerListCell, for: indexPath)
        let obj = currentList[indexPath.row]
        cell.textLabel?.text = obj.CP_Name
        cell.textLabel?.textColor = UIColor(red: 63/255, green: 63/255, blue: 63/255, alpha: 1.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cpObj = currentList[indexPath.row]
        if isFromAccompanistPage
        {
           if let navigationController = self.navigationController
           {
              let viewControllers = navigationController.viewControllers
                if viewControllers.count >= 3
                {
                     let viewController1 = viewControllers[viewControllers.count - 3]
                    if viewController1.isKind(of: WorkPlaceDetailsViewController.self)
                    {
                        let dcrController = viewController1 as! WorkPlaceDetailsViewController
                        dcrController.cpModelObj = cpObj
                        navigationController.popViewController(animated: false)
                        navigationController.popViewController(animated: true)
                    }
                    else if viewController1.isKind(of: TPWorkPlaceDetailViewController.self)
                    {
                        let tpController = viewController1 as! TPWorkPlaceDetailViewController
                        tpController.cpModelObj = cpObj
                        navigationController.popViewController(animated: false)
                        navigationController.popViewController(animated: true)
                    }
  
                }
           }
        }
        else
        {
      
        delegate?.setSelectedCpName(cpModel: cpObj)
       _ = navigationController?.popViewController(animated: false)
        }
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
        self.changeCurrentArray(list: campaignList,type: 0)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if (searchBar.text?.count)! > 0
        {
            sortCurrentList(searchText: searchBar.text!)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.resignFirstResponder()
    }
    
    func sortCurrentList(searchText:String)
    {
        searchList = campaignList.filter{ (obj) -> Bool in
            let lowerCasedText = searchText.lowercased()
            let cpName = obj.CP_Name.lowercased()
            return cpName.contains(lowerCasedText)
        }
        self.changeCurrentArray(list: searchList,type: 1)
    }
    
    func changeCurrentArray(list : [CampaignPlannerHeader] ,type : Int)
    {
        if list.count > 0
        {
            self.showEmptyStateView(show: false)
            if type == 0
            {
                addDefaultPlannerToList(list: list)
            }
            else
            {
            currentList = list
            }
            self.tableView.reloadData()
        }
        else
        {
            showEmptyStateView(show: true)
        }
    }
    
    func addDefaultPlannerToList(list : [CampaignPlannerHeader])
    {
        currentList = getDefaultCampaignPlanner()
        for obj in list
        {
            currentList.append(obj)
        }
    }
    
    func showEmptyStateView(show:Bool)
    {
        self.emptyStateView.isHidden = !show
        self.contentView.isHidden = show
    }
    
    func getDefaultCampaignPlanner() -> [CampaignPlannerHeader]
    {
        let dict : NSDictionary = [ "CP_Id":0,"CP_Name" : "Select \(appCp)"]
        let campaignObj : CampaignPlannerHeader = CampaignPlannerHeader(dict: dict)
        return [campaignObj]
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
        
}
