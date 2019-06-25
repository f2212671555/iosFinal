//
//  UserUploadSellsViewController.swift
//  finalProject
//
//  Created by 陸顥壬 on 2019/6/25.
//  Copyright © 2019 陸顥壬. All rights reserved.
//

import UIKit
import Firebase

class UserUploadSellsViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productTypeTextField: UITextField!
    @IBOutlet weak var productPriceTextField: UITextField!
    var product = Product()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    // 從相簿或相機取到照片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        
        // 取得從 UIImagePickerController 選擇到的檔案
        guard let pickedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        productImageView?.image = pickedImage
        selectedImageFromPicker = pickedImage
        // 關閉圖庫
        dismiss(animated: true, completion: nil)
        
    }
    
    func checkImage() -> Bool {
        if productImageView.image == nil {
            let alertController = UIAlertController(title: "choose a picture", message: "Please choose product image", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            return false
        }else {
            return true
        }
    }
    
    func checkInput() -> Bool {
        var result:Bool = false
        if productNameTextField.text == "" || productTypeTextField.text == "" || productPriceTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter product name, type and price", preferredStyle: .alert)
            
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
            let storageRef = Storage.storage().reference().child("ProductImages").child("\(imageName).png")
            
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
                            self.product.imgUrl = "none"
                            self.saveProduct2Firestore(self.product)
                            return
                        }
                        let productId = NSUUID().uuidString
                        self.product.id = productId
                        self.product.name =  self.productNameTextField.text!
                        self.product.price =  self.productPriceTextField.text!
                        self.product.type =  self.productTypeTextField.text!
                        self.product.seller =  UserDefaults.standard.string(forKey: "userName") ?? "none"
                        // 上傳照片的連結
                        self.product.imgUrl = url?.absoluteString ?? "none"
                        self.saveProduct2Firestore(self.product)
                        
                    })
                    
                })
            }
        }
    }
    
    // 上架成功關閉此頁面
    func handler() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    func saveProduct2Firestore(_ product: Product) {
        let db = Firestore.firestore()
        let data = ["id": product.id,
                    "name": product.name,
                    "price": product.price,
                    "imgUrl": product.imgUrl,
                    "type": product.type,
                    "seller": product.seller,
                    "buyer": "none"]
        db.collection("products").addDocument(data: data) { (error) in
            if let error = error {
                print(error)
            } else {
                print(product.toAnyObject())
            }
        }
    }
    
    @IBAction func addProductBtn(_ sender: Any) {
        if checkInput() == true {
            if checkImage() == true {
                uploadImg2StorageAndsaveProduct2Firestore(productImageView.image)
                
                let alertController = UIAlertController(title: "上架成功", message: "\(self.product.name)上架成功", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: { action in self.handler()})
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
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
