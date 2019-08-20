//
//  NoticeDetailViewController.swift
//  HiDoctorApp
//
//  Created by Kanchana on 8/4/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class NoticeDetailViewController: UIViewController {

    @IBOutlet var samplePerson: UILabel!
    @IBOutlet var sampleDate: UILabel!
    @IBOutlet var message: UILabel!
    @IBOutlet var hyperViewTop: NSLayoutConstraint!
    @IBOutlet var hyperViewBottom: NSLayoutConstraint!
    @IBOutlet var HyperLink: UIButton!
    @IBOutlet var hyperHeight: NSLayoutConstraint!
    @IBOutlet var hyperlinkView: CornerRadiusWithShadowView!
    @IBOutlet var Download: UIButton!
    @IBOutlet var emptyStateView: UIView!
    @IBOutlet var emptyStateLbl: UILabel!
    @IBOutlet var detailView: UIView!
    
    var noticeobj : NoticeBoardModel!
    var file_Name :String = String()
    var noticedetail:[NoticeBoardDetailModel] = []
    var notice:NoticeBoardDetailModel!
    
    //MARK:- ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        noticedetail = DAL_NoticeBoard.sharedInstance.getNoticeboardAttachementDetail(msgCode: noticeobj.Msg_Code)
        self.updateViews()
        self.navigationItem.title = "\(notice.Msg_Title!)"
        samplePerson.text = notice.Msg_Distribution_Type
        let dateValidfrom = convertDateIntoString(dateString: notice.Msg_Valid_From)
        let dateValidto = convertDateIntoString(dateString: notice.Msg_Valid_To)
        sampleDate.text = "\(convertDateIntoString(date: dateValidfrom)) to \(convertDateIntoString(date: dateValidto))"
        message.text = notice.Msg_Body as String
        showHyperlinkView()
        showDownloadButton()
        let fileNameSplittedString = notice.Msg_AttachmentPath.components(separatedBy: "/")
            if fileNameSplittedString.count > 0
                {
                    file_Name = fileNameSplittedString.last!
                }
        changeDownloadButtonTitle()
        addCustomBackButtonToNavigationBar()
        // Do any additional setup after loading the view.
       }
    override func viewWillAppear(_ animated: Bool) {
        self.changeDownloadButtonTitle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Attachement Download Operation
    @IBAction func Hyperlink(_ sender: UIButton) {
       
        if let requestUrl = URL(string: notice.Msg_Hyperlink)
        {
            UIApplication.shared.openURL(requestUrl)
        }
    }
    @IBAction func StartDownload(_ sender: UIButton)
    {
                if BL_NoticeBoardAttachmentDownload.sharedInstance.checkFileNameExists(fileName: file_Name) == true
                    {
                        self.navigateTowebView(siteUrl: BL_NoticeBoardAttachmentDownload.sharedInstance.noticeAssetFileInDocumentsDirectory(fileName: self.file_Name ))

                    }
                else
                    {
                        if checkInternetConnectivity()
                            {
                                showActivityIndicator()
                                BL_NoticeBoardAttachmentDownload.sharedInstance.downloadAttachment(url: notice.Msg_AttachmentPath){ (data) in
                                    removeCustomActivityView()
                                        if data != nil
                                            {
                                                BL_NoticeBoardAttachmentDownload.sharedInstance.saveAttachment(fileData: data!,fileName: self.file_Name)
                                                self.navigateTowebView(siteUrl: BL_NoticeBoardAttachmentDownload.sharedInstance.noticeAssetFileInDocumentsDirectory(fileName: self.file_Name ))
                                            }
                                        else
                                            {
                                                showToastView(toastText: "Problem in Downloading the data")
                                            }
                                            }
                                }
                            else
                                {
                                    AlertView.showNoInternetAlert()
                                }
                    }
    }
    
    //MARK:- Functions for Updating Views
    func navigateTowebView(siteUrl:String)
    {
        let sb = UIStoryboard(name: mainSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: webViewVCID) as! WebViewController
        vc.siteURL = siteUrl
                if siteUrl == notice.Msg_Hyperlink
                    {
                        vc.localURL = false
                        vc.webViewTitle = notice.Msg_Hyperlink
                    }
                else{
                        vc.localURL = true
                        vc.webViewTitle = file_Name
                    }
        self.navigationController?.pushViewController(vc, animated: true)

    }
    func showHyperlinkView()
    {
        if noticeobj.Msg_Hyperlink == EMPTY
            {
                hyperViewTop.constant = 0
                hyperViewBottom.constant = 16
                hyperHeight.constant = 0
                hyperlinkView.isHidden = true
           
            }
        else
            {
                hyperViewTop.constant = 16
                hyperViewBottom.constant = 16
                hyperHeight.constant = 80
                hyperlinkView.isHidden = false
                HyperLink.setTitle(noticeobj.Msg_Hyperlink!, for: .normal)
            
            }
    }
    func showDownloadButton()
    {
       if noticeobj.Msg_AttachmentPath == EMPTY
            {
                Download.isHidden = true
            }
       else
            {
                Download.isHidden = false
            }
    }
    func showActivityIndicator()
    {
        showCustomActivityIndicatorView(loadingText: "Downloading the attachment..")
    }
    func changeDownloadButtonTitle()
    {
        if BL_NoticeBoardAttachmentDownload.sharedInstance.checkFileNameExists(fileName: file_Name)
            {
                Download.setTitle("View Attachment", for: .normal)
            }
        else
            {
              Download.setTitle("Download Attachment", for: .normal)
            }
    }
    func updateViews()
    {
        if noticedetail.count > 0
            {
                notice = noticedetail.first!
                detailView.isHidden = false
                emptyStateView.isHidden = true
            }
        else
            {
                detailView.isHidden = true
                emptyStateLbl.text = "No Notice Details Found"
                emptyStateView.isHidden = false
            }
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
