//
//  CustomAudioPlayer.swift
//  Sample
//
//  Created by Admin on 6/13/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

protocol CustomAudioPlayerDelegate: class {
        func audioScreenTapped()
        func didAudioPlayerFinishedPlaying()
        func didaudioPlayerEnterOffline()

}

class CustomAudioPlayer: NSObject , UIGestureRecognizerDelegate,AVPlayerViewControllerDelegate{
        weak var delegate: CustomAudioPlayerDelegate?
        
        var player = AVPlayer()
        var controlsView = AudioPlayerControlsView()
        var volume = 0.0
        var brightness = 0.0
        //let qualityArray = DataManager.sharedManager.qualityArray
        var asset  = AssetsPlayListModel()
        var assetAnalytics : AssetAnalyticsDetail!
        var audioAssetAnalyticsArray = [AssetAnalyticsDetail]()
        var prevSliderValue : Float = 0.0
        var sessionID = 0
        var isPreview = 0
        var isSlidderDragging = false
        var isOnlineMode = false
        var isEnteredOffline = true
        var isFirsttimeNotifying = true
        var didaudioPlayerPlayed = false
        var progressTimer : Timer?

        func setControlsView(controlsView: AudioPlayerControlsView)  {
            self.controlsView = controlsView
            loadTheControls()

        }
        
        func setAssetAnalytics(assetAnalytics : AssetAnalyticsDetail)  {
            self.assetAnalytics = assetAnalytics
            assetAnalytics.Player_StartTime = "\(Int(controlsView.playProgressSlider.value))"
            audioAssetAnalyticsArray = [AssetAnalyticsDetail]()
            audioAssetAnalyticsArray.append(self.assetAnalytics)
        }
        
        func setAssetModel (assetModel : AssetsPlayListModel){
            self.asset = assetModel
        }
        
        
        func loadTheControls()  {
            controlsView.playOrPauseBtn.addTarget(self, action: #selector(didTapPlayBtn(button:)), for: .touchUpInside)

            let tap = UITapGestureRecognizer(target: self, action: #selector (self.respondToTapGesture))
            tap.delegate = self
            controlsView.addGestureRecognizer(tap)
            controlsView.playProgressSlider.addTarget(self, action: #selector(onSliderValChanged(_:for:)), for: .valueChanged)
            controlsView.timeLabel.isHidden = true
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(playProgressSliderTapped))
            controlsView.playProgressSlider.addGestureRecognizer(tapGestureRecognizer)
            //controlsView.playProgressSlider.isContinuous = false
            
            controlsView.playOrPauseBtn.setImage(UIImage.init(named: "icon-play-LS"), for: .normal)
            
            controlsView.playOrPauseBtn.tag = 0
            
        }
        
    
        
        func playTheAudio(audioURL: URL) {
            
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.itemDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.itemDidJumpedPlaying), name: NSNotification.Name.AVPlayerItemTimeJumped, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.itemDidFailedPlaying(_:)), name: NSNotification.Name.AVPlayerItemFailedToPlayToEndTime, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.itemDidFailedPlaying(_:)), name: NSNotification.Name.AVPlayerItemNewErrorLogEntry, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.itemDidFailedPlaying(_:)), name: NSNotification.Name.AVPlayerItemNewAccessLogEntry, object: nil)
            
            player = AVPlayer(url: audioURL)
            controlsView.playOrPauseBtn.tag = 1
            
            startPlayingAudio()
            
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
        
    
        func startPlayingAudio()  {
            if  player.currentTime() == player.currentItem?.duration{
                player.seek(to: CMTimeMake(0, 1))
                
            }
 
            controlsView.playOrPauseBtn.setImage(UIImage.init(named: "icon-play-pause-LS"), for: .normal)
            
            if #available(iOS 10.0, *) {
                player.playImmediately(atRate: 1.0)
                player.automaticallyWaitsToMinimizeStalling = false
            } else {
                // Fallback on earlier versions
                player.play()

            }
            
          progressTimer =   Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.updateThePlayProgressSlider), userInfo: nil, repeats: true)
                    
        }
        
        func pauseTheAudio()  {
            player.pause()
            
        }
        
        func stopTheAudio()  {
            player.seek(to: CMTimeMake(0, 1))
        }
    
        func stopTimer(){
            progressTimer?.invalidate()
        }
    
        @objc func itemDidFinishPlaying()  {
            
            
            self.delegate?.didAudioPlayerFinishedPlaying()
            if  audioAssetAnalyticsArray.count > 0{
                let slidervalue = controlsView.playProgressSlider.maximumValue
                let previousAssetAnalytics = audioAssetAnalyticsArray.last
                previousAssetAnalytics?.Detailed_EndTime = getCurrentDateAndTime()
                previousAssetAnalytics?.Player_EndTime = "\(Int(slidervalue))"
                var duration = prevSliderValue - Float(previousAssetAnalytics!.Player_StartTime)!
                
                if duration < 0{
                    duration = duration * -1
                }
                previousAssetAnalytics?.Played_Time_Duration = Int(duration)
            }
            
            controlsView.playOrPauseBtn.setImage(UIImage.init(named: "icon-play-LS"), for: .normal)
       
            controlsView.playOrPauseBtn.tag = 0
            controlsView.playProgressSlider.value = 0.0
            controlsView.progressView.isHidden = false
            
            stopTheAudio()
        }
        
        
        @objc func itemDidJumpedPlaying()  {
            print("current time", currentTimeInSeconds())
            //controlsView.playProgressSlider.value = Float(currentTimeInSeconds())
        }
        
        @objc func itemDidFailedPlaying(_ notification: Notification){
            let error = notification.userInfo?[AVPlayerItemFailedToPlayToEndTimeErrorKey] as? Error
            
        }
        
        @objc func didTapPlayBtn(button:UIButton)  {
            
            if button.tag == 1{

                controlsView.playOrPauseBtn.setImage(UIImage.init(named: "icon-play-LS"), for: .normal)

                button.tag = 0
                pauseTheAudio()
            }else {
                
                controlsView.playOrPauseBtn.setImage(UIImage.init(named: "icon-play-pause-LS"), for: .normal)
      
                if player.currentItem?.currentTime() == CMTimeMake(0, 1){
                    createNewAnalytics(startTime: 0)
                }
                startPlayingAudio()
                button.tag = 1
            }
        }
        
        @objc func respondToTapGesture(gesture: UITapGestureRecognizer)  {

            self.delegate?.audioScreenTapped()
            //Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.hideTheContainerView), userInfo: nil, repeats: false)
            
        }
    
        @objc func updateThePlayProgressSlider()  {
            
            
            let playerTime = Float(playerTimeInSeconds())
            if !playerTime.isNaN  && player.currentItem != nil{
                controlsView.playProgressSlider.maximumValue = Float(playerTimeInSeconds())
                let currentTime = Float(self.currentTimeInSeconds())
                if !isSlidderDragging{
                    controlsView.playProgressSlider.value = currentTime
                }
                prevSliderValue = currentTime
                let totalTime = secondsToHoursMinutesSeconds(seconds: Int(playerTime))
                
                controlsView.audioEndtimeLabel.text =  "\(totalTime.1)" + ":" + "\( totalTime.2)"
                let endTime = secondsToHoursMinutesSeconds(seconds: Int(currentTime))
                // assetAnalytics.Player_EndTime = "\(controlsView.playProgressSlider.value)"
                controlsView.audioStartTimeLabel.text = "\(endTime.1)" + ":" + "\( endTime.2)"
                
//                print("player",player.rate)
//                availableDuration()
                didaudioPlayerPlayed = true

            }
            if isOnlineMode{
                if !checkInternetConnectivity(){
                    if !didaudioPlayerPlayed{
                        controlsView.playProgressSlider.isEnabled = false
                            controlsView.playOrPauseBtn.setImage(UIImage.init(named: "icon-play-LS"), for: .normal)
                    
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
                   // showToastView(toastText: internetOfflineMessage)
                    self.delegate?.didaudioPlayerEnterOffline()
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
            if audioAssetAnalyticsArray.count > 0{
                let previousAssetAnalytics = audioAssetAnalyticsArray.last
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
            
//            if !checkInternetConnectivity() {
//                showToastView(toastText: internetOfflineMessage)
//                
//            }
        }
        
        
        
        @objc func onSliderValChanged(_ slider: UISlider, for event: UIEvent) {
            let touchEvent: UITouch? = event.allTouches?.first
            
            if touchEvent?.phase == UITouchPhase.began{
                
                controlsView.progressView.isHidden = false
                if audioAssetAnalyticsArray.count > 0{
                    let previousAssetAnalytics = audioAssetAnalyticsArray.last
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
                isSlidderDragging = false
                
                let timeScale = player.currentItem?.asset.duration.timescale
                let time = CMTimeMakeWithSeconds(Float64(slider.value), timeScale!)
                player.seek(to: time, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
                
                createNewAnalytics(startTime: slider.value)
                
            }else{
                
            }
            
        }
        
        
        func createNewAnalytics(startTime: Float )  {
            
            let dict : NSDictionary = ["DA_Code" : assetAnalytics.DA_Code, "Part_Id" : 1 , "Part_URL" : assetAnalytics.Part_URL, "SessionId" : sessionID , "Detailed_DateTime" : getCurrentDate() , "Detailed_StartTime" : getCurrentDateAndTime() , "Detailed_EndTime" : ""  , "Player_Start_Time" :"\(Int(startTime))" , "Detailed_EndTime" : "" , "Played_Time_Duration":"", "isPreview" : isPreview, "Is_Synced" : 0 ,"Like": "", "Rating":""]
            
            let newAssetAnalytics = AssetAnalyticsDetail(dict:dict)
            newAssetAnalytics.PlayMode = assetAnalytics.PlayMode
            audioAssetAnalyticsArray.append(newAssetAnalytics)
        }
        
        func enterEndTimeForLastAnalytics(endTime : Float){
            
            if audioAssetAnalyticsArray.count > 0{
                let previousAssetAnalytics = audioAssetAnalyticsArray.last
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
         
            return true
        }
        

        
        public enum Direction: Int {
            case Up
            case Down
            case Left
            case Right
            
            public var isX: Bool { return self == .Left || self == .Right }
            public var isY: Bool { return !isX }
        }
        
        func panGestureDirection(velocity : CGPoint) -> Direction {
            
            let vertical = fabs(velocity.y) > fabs(velocity.x)
            switch (vertical, velocity.x, velocity.y) {
            case (true, _, let y) where y < 0: return .Up
            case (true, _, let y) where y > 0: return .Down
            case (false, let x, _) where x > 0: return .Right
            case (false, let x, _) where x < 0: return .Left
            default: return .Up
            }
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

