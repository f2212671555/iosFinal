//
//  PersonViewController.swift
//  finalProject
//
//  Created by 陸顥壬 on 2019/6/17.
//  Copyright © 2019 陸顥壬. All rights reserved.
//

import UIKit
import Firebase

class PersonViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    @IBOutlet weak var userImageView: UIImageView!
    var user = User()
    
    let defaultImg = UIImage(named: "defaultImage")
    @IBOutlet weak var userNameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        let userDefaults = UserDefaults.standard
        let userName: String = userDefaults.string(forKey: "userName") ?? "nil"
        let userId: String = userDefaults.string(forKey: "userId") ?? "nil"
        if userName != "nil" {
            user.id = userId
            userNameTextField.text = userName
            userImageView.imageFromServerURL(user.imgUrl, placeHolder: defaultImg)
        }else { // 未登入
            showNotLoginAlert()
        }
        
    }
    
    @IBAction func uploadImageBtn(_ sender: Any) {
        // 啟用相機
        // 建立一個 UIImagePickerController 的實體
        let imagePickerController = UIImagePickerController()
        
        // 委任代理
        imagePickerController.delegate = self
        
        // 設定 UIAlertController 的標題與樣式為動作清單(ActionSheet)
        let imagePickerAlertController = UIAlertController(title: "變更圖片", message: "請選擇要上傳的圖片或啟用相機", preferredStyle: .actionSheet)
        
        // 開啟圖庫，生成 UIAlertController 和 Action Sheet 的動作
        let imageFromLibAction = UIAlertAction(title: "照片圖庫", style: .default) { (Void) in
            
            // 判斷是否可以從照片圖庫取得照片來源
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                
                // 如果可以，指定 UIImagePickerController 的照片來源為 照片圖庫 (.photoLibrary)，並 present UIImagePickerController
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        
        // 啟用相機，生成 UIAlertController 和 Action Sheet 的動作
        let imageFromCameraAction = UIAlertAction(title: "相機", style: .default) { (Void) in
            
            // 判斷是否可以從相機取得照片來源
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                // 如果可以，指定 UIImagePickerController 的照片來源為 照片圖庫 (.camera)，並 present UIImagePickerController
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        
        // 新增一個取消動作，讓使用者可以關閉 UIAlertController
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (Void) in
            
            imagePickerAlertController.dismiss(animated: true, completion: nil)
        }
        
        imagePickerAlertController.addAction(imageFromLibAction)
        imagePickerAlertController.addAction(imageFromCameraAction)
        imagePickerAlertController.addAction(cancelAction)
        
        // 當使用者按下 uploadBtnAction 時會 present 剛剛建立好的三個 UIAlertAction 動作與處理的 block
        present(imagePickerAlertController, animated: true, completion: nil)
    }
    
    func checkInput() -> Bool {
        var result:Bool = false
        if userNameTextField.text == "" || userNameTextField.text == "nil" || userNameTextField.text == "none" {
            let alertController = UIAlertController(title: "Error", message: "Please enter user name", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
        }else {
            result = true
        }
        return result
    }
    
    func uploadImg2StorageAndsaveProduct2Firestore(_ selectedImageFromPicker: UIImage?) {
        
        // 將照片上傳到 Storage
        if let selectedImage = selectedImageFromPicker {
            print("\(selectedImage)")
            let imageName = NSUUID().uuidString
            // 第一個 child 的參數為「目錄名稱」；第二個 child 的參數為「圖片名稱」
            let storageRef = Storage.storage().reference().child("UserImages").child("\(imageName).png")
            
            // 將圖片轉成 png 後上傳到 storage
            if let uploadData = selectedImage.pngData() {
                // 將圖片上傳至 Storage
                storageRef.putData(uploadData, metadata: nil, completion: { (data, error) in
                    
                    if error != nil {
                        print("Error: \(error!.localizedDescription)")
                        return
                    }
                    // 取得上傳圖片連結的方式
                    storageRef.downloadURL(completion: {(url, error) in
                        if error != nil {
                            print("error： \(String(describing: error))")
                            self.user.imgUrl = "none"
                            self.saveUser2Firestore(self.user)
                            return
                        }
                        
                        self.user.name =  self.userNameTextField.text!
                        // 上傳照片的連結
                        self.user.imgUrl = url?.absoluteString ?? "none"
                        self.saveUser2Firestore(self.user)
                        
                    })
                    
                })
            }
        }
    }
    
    func saveUser2Firestore(_ user: User) {
        let db = Firestore.firestore()
        let data = ["name": user.name,
                    "imgUrl": user.imgUrl]
        db.collection("users").whereField("id", isEqualTo: user.id).getDocuments { (result, err) in
            if err != nil {
                // Some error occured
            }else {
                let document = result?.documents.first
                document?.reference.updateData(data)
            }
        }
    }
    
    func showNotLoginAlert() {
        // 提示用戶從 firebase 返回了一個錯誤。
        let alertController = UIAlertController(title: "未登入", message: "未登入！", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: {action in self.handler()})
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showCommitSuccessAlert() {
        // 提示用戶從 firebase 返回了一個錯誤。
        let alertController = UIAlertController(title: "提交", message: "更改成功！", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: {action in self.handler()})
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // 未登入或變更成功關閉此頁面
    func handler() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func commitBtnAction(_ sender: Any) {
        if checkInput() == true {
            self.uploadImg2StorageAndsaveProduct2Firestore(userImageView.image)
            showCommitSuccessAlert()
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
