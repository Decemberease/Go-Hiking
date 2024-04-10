//
//  LocationViewModel.swift
//  Go hiking
//
//  Created by Anthony Hopkins on 2021-04-11.
//

import Foundation
import CoreLocation
import Combine

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {

    // A singleton for the entire app - there should be only 1 instance of this class
    static let locationManager = LocationViewModel()
    
    private let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?
    @Published var hikingLocations: [CLLocation?] = []
    @Published var hikingSpeed: CLLocationSpeed?
    @Published var hikingSpeeds: [CLLocationSpeed?] = []
    @Published var hikingAltitude: CLLocationDistance?
    @Published var hikingAltitudes: [CLLocationDistance?] = []
    @Published var hikingDistances: [CLLocationDistance?] = []
    @Published var hikingTotalDistance: CLLocationDistance = 0.0

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = 10
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        hikingLocations.append(lastLocation)
        hikingSpeed = location.speed
        hikingAltitude = location.altitude
        hikingSpeeds.append(hikingSpeed)
        hikingAltitudes.append(hikingAltitude)
        
        // Add location to array
        let locationsCount = hikingLocations.count
        if (locationsCount > 1) {
            let newDistanceInMeters = lastLocation?.distance(from: (hikingLocations[locationsCount - 2] ?? lastLocation)!)
            hikingDistances.append(newDistanceInMeters)
            hikingTotalDistance += newDistanceInMeters ?? 0.0
        }
    }
    
    func startedHiking() {
        // Setup background location checking if authorized
        if locationStatus == .authorizedAlways {
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.allowsBackgroundLocationUpdates = true
        }
        // Clear every location except most recent point
        let locationsCount = hikingLocations.count
        if (locationsCount > 1) {
            let locationToKeep = hikingLocations[locationsCount - 1]
            hikingLocations.removeAll()
            hikingLocations.append(locationToKeep)
        }
        // Clear all distances
        hikingDistances.removeAll()
        hikingSpeeds.removeAll()
        hikingAltitudes.removeAll()
        hikingTotalDistance = 0.0
    }
    
    func clearLocationArray() {
        hikingLocations.removeAll()
        hikingDistances.removeAll()
        hikingSpeeds.removeAll()
        hikingAltitudes.removeAll()
        hikingTotalDistance = 0.0
    }
    
    func stopTrackingBackgroundLocation() {
        // There is no reason to allow background location updates if the user is not actively hiking
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.allowsBackgroundLocationUpdates = false
    }
}
