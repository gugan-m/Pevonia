//
//  SampleDetailsViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 19/11/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

class SampleDetailsViewController: UIViewController , UITableViewDataSource, UITableViewDelegate
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
    var sampleBatchList : [SampleBatchProductModel] = []
    var dcrId = Int()
    var visitId = Int()
    var sampleId = Int()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationItem.title = "Samples/Input..."
        self.addBackButtonView()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
//        if(isComingFromAttendanceDoctor && isComingFromModifyPage)
//        {
//           changeCurrentList(list: sampleBatchList)
//        }
//        else
//        {
        let sampleBatchList = BL_SampleProducts.sharedInstance.convertToSampleBatchModel(selectedList: currentList,isComingFromModifyPage:isComingFromModifyPage, dcrId: dcrId,visitId:visitId,sampleId: sampleId)
            changeCurrentList(list: sampleBatchList)
     //   }
        
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
    
        let getPoint = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: getPoint)
        let productDetail = self.sampleBatchList[(indexPath?.section)!].sampleList[(indexPath?.row)!]
        if(self.sampleBatchList[(indexPath?.section)!].isShowSection)
        {
//            if productDetail.sampleObj.Quantity_Provided <  productDetail.sampleObj.Batch_Current_Stock
//            {
                productDetail.sampleObj.Quantity_Provided! += 1
                self.tableView.reloadData()
//            }
//            else
//            {
//                showToastView(toastText: "Entered quantity cannot be greater than available units")
//            }
        }
        else
        {
//            if productDetail.sampleObj.Quantity_Provided <  productDetail.sampleObj.Current_Stock
//            {
                productDetail.sampleObj.Quantity_Provided! += 1
                self.tableView.reloadData()
//            }
//            else
//            {
//                showToastView(toastText: "Entered quantity cannot be greater than available units")
//            }
        }
    }
    
    
    @IBAction func stepDownBtnAction(_ sender: UIButton)
    {
        let getPoint = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: getPoint)
        let productDetail = self.sampleBatchList[(indexPath?.section)!].sampleList[(indexPath?.row)!]
        if productDetail.sampleObj.Quantity_Provided > 0
        {
            productDetail.sampleObj.Quantity_Provided! -= 1
            self.tableView.reloadData()
        }
  
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleBatchList[section].sampleList.count
            //currentList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sampleBatchList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let productDetail = sampleBatchList[indexPath.section].sampleList[indexPath.row]
        var rowHeight : CGFloat = 60
        let productNameTextHeight = getTextSize(text: productDetail.sampleObj.Product_Name, fontName: fontRegular, fontSize: 16, constrainedWidth: SCREEN_WIDTH - 73).height
        rowHeight += productNameTextHeight
        
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: SampleDCRListCell, for: indexPath) as! SampleDCRListTableViewCell
        
        let productDetail = sampleBatchList[indexPath.section].sampleList[indexPath.row]
        var productCount : String = "0"
        var productName  = String()
        if(sampleBatchList[indexPath.section].isShowSection)
        {
            productName  = productDetail.sampleObj.Batch_Name as
            String
        }
        else
        {
            productName  = productDetail.sampleObj.Product_Name as String
        }
        if productDetail.sampleObj.Current_Stock != nil
        {
            if(sampleBatchList[indexPath.section].isShowSection)
            {
                productCount = String(productDetail.sampleObj.Batch_Current_Stock) as String
            }
            else
            {
                productCount = String(productDetail.sampleObj.Current_Stock) as String
            }
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
        if indexPath.row == sampleBatchList[indexPath.section].sampleList.count - 1
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
        
        if sampleBatchList[indexPath.section].sampleList.count == 1
        {
            cell.sepViewHeightConst.constant = 0
        }
        else
        {
            cell.sepViewHeightConst.constant = 1
        }
         cell.productCountLbl.isHidden = true
        cell.upButton.tintColor = UIColor.black
        cell.downButton.tintColor = UIColor.black
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sampleBatchList[section].title
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 40
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
    func sampleDCRProductsMinMaxValidation(sampleProductList : [SampleBatchProductModel])  -> Bool
    {
        var dcrSampleProductList : [DCRSampleModel] = []
        var dcrSampleBatchProductList : [DCRSampleModel] = []
        var resultList: [String] = []
        for sampleBatchObj in sampleProductList
        {
            if(sampleBatchObj.isShowSection)
            {
                for obj in sampleBatchObj.sampleList
                {
                    dcrSampleBatchProductList.append(obj)
                }
            }
            else
            {
                for obj in sampleBatchObj.sampleList
                {
                    dcrSampleProductList.append(obj)
                }
            }
            
        }
        
        for obj in dcrSampleBatchProductList
        {
            let filteredArray = resultList.filter{
                $0 == obj.sampleObj.Product_Code
            }
            
            if (filteredArray.count == 0)
            {
                var qtyProvided: Int = 0
                
                let batchFilter = dcrSampleBatchProductList.filter{
                    $0.sampleObj.Product_Code == obj.sampleObj.Product_Code
                }
                
                for objBatch in batchFilter
                {
                    qtyProvided += objBatch.sampleObj.Quantity_Provided
                }
                resultList.append(obj.sampleObj.Product_Code)
                let sampleMinMaxValue = DBHelper.sharedInstance.getUserProductMinMaxCount(productCode: obj.sampleObj.Product_Code)
                
                if(sampleMinMaxValue.Min_Count > 0)
                {
                    if(qtyProvided < sampleMinMaxValue.Min_Count)
                    {
                        AlertView.showAlertView(title: alertTitle, message: "Please provide minimum \(sampleMinMaxValue.Min_Count!) for product \(obj.sampleObj.Product_Name!)", viewController: self)
                        return false
                    }
                }
                
                if(sampleMinMaxValue.Max_Count > 0)
                {
                    if(qtyProvided > sampleMinMaxValue.Max_Count)
                    {
                         AlertView.showAlertView(title: alertTitle, message: "You can Provide Maximum \(sampleMinMaxValue.Max_Count!) for product \(obj.sampleObj.Product_Name!)", viewController: self)
                        return false
                    }
                }
                
            }
        }
        
        for obj in dcrSampleProductList
        {
            let filteredArray = resultList.filter{
                $0 == obj.sampleObj.Product_Code
            }
            if(filteredArray.count == 0)
            {
                resultList.append(obj.sampleObj.Product_Code)
                let sampleMinMaxValue = DBHelper.sharedInstance.getUserProductMinMaxCount(productCode: obj.sampleObj.Product_Code)
                
                if(sampleMinMaxValue.Min_Count > 0)
                {
                    if(obj.sampleObj.Quantity_Provided < sampleMinMaxValue.Min_Count)
                    {
                        AlertView.showAlertView(title: alertTitle, message: "Please provide minimum \(sampleMinMaxValue.Min_Count!) for product \(obj.sampleObj.Product_Name!)", viewController: self)
                        return false
                    }
                }
                if(sampleMinMaxValue.Max_Count > 0)
                {
                    if(obj.sampleObj.Quantity_Provided > sampleMinMaxValue.Max_Count)
                    {
                        AlertView.showAlertView(title: alertTitle, message: "You can provide maximum \(sampleMinMaxValue.Max_Count!) for product \(obj.sampleObj.Product_Name!)", viewController: self)
                        return false
                    }
                }
                
                
            }
        }

        return true
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
        else if isComingFromChemistDay
        {
            let minMaxValidation = sampleDCRProductsMinMaxValidation(sampleProductList:sampleBatchList)
            if minMaxValidation
            {
                BL_SampleProducts.sharedInstance.saveDoctorSampleDCRProducts(sampleProductList: sampleBatchList,isFrom:sampleBatchEntity.Chemist.rawValue,doctorVisitId: 0)
            }
            //  BL_SampleProducts.sharedInstance.saveSampleDCRChemistProducts(sampleProductList: currentList, dcrSampleBatchProductList: <#[DCRSampleModel]#>)
        }
        else if(isComingFromAttendanceDoctor && isComingFromModifyPage)
        {
            if(currentList.count > 0)
            {
                let minMaxValidation = sampleDCRProductsMinMaxValidation(sampleProductList:sampleBatchList)
                if minMaxValidation
                {
                    BL_SampleProducts.sharedInstance.saveDoctorSampleDCRProducts(sampleProductList: sampleBatchList,isFrom:sampleBatchEntity.Attendance.rawValue,doctorVisitId: DCRModel.sharedInstance.doctorVisitId)
                }
            }
            else
            {
                let minMaxValidation = sampleDCRProductsMinMaxValidation(sampleProductList:sampleBatchList)
                if minMaxValidation
                {
                    BL_DCR_Attendance.sharedInstance.deleteDCRAttendanceDoctorSample(doctorVisitId: DCRModel.sharedInstance.doctorVisitId)
                }
            }
        }
        else if(isComingFromAttendanceDoctor)
        {
            let minMaxValidation = sampleDCRProductsMinMaxValidation(sampleProductList:sampleBatchList)
            if minMaxValidation
            {
                BL_SampleProducts.sharedInstance.saveDoctorSampleDCRProducts(sampleProductList: sampleBatchList,isFrom:sampleBatchEntity.Attendance.rawValue,doctorVisitId: DCRModel.sharedInstance.doctorVisitId)
            }
        }
        else
        {
//            let minMaxValidation = sampleDCRProductsMinMaxValidation(sampleProductList:sampleBatchList)
//            if minMaxValidation
//            {
            
            var samplelistnewbatch : [SampleBatchProductModel] = []
            for i in sampleBatchList
            {
                samplelistnewbatch.append(i)
            }
            var sampleListnew1 : [DCRSampleModel] = []
            //samplelistnewbatch[0].sampleList.removeAll()
            for i in 0..<sampleBatchList[0].sampleList.count
                {
                    if (sampleBatchList[0].sampleList[i].sampleObj.Quantity_Provided > 0)
                    {
                        sampleListnew1.append(sampleBatchList[0].sampleList[i])
                    }
                }
            samplelistnewbatch[0].sampleList.removeAll()
            samplelistnewbatch[0].sampleList = sampleListnew1
                BL_SampleProducts.sharedInstance.saveDoctorSampleDCRProducts(sampleProductList: samplelistnewbatch,isFrom:sampleBatchEntity.Doctor.rawValue,doctorVisitId: 0)
            //}
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
            sample_nc.attendanceDoctorVisitId = DCRModel.sharedInstance.doctorVisitId
            if(sampleBatchList.count > 0)
            {
                if(sampleBatchList[0].sampleList.count > 0)
                {
                    sample_nc.dcrId = sampleBatchList[0].sampleList[0].sampleObj.DCR_Id
                    sample_nc.visitId = sampleBatchList[0].sampleList[0].sampleObj.DCR_Doctor_Visit_Id
                    sample_nc.sampleId = sampleBatchList[0].sampleList[0].sampleObj.DCR_Sample_Id
                }
                else
                {
                    sample_nc.dcrId = 0
                    sample_nc.visitId = 0
                    sample_nc.sampleId = 0
                }
            }
            
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
        sample_nc.doctorVisitId = DCRModel.sharedInstance.doctorVisitId
        
        
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
    
    func changeCurrentList(list : [SampleBatchProductModel])
    {
        if list.count > 0
        {
            
            if isComingFromModifyPage
            {
               sampleBatchList = updateCurrentStockValue(list: list)
            }
            else
            {
                sampleBatchList = list
            }
           
            self.tableView.reloadData()
            self.showEmptyStateView(show: false)
        }
        else
        {
            self.showEmptyStateView(show: true)
        }
    }
    
    func updateCurrentStockValue(list:[SampleBatchProductModel]) ->[SampleBatchProductModel]
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
        let sampleBatchList = BL_SampleProducts.sharedInstance.getSampleBatchProducts(date: dateString)
        
        for obj in userProductList
        {
            for batchObj in userSelectedList
            {
                if(!batchObj.isShowSection)
                {
                    _ = batchObj.sampleList.filter{
                        if $0.sampleObj.Product_Code == obj.Product_Code
                        {
                            $0.sampleObj.Current_Stock = $0.sampleObj.Quantity_Provided + obj.Current_Stock
                        }
                        return true
                    }
                }
            }
            
        }
        
        for obj in sampleBatchList
        {
            for batchObj in userSelectedList
            {
                if(batchObj.isShowSection)
                {
                    _ = batchObj.sampleList.filter{
                        if $0.sampleObj.Product_Code == obj.Product_Code
                        {
                            $0.sampleObj.Current_Stock = $0.sampleObj.Quantity_Provided + obj.Batch_Current_Stock
                        }
                        return true
                    }
                }
            }
        }
        
        return userSelectedList
        
    }
//    func updateCurrentStockValue(list : [DCRSampleModel]) ->  [DCRSampleModel]
//    {
//        let userSelectedList = list
//        var dateString = String()
//        if(isComingFromTpPage)
//        {
//          dateString = TPModel.sharedInstance.tpDateString
//        }
//        else
//        {
//            dateString = DCRModel.sharedInstance.dcrDateString
//        }
//        let userProductList = BL_SampleProducts.sharedInstance.getUserProducts(dateString: dateString)
//
//        for obj in userProductList
//        {
//            _ = userSelectedList.filter {
//                if $0.sampleObj.Product_Code == obj.Product_Code
//                {
//                    $0.sampleObj.Current_Stock = $0.sampleObj.Quantity_Provided + obj.Current_Stock
//                }
//                return true
//            }
//        }
//        return userSelectedList
//    }
    
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
