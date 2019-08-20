//
//  BL_NoticeBoard.swift
//  HiDoctorApp
//
//  Created by Kanchana on 8/4/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class BL_NoticeBoard: NSObject
{
    static let sharedInstance = BL_NoticeBoard()
    var noticeBoardArray:[NSArray] = []
    
    //MARK:- GetNoticeBoardData
    func getNoticeBoardDetail(completion: @escaping (_ StatusMsg:String,_ Status: Int, _ list:NSArray) -> ())
    {
        WebServiceHelper.sharedInstance.getNoticeBoardDetails (postData: getNoticeBoardPostData()){ (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                DAL_NoticeBoard.sharedInstance.deleteNoticeBoardDetail()
                DAL_NoticeBoard.sharedInstance.deleteNoticeBoardAttachmentDetail()
                DAL_NoticeBoard.sharedInstance.insertNoticeboardDetail(array: apiResponseObj.list as NSArray )
                DAL_NoticeBoard.sharedInstance.insertNoticeboardAttachementDetail(array: apiResponseObj.list as NSArray )
                completion(apiResponseObj.Message,apiResponseObj.Status,apiResponseObj.list)
            }
            else
            {
                
                completion(apiResponseObj.Message,apiResponseObj.Status,apiResponseObj.list)
            }
        }
    }
    
    func clearAllArray()
    {
        noticeBoardArray.removeAll()
    }
    
    func updateNoticeBoardDetail(pageNo: Int ,completion: @escaping (_ StatusMsg:String,_ Status: Int,_ list:NSArray) -> ())
    {
        WebServiceHelper.sharedInstance.getNoticeBoardDetails (postData: getNoticeBoardPostDataForUpdate(pageNo: pageNo)){ (apiResponseObj) in
            let statusCode = apiResponseObj.Status
            
            if (statusCode == SERVER_SUCCESS_CODE)
            {
                DAL_NoticeBoard.sharedInstance.insertNoticeboardDetail(array: apiResponseObj.list as NSArray )
                DAL_NoticeBoard.sharedInstance.insertNoticeboardAttachementDetail(array: apiResponseObj.list as NSArray )
                completion(apiResponseObj.Message,apiResponseObj.Status,apiResponseObj.list)
            }
            else
            {
                completion(apiResponseObj.Message,apiResponseObj.Status,apiResponseObj.list)
            }
        }
    }

    func postNoticeBoardDetail(msgCode: String)
    {
        WebServiceHelper.sharedInstance.postNoticeBoardDetails(postData: postDataNoticeBoard(msgCode: msgCode)){ (apiResponseObj) in
        }
    }
    
    //MARK:- PostData for WebServicecall
    func getNoticeBoardPostData() -> [String: Any]
    {
        return ["CompanyCode": getCompanyCode() , "UserCode": getUserCode() , "RegionCode": getRegionCode() , "Page_Size":Constants.NoticeBoardPageConstants.pageSize , "Page_Number": 1 , "Filter_By": "" ]
    }
    
    func postDataNoticeBoard(msgCode: String) -> [String:Any]
    {
        return [ "CompanyCode": getCompanyCode(),
                 "MsgCode": msgCode,
                 "UserCode": getUserCode()]
    }
    func getNoticeBoardPostDataForUpdate(pageNo: Int) -> [String: Any]
    {
        return ["CompanyCode": getCompanyCode() , "UserCode": getUserCode() , "RegionCode": getRegionCode() , "Page_Size":Constants.NoticeBoardPageConstants.pageSize , "Page_Number": pageNo , "Filter_By": "" ]
    }
}
