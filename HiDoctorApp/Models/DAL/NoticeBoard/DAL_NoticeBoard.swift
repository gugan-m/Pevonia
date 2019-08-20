//
//  DAL_NoticeBoard.swift
//  HiDoctorApp
//
//  Created by Kanchana on 8/4/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class DAL_NoticeBoard: NSObject {
    
    static let sharedInstance = DAL_NoticeBoard()
    
    //MARK:- Save NoticeBoard Details
    func insertNoticeboardDetail(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try NoticeBoardModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    func insertNoticeboardAttachementDetail(array: NSArray)
    {
        try? dbPool.writeInTransaction { db in
            for data in array
            {
                try NoticeBoardDetailModel(dict: data as! NSDictionary).insert(db)
            }
            return .commit
        }
    }
    
    //MARK:- Get Noticeboard Details
    func getNoticeboardAttachementDetail(msgCode:String) -> [NoticeBoardDetailModel]!
    {
        var noticeBoardList : [NoticeBoardDetailModel]!
        
        dbPool.read { db in
            noticeBoardList = NoticeBoardDetailModel.fetchAll(db, "SELECT * FROM \(NOTICEBOARD_DOWNLOAD) WHERE Msg_Code = ?", arguments: [msgCode])
        }
        
        return noticeBoardList!
    }
    func getNoticeBoardDetail() -> [NoticeBoardModel]?
    {
        var noticeBoardList : [NoticeBoardModel]?
        
        dbPool.read { db in
            noticeBoardList = NoticeBoardModel.fetchAll(db, "SELECT * FROM \(NOTICEBOARD_DETAIL)")
        }
        return noticeBoardList
    }
    //MARK:- Delete Details
    func deleteNoticeBoardDetail()
    {
        executeQuery(query: "DELETE FROM \(NOTICEBOARD_DETAIL)")
    }
    func deleteNoticeBoardAttachmentDetail()
    {
        executeQuery(query: "DELETE FROM \(NOTICEBOARD_DOWNLOAD)")
    }


}
