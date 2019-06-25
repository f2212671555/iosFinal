//
//  HomeContentViewController.swift
//  finalProject
//
//  Created by 陸顥壬 on 2019/6/25.
//  Copyright © 2019 陸顥壬. All rights reserved.
//

import UIKit
import Firebase

class HomeContentViewController: UIViewController, UIScrollViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myPageControl: UIPageControl!
    @IBOutlet weak var homeContentTableView: UITableView!
    
    struct CellIdentifier {
        static let identifier = "HomeContentTableViewCell"
    }
    
    var upperPics = ["asus", "iphone"]
    var productArray = [Product]()
    let defaultProductImg = UIImage(named: "defaultProduct")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.homeContentTableView.tableFooterView = UIView(frame:CGRect.zero)
        //實際可見視圖範圍寬度
        myScrollView.contentSize.width = (myScrollView.frame.width) * CGFloat(upperPics.count)
        //實際可見視圖範圍高度
        myScrollView.contentSize.height = 104
        //設置代理
        myScrollView.delegate = self
        //以每頁的方式進行更換
        myScrollView.isPagingEnabled = true
        //將超出部分會出現scroll bar的部分隱藏
        myScrollView.showsHorizontalScrollIndicator = false
        //custom page cotrol
        myPageControl.currentPageIndicatorTintColor = .black
        myPageControl.pageIndicatorTintColor = .gray
        //設定頁數
        myPageControl.numberOfPages = upperPics.count
        //起始頁
        myPageControl.currentPage = 0
        
        //將圖片顯示在myScrollView中
        for (index, pic) in upperPics.enumerated() {
            let image = UIImageView(image: UIImage(named: pic))
            image.contentMode = .scaleAspectFit
            image.frame = CGRect(x: CGFloat(index) * myScrollView.frame.width, y: 0, width: myScrollView.frame.width, height: myScrollView.frame.height)
            myScrollView.addSubview(image)
        }
        
        homeContentTableView.dataSource = self
        self.homeContentTableView.rowHeight = 125.0
        self.homeContentTableView.estimatedRowHeight = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        loadProducts()
    }
    
    func loadProducts(){
        self.productArray.removeAll()
        let db = Firestore.firestore();
        db.collection("products").getDocuments { (querySnapshot, error) in
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
                }
                self.homeContentTableView.reloadData()
            }
        }
    }
    
    // 滾動方法
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //update current page in page control while scrolling
        let currentPage = Int(myScrollView.contentOffset.x / myScrollView.frame.size.width)
        myPageControl.currentPage = currentPage
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
    
    // 每個 section 的標題
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        let title = section == 0 ? "即刻搶購" : ""
        return title
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.identifier, for: indexPath) as? HomeContentTableViewCell else {
            
            return UITableViewCell()
        }
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
