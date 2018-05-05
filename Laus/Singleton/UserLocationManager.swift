//
//  UserLocationManager.swift
//  Laus
//
//  Created by Lord Summerisle on 1/10/18.
//  Copyright © 2018 ErmanMaris. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class UserLocationManager: NSObject {
    
    private override init() {}
    static let sharedInstance = UserLocationManager()
    var locationManager: CLLocationManager!

    var postalCode: String?
    var administrativeArea: String?
    var locality: String?
    var areaOfInterest: String?
    var name: String?
    var thoroughfare: String?
    var address: String?
    
    func formatAddress(name: String, areaOfInterest: String, administrativeArea: String) -> String {
        return name + " " + areaOfInterest + " " + " " + administrativeArea
    }
    
    func getUserLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    fileprivate func reverseGeocoding(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { [weak self] (placemarks, error) -> Void in
            guard let strongSelf = self else { return }
            
            if error != nil {
                return
            } else {
                if let placeMark = placemarks?.first {
                    strongSelf.postalCode = placeMark.postalCode
                    strongSelf.administrativeArea = placeMark.administrativeArea
                    strongSelf.locality = placeMark.locality
                    strongSelf.areaOfInterest = placeMark.areasOfInterest?.first
                    strongSelf.name = placeMark.name
                    strongSelf.thoroughfare = placeMark.thoroughfare
                    if let name = placeMark.name, let areaOfInterest = placeMark.areasOfInterest?.first, let administrativeArea = placeMark.administrativeArea {
                        strongSelf.address = strongSelf.formatAddress(name: name, areaOfInterest: areaOfInterest, administrativeArea: administrativeArea)
                    }
                }
            }
        })
    }
}

extension UserLocationManager: CLLocationManagerDelegate, MKMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            let locationValues: CLLocationCoordinate2D = location.coordinate
            locationManager.stopUpdatingLocation()
            reverseGeocoding(latitude: locationValues.latitude, longitude: locationValues.longitude)
        }
    }
}
