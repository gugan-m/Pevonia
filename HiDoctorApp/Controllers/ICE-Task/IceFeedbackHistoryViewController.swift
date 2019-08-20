//
//  IceFeedbackHistoryViewController.swift
//  HiDoctorApp
//
//  Created by Kamaraj on 01/06/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class IceFeedbackHistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var emptyStateLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var userCode: String!
    var feedbackList:[ICEFeedbackList] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        getFeedbackList()
        self.addBackButtonView()
        self.title = "ICE History"
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getFeedbackList()
    {
        if(checkInternetConnectivity())
        {
            showCustomActivityIndicatorView(loadingText: "Loading...")
            WebServiceHelper.sharedInstance.getIceFeedBackList(userCode: userCode) { (apiObj) in
                if(apiObj.Status == SERVER_SUCCESS_CODE)
                {
                   removeCustomActivityView()
                    if(apiObj.list.count > 0)
                    {
                        var feedbackLists:[ICEFeedbackList] = []
                        
                        for obj in apiObj.list
                        {
                            let feedbackData = obj as! NSDictionary
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
                            
                            feedbackLists.append(feedBackObj)
                        }
                        
                        self.feedbackList = feedbackLists
                        self.emptyStateLbl.isHidden = true
                        self.tableView.isHidden = false
                        self.emptyStateLbl.text = ""
                        self.tableView.reloadData()
                        
                    }
                    else
                    {
                        self.emptyStateLbl.isHidden = false
                        self.tableView.isHidden = true
                        self.emptyStateLbl.text = "No Feedback"
                    }
                    
                }
                else
                {
                    removeCustomActivityView()
                    AlertView.showAlertView(title: errorTitle , message: apiObj.Message, viewController: self)
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
        return self.feedbackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "FeedBackListCell") as! IceFeedbackListCell
        
        let feedbackData = self.feedbackList[indexPath.row]
        cell.evaluatedBy.text = "ICE done by:" + feedbackData.Created_By
        let dateToValue = convertDateIntoString(dateString: feedbackData.Evaluation_Date)
        let appFormatModifiyDate = convertDateIntoString(date: dateToValue)
        cell.evaluatedDate.text = appFormatModifiyDate
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let getFeedbackData = self.feedbackList[indexPath.row]
        let sb = UIStoryboard(name: commonListSb, bundle: nil)
        let vc:IceHistoryViewController = sb.instantiateViewController(withIdentifier:IceHistoryViewControllerID) as! IceHistoryViewController
        
        vc.feedbackId = getFeedbackData.Feedback_Id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    
    
    
    
}
