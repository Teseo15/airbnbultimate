//
//  ExplorerViewController.swift
//  semana7-b
//
//  Created by Linder Hassinger on 6/10/21.
//

import UIKit
import SkeletonView

class ExplorerViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var name: String? = nil
    var address: String? = nil
    var rating: String? = nil
    var userRatingsTotal: String? = nil
    var photo: String? = nil
    
//    var shouldAnimate = true
    
    let venueViewModel = VenueViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
        setUpTable()
    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        tableView.isSkeletonable = true
//        tableView.showSkeleton()
//    }
//
    func setUpTable() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configure() {
        venueViewModel.getVenues()
    }
    
    func bind() {
        venueViewModel.refreshData = { [weak self] () in
            DispatchQueue.main.async {
//                self?.shouldAnimate = false
                self?.tableView.reloadData()
            }
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//                self?.shouldAnimate = false
//                self?.tableView.reloadData()
//            })
        }
    }

}

extension ExplorerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venueViewModel.arrayVenues.count
    }
    
//    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return venueViewModel.arrayVenues.count
//    }
//
//    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
//        return "cellExplorer"
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // aca vamos a vincular nuestra celda con el archivo tableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellExplorer", for: indexPath) as! ExploreTableViewCell
        
        let object = venueViewModel.arrayVenues[indexPath.row]
        
        cell.lblTitle.text = object.name
        cell.lblAddress.text = object.address
        cell.lblRating.text = String(object.rating)
        cell.lblCountRating.text = "(\(object.userRatingsTotal))"
        
        setUpImage(photo: object.photo, image: cell.explorImage)
        
        let cellView = UIView()
        cellView.backgroundColor = UIColor.systemBackground
        cell.selectedBackgroundView = cellView
        
//        if !shouldAnimate {
////            cell.hideSkeleton()
//            tableView.stopSkeletonAnimation()
//            view.hideSkeleton()
//        }
//
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // voy a decirle que al dar click en una fila esta vaya a una pantall de detalle
        let object = venueViewModel.arrayVenues[indexPath.row]
        
        self.name = object.name
        self.address = object.address
        self.rating = String(object.rating)
        self.userRatingsTotal = "(\(object.userRatingsTotal))"
        self.photo = object.photo
        
        self.performSegue(withIdentifier: "exploreSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "exploreSegue" {
            if let destVC = segue.destination as? ExploreDetailViewController {
                destVC.name = self.name
                destVC.rating = self.rating
                destVC.address = self.address
                destVC.userRatingsTotal = self.userRatingsTotal
                destVC.photo = self.photo
            }
        }
    }
}
