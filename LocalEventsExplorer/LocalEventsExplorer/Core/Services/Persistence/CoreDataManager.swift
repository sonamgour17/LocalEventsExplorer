//
//  CoreDataManager.swift
//  LocalEventsExplorer
//
//  Created by Sonam Gour on 2026-11-25.
//

import Foundation
import CoreData
import OSLog

/// Core Data setup and save.
final class CoreDataManager {

    // Load model only once
    private static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "LocalEventsExplorer", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Core Data model 'LocalEventsExplorer' not found.")
        }
        return model
    }()

    private let container: NSPersistentContainer

    // For tests, store in memory
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "LocalEventsExplorer", managedObjectModel: Self.model)

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error {
                AppLogger.persistence.logError(AppConstants.LogMessage.coreDataLoadFailed, error)
            }
        }
    }

    var context: NSManagedObjectContext {
        container.viewContext
    }

    // Save changes, rollback if it fails
    func save() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            AppLogger.persistence.logError(AppConstants.LogMessage.coreDataSaveFailed, error)
            context.rollback()
        }
    }
}
