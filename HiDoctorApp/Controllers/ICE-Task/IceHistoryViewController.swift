//
//  IceHistoryViewController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 01/06/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class IceHistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
   
    @IBOutlet weak var emptyStateLbl : UILabel!
    @IBOutlet weak var tableView : UITableView!
    
    
    var feedbackId = Int()
    var iceFeedbackHistory = ICEAnswerHistoryList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        getFeedbackHistoryList()
        self.addBackButtonView()
        self.title = "ICE History"
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getFeedbackHistoryList()
    {
        if(checkInternetConnectivity())
        {
            showCustomActivityIndicatorView(loadingText: "Loading....")
            WebServiceHelper.sharedInstance.getFeedbackHistory(feedbackId: feedbackId) { (apiObj) in
                if(apiObj.Status == SERVER_SUCCESS_CODE)
                {
                    removeCustomActivityView()
                    
                    var iceQuestionAndAnswer :[ICEAnswerHistory] = []
                    let getData = apiObj.list[0] as! NSDictionary
                    
                    let lstFeedbackQuestions = getData.value(forKey: "lstfeedbackQuestions") as! NSArray
                    
                    for lstFeedbackQueObj in lstFeedbackQuestions
                    {
                        let getFeedbackData = lstFeedbackQueObj as! NSDictionary
                        let iceAnswerHistoryobj = ICEAnswerHistory()
                        iceAnswerHistoryobj.Questions = getFeedbackData.value(forKey: "Questions") as! String
                        iceAnswerHistoryobj.Question_Id = getFeedbackData.value(forKey: "Question_Id") as! Int
                        iceAnswerHistoryobj.Question_Type = getFeedbackData.value(forKey: "Question_Type") as! Int
                        iceAnswerHistoryobj.Assigned_Rating = getFeedbackData.value(forKey: "Assigned_Rating") as! Int
                        iceAnswerHistoryobj.Remarks = checkNullAndNilValueForString(stringData: getFeedbackData.value(forKey: "Remarks") as? String)
                        iceAnswerHistoryobj.Feedback_Id = getFeedbackData.value(forKey: "Feedback_Id") as! Int
                        iceAnswerHistoryobj.Rating_Description = getFeedbackData.value(forKey: "Rating_Description") as! String
                        iceAnswerHistoryobj.Rating_Value = getFeedbackData.value(forKey: "Rating_Value") as! Int
                        
                        iceQuestionAndAnswer.append(iceAnswerHistoryobj)
                    }
                    
                    let lstfeedbackEval = getData.value(forKey: "lstfeedbackEval") as! NSArray
                    let feedbackData = lstfeedbackEval[0] as! NSDictionary
                    let feedBackObj = ICEFeedbackList()
                    feedBackObj.Created_By = feedbackData.value(forKey: "Created_By") as! String
                    feedBackObj.Created_By_Employee_Name = feedbackData.value(forKey: "Created_By_Employee_Name") as! String
                    feedBackObj.Created_DateTime = feedbackData.value(forKey: "Created_DateTime") as! String
                    feedBackObj.Evaluation_Date = feedbackData.value(forKey: "Evaluation_Date") as! String
                    feedBackObj.Feedback_Id = feedbackData.value(forKey: "Feedback_Id") as! Int
                    feedBackObj.Feedback_Remarks = checkNullAndNilValueForString(stringData: feedbackData.value(forKey: "Feedback_Remarks") as? String)
                    feedBackObj.Feedback_Status = feedbackData.value(forKey: "Feedback_Status") as! Int
                    feedBackObj.Feedback_User_Employee_Name = feedbackData.value(forKey: "Feedback_User_Employee_Name") as! String
                    feedBackObj.User_Code = feedbackData.value(forKey: "User_Code") as! String
                    feedBackObj.User_Name = feedbackData.value(forKey: "User_Name") as! String

                    self.iceFeedbackHistory.feedbackDetails = feedBackObj
                    self.iceFeedbackHistory.feedbackHistoryList = iceQuestionAndAnswer
                    if(self.iceFeedbackHistory.feedbackHistoryList.count > 0)
                    {
                        self.tableView.isHidden = false
                        self.emptyStateLbl.text = ""
                       self.tableView.reloadData()
                    }
                    else
                    {
                        self.tableView.isHidden = true
                        self.emptyStateLbl.text = "No History"
                    }
                }
                else
                {
                   removeCustomActivityView()
                    AlertView.showAlertView(title: errorTitle, message: apiObj.Message, viewController: self)
                }
            }
        }
        else
        {
            AlertView.showAlertView(title: internetOfflineTitle, message: internetOfflineMessage, viewController: self)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.iceFeedbackHistory != nil)
        {
            return self.iceFeedbackHistory.feedbackHistoryList.count
        }
        else
        {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "IceHistoryListCell") as! IceHistoryListCell
        let getData = self.iceFeedbackHistory.feedbackHistoryList[indexPath.row]
        cell.questionLbl.text = getData.Questions
        cell.answerLbl.text = getData.Rating_Description
        cell.remarksLbl.text = getData.Remarks
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(self.iceFeedbackHistory != nil && self.iceFeedbackHistory.feedbackHistoryList.count > 0)
        {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "IceHistoryHeaderCell") as! IceHistoryHeaderCell
            cell1.evaluatedBy.text = "Evaluated By: " + self.iceFeedbackHistory.feedbackDetails.Created_By_Employee_Name
            cell1.evaluatedFor.text = "Evaluated For: " + self.iceFeedbackHistory.feedbackDetails.Feedback_User_Employee_Name
            var remarks = String()
            if(self.iceFeedbackHistory.feedbackDetails.Feedback_Remarks! == EMPTY)
            {
                remarks = NOT_APPLICABLE
            }
            else
            {
                remarks = self.iceFeedbackHistory.feedbackDetails.Feedback_Remarks!
            }
            cell1.overAllRemarks.text = "Over All Remarks: " + remarks
            let evaluateDate = convertDateIntoString(dateString: self.iceFeedbackHistory.feedbackDetails.Evaluation_Date)
            let appFormatModifiyevaluateDate = convertDateIntoString(date: evaluateDate)
            let createDate = convertDateIntoString(dateString: self.iceFeedbackHistory.feedbackDetails.Created_DateTime)
            let appFormatModifiyCreatedDate = convertDateIntoString(date: createDate)
            
            cell1.evaluatedDate.text = "Evaluated For: " + appFormatModifiyevaluateDate
            cell1.createdDate.text = "Evaluated on: " + appFormatModifiyCreatedDate
            
            return cell1.contentView
        }
        else
        {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if(self.iceFeedbackHistory != nil && self.iceFeedbackHistory.feedbackHistoryList.count > 0)
        {
        let remarks = "Over All Remarks: " + self.iceFeedbackHistory.feedbackDetails.Feedback_Remarks!
         let descriptionHeight = getTextSize(text: remarks, fontName: fontRegular, fontSize: 15, constrainedWidth: SCREEN_WIDTH - 16).height + 10
        return 120 + descriptionHeight
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let getData = self.iceFeedbackHistory.feedbackHistoryList[indexPath.row]
        let questionHeight = getTextSize(text: getData.Questions, fontName: fontRegular, fontSize: 15, constrainedWidth: SCREEN_WIDTH - 16).height + 10
        let descriptionHeight = getTextSize(text: getData.Rating_Description, fontName: fontRegular, fontSize: 15, constrainedWidth: SCREEN_WIDTH - 16).height + 10
        let remarksHeight = getTextSize(text: getData.Remarks, fontName: fontRegular, fontSize: 15, constrainedWidth: SCREEN_WIDTH - 16).height + 25
        
        return questionHeight + descriptionHeight + remarksHeight
    }
    
}
