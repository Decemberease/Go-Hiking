//
//  BikeRideListViewModel.swift
//  Go hiking
//
//  Created by Anthony Hopkins on 2021-04-25.
//

import Foundation
import SwiftUI
import CoreData

class HikingListViewModel: ObservableObject {

    @Published var bikeRides: [Hiking] = Hiking.allHikingsSorted()
    @Published var categories: [Category] = Hiking.allCategories()
    @Published var currentSortChoice: SortChoice = Preferences.storedSortingChoice()
    @Published var currentName: String = Preferences.storedSelectedRoute()
    
    init() {
        let valid = validateCategory(name: currentName)
        if (valid == false) {
            currentName = ""
        }
        
        // Launching history tab is a review worthy action
        ReviewManager.incrementReviewWorthyCount()
        
        // Request for review if appropriate
        ReviewManager.requestReviewIfAppropriate()
    }
    
    // This is the default ordering
    func sortByDateDescending() {
        bikeRides = Hiking.sortByDate(list: bikeRides, ascending: false)
        currentSortChoice = .dateDescending
    }
    
    func sortByDateAscending() {
        bikeRides = Hiking.sortByDate(list: bikeRides, ascending: true)
        currentSortChoice = .dateAscending
    }
    
    func sortByDistanceDescending() {
        bikeRides = Hiking.sortByDistance(list: bikeRides, ascending: false)
        currentSortChoice = .distanceDescending
    }
    
    func sortByDistanceAscending() {
        bikeRides = Hiking.sortByDistance(list: bikeRides, ascending: true)
        currentSortChoice = .distanceAscending
    }
    
    func sortByTimeDescending() {
        bikeRides = Hiking.sortByTime(list: bikeRides, ascending: false)
        currentSortChoice = .timeDescending
    }
    
    func sortByTimeAscending() {
        bikeRides = Hiking.sortByTime(list: bikeRides, ascending: true)
        currentSortChoice = .timeAscending
    }
    
    func getSortActionSheetTitle() -> String {
        var title = ""
        switch currentSortChoice {
        case .distanceAscending:
            title = "Distance ↑"
        case .distanceDescending:
            title = "Distance ↓"
        case .dateAscending:
            title = "Date ↑"
        case .dateDescending:
            title = "Date ↓"
        case .timeAscending:
            title = "Time ↑"
        case .timeDescending:
            title = "Time ↓"
        }
        return title
    }
    
    func setCurrentName(name: String) {
        self.currentName = name
    }
    
    func getFilterActionSheetTitle() -> String {
        return "Filter"
    }
    
    func editEnabledCheck() -> Bool {
        if (self.categories.count > 2) {
            return true
        }
        else if (self.categories.count > 1) {
            if (self.categories[0].name == "All" && self.categories[1].name == "Uncategorized") {
                return false
            }
            return true
        }
        else {
            return false
        }
    }
    
    func filterEnabledCheck() -> Bool {
        if (self.categories.count > 0) {
            return true
        }
        return false
    }
    
    func validateCategory(name: String) -> Bool {
        var validName = false
        for category in categories {
            if (category.name == name) {
                validName = true
                break
            }
        }
        return validName
    }
    
    // Used to create the correctly ordered list of bike rides to display
    func getSortDescriptor() -> NSSortDescriptor {
        switch self.currentSortChoice {
            case .distanceAscending:
                return NSSortDescriptor(keyPath: \Hiking.hikingDistance, ascending: true)
            case .distanceDescending:
                return NSSortDescriptor(keyPath: \Hiking.hikingDistance, ascending: false)
            case .dateAscending:
                return NSSortDescriptor(keyPath: \Hiking.hikingStartTime, ascending: true)
            case .dateDescending:
                return NSSortDescriptor(keyPath: \Hiking.hikingStartTime, ascending: false)
            case .timeAscending:
                return NSSortDescriptor(keyPath: \Hiking.hikingTime, ascending: true)
            case .timeDescending:
                return NSSortDescriptor(keyPath: \Hiking.hikingTime, ascending: false)
        }
    }
    
    // Function to update categories
    func updateCategories() {
        categories = Hiking.allCategories()
        let valid = validateCategory(name: currentName)
        if (valid == false) {
            currentName = ""
        }
    }
}
