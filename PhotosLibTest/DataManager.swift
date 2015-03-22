//
//  DataManager.swift
//  PhotosLibTest
//
//  Created by 相澤 隆志 on 2015/03/22.
//  Copyright (c) 2015年 相澤 隆志. All rights reserved.
//

import Foundation
import UIKit

/*
"Date":"2015/03/22"
"Camera":"EOS M3"
"Object": AnyObject as PHAsset
*/

class DataManager {
    private var dataArray:[[String:AnyObject]] = []
    class var sharedInstance:DataManager {
        struct Static {
            static let instance:DataManager = DataManager()
        }
        return Static.instance
    }
    
    func add( data: Dictionary<String,AnyObject> ) {
        dataArray.append( data )
    }
    
    func removeAll() {
        dataArray.removeAll()
    }
    
    /*
    "EOS M3":[Dictionary]
    "iPhone 6":[Dictionary]
    */
    func searchOfKey( key:String ) -> Dictionary<String,AnyObject>{
        var retDict:Dictionary<String,AnyObject> = [:]
        for obj in dataArray {
            let dict:Dictionary = obj as Dictionary
            for (keyOf, value) in dict {
                if keyOf == key {
                    let keyName: String = value as String
                    let k = Array(retDict.keys)
                    var flag = false
                    for keyN in k {
                        if keyN == keyName {
                            let newDictArray:[Dictionary<String,AnyObject>] = retDict[keyN]
                            newDictArray.append(dict)
                            flag = true
                        }
                    }
                    if flag == false {
                        retDict[keyName] = []
                        let newDictArray = retDict[keyName]
                        newDictArray.append(dict)
                    }
                }
            }
        }
        return retDict
    }
}