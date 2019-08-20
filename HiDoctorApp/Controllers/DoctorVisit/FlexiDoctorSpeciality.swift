//
//  FlexiDoctorSpeciality.swift
//  HiDoctorApp
//
//  Created by Vijay on 12/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

protocol selectedSpecialityDelgate
{
    func getSelectedSpeciality(name: String, code: String)
}

class FlexiDoctorSpeciality: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var delegate : selectedSpecialityDelgate?
    @IBOutlet weak var tableView: UITableView!
    var specialityList : [SpecialtyMasterModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        specialityList = DBHelper.sharedInstance.getSpecilaity()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return specialityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = specialityList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpecialityCell")
        
        cell?.textLabel?.text = model.Speciality_Name
        cell?.textLabel?.font = UIFont(name: fontRegular, size: 14.0)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = specialityList[indexPath.row]
        
        delegate?.getSelectedSpeciality(name: model.Speciality_Name, code: model.Speciality_Code)
        
        _ = navigationController?.popViewController(animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
