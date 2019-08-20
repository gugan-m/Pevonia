//
//  LandingAlertsViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 10/10/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class LandingAlertsViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    //MARK:- IBoutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewWidthCnst: NSLayoutConstraint!
    //MARK:- Variable declaration
    var orientation = UIDeviceOrientation(rawValue: 0)
    var alertsList : [LandingAlertModel] = []
    var unReadArrayCount:[Int?] = [Int?](repeating: nil, count: 6)
    
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    //MARK:- View Controller Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        addBackButtonView()
        self.title = "Alerts"
        self.alertsList = BL_Alerts.sharedInstance.getAlertsList()
        orientation = UIDevice.current.orientation
        
//        if SwifterSwift().isPad || SCREEN_HEIGHT > 750
//        {
//            if self.view.frame.size.height > self.view.frame.size.width
//            {
//                self.collectionViewHeight.constant = self.view.frame.size.height/2
//            }
//            else
//            {
//                self.collectionViewHeight.constant = self.view.frame.size.width/4
//            }
//        }
//        else
//        {
//            if self.view.frame.size.height < self.view.frame.size.width
//            {
//                self.collectionViewHeight.constant = 290
//            }
//            else
//            {
//                self.collectionViewHeight.constant = 430
//            }
//        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.getAllUnreadCount()
        setCollectionViewHeight()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        //setCollectionViewHeight()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        setCollectionViewHeight()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- CollectionViewDataSource and Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.alertsList.count 
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let index = indexPath.row
        if index == 0
        {
            let sb = UIStoryboard(name: Constants.StoaryBoardNames.MessageSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.MessageVCID)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if index == 1
        {
            let sb = UIStoryboard(name: Constants.StoaryBoardNames.NoticeBoardSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.NoticeBoardVCID)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if index == 2
        {
            if (BL_Alerts.sharedInstance.getBirthdayDoctors().count != 0)
            {
                let sb = UIStoryboard(name: landingViewSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.LandingAlertDetailVCID) as! LandingAlertsDetailViewController
                vc.doctorList = BL_Alerts.sharedInstance.getBirthdayDoctors()
                vc.titleText = "Birthdays"
                vc.isAnniversary = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                AlertView.showAlertView(title: infoTitle, message: "No upcoming birthdays found for \(appDoctorPlural)", viewController: self)
            }
        }
        else if (self.alertsList[index].index == 4) //Inward Acknowledgement
        {
            let sb = UIStoryboard(name:commonListSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: InwardAccknowledgementID) as! InwardChalanListViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if (self.alertsList[index].index == 5) // Task
        {
            let sb = UIStoryboard(name:commonListSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: TaskListViewControllerID) as! TaskListViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            if (BL_Alerts.sharedInstance.getAnniversaryDoctors().count != 0)
            {
                let sb = UIStoryboard(name: landingViewSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.LandingAlertDetailVCID) as! LandingAlertsDetailViewController
                vc.doctorList = BL_Alerts.sharedInstance.getAnniversaryDoctors()
                vc.titleText = "Anniversaries"
                vc.isAnniversary = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                AlertView.showAlertView(title: infoTitle, message: "No upcoming anniversaries found for \(appDoctorPlural)", viewController: self)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "landingAlertItem", for: indexPath) as! LandingAlertsCollectionViewCell
        let alertModel = self.alertsList[indexPath.row]
        cell.countView.isHidden = true
        
        if SwifterSwift().isPad
        {
            cell.titleLbl.font = UIFont(name: "SFUIText-Regular", size: 15)
            cell.imgWidthConst.constant = 40
            cell.imgHeightConstant.constant = 40
            //  cell.imgVerticalConst.constant = -20
        }
        else
        {
            cell.imgWidthConst.constant = 25
            cell.imgHeightConstant.constant = 25
        }
        
        cell.activityIndicator.startAnimating()
        cell.imageView.image = UIImage(named: alertModel.imageName)
        
        if(unReadArrayCount[indexPath.row] != nil)
        {
            let count = unReadArrayCount[indexPath.row]!
            
            if(count > 0)
            {
                if (count < 100)
                {
                    cell.pendingLblCount.text = "\(String(describing: count))"
                    cell.countView.isHidden = false
                }
                else
                {
                    cell.pendingLblCount.text = "99+"
                    cell.countView.isHidden = false
                }
            }
            else
            {
                cell.countView.isHidden = true
            }
            cell.activityIndicator.stopAnimating()
            cell.activityIndicator.isHidden = true
        }
        else
        {
            cell.activityIndicator.stopAnimating()
            cell.activityIndicator.isHidden = true
            //cell.countView.isHidden = true
        }
        
        cell.titleLbl.text = alertModel.alertTitle
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if SwifterSwift().isPhone
        {
            //           // size = self.collectionView.frame.width/4.0
            //            return CGSize(width: 125, height: 125)
            if(orientation == UIDeviceOrientation.landscapeRight || orientation == UIDeviceOrientation.landscapeLeft)
            {
                return CGSize(width: self.view.frame.height/3 , height: self.view.frame.height/3)
            }
            else
            {
                return CGSize(width: self.view.frame.width/3.6 , height: self.view.frame.width/3.6)
            }

        }
        else
        {
            if(orientation == UIDeviceOrientation.landscapeRight || orientation == UIDeviceOrientation.landscapeLeft || self.view.frame.size.height < self.view.frame.size.width)
            {
                return CGSize(width: self.view.frame.height/4.2 , height: self.view.frame.height/4.2)
            }
            else
            {
                return CGSize(width: self.view.frame.width/4.2 , height: self.view.frame.width/4.2)
            }
        }

        //  height = collectionView.frame.size.height/2
        // return CGSize(width: size, height: height)
    }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
        {
            return 0
        }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
        {
            return 0
        }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
//    {
//        if(orientation == UIDeviceOrientation.landscapeRight || orientation == UIDeviceOrientation.landscapeLeft || self.view.frame.size.height < self.view.frame.size.width)
//        {
//            var collectionViewSize = collectionView.frame.size
//            collectionViewSize.width = collectionViewSize.width/3\.0 //Display Three elements in a row.
//            collectionViewSize.height = collectionViewSize.height/4.0
//            return collectionViewSize
//        }
//        else
//        {
//        var collectionViewSize = collectionView.frame.size
//        collectionViewSize.width = collectionViewSize.width/3.0 //Display Three elements in a row.
//        collectionViewSize.height = collectionViewSize.height/4.0
//        return collectionViewSize
//        }
//    }
    private func addCustomBackButtonToNavigationBar()
    {
        let backButton = UIButton(type: UIButtonType.custom)
        
        backButton.addTarget(self, action: #selector(self.backButtonClicked), for: UIControlEvents.touchUpInside)
        backButton.setImage(UIImage(named: "navigation-arrow"), for: .normal)
        backButton.sizeToFit()
        
        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    func getAllUnreadCount()
    {
        for i in 0..<alertsList.count
        {
            
            getUnreadCount(index: self.alertsList[i].index)
        }
        self.collectionView.reloadData()
    }
    
    func getUnreadCount(index:Int) //message and notice count
    {
        var countValue = Int()
        
        if checkInternetConnectivity()
        {
            if(index == 0)
            {
                BL_Alerts.sharedInstance.getUnreadMessageCount(completion: { (unReadMessage) in
                    if(unReadMessage.Status == SERVER_SUCCESS_CODE)
                    {
                        countValue = (unReadMessage.list[0] as AnyObject).value(forKey: "Total_Unread_Messages") as! Int
                        self.unReadArrayCount[index] = countValue
                        self.collectionView.reloadData()
                    }
                    else
                    {
                        countValue = -1
                        self.unReadArrayCount[index] = countValue
                        self.collectionView.reloadData()
                    }
                })
            }
            else if(index == 1)
            {
                BL_Alerts.sharedInstance.getUnreadNoticeCount(completion: { (unReadMessage) in
                    if(unReadMessage.Status == SERVER_SUCCESS_CODE)
                    {
                        countValue = (unReadMessage.list[0] as AnyObject).value(forKey: "Total_Unread_Notice_Count") as! Int
                        self.unReadArrayCount[index] = countValue
                        self.collectionView.reloadData()
                    }
                    else
                    {
                        countValue = -1
                        self.collectionView.reloadData()
                    }
                })
            }
            else if(index == 2)
            {
                countValue = BL_Alerts.sharedInstance.getBirthdayDoctors().count
                self.unReadArrayCount[index] = countValue
            }
            else if(index == 3)
            {
                countValue = BL_Alerts.sharedInstance.getAnniversaryDoctors().count
                self.unReadArrayCount[index] = countValue
            }
            else if (index == 4)
            {
                WebServiceHelper.sharedInstance.getInwardChalanListWithProduct{ (apiObj) in
                    countValue = apiObj.list.count
                    self.unReadArrayCount[index] = countValue
                    self.collectionView.reloadData()
                }
            }
            else if(index == 5)
            {
                WebServiceHelper.sharedInstance.getTaskANdFollowUPCount() { (apiObj) in
                    if(apiObj.Status == SERVER_SUCCESS_CODE)
                    {
                        let totalValue = apiObj.list[0] as! NSDictionary
                         countValue = totalValue.value(forKey: "Task_Count") as! Int
                        if(self.alertsList.count == 5)
                        {
                            self.unReadArrayCount[index-1] = countValue
                        }
                        else
                        {
                           self.unReadArrayCount[index] = countValue
                        }
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        else
        {
            countValue = -1
            AlertView.showNoInternetAlert()
        }
    }
    
    @objc func backButtonClicked()
    {
        _ = navigationController?.popViewController(animated: false)
    }
    
    private func setCollectionViewHeight()
    {
        orientation = UIDevice.current.orientation
        if SwifterSwift().isPad || SCREEN_HEIGHT > 750
        {
            if(orientation == UIDeviceOrientation.landscapeRight || orientation == UIDeviceOrientation.landscapeLeft)
            {
                self.collectionViewHeight.constant = self.view.frame.size.height/4 + 150
            }
            else
            {
                self.collectionViewHeight.constant = self.view.frame.size.height/2 + 300
            }
        }
        else
        {
            if orientation == UIDeviceOrientation.landscapeLeft ||   orientation == UIDeviceOrientation.landscapeRight
            {
                self.collectionViewHeight.constant = 290
            }
            else
            {
                self.collectionViewHeight.constant = 430
            }
        }
        
        self.collectionView.reloadData()
    }
}
