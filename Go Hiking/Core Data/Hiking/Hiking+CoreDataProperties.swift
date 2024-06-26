//
//  BikeRide+CoreDataProperties.swift
//  Go Hiking
//
//  Created by Anthony Hopkins on 2021-04-22.
//
//

import Foundation
import CoreData
import CoreLocation

extension Hiking {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Hiking> {
        return NSFetchRequest<Hiking>(entityName: "Hiking")
    }
    
    // Fetch requests for bike rides in specific date ranges - returns an array of optionals
    @nonobjc public class func fetchRequestsWithDateRanges() -> [NSFetchRequest<Hiking>?] {
        // Get the current calendar with local time zone
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local

        let startOfToday = calendar.startOfDay(for: Date())
        let endOfToday = calendar.date(byAdding: .day, value: 1, to: startOfToday)
        
        var requests: [NSFetchRequest<Hiking>?] = []
        
        // 0: Past 7 days
        let request1: NSFetchRequest<Hiking> = Hiking.fetchRequest()
        request1.sortDescriptors = []
        
        let dateFrom1 = calendar.date(byAdding: .day, value: -6, to: startOfToday)

        if let date1 = dateFrom1, let date2 = endOfToday {
            // Set predicate to range of accepted dates
            let fromPredicate = NSPredicate(format: "%@ <= %K", date1 as NSDate, #keyPath(Hiking.hikingStartTime))
            let toPredicate = NSPredicate(format: "%K <= %@", #keyPath(Hiking.hikingStartTime), date2 as NSDate)
            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
            request1.predicate = datePredicate
            requests.append(request1)
        }
        else {
            // Insert nil for this entry if unwrapping didn't work
            requests.append(nil)
        }
        
        // 1: Past 14 - 7 days
        let request2: NSFetchRequest<Hiking> = Hiking.fetchRequest()
        request2.sortDescriptors = []
        
        let dateTo2 = calendar.date(byAdding: .day, value: -7, to: startOfToday)
        let dateFrom2 = calendar.date(byAdding: .day, value: -13, to: startOfToday)

        if let date1 = dateFrom2, let date2 = dateTo2 {
            // Set predicate to range of accepted dates
            let fromPredicate = NSPredicate(format: "%@ <= %K", date1 as NSDate, #keyPath(Hiking.hikingStartTime))
            let toPredicate = NSPredicate(format: "%K <= %@", #keyPath(Hiking.hikingStartTime), date2 as NSDate)
            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
            request2.predicate = datePredicate
            requests.append(request2)
        }
        else {
            // Insert nil for this entry if unwrapping didn't work
            requests.append(nil)
        }
        
        // 2: Past 5 weeks
        let request3: NSFetchRequest<Hiking> = Hiking.fetchRequest()
        request3.sortDescriptors = []
        
        let dateFrom3 = calendar.date(byAdding: .day, value: -34, to: startOfToday)

        if let date1 = dateFrom3, let date2 = endOfToday {
            // Set predicate to range of accepted dates
            let fromPredicate = NSPredicate(format: "%@ <= %K", date1 as NSDate, #keyPath(Hiking.hikingStartTime))
            let toPredicate = NSPredicate(format: "%K <= %@", #keyPath(Hiking.hikingStartTime), date2 as NSDate)
            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
            request3.predicate = datePredicate
            requests.append(request3)
        }
        else {
            // Insert nil for this entry if unwrapping didn't work
            requests.append(nil)
        }
        
        // 3: Past 10 - 5 weeks
        let request4: NSFetchRequest<Hiking> = Hiking.fetchRequest()
        request4.sortDescriptors = []
        
        let dateTo4 = calendar.date(byAdding: .day, value: -35, to: startOfToday)
        let dateFrom4 = calendar.date(byAdding: .day, value: -69, to: startOfToday)

        if let date1 = dateFrom4, let date2 = dateTo4 {
            // Set predicate to range of accepted dates
            let fromPredicate = NSPredicate(format: "%@ <= %K", date1 as NSDate, #keyPath(Hiking.hikingStartTime))
            let toPredicate = NSPredicate(format: "%K <= %@", #keyPath(Hiking.hikingStartTime), date2 as NSDate)
            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
            request4.predicate = datePredicate
            requests.append(request4)
        }
        else {
            // Insert nil for this entry if unwrapping didn't work
            requests.append(nil)
        }
        
        // 4: Past 30 weeks
        let request5: NSFetchRequest<Hiking> = Hiking.fetchRequest()
        request5.sortDescriptors = []
        
        let dateFrom5 = calendar.date(byAdding: .day, value: -209, to: startOfToday)

        if let date1 = dateFrom5, let date2 = endOfToday {
            // Set predicate to range of accepted dates
            let fromPredicate = NSPredicate(format: "%@ <= %K", date1 as NSDate, #keyPath(Hiking.hikingStartTime))
            let toPredicate = NSPredicate(format: "%K <= %@", #keyPath(Hiking.hikingStartTime), date2 as NSDate)
            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
            request5.predicate = datePredicate
            requests.append(request5)
        }
        else {
            // Insert nil for this entry if unwrapping didn't work
            requests.append(nil)
        }
        
        // 5: Past 60 - 30 weeks
        let request6: NSFetchRequest<Hiking> = Hiking.fetchRequest()
        request6.sortDescriptors = []
        
        let dateTo6 = calendar.date(byAdding: .day, value: -210, to: startOfToday)
        let dateFrom6 = calendar.date(byAdding: .day, value: -419, to: startOfToday)

        if let date1 = dateFrom6, let date2 = dateTo6 {
            // Set predicate to range of accepted dates
            let fromPredicate = NSPredicate(format: "%@ <= %K", date1 as NSDate, #keyPath(Hiking.hikingStartTime))
            let toPredicate = NSPredicate(format: "%K <= %@", #keyPath(Hiking.hikingStartTime), date2 as NSDate)
            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
            request6.predicate = datePredicate
            requests.append(request6)
        }
        else {
            // Insert nil for this entry if unwrapping didn't work
            requests.append(nil)
        }
        
        return requests
    }

    @NSManaged public var hikingLatitudes: [CLLocationDegrees]
    @NSManaged public var hikingLongitudes: [CLLocationDegrees]
    @NSManaged public var hikingSpeeds: [CLLocationSpeed]
    @NSManaged public var hikingElevations: [CLLocationDistance]
    @NSManaged public var hikingDistance: Double
    @NSManaged public var hikingStartTime: Date
    @NSManaged public var hikingTime: Double
    @NSManaged public var hikingRouteName: String

    static func sortByDistance(list: [Hiking], ascending: Bool) -> [Hiking] {
        var returnList: [Hiking] = list
        for i in 0..<returnList.count {
            var current = i
            for j in i..<returnList.count {
                if (ascending && returnList[j].hikingDistance < returnList[current].hikingDistance) {
                    current = j
                }
                else if (!ascending && returnList[j].hikingDistance > returnList[current].hikingDistance) {
                    current = j
                }
            }
            let temp: Hiking = returnList[current]
            returnList[current] = returnList[i]
            returnList[i] = temp
        }
        return returnList
    }
    
    static func sortByDate(list: [Hiking], ascending: Bool) -> [Hiking] {
        var returnList: [Hiking] = []

        let HikingDates: [Date] = list.map { $0.hikingStartTime }

        let HikingDateTuples = zip(list, HikingDates)
        
        if (ascending) {
            returnList = HikingDateTuples.sorted { $0.1 < $1.1 }
                .map {$0.0}
        }
        else {
            returnList = HikingDateTuples.sorted { $0.1 > $1.1 }
                .map {$0.0}
        }
        return returnList
    }
    
    static func sortByTime(list: [Hiking], ascending: Bool) -> [Hiking] {
        var returnList: [Hiking] = list
        for i in 0..<returnList.count {
            var current = i
            for j in i..<returnList.count {
                if (ascending && returnList[j].hikingTime < returnList[current].hikingTime) {
                    current = j
                }
                else if (!ascending && returnList[j].hikingTime > returnList[current].hikingTime) {
                    current = j
                }
            }
            let temp: Hiking = returnList[current]
            returnList[current] = returnList[i]
            returnList[i] = temp
        }
        return returnList
    }
}

extension Hiking : Identifiable {
    static var savedHikingsFetchRequest: NSFetchRequest<Hiking> {
        let request: NSFetchRequest<Hiking> = Hiking.fetchRequest()
        request.sortDescriptors = []

        return request
      }
}
