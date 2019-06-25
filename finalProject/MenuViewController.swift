//
//  MenuViewController.swift
//  finalProject
//
//  Created by 陸顥壬 on 2019/6/22.
//  Copyright © 2019 陸顥壬. All rights reserved.
//

import UIKit
import Firebase

class MenuViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate {

    var categoryArray = [ProductCategory]()
    let defaultProductImg = UIImage(named: "defaultProduct")
    
    @IBOutlet weak var menuCollectionView: UICollectionView!
    
    @IBOutlet weak var menuCollectionViewFlowLayout: UICollectionViewFlowLayout!
    
    struct CellIdentifier {
        static let identifier = "photoCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        menuCollectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5) // 設置上下左右的間距
        let fullScreenSize = UIScreen.main.bounds.size // 手機螢幕的大小
        
        menuCollectionViewFlowLayout.itemSize = CGSize(width: fullScreenSize.width/2-10, height: fullScreenSize.height/3) // 設置Cell的size
        
        menuCollectionViewFlowLayout.minimumLineSpacing = 5 // 設置cell與cell的間距
        
        menuCollectionViewFlowLayout.scrollDirection = .vertical // 上下捲動
        
        
            // 註冊 cell 以供後續重複使用
//        menuCollectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: "photoCell")

        // 設置委任對象
//        menuCollectionView.delegate = self
//        menuCollectionView.dataSource = self
//        self.view.addSubview(menuCollectionView)


    }
    
    // 設定區塊 section 數量
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // 將圖片放入陣列中
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadProductCategories()
    }
    
    func loadProductCategories() {
        self.categoryArray.removeAll()
        let db = Firestore.firestore()
        db.collection("categories").getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    
                    let id = document.documentID
                    let name = document.data()["name"] as! String
                    let imgUrl = document.data()["imgUrl"] as! String
                    let productCategory = ProductCategory(id: id, name: name, imgUrl: imgUrl)
                    self.categoryArray.append(productCategory) // object category set
                    print(productCategory.toAnyObject())
                }
                self.menuCollectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.identifier, for: indexPath) as? MenuCollectionViewCell else {return UICollectionViewCell()}
        cell.productImageView.image = defaultProductImg
        cell.productImageView.imageFromServerURL(categoryArray[indexPath.row].imgUrl, placeHolder: defaultProductImg)
        cell.productCategoryNameLabel.adjustsFontSizeToFitWidth = true
        cell.productCategoryNameLabel.text = categoryArray[indexPath.row].name
        
        return cell
    }

    
    // 點選 cell 後執行的動作
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(categoryArray[indexPath.row].name)")
        let categoryText = categoryArray[indexPath.row].name;
        if let controller = storyboard?.instantiateViewController(withIdentifier: "menuShow") as? MenuCategoryViewController {
            controller.categoryText = categoryText
            present(controller, animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
           
    }*/
    
 

}
