//
//  DashboardModel.swift
//  HiDoctorApp
//
//  Created by SwaaS on 12/01/17.
//  Copyright © 2017 swaas. All rights reserved.
//

import UIKit

class DashboardModel: NSObject
{
    var entityId: Int!
    var entityName: String!
    var entityValue: String!
    var iconName: String!
    var isDrillDownRequired: Bool = false
    var currentCallAverage: Double = 0
    var priviousCallAverage: Double = 0
    var dashboardAppliedList :[DashBoardAppliedCount] = []
}

class DashBoardAppliedCount : NSObject
{
    var UserName: String!
    var appliedDate: Date!
    var Applied_Date: String!
    var Flag: String!
    var month: Int!
    var year: Int!
}
