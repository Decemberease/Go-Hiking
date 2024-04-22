//
//  BikeRide+Extensions.swift
//  Go Hiking
//
//  Created by Anthony Hopkins on 2021-04-25.
//

import Foundation
import CoreData

extension Hiking {
    
    static func allHikings() -> [Hiking] {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<Hiking> = Hiking.fetchRequest()
        do {
            let items = try context.fetch(fetchRequest)
            return items
        }
        catch let error as NSError {
            print("Error getting Hikings: \(error.localizedDescription), \(error.userInfo)")
        }
        return [Hiking]()
    }
    
    static func allHikingsSorted() -> [Hiking] {
        let HikingsUnsorted = allHikings()
        var Hikings: [Hiking] = []
        switch Preferences.shared.sortingChoiceConverted {
        case .distanceAscending:
            Hikings = Hiking.sortByDistance(list: HikingsUnsorted, ascending: true)
        case .distanceDescending:
            Hikings = Hiking.sortByDistance(list: HikingsUnsorted, ascending: false)
        case .dateAscending:
            Hikings = Hiking.sortByDate(list: HikingsUnsorted, ascending: true)
        case .dateDescending:
            Hikings = Hiking.sortByDate(list: HikingsUnsorted, ascending: false)
        case .timeAscending:
            Hikings = Hiking.sortByTime(list: HikingsUnsorted, ascending: true)
        case .timeDescending:
            Hikings = Hiking.sortByTime(list: HikingsUnsorted, ascending: false)
        }
        return Hikings
    }
    
    static func allRouteNames() -> [String] {
        let allHikings = allHikings()
        var uniqueNames: [String] = []

        for ride in allHikings {
            if (uniqueNames.firstIndex(of: ride.hikingRouteName) == nil) {
                if (ride.hikingRouteName != "Uncategorized") {
                    uniqueNames.append(ride.hikingRouteName)
                }
            }
        }
        
        return uniqueNames.sorted { $0.lowercased() < $1.lowercased() }
    }
    
    static func allCategories() -> [Category] {
        let allHikings = allHikings()
        var categories: [Category] = []
        var names: [String] = []
        var numbers: [Int] = []
        var uncategorizedCounter = 0
        
        for ride in allHikings {
            if (names.firstIndex(of: ride.hikingRouteName) == nil) {
                if (ride.hikingRouteName != "Uncategorized") {
                    names.append(ride.hikingRouteName)
                    numbers.append(1)
                }
                else {
                    uncategorizedCounter += 1
                }
            }
            else {
                numbers[names.firstIndex(of: ride.hikingRouteName)!] += 1
            }
        }
        
        for (index, name) in names.enumerated() {
            categories.append(Category(name: name, number: numbers[index]))
        }
        
        // Sort the user created categories alphabeticaly
        categories = categories.sorted { $0.name.lowercased() < $1.name.lowercased() }
        
        if (uncategorizedCounter > 0) {
            categories.insert(Category(name: "Uncategorized", number: uncategorizedCounter), at: 0)
        }
        
        if (allHikings.count > 0) {
            categories.insert(Category(name: "All", number: allHikings.count), at: 0)
        }
        
        return categories
    }
    
    // Functions to get data for the charts on the statistics tab
    static func HikingsInPastWeek() -> [Hiking] {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<Hiking> = Hiking.fetchRequestsWithDateRanges()[0] ?? Hiking.fetchRequest()
        do {
            let items = try context.fetch(fetchRequest)
            return items
        }
        catch let error as NSError {
            print("Error getting Hiking: \(error.localizedDescription), \(error.userInfo)")
        }
        return [Hiking]()
    }
    
    static func HikingsInPast5Weeks() -> [Hiking] {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<Hiking> = Hiking.fetchRequestsWithDateRanges()[2] ?? Hiking.fetchRequest()
        do {
            let items = try context.fetch(fetchRequest)
            return items
        }
        catch let error as NSError {
            print("Error getting Hiking: \(error.localizedDescription), \(error.userInfo)")
        }
        return [Hiking]()
    }
    
    static func HikingsInPast30Weeks() -> [Hiking] {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<Hiking> = Hiking.fetchRequestsWithDateRanges()[4] ?? Hiking.fetchRequest()
        do {
            let items = try context.fetch(fetchRequest)
            return items
        }
        catch let error as NSError {
            print("Error getting Hiking: \(error.localizedDescription), \(error.userInfo)")
        }
        return [Hiking]()
    }
}
