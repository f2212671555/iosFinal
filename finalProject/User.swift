//
//  User.swift
//  finalProject
//
//  Created by 陸顥壬 on 2019/6/24.
//  Copyright © 2019 陸顥壬. All rights reserved.
//

import UIKit

class User {

    var id:String
    var name:String
    var account:String
    var imgUrl:String
    var type:String
    
    init(){
        self.id = ""
        self.name  = ""
        self.account  = ""
        self.imgUrl  = ""
        self.type  = ""
    }
    
    init(id: String,name:String, account: String, imgUrl: String, type: String){
        self.id = id
        self.name = name
        self.account = account
        self.imgUrl = imgUrl
        self.type = type
    }
    
    func toAnyObject() -> Any {
        return [
            "id": id,
            "name": name,
            "account": account,
            "imgUrl": imgUrl,
            "type": type
        ]
    }
    
}
