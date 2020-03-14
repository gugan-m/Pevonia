//
//  TPMeetingObjectiveViewController.swift
//  HiDoctorApp
//
//  Created by SSPLLAP-011 on 28/02/20.
//  Copyright © 2020 swaas. All rights reserved.
//

import UIKit

class TPMeetingObjectiveViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var lblMeetingObjective: UILabel!
    @IBOutlet weak var txtMeetingObjective: UITextField!
    @IBOutlet weak var tblAttachments: UITableView!
    @IBOutlet weak var sampleSearchBar: UISearchBar!
    @IBOutlet weak var tblSamples: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewhdrSelectedSamples: UIView!
    @IBOutlet weak var consSelectedTblHeight: NSLayoutConstraint!
    @IBOutlet weak var tblSelectedSample: UITableView!
    @IBOutlet weak var SelectedListHeaderView: UIView!
    @IBOutlet weak var selectedListView: UITableView!
    
    //MARK:- Variables
    var meetingObjectiveList: [CallObjectiveModel] = []
    var pickerview = UIPickerView()
    var sampleList: [UserProductMapping] = []
    var selectedSampleArr: [UserProductMapping] = []
    var masterSampleArr: [UserProductMapping] = []
    var searchSampleArr: [UserProductMapping] = []
    var isSearchEnable = false
    var searchtext = ""
    var objDoctor : StepperDoctorModel?
    var userDCRProductList : [DCRSampleModel] = []
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedSampleArr = []
        self.masterSampleArr = []
        self.searchSampleArr = []
        self.pickerview.delegate = self
        self.getMeetingObjective()
        self.getSamplesList()
        let val = userDCRProductList
        print(userDCRProductList)
        self.txtMeetingObjective.inputView = self.pickerview
        self.title = convertDateIntoString(date: TPModel.sharedInstance.tpDate) + " (Field)"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if objDoctor != nil {
            let subTitle = NSMutableAttributedString()
            let hdr = NSMutableAttributedString(string: "Manage Meeting Plan for\n")
            let contactName = NSMutableAttributedString(string: objDoctor!.Customer_Name ?? "", attributes: [NSAttributedStringKey.foregroundColor: UIColor.darkGray,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17.0)])
                       subTitle.append(hdr)
                       subTitle.append(contactName)
            self.lblMeetingObjective.attributedText = subTitle
        } else {
            self.lblMeetingObjective.text = ""
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if selectedSampleArr.count != 0 && objDoctor != nil {
            let currentList = convertToDCRSampleModel(list: selectedSampleArr)
                BL_TPStepper.sharedInstance.insertSelectedSamples(doctorCode: objDoctor!.Customer_Code, regionCode: objDoctor!.Region_Code, lstDCRSamples: currentList)
        } else {
            BL_TPStepper.sharedInstance.deleteSelectedSamplesForDoctor(tpEntryId: TPModel.sharedInstance.tpEntryId, doctorCode: objDoctor!.Customer_Code, regionCode: objDoctor!.Region_Code)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.scrollView.contentSize = self.setScrollViewOffset()
    }
    
    func setScrollViewOffset() -> CGSize {
        let serch_listHeight = CGFloat(395)
        let selected_thblHeight = CGFloat(70 * self.selectedSampleArr.count)
        if self.selectedSampleArr.count == 0 {
            self.viewhdrSelectedSamples.isHidden = true
            self.selectedListView.isHidden = true
        } else {
            self.viewhdrSelectedSamples.isHidden = false
            self.selectedListView.isHidden = false
        }
        self.consSelectedTblHeight.constant = selected_thblHeight
        let tbl_Sample_maxy = self.tblSamples.frame.origin.y + self.tblSamples.frame.maxY
        return CGSize(width: self.view.frame.width, height: selected_thblHeight + tbl_Sample_maxy + serch_listHeight)
    }
    
    func getMeetingObjective() {
        self.meetingObjectiveList = DBHelper.sharedInstance.getCallObjectiveByEntityType(entityType: Constants.Call_Objective_Entity_Type_Ids.Doctor)
    }
    
    func getSamplesList() {
        if userDCRProductList.count != 0 {
            self.sampleList = DBHelper.sharedInstance.getUserProducts(dateString: TPModel.sharedInstance.tpDateString)!
            for sam_obj in userDCRProductList {
                for num in 0..<self.sampleList.count{
                    if sam_obj.sampleObj.Product_Code == self.sampleList[num].Product_Code {
                        self.sampleList[num].Selected_Quantity = sam_obj.sampleObj.Quantity_Provided
                    }
                }
            }
            // Non filtered Array
            for sam_obj in userDCRProductList {
                for sample in self.sampleList{
                    if sam_obj.sampleObj.Product_Code != sample.Product_Code {
                        self.masterSampleArr.append(sample)
                    }
                }
            }
            // Selected ArrList
            for sam_obj in userDCRProductList {
                for sample in self.sampleList{
                    if sam_obj.sampleObj.Product_Code == sample.Product_Code {
                        self.selectedSampleArr.append(sample)
                    }
                }
            }
        } else {
            self.sampleList = DBHelper.sharedInstance.getUserProducts(dateString: TPModel.sharedInstance.tpDateString)!
            if selectedSampleArr.count == 0 && self.masterSampleArr.count == 0 {
                self.masterSampleArr = self.sampleList
            }
        }
        self.tblSelectedSample.reloadData()
                   self.tblSamples.reloadData()
    }

    @IBAction func act_AddAttachment(_ sender: UIButton) {
        self.show_AddActionSheet()
    }
    
    func show_AddActionSheet() {
        
    }
    
    @IBAction func act_stepper(_ sender: UIStepper) {
        
        for num in 0..<self.sampleList.count {
            if self.sampleList[num].Product_Id == sender.tag {
                self.sampleList[num].Selected_Quantity = Int(sender.value)
            }
        }
        self.selectedSampleArr = self.sampleList.filter{$0.Selected_Quantity != 0}
        if self.selectedSampleArr.count == 0 {
            self.sampleList = DBHelper.sharedInstance.getUserProducts(dateString: TPModel.sharedInstance.tpDateString)!
        }
        self.masterSampleArr = self.sampleList.filter{$0.Selected_Quantity == 0}
        if self.isSearchEnable ==  true {
            self.sortCurrentList(searchText: self.searchtext)
        }
        
        self.tblSelectedSample.reloadData()
        self.tblSamples.reloadData()
        self.scrollView.contentSize = self.setScrollViewOffset()
    }
    
    func convertToDCRSampleModel(list : [UserProductMapping]) -> [DCRSampleModel]
    {
        var sampleObjList : [SampleProductsModel] = []
        var sampleProductList : [DCRSampleModel] = []
        
        for obj in list
        {
            let sampleObj : SampleProductsModel = SampleProductsModel()
            sampleObj.Product_Name = obj.Product_Name
            sampleObj.Product_Id = obj.Product_Id
            sampleObj.Product_Code = obj.Product_Code
            sampleObj.Current_Stock = obj.Current_Stock
            sampleObj.Product_Type_Name = obj.Product_Type_Name
            sampleObj.Division_Name = obj.Division_Name
            sampleObj.Quantity_Provided = obj.Selected_Quantity
            sampleObj.Speciality_Code = obj.Speciality_Code
            sampleObjList.append(sampleObj)
        }
        
        for productObj in sampleObjList
        {
            let sampleObj : DCRSampleModel = DCRSampleModel(sampleObj: productObj)
            sampleProductList.append(sampleObj)
        }
        
        return sampleProductList
    }
    
    func addDCRSampleProducts(list : [DCRSampleModel]) -> [DCRSampleModel]
    {
        let userSelectedList = list
        
        for obj in userSelectedList
        {
            _ = userDCRProductList.filter {
                if $0.sampleObj.Product_Code == obj.sampleObj.Product_Code
                {
                    obj.sampleObj.Quantity_Provided = $0.sampleObj.Quantity_Provided
                }
                return true
            }
        }
        
        return userSelectedList
    }
    
}

//MARK:- Picker View Delegate Methods

extension TPMeetingObjectiveViewController: UIPickerViewDelegate,UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.meetingObjectiveList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.meetingObjectiveList[row].Call_Objective_Name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtMeetingObjective.text = self.meetingObjectiveList[row].Call_Objective_Name
        self.txtMeetingObjective.resignFirstResponder()
    }
}

//MARK:- Table View Delegate Methods

extension TPMeetingObjectiveViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblAttachments
        {
           return 1
        }
        else if tableView == tblSelectedSample
        {
            return selectedSampleArr.count
        }
        else
        {
            if self.isSearchEnable ==  true {
                return self.searchSampleArr.count
            } else {
                return self.masterSampleArr.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if tableView == tblAttachments
       {
          let cell = tableView.dequeueReusableCell(withIdentifier: "TpMeetingObjAttachmentcell")
          cell?.textLabel!.text = "attachment123.png"
          return cell!
       }
       else if tableView == tblSelectedSample
       {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TPSelectedSampleListCell") as! TPSelectedSampleListCell
        let obj = self.selectedSampleArr[indexPath.row]
        cell.Stepper.tag =  obj.Product_Id
        cell.Stepper.value = Double(obj.Selected_Quantity)
        cell.lblSampleName.text = obj.Product_Name
        cell.lblSampleCount.text = String(Int(cell.Stepper.value))
        return cell
        }
        else
        {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TpMeetingObjSamplescell") as! TpMeetingObjSamplescell
            var obj: UserProductMapping!
            if self.isSearchEnable ==  true {
                obj = self.searchSampleArr[indexPath.row]
            } else {
                obj = self.masterSampleArr[indexPath.row]
            }
            cell.Stepper.tag =  obj.Product_Id
            cell.Stepper.value = Double(obj.Selected_Quantity)
            cell.lblSampleName.text = obj.Product_Name
            cell.lblSampleCount.text = String(Int(cell.Stepper.value))
        return cell
       }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblAttachments
        {
           return 50
        }
        else if tableView == tblSelectedSample
        {
          return 70
        }
        else
        {
           return 70
        }
    }
}

//MARK:- Search Bar Delegate Methods

extension TPMeetingObjectiveViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.sampleSearchBar.resignFirstResponder()
        self.isSearchEnable = false
        self.searchtext = ""
        self.tblSamples.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.isSearchEnable = true
        self.sampleSearchBar.resignFirstResponder()
        self.tblSamples.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count != 0 {
            self.isSearchEnable = true
            self.sortCurrentList(searchText: searchText)
        } else {
            self.searchSampleArr = self.masterSampleArr
            self.isSearchEnable = false
            self.searchtext = ""
            self.tblSamples.reloadData()
        }
        self.searchtext = searchText
    }
    
    func sortCurrentList(searchText:String)
    {
        var searchList : [UserProductMapping] = []
        searchList = self.masterSampleArr.filter { (userDetails) -> Bool in
            let lowerCasedText = searchText.lowercased()
            let userName = (userDetails.Product_Name).lowercased()
            return userName.contains(lowerCasedText) && userDetails.Selected_Quantity == 0
        }
        self.searchSampleArr = searchList
         self.tblSamples.reloadData()
    }
}

//MARK:- Table View Cell Class

class TpMeetingObjAttachmentcell : UITableViewCell {
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

class TpMeetingObjSamplescell : UITableViewCell {
    
    
    @IBOutlet weak var lblSampleName: UILabel!
    @IBOutlet weak var lblSampleCount: UILabel!
    @IBOutlet weak var Stepper: UIStepper!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

class TPSelectedSampleListCell: UITableViewCell {
    
     @IBOutlet weak var lblSampleName: UILabel!
     @IBOutlet weak var lblSampleCount: UILabel!
     @IBOutlet weak var Stepper: UIStepper!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
