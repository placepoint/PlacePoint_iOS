//
//  Extension+BuisnessAddress.swift
//  PlacePoint
//
//  Created by Mac on 19/06/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GooglePlaces
import GoogleMaps

//MARK: - CLLocationManager Delegate
extension BuisnessAddressVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedWhenInUse else {
            return
            
        }
        
        locationManager.startUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let userLocation = locations.last else {
            return
        }
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        let region: MKCoordinateRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView?.setRegion(region, animated: true)
        
        self.mapView?.showsUserLocation = true
        
        self.locationManager.stopUpdatingLocation()
        
        self.createMarker(coordinate: userLocation.coordinate)
    }
}


//MARK: - TextField Delegate
extension BuisnessAddressVC: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == txtFieldSelectAddress {
            
            let autoCompleteController = GMSAutocompleteViewController()
            
            autoCompleteController.delegate = self
            
            UIApplication.shared.statusBarStyle = .lightContent
            
            autoCompleteController.modalPresentationStyle = .custom
            
            self.present(autoCompleteController, animated: true, completion: nil)
            
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
}


//MARK: - GMSAutocompleteViewController Delegate
extension BuisnessAddressVC: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        strStNumFirst = ""
        
        strStNumSec = ""
        
        txtFieldAddressLine1.text = ""
        
        txtFieldAddressLine2.text = ""
        
        var strAddress = ""
        
        if place.name != "" {
            
            strStNumFirst = strStNumFirst + place.name
            
            txtFieldAddressLine1.text = strStNumFirst
        }
        if place.formattedAddress != "," {
            
            strStNumSec = strStNumSec + place.formattedAddress! + ","
            
            txtFieldAddressLine2.text = strStNumSec
        }
        
        txtFieldSelectAddress.text = "\(strStNumFirst),\(strStNumSec)"
        
        if let addressLines = place.addressComponents {
            
            if txtFieldSelectAddress.text == "" {
                
                txtFieldSelectAddress.text = streetNumberStr
            }
            
            self.placesMapKit(place: place)
        
        }
    }
    
    
    // get Address name from coordinates
    func getAdressName(coords: CLLocation) {
        
        CLGeocoder().reverseGeocodeLocation(coords) { (placemark, error) in
            
            if error != nil {
                
                print("Error")
                
            }
            else {
                
                let place = placemark! as [CLPlacemark]
                
                if place.count > 0 {
                    
                    let place = placemark![0]
                    
                    var adressString : String = ""
                    
                    var fullAddressString: String = ""
                    
                    self.txtFieldAddressLine1.text = place.addressDictionary!["SubLocality"] as? String
                    
                    adressString = (self.txtFieldAddressLine1.text?.trim())!
                    
                    let addressLine = place.addressDictionary!["FormattedAddressLines"] as? NSArray
                    
                    let strAddress = addressLine?.componentsJoined(by: ",")
                    
                    self.txtFieldAddressLine2.text = strAddress
                    
                    fullAddressString = self.txtFieldAddressLine2.text!.trim()
                    
                    self.txtFieldSelectAddress.text = "\(fullAddressString)"
                    
                }
                
            }
        }
    }
    
    
    func viewController(_ viewController: GMSAutocompleteViewController,
                        didSelect prediction: GMSAutocompletePrediction) -> Bool {
        
        
        let str = String(format:"%@", prediction.attributedPrimaryText)
        
        let strSep = "{"
        
        let strFinal = str.components(separatedBy: strSep)
        
        let strNew = NSString(format:"%@", strFinal[0])
        
        let modified = strNew.replacingOccurrences(of: " ", with: ",")
        
        let delimiter = ","
        
        var token = modified.components(separatedBy: delimiter)
        
        streetNumberStr = token[0]
        
        self.dismiss(animated: true, completion: nil)
        
        return true;
    }
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        
        dismiss(animated: true, completion: nil)
    }
}
