//
//  ImageViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 21/02/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController
{

    @IBOutlet weak var profilePicImageView : UIImageView!
    
    var urlString : String = ""
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setProfileImg()
    }

    func setProfileImg()
    {
        ImageLoader.sharedLoader.imageForUrl(urlString: urlString) {(image) in
            self.profilePicImageView.image = image
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func closeBtnAction(_ sender: AnyObject)
    {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    
    
}
