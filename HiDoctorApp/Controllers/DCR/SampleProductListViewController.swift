//
//  SampleProductListViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 20/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class SampleProductListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate
{
    // MARK:- Variable
    
    // MARK:-- Outlet
    
    @IBOutlet weak var emptyStateImgViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar : UISearchBar!
    @IBOutlet weak var emptyStateView : UIView!
    @IBOutlet weak var contentView : UIView!
    @IBOutlet weak var emptyStateTitleLbl: UILabel!
    @IBOutlet weak var searchBarHeightConst: NSLayoutConstraint!
    
    //MARK:-- Class
    
    var userProductList : [UserProductMapping] = []
    var userDCRProductList : [DCRSampleModel] = []
    var userDCRChemistProductList : [DCRChemistSamplePromotion] = []
    var userSelectedProductCode : [String] = []
    var userSelectedList : NSMutableArray = []
    var currentList : [UserProductMapping]! = []
    var isComingFromSampleDetail : Bool = false
    var isComingFromChemistDay : Bool = false
    var selectedDCRCount : Int = 0
    var nextBtn : UIBarButtonItem!
    var isComingFromModifyPage : Bool = false
    var isComingFromAttendanceDoctor : Bool = false
    var attendanceDoctorVisitId = Int()
    var userDCRAttendenceProductList : [DCRAttendanceSampleDetailsModel] = []
    var sampleListArray: [NSDictionary] = []
    var sectionMenu: [String] = []
    var sampleId = Int()
    var dcrId = Int()
    var visitId = Int()

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getProductList()
        self.addBackButtonView()
        self.addBarButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let dict: NSDictionary = sampleListArray[section]
        let sampleList = dict.value(forKey: "Data_Array") as! [UserProductMapping]
        return sampleList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sampleListArray.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dict: NSDictionary = sampleListArray[section]
        return dict.value(forKey: "Section_Name") as! String
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let dict: NSDictionary = sampleListArray[indexPath.section]
        let sampleList = dict.value(forKey: "Data_Array") as! [UserProductMapping]
        let productDetail = sampleList[indexPath.row]
        var rowHeight : CGFloat = 60
        let productNameTextHeight = getTextSize(text: productDetail.Product_Name, fontName: fontRegular, fontSize: 16, constrainedWidth: SCREEN_WIDTH - 80).height
        rowHeight += productNameTextHeight
        
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: sampleProductListCell, for: indexPath) as! SampleProductListTableViewCell
        
        let dict: NSDictionary = sampleListArray[indexPath.section]
        let sampleList = dict.value(forKey: "Data_Array") as! [UserProductMapping]
        
        let productDetail = sampleList[indexPath.row]
        
        let productName  =  productDetail.Product_Name as String
        let currentStock =  String(productDetail.Current_Stock)
        let productCount  = productDetail.Product_Type_Name as String
        let divisionName =  productDetail.Division_Name as String
        cell.productNameLbl.text = "\(productName)(\(currentStock))"
        if divisionName != ""
        {
            cell.productCountLbl.text = "\(productCount) | \(divisionName)"
        }
        else
        {
            cell.productCountLbl.text = "\(productCount)"
        }
        
        if userSelectedProductCode.contains(productDetail.Product_Code)
        {
            cell.selectedImageView.image = UIImage(named: "icon-tick")
            cell.outerView.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1.0)
        }
        else if userSelectedList.contains(productDetail)
        {
            cell.selectedImageView.image = UIImage(named: "icon-tick")
            cell.outerView.backgroundColor = UIColor.white
        }
        else
        {
            cell.selectedImageView.image = UIImage(named: "icon-unselected")
            cell.outerView.backgroundColor = UIColor.white
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dict: NSDictionary = sampleListArray[indexPath.section]
        let sampleList = dict.value(forKey: "Data_Array") as! [UserProductMapping]
        let productDetail = sampleList[indexPath.row]
        if !userSelectedProductCode.contains(productDetail.Product_Code)
        {
            if self.userSelectedList.contains(productDetail)
            {
                self.userSelectedList.remove(productDetail)
            }
            else
            {
                self.userSelectedList.add(productDetail)
            }
            self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
            var  selectedCount : Int = 0
            
            selectedCount = selectedDCRCount + userSelectedList.count
            if selectedCount > 0
            {
                self.navigationItem.title = "\(String(selectedCount)) Selected"
            }
            else
            {
                self.navigationItem.title = "Samples/Input List"
            }
            if userSelectedList.count > 0
            {
                self.navigationItem.rightBarButtonItem = nextBtn
            }
            else
            {
                self.navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
    func getProductList()
    {
        userProductList = BL_SampleProducts.sharedInstance.getUserProducts(dateString: DCRModel.sharedInstance.dcrDateString)
        if(isComingFromChemistDay)
        {
            userDCRChemistProductList = BL_SampleProducts.sharedInstance.getSampleDCRChemistProducts(dcrId: DCRModel.sharedInstance.dcrId, chemistVisitId: ChemistDay.sharedInstance.chemistVisitId)!
            selectedDCRCount = userSelectedProductCode.count
            
            if !isComingFromSampleDetail
            {
                userSelectedProductCode = BL_SampleProducts.sharedInstance.getSelectChemistProductCode(dcrId: DCRModel.sharedInstance.dcrId, chemistVisitId: ChemistDay.sharedInstance.chemistVisitId)
                selectedDCRCount = userDCRChemistProductList.count
            }

        }
        else if(isComingFromAttendanceDoctor)
        {
            userDCRAttendenceProductList = DAL_DCR_Attendance.sharedInstance.getSelectedDCRAttendanceDoctorVisitSamples(doctorVisitId: attendanceDoctorVisitId, dcrId: DCRModel.sharedInstance.dcrId)
            selectedDCRCount = userDCRAttendenceProductList.count
    
            if !isComingFromSampleDetail
            {
                userSelectedProductCode = BL_DCR_Attendance.sharedInstance.getSelectDoctorProductCode(dcrId: DCRModel.sharedInstance.dcrId, doctorVisit: attendanceDoctorVisitId)
                selectedDCRCount = userDCRChemistProductList.count
            }
        }
        else
        {
           
            userDCRProductList = BL_SampleProducts.sharedInstance.getSampleDCRProducts(dcrId: DCRModel.sharedInstance.dcrId, doctorVisitId: DCRModel.sharedInstance.doctorVisitId)!
            selectedDCRCount = userSelectedProductCode.count
            
            if !isComingFromSampleDetail
            {
                userSelectedProductCode = BL_SampleProducts.sharedInstance.getSelectProductCode(dcrId: DCRModel.sharedInstance.dcrId, doctorVisitId: DCRModel.sharedInstance.doctorVisitId)
                selectedDCRCount = userDCRProductList.count
            }
        }
        
        if selectedDCRCount > 0
        {
            self.navigationItem.title = "\(String(selectedDCRCount)) Selected"
        }
        else
        {
            self.navigationItem.title = "Samples/Input List"
        }
        
       
        changeCurrentList(list: userProductList,type : 0)
    }
    
    func changeCurrentList(list: [UserProductMapping],type : Int)
    {
        sampleListArray = []
        if list.count > 0
            
        {
            var uniqueSectionName: [String] = []
            
            for sectionListObj in list
            {
                if (!uniqueSectionName.contains(sectionListObj.Product_Type_Name))
                {
                    uniqueSectionName.append(sectionListObj.Product_Type_Name)
                }
            }
            
            uniqueSectionName.sort(by: { (obj1, obj2) -> Bool in
                obj1 < obj2
            })
            for sectionName in uniqueSectionName
            {
                
                var dataArray = list.filter{
                    $0.Product_Type_Name == sectionName
                }
                
                dataArray = dataArray.sorted(by: { (obj1, obj2) -> Bool in
                    obj1.Product_Type_Name < obj2.Product_Type_Name
                })
                
                let dict: NSDictionary = ["Section_Name": sectionName, "Data_Array": dataArray]
                
                sampleListArray.append(dict)
            }
//            currentList = list
            self.tableView.reloadData()
            self.showEmptyStateView(show: false)

        }
        else
        {
            self.showEmptyStateView(show: true)
            self.setEmptyStateText(type:type)
            self.searchBar.resignFirstResponder()
        }
    }
    
    func showEmptyStateView(show : Bool)
    {
        self.emptyStateView.isHidden = !show
        self.contentView.isHidden = show
    }
    
    func setEmptyStateText(type : Int)
    {
        if type == 0
        {
            self.emptyStateTitleLbl.text = "No Samples Products found"
            self.searchBarHeightConst.constant = 0
        }
        else
        {
            self.emptyStateTitleLbl.text = "No Samples Products found.Clear your search and try again."
            self.searchBarHeightConst.constant = 44
        }
    }
    
    //MARK: - Search Bar Delegates
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool
    {
        self.searchBar.showsCancelButton = true
        enableCancelButtonForSearchBar(searchBar:searchBar)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.showsCancelButton = false
        self.searchBar.text = nil
        self.searchBar.resignFirstResponder()
        self.changeCurrentList(list: userProductList,type : 0)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if (searchBar.text?.count)! > 0
        {
            sortCurrentList(searchText: searchBar.text!)
        }
    }
    
    func sortCurrentList(searchText:String)
    {
        var searchList : [UserProductMapping] = []
        searchList = userProductList.filter{ (productDetails) -> Bool in
            let lowerCasedText = searchText.lowercased()
            let productName = (productDetails.Product_Name).lowercased()
            return productName.contains(lowerCasedText)
        }
        self.changeCurrentList(list: searchList ,type : 1)
    }
    
    @objc func nextScreenBtnAction()
    {
        var userSelectedProductList : [DCRSampleModel] = []
        userSelectedProductList = convertToDCRModel(list:userSelectedList)
        let sample_sb = UIStoryboard(name: sampleProductListSb, bundle: nil)
        let sample_nc = sample_sb.instantiateViewController(withIdentifier: sampleDCRListVcID) as! SampleDetailsViewController
        
        sample_nc.currentList = userSelectedProductList
        sample_nc.isComingFromChemistDay = self.isComingFromChemistDay
        sample_nc.isComingFromModifyPage  = isComingFromModifyPage
        sample_nc.isComingFromAttendanceDoctor = isComingFromAttendanceDoctor
        sample_nc.doctorVisitId = attendanceDoctorVisitId
        if(isComingFromModifyPage)
        {
            sample_nc.dcrId = dcrId
            sample_nc.visitId = visitId
            sample_nc.sampleId = sampleId
        }
        if let navigationController = self.navigationController
        {
            if(!isComingFromModifyPage && isComingFromAttendanceDoctor)
            {
                //navigationController.popViewController(animated: false)
                navigationController.popViewController(animated: false)
                navigationController.pushViewController(sample_nc, animated: false)
            }
            else
            {
                navigationController.popViewController(animated: false)
                navigationController.pushViewController(sample_nc, animated: false)
            }
        }
    }
    
    
//    func addBackButtonView()
//    {
//        let backButton = UIBarButtonItem(image: UIImage(named: "navigation-arrow"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(SampleProductListViewController.backButtonClicked))
//        self.navigationItem.leftBarButtonItem = backButton
//    }
//    
//    @objc func backButtonClicked()
//    {
//        _ = navigationController?.popViewController(animated: false)
//    }
    
    func addBarButtonItem()
    {
        nextBtn = UIBarButtonItem(image: UIImage(named: "icon-done"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(SampleProductListViewController.nextScreenBtnAction))
    }
    
    func convertToDCRModel(list : NSMutableArray) -> [DCRSampleModel]
    {
        var userProductList : [UserProductMapping] = []
        for obj in list
        {
            userProductList.append(obj as! UserProductMapping)
        }
        return convertToDCRSampleModel(list: addTemporarySelectedCode(list: userProductList))
    }
    
//    func convertToDCRChemistSampleModel(list : NSMutableArray) -> [DCRChemistSamplePromotion]
//    {
//        var userProductList : [UserProductMapping] = []
//        for obj in list
//        {
//            userProductList.append(obj as! UserProductMapping)
//        }
//        return convertToDCRChemistSampleModel(list: addTemporarySelectedCode(list: userProductList))
//    }
//    func convertToDCRChemistSampleModel(list : [UserProductMapping]) -> [DCRChemistSamplePromotion]
//    {
//    
//            var sampleChemistProductList : [DCRChemistSamplePromotion] = []
//            for obj in list
//            {
//                 let dict: NSDictionary = ["DCR_Id": getDcrId(), "DCR_Code": getDcrCode(), "Visit_Id": doctorVisitId, "Product_Id":detailedProductObj.Detail_Product_Id, "Product_Code": detailedProductObj.Product_Code, "Product_Name": detailedProductObj.Product_Name]
//                let sampleObj : DCRChemistSamplePromotion = DCRChemistSamplePromotion(
//                sampleObj.ProductName = obj.Product_Name
//                sampleObj.ProductCode = obj.Product_Code
//                sampleObj.CurrentStock = obj.Current_Stock
//                sampleObj.QuantityProvided = 0
//                sampleObj.DivisionName = obj.Division_Name
//                sampleObj.ProductTypeName = obj.Product_Type_Name
//                sampleChemistProductList.append(sampleObj)
//            }
//
//        
//        return addDCRChemistSampleProducts(list:sampleChemistProductList)
//    }

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
            sampleObj.Quantity_Provided = 0
            sampleObj.Speciality_Code = obj.Speciality_Code
            sampleObj.DCR_Id = obj.dcrId
            sampleObj.DCR_Doctor_Visit_Id = obj.visitId
            sampleObj.DCR_Sample_Id = obj.sampleId
            sampleObjList.append(sampleObj)
        }
        
        for productObj in sampleObjList
        {
            let sampleObj : DCRSampleModel = DCRSampleModel(sampleObj: productObj)
            sampleProductList.append(sampleObj)
        }
        return addDCRSampleProducts(list:sampleProductList)
    }
    
    func addDCRSampleProducts(list : [DCRSampleModel]) -> [DCRSampleModel]
    {
        let userSelectedList = list
        for obj in userSelectedList
        {
            if(isComingFromChemistDay)
            {
                _ = userDCRChemistProductList.filter{
                    if $0.ProductCode == obj.sampleObj.Product_Code
                    {
                        obj.sampleObj.Quantity_Provided = $0.QuantityProvided
                    }
                    return true
                }
            }
            else if(isComingFromAttendanceDoctor)
            {
                _ = userDCRAttendenceProductList.filter{
                    if $0.Product_Code == obj.sampleObj.Product_Code
                    {
                        obj.sampleObj.Quantity_Provided = $0.Quantity_Provided
                    }
                    return true
                }
                
            }
            else
            {
            _ = userDCRProductList.filter {
                if $0.sampleObj.Product_Code == obj.sampleObj.Product_Code
                {
                    obj.sampleObj.Quantity_Provided = $0.sampleObj.Quantity_Provided
                }
                return true
            }
            }
        }
        return userSelectedList
    }
    
//    func addDCRChemistSampleProducts(list : [DCRChemistSamplePromotion]) -> [DCRChemistSamplePromotion]
//    {
//        let userSelectedList = list
//        for obj in userSelectedList
//        {
//            _ = userDCRChemistProductList.filter {
//                if $0.ProductCode == obj.ProductCode
//                {
//                    obj.QuantityProvided = $0.QuantityProvided
//                }
//                return true
//            }
//        }
//        return userSelectedList
//    }

    func addTemporarySelectedCode(list : [UserProductMapping]) -> [UserProductMapping]
    {
        var selectedList : [UserProductMapping] = list
  
        for obj in BL_SampleProducts.sharedInstance.getSelectedSampleProducts1(userSelectedCode: userSelectedProductCode, dateString: DCRModel.sharedInstance.dcrDateString,isComingFromChemistDay:isComingFromChemistDay,isComingFromAttendanceDoctor:isComingFromAttendanceDoctor, attendanceDoctorVisitId: attendanceDoctorVisitId)
        {
            selectedList.append(obj)
        }
        return selectedList
    }
    
    
}
