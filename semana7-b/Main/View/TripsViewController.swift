//
//  TripsViewController.swift
//  semana7-b
//
//  Created by Linder Hassinger on 27/10/21.
//

import UIKit
import MapKit
import CoreLocation

class TripsViewController: UIViewController {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lblName: UILabel!
    
    let venueViewModel = VenueViewModel()
    
    //    Paso 1 para yo poder obtener la ubicacion del usario debe pedir permisos, asi como tambien obtener 2 cosas su latitude y longitude
    //    El archivo donde se piden permisos en info.plist
    //    Una vez que el usuario ya me dio los permisos yo puedo acceder a su ubication
    //    Para eso la librerio de apple llamanda corelocation
    
    var locationManager: CLLocationManager?
    var userLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestLocation()
        configure()
        bind()
        setUpView()
    }
    
    //    Tengo que validar que el usuario nos brindo el permiso
    func requestLocation() {
        mapView.delegate = self
        
        guard CLLocationManager.locationServicesEnabled() else { return }
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    func configure() {
        venueViewModel.getVenues()
    }
    
    func bind() {
        venueViewModel.refreshData = { [weak self] () in
            DispatchQueue.main.async {
                self?.createAnnotation()
            }
        }
    }
    
    func setUpView() {
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(getLocationOnLongClick(longGesture: )))
        
        mapView.addGestureRecognizer(longGesture)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.isHidden = true
    }
    
    func setAnnotation(coordinates: CLLocationCoordinate2D, title: String, subTitle: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        annotation.title = title
        annotation.subtitle = subTitle
        mapView.addAnnotation(annotation)
    }
    
//    Como obtener la ubicacion de un lugar al dar un click largo en la pantalla
    @objc func getLocationOnLongClick(longGesture: UIGestureRecognizer) {
        let touchPoint = longGesture.location(in: mapView)
        // Esto son las coordenas del lugar que acabo de apretar
        let coordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        // creamos un annotation
        setAnnotation(coordinates: coordinates, title: "Get Point", subTitle: "\(coordinates.latitude) \(coordinates.longitude)")
    }
    
}

extension TripsViewController: CLLocationManagerDelegate {
    
    //    Esta es la extension de mi locationamanger
    //    Para poder centrar mi ubicacion en el mapa debe obtener 2 cosas
    //    didUpLocation la cual nos brinda las coordenas del usuario en tiempo real
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        
        print(userLocation.coordinate.latitude)
        print(userLocation.coordinate.longitude)
        
        //        como tengo estos datos quiero centrar al map en esa seción(area)
        let localArea: CLLocationCoordinate2D = manager.location!.coordinate
        //        span: El span viene la distancia entre el mapa y el usuario
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: localArea, span: span)
        
        //        Tengo que asignarle al mapa esta region
        mapView.setRegion(region, animated: true)
    }
    
    //   Vamos a ver como crear un punto en mapa conocimo en iOS ANNOTATION
    func createAnnotation() {
        let places = venueViewModel.arrayVenues
        
        for place in places {
            let coordinates = CLLocationCoordinate2D(latitude: Double(place.latitude)!, longitude: Double(place.longitude)!)
            
            setAnnotation(coordinates: coordinates, title: place.name, subTitle:  "\(place.rating)")
        }
    }
    
}

extension TripsViewController: MKMapViewDelegate {
    
//    Exite la funcion didSelect que captura el click de los annotation
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.contentView.isHidden = false
//        obtener los datos del annotation (title, subtitle)
        self.lblName.text = (view.annotation?.title)!
        self.lblRating.text = (view.annotation?.subtitle)!
        
    }
    
}
