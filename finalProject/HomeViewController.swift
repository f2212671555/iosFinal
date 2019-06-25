//
//  HomeViewController.swift
//  finalProject
//
//  Created by 陸顥壬 on 2019/6/16.
//  Copyright © 2019 陸顥壬. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let userId: String = UserDefaults.standard.string(forKey: "userId") ?? "nil"
        let userName: String = UserDefaults.standard.string(forKey: "userName") ?? "nil"
        let userAccount: String = UserDefaults.standard.string(forKey: "userAccount") ?? "nil"
        let userType: String = UserDefaults.standard.string(forKey: "userType") ?? "nil"
        let userImgUrl: String = UserDefaults.standard.string(forKey: "userImgUrl") ?? "nil"
    print("asdsad")
        print(userId)
        print(userName)
        print(userAccount)
        print(userType)
        print(userImgUrl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
