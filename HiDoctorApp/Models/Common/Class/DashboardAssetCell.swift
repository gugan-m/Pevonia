//
//  DashboardAssetCell.swift
//  HiDoctorApp
//
//  Created by Vijay on 09/06/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class DashboardAssetCell: UITableViewCell {

    @IBOutlet weak var assetName: UILabel!
    @IBOutlet weak var assetSize: UILabel!
    @IBOutlet weak var assetDate: UILabel!
    
    @IBOutlet weak var thumbnailImgVw: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class TopAssetTableviewCell: UITableViewCell{
    
    @IBOutlet weak var initialLabel: UILabel!
    
    @IBOutlet weak var doctorNameLabel: UILabel!
    
    @IBOutlet weak var specialistLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    override func awakeFromNib() {
        initialLabel.layer.cornerRadius = initialLabel.frame.height/2
        initialLabel.layer.masksToBounds = true
    }
    
}

class TopDoctorTableviewCell: UITableViewCell{
    @IBOutlet weak var profilePicImgVw: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var specialistLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var viewBtn: UIButton!
    
    @IBOutlet  weak var collectionView: UICollectionView!
    
    @IBOutlet weak var indexLabel: UILabel!
    var timer : Timer?
    
    override func awakeFromNib() {
        profilePicImgVw.layer.cornerRadius = profilePicImgVw.frame.height/2
        profilePicImgVw.clipsToBounds = true
    }
    
    
}

extension TopDoctorTableviewCell{
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        
        collectionView.register(UINib.init(nibName: "TopDoctorCollectionviewCell", bundle: nil), forCellWithReuseIdentifier: "TopDoctorCollectionviewCell")
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.setContentOffset(collectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        collectionView.reloadData()
        
     
    }
    
    var collectionViewOffset: CGFloat {
        set { collectionView.contentOffset.x = newValue }
        get { return collectionView.contentOffset.x }
    }
    
    func willDisplayCell(){
//        timer?.invalidate()
//         timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.targetMethod), userInfo: nil, repeats: true)
    }
    
    func didEndDisplayCell(){
//        timer?.invalidate()
    }

    func targetMethod ()
    {
        
        let count = collectionView.numberOfItems(inSection: 0)
        let indexpath = collectionView.indexPathsForVisibleItems
        let lastIndexpath = indexpath.last
        if lastIndexpath != nil && (lastIndexpath?.row)! + 1 < count - 1{
        let nextIndexpath = IndexPath(row: (lastIndexpath?.row)! + 1, section: 0)
            DispatchQueue.main.async {
        self.collectionView.scrollToItem(at: nextIndexpath, at: .centeredHorizontally, animated: true)
                print("coll", self.collectionView.tag)
            }
        }

    }
}

class TopDoctorCollectionviewCell: UICollectionViewCell{
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var imgVw: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
//        imgVw.layer.cornerRadius = 10
//        imgVw.layer.masksToBounds = true
        

    }
    
    override func layoutSubviews() {
//        setCornerRadius(view: descriptionLabel, corners: [.bottomLeft, . bottomRight])
    }
    
}
