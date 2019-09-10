//
//  MapVC.swift
//  PlacePoint
//
//  Created by Mac on 05/06/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    var lat = NSString()
    
    var long = NSString()
    
    var latitude = CLLocationDegrees()
    
    var longitude = CLLocationDegrees()
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.requestWhenInUseAuthorization()
            
            locationManager.startUpdatingLocation()
        }
        
        self.latitude = (lat as NSString).doubleValue
        
        self.longitude = (long as NSString).doubleValue
        
        locationManager.delegate = self
        
        self.setUpNavigation()
    }
    
    
    //MARK: - Set up Navigation
    func setUpNavigation() {
        
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.barTintColor = UIColor.themeColor()
        
        navigationItem.navTitle(title: "Location")
        
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(backButtonTapped))
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
    }
    
    
    // backButton tapped
    @objc func backButtonTapped() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - Create Marker
    func createMarker(coordinate: CLLocationCoordinate2D) {
        
        let mapAnnotation = MKPointAnnotation()
        
        mapAnnotation.coordinate = coordinate
        
        mapView.showsUserLocation = false
        
        mapView.addAnnotation(mapAnnotation)
        
        locationManager.stopUpdatingLocation()
    }
    
}


//MARK: - CLLocationManager Delegate
extension MapVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedWhenInUse else {
            return
            
        }
        
        locationManager.startUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let addressCoordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        
        let center = CLLocationCoordinate2D(latitude: addressCoordinate.latitude, longitude: addressCoordinate.longitude)
        
        let region: MKCoordinateRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView?.setRegion(region, animated: true)
        
        self.mapView?.showsUserLocation = true
        
        self.createMarker(coordinate: addressCoordinate)
    }
    
}

