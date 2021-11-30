//
//  WhishListViewController.swift
//  semana7-b
//
//  Created by Linder Hassinger on 29/09/21.
//

import UIKit
import FirebaseFirestore
import SkeletonView

class WishListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    
    // vamos a crear un arreglo de lugares
    var placesOfWish = [Wish]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        getWishList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.isSkeletonable = true
        tableView.showSkeleton()
    }
    
    func setUp() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getWishList() {
        db.collection("wishlist").getDocuments() {
            querySnapshot, err in
            
            if let err = err {
                print(err.localizedDescription)
            } else {
                self.placesOfWish.removeAll()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let documentId = document.documentID
                    let name = data["name"] as? String
                    let photo = data["photo"] as? String
                    let rating = data["rating"] as? String
                    let userRatingsTotal = data["userRatingsTotal"] as? String
                    let address = data["address"] as? String
                    let favorite = Wish(documentId: documentId, name: name!, address: address!, rating: rating!, userRatingsTotal: userRatingsTotal!, photo: photo!)
                    self.placesOfWish.append(favorite)
                }
                self.tableView.stopSkeletonAnimation()
                self.view.hideSkeleton()
                self.tableView.reloadData()
            }
        }
    }
 
    func resizeImage(name: String, for size: CGSize) -> UIImage {
        let image = UIImage(named: name)
        
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            image?.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}


extension WishListViewController:  UITableViewDelegate, SkeletonTableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "cell"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        return places.count
        return placesOfWish.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let object = placesOfWish[indexPath.section]
        
        cell.textLabel?.text = object.name
        cell.detailTextLabel?.text = object.address
        cell.imageView?.isSkeletonable = true
        // vamos a dar forma a las fotos
        cell.imageView?.layer.cornerRadius = 8.0
        cell.imageView?.layer.masksToBounds = true
        cell.imageView?.contentMode = .scaleAspectFit
        
        setUpImage(photo: object.photo, image: cell.imageView!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        Este evento capta el click de cada fila
//        Debo obtene el id de esa fila y pasarlo por firestore
        let object = placesOfWish[indexPath.section]
        
        let alert = UIAlertController(title: "Eliminar", message: "Seguro que desea elimina esto de su lista de deseos?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Si", style: .default) {_ in
            self.db.collection("wishlist").document(object.documentId).delete() {
                err in
                if let err = err {
                    print(err.localizedDescription)
                } else {
                    self.getWishList()
                }
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
