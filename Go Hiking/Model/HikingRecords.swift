//
//  Records.swift
//  Go Hiking
//
//  Created by Anthony Hopkins on 2022-04-15.
//

import Foundation
import MapKit

// Class to represent the Hiking records of a user
class HikingRecords: ObservableObject {
    
    // Singleton instance
    static let shared: HikingRecords = HikingRecords()
    
    @Published var totalHikingTime: Double
    @Published var totalHikingRoutes: Int
    @Published var unlockedIcons: [Bool]
    @Published var longestHikingDistance: Double
    @Published var longestHikingTime: Double
    @Published var fastestAverageSpeed: Double
    @Published var fastestAverageSpeedDate: Date?
    @Published var longestHikingDistanceDate: Date?
    @Published var longestHikingTimeDate: Date?
    // Total Hiking distance is always changed last as the ActivityAwardsViewModel publishes changes when it changes
    @Published var totalHikingDistance: Double
    
    static private let initKey = "didSetupRecords"
    static private let keys = ["totalHikingTime", "totalHikingDistance", "unlockedIcons", "longestHikingDistance", "longestHikingTime", "fastestAverageSpeed", "fastestAverageSpeedDate", "longestHikingDistanceDate", "longestHikingTimeDate", "totalHikingRoutes"]
    static private let keyTypes = [2, 2, 0, 2, 2, 2, 3, 3, 3, 1] // 0: [Bool], 1: Int, 2: Double, 3: Date
    
    static private let numberOfUnlockableIcons = 6
    static let awardValues: [Double] = [10.0 * 1000, 25.0 * 1000, 50.0 * 1000, 100.0 * 1000, 250.0 * 1000, 500.0 * 1000]
    
    init() {
        // First check if iCloud is available
        let iCloudStatus = Preferences.iCloudAvailable()
        
        // Next check if records have ever been setup
        var status = HikingRecords.haveHikingRecordsBeenInitialized()
        
        // On device only if iCloud is off
        if !iCloudStatus {
            if (UserDefaults.standard.object(forKey: HikingRecords.initKey) == nil) {
                status = 0
            }
            else {
                status = 1
            }
        }
        
        switch status {
        // Nothing is setup
        case 0:
            HikingRecords.writeDefaults(iCloud: false)
            UserDefaults.standard.set(true, forKey: HikingRecords.initKey)
            if iCloudStatus {
                HikingRecords.writeDefaults(iCloud: true)
                NSUbiquitousKeyValueStore.default.set(true, forKey: HikingRecords.initKey)
            }
        // On device is setup
        case 1:
            if iCloudStatus {
                HikingRecords.syncLocalAndCloud(localToCloud: true)
                NSUbiquitousKeyValueStore.default.set(true, forKey: HikingRecords.initKey)
            }
        // iCloud is setup
        case 2:
            if iCloudStatus {
                HikingRecords.syncLocalAndCloud(localToCloud: false)
                UserDefaults.standard.set(true, forKey: HikingRecords.initKey)
            }
        // Everything is setup
        case 3:
            if iCloudStatus {
                HikingRecords.syncLocalAndCloud(localToCloud: false)
            }
        default:
            fatalError("Index out of range")
        }
        
        // Set class attributes based on local copy of data
        self.totalHikingTime = UserDefaults.standard.double(forKey: HikingRecords.keys[0])
        self.totalHikingDistance = UserDefaults.standard.double(forKey: HikingRecords.keys[1])
        self.unlockedIcons = UserDefaults.standard.array(forKey: HikingRecords.keys[2]) as! [Bool]
        self.longestHikingDistance = UserDefaults.standard.double(forKey: HikingRecords.keys[3])
        self.longestHikingTime = UserDefaults.standard.double(forKey: HikingRecords.keys[4])
        self.fastestAverageSpeed = UserDefaults.standard.double(forKey: HikingRecords.keys[5])
        self.fastestAverageSpeedDate = UserDefaults.standard.object(forKey: HikingRecords.keys[6]) as? Date
        self.longestHikingDistanceDate = UserDefaults.standard.object(forKey: HikingRecords.keys[7]) as? Date
        self.longestHikingTimeDate = UserDefaults.standard.object(forKey: HikingRecords.keys[8]) as? Date
        self.totalHikingRoutes = UserDefaults.standard.integer(forKey: HikingRecords.keys[9])
        
        // Used to watch for iCloud NSUbiquitousKeyValueStore change events to sync records from other devices
        NotificationCenter.default.addObserver(self, selector: #selector(keysDidChangeOnCloud(notification:)),
                                                       name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                                                       object: nil)
    }
    
    @objc func keysDidChangeOnCloud(notification: Notification) {
        // Force this update to run on the main thread, but asynchronously
        DispatchQueue.main.async {
            HikingRecords.syncLocalAndCloud(localToCloud: false)
            self.writeToClassMembers()
        }
    }
    
    private func writeToClassMembers() {
        self.totalHikingTime = UserDefaults.standard.double(forKey: HikingRecords.keys[0])
        self.totalHikingDistance = UserDefaults.standard.double(forKey: HikingRecords.keys[1])
        self.unlockedIcons = UserDefaults.standard.array(forKey: HikingRecords.keys[2]) as! [Bool]
        self.longestHikingDistance = UserDefaults.standard.double(forKey: HikingRecords.keys[3])
        self.longestHikingTime = UserDefaults.standard.double(forKey: HikingRecords.keys[4])
        self.fastestAverageSpeed = UserDefaults.standard.double(forKey: HikingRecords.keys[5])
        self.fastestAverageSpeedDate = UserDefaults.standard.object(forKey: HikingRecords.keys[6]) as? Date
        self.longestHikingDistanceDate = UserDefaults.standard.object(forKey: HikingRecords.keys[7]) as? Date
        self.longestHikingTimeDate = UserDefaults.standard.object(forKey: HikingRecords.keys[8]) as? Date
        self.totalHikingRoutes = UserDefaults.standard.integer(forKey: HikingRecords.keys[9])
    }
    
    // 0: Nothing setup, 1: On device setup, 2: iCloud setup, 3: Both iCloud and on device setup
    static private func haveHikingRecordsBeenInitialized() -> Int {
        if (!UserDefaults.standard.bool(forKey: initKey) && !NSUbiquitousKeyValueStore.default.bool(forKey: initKey)) {
            return 0
        }
        else if (UserDefaults.standard.bool(forKey: initKey) && !NSUbiquitousKeyValueStore.default.bool(forKey: initKey)) {
            return 1
        }
        else if (!UserDefaults.standard.bool(forKey: initKey) && NSUbiquitousKeyValueStore.default.bool(forKey: initKey)) {
            return 2
        }
        else {
            return 3
        }
    }
    
    static private func writeDefaults(iCloud: Bool) {
        // Use NSUbiquitousKeyValueStore for iCloud storage
        if iCloud {
            NSUbiquitousKeyValueStore.default.set(0.0, forKey: keys[0])
            NSUbiquitousKeyValueStore.default.set(0.0, forKey: keys[1])
            NSUbiquitousKeyValueStore.default.set([Bool].init(repeating: false, count: numberOfUnlockableIcons), forKey: keys[2])
            NSUbiquitousKeyValueStore.default.set(0.0, forKey: keys[3])
            NSUbiquitousKeyValueStore.default.set(0.0, forKey: keys[4])
            NSUbiquitousKeyValueStore.default.set(0.0, forKey: keys[5])
            NSUbiquitousKeyValueStore.default.set(0, forKey: keys[9])
        }
        // Use UserDefaults for local storage
        else {
            UserDefaults.standard.set(0.0, forKey: keys[0])
            UserDefaults.standard.set(0.0, forKey: keys[1])
            UserDefaults.standard.set([Bool].init(repeating: false, count: numberOfUnlockableIcons), forKey: keys[2])
            UserDefaults.standard.set(0.0, forKey: keys[3])
            UserDefaults.standard.set(0.0, forKey: keys[4])
            UserDefaults.standard.set(0.0, forKey: keys[5])
            UserDefaults.standard.set(0, forKey: keys[9])
        }
    }
    
    // Function to write class members to UserDefaults (used when updating the HikingRecords after a new completed bike ride)
    private func writeClassMembersToUserDefaults() {
        UserDefaults.standard.set(self.totalHikingTime, forKey: HikingRecords.keys[0])
        UserDefaults.standard.set(self.totalHikingDistance, forKey: HikingRecords.keys[1])
        UserDefaults.standard.set(self.unlockedIcons, forKey: HikingRecords.keys[2])
        UserDefaults.standard.set(self.longestHikingDistance, forKey: HikingRecords.keys[3])
        UserDefaults.standard.set(self.longestHikingTime, forKey: HikingRecords.keys[4])
        UserDefaults.standard.set(self.fastestAverageSpeed, forKey: HikingRecords.keys[5])
        
        if let date = self.fastestAverageSpeedDate {
            UserDefaults.standard.set(date, forKey: HikingRecords.keys[6])
        }
        if let date = self.longestHikingDistanceDate {
            UserDefaults.standard.set(date, forKey: HikingRecords.keys[7])
        }
        if let date = self.longestHikingTimeDate {
            UserDefaults.standard.set(date, forKey: HikingRecords.keys[8])
        }
        
        UserDefaults.standard.set(self.totalHikingRoutes, forKey: HikingRecords.keys[9])
    }
    
    static private func syncLocalAndCloud(localToCloud: Bool) {
        // Sync local to cloud
        if localToCloud {
            for (i, k) in keys.enumerated() {
                switch keyTypes[i] {
                // Integer
                case 1:
                    NSUbiquitousKeyValueStore.default.set(UserDefaults.standard.integer(forKey: k), forKey: k)
                // Double
                case 2:
                    NSUbiquitousKeyValueStore.default.set(UserDefaults.standard.double(forKey: k), forKey: k)
                // Date?
                case 3:
                    if let date = UserDefaults.standard.object(forKey: k) as? Date {
                        NSUbiquitousKeyValueStore.default.set(date, forKey: k)
                    }
                // [Bool]
                default:
                    NSUbiquitousKeyValueStore.default.set(UserDefaults.standard.array(forKey: k) as! [Bool], forKey: k)
                }
            }
            NSUbiquitousKeyValueStore.default.synchronize()
        }
        // Sync cloud to local
        else {
            for (i, k) in keys.enumerated() {
                switch keyTypes[i] {
                // Integer
                case 1:
                    UserDefaults.standard.set(NSUbiquitousKeyValueStore.default.object(forKey: k) as! Int, forKey: k)
                // Double
                case 2:
                    UserDefaults.standard.set(NSUbiquitousKeyValueStore.default.double(forKey: k), forKey: k)
                // Date?
                case 3:
                    if let date = NSUbiquitousKeyValueStore.default.object(forKey: k) as? Date {
                        UserDefaults.standard.set(date, forKey: k)
                    }
                // [Bool]
                default:
                    UserDefaults.standard.set(NSUbiquitousKeyValueStore.default.array(forKey: k) as! [Bool], forKey: k)
                }
            }
        }
    }
    
    // Should only ever be called once - used to migrate legacy Records to UserDefaults and NSUbiquitousKeyValueStore or create Records from existing BikeRides
    public func initialRecordsMigration(existingRecords: Records?, existingHikings: [Hiking]) {
        if let records = existingRecords {
            UserDefaults.standard.set(records.totalHikingTime, forKey: HikingRecords.keys[0])
            UserDefaults.standard.set(records.totalHikingDistance, forKey: HikingRecords.keys[1])
            UserDefaults.standard.set(records.unlockedIcons, forKey: HikingRecords.keys[2])
            UserDefaults.standard.set(records.longestHikingDistance, forKey: HikingRecords.keys[3])
            UserDefaults.standard.set(records.longestHikingTime, forKey: HikingRecords.keys[4])
            UserDefaults.standard.set(records.fastestAverageSpeed, forKey: HikingRecords.keys[5])
            
            if let date = records.fastestAverageSpeedDate {
                UserDefaults.standard.set(date, forKey: HikingRecords.keys[6])
            }
            if let date = records.longestHikingDistanceDate {
                UserDefaults.standard.set(date, forKey: HikingRecords.keys[7])
            }
            if let date = records.longestHikingTimeDate {
                UserDefaults.standard.set(date, forKey: HikingRecords.keys[8])
            }
            
            UserDefaults.standard.set(Int(records.totalHikingRoutes), forKey: HikingRecords.keys[9])
        }
        else {
            if existingHikings.count > 0 {
                let values = Records.getDefaultRecordsValues(Hikings: existingHikings)
                
                UserDefaults.standard.set(values.totalTime, forKey: HikingRecords.keys[0])
                UserDefaults.standard.set(values.totalDistance, forKey: HikingRecords.keys[1])
                UserDefaults.standard.set(values.unlockedIcons, forKey: HikingRecords.keys[2])
                UserDefaults.standard.set(values.longestDistance, forKey: HikingRecords.keys[3])
                UserDefaults.standard.set(values.longestTime, forKey: HikingRecords.keys[4])
                UserDefaults.standard.set(values.fastestAvgSpeed, forKey: HikingRecords.keys[5])
                
                if let date = values.fastestAvgSpeedDate {
                    UserDefaults.standard.set(date, forKey: HikingRecords.keys[6])
                }
                if let date = values.longestDistanceDate {
                    UserDefaults.standard.set(date, forKey: HikingRecords.keys[7])
                }
                if let date = values.longestTimeDate {
                    UserDefaults.standard.set(date, forKey: HikingRecords.keys[8])
                }
                
                UserDefaults.standard.set(Int(values.totalRoutes), forKey: HikingRecords.keys[9])
            }
        }
        
        // Sync to iCloud
        HikingRecords.syncLocalAndCloud(localToCloud: true)
        
        // Update class members
        self.writeToClassMembers()
    }
    
    // Updates HikingRecords after a new bike ride has been completed
    public func updateHikingRecords(speeds: [CLLocationSpeed?], distance: Double, startTime: Date, time: Double) {
        self.totalHikingDistance = self.totalHikingDistance + distance
        self.totalHikingTime = self.totalHikingTime + time
        self.longestHikingDistanceDate = distance > self.longestHikingDistance ? startTime : self.longestHikingDistanceDate
        self.longestHikingDistance = max(distance, self.longestHikingDistance)
        self.longestHikingTimeDate = time > self.longestHikingTime ? startTime : self.longestHikingTimeDate
        self.longestHikingTime = max(time, self.longestHikingTime)
        
        var bestAvgSpeed: Double = self.fastestAverageSpeed
        var bestAvgSpeedDate: Date? = self.fastestAverageSpeedDate
        let speedsValidated = speeds.compactMap { $0 }
        // Only count fastest average speed if route was 1 KM or longer
        if (speedsValidated.count > 0 && distance > 999) {
            let maxSpeed = speedsValidated.max()
            let avgSpeed = distance/time
            // Must be a valid average speed
            if (maxSpeed ?? 0.0 >= avgSpeed && avgSpeed > self.fastestAverageSpeed) {
                bestAvgSpeed = avgSpeed
                bestAvgSpeedDate = startTime
            }
        }
        
        self.fastestAverageSpeed = bestAvgSpeed
        self.fastestAverageSpeedDate = bestAvgSpeedDate
        
        self.totalHikingRoutes = self.totalHikingRoutes + 1
        
        // Update UserDefaults
        self.writeClassMembersToUserDefaults()
        
        HikingRecords.syncLocalAndCloud(localToCloud: true)
        
        // Update unlocked icons
        self.updateUnlockedIcons()
    }
    
    // Determines unlocked icons bool array based on class members
    public func updateUnlockedIcons() {
        var newUnlockedIcons = [Bool].init(repeating: false, count: HikingRecords.numberOfUnlockableIcons)
        var change = false
        
        for index in 0..<self.unlockedIcons.count {
            // Leave as true if already set
            if self.unlockedIcons[index] == true {
                newUnlockedIcons[index] = true
                continue
            }
            else {
                // Indexes 0-2 are for individual ride distance records
                if (index < 3) {
                    if (self.longestHikingDistance >= HikingRecords.awardValues[index]) {
                        self.unlockedIcons[index] = true
                        newUnlockedIcons[index] = true
                        change = true
                    }
                }
                // Indexes 3-5 are for total distance records
                else {
                    if (self.totalHikingDistance >= HikingRecords.awardValues[index]) {
                        self.unlockedIcons[index] = true
                        newUnlockedIcons[index] = true
                        change = true
                    }
                }
            }
        }
        
        // Save if there is a change
        if change {
            self.writeClassMembersToUserDefaults()
            // Sync to iCloud
            HikingRecords.syncLocalAndCloud(localToCloud: true)
        }
    }
    
    // Reset stored statistics (except unlocked app icons)
    static public func resetStatistics() {
        // Local
        UserDefaults.standard.set(0.0, forKey: keys[0])
        UserDefaults.standard.set(0.0, forKey: keys[1])
        UserDefaults.standard.set(0.0, forKey: keys[3])
        UserDefaults.standard.set(0.0, forKey: keys[4])
        UserDefaults.standard.set(0.0, forKey: keys[5])
        // Need to be explicit about removing these as setting them to nil isn't going to work (the Date? typed records)
        UserDefaults.standard.removeObject(forKey: keys[6])
        UserDefaults.standard.removeObject(forKey: keys[7])
        UserDefaults.standard.removeObject(forKey: keys[8])
        
        UserDefaults.standard.set(0, forKey: keys[9])
        
        // iCloud
        NSUbiquitousKeyValueStore.default.set(0.0, forKey: keys[0])
        NSUbiquitousKeyValueStore.default.set(0.0, forKey: keys[1])
        NSUbiquitousKeyValueStore.default.set(0.0, forKey: keys[3])
        NSUbiquitousKeyValueStore.default.set(0.0, forKey: keys[4])
        NSUbiquitousKeyValueStore.default.set(0.0, forKey: keys[5])
        // Need to be explicit about removing these as setting them to nil isn't going to work (the Date? typed records)
        NSUbiquitousKeyValueStore.default.removeObject(forKey: keys[6])
        NSUbiquitousKeyValueStore.default.removeObject(forKey: keys[7])
        NSUbiquitousKeyValueStore.default.removeObject(forKey: keys[8])
        
        NSUbiquitousKeyValueStore.default.set(0, forKey: keys[9])
        
        // Update class members
        HikingRecords.shared.writeToClassMembers()
    }
}
