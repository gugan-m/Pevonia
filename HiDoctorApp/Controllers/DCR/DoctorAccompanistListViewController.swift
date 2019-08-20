//
//  DoctorAccompanistListViewController.swift
//  HiDoctorApp
//
//  Created by Vignaya on 11/30/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class DoctorAccompanistListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateView: UIView!

    var accompanistList : [DCRAccompanistModel] = []
    var currentList : [DCRAccompanistModel] = []
    var isComingFromModify : Bool = false
    var userSelectedProduct : [String] = []
    var selectedList : NSMutableArray = []
    var selectedTitle : String = ""
    var saveBtn : UIBarButtonItem!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addBackButtonView()
        self.addBarButtonItem()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.getAccompanistList()
        self.getDCRAccSelectedList()
        self.navigationItem.rightBarButtonItem = nil
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("List Count" + String(currentList.count))
        return currentList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let defaultHeight : CGFloat = 58
        let sampleObj = currentList[indexPath.row]
        
        let nameLblHgt = getTextSize(text: sampleObj.Acc_User_Name, fontName: fontSemiBold, fontSize: 15, constrainedWidth: SCREEN_WIDTH - 70).height
        
        return defaultHeight + nameLblHgt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let accompanistCell = tableView.dequeueReusableCell(withIdentifier: doctorAccompanistListCell, for: indexPath) as! DoctorAccompanistListTableViewCell
        let accompanistObj = currentList[indexPath.row]
        let accName = accompanistObj.Employee_Name! as String
        accompanistCell.accompanistNameLbl.text = accName
        accompanistCell.accompanistPosLbl.text = accompanistObj.Acc_User_Name! + " | " + accompanistObj.Acc_User_Type_Name!
        accompanistCell.accompanistAddrLbl.text = accompanistObj.Region_Name
        
        if userSelectedProduct.contains(accompanistObj.Acc_User_Code!) && !isComingFromModify
        {
            accompanistCell.contentView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
            accompanistCell.accSelectImg.image = UIImage(named: "icon-selected")
        }
        else if selectedList.contains(accompanistObj)
        {
            accompanistCell.accSelectImg.image = UIImage(named: "icon-tick")
        }
        else
        {
            accompanistCell.accSelectImg.image = UIImage(named: "icon-unselected")
            accompanistCell.contentView.backgroundColor = UIColor.white
        }
        
        
        return accompanistCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailObj = currentList[indexPath.row]
        if !userSelectedProduct.contains(detailObj.Acc_User_Code!)
        {
            if selectedList.contains(detailObj)
            {
                selectedList.remove(detailObj)
                selectedTitle = String(Int(selectedTitle)! - 1)
            }
            else
            {
                self.selectedList.add(detailObj)
                
                selectedTitle = String(Int(selectedTitle)! + 1)
            }
            
            if selectedTitle != "0"{
                self.navigationItem.rightBarButtonItem = self.saveBtn
            }
            else if isComingFromModify
            {
                self.navigationItem.rightBarButtonItem = self.saveBtn
            }
            setNavigationTitle(Num : selectedTitle)
            self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
        }
    }
    func convertToDetailMaster(list : NSMutableArray) -> [DCRAccompanistModel]
    {
        var selecteAccList : [DCRAccompanistModel] = []
        if list.count > 0
        {
            for obj in list
            {
                selecteAccList.append(obj as! DCRAccompanistModel)
            }
        }
        return selecteAccList
    }
    
    @objc func saveBtnAction()
    {
        
        let selectedProductList = convertToDetailMaster(list: selectedList)
        if isComingFromModify
        {
            BL_DCR_Doctor_Accompanists.sharedInstance.updateDCRDoctorAccompanist(dcrAccompanistList: selectedProductList)
        }
        else
        {
            BL_DCR_Doctor_Accompanists.sharedInstance.insertDCRDoctorAccompanists(dcrAccompanistList:selectedProductList)
        }
        
//        BL_DCR_Doctor_Visit.sharedInstance.insertDoctorVisitTracker(modifiedEntity: Constants.DoctorVisitTrackerEntityIDs.Accompanist_Modified)
        _ = navigationController?.popViewController(animated: false)
    }
    
    func getAccompanistList()
    {
        if !isComingFromModify
        {
            accompanistList = BL_DCR_Doctor_Accompanists.sharedInstance.getDCRAccompanists()
            //print("List Count" + String(accompanistList.count))
            changeCurrentList(list : accompanistList)
        }
        
    }
    func changeCurrentList(list : [DCRAccompanistModel])
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
        saveBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(DoctorAccompanistListViewController.saveBtnAction))
    }
    
    func getDCRAccSelectedList()
    {
        
//        let dcrAccSelectedList = BL_DCR_Doctor_Accompanists.sharedInstance.getDCRSelectedAccompanists()
       // let dcrAccompanistSelectedList = convertToDetailMaster(list: dcrAccSelectedList)
//        for obj in dcrAccSelectedList
//        {
//            if isComingFromModify
//            {
//                selectedList.add(obj)
//            }
//            else
//            {
//                userSelectedProduct.append(obj.Acc_User_Code!)
//            }
//        }
//        selectedTitle = String(dcrAccSelectedList.count)
//        setNavigationTitle(Num : selectedTitle)
//        
//        if isComingFromModify
//        {
//            
//            changeCurrentList(list: dcrAccSelectedList)
//        }
        
    }
    
    func setNavigationTitle(Num : String)
    {
        if Num == "0"{
            self.navigationItem.title = "\(PEV_ACCOMPANIST) List"
        }else{
            self.navigationItem.title = Num + " Selected"
        }
    }


}
