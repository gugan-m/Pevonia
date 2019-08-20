//
//  CompetitorProductListViewController.swift
//  HiDoctorApp
//
//  Created by swaasuser on 07/12/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit

protocol selectedCompetitorListDelgate
{
    func getSelectedCompetitorList(list : [CompetitorProductModel])
}
class CompetitorProductListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate
{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView : UIView!
    @IBOutlet weak var emptyStateView : UIView!
    @IBOutlet weak var searchBarHgtConst: NSLayoutConstraint!
    
    var isComingFromModifyPage : Bool = false
    var productList : [CompetitorProductModel] = []
    var currentList : [CompetitorProductModel] = []
    var searchList : [CompetitorProductModel] = []
    
    var delegate : selectedCompetitorListDelgate?
    var addBtn : UIBarButtonItem!
    var doneBtn : UIBarButtonItem!
    
    var selectedList : NSMutableArray = []
    var userSelectedProduct : [CompetitorProductModel] = []
    var userSelectedProductName : [String] = []
    var productCode : String = ""
    var selectedTitle : Int = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        addBackButtonView()
        self.addBarButtonItem()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.navigationItem.rightBarButtonItems = [addBtn]
        self.setUserSelectedProductName()
        self.addTapGestureForView()
        self.navigationItem.title = "Competitor Products"
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.getProductList()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
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
        
        let nameLblHgt = getTextSize(text: sampleObj.Competitor_Product_Name, fontName: fontSemiBold, fontSize: 14, constrainedWidth: SCREEN_WIDTH - 65).height
        return defaultHeight + nameLblHgt
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: competitorListCell, for: indexPath) as! DetailedProductsTableViewCell
        let detailObj = currentList[indexPath.row]
        let productName = detailObj.Competitor_Product_Name as String
        cell.DetailProductNameLbl.text = productName
        
        if userSelectedProductName.contains(detailObj.Competitor_Product_Name)
        {
            cell.contentView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
            cell.DetailProductNameImg.image = UIImage(named: "icon-selected")
        }
        else if selectedList.contains(detailObj)
        {
            cell.DetailProductNameImg.image = UIImage(named: "icon-tick")
        }
        else
        {
            cell.DetailProductNameImg.image = UIImage(named: "icon-unselected")
            cell.contentView.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let detailObj = currentList[indexPath.row]
        if !userSelectedProductName.contains(detailObj.Competitor_Product_Name)
        {
            if selectedList.contains(detailObj)
            {
                selectedList.remove(detailObj)
                selectedTitle = selectedTitle - 1
            }
            else
            {
                self.selectedList.add(detailObj)
                
                selectedTitle = selectedTitle + 1
            }
        }
        
        if selectedTitle != 0
        {
            self.navigationItem.rightBarButtonItems = [doneBtn,addBtn]
        }
        setNavigationTitle(Num : String(selectedTitle))
        self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
    }
    
    
    func changeCurrentList(list : [CompetitorProductModel])
    {
        if list.count > 0
        {
            self.currentList = list
            self.tableView.reloadData()
            showEmptyStateView(show: false)
        }
        else
        {
            showEmptyStateView(show: true)
        }
    }
    
    func showEmptyStateView(show : Bool)
    {
        self.emptyStateView.isHidden = !show
        self.contentView.isHidden = show
        
    }
    
    func getProductList()
    {
        
        productList = BL_DCR_Chemist_Visit.sharedInstance.getCompetitorProducts(ownProductCode: productCode)!
        self.setSearchBarHeight()
        changeCurrentList(list: productList)
    }
    
    func setSearchBarHeight()
    {
        if productList.count > 0
        {
            self.searchBarHgtConst.constant = 44
        }
        else
        {
            self.searchBarHgtConst.constant = 0
        }
    }
    
    //MARK:-Search Bar Delegate
    
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
        self.changeCurrentList(list: productList)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if (searchBar.text?.count)! > 0
        {
            sortCurrentList(searchText: searchBar.text!)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func sortCurrentList(searchText:String)
    {
        
        searchList = productList.filter { (obj) -> Bool in
            let lowerCaseText = searchText.lowercased()
            let detailName  = (obj.Competitor_Product_Name).lowercased()
            return detailName.contains(lowerCaseText)
        }
        self.changeCurrentList(list: searchList)
    }
    
    func setNavigationTitle(Num : String)
    {
        if Num == "0"{
            self.navigationItem.title = "Competitor Products"
        }else{
            self.navigationItem.title = Num + " Selected"
        }
        
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
    
    
    
    func addBarButtonItem()
    {
        addBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(self.addCompetitorProductBtnAction))
        doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneBtnAction))
    }
    
    @objc func addCompetitorProductBtnAction()
    {
        let sb = UIStoryboard(name: chemistsSb, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: AddCompetitorProductVcID) as! AddCompetitorProductViewController
        vc.competitorList = userSelectedProduct
        vc.productCode = productCode
      _ = navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func doneBtnAction()
    {
        var list : [CompetitorProductModel] = []
        
        list = userSelectedProduct
        for obj in selectedList
        {
            list.append(obj as! CompetitorProductModel)
        }
        
        delegate?.getSelectedCompetitorList(list: list)
        _ = navigationController?.popViewController(animated: false)
    }
    
    func setUserSelectedProductName()
    {
        for obj in userSelectedProduct
        {
            if obj.Competitor_Product_Name != nil
            {
                userSelectedProductName.append(obj.Competitor_Product_Name)
            }
        }
    }
    
    func addTapGestureForView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.resignResponserForSearchBar))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func resignResponserForSearchBar()
    {
        self.searchBar.resignFirstResponder()
    }
    
 }
