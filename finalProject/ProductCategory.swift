//
//  ProductCategory.swift
//  finalProject
//
//  Created by 陸顥壬 on 2019/6/25.
//  Copyright © 2019 陸顥壬. All rights reserved.
//

import UIKit

class ProductCategory {
    var id:String
    var name:String
    var imgUrl:String
    
    init(){
        self.id = ""
        self.name  = ""
        self.imgUrl  = ""
    }
    
    init(id: String,name:String, imgUrl: String){
        self.id = id
        self.name = name
        self.imgUrl = imgUrl
    }
    
    func toAnyObject() -> Any {
        return [
            "id": id,
            "name": name,
            "imgUrl": imgUrl
        ]
    }
}
