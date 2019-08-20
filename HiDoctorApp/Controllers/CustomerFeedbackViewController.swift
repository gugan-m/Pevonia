//
//  CustomerFeedbackViewController.swift
//  HiDoctorApp
//
//  Created by Admin on 7/20/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class CustomerFeedbackViewController: UIViewController, UITextFieldDelegate , UITextViewDelegate {
    
    @IBOutlet weak var customerProfileImgVw: UIImageView!
    
    @IBOutlet weak var customerNameLbl: UILabel!
    
    @IBOutlet weak var rateTextLabel: UILabel!
    
    @IBOutlet weak var starBtn1: UIButton!

    @IBOutlet weak var starBtn2: UIButton!
    
    @IBOutlet weak var starBtn3: UIButton!
    
    @IBOutlet weak var starBtn4: UIButton!
    
    @IBOutlet weak var starBtn5: UIButton!
    
    @IBOutlet weak var commentProfileImgVw: UIImageView!
    
    @IBOutlet weak var starContentView: UIView!
    

    @IBOutlet weak var addcommentTV: PlaceHolderForTextView!
    
    @IBOutlet weak var textCountLabel: UILabel!
    
    
    @IBOutlet weak var feedbackTV: PlaceHolderForTextView!
    
    @IBOutlet weak var specialityNameLbl: UILabel!
    
    @IBOutlet weak var dateLbl: UILabel!
    
    var starBtnsList = [UIButton]()
    
    var customerAndAssetObj = DoctorFeedbackModel()
    var doneBtn : UIBarButtonItem!
    var ratingCount = 0
    var existingfeedback : DoctorVisitFeedback!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addCustomBackButtonToNavigationBar()
        loadDefaultValues()
        loadDoctorData()
        existingfeedback = DBHelper.sharedInstance.getDoctorVisitFeedBackForToday(customerObj: customerAndAssetObj.customerObj)
        loadFeedbackData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        hideKeyboard()
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
    
    
    @objc func backButtonClicked(){
         _ = navigationController?.popViewController(animated: false)
    }
    
    func loadDefaultValues(){
        starBtnsList.append(starBtn1)
        starBtnsList.append(starBtn2)
        starBtnsList.append(starBtn3)
        starBtnsList.append(starBtn4)
        starBtnsList.append(starBtn5)
        
        setRoundedCornersForImageVW(imageVw: customerProfileImgVw)
        setRoundedCornersForImageVW(imageVw: commentProfileImgVw)
        
        let date = convertDateIntoServerDisplayformat(date: getCurrentDateAndTime())
        dateLbl.text = date
        
        let tapRecog = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tapRecog)
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(drag(gesture:)))
        starContentView.addGestureRecognizer(gesture)
        
        self.navigationItem.title = "Visit Feedback"
        self.addcommentTV.layer.borderWidth = 1
        self.addcommentTV.layer.borderColor = UIColor.lightGray.cgColor
        self.addcommentTV.delegate = self
        
    }
    
    
    @IBAction func didTapSubmitAction(_ sender: Any) {
        
        doneBtnAction()
    }
    
    
    func doneBtnAction(){
        
        let customerObj = customerAndAssetObj.customerObj
        var feedbackText = addcommentTV.text
        feedbackText =  feedbackText?.trimmingCharacters(in: .whitespacesAndNewlines)

        
        ratingCount = 0
        
        for starBtn in starBtnsList{
            
            if (starBtn.image(for: .normal) == UIImage.init(named: "icon-star-selected") ){
                ratingCount += 1
            }else{
                break
            }
            
        }
        
        if ratingCount == 0{
            AlertView.showAlertView(title: "Alert", message: ratingSelectMessage , viewController: self)
            return
        }
        showToastView(toastText: "Thanks for your feedback")
        
        if existingfeedback.customerCode != nil && existingfeedback.customerCode != "" {
            existingfeedback.visitRating = ratingCount
            existingfeedback.VisitFeedBack = feedbackText ?? ""
            existingfeedback.detailedDate = getCurrentDate()
            
            existingfeedback.updated_Date_Time = getCurrentDateAndTimeString()
            existingfeedback.is_Synced = 0
            DBHelper.sharedInstance.updateDoctorVisitFeedback(feedback: existingfeedback)

        }else{
        
        var assetDict = NSDictionary()

        assetDict = ["Customer_Region_Code": getRegionCode() , "Customer_Code" : customerObj?.Customer_Code ?? "0", "User_Code" : getUserCode() ,  "Visit_Rating" : ratingCount , "Visit_Feedback" : feedbackText ?? "" ,"Time_Zone": getCurrentTimeZone() , "Detailed_Date" : getCurrentDate() , "Current_Datetime" : getCurrentDateAndTimeString() , "Is_Synced" : 0 ]
        
        DBHelper.sharedInstance.insertDoctorVisitFeedback(dict: assetDict)
        }
        self.navigationController?.popViewController(animated: false)

    }
    
    
    func loadDoctorData(){
        setDoctorProfileImg()
        customerNameLbl.text = customerAndAssetObj.customerObj.Customer_Name
        specialityNameLbl.text = customerAndAssetObj.customerObj.Speciality_Name
    }
    
    func loadFeedbackData(){
        
        if existingfeedback.customerCode != nil && existingfeedback.customerCode != "" {
      feedbackTV.text = existingfeedback.VisitFeedBack
       self.textCountLabel.text = "\(existingfeedback.VisitFeedBack.count)/\(doctorRemarksMaxLength)"
        for index in 0...existingfeedback.visitRating - 1 {
            
            starBtnsList[index].setImage(UIImage.init(named: "icon-star-selected"), for: .normal)

        }
        }
    }
    
    
    func setDoctorProfileImg()
    {
        let profileImgUrl = BL_DoctorList.sharedInstance.getDoctorProfileImgUrl()
        if profileImgUrl != ""
        {
            ImageLoader.sharedLoader.imageForUrl(urlString: profileImgUrl) {(image) in
                self.customerProfileImgVw.image = image
                self.commentProfileImgVw.image = image
            }
        }
        else
        {
            self.customerProfileImgVw.image = UIImage(named: "profile-placeholder-image")
             self.customerProfileImgVw.image = UIImage(named: "profile-placeholder-image")
        }
    }

    
    @IBAction func didTapStarButtons(_ sender: Any) {
        
        let selButton = sender as! UIButton

        for starBtn in starBtnsList{
            
            if selButton.tag >= starBtn.tag{
                
                starBtn.setImage(UIImage.init(named: "icon-star-selected"), for: .normal)
            
            }else{
              starBtn.setImage(UIImage.init(named: "icon-star-unselected"), for: .normal)
            }
        }
        
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
            

        if self.view.frame.size.width > self.view.frame.size.height {
            if SwifterSwift().isPad{
                self.view.frame.origin.y -= 220

            }else{
            self.view.frame.origin.y -= 162
            }
        }else{
            if !SwifterSwift().isPad{

            if self.view.frame.size.height < 550{
                self.view.frame.origin.y -= 200
            }else{
            self.view.frame.origin.y -= 152
            }
        }
        }
        }, completion: nil)

    }
    
    func textViewDidEndEditing(_ textView: UITextView) {

        if self.view.frame.origin.y < 0{

            if self.view.frame.size.width > self.view.frame.size.height {
                if SwifterSwift().isPad{
                    self.view.frame.origin.y += 220
                    
                }else{
                self.view.frame.origin.y += 162
                }
            }else{
                if !SwifterSwift().isPad{

                if self.view.frame.size.height < 550{
                    self.view.frame.origin.y += 200
                }else{
                self.view.frame.origin.y += 150
                }
            }
        }
    }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
     
        self.view.frame.origin.y -= 150
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.view.frame.origin.y < 0{
        self.view.frame.origin.y += 150
        }

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        

        return true
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let charList = ACCEPTABLE_CHARACTERS
        if  text != "" && !charList.contains(text.last!){
            return false
        }
        if textView.text.count > 499 && text != "" {
            return false
        }
        var newLength = textView.text.count
        if text != ""{
            newLength += 1
        }else{
            newLength -= 1
        }
        if newLength < 0{
            newLength = 0
        }
        
        self.textCountLabel.text = "\(newLength)/\(doctorRemarksMaxLength)"
        
        return true
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
  
    
    @objc func drag(gesture: UIPanGestureRecognizer) {
        
        let point = gesture.location(in: starContentView)
        
        checkForButtonState(pointX: point.x)

    }
    
    func checkForButtonState(pointX : CGFloat){
        
        if pointX > starBtn1.frame.origin.x{
            starBtn1.setImage(UIImage.init(named: "icon-star-selected"), for: .normal)
        }else{
            starBtn1.setImage(UIImage.init(named: "icon-star-unselected"), for: .normal)
        }
        
        if pointX > starBtn2.frame.origin.x{
            starBtn2.setImage(UIImage.init(named: "icon-star-selected"), for: .normal)
        }else{
            starBtn2.setImage(UIImage.init(named: "icon-star-unselected"), for: .normal)
        }
        
        if pointX > starBtn3.frame.origin.x{
            starBtn3.setImage(UIImage.init(named: "icon-star-selected"), for: .normal)
        }else{
            starBtn3.setImage(UIImage.init(named: "icon-star-unselected"), for: .normal)
        }
        
        if pointX > starBtn4.frame.origin.x{
            starBtn4.setImage(UIImage.init(named: "icon-star-selected"), for: .normal)
        }else{
            starBtn4.setImage(UIImage.init(named: "icon-star-unselected"), for: .normal)
        }
        
        if pointX > starBtn5.frame.origin.x{
            starBtn5.setImage(UIImage.init(named: "icon-star-selected"), for: .normal)
        }else{
            starBtn5.setImage(UIImage.init(named: "icon-star-unselected"), for: .normal)
        }
        
        
        
    }
    
    func deselectTheStarButtons(selButton : UIButton){
        
        for starBtn in starBtnsList{
        
        if selButton.tag > starBtn.tag{
            
            starBtn.setImage(UIImage.init(named: "icon-star-unselected"), for: .normal)

           // starBtn.setImage(UIImage.init(named: "icon-star-selected"), for: .normal)
            
        }else{
        }
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
