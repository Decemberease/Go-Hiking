//
//  Records+CoreDataProperties.swift
//  Go Hiking
//
//  Created by Anthony Hopkins on 2021-08-29.
//
//

import Foundation
import CoreData


extension Records {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Records> {
        return NSFetchRequest<Records>(entityName: "Records")
    }

    @NSManaged public var totalHikingTime: Double
    @NSManaged public var totalHikingDistance: Double
    @NSManaged public var totalHikingRoutes: Int64
    @NSManaged public var unlockedIcons: [Bool]
    @NSManaged public var longestHikingDistance: Double
    @NSManaged public var longestHikingTime: Double
    @NSManaged public var fastestAverageSpeed: Double
    @NSManaged public var fastestAverageSpeedDate: Date?
    @NSManaged public var longestHikingDistanceDate: Date?
    @NSManaged public var longestHikingTimeDate: Date?

}

extension Records : Identifiable {
    static var savedRecordsFetchRequest: NSFetchRequest<Records> {
        let request: NSFetchRequest<Records> = Records.fetchRequest()
        request.sortDescriptors = []

        return request
      }
}
