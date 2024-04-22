//
//  SingleBikeRide.swift
//  Go hiking
//
//  Created by Anthony Hopkins on 2021-04-23.
//

import SwiftUI
import CoreLocation
import MapKit

struct SingleHikingView: View {
    let bikeRide: Hiking
    let navigationTitle: String
    
    @EnvironmentObject var preferences: Preferences
    
    @State private var showingEditPopover = false
    
    var body: some View {
        GeometryReader { (geometry) in
            VStack {
                VStack (spacing: 0) {
                    if (preferences.namedRoutes && bikeRide.hikingRouteName != "Uncategorized") {
                        Text("\(bikeRide.hikingRouteName)")
                            .bold()
                            .padding(.top, 10)
                    }
                    MapSnapshotView(location: self.calculateCenter(latitudes: bikeRide.hikingLatitudes, longitudes: bikeRide.hikingLongitudes),
                                    span: self.calculateSpan(latitudes: bikeRide.hikingLatitudes, longitudes: bikeRide.hikingLongitudes),
                                    coordinates: self.setupCoordinates(latitudes: bikeRide.hikingLatitudes, longitudes: bikeRide.hikingLongitudes))
                        .padding(.bottom, 10)
                }
                if (min(geometry.size.width, geometry.size.height) < 600) {
                    VStack(spacing: 10) {
                        HStack {
                            Spacer()
                            HistoryMetricView(systemImageString: "location", metricName: "Distance", metricText: MetricsFormatting.formatDistance(distance: bikeRide.hikingDistance, usingMetric: preferences.usingMetric))
                            Spacer()
                            HistoryMetricView(systemImageString: "timer", metricName: "Time", metricText: MetricsFormatting.formatTime(time: bikeRide.hikingTime))
                            Spacer()
                            HistoryMetricView(systemImageString: "arrow.up.arrow.down", metricName: "Elev. Gain", metricText: MetricsFormatting.formatElevation(elevations: bikeRide.hikingElevations, usingMetric: preferences.usingMetric))
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            HistoryMetricView(systemImageString: "speedometer", metricName: "Average Speed", metricText: MetricsFormatting.formatAverageSpeed(speeds: bikeRide.hikingSpeeds, distance: bikeRide.hikingDistance, time: bikeRide.hikingTime, usingMetric: preferences.usingMetric))
                            Spacer()
                            HistoryMetricView(systemImageString: "speedometer", metricName: "Top Speed", metricText: MetricsFormatting.formatTopSpeed(speeds: bikeRide.hikingSpeeds, usingMetric: preferences.usingMetric))
                            Spacer()
                        }
                    }
                    .padding(.bottom, 10)
                }
                else {
                    HStack {
                        Spacer()
                        HStack {
                            HistoryMetricView(systemImageString: "location", metricName: "Distance", metricText: MetricsFormatting.formatDistance(distance: bikeRide.hikingDistance, usingMetric: preferences.usingMetric))
                            Spacer()
                            HistoryMetricView(systemImageString: "timer", metricName: "Time", metricText: MetricsFormatting.formatTime(time: bikeRide.hikingTime))
                            Spacer()
                            HistoryMetricView(systemImageString: "arrow.up.arrow.down", metricName: "Elev. Gain", metricText: MetricsFormatting.formatElevation(elevations: bikeRide.hikingElevations, usingMetric: preferences.usingMetric))
                            Spacer()
                            HistoryMetricView(systemImageString: "speedometer", metricName: "Average Speed", metricText: MetricsFormatting.formatAverageSpeed(speeds: bikeRide.hikingSpeeds, distance: bikeRide.hikingDistance, time: bikeRide.hikingTime, usingMetric: preferences.usingMetric))
                            Spacer()
                            HistoryMetricView(systemImageString: "speedometer", metricName: "Top Speed", metricText: MetricsFormatting.formatTopSpeed(speeds: bikeRide.hikingSpeeds, usingMetric: preferences.usingMetric))
                        }
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        Spacer()
                    }
                    .padding(.bottom, 10)
                }
            }
        }
        .navigationBarTitle(navigationTitle, displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if (preferences.namedRoutes) {
                    Button ("Edit") {
                        self.showingEditPopover = true
                    }
                }
            }
        }
        .sheet(isPresented: $showingEditPopover) {
            RouteNameModalView(showEditModal: $showingEditPopover, HikingToEdit: bikeRide)
        }
    }
    
    func setupCoordinates(latitudes: [CLLocationDegrees], longitudes: [CLLocationDegrees]) -> [CLLocationCoordinate2D] {
        var coordinates: [CLLocationCoordinate2D] = []
        
        var locationsCount = latitudes.count
        if (latitudes.count > longitudes.count) {
            locationsCount = longitudes.count
        }
        
        for index in 0..<locationsCount {
            coordinates.append(CLLocationCoordinate2DMake(latitudes[index], longitudes[index]))
        }
        
        return coordinates
    }
    
    func calculateSpan(latitudes: [CLLocationDegrees], longitudes: [CLLocationDegrees]) -> CLLocationDegrees {
        // Find the min and max latitude and longitude to find ideal span that fits entire route
        if (latitudes.count > 0 && longitudes.count > 0) {
            var maxLatitude: CLLocationDegrees = latitudes[0]
            var minLatitude: CLLocationDegrees = latitudes[0]
            var maxLongitude: CLLocationDegrees = longitudes[0]
            var minLongitude: CLLocationDegrees = longitudes[0]
            
            for latitude in latitudes {
                if (latitude < minLatitude) {
                    minLatitude = latitude
                }
                if (latitude > maxLatitude) {
                    maxLatitude = latitude
                }
            }
            
            for longitude in longitudes {
                if (longitude < minLongitude) {
                    minLongitude = longitude
                }
                if (longitude > maxLongitude) {
                    maxLongitude = longitude
                }
            }
            
            // Add 10% extra so that there is some space around the map
            let latitudeSpan = (maxLatitude - minLatitude) * 1.1
            let longitudeSpan = (maxLongitude - minLongitude) * 1.1
            return latitudeSpan > longitudeSpan ? latitudeSpan : longitudeSpan
        }
        else {
            return 0.1
        }
    }
    
    func calculateCenter(latitudes: [CLLocationDegrees], longitudes: [CLLocationDegrees]) -> CLLocationCoordinate2D {
        // Find the min and max latitude and longitude to find ideal span that fits entire route
        if (latitudes.count > 0 && longitudes.count > 0) {
            var maxLatitude: CLLocationDegrees = latitudes[0]
            var minLatitude: CLLocationDegrees = latitudes[0]
            var maxLongitude: CLLocationDegrees = longitudes[0]
            var minLongitude: CLLocationDegrees = longitudes[0]
            
            for latitude in latitudes {
                if (latitude < minLatitude) {
                    minLatitude = latitude
                }
                if (latitude > maxLatitude) {
                    maxLatitude = latitude
                }
            }
            
            for longitude in longitudes {
                if (longitude < minLongitude) {
                    minLongitude = longitude
                }
                if (longitude > maxLongitude) {
                    maxLongitude = longitude
                }
            }
            
            let latitudeMidpoint = (maxLatitude + minLatitude)/2
            let longitudeMidpoint = (maxLongitude + minLongitude)/2
            return CLLocationCoordinate2D(latitude: latitudeMidpoint, longitude: longitudeMidpoint)
        }
        else {
            return CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
    }
}
