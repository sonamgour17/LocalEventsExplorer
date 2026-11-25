//
//  CoreDataService.swift
//  LocalEventsExplorer
//
//  Created by Sonam Gour on 2026-11-25.
//

import Foundation
import CoreData

/// Local storage on the device.
@MainActor
protocol CoreDataServiceProtocol {
    func saveLastFetchedEvents(_ events: [Event])
    func fetchLastFetchedEvents() -> [Event]
}

final class CoreDataService: CoreDataServiceProtocol {
    private let manager: CoreDataManager

    init(manager: CoreDataManager) {
        self.manager = manager
    }

    // MARK: - Offline (last fetched events)

    /// Replaces old saved events with the new ones.
    func saveLastFetchedEvents(_ events: [Event]) {
        let context = manager.context

        // 1. Delete old events
        let request: NSFetchRequest<CachedEventEntity> = CachedEventEntity.fetchRequest()
        if let oldEvents = try? context.fetch(request) {
            oldEvents.forEach { context.delete($0) }
        }

        // 2. Insert new events
        for event in events {
            let cached = CachedEventEntity(context: context)
            cached.id = event.id
            cached.title = event.title
            cached.location = event.location
            cached.time = event.time
            cached.imageUrl = event.imageUrl
            cached.lastFetchedAt = Date()
        }
        manager.save()
        print("CORE DATA SAVED: \(events.count) events")   

    }

    /// Saved events sorted by time.
    func fetchLastFetchedEvents() -> [Event] {
        let request: NSFetchRequest<CachedEventEntity> = CachedEventEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]

        guard let results = try? manager.context.fetch(request) else { return [] }
        
        print("CORE DATA LOADED: \(results.count) events")

        return results.map {
            makeEvent(id: $0.id, title: $0.title, location: $0.location, time: $0.time, imageUrl: $0.imageUrl)
        }
    }

    // MARK: - Private

    /// Core Data values are optional; nil becomes "".
    private func makeEvent(id: String?, title: String?, location: String?,
                           time: String?, imageUrl: String?) -> Event {
        Event(id: id ?? "", title: title ?? "", location: location ?? "",
              time: time ?? "", imageUrl: imageUrl ?? "")
    }
}
