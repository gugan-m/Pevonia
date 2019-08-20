//
//  SplashModel.swift
//  HiDoctorApp
//
//  Created by Swaas on 06/03/19.
//  Copyright © 2019 swaas. All rights reserved.
//

import UIKit

class SplashModel: NSObject {
    static let sharedInstance : SplashModel = SplashModel()
    
    var type: Int!
    var desc: String!
    var file: String!
    var title: String!
}
