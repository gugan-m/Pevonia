//
//  AlbumListController.swift
//  HiDoctorApp
//
//  Created by Vijay on 19/04/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import Photos

class AlbumListController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var emptyStateWrapper: UIView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    var isFromMessage = false
    var isFromChemistDay = false
    var isfromLeave = false
    var isFromNotes = false
    var isFromEditDoctor = false
    
    var imageArray : [PhotoModel] = []
   
    //MARK:- Controller Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Album"
        addCustomCancelButtonToNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        imageArray = BL_Assets.sharedInstance.getCurrentArray()
        showHideViews(imgArr: imageArray)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Show/Hide views
    func showHideViews(imgArr: [PhotoModel])
    {
        if imgArr.count > 0
        {
            tableView.isHidden = false
            tableView.reloadData()
            emptyStateWrapper.isHidden = true
        }
        else
        {
            tableView.isHidden = true
            emptyStateWrapper.isHidden = false
            emptyStateLbl.text = albumEmptyMsg
        }
    }
    
    //MARK:- Tableview delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return imageArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.CustomImageLibAlbumCell, for: indexPath) as! PhotoViewCellTableViewCell
        
        let obj = imageArray[indexPath.row]
        
        cell.imgName.text = obj.albumTitle
        if let getThumbImg = obj.thumbnail
        {
            cell.img.image = getThumbImg
        }
        cell.albumCount.text = "\(obj.albumCount!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let obj = imageArray[indexPath.row]
        
        let sb = UIStoryboard(name: Constants.StoaryBoardNames.CustomImgLib, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.CustomImgLibPhotoVCID) as! PhotosViewController
        vc.selectedDirectory = obj
        vc.isFromMessage = isFromMessage
        vc.isFromChemistDay = isFromChemistDay
        vc.isFromEditDoctor = isFromEditDoctor
        vc.isfromLeave = isfromLeave
        vc.isFromNotes = isFromNotes
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Nav Bar - Custom Cancel button
    private func addCustomCancelButtonToNavigationBar()
    {
        let cancelButton = UIButton(type: UIButtonType.custom)
        
        cancelButton.addTarget(self, action: #selector(self.cancelButtonClicked), for: .touchUpInside)
        cancelButton.setTitle(nbCancelTitle, for: .normal)
        cancelButton.sizeToFit()
        
        let leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func cancelButtonClicked()
    {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromBottom
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        
        _ = navigationController?.popViewController(animated: false)
    }
}
