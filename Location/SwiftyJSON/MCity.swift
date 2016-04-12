//
//  MCity.swift
//  DDQP-Swift
//
//  Created by lovefancy on 15/11/4.
//  Copyright © 2015年 老镇. All rights reserved.
//

import UIKit
/**城市数据模型*/
class MCity: NSObject {
    static var lastTime:Int = -1
    var areaId:Int = -1
    var parentId: Int = -1
    var areaName: String = ""
    var level:Int = -1
    var child:[MCity] = []
    var parent:MCity?
    
    init(areaId:Int = -1,parentId:Int = -1,areaName:String = "") {
        self.areaId = areaId
        self.parentId = parentId
        self.areaName = areaName
    }
    
    func hasChildren()->Bool{
        return child.count > 0
    }
    func addChild(child:MCity){
        self.child.append(child)
        child.parent = self
        child.level = self.level+1
    }
}
