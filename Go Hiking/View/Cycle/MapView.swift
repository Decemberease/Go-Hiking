//
//  MapView.swift
//  Go Hiking
//
//  Created by Anthony Hopkins on 2021-04-09.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: UIViewRepresentable {
    typealias UIViewType = MKMapView
    
    let persistenceController = PersistenceController.shared

    @EnvironmentObject var hikingStatus: HikingStatus
    
    @StateObject var locationManager = LocationViewModel.locationManager
    
    @Binding var centerMapOnLocation: Bool
    @Binding var hikingStartTime: Date
    @Binding var timeHiking: TimeInterval
    
    @Environment(\.managedObjectContext) private var managedObjectContext
    @EnvironmentObject var preferences: Preferences
    @EnvironmentObject var records: HikingRecords
    
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }
        
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    
    func makeCoordinator() -> MapView.Coordinator {
        Coordinator(self, colour: UserPreferences.convertColourChoiceToUIColor(colour: preferences.colourChoiceConverted))
    }

    final class Coordinator: NSObject, MKMapViewDelegate {
        var control: MapView
        var colour: UIColor

        init(_ control: MapView, colour: UIColor) {
            self.control = control
            self.colour = colour
        }

        //Managing the Display of Overlays
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let polylineRenderer = MKPolylineRenderer(overlay: polyline)
                polylineRenderer.strokeColor = colour
                polylineRenderer.lineWidth = 8
                return polylineRenderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }

    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        view.showsUserLocation = true
        
        let authStatus = locationManager.statusString
        
        if (authStatus == "authorizedAlways" || authStatus == "authorizedWhenInUse") {
            let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(userLatitude)!, CLLocationDegrees(userLongitude)!)
            let span = MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)
            let region = MKCoordinateRegion(center: location, span: span)
            if (centerMapOnLocation) {
                view.setRegion(region, animated: true)
            }
            
            // Need to maintain the cyclists route if they are currently hiking
            if hikingStatus.isHiking {
                if (!startedHiking) {
                    startedHiking = true
                    locationManager.startedHiking()
                }
                let locationsCount = locationManager.hikingLocations.count
                switch locationsCount {
                case _ where locationsCount < 2:
                    break
                default:
                    var locationsToRoute : [CLLocationCoordinate2D] = []
                    for location in locationManager.hikingLocations {
                        if (location != nil) {
                            locationsToRoute.append(location!.coordinate)
                        }
                    }
                    if (locationsToRoute.count > 1 && locationsToRoute.count <= locationManager.hikingLocations.count) {
                        let route = MKPolyline(coordinates: locationsToRoute, count: locationsCount)
                        view.addOverlay(route)
                        
                        // Update stroke colour if user changes colour preference after renderer was created
                        if let renderer = view.renderer(for: route) as? MKPolylineRenderer {
                            if (renderer.strokeColor != UserPreferences.convertColourChoiceToUIColor(colour: preferences.colourChoiceConverted)) {
                                renderer.strokeColor =  UserPreferences.convertColourChoiceToUIColor(colour: preferences.colourChoiceConverted)
                            }
                        }
                    }
                }
            }
            else {
                // Means we need to store the current route and clear the map
                if (startedHiking) {
                    startedHiking = false
                    let overlays = view.overlays
                    view.removeOverlays(overlays)
                    persistenceController.storeBikeRide(locations: locationManager.hikingLocations,
                                                        speeds: locationManager.hikingSpeeds,
                                                        distance: locationManager.hikingTotalDistance,
                                                        elevations: locationManager.hikingAltitudes,
                                                        startTime: hikingStartTime,
                                                        time: timeHiking)
                    
                    // Update HikingRecords with thise new entry in case any new records were set
                    records.updateHikingRecords(speeds: locationManager.hikingSpeeds, distance: locationManager.hikingTotalDistance, startTime: hikingStartTime, time: timeHiking)
                    
                    locationManager.clearLocationArray()
                    locationManager.stopTrackingBackgroundLocation()
                }
            }
            view.delegate = context.coordinator
        }
    }
}

var startedHiking = false

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(centerMapOnLocation: .constant(true), hikingStartTime: .constant(Date()), timeHiking: .constant(10))
    }
}
