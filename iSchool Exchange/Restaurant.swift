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
    var image = ""
    var isVisited = false
    
    init(name:String, type:String, location:String, image:String, isVisited:Bool){
        self.name = name
        self.type = type
        self.location = location
        self.image = image
        self.isVisited = isVisited
    }
}
