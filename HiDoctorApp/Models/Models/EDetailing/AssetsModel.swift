//
//  AssetsModel.swift
//  HiDoctorApp
//
//  Created by swaasuser on 18/05/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class AssetsModel: NSObject
{
    var assetsName : String!
    var assetType : Int!
    var totalPlayedDuration : String!
    var totalPagesViewed : String!
    var totalUniquePagesCount : String = "0"
}

class AssetsPlayListModel : NSObject
{
    var assetObj : AssetHeader!
    var assetPartList : [AssetParts]!
    var isStoryEnabled = false
    var storyObj : StoryHeader!
    var isFirstAssetInStory = false
}

class PlayerTableAssetModel : NSObject{
    var assetPlayObj = AssetsPlayListModel()
    var isStoryEnabled = false
    var storyObj : StoryHeader!
    var storyList = [AssetsPlayListModel]()

}

class AssetMandatoryListModel : NSObject
{
    var storyObj : StoryHeader!
    var isAssets : Bool!
    var assetList : [AssetHeader]!
}

class AssetsWrapperModel : NSObject
{
    var assetTag : String!
    var assetList : [AssetHeader] = []
}

class CustomerModel : NSObject
{
    static let sharedInstance = CustomerModel()
    
    var regionCode : String!
    var navTitle: String!
    var userCode: String!
}

class AssetsMenuModel : NSObject
{
    var menuName : String!
    var menuLeftIcon : String!
    var menuRightIcon : String!
    var menuId : Int!
}

class AssetMenuWrapperModel : NSObject
{
    var sectionName : String!
    var assetMenuList : [AssetsMenuModel]!
    var isExpanded : Bool = false
}

class ShowList : NSObject
{
    var id: Int!
    var storyId: NSNumber!
    var storyName: String!
    var assetList: [AssetHeader] = []
    var storyEnabled: Bool!
}

class ShowListModel : NSObject
{
    var id: Int!
    var storyId: NSNumber! = -1
    var assetDetail : AssetHeader!
    var storyObj = AssetMandatoryListModel()
    var storyEnabled = false
    var isPrefilled : Bool = true
    
}
