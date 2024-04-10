//
//  ContentView.swift
//  Go Hiking
//
//  Created by Anthony Hopkins on 2021-03-14.
//

import SwiftUI

struct HikeView: View {
    
    @EnvironmentObject var hikingStatus: HikingStatus
    
    @StateObject var timer = TimerViewModel()
    @State private var showingAlert = false
    @State private var hikingSpeed = 0.0
    @State private var hikingStartTime = Date()
    @State private var timeHiking = 0.0
    @State private var showingRouteNamingPopover = false
    
    @EnvironmentObject var preferences: Preferences
    
    var body: some View {
        GeometryReader { (geometry) in
            VStack {
                MapWithSpeedView(hikingStartTime: $hikingStartTime, timeHiking: $timeHiking, screenWidth: geometry.size.width)
                Text(formatTimeString(accumulatedTime: timer.totalAccumulatedTime))
                    .font(.custom("Avenir", size: 40))
                Spacer()
                HStack {
                    if (timer.isRunning) {
                        Button (action: {self.timer.pause()}) {
                            TimerButton(label: "Pause", buttonColour: UIColor.systemYellow)
                                .padding(.bottom, 20)
                                .minimumScaleFactor(0.3)
                                .lineLimit(1)
                        }
                        Button (action: {self.confirmStop()}) {
                            TimerButton(label: "Stop", buttonColour: UIColor.systemRed)
                                .padding(.bottom, 20)
                                .minimumScaleFactor(0.3)
                                .lineLimit(1)
                        }
                    }
                    if (timer.isStopped) {
                        Button (action: {self.startHiking()}) {
                            TimerButton(label: "Start", buttonColour: UIColor.systemGreen)
                                .padding(.bottom, 20)
                                .minimumScaleFactor(0.3)
                                .lineLimit(1)
                        }
                    }
                    if (timer.isPaused) {
                        Button (action: {self.timer.start()}) {
                            TimerButton(label: "Resume", buttonColour: UIColor.systemGreen)
                                .padding(.bottom, 20)
                                .minimumScaleFactor(0.3)
                                .lineLimit(1)
                        }
                        Button (action: {self.confirmStop()}) {
                            TimerButton(label: "Stop", buttonColour: UIColor.systemRed)
                                .padding(.bottom, 20)
                                .minimumScaleFactor(0.3)
                                .lineLimit(1)
                        }
                    }
                }
                Spacer()
            }
            // Confirmation alert about ending the current route
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Are you sure that you want to end the current route?"),
                      message: Text("Please confirm that you are ready to end the current route."),
                      primaryButton: .destructive(Text("Stop")) {
                        self.timeHiking = timer.totalAccumulatedTime
                        self.timer.stop()
                        hikingStatus.stoppedHiking()
                        
                        // Present route naming popover if necessary
                        if (preferences.namedRoutes) {
                            self.showingRouteNamingPopover = true
                        }
                      },
                      secondaryButton: .cancel()
                )
            }
            .sheet(isPresented: $showingRouteNamingPopover) {
                RouteNameModalView(showEditModal: $showingRouteNamingPopover, bikeRideToEdit: nil)
            }
        }
    }
    
    func formatTimeString(accumulatedTime: TimeInterval) -> String {
        let hours = Int(accumulatedTime) / 3600
        let minutes = Int(accumulatedTime) / 60 % 60
        let seconds = Int(accumulatedTime) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func startHiking() {
        hikingStatus.startedHiking()
        self.hikingStartTime = Date()
        self.timeHiking = 0.0
        self.timer.start()
    }
    
    func confirmStop() {
        // Completing a route is a review worthy event
        ReviewManager.incrementReviewWorthyCount()
        // Keep track of whether user has completed a route
        ReviewManager.completedRoute()
        self.timer.pause()
        showingAlert = true
    }
}

struct HikeView_Previews: PreviewProvider {
    static var previews: some View {
        HikeView()
    }
}
