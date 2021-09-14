//
//  LocationUtility.swift
//  PlacesDemo
//
//  Created by August Patterson on 9/14/21.
//

import UIKit
import CoreLocation
import Combine

protocol LocationUtilityProtocol {
    func hasRequested() -> Bool
    func hasPermission() -> Bool
    func requestPermission()

    var locationTuple: CurrentValueSubject<(latitude: Double, longitude: Double)?, Never> {get set}
}


class LocationUtility: NSObject, CLLocationManagerDelegate, LocationUtilityProtocol {

    var locationTuple: CurrentValueSubject<(latitude: Double, longitude: Double)?, Never> = CurrentValueSubject.init(nil)
    
// Create a CLLocationManager and assign a delegate
    lazy var locationManager : CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.startUpdatingLocation()
        return manager
    }()

    //MARK: Getting Location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationTuple.send( (latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) )
        }
    }
    
    //MARK: Permissions
    func hasRequested() -> Bool {
        switch locationManager.authorizationStatus{
        case .notDetermined:
            return false
        default:
            return true
        }
    }
    
    func hasPermission() -> Bool {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default:
            return false
        }
    }
    
    func requestPermission() {
        if !hasRequested(){
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("CLLocationManager error \(error)")
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("locationManagerDidChangeAuthorization \(locationManager.authorizationStatus.rawValue)")
    }
}


enum LocationPermission {
    case allowed
    case notAllowed
    case notAsked
}
