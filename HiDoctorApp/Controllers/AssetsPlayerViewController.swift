//
//  AssetsPlayerViewController.swift
//  HiDoctorApp
//
//  Created by Admin on 6/4/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class AssetsPlayerViewController: UIViewController , ReaderViewControllerDelegate{
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var navigationView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var assetsChildView: UIView!
    
    @IBOutlet weak var childViewHeader: UILabel!
    
    @IBOutlet weak var childViewCloseBtn: UIButton!
    
    @IBOutlet weak var assetsChildTableView: UITableView!
    
    @IBOutlet weak var previousBtn: UIButton!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var settingBtn: UIButton!
    
    @IBOutlet weak var autoPlayBtn: UIButton!
    @IBOutlet weak var gestureContainerView: UIView!
    @IBOutlet weak var gestureView: UIView!
    
    @IBOutlet weak var gestureCloseBtn: UIButton!
    
    @IBOutlet weak var smileyImgVw: UIImageView!
    
    @IBOutlet weak var feedBackBtn: UIButton!
    
    @IBOutlet weak var seetingBtnLeadingCnst: NSLayoutConstraint!
    
    @IBOutlet weak var previewContentView: UIView!
    
    @IBOutlet weak var previewBtn: UIButton!
    
    @IBOutlet weak var previewLabel: UILabel!
    
    @IBOutlet weak var previewCloseBtn: UIButton!
    
    @IBOutlet weak var previewContainerView: UIView!
    
    @IBOutlet weak var previewWdCnst: NSLayoutConstraint!
    
    @IBOutlet weak var simileyBtnHgtCnst: NSLayoutConstraint!
    
    @IBOutlet weak var simileyBtnWdhCnst: NSLayoutConstraint!
    
    @IBOutlet weak var ratingBtn1: UIButton!
    @IBOutlet weak var ratingBtn2: UIButton!
    @IBOutlet weak var ratingBtn3: UIButton!
    @IBOutlet weak var ratingBtn4: UIButton!
    
    @IBOutlet weak var ratingBtn5: UIButton!
    
    @IBOutlet weak var gestureRatingView: UIView!
    
    @IBOutlet weak var ratingBtn1LdgCnst: NSLayoutConstraint!
    
    @IBOutlet weak var ratingBtn2LdgCnst: NSLayoutConstraint!
    
    @IBOutlet weak var ratingBtn3LdgCnst: NSLayoutConstraint!
    
    @IBOutlet weak var ratingBtn4LdgCnst: NSLayoutConstraint!
    
    @IBOutlet weak var navigationCornerButton : UIView!
    var controllersList = [AssetsPlayerChildViewController]()
    var pageVC = UIPageViewController()
    var isPreview : Int = 0
    var assetsArray = [AssetsPlayListModel]()
    var assetObj : AssetHeader!
    var currentChildVC :AssetsPlayerChildViewController!
    var tableVIewSelecionArray = [Bool]()
    var assetStartTimer : Timer?
    var assetEndTimer : Timer?
    var timerIndex = 0
    var didScreenOrientationChange = false
    let gestureRecognizer = CustomGestureRecognizer()
    var isGoingToFeedback = false
    var mc_StoryId : NSNumber = 0
    var storyObj = AssetMandatoryListModel()
    var storyArray =  [AssetMandatoryListModel]()
    var isComingFromStory = false
    var isComingFromMandatoryStory = false
    var isComingFromShowList = false
    var currentStoryIndex = 0
    var showList = [ShowListModel]()
    var blinkStatus = true
    var ratingBtnArray = [UIButton]()
    var lastSelBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        settingBtn.isHidden = true
    
        removeVersionToastView()
        // Create page view controller
        self.pageVC = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController
        self.pageVC.dataSource = self
        self.pageVC.delegate = self
        lastSelBtn.tag = 0

        loadTheDefaultState()
        let tap = UITapGestureRecognizer(target: self, action: #selector (self.respondToTap))
        self.contentView.addGestureRecognizer(tap)
        
        let childViewTap = UITapGestureRecognizer(target: self, action: #selector (self.hideTableView))
        childViewTap.delegate = self
        self.assetsChildView.addGestureRecognizer(childViewTap)
        
        smileyImgVw.isHidden = true
        if isPreview != 1{
           // addGesturesToView()
        }else{
            gestureContainerView.isHidden = true
            feedBackBtn.isHidden = true
            seetingBtnLeadingCnst.constant = -20
            
        }
        gestureContainerView.isHidden = true
        previewContentView.layer.cornerRadius = 10
        previewContentView.layer.masksToBounds = true
        previewContainerView.isHidden = true
        
        if SwifterSwift().isPhone{
            previewWdCnst.constant = 70
            previewBtn.titleLabel?.font =  UIFont(name: fontBold, size: 17.0)
        }else{
            simileyBtnWdhCnst.constant = 100
            simileyBtnHgtCnst.constant = 100
            ratingBtn1LdgCnst.constant = 40
            ratingBtn2LdgCnst.constant = 40
            ratingBtn3LdgCnst.constant = 40
            ratingBtn4LdgCnst.constant = 40

        }
        
        if isPreview == 1{
            previewBtn.isHidden = false
        }else{
            previewWdCnst.constant = 0
            previewBtn.isHidden = true
        }

        
        previewLabel.text = "This is for preview purpose, \(appDoctor) details will not be captured"
        
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.hideTheNavigationView), userInfo: nil, repeats: false)
        
        ratingBtnArray.append(ratingBtn1)
        ratingBtnArray.append(ratingBtn2)
        ratingBtnArray.append(ratingBtn3)
        ratingBtnArray.append(ratingBtn4)
        ratingBtnArray.append(ratingBtn5)

        self.navigationView.isHidden = true
        self.navigationCornerButton.layer.cornerRadius = 7
        navigationCornerButton.layer.masksToBounds = true

    }
    
    func loadTheDefaultState(){
        
        checkForObjectType()
        initializeViewControllers()
        loadTableView()
        initializePageViewController()
        checkForAutoPlayAction()
        
        
        
        if AssetsDataManager.sharedManager.currentIndex == 0 {
            previousBtn.isHidden = true
        }else if AssetsDataManager.sharedManager.currentIndex == self.controllersList.count-1{
            nextBtn.isHidden = true
        }
        
        if AssetsDataManager.sharedManager.docType == 2 || AssetsDataManager.sharedManager.docType == 3 || AssetsDataManager.sharedManager.docType == 5 {
            previousBtn.isHidden = true
            nextBtn.isHidden = true
        }
        
    }
    
    @objc func respondToTap(){
        
        self.navigationView.isHidden = !self.navigationView.isHidden
        self.navigationCornerButton.isHidden = !self.navigationView.isHidden
        
//        self.navigationView.isHidden = !self.navigationView.isHidden
//        previousBtn.isHidden = self.navigationView.isHidden
//        nextBtn.isHidden = self.navigationView.isHidden
//        assetsChildView.isHidden = true
//        if AssetsDataManager.sharedManager.currentIndex == 0 {
//            previousBtn.isHidden = true
//        }else if AssetsDataManager.sharedManager.currentIndex == controllersList.count - 1{
//            nextBtn.isHidden = true
//        }
//
//        if AssetsDataManager.sharedManager.docType == 2 {
//            previousBtn.isHidden = true
//            nextBtn.isHidden = true
//            self.navigationView.isHidden =  AssetsDataManager.sharedManager.isSubviewsHidden
//
//        }
//        if AssetsDataManager.sharedManager.docType == 3 || AssetsDataManager.sharedManager.docType == 5{
//            previousBtn.isHidden = true
//            nextBtn.isHidden = true
//        }
//
//        if AssetsDataManager.sharedManager.docType == 5{
//            // self.navigationView.isHidden = false
//            Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.hideTheNavigationView), userInfo: nil, repeats: false)
//
//        }
//        assetStartTimer?.invalidate()
//        assetEndTimer?.invalidate()
//
//        Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.hideTheNavigationView), userInfo: nil, repeats: false)
//        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.blinkThePreviewBtn), userInfo: nil, repeats: true)
    }
    
    @objc func  hideTheNavigationView()  {
        
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {() -> Void in
            self.navigationView.isHidden = true
            self.navigationCornerButton.isHidden = false
            
        }, completion: { _ in })
        
        previousBtn.isHidden = true
        nextBtn.isHidden = true
    }
    
    @objc func hideTableView()  {
        self.assetsChildView.isHidden = true
    }
    
    @IBAction func navigationShowBut(_ sender: Any) {
        
        self.navigationCornerButton.isHidden = true
        self.navigationView.isHidden = !self.navigationView.isHidden
        previousBtn.isHidden = self.navigationView.isHidden
        nextBtn.isHidden = self.navigationView.isHidden
        assetsChildView.isHidden = true
        if AssetsDataManager.sharedManager.currentIndex == 0 {
            previousBtn.isHidden = true
        }else if AssetsDataManager.sharedManager.currentIndex == controllersList.count - 1{
            nextBtn.isHidden = true
        }
        
        if AssetsDataManager.sharedManager.docType == 2 {
            previousBtn.isHidden = true
            nextBtn.isHidden = true
          //  self.navigationView.isHidden =  AssetsDataManager.sharedManager.isSubviewsHidden
            
        }
        if AssetsDataManager.sharedManager.docType == 3 || AssetsDataManager.sharedManager.docType == 5{
            previousBtn.isHidden = true
            nextBtn.isHidden = true
        }
        
        if AssetsDataManager.sharedManager.docType == 5{
            // self.navigationView.isHidden = false
            Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.hideTheNavigationView), userInfo: nil, repeats: false)
            
        }
        assetStartTimer?.invalidate()
        assetEndTimer?.invalidate()

    }
    
    @IBAction func didTapPreviewBtn(_ sender: Any) {
        
        self.previewContainerView.isHidden = false
        let frame = self.previewContainerView.frame
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn, animations: {() -> Void in
            self.previewContainerView?.frame = CGRect(x: frame.origin.x, y: frame.origin.y + 50, width: frame.width  , height: frame.height)
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {() -> Void in
                self.previewContainerView?.frame = frame
            }, completion: {(_ finished: Bool) -> Void in
            })
        })
    }
    
    @IBAction func didTapPreviewCloseBtn(_ sender: Any) {
        self.previewContainerView.isHidden = true

    }
    
    func blinkThePreviewBtn(){
        
        if blinkStatus{
            previewBtn.setTitleColor(UIColor.white, for: .normal)
            blinkStatus = false
        }else{
            previewBtn.setTitleColor(UIColor.red, for: .normal)
            blinkStatus = true
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        URLCache.shared.removeAllCachedResponses()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        self.navigationController?.isNavigationBarHidden = true
        isGoingToFeedback = false
        self.navigationCornerButton.isHidden = false
        }
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransition(to: size, with: coordinator)
        let frame = CGRect(x: 0, y: 0, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)
        self.pageVC.view.frame = frame
        removeToastView()
        didScreenOrientationChange = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        if !isGoingToFeedback{
            for assetChildVC in controllersList{
                if assetChildVC.imageVw != nil{
                    assetChildVC.imageVw.removeFromSuperview()
                }
            }
        }
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    
    func checkForObjectType(){
        
        if isComingFromStory{
            mc_StoryId = storyObj.storyObj.Story_Id  ?? 0
            let assetList = storyObj.assetList
            storyObj.storyObj.No_Of_Assets = assetList?.count
            var firstIndex = true
            for assetHeader in assetList!{
                
                let playList = AssetsPlayListModel()
                playList.assetObj = assetHeader
                playList.assetObj.mc_StoryId = Int(mc_StoryId)
                playList.isStoryEnabled = true
                playList.storyObj = storyObj.storyObj
                if firstIndex{
                    firstIndex = false
                    playList.isFirstAssetInStory = true
                }
                assetsArray.append(playList)
                
            }
            
            if isComingFromMandatoryStory{
                self.assetsArray.removeAll()
                var firstIndex = true

                for value in  self.storyArray {
                    
                    mc_StoryId = value.storyObj.Story_Id  ?? 0
                    let assetList = value.assetList
                    value.storyObj.No_Of_Assets = assetList?.count
                    for assetHeader in assetList!{
                        
                        let playList = AssetsPlayListModel()
                        playList.assetObj = assetHeader
                        playList.assetObj.mc_StoryId = Int(mc_StoryId)
                        playList.isStoryEnabled = true
                        playList.storyObj = value.storyObj
                        if firstIndex{
                            firstIndex = false
                            playList.isFirstAssetInStory = true
                        }
                        assetsArray.append(playList)
                        
                    }
                    
                }
            }
        }
        if isComingFromShowList{
            for showListObj in showList{
                
                if showListObj.storyEnabled{
                    
                    mc_StoryId = showListObj.storyId ?? 0
                    let assetList = showListObj.storyObj.assetList
                    showListObj.storyObj.storyObj.No_Of_Assets = assetList?.count
                    var firstIndex = true
                    for assetHeader in assetList!{
                        
                        let playList = AssetsPlayListModel()
                        playList.assetObj = assetHeader
                        playList.assetObj.mc_StoryId = Int(mc_StoryId)
                        playList.isStoryEnabled = true
                        playList.storyObj = showListObj.storyObj.storyObj
                        if firstIndex{
                            firstIndex = false
                            playList.isFirstAssetInStory = true
                        }
                        assetsArray.append(playList)
                        
                    }
                    
                }else{
                    let playList = AssetsPlayListModel()
                    playList.assetObj = showListObj.assetDetail
                    assetsArray.append(playList)
                }
            }
            
        }
        
        
    }
    
    
    func initializeViewControllers(){
        
        var index = 0
        controllersList.removeAll()
        for value in assetsArray{
            
            let assetChildVC = self.storyboard?.instantiateViewController(withIdentifier: "AssetsPlayerChildVCID") as! AssetsPlayerChildViewController
            assetChildVC.currentAssetObj = value
            assetChildVC.index = index
            assetChildVC.isPreview = isPreview
            assetChildVC.isComingFromMandatoryStory = isComingFromMandatoryStory
            assetChildVC.delegate = self
            controllersList.append(assetChildVC)
            index = index + 1
        }
        
        AssetsDataManager.sharedManager.childControllersList = controllersList
        
    }
    
    
    func loadTableView()  {
        self.assetsChildTableView.delegate = self
        self.assetsChildTableView.dataSource = self
        self.assetsChildTableView.register(UINib(nibName: Constants.NibNames.AssetsChildTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.TableViewCellIdentifier.AssetsPlayerChildCell)
        
        self.assetsChildView.isHidden = true
    }
    
    
    func initializePageViewController()  {
        var index = 0
        var currentIndex = 0
        
        if self.assetObj != nil{
            for value in self.assetsArray{
                if value.assetObj.daCode == self.assetObj.daCode {
                    if self.storyObj.storyObj != nil{
                        if value.isStoryEnabled  {
                            if  value.storyObj.Story_Id == self.storyObj.storyObj.Story_Id{
                                currentIndex = index
                                break
                            }
                        }
                    }else if value.storyObj == nil{
                        currentIndex = index
                        break
                    }
                }
                index = index + 1
                
            }
        }
        
        tableVIewSelecionArray.removeAll()
        for _ in assetsArray{
            
            tableVIewSelecionArray.append(false)
        }
        if assetsArray.count > 0{
            tableVIewSelecionArray[currentIndex] = true
        }
        
        
        
        let  startingViewController = self.viewControllerAtIndex(index: currentIndex)
        let viewControllers = [startingViewController]
        
        self.pageVC.setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
        
        // Change the size of page view controller
        let frame = CGRect(x: 0, y: 0, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)
        self.pageVC.view.frame = frame
        
        self.addChildViewController(pageVC)
        self.contentView.addSubview(pageVC.view)
        self.pageVC.didMove(toParentViewController: self)

        for v in pageVC.view.subviews{
            if v is UIScrollView{
                (v as! UIScrollView).delegate = self
            }
        }
    }
    
    func removePageViewControllers(){
        
        self.pageVC.setViewControllers([], direction: .forward, animated: false, completion: nil)
    }
    

    func checkForAutoPlayAction(){
        autoPlayBtn.isHidden = true
        if UserDefaults.standard.bool(forKey:"autoplay"){
            autoPlayBtn.tag = 1
            autoPlayBtn.setImage((UIImage.init(named: "icon-autoplay-ON")), for: .normal)
            
        }else{
            autoPlayBtn.tag = 0
            autoPlayBtn.setImage((UIImage.init(named: "icon-autoplay-OFF")), for: .normal)
        }

    }
    
    @IBAction func didTapTheListBtn(_ sender: Any) {
        previousBtn.isHidden = true
        nextBtn.isHidden = true
        var i = 0
        for _ in tableVIewSelecionArray{
             tableVIewSelecionArray[i] = false
            i = i + 1
        }
        tableVIewSelecionArray[AssetsDataManager.sharedManager.currentIndex] = true
        self.assetsChildTableView.reloadData()
        self.assetsChildTableView.scrollToRow(at: IndexPath(row: AssetsDataManager.sharedManager.currentIndex, section: 0), at: .top, animated: false)
        self.assetsChildView.isHidden = false

    }
    
    
    @IBAction func didTapAutoPlayBtn(_ sender: Any) {
        
        if autoPlayBtn.tag == 1{
            autoPlayBtn.tag = 0
            autoPlayBtn.setImage((UIImage.init(named: "icon-autoplay-OFF")), for: .normal)
            UserDefaults.standard.set(false, forKey: "autoplay")

        }else{
            autoPlayBtn.tag = 1
            autoPlayBtn.setImage((UIImage.init(named: "icon-autoplay-ON")), for: .normal)
            UserDefaults.standard.set(true, forKey: "autoplay")
            if AssetsDataManager.sharedManager.docType == 1{
                startEndTimerForCurrentAssets(index: AssetsDataManager.sharedManager.currentIndex)
            }
            
        }
        
    }
    
    @IBAction func didTapSettingsBtn(_ sender: Any) {
        
        let  currentViewController = self.viewControllerAtIndex(index:  AssetsDataManager.sharedManager.currentIndex) as AssetsPlayerChildViewController
        currentViewController.actionForPDF()
       
        
    }
   
    @IBAction func didTapFeedbackBtn(_ sender: Any) {
        
        isGoingToFeedback = true
        let currentCusAndAssetObj = DoctorFeedbackModel()
        currentCusAndAssetObj.customerObj = BL_AssetModel.sharedInstance.getCustomerObjByCustomerCode()
        currentCusAndAssetObj.assetObj = AssetsDataManager.sharedManager.currentAssetObj.assetObj
        
        let sb = UIStoryboard(name: CustomerFBSB, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: CustomerFBVCID) as! CustomerFeedbackViewController
        vc.customerAndAssetObj = currentCusAndAssetObj
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    @IBAction func didTapCloseBtn(_ sender: Any) {
        
        self.assetsChildView.isHidden = true
    }
    
    @IBAction func didTapBackBtn(_ sender: Any)
    {
        
        self.navigationController?.isNavigationBarHidden = false
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        AssetsDataManager.sharedManager.isStoryTracked = false

        self.navigationController?.popViewController(animated: false)

    }
    
    
    @IBAction func didTapNextBtn(_ sender: Any) {
        didTapNext()
    }
    
    @IBAction func didTapPreviousBtn(_ sender: Any) {
        didTapPrevious()
    }
    
    
    func dismiss(_ viewController: ReaderViewController!) {
        self.navigationController?.popViewController(animated: false
        )
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func didTapGestureCloseBtn(_ sender: Any) {
        insertTheRating()
        gestureContainerView.isHidden = true
    }
    
    @IBAction func didTapRatingsBtn(_ sender: Any) {
        
        for button in ratingBtnArray{
            button.layer.removeAllAnimations()
            button.setImage(getSelectedSimileyIconForRating(value: button.tag), for: .normal)
        }

        let ratingBtn = sender as! UIButton
        lastSelBtn = ratingBtn
        ratingBtn.setImage(getSimileyIconForRating(value: ratingBtn.tag), for: .normal)
        ratingBtn.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
        UIView.animate(withDuration: 1, animations: {() -> Void in
            ratingBtn.transform = CGAffineTransform.identity.scaledBy(x: 2, y: 2)
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 1, animations: {() -> Void in
                ratingBtn.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)

            }, completion: {(_ finished: Bool) -> Void in
                UIView.animate(withDuration: 15, animations: {
                    ratingBtn.transform = CGAffineTransform.identity

                }, completion: {
                    (value: Bool) in
                    if ratingBtn == self.lastSelBtn {
                    
                        self.insertTheRating()
                        self.gestureContainerView.isHidden = true
                    }
                })
            })
        })
        
       
    }
    
    func insertTheRating(){
        if lastSelBtn.tag != 0{
            let  customerObj = BL_AssetModel.sharedInstance.getCustomerObjByCustomerCode()
            let  assetObj = AssetsDataManager.sharedManager.currentAssetObj.assetObj
            var assetDict = NSDictionary()
            assetDict = ["DA_Code": assetObj?.daCode ?? "0" , "Region_Code": getRegionCode() , "Customer_Code" : customerObj?.Customer_Code ?? "0", "User_Code" : getUserCode() , "DA_Type": assetObj?.docType ?? 0 , "Rating" : 0 , "User_Like" : lastSelBtn.tag , "Feedback" :  "" , "Is_Synced" : 0 ,"Time_Zone": getCurrentTimeZone() , "Current_Date" : getCurrentDate() , "Current_Datetime" : getCurrentDateAndTimeString() ]
            
            DBHelper.sharedInstance.insertAssetFeedback(dict: assetDict)
            lastSelBtn = UIButton()
            lastSelBtn.tag = 0
        }
    }
    
 
    func getSimileyIconForRating(value : Int) -> UIImage  {
        
        switch value {
        case 1:
            return UIImage(named: "icon-verypoor")!
        case 2:
            return UIImage(named: "icon-poor")!
        case 3:
            return UIImage(named: "icon-average")!
        case 4:
            return UIImage(named: "icon-good")!
        case 5:
            return UIImage(named: "icon-excellent")!
        default:
            return UIImage(named: "icon-verypoor")!
        }
        
    }
    
    
    func getSelectedSimileyIconForRating(value : Int) -> UIImage  {
        
        switch value {
        case 1:
            return UIImage(named: "icon-verypoor-grey")!
        case 2:
            return UIImage(named: "icon-poor-grey")!
        case 3:
            return UIImage(named: "icon-average-grey")!
        case 4:
            return UIImage(named: "icon-good-grey")!
        case 5:
            return UIImage(named: "icon-excellent-grey")!
        default:
            return UIImage(named: "icon-verypoor-grey")!
        }
    }
    
    func addGesturesToView(){
  
        
        gestureRecognizer.addTarget(self, action: #selector(gestureDetected(recognizer:)))
        gestureView.addGestureRecognizer(gestureRecognizer)
        gestureContainerView.isHidden = true
        gestureView.layer.borderColor = UIColor.black.cgColor
        gestureView.layer.borderWidth = 4.0
        
    }
    
    // MARK :--  For reaction gestures
    // MARK :- Requiremnet Changed

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event) // Call the super.
        
//        self.gestureView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
//        let path = UIBezierPath()
//        
//        let currentPoint = touches.first?.location(in: gestureView)
//        let previousPoint = touches.first?.previousLocation(in: gestureView)
//        
//        path.move(to: currentPoint!)
//        path.addLine(to: previousPoint!)
//        
//        //design path in layer
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = path.cgPath
//        shapeLayer.strokeColor = UIColor.red.cgColor
//        shapeLayer.lineWidth = 10.0
//        
//        gestureView.layer.addSublayer(shapeLayer)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
//        
//        if !self.gestureContainerView.isHidden{
//            self.gestureView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
//            self.gestureContainerView.isHidden = true
//            showToastViewWithShortTime(toastText: "invalid")
//        }
        
    }
    
    @objc func gestureDetected(recognizer : CustomGestureRecognizer){
        
        let  customerObj = BL_AssetModel.sharedInstance.getCustomerObjByCustomerCode()
        let  assetObj = AssetsDataManager.sharedManager.currentAssetObj.assetObj
        var assetDict = NSDictionary()
        
        var likeStatus = 0
        
        var  type = "";
        if (gestureRecognizer.gestureType == 1 || gestureRecognizer.gestureType == 4){
            type = average
            likeStatus = 1
            self.smileyImgVw.image = UIImage.init(named: "icon-average-similey")
            
        }
        else if (gestureRecognizer.gestureType == 2){
            type = disLiked
            likeStatus = 0
            self.smileyImgVw.image = UIImage.init(named: "icon-dislike-similey")
        }
            
        else if (gestureRecognizer.gestureType == 3 || gestureRecognizer.gestureType == 5){
            type = liked
            likeStatus = 2
            self.smileyImgVw.image = UIImage.init(named: "icon-like-similey")
        }else{
            type = invalid
        }
        
        if type != invalid{
            
            smileyImgVw.isHidden = false
            smileyImgVw.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
            UIView.animate(withDuration: 1, animations: {() -> Void in
                self.smileyImgVw.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
            }, completion: {(_ finished: Bool) -> Void in
                UIView.animate(withDuration: 1, animations: {() -> Void in
                    self.smileyImgVw.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
                }, completion: {(_ finished: Bool) -> Void in
                    UIView.animate(withDuration: 1.5, animations: {() -> Void in
                        self.smileyImgVw.transform = CGAffineTransform.identity
                        self.smileyImgVw.isHidden = true
                    })
                })
            })
            
            assetDict = ["DA_Code": assetObj?.daCode ?? "0" , "Region_Code": getRegionCode() , "Customer_Code" : customerObj?.Customer_Code ?? "0", "User_Code" : customerObj?.userCode ?? "", "DA_Type": assetObj?.docType ?? 0 , "Rating" : 0 , "User_Like" : likeStatus , "Feedback" :  "" , "Is_Synced" : 0 ,"Time_Zone": getCurrentTimeZone() , "Current_Date" : getCurrentDate() , "Current_Datetime" : getCurrentDateAndTimeString() ]
            
            DBHelper.sharedInstance.insertAssetFeedback(dict: assetDict)
            
        }else{
            self.smileyImgVw.isHidden = true
        }
        self.gestureView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        gestureContainerView.isHidden = true
        
        showToastViewWithShortTime(toastText: type)
        
    }
    
    
    
    func showAvailablityForNextStory(){
        
        if isComingFromMandatoryStory && storyArray.count > 1{
            
            let alertViewController = UIAlertController(title: "Hello", message: "Do you want to continue next story", preferredStyle: UIAlertControllerStyle.alert)
            
            alertViewController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alertAction in
                
                //  self.removePageViewControllers()
                self.currentStoryIndex += 1
                
                if self.currentStoryIndex < self.storyArray.count {
                    self.assetsArray.removeAll()
                    
                    self.storyObj = self.storyArray[self.currentStoryIndex]
                    self.mc_StoryId = self.storyArray[self.currentStoryIndex].storyObj.Story_Id
                    
                }
                
                self.loadTheDefaultState()
                
            }))
            
            alertViewController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { alertAction in
                
            }))
            
            self.present(alertViewController, animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AssetsPlayerViewController: UIPageViewControllerDataSource , UIPageViewControllerDelegate{
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let assetsChildVC = viewController as! AssetsPlayerChildViewController
        var index = assetsChildVC.index
        
        if index == NSNotFound
        {
            return nil;
        }
        
        index = index + 1
        
        if index == self.controllersList.count
        {
            return nil;
        }
        
        return self.viewControllerAtIndex(index: index)
        
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let assetsChildVC = viewController as! AssetsPlayerChildViewController
        var index = assetsChildVC.index
        
        if index == 0 || index == NSNotFound
        {
            return nil;
        }
        
        index = index - 1
        
        return self.viewControllerAtIndex(index: index)
        
    }
    
    func viewControllerAtIndex(index : Int)->AssetsPlayerChildViewController{
        
        
        return controllersList[index]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        checkForOverlayBtnActions()
        print("sdfsf", previousViewControllers)
    
    }
    
   
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        print("ojkfjnlkfk")
    }
}

extension AssetsPlayerViewController : UITableViewDelegate , UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        return assetsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.AssetsPlayerChildCell) as! AssetsChildTableViewCell
        let assetPlayList = assetsArray[indexPath.row]
        
        let docType = assetPlayList.assetObj.docType ?? 1
        var thumnailImg : UIImage = BL_AssetModel.sharedInstance.getThumbnailImage(docType : docType)
        
            if assetPlayList.isFirstAssetInStory && assetPlayList.isStoryEnabled{
                cell.storytitleLabel.text = assetPlayList.storyObj.Story_Name
                cell.storySubtitleLabel.text = "No of digital resource : \(assetPlayList.storyObj.No_Of_Assets!)"
                if let expiryDate = assetPlayList.storyObj.Effective_To{
                    cell.expiryDateLabel.text = "Valid till \(convertDateIntoServerDisplayformat(date: expiryDate)) "
                }
                cell.storyContainerView.isHidden = false
            }else{
                cell.storyContainerView.isHidden = true
            }
            
            cell.titleLabel.text = assetPlayList.assetObj.daName
            cell.subTitleLabel.text = "\(assetPlayList.assetObj.daSize!) MB"
            cell.indexLabel.text = "\(indexPath.row + 1)"
            
            let urlString =  assetPlayList.assetObj.thumbnailUrl
            
            let localUrl = checkNullAndNilValueForString(stringData:  assetPlayList.assetObj.localUrl)
            
            if localUrl != EMPTY
            {
                let localThumbnailUrl = BL_AssetDownloadOperation.sharedInstance.getAssetThumbnailURL(model :assetPlayList.assetObj)
                if localThumbnailUrl != EMPTY
                {
                    thumnailImg = UIImage(contentsOfFile: localThumbnailUrl)!
                }
            }
            
            
            let thumbanailUrl = checkNullAndNilValueForString(stringData: assetPlayList.assetObj.thumbnailUrl)
            let image = BL_AssetModel.sharedInstance.thumbailImage[thumbanailUrl]
            if  thumbanailUrl != EMPTY && image != nil
            {
                thumnailImg = image!
            }
            else
            {
                getThumbnailImageForUrl(imageUrl: thumbanailUrl, indexPath: indexPath)
            }
            
            cell.thumbNailImgVw.image = thumnailImg
            if tableVIewSelecionArray[indexPath.row] {
                childViewHeader.text = assetPlayList.assetObj.daName
                cell.assetContainerView.backgroundColor = UIColor.darkGray
                
            }else{
                cell.assetContainerView.backgroundColor = UIColor.black
                
            }
            
            if assetPlayList.isStoryEnabled{
                cell.imgVwleadingCnst.constant = 75
            }else{
                cell.imgVwleadingCnst.constant = 15
            }
        
        
        cell.selectionStyle = .none
        
        
        return cell
    }
    
    private func getThumbnailImageForUrl(imageUrl : String,indexPath : IndexPath)
    {
        if imageUrl != EMPTY
        {
            ImageLoader.sharedLoader.imageForUrl(urlString: imageUrl) { (image) in
                if image != nil
                {
                    BL_AssetModel.sharedInstance.thumbailImage[imageUrl] = image
                    DispatchQueue.main.async {
                      self.assetsChildTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                    }
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if assetsArray[indexPath.row].isFirstAssetInStory{
            return 200
        }
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.darkGray
        cell?.backgroundColor = UIColor.darkGray
        cell?.selectionStyle = .none
        let  startingViewController = self.viewControllerAtIndex(index: indexPath.row)
        let viewControllers = [startingViewController]
        pageVC.setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
        
       
        checkForOverlayBtnActions()
        assetsChildView.isHidden = true
    }
}

extension AssetsPlayerViewController : ChildControllerDelegate{
    
    
    func setTitleName(name: String){
        self.titleLabel.text = name
        self.navigationView.isHidden = true
    }
    
    func loadPdfWithLibrary(filePath: String) {
        
        let document = ReaderDocument.withDocumentFilePath(filePath, password: "")
        if document != nil {
            let readerViewController = ReaderViewController(readerDocument: document)
            readerViewController?.delegate = self
            // Set the ReaderViewController delegate to self
            
            self.navigationController?.pushViewController(readerViewController!, animated: true)
            readerViewController?.modalTransitionStyle = .crossDissolve
            readerViewController?.modalPresentationStyle = .fullScreen
            
        }
    }
    
    
    func childScreenTapped() {
        self.respondToTap()
    }
    
    func didShowVideoFile() {
        nextBtn.isHidden = true
        previousBtn.isHidden = true
    }
    
    func didShowSettingsBtn() {
        settingBtn.isHidden = false
    }
    
    func didAssetFinishedPlaying(index: Int) {
        startEndTimerForCurrentAssets(index:  index)

    }
    
    func didShowGestureView() {
        
        for button in ratingBtnArray{
            button.setImage(getSelectedSimileyIconForRating(value: button.tag), for: .normal)
            button.layer.removeAllAnimations()
        }
        
        gestureContainerView.isHidden = false
    }
    
    func didTapOnPdf() {
        self.navigationView.isHidden = !self.navigationView.isHidden
        previousBtn.isHidden = self.navigationView.isHidden
        nextBtn.isHidden = self.navigationView.isHidden
        
        if AssetsDataManager.sharedManager.currentIndex == 0 {
            previousBtn.isHidden = true
        }else if AssetsDataManager.sharedManager.currentIndex == self.controllersList.count-1{
            nextBtn.isHidden = true
        }
        assetStartTimer?.invalidate()
        assetEndTimer?.invalidate()
        
    }
    
    func didTapNext() {
        
        var index = AssetsDataManager.sharedManager.currentIndex
       
        index = index + 1
        
        if index == self.controllersList.count
        {
            showToastViewWithShortTime(toastText: "you're at the last position")
            return
        }

        let  startingViewController = self.viewControllerAtIndex(index: index)
        let viewControllers = [startingViewController]
        pageVC.setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)

        checkForOverlayBtnActions()
        self.navigationCornerButton.isHidden = false

    }
    
    func didTapPrevious() {
        
        var index = AssetsDataManager.sharedManager.currentIndex

        if index == 0 || index == NSNotFound
        {
            showToastViewWithShortTime(toastText: "you're at the first position")
            return
        }
        
        index = index - 1
        
        let  startingViewController = self.viewControllerAtIndex(index: index)
        let viewControllers = [startingViewController]
        pageVC.setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
        
        checkForOverlayBtnActions()
        self.navigationCornerButton.isHidden = false
    }
    
    
    func checkForOverlayBtnActions(){
        if AssetsDataManager.sharedManager.currentIndex == 0 {
            previousBtn.isHidden = true
        }else if AssetsDataManager.sharedManager.currentIndex == self.controllersList.count-1{
            nextBtn.isHidden = true
        }else{
            previousBtn.isHidden = false
            nextBtn.isHidden = false
        }
        
        if AssetsDataManager.sharedManager.docType == 2 || AssetsDataManager.sharedManager.docType == 3 || AssetsDataManager.sharedManager.docType == 5 {
            previousBtn.isHidden = true
            nextBtn.isHidden = true
        }
        if AssetsDataManager.sharedManager.docType == 4{
            settingBtn.isHidden = false
        }else{
            settingBtn.isHidden = true
        }
        
        if AssetsDataManager.sharedManager.docType == 5{
            self.navigationView.isHidden = true
        }
        
    }
    
}

extension AssetsPlayerViewController : UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if AssetsDataManager.sharedManager.currentIndex == 0 && !didScreenOrientationChange {
            
            var leftEdge = scrollView.contentInset.left
            if leftEdge < 0 {
                leftEdge = leftEdge * (-1)
                if scrollView.contentOffset.x < leftEdge{
                    showToastViewWithShortTime(toastText: "you're at the first Digital Resource")
                }
            }
        }else if AssetsDataManager.sharedManager.currentIndex == assetsArray.count - 1 && !didScreenOrientationChange{
            
            var rightEdge = scrollView.contentInset.right
            if rightEdge < 0 {
                rightEdge = rightEdge * (-1)
                if scrollView.contentOffset.x > rightEdge{
                    showToastViewWithShortTime(toastText: "you're at the last digital resource")
                    //showAvailablityForNextStory()
                }
            }
        }
        didScreenOrientationChange = false
    }
}

extension AssetsPlayerViewController : UIGestureRecognizerDelegate{
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {

        if (touch.view?.isDescendant(of: assetsChildTableView))!{
            return false
        }
        return true
    }
}


// Timer to move next Assets

extension AssetsPlayerViewController{
    
    func startEndTimerForCurrentAssets(index : Int){
        
        //        timerIndex = index
        //        assetEndTimer?.invalidate()
        //        assetStartTimer?.invalidate()
        //        assetEndTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.forwardToNextAsset), userInfo: nil, repeats: false)
        
        
    }
    
    func forwardToNextAsset(){
        
        if AssetsDataManager.sharedManager.currentIndex != self.controllersList.count-1 && self.autoPlayBtn.tag == 1{
            if AssetsDataManager.sharedManager.currentIndex == timerIndex{
                
                let alertViewController = UIAlertController(title: title, message: "Would you like to forward next digital resource?", preferredStyle: UIAlertControllerStyle.alert)
                alertViewController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default)
                { action -> Void in
                    self.checkForNextAsset()
                })
                alertViewController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alertViewController, animated: true, completion: nil)
                
                //        assetStartTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.checkForNextAsset), userInfo: nil, repeats: false)
            }
        }
    }
    
    func checkForNextAsset(){
        if AssetsDataManager.sharedManager.currentIndex == timerIndex{
            self.didTapNext()
        }
    }
    
}
