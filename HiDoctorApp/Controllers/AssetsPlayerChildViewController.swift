//
//  AssetsPlayerChildViewController.swift
//  HiDoctorApp
//
//  Created by Admin on 6/4/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import AVFoundation
import UIKit
import WebKit

protocol ChildControllerDelegate: class {
    func setTitleName(name: String)
    func childScreenTapped()
    func didTapNext()
    func didTapPrevious()
    func didShowVideoFile()
    func didShowGestureView()
    func didAssetFinishedPlaying(index: Int)
    func didShowSettingsBtn()
    func didTapOnPdf()
    func loadPdfWithLibrary(filePath: String)
}

class AssetsPlayerChildViewController: UIViewController  {
    
    var index = 0
    var indexPath: IndexPath!
    var URLrequest: URLRequest?
    
    @IBOutlet weak var audioPlayerControlsView: AudioPlayerControlsView!
    @IBOutlet weak var audioContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var avControlsView: AVControlsVIew!
    @IBOutlet weak var videoContainerView: UIView!
    let avPlayer = CustomAVPlayer()
    let audioPlayer = CustomAudioPlayer()
    
    var pdfWebkitView = UIWebView()
    var htmlWebkitView = UIWebView()
    
    @IBOutlet weak var imageVw: CustomImageView!
    
    @IBOutlet weak var pdfViewer: UIView!
    
    @IBOutlet weak var pdfCountView: RoundedCornerRadiusView!
    
    @IBOutlet weak var pdfCurrentPgLbl: UILabel!
    
    @IBOutlet weak var pdfTotalPgLbl: UILabel!
    
    
    
    //  @IBOutlet weak var vrVideoView: GVRVideoView!
    
    var isVRPaused = true
    
    var currentAssetObj : AssetsPlayListModel!
    
    var assetsAnalyticsArray = [AssetAnalyticsDetail]()
    var isFirstTimeLoad = true
    var previousPdfPage = 0
    var analyticsId : Int = 0
    var isPreview : Int = 0
    var SessionUniqueId = 0
    var currentUniqueId = 0
    var pdfAnalyticsArray = [AssetAnalyticsDetail]()
    var htmlAnalyticsArraay = [AssetAnalyticsDetail]()
    var videoAnalyticArray = [AssetAnalyticsDetail]()
    var imageAnalyticArray = [AssetAnalyticsDetail]()
    var audioAnalyticsArray = [AssetAnalyticsDetail]()
    var isViewed = false
    var currentIndexpath = IndexPath()
    
    var lastActiveStateURL = ""
    var lastActiveStatePageNo = 1
    var currentAnalytics : AssetAnalyticsDetail!
    
    weak var delegate: ChildControllerDelegate?
    
    var insertedCount = 0
    var isEnteredBackground = false
    var lastScale : CGFloat = 0.0
    var didPdfScrolling = false
    let pdfDocumentCount = 0
    var readerViewController : ReaderViewController?
    var pdfCurrentPage = 1
    var pdfTimer : Timer?
    var sessionID = 1
    var mc_storyId : NSNumber = 0
    var isComingFromMandatoryStory = false
    
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        self.pdfWebkitView = UIWebView(frame: self.view.frame)
        self.pdfWebkitView.scalesPageToFit = true
        self.pdfWebkitView.delegate = self
       // self.pdfWebkitView.uiDelegate = self
        self.htmlWebkitView = UIWebView(frame: self.view.frame)
        self.htmlWebkitView.delegate = self
        self.htmlWebkitView.scalesPageToFit = true
     //   self.htmlWebkitView.navigationDelegate = self
        self.htmlWebkitView.contentMode = .scaleToFill
        self.htmlWebkitView.clipsToBounds = true
        self.view.addSubview(pdfWebkitView)
        self.view.addSubview(htmlWebkitView)
    
        // Do any additional setup after loading the view.
        audioPlayerControlsView.isHidden = true
        videoContainerView.isHidden = true
        audioContainerView.isHidden = true
        imageVw.isHidden = true
        avControlsView.isHidden = true
        pdfViewer.isHidden = true
     
        htmlWebkitView.isHidden = true
       
        pdfWebkitView.isHidden = true
        loadingIndicator.isHidden = true
        pdfCountView.isHidden = true
        
        avPlayer.delegate = self
        
        if isPreview != 1  {
            
            let doubleTouchAndTap = UITapGestureRecognizer(target: self, action: #selector(self.didTappedAndTouched(gesture:)))
            
            doubleTouchAndTap.delegate = self
            doubleTouchAndTap.numberOfTapsRequired = 2
            doubleTouchAndTap.numberOfTouchesRequired = 2
            self.view.addGestureRecognizer(doubleTouchAndTap)
            
        }
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(recognizer:)))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.delegate = self
       self.htmlWebkitView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func handleSingleTap(recognizer: UITapGestureRecognizer) {
        delegate?.childScreenTapped()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        URLCache.shared.removeAllCachedResponses()
        print("memory warning")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        print("viewWillAppear", index)
        
        removeToastView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: Notification.Name("appEnteredBackground"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: Notification.Name("appEnteredForeground"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didBatteryLevelChange), name: NSNotification.Name.UIDeviceBatteryLevelDidChange, object: nil)
        sessionID = getSessionIDForDACode(da_code: currentAssetObj.assetObj.daCode) + 1
        if currentAssetObj.assetObj.localUrl != nil && currentAssetObj.assetObj.localUrl.count > 0
        {
            loadAnalyticalDetail()
        }
        else
        {
            if(checkInternetConnectivity())
            {
                loadAnalyticalDetail()
            }
            else
            {
                DispatchQueue.main.async {
                    self.showActionForOffline()
                }
            }
        }
        self.delegate?.setTitleName(name: currentAssetObj.assetObj.daName)
        AssetsDataManager.sharedManager.currentAssetObj = currentAssetObj
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        removeToastView()
        pdfCountView.isHidden = true
    }
    
    @objc func didEnterBackground()  {
        
        //        isEnteredBackground = true
        avPlayer.pauseTheAV()
        audioPlayer.pauseTheAudio()
        insertAnalyticsIntoDB()
    }
    
    @objc func willEnterForeground() {
        loadAnalyticalDetail()
    }
    
    @objc func  didBatteryLevelChange()  {
        //        if SwifterSwift.batteryLevel == 1{
        //            insertAnalyticsIntoDB()
        //        }
        //
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear", index)
        AssetsDataManager.sharedManager.currentIndex = index
        if(checkInternetConnectivity())
        {
            if currentAnalytics.PlayMode == "1"{
                if !checkInternetConnectivity() && !isViewed{
                    DispatchQueue.main.async {
                        self.showActionForOffline()
                    }
                }
            }
        }
        else
        {
            if currentAssetObj.assetObj.localUrl == nil
            {
                DispatchQueue.main.async {
                    self.showActionForOffline()
                }
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear", index)
        
        avPlayer.pauseTheAV()
        avPlayer.stopTimer()
        audioPlayer.pauseTheAudio()
        audioPlayer.stopTimer()
        insertAnalyticsIntoDB()
        
        
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("appEnteredBackground"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("appEnteredForeground"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceBatteryLevelDidChange, object: nil)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappear", index)
        
        AssetsDataManager.sharedManager.previousIndex = index
    }
    
    func actionForPDF() {
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let singleAction = UIAlertAction(title: "Single Page", style: .default, handler:{
            (alert: UIAlertAction) -> Void in
            self.pdfCountView.isHidden = true
            self.pdfWebkitView.isHidden = true
            self.pdfViewer.isHidden = false
            self.readerViewController?.showDocumentPage(self.pdfCurrentPage)
        })
        actionSheetController.addAction(singleAction)
        
        let continuousAction = UIAlertAction(title: "Continuous Page", style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            self.pdfViewer.isHidden = false
            self.pdfWebkitView.isHidden = false
            self.pdfWebkitView.scrollView.contentOffset.y = CGFloat(self.getContentOffsetForPageNumber(pageNumber: self.pdfCurrentPage-1))
        })
        actionSheetController.addAction(continuousAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:{
            (alert: UIAlertAction) -> Void in
            
        })
        actionSheetController.addAction(cancelAction)
        
        if SwifterSwift().isPhone
        {
            self.present(actionSheetController, animated: true, completion: nil)
        }
        else
        {
            if let currentPopoverpresentioncontroller = actionSheetController.popoverPresentationController{
                currentPopoverpresentioncontroller.sourceView = self.view
                currentPopoverpresentioncontroller.sourceRect = CGRect(x:self.view.frame.size.width - 125 ,y:-45, width:100,height:100)
                currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.up
                self.present(actionSheetController, animated: true, completion: nil)
            }
        }
        
    }
    
    
    func loadAnalyticalDetail()  {
        let dict : NSDictionary = ["DA_Code" : currentAssetObj.assetObj.daCode, "Part_Id" : 1 , "Part_URL" : "" , "SessionId" : sessionID , "Detailed_DateTime" : getCurrentDate(), "Detailed_StartTime" : getCurrentDateAndTime() , "Detailed_EndTime" : ""  , "Player_Start_Time" :"" , "Played_Time_Duration":"", "isPreview" : isPreview, "Is_Synced" : 0 ,"Like": "", "Rating":""]
        
        
        
        currentAnalytics  = AssetAnalyticsDetail(dict: dict)
        
        currentAnalytics.Part_Id = lastActiveStatePageNo
        currentAnalytics.Doc_Type = currentAssetObj.assetObj.docType
        
        if currentAssetObj.assetObj.docType == 5 {
            currentAnalytics.Part_URL = lastActiveStateURL
        }
        
        configureLayout()
        loadAnalytics()
        
    }
    
    func loadAnalytics(){
        
        if currentAnalytics?.Doc_Type == 4 {
            pdfAnalyticsArray.append(currentAnalytics!)
            previousPdfPage = (currentAnalytics?.Part_Id)!
        }else if currentAnalytics?.Doc_Type == 5{
            htmlAnalyticsArraay.append(currentAnalytics!)
        }else if currentAnalytics?.Doc_Type == 1{
            imageAnalyticArray.append(currentAnalytics!)
        }
        
    }
    
    
    func insertAnalyticsIntoDB(){
        
        if(currentAnalytics != nil)
        {
            if (currentAnalytics?.Detailed_StartTime.count)! > 0{
                
                switch currentAnalytics!.Doc_Type {
                    
                case 1  :
                    // Image
                    
                    if imageAnalyticArray.count > 0{
                        let imageAnalytic = imageAnalyticArray.last
                        imageAnalytic?.Player_EndTime = getCurrentDateAndTime()
                        imageAnalytic?.Detailed_EndTime = getCurrentDateAndTime()
                        
                        if (imageAnalytic?.Player_StartTime.count)! > 0 {
                            
                            let secondsBetween = getDurationForAsset(asset: imageAnalytic!)
                            print("seconds", secondsBetween)
                            imageAnalytic?.Player_EndTime = "\(Int(secondsBetween))"
                            imageAnalytic?.Played_Time_Duration = Int(secondsBetween)
                            imageAnalytic?.Player_StartTime = "0"
                        }else{
                            imageAnalytic?.Player_StartTime = "0"
                            imageAnalytic?.Player_EndTime = "0"
                            imageAnalytic?.Played_Time_Duration = 0
                        }
                        imageAnalytic?.Is_Preview = isPreview
                        
                        if checkForDurationTime(asset: imageAnalytic!) {
                            imageAnalytic?.Part_URL = ""
                            insertAssetObj(assetObj: imageAnalytic!)
                        }
                        
                    }
                    imageAnalyticArray.removeAll()
                    
                    break
                    
                    
                case 4:
                    //PDF
                    
                    var i = 0
                    let detailEndTime = getCurrentDateAndTime()
                    for value in pdfAnalyticsArray{
                        if i == pdfAnalyticsArray.count - 1{
                            let endTime = getCurrentDateAndTime()
                            value.Player_EndTime = endTime
                            lastActiveStatePageNo = value.Part_Id
                        }
                        value.Detailed_EndTime = detailEndTime
                        
                        if pdfAnalyticsArray.count > 0{
                            let detailStartTime = pdfAnalyticsArray[0].Detailed_StartTime
                            value.Detailed_StartTime = detailStartTime
                        }
                        value.Is_Preview = isPreview
                        value.Part_URL = ""
                        if value.Player_StartTime.count > 0 {
                            
                            let secondsBetween = getDurationForAsset(asset: value)
                            print("seconds", secondsBetween)
                            value.Played_Time_Duration = Int(secondsBetween)
                            value.Player_EndTime = "\(Int(secondsBetween))"
                            value.Player_StartTime = "0"
                            
                            if value.Player_EndTime.count > 0 {
                                
                                if pdfAnalyticsArray.count == 1{
                                    if checkForDurationTime(asset: value) {
                                        insertAssetObj(assetObj: value)
                                    }
                                }else{
                                    insertAssetObj(assetObj: value)
                                }
                            }
                        }else{
                            value.Player_StartTime = "0"
                            value.Player_EndTime = "0"
                            value.Played_Time_Duration = 0
                            if pdfAnalyticsArray.count == 1{
                                if checkForDurationTime(asset: value) {
                                    insertAssetObj(assetObj: value)
                                }
                            }else{
                                insertAssetObj(assetObj: value)
                            }
                        }
                        i = i+1
                    }
                    pdfAnalyticsArray.removeAll()
                    break
                    
                case 5:
                    //HTML
                    
                    var i = 0
                    let detailEndTime = getCurrentDateAndTime()
                    for value in htmlAnalyticsArraay{
                        if i == htmlAnalyticsArraay.count - 1{
                            let endTime = getCurrentDateAndTime()
                            value.Player_EndTime = endTime
                            //                            lastActiveStateURL = value.Part_URL
                        }
                        value.Detailed_EndTime = detailEndTime
                        if htmlAnalyticsArraay.count > 0{
                            let detailStartTime = htmlAnalyticsArraay[0].Detailed_StartTime
                            value.Detailed_StartTime = detailStartTime
                        }
                        
                        value.Is_Preview = isPreview
                        
                        if value.Player_StartTime.count > 0
                        {
                            let secondsBetween = getDurationForAsset(asset: value)
                            print("seconds", secondsBetween)
                            value.Played_Time_Duration = Int(secondsBetween)
                            value.Player_EndTime = "\(Int(secondsBetween))"
                            value.Player_StartTime = "0"
                        }
                        else
                        {
                            value.Player_StartTime = "0"
                            value.Player_EndTime = "0"
                            value.Played_Time_Duration = 0
                        }
                        
                        let partURL = value.Part_URL
                        let htmlNameArray = partURL?.components(separatedBy: "\(value.DA_Code!)/")
                        
                        value.Part_URL = (htmlNameArray?.last)!
                        
                        if htmlAnalyticsArraay.count == 1{
                            if checkForDurationTime(asset: value) {
                                insertAssetObj(assetObj: value)
                            }
                        }else{
                            insertAssetObj(assetObj: value)
                        }
                        i = i+1
                    }
                    htmlAnalyticsArraay.removeAll()
                    break
                    
                    
                case 2:
                    // Video
                    
                    let videoAnalytics = avPlayer.videoAssetAnalyticsArray
                    
                    var index = 0
                    let detailEndTime = getCurrentDateAndTime()
                    for value in videoAnalytics{
                        if index == videoAnalytics.count - 1{
                            if value.Player_StartTime.count > 0  && !(value.Player_EndTime.count > 0){
                                value.Player_EndTime = "\(Int(avPlayer.controlsView.playProgressSlider.value))"
                            }
                        }
                        value.Detailed_EndTime = detailEndTime
                        if videoAnalytics.count > 0{
                            let detailStartTime = videoAnalytics[0].Detailed_StartTime
                            value.Detailed_StartTime = detailStartTime
                        }
                        value.Is_Preview = isPreview
                        value.Part_URL = ""
                        if value.Player_StartTime.count > 0 && value.Player_EndTime.count > 0 {
                            let duration = Float(value.Player_EndTime)! - Float(value.Player_StartTime)!
                            
                            value.Played_Time_Duration = Int(duration)
                        }
                        
                        if videoAnalytics.count != 1{
                            if value.Player_EndTime.count > 0 && value.Played_Time_Duration > 0 {
                                insertAssetObj(assetObj: value)
                            }else if value.Player_EndTime.count > 0 && index == 0 {
                                insertAssetObj(assetObj: value)
                            }
                        }
                        else {
                            if checkForDurationTime(asset: value){
                                insertAssetObj(assetObj: value)
                            }
                        }
                        index = index+1
                    }
                    avPlayer.videoAssetAnalyticsArray.removeAll()
                    break
                    
                case 3:
                    // Audio
                    
                    let audioAnalytics = audioPlayer.audioAssetAnalyticsArray
                    
                    var index = 0
                    let detailEndTime = getCurrentDateAndTime()
                    for value in audioAnalytics{
                        if index == audioAnalytics.count - 1{
                            if value.Player_StartTime.count > 0  && !(value.Player_EndTime.count > 0){
                                value.Player_EndTime = "\(Int(audioPlayer.controlsView.playProgressSlider.value))"
                            }
                        }
                        value.Detailed_EndTime = detailEndTime
                        if audioAnalytics.count > 0{
                            let detailStartTime = audioAnalytics[0].Detailed_StartTime
                            value.Detailed_StartTime = detailStartTime
                        }
                        value.Is_Preview = isPreview
                        value.Part_URL = ""
                        if value.Player_StartTime.count > 0 && value.Player_EndTime.count > 0 {
                            let duration = Float(value.Player_EndTime)! - Float(value.Player_StartTime)!
                            
                            value.Played_Time_Duration = Int(duration)
                        }
                        
                        if audioAnalytics.count != 1{
                            if value.Player_EndTime.count > 0 && value.Played_Time_Duration > 0 {
                                insertAssetObj(assetObj: value)
                            }
                        }
                        else {
                            if checkForDurationTime(asset: value){
                                insertAssetObj(assetObj: value)
                            }
                        }
                        index = index+1
                    }
                    audioPlayer.audioAssetAnalyticsArray.removeAll()
                    break
                    
                default:
                    break
                }
                
            }
        }
        
        
    }
    
    func getDurationForAsset(asset: AssetAnalyticsDetail) -> Float{
        
        let dateObj = getDateFromString(dateString: (asset.Player_StartTime))
        let endDateObj = getDateFromString(dateString: (asset.Player_EndTime))
        let secondsBetween = abs(Float(endDateObj.timeIntervalSince(dateObj)))
        
        return secondsBetween
    }
    
    
    func checkForDurationTime(asset : AssetAnalyticsDetail) -> Bool{
        let detailDateObj = getDateFromString(dateString: (asset.Detailed_StartTime)!)
        let detailendDateObj = getDateFromString(dateString: (asset.Detailed_EndTime)!)
        let seconds = abs(Float(detailendDateObj.timeIntervalSince(detailDateObj)))
        if seconds > 3 {
            return true
        }
        
        return false
    }
    
    func configureLayout()  {
        
        
        avPlayer.player.pause()
        //avPlayer.controlsView.playProgressSlider.value = 0.0
        AssetsDataManager.sharedManager.docType = currentAssetObj.assetObj.docType
        
        
        switch currentAssetObj.assetObj.docType {
        case 1:
            // Image
            // imagePinchScrollVw.isHidden = false
            imageVw.isHidden = false
            loadImageView()
            break
            
        case 2:
            // Video
            avPlayer.setControlsView(controlsView: avControlsView)
            let avFrame = CGRect(x:0, y:0, width:containerView.frame.size.width, height:containerView.frame.size.height)
            avPlayer.setPlayerFrame(frame: avFrame)
            videoContainerView.addSubview(avPlayer.playerViewController.view)
            avControlsView.isHidden = false
            videoContainerView.isHidden = false
            loadVideoView()
            self.delegate?.didShowVideoFile()
            break
            
        case 3:
            audioContainerView.isHidden = false
            audioPlayerControlsView.isHidden = false
            
            audioPlayerControlsView.isHidden = false
            audioPlayer.setControlsView(controlsView: audioPlayerControlsView)
            audioPlayer.delegate = self
            loadAudioView()
            self.delegate?.didShowVideoFile()
            break
        case 5:
            // Html
            loadHTMLView()
            break
            
        case 4:
            // PDF
            loadPDFView()
            self.delegate?.didShowSettingsBtn()
            break
        default:
            break
        }
        
    }
    
    func loadVideoView()  {
        
        var url = URL(string:"")
        if currentAssetObj.assetObj.localUrl != nil && currentAssetObj.assetObj.localUrl.count > 0 {
            let filePath = BL_AssetDownloadOperation.sharedInstance.getAssetFileURL(fileName: currentAssetObj.assetObj.localUrl, subFolder: "\(currentAssetObj.assetObj.daCode!)")
            url  = URL(fileURLWithPath: filePath)
            currentAnalytics.Part_URL = currentAssetObj.assetObj.localUrl
            currentAnalytics.PlayMode = "0"
            avPlayer.isOnlineMode = false
            //                assetsImageUrl = assetsImageUrl.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? EMPTY
            
            
        }else if currentAssetObj.assetObj.onlineUrl != nil{
            
            url = URL(string :currentAssetObj.assetObj.onlineUrl.addingPercentEncoding(withAllowedCharacters: getCharacterSet() as CharacterSet) ?? EMPTY)
            currentAnalytics.Part_URL = currentAssetObj.assetObj.onlineUrl
            currentAnalytics.PlayMode = "1"
            avPlayer.isOnlineMode = true
            if !checkInternetConnectivity() {
                //showToastViewWithShortTime(toastText: internetOfflineMessage)
                isViewed = false
                
            }
            
        }
        currentAnalytics.Player_StartTime = "0"
        videoAnalyticArray =  avPlayer.videoAssetAnalyticsArray
        avPlayer.setAssetAnalytics(assetAnalytics: currentAnalytics)
        avPlayer.sessionID = (currentAnalytics.Session_Id)!
        avPlayer.isPreview = currentAnalytics.Is_Preview
        if !isViewed {
            if !avPlayer.didVideoPlayerPlayed{
                avPlayer.playTheAV(videoURL: url!)
            }
            if currentAnalytics.PlayMode == "1" {
                if checkInternetConnectivity(){
                    isViewed = true
                }
            }else{
                isViewed = true
            }
        }
        
        avPlayer.controlsView.nextBtn.addTarget(self, action: #selector(self.moveToNext), for: .touchUpInside )
        avPlayer.controlsView.previousBtn.addTarget(self, action: #selector(self.moveToPrevious), for: .touchUpInside )
        
    }
    
    @objc func moveToNext()  {
        self.delegate?.didTapNext()
    }
    
    @objc func moveToPrevious()  {
        self.delegate?.didTapPrevious()
    }
    
    func didScreenTapped(){
        self.delegate?.didTapOnPdf()
        
    }
    
    @objc func didTappedAndTouched(gesture: UITapGestureRecognizer){
        
        self.delegate?.didShowGestureView()
    }
    
    func loadAudioView(){
        
        var url = URL(string:"")
        if currentAssetObj.assetObj.localUrl != nil && currentAssetObj.assetObj.localUrl.count > 0 {
            let filePath = BL_AssetDownloadOperation.sharedInstance.getAssetFileURL(fileName: currentAssetObj.assetObj.localUrl, subFolder: "\(currentAssetObj.assetObj.daCode!)")
            url  = URL(fileURLWithPath: filePath)
            currentAnalytics.Part_URL = currentAssetObj.assetObj.localUrl
            currentAnalytics.PlayMode = "0"
            audioPlayer.isOnlineMode = false
        }else if currentAssetObj.assetObj.onlineUrl != nil{
            url = URL(string :currentAssetObj.assetObj.onlineUrl)
            currentAnalytics.Part_URL = currentAssetObj.assetObj.onlineUrl
            currentAnalytics.PlayMode = "1"
            audioPlayer.isOnlineMode = true
            if !checkInternetConnectivity() {
                // showToastViewWithShortTime(toastText: internetOfflineMessage)
                isViewed = false
                
            }
            
        }
        
        currentAnalytics.Player_StartTime = "0"
        audioAnalyticsArray =  audioPlayer.audioAssetAnalyticsArray
        audioPlayer.setAssetAnalytics(assetAnalytics: currentAnalytics)
        audioPlayer.sessionID = (currentAnalytics.Session_Id)!
        audioPlayer.isPreview = currentAnalytics.Is_Preview
        if !isViewed {
            if !audioPlayer.didaudioPlayerPlayed{
                audioPlayer.playTheAudio(audioURL:url!)
            }
            if currentAnalytics.PlayMode == "1" {
                if checkInternetConnectivity(){
                    isViewed = true
                }
            }else{
                isViewed = true
            }
        }
        
        // for thumbnail
        
        
        var thumnailImg : UIImage = BL_AssetModel.sharedInstance.getThumbnailImage(docType : currentAssetObj.assetObj.docType!)
        
        let localUrl = checkNullAndNilValueForString(stringData:  currentAssetObj.assetObj.localUrl)
        
        if localUrl != EMPTY
        {
            let localThumbnailUrl = BL_AssetDownloadOperation.sharedInstance.getAssetThumbnailURL(model :currentAssetObj.assetObj)
            if localThumbnailUrl != EMPTY
            {
                thumnailImg = UIImage(contentsOfFile: localThumbnailUrl)!
            }
        }
        
        
        let thumbanailUrl = checkNullAndNilValueForString(stringData: currentAssetObj.assetObj.thumbnailUrl)
        let image = BL_AssetModel.sharedInstance.thumbailImage[thumbanailUrl]
        if  thumbanailUrl != EMPTY && image != nil
        {
            thumnailImg = image!
        }
        else
        {
            getThumbnailImageForUrl(imageUrl: thumbanailUrl)
        }
        
        audioPlayerControlsView.thumbNailImageVw.image = thumnailImg
        
        
        audioPlayer.controlsView.nextBtn.addTarget(self, action: #selector(self.moveToNext), for: .touchUpInside )
        audioPlayer.controlsView.previousBtn.addTarget(self, action: #selector(self.moveToPrevious), for: .touchUpInside )
        
    }
    
    private func getThumbnailImageForUrl(imageUrl : String)
    {
        if imageUrl != EMPTY
        {
            ImageLoader.sharedLoader.imageForUrl(urlString: imageUrl) { (image) in
                if image != nil
                {
                    BL_AssetModel.sharedInstance.thumbailImage[imageUrl] = image
                    DispatchQueue.main.async {
                        self.imageVw.imageVw.image = image
                    }
                }
            }
        }
    }

    func loadImageView()  {
        
        
        if currentAssetObj.assetObj.localUrl != nil && currentAssetObj.assetObj.localUrl.count > 0 {
            
            let filePath = BL_AssetDownloadOperation.sharedInstance.getAssetFileURL(fileName: currentAssetObj.assetObj.localUrl, subFolder: "\(currentAssetObj.assetObj.daCode!)")
            
            let imageUrls = filePath.components(separatedBy: ".")
            if imageUrls.last == "gif"{
                if !isViewed{
                    loadingIndicator.isHidden = false
                    loadingIndicator.startAnimating()
                    
                    let url = URL(fileURLWithPath: filePath)
                    
                    do {
                        let imageData = try Data(contentsOf: url)
                        DispatchQueue.main.async {
                            self.imageVw?.imageVw?.image = UIImage.gifImageWithData(imageData)
                            self.isViewed = true
                            self.loadingIndicator.stopAnimating()
                            self.loadingIndicator.isHidden = true
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }else{
                imageVw?.imageVw?.image = UIImage(contentsOfFile: filePath)
                isViewed = true
            }
            imageVw?.imageVw?.contentMode = .scaleAspectFit
            
            
            self.currentAnalytics.Player_StartTime = self.getCurrentDateAndTime()
            currentAnalytics.Part_URL = currentAssetObj.assetObj.localUrl
            currentAnalytics.PlayMode = "0"
            Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.forwardToNextAsset), userInfo: nil, repeats: false)
            
        }else if currentAssetObj.assetObj.onlineUrl != nil{
            self.currentAnalytics.PlayMode = "1"
            let urlString =  currentAssetObj.assetObj.onlineUrl
            if urlString != nil{
                
                //showCustomActivityIndicatorView(loadingText: "loading")
                
                self.currentAnalytics.Part_URL = self.currentAssetObj.assetObj.onlineUrl
                if (urlString?.count)! > 0 {
                    loadingIndicator.isHidden = false
                    loadingIndicator.startAnimating()
                    
                    let imageUrls = urlString?.components(separatedBy: ".")
                    if imageUrls?.last == "gif"{
                        ImageLoader.sharedLoader.gifForUrl(urlString: urlString!) { (data) in
                            
                            
                            if data == nil{
                                if !checkInternetConnectivity() {
                                    // showToastViewWithShortTime(toastText: internetOfflineMessage)
                                }
                            }else if !self.isViewed{
                                
                                DispatchQueue.main.async {
                                    
                                    self.imageVw?.imageVw?.image = UIImage.gifImageWithData(data!)
                                    removeCustomActivityView()
                                    self.loadingIndicator.stopAnimating()
                                    self.loadingIndicator.isHidden = true
                                    self.isViewed = true
                                    self.currentAnalytics.Player_StartTime = self.getCurrentDateAndTime()
                                    
                                }
                                
                            }else{
                                self.currentAnalytics.Player_StartTime = self.getCurrentDateAndTime()
                                self.loadingIndicator.stopAnimating()
                                self.loadingIndicator.isHidden = true
                            }
                            Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.forwardToNextAsset), userInfo: nil, repeats: false)
                            
                        }
                        
                    }else{
                        
                        ImageLoader.sharedLoader.imageForUrl(urlString: urlString!) { (image) in
                            DispatchQueue.main.async {
                                
                                self.imageVw?.imageVw?.image = image
                                removeCustomActivityView()
                                self.loadingIndicator.stopAnimating()
                                self.loadingIndicator.isHidden = true
                            }
                            if image == nil{
                                if !checkInternetConnectivity() {
                                    // showToastViewWithShortTime(toastText: internetOfflineMessage)
                                }
                            }else{
                                self.currentAnalytics.Player_StartTime = self.getCurrentDateAndTime()
                                self.isViewed = true
                            }
                            Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.forwardToNextAsset), userInfo: nil, repeats: false)
                            
                        }
                    }
                    
                }
                
            }
        }
        
        
    }
    
    func loadPDFView()
    {
       pdfWebkitView.scrollView.delegate = self
        pdfWebkitView.scrollView.tag = 100
        // pdfVwModeBtn.isHidden = false
        
        if currentAssetObj.assetObj.localUrl != nil && currentAssetObj.assetObj.localUrl.count > 0 {
            let filePath = BL_AssetDownloadOperation.sharedInstance.getAssetFileURL(fileName: currentAssetObj.assetObj.localUrl, subFolder: "\(currentAssetObj.assetObj.daCode!)")
            let targetURL = URL(fileURLWithPath: filePath)
            let request = URLRequest(url: targetURL)
            
            if filePath.count > 0
            {
                if !isViewed
                {
                    // self.delegate?.loadPdfWithLibrary(filePath: filePath)
                    //showCustomActivityIndicatorView(loadingText: "loading")
                    
                    let document = ReaderDocument.withDocumentFilePath(filePath, password: "")
                    pdfWebkitView.tag = document?.pageCount as! Int
                    pdfTotalPgLbl.text = "\(pdfWebkitView.tag)"
                    
                    if document != nil
                    {
                        readerViewController = ReaderViewController(readerDocument: document)
                        readerViewController?.delegate = self
                        // Set the ReaderViewController delegate to self
                        
                        
                        self.addChildViewController(readerViewController!)
                        let frame = CGRect(x: pdfViewer.frame.origin.x, y: pdfViewer.frame.origin.y, width: pdfViewer.frame.size.width, height: pdfViewer.frame.size.height)
                        readerViewController?.view.frame = frame
                        readerViewController?.view.backgroundColor = UIColor.gray
                        pdfViewer.addSubview((readerViewController?.view)!)
                        readerViewController?.didMove(toParentViewController: self)
                        self.readerViewController?.showDocumentPage(1)
                        self.readerViewController?.orientationDidChange()
                    }
                    
                    self.pdfWebkitView.loadRequest(request)
                    pdfViewer.isHidden = false
                    isViewed = true
                    // self.loadPdf(fileName: filePath)
                }
                else
                {
                    currentAnalytics.Player_StartTime = self.getCurrentDateAndTime()
                }
            }
            currentAnalytics.Part_URL = currentAssetObj.assetObj.localUrl
            currentAnalytics.PlayMode = "0"
        }
        else if currentAssetObj.assetObj.onlineUrl != nil && currentAssetObj.assetObj.onlineUrl.count > 0
        {
            self.currentAnalytics.PlayMode = "1"
            let myUrl = URL(string: currentAssetObj.assetObj.onlineUrl)
            
            if !self.isViewed
            {
                //showCustomActivityIndicatorView(loadingText: "loading")
                loadingIndicator.isHidden = false
                loadingIndicator.startAnimating()
                
                WebServiceWrapper.sharedInstance.getDataFromUrl(url: myUrl!, completion: { (data) in
                    let fileNameSplittedString = self.currentAssetObj.assetObj.onlineUrl.components(separatedBy: "/")
                    
                    if fileNameSplittedString.count > 0
                    {
                        if data != nil
                        {
                            let fileName = fileNameSplittedString.last
                            BL_AssetDownloadOperation.sharedInstance.saveAssetFile(fileData: data!, fileName: fileName!, subFolder: Constants.SubDirectories.PDFCache)
                            
                            let filePath = BL_AssetDownloadOperation.sharedInstance.getAssetFileURL(fileName: fileName!, subFolder: Constants.SubDirectories.PDFCache)
                            
                            if (filePath != EMPTY)
                            {
                                let targetURL = URL(fileURLWithPath: filePath)
                                let request = URLRequest(url: targetURL)
                                
                                //let myRequest = URLRequest(url: myUrl!)
                                // showCustomActivityIndicatorView(loadingText: "loading")
                                
                                let document = ReaderDocument.withDocumentFilePath(filePath, password: "")
                                
                                if document != nil
                                {
                                  
                                    self.pdfWebkitView.tag = document?.pageCount as! Int
                                }
                                else
                                {
                                    self.pdfWebkitView.tag = 1
                                }
                                
                                self.pdfTotalPgLbl.text = "\(self.pdfWebkitView.tag)"
                                
                                if document != nil
                                {
                                    self.readerViewController = ReaderViewController(readerDocument: document)
                                    self.readerViewController?.delegate = self
                                    // Set the ReaderViewController delegate to self
                                    
                                    self.addChildViewController(self.readerViewController!)
                                    let frame = CGRect(x: self.pdfViewer.frame.origin.x, y: self.pdfViewer.frame.origin.y, width: self.pdfViewer.frame.size.width, height: self.pdfViewer.frame.size.height)
                                    self.readerViewController?.view.frame = frame
                                    self.readerViewController?.view.backgroundColor = UIColor.gray
                                    self.pdfViewer.addSubview((self.readerViewController?.view)!)
                                    self.readerViewController?.didMove(toParentViewController: self)
                                    self.readerViewController?.showDocumentPage(1)
                                    self.readerViewController?.orientationDidChange()
                                }
                                self.pdfWebkitView.loadRequest(request)
                                self.URLrequest = request
                                // self.loadPdf(fileName: filePath)
                                self.pdfViewer.isHidden = false
                                
                                self.isViewed = true
                                self.currentAnalytics.Player_StartTime = self.getCurrentDateAndTime()
                            }
                        }
                        else
                        {
                            if !checkInternetConnectivity()
                            {
                                // showToastViewWithShortTime(toastText: internetOfflineMessage)
                                
                            }
                        }
                        
                    }
                })
                
            }
            else
            {
                currentAnalytics.Player_StartTime = self.getCurrentDateAndTime()
            }
            
            currentAnalytics.Part_URL = currentAssetObj.assetObj.onlineUrl
        }
    }
    
    func loadHTMLView()
    {
        
        htmlWebkitView.scrollView.delegate = self
        htmlWebkitView.scrollView.tag = 200
        currentAnalytics.Session_Id = sessionID
        
        if currentAssetObj.assetObj.localUrl != nil && currentAssetObj.assetObj.localUrl.count > 0
        {
            let filePath = BL_AssetDownloadOperation.sharedInstance.getHTMLFileURL(fileName: currentAssetObj.assetObj.localUrl!, subFolder: "\(currentAssetObj.assetObj.daCode!)", startHtmlPage: currentAssetObj.assetObj.Html_Start_Page)
            let targetURL = URL(fileURLWithPath: filePath, isDirectory: false)
            let request = URLRequest(url: targetURL)
            
            if !isViewed
            {
                //showCustomActivityIndicatorView(loadingText: "loading")
                loadingIndicator.isHidden = false
                loadingIndicator.startAnimating()
                do {
                     let tex = try String(contentsOf: targetURL, encoding: .utf8)
                    htmlWebkitView.loadHTMLString(tex, baseURL: targetURL)
                
                   // htmlWebkitView.loadFileURL(targetURL, allowingReadAccessTo: targetURL)
                    //htmlWebkitView.load(request)
                }
                catch {
                    print(error)
                }
                
                isViewed = true
                currentAnalytics.Part_URL = filePath
            }
            else
            {
                currentAnalytics.Player_StartTime = getCurrentDateAndTime()
            }
            currentAnalytics.PlayMode = "0"
        }
        else if currentAssetObj.assetObj.onlineUrl != nil && currentAssetObj.assetObj.onlineUrl.count > 0
        {
            //showCustomActivityIndicatorView(loadingText: "loading")
            let myUrl = URL(string: currentAssetObj.assetObj.onlineUrl)
            let myRequest = URLRequest(url: myUrl!)
            
            if !isViewed
            {
                //showCustomActivityIndicatorView(loadingText: "loading")
                loadingIndicator.startAnimating()
                 htmlWebkitView.loadRequest(myRequest)
            }
            else
            {
                currentAnalytics.Player_StartTime = getCurrentDateAndTime()
            }
            
            isViewed = true
            currentAnalytics.Part_URL = currentAssetObj.assetObj.onlineUrl
            currentAnalytics.PlayMode = "1"
        }
        htmlWebkitView.isHidden = false
        
    }
    
    @objc func forwardToNextAsset()
    {
        self.delegate?.didAssetFinishedPlaying(index:  index)
    }
    
    
    //
    //    func loadPdf(fileName : String  )  {
    //
    //       // pdfViewer.isHidden = false
    //        let viewer = PDFKBasicPDFViewer()
    //
    //        viewer.delegate = self
    //        //Load the document
    //        let document = PDFKDocument(contentsOfFile: fileName, password: nil)
    //        let str: String = "\(UInt(document!.pageCount))"
    //        pdfWebVIewer.tag = Int(document!.pageCount)
    //      //  viewer.loadDocument(document)
    //       // displayContentController(content: viewer)
    //
    //    }
    //
    //    func displayContentController(content: PDFKBasicPDFViewer) {
    //
    //
    //        addChildViewController(content)
    //        let frame = CGRect(x: pdfViewer.frame.origin.x, y: pdfViewer.frame.origin.y, width: pdfViewer.frame.size.width-20, height: pdfViewer.frame.size.height - 20)
    //        content.view.frame = frame
    //        content.view.backgroundColor = UIColor.blue
    //        pdfViewer.addSubview(content.view)
    //        content.didMove(toParentViewController: self)
    //    }
    
    
    func showActionForOffline(){
        let alertViewController = UIAlertController(title: "Internet is not available.", message: "To continue choose an option", preferredStyle: UIAlertControllerStyle.alert)
        
        alertViewController.addAction(UIAlertAction(title: "Goto Settings", style: UIAlertActionStyle.default, handler: { alertAction in
            
            if let url = URL(string: UIApplicationOpenSettingsURLString){
                if  UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.openURL(url)
                }
            }
        }))
        
        if AssetsDataManager.sharedManager.currentIndex != AssetsDataManager.sharedManager.childControllersList.count - 1{
            
            alertViewController.addAction(UIAlertAction(title: "Next Digital Resource", style: UIAlertActionStyle.default, handler: { alertAction in
                self.delegate?.didTapNext()
            }))
        }
        
        alertViewController.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: { alertAction in
            alertViewController.dismiss(animated: true, completion: nil)
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.popViewController(animated: true)
            
        }))
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func getCurrentDateAndTime() -> String{
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateObj = dateFormatter.string(from: Date())
        
        _ = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        return dateObj
    }
    
    func getCurrentDate() -> String{
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateObj = dateFormatter.string(from: Date())
        return dateObj
    }
    
    
    func getDateFromString(dateString : String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateString)
        if date != nil {
            return date!
            
        }
        return Date()
    }
    
    
    func getStringFromDate(date : Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
    
    
    private func insertAssetObj(assetObj : AssetAnalyticsDetail)
    {
        assetObj.MC_Story_Id = currentAssetObj.assetObj.mc_StoryId as NSNumber
        assetObj.Doc_Type = currentAssetObj.assetObj.docType
        
         BL_AssetModel.sharedInstance.detailedCustomerId = BL_AssetModel.sharedInstance.DETAIL_CUSTOMER_ID
        
        analyticsId = BL_AssetModel.sharedInstance.insertAssetAnalytics(analyticsObj: assetObj, customerObj: BL_AssetModel.sharedInstance.getCustomerObjByCustomerCode())
        
        if BL_MenuAccess.sharedInstance.is_Group_eDetailing_Allowed() && BL_AssetModel.sharedInstance.selected_CustomersForEdetailing.count != 0
        {
            self.insert_GroupAnalytics(count: 0, assetObject: assetObj)
        }
        
        print("analytics" , analyticsId)
        
        if isComingFromMandatoryStory && assetObj.Played_Time_Duration > 0 && assetObj.MC_Story_Id != AssetsDataManager.sharedManager.previousStoryId  {
            AssetsDataManager.sharedManager.previousStoryId = assetObj.MC_Story_Id
            let groupCount = 0
                // checking for group Edetailing
            
            
                let customerObj =  BL_AssetModel.sharedInstance.getCustomerObjByCustomerCode()
                               let dict = ["Story_Id" : assetObj.MC_Story_Id, "DA_Code" : currentAssetObj.assetObj.daCode, "Customer_Code" : customerObj?.Customer_Code ?? 0 , "Customer_Region_Code" : customerObj?.Region_Code ?? 0 , "TimeZone" : getCurrentTimeZone() , "Is_Synched" : 0 ] as [String : Any]
                               let storyAssetObj = StoryAssetAnalytics(dict: dict as NSDictionary)
                               DBHelper.sharedInstance.insertMasterStoryAnalytics(analyticsObj: storyAssetObj)
                               AssetsDataManager.sharedManager.isStoryTracked = true
            
                if BL_MenuAccess.sharedInstance.is_Group_eDetailing_Allowed() && BL_AssetModel.sharedInstance.selected_CustomersForEdetailing.count != 0
                {
                self.insert_GroupEdetailing_AssetDetail(count: groupCount)
            
            }
        }
        //  sessionId = BL_AssetModel.sharedInstance.getAssetAnalyticsById(analyticsId: analyticsId).Session_Id
    }
    
    
    func insert_GroupAnalytics(count: Int,assetObject: AssetAnalyticsDetail){
        var arr_Count = count
        if arr_Count == BL_AssetModel.sharedInstance.selected_CustomersForEdetailing.count {
            return
        } else {
          
            BL_AssetModel.sharedInstance.detailedCustomerId =  BL_AssetModel.sharedInstance.detailedCustomerId_Arr[arr_Count]
             analyticsId = BL_AssetModel.sharedInstance.insertAssetAnalytics(analyticsObj: assetObject, customerObj: BL_AssetModel.sharedInstance.selected_CustomersForEdetailing[arr_Count])
           arr_Count = arr_Count + 1
            self.insert_GroupAnalytics(count: arr_Count, assetObject: assetObject)
        }
    }
    
    
    func insert_GroupEdetailing_AssetDetail(count: Int){
        var arr_Count = count
        if arr_Count == BL_AssetModel.sharedInstance.selected_CustomersForEdetailing.count{
            return
        } else {
            let num =  currentAssetObj.assetObj.mc_StoryId as NSNumber
            let cus_Data = BL_AssetModel.sharedInstance.selected_CustomersForEdetailing[arr_Count]
            let dict = ["Story_Id" : num, "DA_Code" : currentAssetObj.assetObj.daCode, "Customer_Code" : cus_Data.Customer_Code ?? 0 , "Customer_Region_Code" : cus_Data.Region_Code ?? 0 , "TimeZone" : getCurrentTimeZone() , "Is_Synched" : 0 ] as [String : Any]
            let storyAssetObj = StoryAssetAnalytics(dict: dict as NSDictionary)
            DBHelper.sharedInstance.insertMasterStoryAnalytics(analyticsObj: storyAssetObj)
            AssetsDataManager.sharedManager.isStoryTracked = true
           arr_Count = arr_Count + 1
            self.insert_GroupEdetailing_AssetDetail(count: arr_Count)
        }
    }
    
    private func updateAssetObj(assetObj : AssetAnalyticsDetail)
    {
        BL_AssetModel.sharedInstance.updateAssetAnalyticsById(assetAnalyticsId: analyticsId, assetObj: assetObj)
        print("analytics" , analyticsId)
        //  sessionId = BL_AssetModel.sharedInstance.getAssetAnalyticsById(analyticsId: analyticsId).Session_Id
    }
    
    func getSessionIDForDACode(da_code : Int) -> Int{
        let sessionId =  BL_AssetModel.sharedInstance.getSessionIdByDaCode(daCode: da_code)
        
        if sessionId != nil{
            return sessionId!
        }
        return 0
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


extension AssetsPlayerChildViewController : ReaderViewControllerDelegate{
    
    func didChangePDFPage(_ pageNumber: Int32, totalPage totalPageNo: Int32) {
        print("pdfpage", pageNumber)
        didPdfScrolling = true
        pdfCountView.isHidden = false
        pdfCurrentPgLbl.text = "\(pageNumber)"
        pdfCurrentPage = Int(pageNumber)
        
        let previousAssetAnalytics = pdfAnalyticsArray.last
        if pdfAnalyticsArray.count > 0 {
            
            if previousAssetAnalytics?.Part_Id != pdfCurrentPage && pdfCurrentPage != 0 && !pdfViewer.isHidden
            {
                let endTime = getCurrentDateAndTime()
                previousAssetAnalytics?.Player_EndTime = endTime
                previousAssetAnalytics?.Detailed_EndTime = getCurrentDateAndTime()
                
                
                let dict : NSDictionary = ["DA_Code" : previousAssetAnalytics!.DA_Code, "Part_Id" : pdfCurrentPage , "Part_URL" : previousAssetAnalytics!.Part_URL , "SessionId" : sessionID  , "Detailed_DateTime" : getCurrentDate() , "Detailed_StartTime" : getCurrentDateAndTime() , "Detailed_EndTime" : ""  ,"Player_Start_Time" :self.getCurrentDateAndTime() ,  "Played_Time_Duration":"", "isPreview" : isPreview, "Is_Synced" : 0 ,"Like": "", "Rating":""]
                
                let assetAnalytics  = AssetAnalyticsDetail(dict: dict)
                assetAnalytics.PlayMode = previousAssetAnalytics?.PlayMode
                pdfAnalyticsArray.append(assetAnalytics)
            }
        }
        pdfTimer?.invalidate()
        pdfTimer =   Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.hidethePdfOverlay), userInfo: nil, repeats: false)
        
        if (pdfTotalPgLbl.text?.count)! > 0{
            let totalPage = Int(pdfTotalPgLbl.text!)
            if pdfCurrentPage == totalPage{
                self.delegate?.didAssetFinishedPlaying(index: index)
            }
        }
    }
    
    @objc func hidethePdfOverlay()  {
        //        if !didPdfScrolling {
        pdfCountView.isHidden = true
        //        }
        didPdfScrolling = false
        
    }
    
    
    func didTapPDFScreen() {
        self.delegate?.childScreenTapped()
        
    }
    
}

extension AssetsPlayerChildViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !pdfWebkitView.isHidden {
            if scrollView.tag == 100 {
                
                let webView = scrollView.superview as! UIWebView
                
                let pageOffset : Float = Float(scrollView.contentOffset.y)
                
                var pagenumber = 0
                
                let scrollViewHeight = Int(scrollView.contentSize.height)
                if webView.tag == 0{
                    pagenumber =  Int(pageOffset / Float(webView.frame.size.height)) + 1;
                }else{
                    
                    let singlePageHeight = (scrollViewHeight/webView.tag)
                    let halfPage = webView.frame.size.height / 2
                    
                    pagenumber = Int(pageOffset + Float(halfPage))/singlePageHeight + 1
                }
                print("pagenumber" , pagenumber)
                
                pdfCountView.isHidden = false
                pdfTotalPgLbl.text = "\(webView.tag)"
                pdfCurrentPgLbl.text = "\(pagenumber)"
                pdfCurrentPage = pagenumber
                let currentPage = pagenumber
                let previousAssetAnalytics = pdfAnalyticsArray.last
                if pdfAnalyticsArray.count > 0 {
                    
                    if previousAssetAnalytics?.Part_Id != currentPage
                    {
                        let endTime = getCurrentDateAndTime()
                        previousAssetAnalytics?.Player_EndTime = endTime
                        previousAssetAnalytics?.Detailed_EndTime = getCurrentDateAndTime()
                        
                        
                        let dict : NSDictionary = ["DA_Code" : previousAssetAnalytics!.DA_Code, "Part_Id" : currentPage , "Part_URL" : previousAssetAnalytics!.Part_URL , "SessionId" : sessionID  , "Detailed_DateTime" : getCurrentDate() , "Detailed_StartTime" : getCurrentDateAndTime() , "Detailed_EndTime" : ""  ,"Player_Start_Time" :self.getCurrentDateAndTime() ,  "Played_Time_Duration":"", "isPreview" : isPreview, "Is_Synced" : 0 ,"Like": "", "Rating":""]
                        
                        let assetAnalytics  = AssetAnalyticsDetail(dict: dict)
                        assetAnalytics.PlayMode = previousAssetAnalytics?.PlayMode
                        pdfAnalyticsArray.append(assetAnalytics)
                    }
                    
                    previousPdfPage = currentPage
                }
                
                if currentPage == webView.tag{
                    self.delegate?.didAssetFinishedPlaying(index: index)
                }
            }
        }
    }
    
    func getContentOffsetForPageNumber(pageNumber : Int) -> Float {
        
        var pageOffset : Float = 0.0
        let scrollViewHeight = Int(pdfWebkitView.scrollView.contentSize.height)
        if pdfWebkitView.tag != 0{
            let singlePageHeight = (scrollViewHeight/pdfWebkitView.tag)
            // let halfPage = pdfWebVIewer.frame.size.height / 2
            
            pageOffset = Float(pageNumber) * (Float(singlePageHeight) )
        }
        return pageOffset
        
    }
    
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pdfCountView.isHidden = true
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pdfCountView.isHidden = true
    }
    
    
}

extension AssetsPlayerChildViewController : CustomAVPlayerDelegate{
    
    func screenTapped() {
        self.delegate?.childScreenTapped()
    }
    
    func didVideoPlayerFinishedPlaying() {
        self.delegate?.didAssetFinishedPlaying(index: index )
    }
    
    func didEnterOffline() {
        showActionForOffline()
    }
    
}

extension AssetsPlayerChildViewController : CustomAudioPlayerDelegate{
    
    func audioScreenTapped() {
        self.delegate?.childScreenTapped()
        
    }
    
    func didAudioPlayerFinishedPlaying() {
        self.delegate?.didAssetFinishedPlaying(index: index )
        
    }
    
    func didaudioPlayerEnterOffline() {
        showActionForOffline()
    }
}

extension AssetsPlayerChildViewController : UIGestureRecognizerDelegate{
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

//
//extension AssetsPlayerChildViewController : WKNavigationDelegate,WKUIDelegate {
//    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
//        loadingIndicator.stopAnimating()
//        loadingIndicator.isHidden = true
//    }
//
//    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        print("didStartProvisionalNavigation")
//    }
//
//
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        if (navigationAction.navigationType == .linkActivated){
//            decisionHandler(.cancel)
//        } else {
//            decisionHandler(.allow)
//        }
//        if webView.scrollView.tag == 200 {
//            var requestUrl = webView.url?.absoluteString
//            if htmlAnalyticsArraay.count > 0 {
//
//                if (requestUrl?.hasPrefix("js-frame:"))! {
//                    let components: [Any] = requestUrl!.components(separatedBy: ":")
//
//                    let receivedArgs = (components[1] as? String)
//                    enterTheHtmlAnalytics(requestUrl: receivedArgs!)
//                }else{
//
//                    requestUrl = requestUrl?.replacingOccurrences(of: "file://", with: "")
//                    lastActiveStateURL = requestUrl!
//                    let previousAssetAnalytics = htmlAnalyticsArraay.last
//                    if previousAssetAnalytics?.Part_URL != requestUrl {
//                        enterTheHtmlAnalytics(requestUrl: requestUrl!)
//                    }
//                }
//            }
//        }
//    }
//
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        loadingIndicator.stopAnimating()
//        loadingIndicator.isHidden = true
//
//        if webView.scrollView.tag == 200
//        {
//            currentAnalytics?.Player_StartTime = getCurrentDateAndTime()
//        }
//        else if webView.scrollView.tag == 100
//        {
//            currentAnalytics?.Player_StartTime = getCurrentDateAndTime()
//        }
//
//        removeCustomActivityView()
//        webView.backgroundColor = UIColor.white
//        for subView: UIView in webView.subviews {
//            if (subView is UIScrollView) {
//                for shadowView: UIView in subView.subviews {
//                    if (shadowView is UILabel) {
//                        shadowView.isHidden = true
//                    }
//                }
//            }
//        }
//        URLCache.shared.removeAllCachedResponses()
//        URLCache.shared.diskCapacity = 0
//        URLCache.shared.memoryCapacity = 0
//
//        if let cookies = HTTPCookieStorage.shared.cookies {
//            for cookie in cookies {
//                HTTPCookieStorage.shared.deleteCookie(cookie)
//            }
//        }
//        htmlWebkitView.stopLoading()
//    }
//
//}




extension AssetsPlayerChildViewController : UIWebViewDelegate{
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
        
        if webView.scrollView.tag == 200
        {
            currentAnalytics?.Player_StartTime = getCurrentDateAndTime()
        }
        else if webView.scrollView.tag == 100
        {
            currentAnalytics?.Player_StartTime = getCurrentDateAndTime()
        }
        
        removeCustomActivityView()
        webView.backgroundColor = UIColor.white
        for subView: UIView in webView.subviews {
            if (subView is UIScrollView) {
                for shadowView: UIView in subView.subviews {
                    if (shadowView is UILabel) {
                        shadowView.isHidden = true
                    }
                }
            }
        }
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        htmlWebkitView.stopLoading()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if webView.scrollView.tag == 200{
            var requestUrl = request.url?.absoluteString
            
            
            if htmlAnalyticsArraay.count > 0 {
                
                if (requestUrl?.hasPrefix("js-frame:"))! {
                    let components: [Any] = requestUrl!.components(separatedBy: ":")
                    
                    let receivedArgs = (components[1] as? String)
                    enterTheHtmlAnalytics(requestUrl: receivedArgs!)
                }else{
                    
                    requestUrl = requestUrl?.replacingOccurrences(of: "file://", with: "")
                    lastActiveStateURL = requestUrl!
                    let previousAssetAnalytics = htmlAnalyticsArraay.last
                    if previousAssetAnalytics?.Part_URL != requestUrl {
                        enterTheHtmlAnalytics(requestUrl: requestUrl!)
                    }
                }
                
            }
            
        }
        return true
    }
    
    func enterTheHtmlAnalytics(requestUrl : String){
        
        
        let previousAssetAnalytics = htmlAnalyticsArraay.last
        
        let endTime = getCurrentDateAndTime()
        previousAssetAnalytics?.Player_EndTime = endTime
        previousAssetAnalytics?.Detailed_EndTime = endTime
        
        let dict : NSDictionary = ["DA_Code" : previousAssetAnalytics!.DA_Code, "Part_Id" : 1 , "Part_URL" : requestUrl , "SessionId" : previousAssetAnalytics?.Session_Id ?? 1  , "Detailed_DateTime" : getCurrentDate() , "Detailed_StartTime" : endTime , "Detailed_EndTime" : ""  , "Player_Start_Time" : endTime , "Detailed_EndTime" : "" , "Played_Time_Duration":"", "isPreview" : isPreview, "Is_Synced" : 0 ,"Like": "", "Rating":""]
        
        let assetAnalytics  = AssetAnalyticsDetail(dict: dict)
        assetAnalytics.PlayMode = previousAssetAnalytics?.PlayMode
        
        currentAnalytics = assetAnalytics
        currentAnalytics.Doc_Type = currentAssetObj.assetObj.docType
        
        htmlAnalyticsArraay.append(currentAnalytics)
    }
    
    func didTapHTMLScreen() {
        self.delegate?.childScreenTapped()
    }
}
