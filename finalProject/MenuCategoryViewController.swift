//
//  MennuShowViewController.swift
//  finalProject
//
//  Created by 陸顥壬 on 2019/6/23.
//  Copyright © 2019 陸顥壬. All rights reserved.
//

import UIKit
import Firebase

class MenuCategoryViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    struct CellIdentifier {
        static let identifier = "menuCategoryTableViewCell"
    }
    
    @IBOutlet weak var menuNavItem: UINavigationItem!
    @IBOutlet weak var menuShowTableView: UITableView!

    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var categoryText:String=""
    let defaultProductImg = UIImage(named: "defaultProduct")
    var productArray:[Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 設置委任對象
        menuShowTableView.dataSource = self
        self.menuShowTableView.rowHeight = 170.0
        self.menuShowTableView.estimatedRowHeight = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        menuNavItem.title = categoryText
        loadProducts(categoryText)
    }
    
    func loadProducts(_ categoryName: String){
        self.productArray.removeAll()
        let db = Firestore.firestore();
        db.collection("products").whereField("type", isEqualTo: categoryName).getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    
                    let documentID = document.documentID
                    let name = document.data()["name"] as! String
                    let price = document.data()["price"] as! String
                    let type = document.data()["type"] as! String
                    let imgUrl = document.data()["imgUrl"] as! String
                    let seller = document.data()["seller"] as! String
                    
                    let product = Product(id: documentID,name: name, price: price, imgUrl: imgUrl, type: type, seller: seller)
                    
                    self.productArray.append(product) // object product set
                    
                    //                    print(product.toAnyObject())
                    
                }
                self.menuShowTableView.reloadData()
            }
        }
    }
    
    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.identifier, for: indexPath) as? MenuCategoryTableViewCell else {return UITableViewCell()}
        
       cell.productImageView.image = defaultProductImg
        
        cell.productImageView.imageFromServerURL(productArray[indexPath.row].imgUrl, placeHolder: defaultProductImg)
        cell.productNameLabel.adjustsFontSizeToFitWidth = true
        cell.productNameLabel.text =  productArray[indexPath.row].name
        cell.productPriceLabel.adjustsFontSizeToFitWidth = true
        cell.productPriceLabel.text = String(productArray[indexPath.row].price)
        return cell
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
