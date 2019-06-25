//
//  ManageSellsTableViewController.swift
//  finalProject
//
//  Created by 陸顥壬 on 2019/6/25.
//  Copyright © 2019 陸顥壬. All rights reserved.
//

import UIKit
import Firebase

class ManageSellsViewController: UIViewController ,UITableViewDataSource ,UITableViewDelegate{

    @IBOutlet weak var manageSellsTableView: UITableView!
    
    struct CellIdentifier {
        static let identifier = "ManageSellsTableViewCell"
    }
    
    let defaultProductImg = UIImage(named: "defaultProduct")
    var productArray:[Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // 設置委任對象
        manageSellsTableView.dataSource = self
        manageSellsTableView.delegate = self
        
        self.manageSellsTableView.rowHeight = 170.0
        self.manageSellsTableView.estimatedRowHeight = 0
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userDefaults = UserDefaults.standard
        let userName: String = userDefaults.string(forKey: "userName") ?? "nil"
        if userName == "nil" { // 未登入
            productArray.removeAll()
            manageSellsTableView.reloadData()
            showNotLoginAlert()
        }else {
            loadProducts(userName)
        }
        
    }
    
    func showNotLoginAlert() {
        // 提示用戶從 firebase 返回了一個錯誤。
        let alertController = UIAlertController(title: "未登入", message: "未登入！", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: {action in self.notLoginHandler()})
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // 未登入關閉此頁面
    func notLoginHandler() -> Void {
        self.tabBarController?.selectedIndex = 0
    }
    
    // 下架關閉此頁面
    func productDelHandler() -> Void {
        self.manageSellsTableView.reloadData()
    }
    
    func loadProducts(_ userName: String){
        self.productArray.removeAll()
        let db = Firestore.firestore();
        db.collection("products").whereField("seller", isEqualTo: userName).getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    
                    let documentID = document.documentID
                    let name = document.data()["name"] as! String
                    let price = document.data()["price"] as! String
                    let type = document.data()["type"] as! String
                    let imgUrl = document.data()["imgUrl"] as! String
                    
                    let product = Product(id: documentID,name: name, price: price, imgUrl: imgUrl, type: type,seller: userName)
                    
                    self.productArray.append(product) // object product set
                    
                    //                    print(product.toAnyObject())
                    
                }
                self.manageSellsTableView.reloadData()
            }
        }
    }
    
    @IBAction func delProductBtn(_ sender: Any) {
        let btn = sender as! UIButton
        let tag = btn.tag
        let id = productArray[tag].id
        self.productArray.remove(at: tag)
        delProduct(id)
        let alertController = UIAlertController(title: "下架", message: "下架成功", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: { action in self.productDelHandler()})
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func delProduct(_ productId: String) {
        let db = Firestore.firestore();
        db.collection("products").whereField("id", isEqualTo: productId).getDocuments{ (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    document.reference.delete(){ err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                        }
                    }
                }
                self.manageSellsTableView.reloadData()
            }
        }
    }
    // MARK: - Table view data source

    // 有幾組 section
    func numberOfSectionsInTableView(
        tableView: UITableView) -> Int {
        return 1
    }
    
    // 必須實作的方法：每一組有幾個 cell
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 150.0;//Choose your custom row height
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.identifier, for: indexPath) as? ManageSellsTableViewCell else {return UITableViewCell()}
        
        cell.productImageView.image = defaultProductImg
        
        cell.productImageView?.imageFromServerURL(productArray[indexPath.row].imgUrl, placeHolder: defaultProductImg)
        cell.productNameLabel.adjustsFontSizeToFitWidth = true
        cell.productNameLabel.text =  productArray[indexPath.row].name
        cell.productPriceLabel.adjustsFontSizeToFitWidth = true
        cell.productPriceLabel.text = String(productArray[indexPath.row].price)
        cell.productDelBtn.tag = indexPath.row
        return cell
    }

    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        let controller = segue.destination as? UserModifyViewController
        let indexPath = self.manageSellsTableView.indexPathForSelectedRow
        controller?.productImage = productArray[indexPath!.row].imgUrl
        controller?.productName  = productArray[indexPath!.row].name
        controller?.productType = productArray[indexPath!.row].type
        controller?.productPrice = productArray[indexPath!.row].price
     }
 

}
