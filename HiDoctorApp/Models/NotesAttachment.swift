//
//  NotesAttachment.swift
//  HiDoctorApp
//
//  Created by SwaaS on 24/07/19.
//  Copyright © 2019 swaas. All rights reserved.
//

import UIKit
import GRDB

class NotesAttachment: Record
{
    
    var AttachmentName: String?
    
    init(dict: NSDictionary)
    {
        self.AttachmentName = checkNullAndNilValueForString(stringData: dict.value(forKey: "AttachmentName") as? String)
        super.init()
    }
    
    override class var databaseTableName: String
    {
        return Notes_Attachment
    }
    
    required init(row: Row)
    {
        AttachmentName = row["AttachmentName"]
        super.init(row: row)
    }
    override func encode(to container: inout PersistenceContainer) {
        
        container["AttachmentName"] = AttachmentName
        
}
}
class NotesAttach: NSObject{
    var AttachmentName: String = ""
}
