//
//  TopAssetViewController.swift
//  HiDoctorApp
//
//  Created by Admin on 6/30/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class TopAssetViewController: UIViewController , CardStackViewDataSource, CardStackViewDelegate , UITableViewDelegate , UITableViewDataSource{
    
    
    @IBOutlet weak var cardView: UIView!
    
    var orderNo: Int = 0
    
    @IBOutlet weak var emptyStateView: UIView!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var cardStackView: CardStackView!
    
    @IBOutlet weak var subtitleText: UILabel!
    
    @IBOutlet weak var swipeHintLbl: UILabel!
    
    var currentCard = CardView()
    var cardlist = [CardView]()
    var speed = 0.2
    var didShowAnimation = true
    var topAssetList = [DashboardTopAssets]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doInitialSetup()
      
    }
    
    func doInitialSetup()  {
        cardStackView.register(nib: UINib(nibName: "MyCard", bundle: nil))
        cardStackView.dataSource = self
        cardStackView.delegate = self
        showMainView()
        getAssetandDoctorServiceCall()
        self.navigationItem.title = "Top 10 Asset's"
        subtitleText.text = "Top \(appDoctorPlural)"
        addCustomBackButtonToNavigationBar()
        swipeHintLbl.isHidden = true
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
    
    
    @objc func backButtonClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    private func showMainView()
    {
        mainView.isHidden = false
        emptyStateView.isHidden = true
    }
    
    private func showEmptyStateView(emptyStateText: String)
    {
        mainView.isHidden = true
        emptyStateView.isHidden = false
        emptyStateLabel.text = emptyStateText
    }
    
    func nextCard(in: CardStackView) -> CardView? {
        
        orderNo += 1
        if orderNo ==  cardlist.count {
            orderNo = 0
        }
        countLabel.text = "\(orderNo + 1)/\(topAssetList.count)"
        
        let card = cardlist[orderNo ]
        currentCard = card
        didShowAnimation = true
        tableView.reloadData()
        if topAssetList.count > 0{
            if topAssetList[orderNo].Doctor_List.count > 0{
                tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
        }
        return card
    }
    
    func previousCard(in: CardStackView) -> CardView? {
        
        orderNo -= 1
        if orderNo <  0 {
            orderNo = topAssetList.count - 1
            
        }
        countLabel.text = "\(orderNo + 1)/\(topAssetList.count)"
        let card = cardlist[orderNo ]
        currentCard = card
        didShowAnimation = true
        tableView.reloadData()
        if topAssetList.count > 0{
            if topAssetList[orderNo].Doctor_List.count > 0{
                tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
        }

        return card
    }
    
    
    func getAssetandDoctorServiceCall()
    {
        if checkInternetConnectivity()
        {
            showCustomActivityIndicatorView(loadingText: "Loading..")
            BL_DashboardAsset.sharedInstance.getTopAssetData(completion: { (topAssetList, errorMsg) in
                
                print(topAssetList, "topAssetList")
                self.topAssetList = topAssetList
                removeCustomActivityView()
                if errorMsg == ""{
                    if topAssetList.count > 0
                    {
                        var i = 0
                        for _ in topAssetList{
                            self.createCard(order: i)
                            i += 1
                        }
                self.countLabel.text = "1/\(topAssetList.count)"
                self.cardStackView.reloadData()
                self.tableView.reloadData()
                self.showMainView()
                self.swipeHintLbl.isHidden = false
                    }
                else
                {
                    self.showEmptyStateView(emptyStateText:assetsEmptyMsg )
                    }}
                else
                {
                self.showEmptyStateView(emptyStateText: errorMsg)
            }
            
            })
        }else{
            showEmptyStateView(emptyStateText: internetOfflineMessage)
        }
    }
    
    func cardStackView(_ cardStackView: CardStackView, cardAt index: Int) -> CardView {
        
        return cardlist[index]
    }
    
    func numOfCardInStackView(_ cardStackView: CardStackView) -> Int {
        return cardlist.count
    }
    
    public func cardStackView(_: CardStackView, didSelect card: CardView) {
        if card is MyCard {
            
            
        }
    }
    
    func createCard(order: Int) {
        let card = cardStackView.dequeueCardView() as! MyCard
        let topAsset = topAssetList[order]
        
        if topAsset.Asset_Thumbnail != EMPTY
        {
            ImageLoader.sharedLoader.imageForUrl(urlString: topAsset.Asset_Thumbnail) { (image) in
                if image != nil
                {
                    DispatchQueue.main.async {
                        card.imageView?.image = image
                        card.imageView.contentMode = .scaleToFill
                    }
                }else{
                    card.imageView.image = BL_AssetModel.sharedInstance.getThumbnailImage(docType: topAsset.Asset_Type)
                     card.imageView.contentMode = .center
                }
            }
        }else{
            card.imageView.image = BL_AssetModel.sharedInstance.getThumbnailImage(docType: topAsset.Asset_Type)
            card.imageView.contentMode = .center

        }
        card.titleLabel?.text = topAsset.Asset_Name
        card.subtitleLabel.text = "\(getDocTypeVal(docType: topAsset.Asset_Type)) | \(String(topAsset.Asset_Size!)) MB"
        card.batchLabel.text = "\(order + 1)"
        card.borderWidth = 1.0
        card.borderColor = UIColor.lightGray
        card.isShadowed = true
        card.index = order
        cardlist.append(card)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if topAssetList.count > 0{
        return topAssetList[orderNo].Doctor_List.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopAssetTableviewCell")! as! TopAssetTableviewCell
        
        let doctor = topAssetList[orderNo].Doctor_List[indexPath.row]
        cell.doctorNameLabel.text = doctor.Doctor_Name
        if  doctor.Doctor_Name.count > 0{
        let initial = doctor.Doctor_Name.first
            cell.initialLabel.text = "\(initial!)"
        }
        cell.durationLabel.text = getPlayTime(timeVal: "\(doctor.Duration!)")
        cell.specialistLabel.text = "\(doctor.Doctor_Speciality!) | \(doctor.Category_Name!)"
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if didShowAnimation{
            let transition = CATransition()
            transition.duration = speed
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            cell.layer.add(transition, forKey: kCATransition)
            speed += 0.1
        }
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        speed = 0.2
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didShowAnimation = false
    }
    
}





