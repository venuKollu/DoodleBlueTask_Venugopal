//
//  UserDataModel.swift
//  DoodleBlueTask_Venugopal
//
//  Created by Venugopal on 25/07/20.
//  Copyright © 2020 Venugopal. All rights reserved.
//

import UIKit

class UserDataModel: NSObject {
    var userName: String?
    var userImage: String?
    
    init(responceDict : NSDictionary) {
        if let str = responceDict["name"] as? String{
            userName = str
        }
        if let str = responceDict["image"] as? String{
            userImage = str
        }
    }
}
