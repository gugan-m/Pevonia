//
//  AssetsSelectionView.swift
//  HiDoctorApp
//
//  Created by swaasuser on 21/05/17.
//  Copyright © 2017 swaas. All rights reserved.
//

protocol AssetsSelectedDelegate
{
    func navigateToSelectedList(type : Int,isMenu : Bool)
}

import UIKit

class AssetsSelectionView: UIView
{

    @IBOutlet weak var selectedLbl: UILabel!
    @IBOutlet weak var downloadBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var menuBtn : UIButton!
    @IBOutlet weak var menuBtnWidth: NSLayoutConstraint!
    var delegate : AssetsSelectedDelegate?
    var isComingFromDigitalAssets : Bool = false
    var isDownloadable : Int = 0
    
    class func loadNib() -> AssetsSelectionView
    {
        return Bundle.main.loadNibNamed("AssetsSelectionView", owner:  self, options: nil)![0] as! AssetsSelectionView
    }
    
    override func awakeFromNib()
    {
        setDefaultDetails()
    }
    
    func setDefaultDetails()
    {
        var iconName : String = "icon-show-inactive"
        
        if isComingFromDigitalAssets
        {
            iconName = "icon-download"
        }
        
        self.downloadBtnWidth.constant = 0
        
        menuBtn.imageView?.tintColor = UIColor.lightGray
        menuBtn.setImage(UIImage(named :iconName), for: UIControlState.normal)
    }
    
    @IBAction func firstBtnAction(_ sender: UIButton)
    {
        var type : Int = 1
        
        if isComingFromDigitalAssets
        {
            type = 2
            showToastView(toastText: assetDownloadMessage)

        }
        delegate?.navigateToSelectedList(type : type,isMenu: false)
    }
    
    @IBAction func secondBtnAction(_ sender: UIButton)
    {
        var type : Int = 1
        
        if isComingFromDigitalAssets
        {
            type = 2
        }
        delegate?.navigateToSelectedList(type : type,isMenu: false)
    }
}
