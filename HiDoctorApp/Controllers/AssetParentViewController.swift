//
//  AssetParentViewController.swift
//  HiDoctorApp
//
//  Created by Admin on 8/1/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class AssetParentViewController: UIViewController , deleteOrAddShowListDelegate
{
    @IBOutlet weak var storyChildView: UIView!
    @IBOutlet weak var assetChildView: UIView!
    @IBOutlet weak var showListChildView: UIView!
    //@IBOutlet weak var showBottomLbl: UILabel!
    @IBOutlet weak var assetBottomLbl: UILabel!
    @IBOutlet weak var assetIcon : UIImageView!
    @IBOutlet weak var showIcon : UIImageView!
    @IBOutlet weak var storyIcon: UIImageView!
    @IBOutlet weak var storyBottomLbl: UILabel!
    @IBOutlet weak var mandatoryStoryView: UIView!
    @IBOutlet weak var selectionView: UIView!
    
    
    var assetViewController : AssetsListViewController!
    var storyViewController : AssetsMainStoryListViewController!
    var showViewController : AssetShowListViewController!
    var mandStoryViewController : AssetsMainStoryListViewController!
    var currentIndex = 0
    var addBtn : UIBarButtonItem!
    var playBtn : UIBarButtonItem!
    var isForMandatoryView = false
    var isComingFromTP = false
    var isComingFromDigitalAssets = false
    var isComingFromDCR = false
    
    //  @IBOutlet weak var bottomTabViewThreeWidth: NSLayoutConstraint!
    // @IBOutlet weak var bottomTabViewTwoWidth: NSLayoutConstraint!
    // @IBOutlet weak var bottomTabViewoneWidth: NSLayoutConstraint!
    @IBOutlet weak var BottomTabViewThree: UIView!
    // @IBOutlet weak var bottomTabViewone: UIView!
    @IBOutlet weak var bottomTabViewTwo: UIView!
    @IBOutlet weak var bottomTabViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomTabView: UIView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if SwifterSwift().isPad
        {
            storyBottomLbl.text = "Marketing Content"
        }
        else
        {
            storyBottomLbl.text = "Mktg. Content"
        }
        
        storyChildView.isHidden = true
        showListChildView.isHidden = false
        mandatoryStoryView.isHidden = true
        selectionView.isHidden = true
        
        if isComingFromDigitalAssets
        {
            currentIndex = 1
            bottomTabView.isHidden = false
            bottomTabViewHeight.constant = 50
            // bottomTabViewoneWidth.constant = 0
            //  bottomTabViewone.isHidden = true
            
            //  bottomTabViewTwoWidth.constant = self.view.frame.size.width/2
            //  bottomTabViewThreeWidth.constant = self.view.frame.size.width/2
            addAssetListViewController()
        }
        else
        {
            currentIndex = 3
            bottomTabView.isHidden = true
            bottomTabViewHeight.constant = 0
            addShowListViewController()
        }
        
        hideContentController()
        addCustomBackButtonToNavigationBar()
        addBarButtonItem()
        setNavTitle()
        setAssetsIcon()
    }
    
    func checkForMandatoryStoryList()
    {
        let  storyList =  BL_StoryModel.sharedInstance.getMasterStoryList(ismandatory: true)
        
        if storyList.count > 0
        {
            isForMandatoryView = true
            currentIndex = 0
        }
        else if currentIndex == 0
        {
            isForMandatoryView = false
            currentIndex = 3
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // Mark --> For marketing content
        //checkForMandatoryStoryList()
        
        //        if isForMandatoryView{
        //            assetChildView.isHidden = true
        //            mandatoryStoryView.isHidden = false
        //            addMandatoryStoryView()
        //
        //        }else if currentIndex == 3{
        //            mandatoryStoryView.isHidden = true
        //            showListChildView.isHidden = false
        //            addShowListViewController()
        //        }
        
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
    
    func isCurrentDate() -> Bool
    {
        
        let dcrDate = DCRModel.sharedInstance.dcrDateString
        let currentDate = getCurrentDate()
        
        if (dcrDate == currentDate)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    @objc func backButtonClicked()
    {
        let customerObj =  BL_AssetModel.sharedInstance.getCustomerObjByCustomerCode()
        if(BL_MenuAccess.sharedInstance.is_Punch_In_Out_Enabled() && customerObj != nil)
        {
            
            var dcrId = 0
            let convertedDate = getStringInFormatDate(dateString: getCurrentDate())
            let dcrDetail = DBHelper.sharedInstance.getDCRIdforDCRDate(dcrDate: convertedDate)
            if dcrDetail.count > 0
            {
                dcrId = dcrDetail[0].DCR_Id
            }
            let assets = DBHelper.sharedInstance.getAssestAnalyticscheckpunchendtime(customerCode: customerObj!.Customer_Code, customeRegionCode: customerObj!.Region_Code)
            
            if(assets != nil && assets.count > 0 && assets[0].Punch_End_Time == "")
            {
                if(isComingFromDCR)
                {
                    self.navigationController?.popViewController(animated: true)
                }
                else{
                    showpunchendtimealert(name: assets[0].Customer_Name, time: getcurrenttime(), obj: customerObj! , dcrId: dcrId, code: assets[0].Customer_Code )
                }
            }
            else
            {
                if isComingFromTP || isComingFromDigitalAssets || isComingFromDCR
                {
                    self.navigationController?.popViewController(animated: true)
                }
                else
                {
                    setSplitViewRootController(backFromAsset: true, isCustomerMasterEdit: false, customerListPageSouce: Constants.Doctor_List_Page_Ids.Customer_List)
                }
            }
            
        }
        else
        {
            if isComingFromTP || isComingFromDigitalAssets || isComingFromDCR
            {
                self.navigationController?.popViewController(animated: true)
            }
            else
            {
                setSplitViewRootController(backFromAsset: true, isCustomerMasterEdit: false, customerListPageSouce: Constants.Doctor_List_Page_Ids.Customer_List)
            }
        }
    }
    
    func showpunchendtimealert(name: String, time: String , obj: CustomerMasterModel, dcrId:Int, code: String)
    {
        let initialAlert = "Check-out time for " + name + " is " + time + ". You cannot Check-in for other \(appDoctor) until you Check-out for " + name
        //let indexpath = sender.tag
        let alertViewController = UIAlertController(title: "Check Out", message: initialAlert, preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { alertAction in
            if self.isComingFromTP || self.isComingFromDigitalAssets || self.isComingFromDCR
            {
                self.navigationController?.popViewController(animated: true)
            }
            //            else
            //            {
            //                setSplitViewRootController(backFromAsset: true, isCustomerMasterEdit: false, customerListPageSouce: Constants.Doctor_List_Page_Ids.Customer_List)
            //            }
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        alertViewController.addAction(UIAlertAction(title: "Check Out", style: UIAlertActionStyle.default, handler: { alertAction in
            //function
            DBHelper.sharedInstance.updatepunchendtime(Customercode: obj.Customer_Code, regioncode:obj.Region_Code!, time:getStringFromDateforPunch(date: getCurrentDateAndTime()))
            let list = DBHelper.sharedInstance.getDCRDoctorVisitid(dcrId: dcrId, doctorcode: code)
            var doctorvisitid = 0
            if (list != nil && list.count > 0 )
            {
                doctorvisitid = list[0].DCR_Doctor_Visit_Id
            }
            self.updatepunchout(dcrID: dcrId, visitid: doctorvisitid, doctorcode: code )
            BL_DoctorList.sharedInstance.punchInTime = ""
            if self.isComingFromTP || self.isComingFromDigitalAssets || self.isComingFromDCR
            {
                self.navigationController?.popViewController(animated: true)
            }
            else
            {
                setSplitViewRootController(backFromAsset: true, isCustomerMasterEdit: false, customerListPageSouce: Constants.Doctor_List_Page_Ids.Customer_List)
            }
            alertViewController.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func updatepunchout(dcrID: Int, visitid: Int, doctorcode: String)
    {
        let time = getStringFromDateforPunch(date: getCurrentDateAndTime())
        executeQuery(query: "UPDATE \(TRAN_DCR_DOCTOR_VISIT) SET Punch_End_Time = '\(time)', Punch_Status = 2 WHERE DCR_Id = \(dcrID) AND Doctor_Code = '\(doctorcode)'")
    }
    
    func addBarButtonItem()
    {
        addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToShowList))
        
        let rightBarButton = UIButton(type: UIButtonType.custom)
        rightBarButton.addTarget(self, action: #selector(navigateToPlayList), for: UIControlEvents.touchUpInside)
        rightBarButton.setImage(UIImage(named: "icon-asset-play"), for: .normal)
        rightBarButton.sizeToFit()
        playBtn = UIBarButtonItem(customView: rightBarButton)
    }
    
    func setNavTitle()
    {
        var title = ""
        self.navigationItem.rightBarButtonItems = nil
        
        if currentIndex == 0
        {
            title = "Marketing Content"
            self.navigationItem.rightBarButtonItem = addBtn
        }
        else
        {
            title = BL_DoctorList.sharedInstance.doctorTitle
        }
        
        if currentIndex == 3
        {
            if BL_AssetModel.sharedInstance.showList.count > 0{
                self.navigationItem.rightBarButtonItems = [addBtn,playBtn]
            }
            else
            {
                self.navigationItem.rightBarButtonItems = [addBtn]
            }
        }
        if isComingFromDigitalAssets
        {
            title = PEV_DIGITAL_ASSETS
            
        }
        
        self.navigationItem.title = title
    }
    
    func addMandatoryStoryView()
    {
        let asset_sb = UIStoryboard(name: Constants.StoaryBoardNames.AssetsListSb, bundle: nil)
        let storyVC = asset_sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.AssetsMainStoryVcID) as! AssetsMainStoryListViewController
        mandStoryViewController = storyVC
        storyVC.isComingFromMandatory = true
        addNewChildController(content: storyVC)
    }
    
    func addAssetListViewController()
    {
        if assetViewController == nil
        {
            let asset_sb = UIStoryboard(name: Constants.StoaryBoardNames.AssetsListSb, bundle: nil)
            assetViewController = asset_sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.AssetsListVcID) as! AssetsListViewController
            assetViewController.isComingFromDigitalAssets = isComingFromDigitalAssets
            addNewChildController(content: assetViewController)
        }
    }
    
    func addStoryListViewController()
    {
        if storyViewController == nil
        {
            let asset_sb = UIStoryboard(name: Constants.StoaryBoardNames.AssetsListSb, bundle: nil)
            storyViewController = asset_sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.AssetsMainStoryVcID) as! AssetsMainStoryListViewController
            storyViewController.isComingFromMandatory = false
            storyViewController.isComingFromDigitalAssets = isComingFromDigitalAssets
            addNewChildController(content: storyViewController)
        }
    }
    
    func addShowListViewController()
    {
        if showViewController == nil
        {
            let asset_sb = UIStoryboard(name: Constants.StoaryBoardNames.AssetsListSb, bundle: nil)
            let showList_vc = asset_sb.instantiateViewController(withIdentifier: AssetShowListVcID) as! AssetShowListViewController
            showViewController =  showList_vc
            showViewController.isComingFromDigitalAssets = isComingFromDigitalAssets
            showViewController.delegate = self
            addNewChildController(content: showList_vc)
        }
        else
        {
            showViewController.setAssetDetails()
            showViewController.tableView.reloadData()
        }
    }
    
    func didDeleteOrAddTheShowList()
    {
        setNavTitle()
    }
    
    @objc func navigateToPlayList()
    {
        if currentIndex == 0
        {
            mandStoryViewController.playLatestStoryList()
        }
        else if currentIndex == 3
        {
            showViewController.navigateToPlayList()
        }
    }
    
    @objc func addToShowList()
    {
        let asset_sb = UIStoryboard(name: Constants.StoaryBoardNames.AssetsListSb, bundle: nil)
        let assetVC = asset_sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.AssetsListVcID) as! AssetsListViewController
        assetVC.isComingForSelection = true
        self.navigationController?.pushViewController(assetVC, animated: true)
        
        // MARK -> Requirement changed for only asset
        //        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        //
        //        let assetAction = UIAlertAction(title: "Asset List", style: .default, handler:{
        //            (alert: UIAlertAction) -> Void in
        //            let asset_sb = UIStoryboard(name: Constants.StoaryBoardNames.AssetsListSb, bundle: nil)
        //            let assetVC = asset_sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.AssetsListVcID) as! AssetsListViewController
        //            assetVC.isComingForSelection = true
        //            self.navigationController?.pushViewController(assetVC, animated: true)
        //
        //
        //        })
        //        actionSheetController.addAction(assetAction)
        //
        //        let storyAction = UIAlertAction(title: "Marketing Content", style: .default, handler: {
        //            (alert: UIAlertAction) -> Void in
        //
        //            let asset_sb = UIStoryboard(name: Constants.StoaryBoardNames.AssetsListSb, bundle: nil)
        //            let storyVC = asset_sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.AssetsMainStoryVcID) as! AssetsMainStoryListViewController
        //            storyVC.isComingFromMandatory = false
        //            storyVC.isComingForSelection = true
        //            storyVC.isComingFromDigitalAssets = self.isComingFromDigitalAssets
        //            self.navigationController?.pushViewController(storyVC, animated: true)
        //        })
        //        actionSheetController.addAction(storyAction)
        //
        //
        //
        //        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:{
        //            (alert: UIAlertAction) -> Void in
        //
        //        })
        //        actionSheetController.addAction(cancelAction)
        //
        //        if SwifterSwift().isPhone
        //        {
        //            self.present(actionSheetController, animated: true, completion: nil)
        //        }
        //        else
        //        {
        //            if let currentPopoverpresentioncontroller = actionSheetController.popoverPresentationController{
        //                currentPopoverpresentioncontroller.sourceView = self.view
        //                currentPopoverpresentioncontroller.sourceRect = CGRect(x:self.view.frame.size.width - 125 ,y:-45, width:100,height:100)
        //                currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.up
        //                self.present(actionSheetController, animated: true, completion: nil)
        //            }
        //        }
        
    }
    
    @IBAction func didTapTabBarIcons(_ sender: Any)
    {
        let menuBtn = sender as! UIButton
        
        if (menuBtn).tag == 1 && currentIndex != 1
        {
            currentIndex = 1
            addAssetListViewController()
            
        }
        else if menuBtn.tag == 2 && currentIndex != 2
        {
            currentIndex = 2
            addStoryListViewController()
            
        }
        else if menuBtn.tag == 3 && currentIndex != 3
        {
            currentIndex = 3
            
            if assetViewController != nil
            {
                if assetViewController.selectedList.count > 0
                {
                    assetViewController.showListBtnAction()
                    assetViewController.setAssetDetails()
                }
            }
            addShowListViewController()
        }
        
        hideContentController()
        setNavTitle()
        setAssetsIcon()
    }
    
    private func setAssetsIcon()
    {
        var assetImage : String = "icon-asset-inactive"
        var showImage : String = "icon-show-inactive"
        var storyImage : String = "icon-story-inactive"
        
        var assetTextColor : UIColor = UIColor.darkGray
        var showTextColor : UIColor = UIColor.darkGray
        var storyTextColor : UIColor = UIColor.darkGray
        
        if currentIndex == 1
        {
            assetImage = "icon-asset-active"
            assetTextColor = UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1.0)
        }
        else if currentIndex == 2
        {
            storyImage = "icon-story-active"
            storyTextColor =  UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1.0)
        }
        else if currentIndex == 3
        {
            showImage = "icon-show-active"
            showTextColor =  UIColor(red: 63/255, green: 81/255, blue: 181/255, alpha: 1.0)
        }
        
        self.assetIcon.image = UIImage(named: assetImage)
        //  self.showIcon.image = UIImage(named: showImage)
        self.storyIcon.image = UIImage(named: storyImage)
        
        self.assetBottomLbl.textColor = assetTextColor
        self.storyBottomLbl.textColor = storyTextColor
        // self.showBottomLbl.textColor = showTextColor
        
    }
    
    func hideContentController()
    {
        if currentIndex == 0
        {
            self.mandatoryStoryView.isHidden = true
            currentIndex = 1
        }
        
        if currentIndex == 1
        {
            self.assetChildView.isHidden = false
            self.storyChildView.isHidden = true
            self.showListChildView.isHidden = true
            
        }
        else if currentIndex == 2
        {
            self.assetChildView.isHidden = true
            self.storyChildView.isHidden = false
            self.showListChildView.isHidden = true
        }
        else if currentIndex == 3
        {
            self.assetChildView.isHidden = true
            self.storyChildView.isHidden = true
            self.showListChildView.isHidden = false
        }
    }
    
    func addNewChildController(content : UIViewController)
    {
        var  childView = UIView()
        
        if currentIndex == 0
        {
            childView = self.mandatoryStoryView
        }
        else if currentIndex == 1
        {
            childView = self.assetChildView
        }else if currentIndex == 2
        {
            childView = self.storyChildView
        }else if currentIndex == 3
        {
            childView = self.showListChildView
        }
        // Change the size of  view controller
        
        let frame = CGRect(x: 0, y: 0, width: childView.frame.size.width, height: childView.frame.size.height)
        content.view.frame = frame
        self.addChildViewController(content)
        childView.addSubview(content.view)
        self.didMove(toParentViewController: self)
    }
    
    func navigateToNextScreen(stoaryBoard:String,viewController:String)
    {
        let sb = UIStoryboard(name: stoaryBoard, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: viewController)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
