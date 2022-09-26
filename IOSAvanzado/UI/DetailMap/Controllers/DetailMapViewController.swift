//
//  DetailMapViewController.swift
//  IOSAvanzado
//
//  Created by Joaquín Corugedo Rodríguez on 25/9/22.
//

import UIKit
import MapKit

class DetailMapViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    
    let viewModel = DetailMapViewModel()
    
    private var model:Hero?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let model else {return}

        self.title = model.name
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let model else {return}
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(loadHeroMap),
            name: Notification.Name("loadMap"),
            object: nil
        )
        
        viewModel.checkLocationServices()

        viewModel.getAnnotations(heroe: model)
        centerToLastLocation()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "paperplane.fill"), style: .plain, target: self, action: #selector(centerToUserLocation))
        
        navigationController?.navigationBar.tintColor = .systemBlue
    }
    
    func set(model:Hero){
        self.model = model
    }
    
    //MARK: Configurations Maps
    func centerToDefaultLocation() {
        mapView.showsUserLocation = true
        mapView.centerToLocation(location: CLLocation(
            latitude: 40.4381311,
            longitude: -3.8196202
            )
        )
    }
    
    @objc func loadHeroMap() {
        
        guard let model else {return}
        
        let annotations = viewModel.locations.map { Annotation(hero: model, coordenate: HeroCoordenates(id: $0.id, latitud: $0.latitud, longitud: $0.longitud))
        }
        mapView.addAnnotations(annotations)
        
        mapView.register(AnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        mapView.showAnnotations(annotations, animated: true)
    }
    
    func centerToLastLocation(){
        mapView.showsUserLocation = true
        
        guard let latitud = viewModel.locations.last?.latitud ,
             let longitud = viewModel.locations.last?.longitud else{
            centerToDefaultLocation()
            return
        }
              
        mapView.centerToLocation(location: CLLocation(
            latitude:Double(latitud) ?? 40.4381311,
            longitude:Double(longitud) ?? -3.8196202
            )
        )
    }
    
    
    @objc func centerToUserLocation(){
        
        mapView.showsUserLocation = true
        mapView.centerToLocation(location: CLLocation(
            latitude: mapView.userLocation.coordinate.latitude,
            longitude: mapView.userLocation.coordinate.longitude
            )
        )
    }
    
    
}
