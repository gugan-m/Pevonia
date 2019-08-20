    //
    //  EDetailedProductsViewController.swift
    //  HiDoctorApp
    //
    //  Created by swaasuser on 16/10/17.
    //  Copyright © 2017 swaas. All rights reserved.
    //

    import UIKit

    class EDetailedProductsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
        
        //MARK:- IBOutlet
        @IBOutlet weak var messageLbl: UILabel!
        @IBOutlet weak var tableView: UITableView!
        
        //MARK:- Variable
        var currentList : [DetailProductMaster] = []
        var selectedList : NSMutableArray = []
        var selectedTitle : String = ""
        var userSelectedProduct : [String] = []
        var isComingFromModifyPage : Bool = false
        var detailedList : [DetailProductMaster] = []
        
        override func viewDidLoad() {
            super.viewDidLoad()
            tableView.dataSource = self
            tableView.delegate = self
            addBackButtonView()
            // Do any additional setup after loading the view.
        }
        override func viewWillAppear(_ animated: Bool) {
            self.getDCRSelectedList()
            
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return currentList.count
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            let defaultHeight : CGFloat = 40
            let sampleObj = currentList[indexPath.row]
            
            let nameLblHgt = getTextSize(text: sampleObj.Product_Name, fontName: fontSemiBold, fontSize: 14, constrainedWidth: SCREEN_WIDTH - 65).height
            return defaultHeight + nameLblHgt
        }
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let detailProductCell = tableView.dequeueReusableCell(withIdentifier: detailProductListCell, for: indexPath) as! DetailedProductsTableViewCell
            let detailObj = currentList[indexPath.row]
            let productName = detailObj.Product_Name as String
            detailProductCell.DetailProductNameLbl.text = productName
            detailProductCell.selectedImgConst.constant = 25
            if userSelectedProduct.contains(detailObj.Product_Code) && !isComingFromModifyPage
            {
                detailProductCell.contentView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
                detailProductCell.DetailProductNameImg.image = UIImage(named: "icon-selected")
            }
            else if selectedList.contains(detailObj)
            {
                detailProductCell.DetailProductNameImg.image = UIImage(named: "icon-tick")
            }
            else
            {
                detailProductCell.DetailProductNameImg.image = UIImage(named: "icon-unselected")
                detailProductCell.contentView.backgroundColor = UIColor.white
            }
            
            return detailProductCell
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        {
            let detailObj = currentList[indexPath.row]
            if !userSelectedProduct.contains(detailObj.Product_Code)
            {
                if selectedList.contains(detailObj)
                {
                    selectedList.remove(detailObj)
                    selectedTitle = String(Int(selectedTitle)! - 1)
                }
                else
                {
                    self.selectedList.add(detailObj)
                    selectedTitle = String(Int(selectedTitle)! + 1)
                }
            }
            setNavigationTitle(Num : selectedTitle)
            self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
        }
        
        @IBAction func doneAction(_ sender: Any)
        {
            let selectedProductList = convertToDetailMaster(list: selectedList)
            BL_DetailedProducts.sharedInstance.insertDetailedProducts(detailedProductList:selectedProductList, doctorVisitId: DCRModel.sharedInstance.doctorVisitId)
        }
        func convertToDetailMaster(list : NSMutableArray) -> [DetailProductMaster]
        {
            var selectedProductList : [DetailProductMaster] = []
            if list.count > 0
            {
                for obj in list
                {
                    selectedProductList.append(obj as! DetailProductMaster)
                }
            }
            return selectedProductList
        }
        
        private func addCustomBackButtonToNavigationBar()
        {
            let backButton = UIButton(type: UIButtonType.custom)
            
            backButton.addTarget(self, action: #selector(self.backButtonClicked), for: UIControlEvents.touchUpInside)
            backButton.setImage(UIImage(named: "navigation-arrow"), for: .normal)
            backButton.sizeToFit()
            
            let leftBarButtonItem = UIBarButtonItem(customView: backButton)
            
            self.navigationItem.leftBarButtonItem = leftBarButtonItem
        }
        
        @objc func backButtonClicked()
        {
            _ = navigationController?.popViewController(animated: false)
        }
        func getDCRSelectedList()
        {
            let dcrSelectedList = BL_DetailedProducts.sharedInstance.getDCRDetailedProducts(dcrId: DCRModel.sharedInstance.dcrId, doctorVisitId: DCRModel.sharedInstance.doctorVisitId)
            
            for obj in dcrSelectedList
            {
                selectedList.add(obj)
            }
            
            selectedTitle = String(dcrSelectedList.count)
            changeCurrentList(list: dcrSelectedList)
            setNavigationTitle(Num : selectedTitle)
            
        }
        //        func getDetailedList()
        //        {
        //            if !isComingFromModifyPage {
        //                detailedList = BL_DetailedProducts.getMasterDetailedProducts()
        //                changeCurrentList(list: detailedList)
        //            }
        //        }
        func changeCurrentList(list : [DetailProductMaster])
        {
            if list.count > 0
            {
                self.currentList = list
                self.tableView.reloadData()
            }
        }
        
        
        func setNavigationTitle(Num : String)
        {
            if Num == "0"{
                self.navigationItem.title = "Detail Products List"
            }else{
                self.navigationItem.title = Num + " Selected"
            }
            
        }
        
        
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destinationViewController.
         // Pass the selected object to the new view controller.
         }
         */
        
    }
