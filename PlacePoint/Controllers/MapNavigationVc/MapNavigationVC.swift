//
//  MapNavigationVC.swift
//  PlacePoint
//
//  Created by Mac on 03/08/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire

class MapNavigationVC: UIViewController {
    
    @IBOutlet var mapView: GMSMapView!
    
    var locationManager = CLLocationManager()
    
    var latitude = CLLocationDegrees()
    
    var longitude = CLLocationDegrees()
    
    var locationStart = CLLocation()
    
    var locationEnd = CLLocation()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        locationEnd = CLLocation(latitude: latitude, longitude: longitude)
        
        self.setUpNavigation()
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.requestWhenInUseAuthorization()
            
            locationManager.startUpdatingLocation()
        }
        
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
    
    
    //MARK: GoogleMarker
    func createGoogleMarker(lat: CLLocationDegrees,long: CLLocationDegrees) {
        
        let marker = GMSMarker()
        
        marker.position = CLLocationCoordinate2D(latitude:lat, longitude: long)
        
        marker.map = self.mapView
        
        mapView.selectedMarker = marker
    }
    
    
    //MARK: Draw path
    func drawPath(startLocation: CLLocation, endLocation: CLLocation){
        
        self.mapView.clear()
        
        self.createGoogleMarker(lat: startLocation.coordinate.latitude, long: startLocation.coordinate.longitude)
        
        self.createGoogleMarker(lat: endLocation.coordinate.latitude, long: endLocation.coordinate.longitude)
        
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
        
        Alamofire.request(url).responseJSON { response in
            
            let JSON = response.result.value as? [String: Any]
            
            let routes = JSON!["routes"] as! NSArray
            
            for route in routes {
                
                let legs : NSArray = (route as! NSDictionary).value(forKey: "legs") as! NSArray
                
                for leg in legs {
                    
                    let steps : NSArray = (leg as! NSDictionary).value(forKey: "steps") as! NSArray
                    
                    for step in steps {
                        
                        let polyline:NSDictionary = (step as! NSDictionary).value(forKey: "polyline") as! NSDictionary
                        
                        let points = polyline["points"] as? String
                        
                        let path = GMSPath(fromEncodedPath: points!)
                        
                        let polylinePath = GMSPolyline(path: path)
                        
                        polylinePath.geodesic = true
                        
                        polylinePath.strokeWidth = 4
                        
                        polylinePath.strokeColor = UIColor.blue
                        
                        polylinePath.map = self.mapView
                    }
                }
            }
        }
    }
}


//MARK: - CLLocationManager Delegate
extension MapNavigationVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedWhenInUse else {
            return
        }
        
        locationManager.startUpdatingLocation()
        
        mapView.isMyLocationEnabled = true
        
        mapView.settings.myLocationButton = false
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let userLocation = locations.last else {
            return
        }
        
        mapView.camera = GMSCameraPosition.camera(withLatitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude, zoom: 18.0)
        
        locationManager.stopUpdatingLocation()
        
        locationStart = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        
        self.drawPath(startLocation: locationStart, endLocation: locationEnd)
    }
    
}
