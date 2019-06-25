//
//  LoginViewController.swift
//  finalProject
//
//  Created by 陸顥壬 on 2019/6/16.
//  Copyright © 2019 陸顥壬. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.passwordTextField.isSecureTextEntry = true
    }
    
    @IBAction func loginAction(_ sender: AnyObject) {
        
        if self.emailTextField.text == "" {
            
            // 提示用戶是不是忘記輸入 textfield ？
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    
                    // 登入成功，打印 ("You have successfully logged in")
                    
                    //Go to the HomeViewController if the login is sucessful
                    // save User info
                    guard let userID = Auth.auth().currentUser?.uid else { return }
                    
                    self.getUserInfo(userID)
                    
                    let alertController = UIAlertController(title: "登入成功", message: "\(userID)登入成功", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: { action in self.handler()})
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)

                    
                } else {
                    
                    // 提示用戶從 firebase 返回了一個錯誤。
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    // 登入成功關閉此頁面
    func handler() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getUserInfo(_ userID : String) {
        let db = Firestore.firestore();
        db.collection("users").whereField("id", isEqualTo: userID).getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    
                    let id = userID;
                    let name = document.data()["name"] as! String;
                    let account = document.data()["account"] as! String;
                    let type = document.data()["type"] as! String;
                    let imgUrl = document.data()["imgUrl"] as! String;
                    
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(id, forKey: "userId")
                    userDefaults.set(name, forKey: "userName")
                    userDefaults.set(account, forKey: "userAccount")
                    userDefaults.set(type, forKey: "userType")
                    userDefaults.set(imgUrl, forKey: "userImgUrl")
                }
            }
        }
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
