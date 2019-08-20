//
//  ChemistModiyListViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 07/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class ChemistModiyListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
 {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    
    
    var dcrChemistList : [DCRChemistVisitModel] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        addBackButtonView()
        self.getDCRChemistVisit()
        self.navigationItem.title = "\(appChemist) Details"
        emptyStateLbl.text = "No \(appChemist) found"
    }
    
    //MARK: - Table View Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dcrChemistList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let chemistObj = dcrChemistList[indexPath.row]
        let defaultHeight : CGFloat = 48
        let bottomViewHeight : CGFloat = 60 + 10
        let chemistNameLblHgt = getTextSize(text: chemistObj.Chemist_Name, fontName: fontRegular, fontSize: 15, constrainedWidth: SCREEN_WIDTH - 40).height

        return defaultHeight + bottomViewHeight + chemistNameLblHgt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ModifyChemistListCell, for: indexPath) as! ChemistModifyListTableViewCell
        let chemistObj = dcrChemistList[indexPath.row]
        cell.chemistNameLbl.text = chemistObj.Chemist_Name! as String
        let pobAmt  = String(describing: chemistObj.POB_Amount!)
        cell.modifyBtn.tag = indexPath.row
        cell.removeBtn.tag = indexPath.row
        cell.qtyLbl.text = pobAmt
        return cell
    }
    

    @IBAction func modifyBtnAction(_ sender: UIButton) {
        let indexPath = (sender as AnyObject).tag
        let chemistObj = dcrChemistList[indexPath!]
        
        self.navigateToModifyExpensePage(modifyObj: chemistObj)
    }
    
 
    @IBAction func removeBtnAction(_ sender: UIButton) {
        let indexPath = (sender as AnyObject).tag
        let chemistObj = dcrChemistList[indexPath!]
        let chemistName = chemistObj.Chemist_Name! as String
        let alertViewController = UIAlertController(title: nil, message: "Do you want to remove \(appChemist) \"\(chemistName)\"", preferredStyle: UIAlertControllerStyle.alert)
        alertViewController.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { alertAction in
            self.removeExpenseDetails(chemistObbj: chemistObj)
            self.dcrChemistList.remove(at: indexPath!)
            self.reloadTableView()
            showToastView(toastText: "\(appChemist) details removed successfully")
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        alertViewController.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.default, handler: { alertAction in
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    
    func getDCRChemistVisit()
    {
       dcrChemistList =  BL_DCR_Chemist_Visit.sharedInstance.getDCRChemistVisit()!
        self.reloadTableView()
    }
    
    func navigateToModifyExpensePage(modifyObj :DCRChemistVisitModel)
    {
        let sb = UIStoryboard(name: chemistsSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: AddChemistsVisitVcID) as! AddChemistsVisitViewController
        vc.modifyObj = modifyObj
        vc.isComingFromModifyPage = true
       self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func addExpenseBtnAction(_ sender: Any)
    {
        let sb = UIStoryboard(name:addExpenseDetailsSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: AddExpenseVcID)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func removeExpenseDetails(chemistObbj : DCRChemistVisitModel)
    {
       BL_DCR_Chemist_Visit.sharedInstance.deleteDCRChemistVisit(dcrChemistVisitId: chemistObbj.DCR_Chemist_Visit_Id)
    }
    
    func showEmptyStateView(show: Bool)
    {
        self.emptyStateView.isHidden = !show
        self.contentView.isHidden  = show
    }
    
    func reloadTableView()
    {
        if self.dcrChemistList.count > 0
        {
            self.tableView.reloadData()
            self.showEmptyStateView(show: false)
        }
        else
        {
            self.showEmptyStateView(show: true)
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
    
    
    @IBAction func doneBtnAction(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: false)
     }
    
    
    @IBAction func addChemistBtnAction(_ sender: Any)
    {
        self.navigateToChemist()
    }
    
    @objc func backButtonClicked()
    {
        _ = navigationController?.popViewController(animated: false)
    }
    
    func navigateToChemist()
    {
        if BL_DCR_Chemist_Visit.sharedInstance.canUseAccompanistsChemist() && BL_DCR_Accompanist.sharedInstance.getDCRAccompanistListCount() > 0
        {
            let sb = UIStoryboard(name: commonListSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: userListVcID) as! UserListViewController
            vc.navigationScreenName = UserListScreenName.DCRChemistAccompanistList.rawValue
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let sb = UIStoryboard(name: chemistsSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: ChemistsListVcID) as! ChemistsListViewController
            vc.regionCode =  BL_InitialSetup.sharedInstance.regionCode
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }

}
