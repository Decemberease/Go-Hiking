//
//  Go_HikingApp.swift
//  Go Hiking
//
//  Created by Anthony Hopkins on 2021-03-14.
//

import SwiftUI

@main
struct GoHikingApp: App {
    
    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var Hikings: HikingStorage
    @StateObject var hikingStatus = HikingStatus()
    @StateObject var preferences = Preferences.shared
    @StateObject var records = HikingRecords.shared
    
    init() {
        // Clear iCloud key value pairs
//        let allKeys = NSUbiquitousKeyValueStore.default.dictionaryRepresentation.keys
//        for key in allKeys {
//            NSUbiquitousKeyValueStore.default.removeObject(forKey: key)
//        }
        
        // Retrieve stored data to be used by all views - create state objects for environment objects
        let managedObjectContext = persistenceController.container.viewContext
        let HikingsStorage = HikingStorage(managedObjectContext: managedObjectContext)
        self._Hikings = StateObject(wrappedValue: HikingsStorage)
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(Hikings)
                .environmentObject(records)
                .environmentObject(hikingStatus)
                .environmentObject(preferences)
                .onAppear(perform: {
                    
                    // For first launch with UserPreferences set
                    if (!NSUbiquitousKeyValueStore.default.bool(forKey: "didLaunch1.4.0Before") || !UserDefaults.standard.bool(forKey: "didLaunch1.4.0Before")) {
                        NSUbiquitousKeyValueStore.default.set(true, forKey: "didLaunch1.4.0Before")
                        UserDefaults.standard.set(true, forKey: "didLaunch1.4.0Before")
                        // Migrate existing UserPreferences
                        if let oldPreferences = UserPreferences.savedPreferences() {
                            preferences.initialUserPreferencesMigration(existingPreferences: oldPreferences)
                        }
                        // Migrate existing Records
                        if let oldRecords = Records.getStoredRecords() {
                            records.initialRecordsMigration(existingRecords: oldRecords, existingHikings: Hikings.storedHikings)
                        }
                    }
                    
                    // Check if iCloud is available
                    if FileManager.default.ubiquityIdentityToken != nil {
                        if (!NSUbiquitousKeyValueStore.default.bool(forKey: "didLaunch1.4.0Before")) {
                            NSUbiquitousKeyValueStore.default.set(true, forKey: "didLaunch1.4.0Before")
                        }
                    }
                })
        }
        .onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
    }
}
