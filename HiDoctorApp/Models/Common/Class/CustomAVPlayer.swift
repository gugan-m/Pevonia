//
//  CustomAVPlayer.swift
//  Sample
//
//  Created by Admin on 5/17/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

protocol CustomAVPlayerDelegate: class {
    func screenTapped()
    func didVideoPlayerFinishedPlaying()
    func didEnterOffline()
}

class CustomAVPlayer: NSObject , UIGestureRecognizerDelegate , AVPlayerViewControllerDelegate{
    let playerViewController = AVPlayerViewController()
    weak var delegate: CustomAVPlayerDelegate?

    var player = AVPlayer()
    var controlsView = AVControlsVIew()
    var volume = 0.0
    var brightness = 0.0
    //let qualityArray = DataManager.sharedManager.qualityArray
    var asset  = AssetsPlayListModel()
    var assetAnalytics : AssetAnalyticsDetail!
    var videoAssetAnalyticsArray = [AssetAnalyticsDetail]()
    var prevSliderValue : Float = 0.0
    var sessionID = 0
    var isPreview = 0
    var isSlidderDragging = false
    var orientation = UIDeviceOrientation(rawValue: 0)
    var isOnlineMode = false
    var isEnteredOffline = true
    var isFirsttimeNotifying = true
    var didVideoPlayerPlayed = false
    var progressTimer : Timer?
    
    func setControlsView(controlsView: AVControlsVIew)  {
        self.controlsView = controlsView
    }

    
    func setPlayerFrame(frame:CGRect)  {
        playerViewController.view.frame = frame
        loadTheControls()
        controlsView.playOrPauseBtn.addTarget(self, action: #selector(didTapPlayBtn(button:)), for: .touchUpInside)
        controlsView.backwardBtn.addTarget(self, action: #selector(backwardSecondsTheAV), for: .touchUpInside)
        controlsView.forwardBtn.addTarget(self, action: #selector(forwardSecondsTheAV), for: .touchUpInside)
        controlsView.settingsBtn.addTarget(self, action: #selector(hideOrShowTheQualityTableView), for: .touchUpInside)
        controlsView.qualityTableView.delegate = self
        controlsView.qualityTableView.dataSource = self
    }
    
    func setAssetAnalytics(assetAnalytics : AssetAnalyticsDetail)  {
        self.assetAnalytics = assetAnalytics
        assetAnalytics.Player_StartTime = "\(Int(controlsView.playProgressSlider.value))"
        videoAssetAnalyticsArray = [AssetAnalyticsDetail]()
        videoAssetAnalyticsArray.append(self.assetAnalytics)
    }
    
    func setAssetModel (assetModel : AssetsPlayListModel){
    self.asset = assetModel
    }
    
    
    func loadTheControls()  {
        let tap = UITapGestureRecognizer(target: self, action: #selector (self.respondToTapGesture))
        tap.delegate = self
        controlsView.addGestureRecognizer(tap)
        
        // for next phase
        let rightPan = UIPanGestureRecognizer(target: self, action: #selector (self.respondToPanGesture))
        controlsView.rightView?.tag = 1
        rightPan.delegate = self
        controlsView.rightView.addGestureRecognizer(rightPan)
        
        let leftPan = UIPanGestureRecognizer(target: self, action: #selector (self.respondToPanGesture))
        controlsView.leftView?.tag = 2
        leftPan.delegate = self
        controlsView.leftView.addGestureRecognizer(leftPan)

        let controlsPan = UIPanGestureRecognizer(target: self, action: #selector (self.respondToPanGesture))
        controlsView.containerView?.tag = 3
        controlsPan.delegate = self
        controlsView.containerView.addGestureRecognizer(controlsPan)
        
        controlsView.volumeSlider.addTarget(self, action: #selector(volumeValueChanged), for: .valueChanged)
        controlsView.brightnessSlider.addTarget(self, action: #selector(brightnessValueChanged), for: .valueChanged)
        
        
        
        controlsView.playProgressSlider.addTarget(self, action: #selector(onSliderValChanged(_:for:)), for: .valueChanged)
        controlsView.timeLabel.isHidden = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(playProgressSliderTapped))
        controlsView.playProgressSlider.addGestureRecognizer(tapGestureRecognizer)
        //controlsView.playProgressSlider.isContinuous = false
        orientation = UIDevice.current.orientation
        orientationDidChange()
        
        if SwifterSwift().isPad{
            controlsView.playOrPauseBtn.setImage(UIImage.init(named: "icon-play-LS"), for: .normal)
        }else{
            if UIScreen.main.bounds.height > UIScreen.main.bounds.width{
                controlsView.playOrPauseBtn.setImage(UIImage.init(named: "icon-play-PT"), for: .normal)
            }else{
                controlsView.playOrPauseBtn.setImage(UIImage.init(named: "icon-play-LS"), for: .normal)
            }
        }
        
        controlsView.playOrPauseBtn.tag = 0

    }
    
    
    @objc func hideOrShowTheQualityTableView()  {
        controlsView.qualityTableView.isHidden = !controlsView.qualityTableView.isHidden
        UIView.transition(with: controlsView.qualityTableView, duration: 5.0, options: .curveLinear, animations: {
            
        }, completion: nil)
    }
    
    
    func playTheAV(videoURL: URL) {
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.itemDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.itemDidJumpedPlaying), name: NSNotification.Name.AVPlayerItemTimeJumped, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.orientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
  
        NotificationCenter.default.addObserver(self, selector: #selector(self.itemDidFailedPlaying(_:)), name: NSNotification.Name.AVPlayerItemFailedToPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.itemDidFailedPlaying(_:)), name: NSNotification.Name.AVPlayerItemNewErrorLogEntry, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.itemDidFailedPlaying(_:)), name: NSNotification.Name.AVPlayerItemNewAccessLogEntry, object: nil)
        
        player = AVPlayer(url: videoURL)
        controlsView.playOrPauseBtn.tag = 1
        playerViewController.showsPlaybackControls = false
        playerViewController.player = player
        
        startPlayingAV()
        
        assetAnalytics.Player_StartTime = "0"
        controlsView.playProgressSlider.value = 0

        controlsView.playProgressSlider.minimumValue = 0
     //   player.automaticallyWaitsToMinimizeStalling = false
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if  keyPath == "status" {
            if player.status == .readyToPlay {
            }
            else if player.status == .failed {
                // something went wrong. player.error should contain some information
                if SwifterSwift().isPad{
                    controlsView.playOrPauseBtn.setImage(UIImage.init(named: "icon-play-LS"), for: .normal)
                }else{
                    if UIScreen.main.bounds.height > UIScreen.main.bounds.width{
                        controlsView.playOrPauseBtn.setImage(UIImage.init(named: "icon-play-PT"), for: .normal)
                    }else{
                        controlsView.playOrPauseBtn.setImage(UIImage.init(named: "icon-play-LS"), for: .normal)
                    }
                }
            }
        }
    }
    
    
    func playerViewControllerDidStopPictureInPicture(_ playerViewController: AVPlayerViewController) {
        print("stopped")
    }
    
    @objc func orientationDidChange()  {
         orientation = UIDevice.current.orientation
        print(orientation ?? 0, "orientation")
        
        print("screen",UIScreen.main.bounds)
        if !SwifterSwift().isPad{
        if UIScreen.main.bounds.height > UIScreen.main.bounds.width{
        
            if controlsView.playOrPauseBtn.tag == 1{
              controlsView.playOrPauseBtn.setImage(UIImage.init(named: "icon-play-pause-PT"), for: .normal)
            }else {
                 controlsView.playOrPauseBtn.setImage(UIImage.init(named: "icon-play-PT"), for: .normal)
            }
              controlsView.previousBtn.setImage(UIImage.init(named: "icon-play-previous-PT"), for: .normal)
            controlsView.nextBtn.setImage(UIImage.init(named: "icon-play-next-PT"), for: .normal)
            controlsView.forwardBtn.setImage(UIImage.init(named: "icon-play-forward-PT"), for: .normal)
            controlsView.backwardBtn.setImage(UIImage.init(named: "icon-play-backward-PT"), for: .normal)
        }else {
            
                 if controlsView.playOrPauseBtn.tag == 1{
            controlsView.playOrPauseBtn.setImage(UIImage.init(named: "icon-play-pause-LS"), for: .normal)
                 }else {
                    controlsView.playOrPauseBtn.setImage(UIImage.init(named: "icon-play-LS"), for: .normal)
                 }
            controlsView.previousBtn.setImage(UIImage.init(named: "icon-play-previous-LS"), for: .normal)
            controlsView.nextBtn.setImage(UIImage.init(named: "icon-play-next-LS"), for: .normal)
            controlsView.forwardBtn.setImage(UIImage.init(named: "icon-play-forward-LS"), for: .normal)
            controlsView.backwardBtn.setImage(UIImage.init(named: "icon-play-backward-LS"), for: .normal)
        }
    }
    }
    
    
    func startPlayingAV()  {
        if  player.currentTime() == player.currentItem?.duration{
            player.seek(to: CMTimeMake(0, 1))

        }
        
        if !SwifterSwift().isPad{
            if UIScreen.main.bounds.height > UIScreen.main.bounds.width{
                controlsView.playOrPauseBtn.setImage(UIImage.init(named: "icon-play-pause-PT"), for: .normal)
            }else{
                controlsView.playOrPauseBtn.setImage(UIImage.init(named: "icon-play-pause-LS"), for: .normal)
            }
        }else{
            controlsView.playOrPauseBtn.setImage(UIImage.init(named: "icon-play-pause-LS"), for: .normal)
        }
        
        player.play()
        
       progressTimer =  Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.updateThePlayProgressSlider), userInfo: nil, repeats: true)

        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.hideTheContainerView), userInfo: nil, repeats: false)

    }
    
    func pauseTheAV()  {
        player.pause()

    }
    
    func stopTheAV()  {
        player.seek(to: CMTimeMake(0, 1))
    }
    
    func stopTimer(){
        progressTimer?.invalidate()
    }
    
    @objc func forwardSecondsTheAV()  {
        
        
        let slidervalue = controlsView.playProgressSlider.value
        if videoAssetAnalyticsArray.count > 0{
        let previousAssetAnalytics = videoAssetAnalyticsArray.last
        previousAssetAnalytics?.Detailed_EndTime = getCurrentDateAndTime()
        previousAssetAnalytics?.Player_EndTime = "\(Int(slidervalue))"
        var duration = prevSliderValue - Float(previousAssetAnalytics!.Player_StartTime)!
        
        if duration < 0{
            duration = duration * -1
        }
        previousAssetAnalytics?.Played_Time_Duration = Int(duration)
        
        }
          let forwardTime = CMTimeAdd(player.currentTime(), CMTimeMakeWithSeconds(10, 1))
        player.seek(to: forwardTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        
        // controlsView.playProgressSlider.setValue(Float(newValue), animated: true)
        // player.seek(to: CMTimeMakeWithSeconds(Float64(newValue), 1))
        //player.currentTime() = CMTimeMakeWithSeconds(newValue, preferredTimescale: Int32)(Int64(n1) , 10000)
        
        var dur: Float64 = CMTimeGetSeconds(forwardTime)
        
        if dur > playerTimeInSeconds(){
            dur = playerTimeInSeconds()
        }else if dur < 0{
            dur = 0
        }

        createNewAnalytics(startTime: Float(dur))
      

    }
    
    @objc func backwardSecondsTheAV()  {
        let slidervalue = controlsView.playProgressSlider.value
        if videoAssetAnalyticsArray.count > 0{
        let previousAssetAnalytics = videoAssetAnalyticsArray.last
        previousAssetAnalytics?.Detailed_EndTime = getCurrentDateAndTime()
        previousAssetAnalytics?.Player_EndTime = "\(Int(slidervalue))"
        let duration = prevSliderValue - Float(previousAssetAnalytics!.Player_StartTime)!
        
        previousAssetAnalytics?.Played_Time_Duration = Int(duration)
        }
        
        let backwardTime = CMTimeAdd(player.currentTime(), CMTimeMakeWithSeconds(-10, 1))
        player.seek(to: backwardTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        
        // controlsView.playProgressSlider.setValue(Float(newValue), animated: true)
        // player.seek(to: CMTimeMakeWithSeconds(Float64(newValue), 1))
        //player.currentTime() = CMTimeMakeWithSeconds(newValue, preferredTimescale: Int32)(Int64(n1) , 10000)
        var dur: Float64 = CMTimeGetSeconds(backwardTime)

        if dur > playerTimeInSeconds(){
            dur = playerTimeInSeconds()
        }else if dur < 0{
            dur = 0
        }
        createNewAnalytics(startTime: Float(dur))
       
    }
    
    
    @objc func itemDidFinishPlaying()  {
        
        
        self.delegate?.didVideoPlayerFinishedPlaying()
        if  videoAssetAnalyticsArray.count > 0{
            let slidervalue = controlsView.playProgressSlider.maximumValue
            let previousAssetAnalytics = videoAssetAnalyticsArray.last
            previousAssetAnalytics?.Detailed_EndTime = getCurrentDateAndTime()
            previousAssetAnalytics?.Player_EndTime = "\(Int(slidervalue))"
            var duration = prevSliderValue - Float(previousAssetAnalytics!.Player_StartTime)!
            
            if duration < 0{
                duration = duration * -1
            }
            previousAssetAnalytics?.Played_Time_Duration = Int(duration)
        }
        
        if SwifterSwift().isPad{
        controlsView.playOrPauseBtn.setImage(UIImage.init(named: "icon-play-LS"), for: .normal)
        }else{
            if UIScreen.main.bounds.height > UIScreen.main.bounds.width{
                controlsView.playOrPauseBtn.setImage(UIImage.init(named: "icon-play-PT"), for: .normal)
            }else{
                controlsView.playOrPauseBtn.setImage(UIImage.init(named: "icon-play-LS"), for: .normal)
            }
        }
        controlsView.playOrPauseBtn.tag = 0
        controlsView.playProgressSlider.value = 0.0
        controlsView.containerView.isHidden = false
        controlsView.progressView.isHidden = false
         AssetsDataManager.sharedManager.isSubviewsHidden = controlsView.containerView.isHidden
        
        
        stopTheAV()
    }
    
    
    @objc func itemDidJumpedPlaying()  {
        print("current time", currentTimeInSeconds())
        //controlsView.playProgressSlider.value = Float(currentTimeInSeconds())
    }
    
    @objc func itemDidFailedPlaying(_ notification: Notification){
        _ = notification.userInfo?[AVPlayerItemFailedToPlayToEndTimeErrorKey] as? Error
 
    }
    
    @objc func didTapPlayBtn(button:UIButton)  {
        
        if button.tag == 1{
            if !SwifterSwift().isPad{
             if UIScreen.main.bounds.height > UIScreen.main.bounds.width{
            controlsView.playOrPauseBtn.setImage(UIImage.init(named: "icon-play-PT"), for: .normal)
             }else{
              controlsView.playOrPauseBtn.setImage(UIImage.init(named: "icon-play-LS"), for: .normal)
            }
            }else{
              controlsView.playOrPauseBtn.setImage(UIImage.init(named: "icon-play-LS"), for: .normal)
            }
            button.tag = 0
        pauseTheAV()
        }else {
            if !SwifterSwift().isPad{
            if UIScreen.main.bounds.height > UIScreen.main.bounds.width{
            controlsView.playOrPauseBtn.setImage(UIImage.init(named: "icon-play-pause-PT"), for: .normal)
            }else{
                controlsView.playOrPauseBtn.setImage(UIImage.init(named: "icon-play-pause-LS"), for: .normal)
            }
        }else{
            controlsView.playOrPauseBtn.setImage(UIImage.init(named: "icon-play-pause-LS"), for: .normal)
            }
            
            
            if player.currentItem?.currentTime() == CMTimeMake(0, 1){
                createNewAnalytics(startTime: 0)
            }
            startPlayingAV()
            button.tag = 1
        }
    }
    
    @objc func respondToTapGesture(gesture: UITapGestureRecognizer)  {
        controlsView.containerView.isHidden = !controlsView.containerView.isHidden
        if !isSlidderDragging{
        controlsView.progressView.isHidden = controlsView.containerView.isHidden
        }
        AssetsDataManager.sharedManager.isSubviewsHidden = controlsView.containerView.isHidden
        self.delegate?.screenTapped()
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.hideTheContainerView), userInfo: nil, repeats: false)
        

    }
    
    @objc func respondToPanGesture(gesture: UIPanGestureRecognizer)  {
        
        let vel: CGPoint = gesture.velocity(in: controlsView)
        
        
        let direction = panGestureDirection(velocity: vel)
        
        if gesture.view?.tag == 1{
            
            if direction == Direction.Up{
                volume = volume + 0.03
            }else if direction == Direction.Down {
                volume = volume - 0.03
            }
            
            if volume < 0.0 {
                volume = 0.0
            }else if(volume > 1.0){
                volume = 1.0
            }
            if direction == Direction.Up || direction == Direction.Down{
            controlsView.volumeSlider.value = Float(volume)
            volumeValueChanged(volume: Float(volume))
            }
        }else if gesture.view?.tag == 2{
            
            if direction == Direction.Up{
                brightness = brightness + 0.03
            }else if direction == Direction.Down {
                brightness = brightness - 0.03
            }
            
            if brightness < 0.0 {
                brightness = 0.0
            }else if(brightness > 1.0){
                brightness = 1.0
            }
            if direction == Direction.Up || direction == Direction.Down{
            controlsView.brightnessSlider.value = Float(brightness)
            brightnessValueChanged(brightness:Float(brightness))
            }
        }else if gesture.view?.tag == 3{
            controlsView.containerView.isHidden = true
        }
        
        if gesture.state == .ended{
            controlsView.brightnOrVolumeVw.isHidden = true

        }
    }

    @objc func volumeValueChanged(volume:Float)  {
        controlsView.containerView.isHidden = true
        controlsView.volumeSlider.isHidden = false
        controlsView.volumeSlider.isHidden = true
        controlsView.brightnOrVolumeVw.isHidden = false
        controlsView.brightOrVolTxtLbl.text = "Volume"
        controlsView.brightOrVolumeLbl.text = "\(Int(volume * 10))"
        player.volume = volume
        print("volume",volume)
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.hideTheVolumeSlider), userInfo: nil, repeats: false)

    }
    
    @objc func brightnessValueChanged(brightness : Float)  {
        controlsView.containerView.isHidden = true
        controlsView.brightnessSlider.isHidden = false
        controlsView.brightnessSlider.isHidden = true
        controlsView.brightnOrVolumeVw.isHidden = false
        controlsView.brightOrVolumeLbl.text = "\(Int(brightness * 10))"
        controlsView.brightOrVolTxtLbl.text = "Brightness"


        UIScreen.main.brightness = CGFloat(brightness)
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.hideTheBrightnessSlider), userInfo: nil, repeats: false)

    }
    
    @objc func updateThePlayProgressSlider()  {
        
        
         let playerTime = Float(playerTimeInSeconds())
         if !playerTime.isNaN {
        controlsView.playProgressSlider.maximumValue = Float(playerTimeInSeconds())
        let currentTime = Float(self.currentTimeInSeconds())
            if !isSlidderDragging{
        controlsView.playProgressSlider.value = currentTime
            }
        prevSliderValue = currentTime
        let totalTime = secondsToHoursMinutesSeconds(seconds: Int(playerTime))
        
        controlsView.videoEndtimeLabel.text =  "\(totalTime.1)" + ":" + "\( totalTime.2)"
        let endTime = secondsToHoursMinutesSeconds(seconds: Int(currentTime))
       // assetAnalytics.Player_EndTime = "\(controlsView.playProgressSlider.value)"
        controlsView.videoStartTimeLabel.text = "\(endTime.1)" + ":" + "\( endTime.2)"

            didVideoPlayerPlayed = true
        }
    
        if isOnlineMode{
            if !checkInternetConnectivity(){
                if !didVideoPlayerPlayed{
                    controlsView.playProgressSlider.isEnabled = false
                    if SwifterSwift().isPad{
                        controlsView.playOrPauseBtn.setImage(UIImage.init(named: "icon-play-LS"), for: .normal)
                    }else{
                        if UIScreen.main.bounds.height > UIScreen.main.bounds.width{
                            controlsView.playOrPauseBtn.setImage(UIImage.init(named: "icon-play-PT"), for: .normal)
                        }else{
                            controlsView.playOrPauseBtn.setImage(UIImage.init(named: "icon-play-LS"), for: .normal)
                        }
                    }
                }else{
                   controlsView.playProgressSlider.isEnabled = true
                }
                isEnteredOffline = true
            }else{
                controlsView.playProgressSlider.isEnabled = true
                isEnteredOffline = false
                isFirsttimeNotifying = true
            }
            
            if isEnteredOffline && isFirsttimeNotifying{
                //showToastView(toastText: internetOfflineMessage)
                self.delegate?.didEnterOffline()
                isFirsttimeNotifying = false
            }
        }else{
            controlsView.playProgressSlider.isEnabled = true
        }
    
        
        
        
    }
    
    
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) { return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60) }
    
    func currentTimeInSeconds() -> Float64 {
        let dur: Float64 = CMTimeGetSeconds(player.currentItem!.currentTime())
        return dur
    }
    
    func playerTimeInSeconds() -> Float64 {
        if player.currentItem?.duration != nil{
        let dur: Float64 = CMTimeGetSeconds((player.currentItem?.duration)!)
        return dur
        }
        return 0.0
    }
    
    
    @objc func playProgressSliderTapped(gestureRecognizer: UIGestureRecognizer) {
        
        let slidervalue = controlsView.playProgressSlider.value
        if videoAssetAnalyticsArray.count > 0{
        let previousAssetAnalytics = videoAssetAnalyticsArray.last
        previousAssetAnalytics?.Detailed_EndTime = getCurrentDateAndTime()
        previousAssetAnalytics?.Player_EndTime = "\(Int(slidervalue))"
        var duration = prevSliderValue - Float(previousAssetAnalytics!.Player_StartTime)!
        
        if duration < 0{
            duration = duration * -1
        }
        previousAssetAnalytics?.Played_Time_Duration = Int(duration)
        }
//        let pointTapped: CGPoint = gestureRecognizer.location(in: gestureRecognizer.view)
//        
//        let positionOfSlider: CGPoint = controlsView.playProgressSlider.frame.origin
//        let widthOfSlider: CGFloat = controlsView.playProgressSlider.frame.size.width
//        let newValue = ((pointTapped.x - positionOfSlider.x) * CGFloat(controlsView.playProgressSlider.maximumValue) / widthOfSlider)
      
       // controlsView.playProgressSlider.setValue(Float(newValue), animated: true)
       // player.seek(to: CMTimeMakeWithSeconds(Float64(newValue), 1))
        //player.currentTime() = CMTimeMakeWithSeconds(newValue, preferredTimescale: Int32)(Int64(n1) , 10000)
        
        let point = gestureRecognizer.location(in: controlsView.playProgressSlider)
        let percentage = Float(point.x / controlsView.playProgressSlider.bounds.width)
        let delta = percentage * (controlsView.playProgressSlider.maximumValue - controlsView.playProgressSlider.minimumValue)
        let newValue = controlsView.playProgressSlider.minimumValue + delta
        
        let timeScale = player.currentItem?.asset.duration.timescale
        let time = CMTimeMakeWithSeconds(Float64(newValue), timeScale!)
        player.seek(to: time, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        createNewAnalytics(startTime: newValue)

//        if !checkInternetConnectivity() {
//            showToastViewWithShortTime(toastText: internetOfflineMessage)
//            
//        }
    }
    
    
    
    @objc func onSliderValChanged(_ slider: UISlider, for event: UIEvent) {
        let touchEvent: UITouch? = event.allTouches?.first
        
        if touchEvent?.phase == UITouchPhase.began{
            
            controlsView.progressView.isHidden = false
            if videoAssetAnalyticsArray.count > 0{
            let previousAssetAnalytics = videoAssetAnalyticsArray.last
            previousAssetAnalytics?.Detailed_EndTime = getCurrentDateAndTime()
            previousAssetAnalytics?.Player_EndTime = "\(Int(prevSliderValue))"
            let duration = Float(previousAssetAnalytics!.Player_StartTime)! - prevSliderValue
            previousAssetAnalytics?.Played_Time_Duration = Int(duration)
            }
            controlsView.timeLabel.isHidden = false
            print("began")
            isSlidderDragging = true
            
        }else if touchEvent?.phase == UITouchPhase.moved{
            
            controlsView.timeLabel.isHidden = false
            controlsView.progressView.isHidden = false
            isSlidderDragging = true

            let currentTime = secondsToHoursMinutesSeconds(seconds: Int(slider.value))
            controlsView.timeLabel.text =  "\(currentTime.1)" + ":" + "\( currentTime.2)"

        }else if touchEvent?.phase == UITouchPhase.ended{
            controlsView.timeLabel.isHidden = true
            
            let timeScale = player.currentItem?.asset.duration.timescale
            let time = CMTimeMakeWithSeconds(Float64(slider.value), timeScale!)
            player.seek(to: time, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
            isSlidderDragging = false

            createNewAnalytics(startTime: slider.value)

        }else{

        }
    
    }
    
    
    func createNewAnalytics(startTime: Float )  {
        
        let dict : NSDictionary = ["DA_Code" : assetAnalytics.DA_Code, "Part_Id" : 1 , "Part_URL" : assetAnalytics.Part_URL, "SessionId" : sessionID , "Detailed_DateTime" : getCurrentDate() , "Detailed_StartTime" : getCurrentDateAndTime() , "Detailed_EndTime" : ""  , "Player_Start_Time" :"\(Int(startTime))" , "Detailed_EndTime" : "" , "Played_Time_Duration":"", "isPreview" : isPreview, "Is_Synced" : 0 ,"Like": "", "Rating":""]
        
        let newAssetAnalytics = AssetAnalyticsDetail(dict:dict)
        newAssetAnalytics.PlayMode = assetAnalytics.PlayMode
        videoAssetAnalyticsArray.append(newAssetAnalytics)
    }
    
    func enterEndTimeForLastAnalytics(endTime : Float){
        
        if videoAssetAnalyticsArray.count > 0{
        let previousAssetAnalytics = videoAssetAnalyticsArray.last
        previousAssetAnalytics?.Detailed_EndTime = getCurrentDateAndTime()
        previousAssetAnalytics?.Player_EndTime = "\(Int(endTime))"
        let duration = Float(previousAssetAnalytics!.Player_StartTime)! - endTime
        previousAssetAnalytics?.Played_Time_Duration = Int(duration)
        }
    }
    
    func durationInSeconds(duration:CMTime) -> Float64 {
        let dur: Float64 = CMTimeGetSeconds(duration)
        return dur
    }
    
    @objc func hideTheVolumeSlider()  {
        controlsView.volumeSlider.isHidden = true
    }
    
    @objc func hideTheBrightnessSlider()  {
        controlsView.brightnessSlider.isHidden = true

    }
    
    @objc func hideTheContainerView(){
        controlsView.containerView.isHidden = true
        if !isSlidderDragging{
        controlsView.progressView.isHidden = true
        }
         AssetsDataManager.sharedManager.isSubviewsHidden = controlsView.containerView.isHidden
    }
    
    
    func availableDuration() -> TimeInterval {
        let loadedTimeRanges = player.currentItem?.loadedTimeRanges
        if (loadedTimeRanges?.count)! > 0{
        let timeRange : CMTimeRange = loadedTimeRanges?[0] as! CMTimeRange
        let startSeconds: Float64? = CMTimeGetSeconds(timeRange.start)
        let durationSeconds: Float64? = CMTimeGetSeconds(timeRange.duration)
        let result: TimeInterval = startSeconds! + durationSeconds!
        
        print("result" , result)
        
        return result
        }
        return 0
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: controlsView.qualityTableView))!{
            return false
        }
        if (touch.view?.isDescendant(of: controlsView.progressView))!{
            controlsView.progressView.isHidden = false
        }
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let gesture = gestureRecognizer as? UIPanGestureRecognizer{
            var vel = CGPoint()
            if gesture.view?.tag == 3{

             vel = gesture.velocity(in: controlsView.containerView)
            }else{
                 vel = gesture.velocity(in: controlsView.gestureView)
            }

            return fabs(vel.y) > fabs(vel.x);
        }
        return true
    }
    

    
    func getCurrentDateAndTime() -> String{
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = dateTimeForAssets
        //dateFormatter.timeZone = localTimeZone
        
        print("df", NSTimeZone.default, "ct" , TimeZone.current.identifier)
        let dateObj = dateFormatter.string(from: Date())
        
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
        dateFormatter.timeZone = localTimeZone
        dateFormatter.dateFormat = dateTimeForAssets
        let date = dateFormatter.date(from: dateString)
        if date != nil {
            return date!
            
        }
        return Date()
    }
    
    
    func getStringFromDate(date : Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = localTimeZone
        dateFormatter.dateFormat = dateTimeForAssets
        let dateStr = dateFormatter.string(from: date)
        return dateStr
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


extension CustomAVPlayer:  UITableViewDelegate,UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AVQualityTableViewCell")
        
        return cell!
    }
}
