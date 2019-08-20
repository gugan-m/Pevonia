//
//  AccompanistListViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 28/08/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class AccompanistListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    //MARK:- IBOutlet
    @IBOutlet weak var accTableView: UITableView!
    
    //MARK:- Variable
    var accList:[UserMasterWrapperModel] = []
    var titleText = "Choose Accompanist"
    
    //MARK:- View Controller LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        accList = BL_TPStepper.sharedInstance.getSelectedAccompanists(tp_Entry_Id: TPModel.sharedInstance.tpEntryId)
        addBackButtonView()
        self.title = titleText
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- TableView Datasource and Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = accTableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.TPCopyTourPlanAccListMainCell, for: indexPath) as! TPCopyTourPlanAccompanistTableViewCell
       let cellData = accList[indexPath.row].userObj
        cell.accompanistNameLbl.text = cellData.Employee_name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: Constants.StoaryBoardNames.TPCopyTourPlanSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.TPCopyTourPlanVCID) as! TPCopyTourPlannerViewController
        let cellData = accList[indexPath.row].userObj
        vc.accDataArray = cellData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK:- Updating Views
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
