//
//  NotesModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 19/07/19.
//  Copyright © 2019 swaas. All rights reserved.
//
import UIKit
class NotesModel: NSObject {
    var companyCode: String = ""
    var companyID: Int = 0
    var title = "", noteActualDate: String = ""
    var notesOrTaskOf: NSNull? = nil
    var noteHeaderID: Int = 0
    var regionCode = "", regionName = "", userCode: String = ""
    var isNotePinned = 0, isNotePublic: Int = 0
    var createdBy = "", createdDateTime: String = ""
    var Task_Actual_Date: String = "", Task_Due_Date: String = ""
    var lstNotes: [LstNote] = []
    var lstNotesTags: [LstNotesTag] = []
    var lstAttachments: [LstAttachment] = []
}
class LstAttachment: NSObject {
    var companyCode: String = ""
    var companyID: Int = 0
    var attachmentURL: String = ""
    var taskHeaderID = 0, noteHeaderID: Int = 0
    var fileName = "", createdBy = "", createdDateTime: String = ""
    var inputStream: NSNull? = nil
}
class LstNote: NSObject {
    var companyCode: String = ""
    var companyID: Int = 0
    var notesDescription: String = ""
    var noteHeaderID: Int = 0
    var createdBy = "", createdDateTime: String = ""
}
class LstNotesTag: NSObject {
    var companyCode: NSNull? = nil
    var companyID = 0, noteHeaderID = 0, taskHeaderID: Int = 0
    var customerCode = "", doctorName = "", regionCode: String = ""
    var masterCCMID: Int = 0
    var accountNumber: NSNull? = nil
    var createdBy = "", createdDateTime: String = ""
}
