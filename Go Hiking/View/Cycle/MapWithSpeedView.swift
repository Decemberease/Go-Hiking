//
//  MapWithSpeedView.swift
//  Go Hiking
//
//  Created by Anthony Hopkins on 2021-04-15.
//

import SwiftUI
import CoreLocation

struct MapWithSpeedView: View {
    
    @EnvironmentObject var hikingStatus: HikingStatus
    
    @Binding var hikingStartTime: Date
    @Binding var timeHiking: TimeInterval
    var screenWidth: CGFloat
    
    @StateObject var locationManager = LocationViewModel.locationManager
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var preferences: Preferences
    
    @State var mapCentered: Bool = true
    
    var body: some View {
        ZStack {
            MapView(centerMapOnLocation: $mapCentered, hikingStartTime: $hikingStartTime, timeHiking: $timeHiking)
            VStack {
                if (preferences.largeMetrics) {
                    LargeMetricsView(currentSpeed: $locationManager.hikingSpeed, currentAltitude: $locationManager.hikingAltitude, currentDistance: $locationManager.hikingTotalDistance, screenWidth: screenWidth)
                }
                else {
                    SmallMetricsView(currentSpeed: $locationManager.hikingSpeed, currentAltitude: $locationManager.hikingAltitude, currentDistance: $locationManager.hikingTotalDistance)
                }
                Spacer()
                HStack {
                    Spacer()
                    ZStack {
                        if (mapCentered) {
                            Button (action: {self.toggleMapCentered()}) {
                                MapSystemImageButton(systemImageString: "lock", buttonColour: (UserPreferences.convertColourChoiceToUIColor(colour: preferences.colourChoiceConverted)))
                                    .padding(.bottom, 5)
                                }
                        }
                        else {
                            Button (action: {self.toggleMapCentered()}) {
                                MapSystemImageButton(systemImageString: "lock.open", buttonColour: (UserPreferences.convertColourChoiceToUIColor(colour: preferences.colourChoiceConverted)))
                                    .padding(.bottom, 5)
                                }
                        }
                    }
                    Spacer()
                }
            }
        }
        Spacer()
    }
    
    func toggleMapCentered() {
        self.mapCentered = self.mapCentered ? false : true
    }
}

struct MapWithSpeedView_Previews: PreviewProvider {
    static var previews: some View {
        MapWithSpeedView(hikingStartTime: .constant(Date()), timeHiking: .constant(10), screenWidth: UIScreen.main.bounds.width)
    }
}
