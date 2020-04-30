//
//  AddProductInPromotionController.swift
//  GWShopReal
//
//  Created by PMJs on 30/4/2563 BE.
//  Copyright © 2563 PMJs. All rights reserved.
//

import UIKit
import Firebase

class AddProductInPromotionController: UIViewController {
    
    
    @IBOutlet weak var productInPromotionTableView: UITableView!
    var product : [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productInPromotionTableView.dataSource = self
        loadProduct()
    }
    
    func loadProduct()  {
        
        let db = Firestore.firestore()
        let productCollect = db.collection(K.productCollection.productCollection)
        if let emailSender = Auth.auth().currentUser?.email {
            productCollect.whereField(K.sender, isEqualTo: emailSender).getDocuments { (querySnapshot, error) in
                
                self.product = []
                
                if let e = error {
                    print("error while loading product \(e.localizedDescription)")
                } else {
                    if let snapShotDocument = querySnapshot?.documents {
                        for doc in snapShotDocument {
                            let data = doc.data()
                            let docID = doc.documentID
                            
                            if let productNameCell = data[K.productCollection.productName] as? String
                            ,  let productCategoryCell = data[K.productCollection.productCategory] as? String
                            ,  let productDetailCell = data[K.productCollection.productDetail] as? String
                            ,  let productImageURLCell = data[K.productCollection.productImageURL] as? String
                            , let productPriceCell = data[K.productCollection.productPrice] as? String
                            , let productQuantity = data[K.productCollection.productQuantity] as? String {
                                
                                let newProduct = Product(productName: productNameCell, productDetail: productDetailCell, productCategory: productCategoryCell, productPrice: productPriceCell, productQuantity: productQuantity, productImageURL: productImageURLCell, documentId: docID)
                                
                                self.product.append(newProduct)
                                
                                DispatchQueue.main.async {
                                    self.productInPromotionTableView.reloadData()
                                }
                            }
                                
                        }
                    }
                    
                }
            }
        }
    }
 }

extension AddProductInPromotionController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let productReturnToCell = product[indexPath.row]
        let cell = productInPromotionTableView.dequeueReusableCell(withIdentifier: K.identifierForTableView.addProductInAddPromotionCell) as! addProductInAddPromotionCell
        
        cell.productNameLable.text = productReturnToCell.productName
        cell.priceLabel.text  = productReturnToCell.productPrice
        cell.productImageURL = productReturnToCell.productImageURL
        productInPromotionTableView.delegate = self
        return cell
        
    }
    
    
    
    
    
}