//
//  Product.swift
//  finalProject
//
//  Created by 陸顥壬 on 2019/6/17.
//  Copyright © 2019 陸顥壬. All rights reserved.
//

import UIKit

class Product {
    
    var id:String
    var name:String
    var price:String
    var imgUrl:String
    var type:String
    var seller:String
    var buyer:String
    
    init(){
        self.id = ""
        self.name = ""
        self.price = ""
        self.imgUrl = ""
        self.type = ""
        self.seller = ""
        self.buyer = "none"
    }
    
    init(id: String,name:String, price: String, imgUrl: String, type: String, seller: String){
        self.id = id
        self.name = name
        self.price = price
        self.imgUrl = imgUrl
        self.type = type
        self.seller = seller
        self.buyer = "none"
    }
    
    init(id: String,name:String, price: String, imgUrl: String, type: String, seller: String, buyer: String){
        self.id = id
        self.name = name
        self.price = price
        self.imgUrl = imgUrl
        self.type = type
        self.seller = seller
        self.buyer = buyer
    }
    
    func toAnyObject() -> Any {
        return [
            "id": id,
            "name": name,
            "price": price,
            "imgUrl": imgUrl,
            "type": type,
            "seller": seller,
            "buyer": buyer
        ]
    }
}
