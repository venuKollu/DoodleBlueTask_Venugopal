//
//  MainModel.swift
//  DoodleBlueTask_Venugopal
//
//  Created by Venugopal on 25/07/20.
//  Copyright © 2020 Venugopal. All rights reserved.
//

import UIKit

class MainModel: NSObject {
    var headerName: String?
    var headerArray: [UserDataModel]? = []
     var selectionType : Int?
    var selectedIndex: [Int] = []
    
    init(responceDict : NSDictionary) {
        if let str = responceDict["headerName"] as? String{
            headerName = str
        }
       if let headerArr = responceDict["headerArray"] as? NSArray {
            for subDict in headerArr {
                let setsubDict = UserDataModel(responceDict: subDict as! NSDictionary)
                headerArray?.append(setsubDict)
            }
        }
        if let str = responceDict["type"] as? Int{
                   selectionType = str
        }
        
    }
}
