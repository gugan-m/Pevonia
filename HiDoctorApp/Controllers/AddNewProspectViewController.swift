//
//  AddNewProspectViewController.swift
//  HiDoctorApp
//
//  Created by SSPLLAP-011 on 19/03/20.
//  Copyright © 2020 swaas. All rights reserved.
//

import UIKit

class AddNewProspectViewController: UIViewController {

    //MARK:- Outlets
    
    //MARK:- Add new Prospect
    @IBOutlet weak var viewAccountName: UIView!
    @IBOutlet weak var viewProspectName: UIView!
    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var viewCity: UIView!
    @IBOutlet weak var viewState: UIView!
    @IBOutlet weak var viewZip: UIView!
    @IBOutlet weak var viewPhoneNumber: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var txtAccountName: UITextField!
    @IBOutlet weak var txtProspectName: UITextField!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtZip: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var segmentStatus: UISegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var addView: UIStackView!
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var lblNoProspect: UILabel!
    //MARK:- Edit New Prospect
    @IBOutlet weak var consAddViewHeight: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblProspecting: UITableView!
    @IBOutlet weak var imgDropDown_AddProspect: UIImageView!
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var btnAddNewProspect: UIButton!
    //MARK:- Variables

    let add_COLOR = UIColor.init(red: 0/255.0, green: 150/255.0, blue: 136/255.0, alpha: 1.0)
    let edit_COLOR = UIColor.init(red: 44/255.0, green: 83/255.0, blue: 162/255.0, alpha: 1.0)
    var selctedIndexPath : IndexPath?
    var canShowAddView = false
    var prospectArray: [AddProspectModel] = []
    var searchProspectArr: [AddProspectModel] = []
    var isNewProspect = false
    var isSearchEnable = false
    var selectedArr : [AddProspectModel] = []
    var selectedObj: AddProspectModel?
    var pickerview  = UIPickerView()
    
    var usStatesArr = ["Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","District of Columbia","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","West Virginia","Wisconsin","Wyoming","American Samoa","Guam","Northern Mariana Islands","Puerto Rico","U.S. Virgin Islands","Micronesia","Marshall Islands","Palau","U.S. Armed Forces – Americas[d]","U.S. Armed Forces – Europe[e]","U.S. Armed Forces – Pacific[f]","Northern Mariana Islands","Panama Canal Zone","Nebraska","Philippine Islands","Trust Territory of the Pacific Islands"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerview.delegate = self
        self.title = " "
        self.setDoneButton()
        self.consAddViewHeight.constant = 0
        self.txtState.inputView = pickerview
        if let arr = DBHelper.sharedInstance.getProspect(){
          self.prospectArray = arr
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 2)
    }
    
    @IBAction func act_AddProspect(_ sender: UIButton) {
        view.layoutIfNeeded()
        if canShowAddView {
            self.showAddView()
        } else {
            self.hideAddView()
        }
    }
    
    @IBAction func act_AddProspectUser(_ sender: UIButton) {
        if isSearchEnable {
            for num in 0..<searchProspectArr.count {
                if num == sender.tag{
                    searchProspectArr[num].isSelected = true
                } else {
                    searchProspectArr[num].isSelected = false
                }
            }
        } else {
            for num in 0..<prospectArray.count {
                if num == sender.tag{
                    prospectArray[num].isSelected = true
                } else {
                    prospectArray[num].isSelected = false
                }
            }
        }
        
       var selectedArr : [AddProspectModel] = []
        if isSearchEnable {
         selectedArr = searchProspectArr.filter({$0.isSelected == true})
        } else {
         selectedArr = prospectArray.filter({$0.isSelected == true})
        }
         if selectedArr.count != 0 {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
         } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        self.tblProspecting.reloadData()
    }
    
    func setDoneButton() {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "icon-done"), for: .normal)
        button.addTarget(self, action:#selector(doneAction), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func showAddView() {
        self.addView.isHidden = false
        canShowAddView = false
        self.imgDropDown_AddProspect.image = UIImage(named: "icon-stepper-up-arrow")
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.consAddViewHeight.constant = 570
            self.view.layoutIfNeeded()
        })
    }
    
   func hideAddView(){
    canShowAddView = true
    self.addView.isHidden = true
    clearAll()
    self.btnAddNewProspect.setTitle("  Add New Prospect", for: .normal)
    self.imgDropDown_AddProspect.image = UIImage(named: "icon-stepper-down-arrow")
                   UIView.animate(withDuration: 0.2, animations: { () -> Void in
                       self.consAddViewHeight.constant = 0
                       self.view.layoutIfNeeded()
                   })
    self.scrollView.setContentOffset(.zero, animated: true)
    }
    
    @objc func doneAction() {
       selectedArr = []
       if isSearchEnable {
        selectedArr = searchProspectArr.filter({$0.isSelected == true})
       } else {
        selectedArr = prospectArray.filter({$0.isSelected == true})
       }
        for data in selectedArr {
            self.saveDoctorInFlexi(DoctorName:data.Contact_Name, Title: data.Title)
        }
    }
    
    
    @IBAction func act_Save(_ sender: UIButton) {
        self.doValidation()
    }
    
    func doValidation()
    {
        if txtAccountName.text?.count == 0 {
            AlertView.showAlertView(title: "Account Name", message: "Please enter account name")
        } else if txtProspectName.text?.count == 0 {
            AlertView.showAlertView(title: "Prospect Name", message: "Please enter prospect name")
//        } else if txtTitle.text?.count == 0 {
//            AlertView.showAlertView(title: "Title", message: "Please enter title")
       } else if txtCity.text?.count == 0 {
            AlertView.showAlertView(title: "City", message: "Please enter city")
        } else if txtState.text?.count == 0 {
            AlertView.showAlertView(title: "State", message: "Please enter state")
        } else if txtZip.text?.count == 0 {
            AlertView.showAlertView(title: "Zip", message: "Please enter zip")
//        } else if txtPhoneNumber.text?.count == 0 {
//            AlertView.showAlertView(title: "Phone Number", message: "Please enter phone number")
//        } else if txtEmail.text?.count == 0 {
//            AlertView.showAlertView(title: "Email", message: "Please enter email id")
//        } else if !isValidEmail(stringData: txtEmail.text!) {
//            AlertView.showAlertView(title: "Email", message: "Please enter valid email id")
      } else {
            var flag = ""
            var ProspectId = 0
            if selectedObj != nil {
                ProspectId = selectedObj!.Prospect_Id
            }
            if self.btnAddNewProspect.currentTitle == "  Add New Prospect" && ProspectId == 0 {
              flag = "Add"
            } else {
               flag = "Edit"
            }
            let status = self.segmentStatus.titleForSegment(at: self.segmentStatus.selectedSegmentIndex)
            self.saveProspect(Flag: flag, Account_Name: txtAccountName.text!, Contact_Name: txtProspectName.text!, Title: txtTitle.text!, Address: txtAddress.text!, City: txtCity.text!, State: txtState.text!, Phone_No: txtPhoneNumber.text!, Email: txtEmail.text!, Prospect_Status:status!, Zip: Int(txtZip.text!)!)
        }
    }
    
    func saveProspect(Flag: String, Account_Name:String ,Contact_Name:String ,Title:String, Address:String, City:String, State:String, Phone_No:String, Email:String ,Prospect_Status:String,Zip: Int)
    {
        var prosArr:NSArray = []
        let companyId = getCompanyId()
        var Prospect_Id = 0
        if Flag == "Add"{
            Prospect_Id = 0
        } else {
            Prospect_Id = selectedObj?.Prospect_Id ?? 0
        }
        
        let dict = ["Flag": Flag ,"Prospect_Id": Prospect_Id,"Company_Code": getCompanyCode() ,"Company_Id":companyId,"Account_Name": Account_Name, "Contact_Name":Contact_Name, "Title":Title ?? "", "Address":Address ?? "", "City":City, "State": State,"Phone_No":Phone_No ?? "","Email":Email ?? "","Prospect_Status":Prospect_Status,"DCR_Date": getCurrentDate(),"Created_Region_Code": getRegionCode(),"Created_By": getUserCode(),"Created_DateTime": getStringFromDateforPunch(date: Date()),"Zip": Zip] as [String : Any]
        prosArr = [dict]
        let postData = AddProspectModel(dict: dict as NSDictionary)
            self.updateProspectDetails(flag: Flag, postData: postData)
    }
    
    func saveDoctorInFlexi(DoctorName: String,Title: String){
        
    BL_DCR_Doctor_Visit.sharedInstance.saveFlexiDoctor(doctorName:condenseWhitespace(stringValue: DoctorName))
            
            if self.navigationController != nil
            {
                let sb = UIStoryboard(name: doctorMasterSb, bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: doctorVisitStepperVcID) as! DoctorVisitStepperController
                vc.flexiDoctorName = DoctorName
                vc.flexiSpecialityName = Title
                vc.flexiDoctorName = DoctorName
                if(BL_MenuAccess.sharedInstance.is_Punch_In_Out_Enabled() && isCurrentDate())
                {
                vc.flexiSpecialityName = Title
                
                vc.flexiDoctorName = DoctorName
                
                vc.flexiSpecialityName = Title
                
                var localTimeZoneName: String { return TimeZone.current.identifier }
                
                //vc.currentLocation = currentLocation
                
                vc.punch_start = getStringFromDateforPunch(date: getCurrentDateAndTime())
                
                vc.punch_status = 1
                
                vc.punch_UTC = getUTCDateForPunch()
                
                vc.isfromProspect = true
                    
                vc.punch_timezone = localTimeZoneName
                
                vc.punch_timeoffset = getOffset()
                }
                //                DCRModel.sharedInstance.customerId = 0
                DCRModel.sharedInstance.customerCode = ""
                DCRModel.sharedInstance.customerRegionCode = getRegionCode()
                DCRModel.sharedInstance.doctorVisitId = 0
                
                if let navigationController = self.navigationController
                {
                    navigationController.popViewController(animated: false)
                    navigationController.pushViewController(vc, animated: false)
                    
                }
            }
        }
    
    private func navigateToNextScreen(stoaryBoard: String, viewController:String)
    {
        let sb = UIStoryboard(name: stoaryBoard, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: viewController)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func isCurrentDate() -> Bool
    {
        
        let dcrDate = DCRModel.sharedInstance.dcrDateString
        let currentDate = getCurrentDate()
        
        if (dcrDate == currentDate)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func getProspectData(model:AddProspectModel) -> [String:Any]{
       
        let dict: [String:Any]?
        var Flag : String = ""
        var Prospect_Id : Int = 0
        var Company_Code : String = ""
        var Company_Id : Int = 0
        var Account_Name : String = ""
        var Contact_Name : String = ""
        var Address : String = ""
        var City : String = ""
        var State : String = ""
        var Phone_No : String = ""
        var Email : String = ""
        var Prospect_Status : String = ""
        var Title : String = ""
        var Zip : Int = 0
        
        if model.Flag != nil {
            Flag = model.Flag
        }
        if model.Prospect_Id != nil {
            Prospect_Id = model.Prospect_Id
        }
        if model.Company_Code != nil {
            Company_Code = model.Company_Code
        }
        if model.Company_Id != nil {
            Company_Id = model.Company_Id
        }
        if model.Account_Name != nil {
            Account_Name = model.Account_Name
        }
        if model.Contact_Name != nil {
            Contact_Name = model.Contact_Name
        }
        if model.Address != nil {
            Address = model.Address
        }
        if model.City != nil {
            City = model.City
        }
        if model.State != nil {
            State = model.State
        }
        if model.Phone_No != nil {
            Phone_No = model.Phone_No
        }
        if model.Email != nil {
            Email = model.Email
        }
        if model.Prospect_Status != nil {
            Prospect_Status = model.Prospect_Status
        }
        if model.Title != nil {
            Title = model.Title
        }
        if model.Zip != nil {
            Zip = model.Zip
        }
        
        dict = ["Flag": Flag ,"Prospect_Id": Prospect_Id,"Company_Code": Company_Code,"Company_Id": Company_Id,"Account_Name": Account_Name, "Contact_Name":Contact_Name, "Title":Title, "Address":Address, "City":City, "State": State,"Phone_No":Phone_No,"Email":Email,"Prospect_Status":Prospect_Status,"DCR_Date": getCurrentDate(),"Created_Region_Code": getRegionCode(),"Created_By": getUserCode(),"Created_DateTime": getStringFromDateforPunch(date: Date()),"Zip": Zip] as [String : Any]
        return dict!
        
    }
    
    func updateProspectDetails(flag: String,postData: AddProspectModel) {
        if postData != nil {
            if flag == "Edit"{
                showCustomActivityIndicatorView(loadingText: "Updating Prospect..")
            } else {
                showCustomActivityIndicatorView(loadingText: "Saving Prospect..")
            }
            
            WebServiceHelper.sharedInstance.updateProspect(postData: self.getProspectData(model: postData), completion: {
                (apiObj) in
                if apiObj.Status ==  SERVER_SUCCESS_CODE
                {
                    if flag == "Edit" && apiObj.list != nil && apiObj.list.count == 0{
                        var prosArr:NSArray = []
                        let dict = self.getProspectData(model: postData)
                        prosArr = [dict]
                        self.selectedObj = nil
                        DBHelper.sharedInstance.deleteProspecting(Prospect_Id: postData.Prospect_Id)
                        DBHelper.sharedInstance.insertProspecting(ProspectList: prosArr)
                        if let arr = DBHelper.sharedInstance.getProspect(){
                        self.prospectArray = arr
                        }
                        self.hideAddView()
                        self.tblProspecting.reloadData()
                        removeCustomActivityView()
                    } else {
                        self.saveDoctorInFlexi(DoctorName:postData.Contact_Name, Title: postData.Title)
                        if apiObj.list != nil && apiObj.list.count != 0 {
                            DBHelper.sharedInstance.insertProspecting(ProspectList: apiObj.list)
                           if let arr = DBHelper.sharedInstance.getProspect(){
                            self.prospectArray = arr
                            }
                            self.tblProspecting.reloadData()
                            removeCustomActivityView()
                        } else {
                            removeCustomActivityView()
                        }
                    }
                } else {
                    removeCustomActivityView()
                    if flag != "Edit"{
                       self.saveDoctorInFlexi(DoctorName:postData.Contact_Name, Title: postData.Title)
                    } else {
                    AlertView.showAlertView(title: "Prospect update failed", message: "Try after some time")
                    }
                }
            })
        }
    }
    
    func insertProspectDetails(arr: NSArray){
        DBHelper.sharedInstance.insertProspecting(ProspectList: arr)
    }
    
    func editProspectDetails() {
        if selectedObj != nil {
            self.txtAccountName.text = selectedObj?.Account_Name
            self.txtProspectName.text = selectedObj?.Contact_Name
            self.txtTitle.text = selectedObj?.Title
            self.txtAddress.text = selectedObj?.Address
            self.txtCity.text = selectedObj?.City
            self.txtState.text = selectedObj?.State
            self.txtZip.text =  selectedObj?.Zip.map(String.init) ?? ""
            self.txtPhoneNumber.text = selectedObj?.Phone_No
            self.txtEmail.text = selectedObj?.Email
            if selectedObj?.Prospect_Status != nil {
                if selectedObj?.Prospect_Status  == "Cold"   {
                  self.segmentStatus.selectedSegmentIndex = 0
                } else if selectedObj?.Prospect_Status == "Warm" {
                    self.segmentStatus.selectedSegmentIndex = 1
                } else {
                    self.segmentStatus.selectedSegmentIndex = 2
                }
            }
            self.btnAddNewProspect.setTitle("  Edit Prospect", for: .normal)
        }
    }
    
    func isProspectnameExist(name: String) -> Bool {
            let arr = prospectArray.filter({$0.Contact_Name.lowercased() == name.lowercased()})
            if arr.count == 0 {
                return false
            } else {
                return true
            }
    }
    
  func clearAll()   {
        if selectedObj != nil {
            self.txtAccountName.text = ""
            self.txtProspectName.text = ""
            self.txtTitle.text = ""
            self.txtAddress.text = ""
            self.txtCity.text = ""
            self.txtState.text = ""
            self.txtZip.text = ""
            self.txtPhoneNumber.text = ""
            self.txtEmail.text = ""
            self.segmentStatus.selectedSegmentIndex = 0
        }
    }
}
extension AddNewProspectViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.txtAccountName:
            self.txtProspectName.becomeFirstResponder()
            case self.txtProspectName:
                if isProspectnameExist(name: textField.text!) == true {
                    self.txtProspectName.text = ""
                   AlertView.showAlertView(title: "Prospect Name", message: "Prospect name already exist")
                } else {
                    self.txtTitle.becomeFirstResponder()
                }
            case self.txtTitle:
            self.txtAddress.becomeFirstResponder()
            case self.txtAddress:
            self.txtCity.becomeFirstResponder()
            case self.txtCity:
            self.txtState.becomeFirstResponder()
            case self.txtState:
            self.txtZip.becomeFirstResponder()
            case self.txtZip:
            self.txtPhoneNumber.becomeFirstResponder()
            case self.txtPhoneNumber:
            self.txtEmail.becomeFirstResponder()
            case self.txtEmail:
            self.txtEmail.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtProspectName {
            if isProspectnameExist(name: textField.text!) == true {
                self.txtProspectName.text = ""
               AlertView.showAlertView(title: "Prospect Name", message: "Prospect name already exist")
            }
        }
        return true
    }
    
}

extension AddNewProspectViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       if searchText.count != 0 {
        self.isSearchEnable = true
        sortCurrentList(searchText: searchText)
        } else {
        self.isSearchEnable = false
        self.tblProspecting.reloadData()
        }
    }
    
    func sortCurrentList(searchText:String)
    {
         var searchList : [AddProspectModel] = []
        searchList = self.prospectArray.filter { (userDetails) -> Bool in
            let lowerCasedText = searchText.lowercased()
            let userName = (userDetails.Contact_Name).lowercased()
            return userName.contains(lowerCasedText)
        }
        searchProspectArr = searchList
        self.tblProspecting.reloadData()
    }
}


extension AddNewProspectViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchEnable {
            if searchProspectArr.count == 0 {
                self.lblNoProspect.isHidden = false
                self.tblProspecting.isHidden = true
                return 0
            } else {
                self.lblNoProspect.isHidden = true
                self.tblProspecting.isHidden = false
                return searchProspectArr.count
            }
        } else {
            if prospectArray.count == 0 {
                self.lblNoProspect.isHidden = false
                self.tblProspecting.isHidden = true
                return 0
            } else {
                self.lblNoProspect.isHidden = true
                self.tblProspecting.isHidden = false
                return prospectArray.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"ProspectingCell" ) as! ProspectingCell
        let SelectedDoctorList = BL_Stepper.sharedInstance.doctorList
         if isSearchEnable {
            let dict = self.searchProspectArr[indexPath.row]
            cell.lblProspectingName.text = dict.Contact_Name
            cell.lblProspectingDetails.text =  dict.Title + " | " + dict.Account_Name + " | " + dict.City
            cell.btnSelected.tag = indexPath.row
            if dict.isSelected == true {
             cell.btnSelected.setImage(UIImage(named: "icon-tick"), for: .normal)
            } else {
               cell.btnSelected.setImage(UIImage(named: "icon-unselected"), for: .normal)
            }
            for docObj in SelectedDoctorList {
                if docObj.Doctor_Name == dict.Contact_Name {
                    cell.btnSelected.isEnabled = false
                } else {
                    cell.btnSelected.isEnabled = true
                }
            }
          } else {
            let dict = self.prospectArray[indexPath.row]
            cell.lblProspectingName.text = dict.Contact_Name
            cell.lblProspectingDetails.text = dict.Account_Name + " | " + dict.City
            cell.btnSelected.tag = indexPath.row
            if dict.isSelected == true {
             cell.btnSelected.setImage(UIImage(named: "icon-tick"), for: .normal)
            } else {
               cell.btnSelected.setImage(UIImage(named: "icon-unselected"), for: .normal)
            }
            for docObj in SelectedDoctorList {
                if docObj.Doctor_Name == dict.Contact_Name {
                    cell.btnSelected.isEnabled = false
                } else {
                    cell.btnSelected.isEnabled = true
                }
            }
          }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if isSearchEnable {
         self.selectedObj = self.searchProspectArr[indexPath.row]
         } else {
          self.selectedObj = self.prospectArray[indexPath.row]
        }
        showAddView()
        editProspectDetails()
       self.scrollView.setContentOffset(.zero, animated: true)
    }
}

extension AddNewProspectViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.usStatesArr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtState.text = self.usStatesArr[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return usStatesArr.count
    }
}

//MARK:- Table view cell Class
class ProspectingCell : UITableViewCell {
    @IBOutlet weak var lblProspectingName: UILabel!
    @IBOutlet weak var btnSelected: UIButton!
    @IBOutlet weak var lblProspectingDetails: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
