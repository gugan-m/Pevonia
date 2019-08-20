//
//  UserMasterWrapperModel.swift
//  ContactsPoc
//
//  Created by Vignaya on 10/24/16.
//  Copyright © 2016 Vignaya. All rights reserved.
//

import UIKit

class UserMasterWrapperModel: NSObject {
    
    var userObj : UserMasterModel  = UserMasterModel()
    var isSelected : Bool = false
    var isReadOnly: Bool = false
}

class UserListModel : NSObject
{
    var sectionKey : String = ""
    var accompanistsList : [UserMasterModel] = []
}
