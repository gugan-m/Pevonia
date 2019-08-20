//
//  AssetDetailController.swift
//  HiDoctorApp
//
//  Created by Vijay on 19/05/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class AssetDetailController: UIViewController {
    
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var wrapperViewLeadingConst: NSLayoutConstraint!
    @IBOutlet weak var wrapperViewTrailingConst: NSLayoutConstraint!
    @IBOutlet weak var assetImg: UIImageView!
    @IBOutlet weak var assetIcon: UIImageView!
    @IBOutlet weak var assetName: UILabel!
    @IBOutlet weak var contentViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var topViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var sizeLbl: UILabel!
    @IBOutlet weak var playTimeLbl: UILabel!
    @IBOutlet weak var availLbl: UILabel!
    @IBOutlet weak var productLbl: UILabel!
    @IBOutlet weak var createdLbl: UILabel!
    @IBOutlet weak var playTimeHeightConst: NSLayoutConstraint!
    @IBOutlet weak var playTimeTopConst: NSLayoutConstraint!
    @IBOutlet weak var playTimeView: UIView!
    
    
    
    
    var assetModel: AssetHeader!
    var defaultPlayTimeHeightConst: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        //setWrapperViewWidth()
        
        if assetModel != nil
        {
            loadAssetDetails()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        contentViewHeightConst.constant = self.view.frame.size.height - topViewHeightConst.constant
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setWrapperViewWidth()
    {
        if SCREEN_WIDTH > 375
        {
            wrapperViewLeadingConst.constant = 100.0
            wrapperViewTrailingConst.constant = 100.0
        }
        else
        {
            wrapperViewLeadingConst.constant = 0.0
            wrapperViewTrailingConst.constant = 0.0
        }
    }
    
    private func loadAssetDetails()
    {
        defaultPlayTimeHeightConst = playTimeHeightConst.constant
        
        setThumbnailImg()
        
//        if assetModel.docType == 2
//        {
//            playTimeView.isHidden = false
//            playTimeHeightConst.constant = defaultPlayTimeHeightConst
//            playTimeTopConst.constant = 5.0
//        }
//        else
//        {
//            playTimeView.isHidden = true
//            playTimeHeightConst.constant = 0.0
//            playTimeTopConst.constant = 0.0
//        }
        
        playTimeView.isHidden = true
        playTimeHeightConst.constant = 0.0
        playTimeTopConst.constant = 0.0
        
        assetIcon.image = getAssetThumbnailIcon(docType: assetModel.docType)
        
        assetName.text = assetModel.daName
        typeLbl.text = getDocTypeVal(docType: assetModel.docType)
        sizeLbl.text = "\(String(format: "%.2f", assetModel.daSize)) MB"
        availLbl.text = BL_AssetModel.sharedInstance.getDownloadStatus(isDownloaded: assetModel.isDownloaded)
        
        productLbl.text = assetModel.tagValue
    }

    private func setThumbnailImg()
    {
        if assetModel.thumbnailUrl != ""
        {
            ImageLoader.sharedLoader.imageForUrl(urlString: assetModel.thumbnailUrl) {(image) in
                if image != nil
                {
                    self.assetImg.image = image
                }
                else
                {
                    self.assetImg.image = UIImage(named: "image-placeholder")
                }
            }
        }
        else
        {
            self.assetImg.image = UIImage(named: "image-placeholder")
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        _ = navigationController?.popViewController(animated: false)
    }
}
