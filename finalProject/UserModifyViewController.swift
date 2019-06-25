//
//  UserModifyViewController.swift
//  finalProject
//
//  Created by 陸顥壬 on 2019/6/25.
//  Copyright © 2019 陸顥壬. All rights reserved.
//

import UIKit

class UserModifyViewController: UIViewController {

    var productImage:String = ""
    var productName:String = ""
    var productType:String = ""
    var productPrice:String = ""
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productTypeTextField: UITextField!
    @IBOutlet weak var productPriceTextField: UITextField!
    
    let defaultProductImg = UIImage(named: "defaultProduct")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initProduct()
    }
    
    func initProduct() {
        productImageView.imageFromServerURL(productImage, placeHolder: defaultProductImg)
        productNameTextField.placeholder = productName
        productTypeTextField.placeholder = productType
        productPriceTextField.placeholder = productPrice
    }
    
    @IBAction func commitBtnAction(_ sender: Any) {
    }
    
    @IBAction func changeImgBtnAction(_ sender: Any) {
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
