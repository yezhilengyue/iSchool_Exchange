//
//  Restaurant.swift
//  iSchool Exchange
//
//  Created by ChenYuwei on 2017/10/11.
//  Copyright © 2017年 ChenYuwei. All rights reserved.
//

import Foundation

class Restaurant {
    var name = ""
    var type = ""
    var location = ""
    var phone = ""
    var image = ""
    var isVisited = false
    
    init(name:String, type:String, location:String, phone:String, image:String, isVisited:Bool){
        self.name = name
        self.type = type
        self.location = location
        self.phone = phone
        self.image = image
        self.isVisited = isVisited
    }
}
