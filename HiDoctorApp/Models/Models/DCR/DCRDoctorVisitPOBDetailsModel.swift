//
//  DCRDoctorVisitPOBModel.swift
//  HiDoctorApp
//
//  Created by swaasuser on 21/04/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit
import GRDB

class DCRDoctorVisitPOBDetailsModel: NSObject
{
    var ORDER_DETAIL_ID : Int = 1
    var ORDER_ENTRY_ID : Int = 2
    var PRODUCT_CODE : String = ""
    var PRODUCT_QTY : Double?
    var PRODUCT_UNIT_RATE : Double?
    var PRODUCT_AMOUNT : Double?
    var PRODUCT_NAME : String?
}
