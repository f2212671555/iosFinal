//
//  PersonTableViewController.swift
//  finalProject
//
//  Created by 陸顥壬 on 2019/6/24.
//  Copyright © 2019 陸顥壬. All rights reserved.
//

import UIKit
import Firebase

class PersonTableViewController: UITableViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.tableFooterView = UIView(frame:CGRect.zero)
        userLabel.adjustsFontSizeToFitWidth=true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userDefaults = UserDefaults.standard
        let userName: String = userDefaults.string(forKey: "userName") ?? "nil"
        let userImgUrl: String = userDefaults.string(forKey: "userImgUrl") ?? "nil"
        
        self.setUserButton(userName)
        self.setUserName(userName)
        self.setUserPhoto(userImgUrl)
    }
    
    @IBAction func logOutAction(sender: AnyObject) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                
                let alertController = UIAlertController(title: "登出", message: "登出成功", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: { action in self.handler()})
                alertController.addAction(defaultAction)
                present(alertController, animated: true, completion: nil)
                
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    // 登出成功關閉此頁面
    func handler() -> Void {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "userId")
        userDefaults.removeObject(forKey: "userName")
        userDefaults.removeObject(forKey: "userAccount")
        userDefaults.removeObject(forKey: "userType")
        userDefaults.removeObject(forKey: "userImgUrl")
        self.tabBarController?.selectedIndex = 0
    }
    
    // 設定按鈕 顯示 或 隱藏
    func setUserButton(_ userFlag: String) {
        if userFlag != "nil" { // 已登入
            loginButton.isHidden = true
            signupButton.isHidden = true
            logoutButton.isHidden = false
        }else {
            loginButton.isHidden = false
            signupButton.isHidden = false
            logoutButton.isHidden = true
        }
    }
    
    // 設定大頭照
    func setUserPhoto(_ userImageURL: String) {
        let uiImage = UIImage(named: "defaultUser")
        if userImageURL == "none" || userImageURL == "nil" { // 該使用者沒有圖片 或 沒有 登入
            userImageView.image = uiImage
        }else { // 該使用者有圖片
            userImageView.imageFromServerURL(userImageURL, placeHolder: uiImage)
        }
    }
    
    // 設定名稱
    func setUserName(_ userName: String) {
        if userName != "nil" { // 該使用者有登入
            userLabel.text = userName
        }else { // 該使用者沒有 登入
            userLabel.text = "您尚未登入"
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PersonTableViewCell", for: indexPath) as
            UITableViewCell else {
            return UITableViewCell()
        }
         //Configure the cell...
        return cell
    }*/
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
