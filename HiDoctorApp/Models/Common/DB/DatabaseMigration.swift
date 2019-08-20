//
//  DatabaseMigration.swift
//  HiDoctorApp
//
//  Created by Vignaya on 10/17/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import GRDB

class DatabaseMigration: NSObject
{
    static let sharedInstance = DatabaseMigration()
    
    func doV1Migration()
    {
        self.insertAppStatus()        
    }
    
    private func insertAppStatus()
    {
        let count = DBHelper.sharedInstance.getAppStatusCount()
        
        if (count == 0)
        {
            DBHelper.sharedInstance.insertAppStatus()
        }
    }
    
    func insertOnBoard()
    {
        let count = DBHelper.sharedInstance.getOnboardDetailsCount()
        
        if (count == 0)
        {
            DBHelper.sharedInstance.insertOnboardDetail(shownType: 0)
        }
    }
}
