//
//  DoctorTagViewController.swift
//  HiDoctorApp
//
//  Created by Vijay on 22/06/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class DoctorTagViewController: UIViewController, TagListViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var emptyStateWrapper: UIView!
    @IBOutlet weak var emptyStateLbl: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var tagEmptyLbl: UILabel!
    @IBOutlet weak var remarksEmptyLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var showAllBtn: UIButton!
    
    var tagExpand: Bool = false
    var tagList: [DoctorTag] = []
    var remarksList: [DoctorRemarks] = []
    
    //MARK:- View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.estimatedRowHeight = 500
        
        tagListView.delegate = self
        tagListView.textFont = UIFont(name: fontSemiBold, size: 14.0)!
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if tagExpand == true
        {
            tagList = BL_DoctorDetail.sharedInstance.getTagList()
        }
        else
        {
            tagList = BL_DoctorDetail.sharedInstance.getDefaultTagList()
        }
        remarksList = BL_DoctorDetail.sharedInstance.getRemarksList()
        setTagEmptyState()
        setRemarksEmptyState()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Tag list delegates
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        sender.removeTagView(tagView)
    }
    
    //MARK:- Tag functions
    @IBAction func showAllAction(_ sender: Any)
    {
        if tagExpand == false
        {
            tagExpand = true
            tagList = BL_DoctorDetail.sharedInstance.getTagList()
            reloadTagList()
        }
    }
    
    func setTagEmptyState()
    {
        if tagList.count > 0
        {
            tagEmptyLbl.isHidden = true
            tagListView.isHidden = false
            if tagList.count > defaultTagCount
            {
                showAllBtn.isHidden = false
            }
            else
            {
                showAllBtn.isHidden = true
            }
            reloadTagList()
        }
        else
        {
            tagEmptyLbl.isHidden = false
            tagEmptyLbl.text = NOT_APPLICABLE
            tagListView.isHidden = true
            showAllBtn.isHidden = true
        }
    }
    
    func reloadTagList()
    {
        tagListView.removeAllTags()
        for model in tagList
        {
            tagListView.addTag(model.tagName)
        }
    }
    
    //MARK:- Remarks functions
    func setRemarksEmptyState()
    {
        if remarksList.count > 0
        {
            tableView.isHidden = false
            remarksEmptyLbl.isHidden = true
            tableView.reloadData()
        }
        else
        {
            tableView.isHidden = true
            remarksEmptyLbl.isHidden = false
            remarksEmptyLbl.text = NOT_APPLICABLE
        }
    }
    
    //MARK:- Tableview delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return remarksList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifier.DoctorTagCell) as! DoctorTagCell
        cell.remarksDate.text = remarksList[indexPath.row].remarksDate
        cell.remarksDesc.text = remarksList[indexPath.row].remarksDesc
        return cell
    }
}
