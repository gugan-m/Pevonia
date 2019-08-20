//
//  OnBoardViewController.swift
//  HiDoctorApp
//
//  Created by Vignaya on 11/2/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

protocol onBoardComplete
{
    func onBoardViewDismiss()
}
class OnBoardViewController: UIViewController {
    
    @IBOutlet weak var closeBtn: UIButton!
    var delegate : onBoardComplete?
    var splashlist:[SplashModel] = []
    var splashlist1:[SplashModel] = []
    var splashlist2:[SplashModel] = []
    var check: Bool = false
    let lastAlertDate = UserDefaults.standard.string(forKey:"lastAlertDate")
    override func viewDidLoad()
    {
        super.viewDidLoad()
        closeBtn.tintColor = UIColor.darkGray
        closeBtn.layer.cornerRadius = closeBtn.frame.height/2
        self.checkCodeOfConduct()
       // self.checksplash()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func gotItBtnAction(_ sender: AnyObject)
    {
        DBHelper.sharedInstance.updateOnBoardDetail(shownType: 1)
        self.dismiss(animated: false, completion: nil)
        BL_MasterDataDownload.sharedInstance.onBoarCompleted = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "onBoardAction"), object: nil)
        self.checksplash()
    }
    
    @IBAction func closeBtnAction(_ sender: AnyObject) {
         self.dismiss(animated: false, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "onBoardAction"), object: nil)
        self.checksplash()
    }
    
    private func checkCodeOfConduct()
    {
        if let getDate = UserDefaults.standard.value(forKey: "CodeOfConduct") as? Date
        {
            let compare = NSCalendar.current.compare(getDate, to: Date(), toGranularity: .day)
            if(compare != .orderedSame && compare == .orderedAscending)
            {
                self.showCodeOFConduct()
            }
        }
        else
        {
            self.showCodeOFConduct()
        }
        
       
            
        }
    
    
    func showCodeOFConduct()
    {
        BL_InitialSetup.sharedInstance.checkCodeOfConduct { (response) in
            if(response)
            {
                // if yes show code of conduct page
                let sb = UIStoryboard(name:prepareMyDeviceSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: CodeOfConductViewControllerID) as! CodeOfConductViewController
                vc.providesPresentationContextTransitionStyle = true
                vc.definesPresentationContext = true
                vc.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                vc.isComingFromCompanyLogin = false
                self.present(vc, animated: false, completion: nil)
            }
        }
    }

    func checksplash()
    {
        splash { (status) in
            if(status == SERVER_SUCCESS_CODE)
            {
                
                self.pass(splashlist: self.splashlist1)
            }
        }
    }

    func pass(splashlist: [SplashModel]){
        for splash in splashlist {
            if(splashlist.count > 1)
            {
                splashlist2.append(splash)
            }
        }
        self.showAlert()
        UserDefaults.standard.set(getCurrentDate(), forKey: "lastAlertDate")
        
    }
    private func splash(completion: @escaping (_ status: Int) -> ())
    {
        if(checkInternetConnectivity())
        {
            WebServiceHelper.sharedInstance.getSplashScreenData { (apiObj) in
                if(apiObj.Status == SERVER_SUCCESS_CODE)
                {
                    if apiObj.list.count>0
                    {   var splash = SplashModel()
                        for splashobj in apiObj.list
                        {
                            splash = SplashModel()
                            var file = (splashobj as! NSDictionary).value(forKey: "File_Path") as! String
                            var descrip = (splashobj as! NSDictionary).value(forKey: "Description") as! String
                            var title = (splashobj as! NSDictionary).value(forKey: "Title") as! String
                            if title.count < 1
                            {
                                title = "New Splash"
                            }
                            if  file.count > 0
                            {
                                if descrip.count > 1
                                {
                                    splash.file = file
                                    splash.type = 1
                                    splash.desc = descrip
                                    splash.title = title
                                }
                                else
                                {
                                    splash.file =  file
                                    splash.type = 1
                                    splash.desc = ""
                                    splash.title = title
                                }
                                
                            }
                            else if file.count < 1
                            {
                                splash.desc = descrip
                                splash.type = 0
                                splash.title = title
                                
                                
                            }
                            
                            self.splashlist1.append(splash)
                        }
                    }
                    completion(SERVER_SUCCESS_CODE)
                }
                else
                {
                    completion(SERVER_SUCCESS_CODE)
                }
            }
            //isAppUpdateAvailable
            
        }
    }
    private func showAlert() {
        guard self.splashlist1.count > 0 else { return }
        let message = self.splashlist1.first?.desc
        let type1 = self.splashlist1.first?.type
        let file = self.splashlist1.first?.file
        let title = self.splashlist1.first?.title
        func removeAndShowNextMessage() {
            self.splashlist1.removeFirst()
            self.showAlert()
        }
        var alert = UIAlertController()
        if type1 == 0
        {
            alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            alert.addAction(UIAlertAction(title: "Close", style: .default){ (action) in
                print("pressed yes")
                // removeAndShowNextMessage()
                self.check  = true
            })
            if splashlist1.count > 1
            {
                alert.addAction(UIAlertAction(title: "Next screen", style: .cancel){ (action) in
                    print("pressed no")
                    removeAndShowNextMessage()
                })
            }
            
        }
        else if type1 == 1
        {   var imageURL = UIImage()
            alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            let url = URL(string:"https://nbfiles.blob.core.windows.net/"+getCompanyCode().lowercased()+"/"+file!)
            let data = try? Data(contentsOf:url!)
            
            // It is the best way to manage nil issue.
            imageURL = UIImage(data:data! as Data)!
            var image = imageURL
            alert.addImage(image: image)
            alert.addAction(UIAlertAction(title: "Close", style: .default){ (action) in
                print("pressed yes")
                //removeAndShowNextMessage()
                self.check = true
            })
            if splashlist1.count > 1
            {
                alert.addAction(UIAlertAction(title: "Next screen", style: .cancel){ (action) in
                    print("pressed no")
                    removeAndShowNextMessage()
                })
            }
        }
        UIApplication.shared.delegate?.window??.rootViewController?.present(alert, animated: true)
    }
    

}


