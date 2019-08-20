//
//  CustomerAddressViewController.swift
//  HiDoctorApp
//
//  Created by SwaaS on 19/03/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

protocol customerAddressSelecitonDelegate
{
    func selectAddres(indexPath: IndexPath, customerAddressList: [CustomerAddressModel], currentLocation: GeoLocationModel)
}

class CustomerAddressViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var msgLabel: UILabel!
    
    //MARK:- Variables
    var addressList: [CustomerAddressModel] = []
    var objCustomer: CustomerMasterModel!
    var indexPath: IndexPath!
    var delegate: customerAddressSelecitonDelegate?
    var currentLocation: GeoLocationModel!
    
    //MARK:- Life Cycle Events
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setDefaults()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setDefaults()
    {
        tableView.estimatedRowHeight = 1000
        self.title = "\(objCustomer.Customer_Name!)"
        self.msgLabel.text = "We have find the below addresses for this \(appDoctor). Please tap on the address, if you are at any of the below addresses"
        
        let doneButton = UIButton(type: UIButtonType.custom)
        doneButton.addTarget(self, action: #selector(doneBtnClicked), for: .touchUpInside)
        doneButton.setTitle(nbDoneTitle, for: .normal)
        doneButton.sizeToFit()
        let rightBarButtonItem = UIBarButtonItem(customView: doneButton)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        let backButton = UIButton(type: UIButtonType.custom)
        backButton.addTarget(self, action: #selector(self.backButtonClicked), for: UIControlEvents.touchUpInside)
        backButton.setImage(UIImage(named: "navigation-arrow"), for: .normal)
        backButton.sizeToFit()
        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    //MARK:- Button Actions
    @objc func doneBtnClicked()
    {
        let filteredArray = addressList.filter{
            $0.Is_Selected == true
        }
        
        if (filteredArray.count == 0)
        {
            AlertView.showAlertView(title: errorTitle, message: "Please select an address", viewController: self)
            return
        }
        
        self.delegate?.selectAddres(indexPath: self.indexPath, customerAddressList: filteredArray, currentLocation: self.currentLocation)
    }
    
    @objc func backButtonClicked()
    {
        _ = navigationController?.popViewController(animated: false)
    }
    
    //MARK:-- Table View Delegates
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return addressList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerAddressCell") as! CustomerAddressCell
        let objAddress = addressList[indexPath.row]
        var addressText: String = EMPTY
        
        if (objAddress.Address1 != EMPTY)
        {
            addressText = "Address 1: \(objAddress.Address1!) | "
        }
        else
        {
            addressText = "Address 1: N/A | "
        }
        
        if (objAddress.Address2 != EMPTY)
        {
            addressText += "Address 2: \(objAddress.Address2!) | "
        }
        else
        {
            addressText += "Address 2: N/A | "
        }
        
        if (objAddress.Local_Area != EMPTY)
        {
            addressText += "Local Area: \(objAddress.Local_Area!) | "
        }
        else
        {
            addressText += "Local Area: N/A | "
        }
        
        if (objAddress.City != EMPTY)
        {
            addressText += "City: \(objAddress.City!) | "
        }
        else
        {
            addressText += "City: N/A | "
        }
        
        if (objAddress.State != EMPTY)
        {
            addressText += "State: \(objAddress.State!) | "
        }
        else
        {
            addressText += "State: N/A | "
        }
        
        if (objAddress.Pin_Code != EMPTY)
        {
            addressText += "Pin Code: \(objAddress.Pin_Code!) | "
        }
        else
        {
            addressText += "Pin Code: N/A | "
        }
        let strHospitalName = checkNullAndNilValueForString(stringData: objAddress.Hospital_Name) as? String
        if (strHospitalName != EMPTY)
        {
            addressText += "\(PEV_HOSPITAL_NAME): \(strHospitalName!)"
        }
        else
        {
            addressText += "\(PEV_HOSPITAL_NAME): N/A"
        }
        
        cell.addressLabel.text = addressText
        if(addressList[indexPath.row].Is_Selected)
        {
            cell.accessoryType = .checkmark
            //cell.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        }
        else
        {
            cell.accessoryType = .none
            //cell.backgroundColor = UIColor.white
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        addressList[indexPath.row].Is_Selected = !addressList[indexPath.row].Is_Selected
        var index: Int = 0
        
        for objAddress in addressList
        {
            if (index != indexPath.row)
            {
                objAddress.Is_Selected = false
            }
            index += 1
        }
        
        tableView.reloadData()
    }
}
