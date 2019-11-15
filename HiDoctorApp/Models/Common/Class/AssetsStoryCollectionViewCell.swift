//
//  AssetsStoryCollectionViewCell.swift
//  HiDoctorApp
//
//  Created by swaasuser on 28/06/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class AssetsStoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImg: UIImageView!
    @IBOutlet weak var assetNameLbl: UILabel!
    @IBOutlet weak var assetDescriptionLbl: UILabel!
    
    @IBOutlet weak var indexView: RoundedCornerRadiusView!
    
    @IBOutlet weak var indexLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        thumbnailImg.layer.borderWidth = 1
        thumbnailImg.layer.borderColor = UIColor.lightGray.cgColor
//        thumbnailImg.layer.cornerRadius = 10
//        thumbnailImg.clipsToBounds = true
    }
}

protocol StorySelectionDelegate
{
    func didSelectItemAtCollectionView(indexPath : IndexPath)
}


class AssetsStoryMainTableViewCell : UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var assetNameLbl : UILabel!
    @IBOutlet weak var assetCountLbl : UILabel!
    @IBOutlet weak var menuBtn: MyButton!
    
    @IBOutlet weak var targetLabel: UILabel!
    var assetList : [AssetHeader] = []
    var delegate : StorySelectionDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assetList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let assetObj = assetList[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionViewIdentifier.AssetsStoryCollectionCell, for: indexPath) as! AssetsStoryCollectionViewCell
        var thumnailImg : UIImage = BL_AssetModel.sharedInstance.getThumbnailImage(docType : assetObj.docType!)
        cell.assetNameLbl.text =  assetObj.daName!
        cell.indexLabel.text = "\(assetObj.displayIndex)"
        var downloadedStatus : String = EMPTY
        let localUrl = checkNullAndNilValueForString(stringData:  assetObj.localUrl)
        
        if localUrl != EMPTY
        {
            downloadedStatus = BL_AssetModel.sharedInstance.getDownloadStatus(isDownloaded:2)
            let localThumbnailUrl = BL_AssetDownloadOperation.sharedInstance.getAssetThumbnailURL(model :assetObj)
            if localThumbnailUrl != EMPTY
            {
                thumnailImg = UIImage(contentsOfFile: localThumbnailUrl)!
            }
        }
        else
        {
            downloadedStatus = BL_AssetModel.sharedInstance.getDownloadStatus(isDownloaded: assetObj.isDownloaded!)
        }
        
        let thumbanailUrl = checkNullAndNilValueForString(stringData: assetObj.thumbnailUrl)
        let image = BL_AssetModel.sharedInstance.thumbailImage[thumbanailUrl]
        if  thumbanailUrl != EMPTY && image != nil
        {
            thumnailImg = image!
        }
        else
        {
            getThumbnailImageForUrl(imageUrl: thumbanailUrl, indexPath: indexPath)
        }
        
        cell.thumbnailImg.image = thumnailImg
        let size = (assetObj.Total_Measure ?? "0") + " " + assetObj.Measured_Unit
        cell.assetDescriptionLbl.text = "\(String(format: "%.2f", assetObj.daSize)) MB | \(getDocTypeVal(docType : assetObj.docType)) | \(size) | \(downloadedStatus)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        return CGSize(width: 185, height: 138)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tag", collectionView.tag , indexPath.row)
        delegate.didSelectItemAtCollectionView(indexPath: IndexPath(row: indexPath.row, section: collectionView.tag))
    }
    
    
    private func getThumbnailImageForUrl(imageUrl : String,indexPath : IndexPath)
    {
        if imageUrl != EMPTY
        {
            ImageLoader.sharedLoader.imageForUrl(urlString: imageUrl) { (image) in
                if image != nil
                {
                    BL_AssetModel.sharedInstance.thumbailImage[imageUrl] = image
                    DispatchQueue.main.async {
                        self.reloadTableViewAtSpecificIndex(indexPath: indexPath)
                    }
                }
            }
        }
    }
    
    private func reloadTableViewAtSpecificIndex(indexPath: IndexPath)
    {
        self.collectionView.reloadItems(at: [indexPath])
    }

}
