//
//  BuisnessAddressVC.swift
//  PlacePoint
//
//  Created by Mac on 05/06/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GooglePlaces
import GoogleMaps

protocol SelectedAddress: class {
    
    func addressSelected(address: String,lat: CLLocationDegrees, long: CLLocationDegrees)
}

class BuisnessAddressVC: UIViewController {
    
    @IBOutlet weak var txtFieldSelectAddress: UITextField!
    
    @IBOutlet weak var tblSearchLocaion: UITableView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var txtFieldAddressLine1: UITextField!
    
    @IBOutlet weak var txtFieldAddressLine2: UITextField!
    
    @IBOutlet weak var txtFieldAddressLine3: UITextField!
    
    @IBOutlet weak var txtFieldAddressLine4: UITextField!
    
    
    var locationManager = CLLocationManager()
    
    var txtSearch = ""
    
    var streetNumberStr = ""
    
    var strStNumFirst = ""
    
    var strStNumSec = ""
    
    var lat = CLLocationDegrees()
    
    var long = CLLocationDegrees()
    
    var delegate: SelectedAddress?
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        locationManager = CLLocationManager()
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.requestWhenInUseAuthorization()
            
            locationManager.startUpdatingLocation()
        }
        
        locationManager.delegate = self
        
        txtFieldSelectAddress.delegate = self
        
        txtFieldAddressLine1.delegate = self
        
        txtFieldAddressLine2.delegate = self
        
        self.keyBoardNotify()
        
        self.setNavigation()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return UIStatusBarStyle.lightContent
    }
    
    
    //MARK: - KeyBoard Notification
    func keyBoardNotify() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    //MARK: - Keyboard Methods
    @objc func keyboardWillShow(notification: NSNotification) {
        
        self.view.frame.origin.y = -150
        
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if UIScreen.main.bounds.size.height == 812 {
            
            self.view.frame.origin.y = 85
        }
        else {
            
            self.view.frame.origin.y = 65
        }
    }
    
    
    //MARK: - SetUp Navigation
    func setNavigation() {
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.makeColorNavigationBar(titleName: "")
        
        self.navigationItem.navTitle(title: "Location")
        
        let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(backButtonTapped))
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
    }
    
    
    @objc func doneButtonTapped() {
        
        guard let address1 = txtFieldAddressLine1.text?.trim(), let address2 = txtFieldAddressLine2.text?.trim() else{
            
            return
        }
        txtSearch = ("\(address2)")
        
        if self.lat != nil && self.long != nil {
            
            delegate?.addressSelected(address: txtSearch, lat: self.lat,long: self.long )
        }
        else {
            
            delegate?.addressSelected(address: txtSearch, lat: (locationManager.location?.coordinate.latitude)!,long: (locationManager.location?.coordinate.longitude)! )
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @objc func backButtonTapped() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    //MARK: - Create Marker
    func createMarker(coordinate: CLLocationCoordinate2D) {
        
        self.lat = coordinate.latitude
        
        self.long = coordinate.longitude
        
        let mapAnnotation = MKPointAnnotation()
        
        mapAnnotation.coordinate = coordinate
        
        mapView.showsUserLocation = false
        
        mapView.addAnnotation(mapAnnotation)
        
        let currentLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        if txtFieldSelectAddress.text == "" {
            
            self.getAdressName(coords: currentLocation)
            
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    
    //MARK: - fetch AppleMap Place from GMSAutoCompleteController
    func placesMapKit(place: GMSPlace) {
        
        let center = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView?.setRegion(region, animated: true)
        
        self.createMarker(coordinate: place.coordinate)
        
    }
    
    
    //MARK: - Button Actions
    @IBAction func btnCloseAction(_ sender: UIButton) {
        
        txtFieldSelectAddress.text = ""
    }
}
