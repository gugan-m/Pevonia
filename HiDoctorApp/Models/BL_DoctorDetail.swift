//
//  BL_DoctorDetail.swift
//  HiDoctorApp
//
//  Created by Vijay on 22/06/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class DoctorTag: NSObject
{
    var tagId: Int!
    var tagName: String!
}

class DoctorRemarks: NSObject
{
    var remarksId: Int!
    var remarksDate: String!
    var remarksDesc: String!
}

class BL_DoctorDetail: NSObject
{
    static let sharedInstance = BL_DoctorDetail()
    
    let sampleTagList: [String] = ["Cardiology", "Chennai", "Dean of MGR University", "Sachin fan", "Food lover", "Rajini fan", "Test tag", "Clinic Adyar", "Apollo hospital"]
    let remarksDateList: [String] = ["June 20, 2017", "June 21, 2017", "June 22, 2017"]
    let remarksDescList: [String] = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean dignissim ornare arcu accumsan interdum. Sed auctor velit ut velit hendrerit, ut feugiat risus tincidunt", "Phasellus ultricies diam et aliquet vehicula. Pellentesque finibus, lectus at ultrices bibendum, lectus justo egestas sem, a auctor felis mi et velit", "Donec blandit libero vel tellus suscipit pellentesque. Nulla eget libero vitae sem lobortis suscipit. Curabitur ultricies bibendum lectus"]
    
    func getDefaultTagList() -> [DoctorTag]
    {
        var tagList: [DoctorTag] = []
        
        for i in 0..<sampleTagList.count
        {
            if i < defaultTagCount
            {
                let tagModel = DoctorTag()
                tagModel.tagName = sampleTagList[i]
                tagList.append(tagModel)
            }
        }
        
        return tagList
    }
    
    func getTagList() -> [DoctorTag]
    {
        var tagList: [DoctorTag] = []
        
        for tagName in sampleTagList
        {
            let tagModel = DoctorTag()
            tagModel.tagName = tagName
            tagList.append(tagModel)
        }
        
        return tagList
    }
    
    func getRemarksList() -> [DoctorRemarks]
    {
        var remarksList: [DoctorRemarks] = []
        
        for i in 0..<remarksDateList.count
        {
            let remarksModel = DoctorRemarks()
            remarksModel.remarksDate = remarksDateList[i]
            remarksModel.remarksDesc = remarksDescList[i]
            remarksList.append(remarksModel)
        }
        
        return remarksList
    }
}
