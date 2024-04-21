//
//  BikeRideStorage.swift
//  Go Hiking
//
//  Created by Anthony Hopkins on 2021-04-22.
//

import Foundation
import CoreData

class HikingStorage: NSObject, ObservableObject {
    @Published var storedHikings: [Hiking] = []
    private let HikingsController: NSFetchedResultsController<Hiking>

    init(managedObjectContext: NSManagedObjectContext) {
        HikingsController = NSFetchedResultsController(fetchRequest: Hiking.savedHikingsFetchRequest,
        managedObjectContext: managedObjectContext,
        sectionNameKeyPath: nil, cacheName: nil)

        super.init()

        HikingsController.delegate = self

        do {
            try HikingsController.performFetch()
            storedHikings = HikingsController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch items!")
        }
    }
}

extension HikingStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let savedHikings = controller.fetchedObjects as? [Hiking]
        else { return }

        storedHikings = savedHikings
    }
}

