//
//  TPSampleDetailsViewController.swift
//  HiDoctorApp
//
//  Created by Swaas on 18/08/18.
//  Copyright © 2018 swaas. All rights reserved.
//

import UIKit

class TPSampleDetailsViewController: UIViewController , UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tableView : UITableView!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var emptyStateView: UIView!
    
    var userSelectedProductList : [UserProductMapping] = []
    var selectedDCRList : [DCRSampleModel] = []
    var userSelectedProductCode : [String] = []
    var currentList :[DCRSampleModel] = []
    var isComingFromDeletePage : Bool = false
    var isComingFromModifyPage : Bool = false
    var isComingFromTpPage = false
    var isComingFromChemistDay : Bool = false
    var isComingFromAttendanceDoctor : Bool = false
    var doctorVisitId = Int()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationItem.title = "Samples/Input..."
        self.addBackButtonView()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        changeCurrentList(list: currentList)
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
    }
    
    override func viewDidLayoutSubviews()
    {
        self.tableView.layoutIfNeeded()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func stepUpBtnAction(_ sender: UIButton)
    {
        let productDetail = currentList[sender.tag]
        if productDetail.sampleObj.Quantity_Provided <  productDetail.sampleObj.Current_Stock
        {
            productDetail.sampleObj.Quantity_Provided! += 1
            self.tableView.reloadData()
        }
        else
        {
            showToastView(toastText: "Entered quantity cannot be greater than available units")
        }
    }
    
    @IBAction func stepDownBtnAction(_ sender: UIButton)
    {
        let productDetail = currentList[sender.tag]
        if productDetail.sampleObj.Quantity_Provided > 0
        {
            productDetail.sampleObj.Quantity_Provided! -= 1
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let productDetail = currentList[indexPath.row]
        var rowHeight : CGFloat = 60
        let productNameTextHeight = getTextSize(text: productDetail.sampleObj.Product_Name, fontName: fontRegular, fontSize: 16, constrainedWidth: SCREEN_WIDTH - 73).height
        rowHeight += productNameTextHeight
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: SampleDCRListCell, for: indexPath) as! SampleDCRListTableViewCell
        let productDetail = currentList[indexPath.row]
        var productCount : String = "0"
        let productName  = productDetail.sampleObj.Product_Name as String
        if productDetail.sampleObj.Current_Stock != nil
        {
            productCount = String(productDetail.sampleObj.Current_Stock) as String
        }
        cell.productNameLbl.text = productName
        cell.productCountLbl.text = "Available Units:\(productCount) nos"
        cell.downButton.tag = indexPath.row
        cell.upButton.tag = indexPath.row
        cell.downButton.tag = indexPath.row
        cell.upButton.tag = indexPath.row
        
        if indexPath.row == 0
        {
            let rectShape = CAShapeLayer()
            rectShape.path = UIBezierPath(roundedRect: cell.outerView.bounds, byRoundingCorners: [.topLeft,.topRight] ,cornerRadii: CGSize(width: 3, height: 3)).cgPath
            cell.outerView.layer.mask = rectShape
            cell.outerView.layer.masksToBounds = true
        }
        if indexPath.row == currentList.count - 1
        {
            let rectShape = CAShapeLayer()
            rectShape.path = UIBezierPath(roundedRect: cell.outerView.bounds, byRoundingCorners: [.bottomLeft ,.bottomRight] ,cornerRadii: CGSize(width: 3, height: 3)).cgPath
            cell.outerView.layer.mask = rectShape
            cell.outerView.layer.masksToBounds = true
        }
        
        if productDetail.sampleObj.Quantity_Provided != nil
        {
            cell.countLabel.text = String(productDetail.sampleObj.Quantity_Provided)
        }
        else
        {
            productDetail.sampleObj.Quantity_Provided = 0
        }
        
        if currentList.count == 1
        {
            cell.sepViewHeightConst.constant = 0
        }
        else
        {
            cell.sepViewHeightConst.constant = 1
        }
        return cell
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
            sampleObjList.append(sampleObj)
        }
        
        for productObj in sampleObjList
        {
            let sampleObj : DCRSampleModel = DCRSampleModel(sampleObj: productObj)
            sampleProductList.append(sampleObj)
        }
        return sampleProductList
    }
    //    func convertDoctorSampleToCHemistSample(list :[DCRSampleModel]) -> [DCRChemistSamplePromotion]
    //    {
    //        var sampleChemistProductList : [DCRChemistSamplePromotion] = []
    //        for obj in list
    //        {
    //            let sampleObj : DCRChemistSamplePromotion = DCRChemistSamplePromotion()
    //            sampleObj.ProductName = obj.sampleObj.Product_Name
    //            sampleObj.pro
    //
    //        }
    //
    //    }
    @IBAction func saveBtnAction(_ sender: AnyObject)
    {
        if isComingFromTpPage
        {
            let doctorList = BL_TPStepper.sharedInstance.doctorList
            let doctorObj: StepperDoctorModel = doctorList[BL_TPStepper.sharedInstance.selectedDoctorIndex]
            BL_TPStepper.sharedInstance.insertSelectedSamples(doctorCode: doctorObj.Customer_Code, regionCode: doctorObj.Region_Code, lstDCRSamples: currentList)
        }
       
        
        _ = navigationController?.popViewController(animated: false)
    }
    
    @IBAction func addBtnAction(_ sender: AnyObject)
    {
        if isComingFromTpPage
        {
            let sample_sb = UIStoryboard(name: TPStepperSb, bundle: nil)
            let sample_nc = sample_sb.instantiateViewController(withIdentifier: TPSampleListVCID) as! TPSampleListViewController
            sample_nc.userSelectedProductCode = getSelctedProductList()
            sample_nc.isComingFromSampleDetail = true
            
            if let navigationController = self.navigationController
            {
                navigationController.popViewController(animated: false)
                navigationController.pushViewController(sample_nc, animated: false)
            }
        }
        else
        {
            let sample_sb = UIStoryboard(name: sampleProductListSb, bundle: nil)
            let sample_nc = sample_sb.instantiateViewController(withIdentifier: sampleProductListVcID) as! SampleProductListViewController
            sample_nc.userSelectedProductCode = getSelctedProductList()
            sample_nc.isComingFromSampleDetail = true
            sample_nc.isComingFromChemistDay = self.isComingFromChemistDay
            sample_nc.isComingFromModifyPage = isComingFromModifyPage
            sample_nc.isComingFromAttendanceDoctor = isComingFromAttendanceDoctor
            sample_nc.attendanceDoctorVisitId = doctorVisitId
            if let navigationController = self.navigationController
            {
                navigationController.popViewController(animated: false)
                navigationController.pushViewController(sample_nc, animated: false)
            }
        }
    }
    
    
    @IBAction func deleteBtnAction(_ sender: AnyObject)
    {
        let sample_sb = UIStoryboard(name: sampleProductListSb, bundle: nil)
        let sample_nc = sample_sb.instantiateViewController(withIdentifier:DeleteSampleVcID) as! DeleteSampleListViewController
        sample_nc.userDCRProductList = currentList
        sample_nc.isComingFromTP = self.isComingFromTpPage
        sample_nc.isComingFromChemistDay = self.isComingFromChemistDay
        sample_nc.iscomingFromModify = self.isComingFromModifyPage
        sample_nc.isComingFromAttendanceDoctor = isComingFromAttendanceDoctor
        sample_nc.doctorVisitId = doctorVisitId
        
        
        if let navigationController = self.navigationController
        {
            navigationController.popViewController(animated: false)
            navigationController.pushViewController(sample_nc, animated: false)
        }
    }
    
    func getSelctedProductList() -> [String]
    {
        //userSelectedProductCode = BL_SampleProducts.getSelectProductCode()
        for obj in currentList
        {
            userSelectedProductCode.append(obj.sampleObj.Product_Code)
        }
        
        return userSelectedProductCode
    }
    
    func changeCurrentList(list : [DCRSampleModel])
    {
        if list.count > 0
        {
            
            if isComingFromModifyPage
            {
                currentList = updateCurrentStockValue(list: list)
            }
            else
            {
                currentList = list
            }
            
            self.tableView.reloadData()
            self.showEmptyStateView(show: false)
        }
        else
        {
            self.showEmptyStateView(show: true)
        }
    }
    
    func updateCurrentStockValue(list : [DCRSampleModel]) ->  [DCRSampleModel]
    {
        let userSelectedList = list
        var dateString = String()
        if(isComingFromTpPage)
        {
            dateString = TPModel.sharedInstance.tpDateString
        }
        else
        {
            dateString = DCRModel.sharedInstance.dcrDateString
        }
        let userProductList = BL_SampleProducts.sharedInstance.getUserProducts(dateString: dateString)
        
        for obj in userProductList
        {
            _ = userSelectedList.filter {
                if $0.sampleObj.Product_Code == obj.Product_Code
                {
                    $0.sampleObj.Current_Stock = $0.sampleObj.Quantity_Provided + obj.Current_Stock
                }
                return true
            }
        }
        return userSelectedList
    }
    
    func showEmptyStateView(show : Bool)
    {
        self.emptyStateView.isHidden = !show
        self.contentView.isHidden = show
    }
    
    
    //    func addBackButtonView()
    //    {
    //        let backButton = UIBarButtonItem(image: UIImage(named: "navigation-arrow"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(SampleDetailsViewController.backButtonClicked))
    //        self.navigationItem.leftBarButtonItem = backButton
    //    }
    //
    //    @objc func backButtonClicked()
    //    {
    //        _ = navigationController?.popViewController(animated: false)
    //    }
}
