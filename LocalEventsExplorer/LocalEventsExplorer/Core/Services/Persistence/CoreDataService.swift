//
//  CoreDataService.swift
//  LocalEventsExplorer
//
//  Created by Sonam Gour on 2026-11-25.
//

import Foundation
import CoreData
import OSLog

/// Local storage on the device.
@MainActor
protocol CoreDataServiceProtocol {
    func saveLastFetchedEvents(_ events: [Event])
    func fetchLastFetchedEvents() -> [Event]
    func saveBookmark(_ event: Event)
    func removeBookmark(eventID: String)
    func isBookmarked(eventID: String) -> Bool
    func fetchBookmarks() -> [Event]
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
        
    }
    
    /// Saved events sorted by time.
    func fetchLastFetchedEvents() -> [Event] {
        let request: NSFetchRequest<CachedEventEntity> = CachedEventEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
        
        guard let results = try? manager.context.fetch(request) else { return [] }
                
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
    
    

    // MARK: - Bookmarks
    
    func saveBookmark(_ event: Event) {
        guard !isBookmarked(eventID: event.id) else { return }
        
        let bookmark = BookmarkEntity(context: manager.context)
        bookmark.id = event.id
        bookmark.title = event.title
        bookmark.location = event.location
        bookmark.time = event.time
        bookmark.imageUrl = event.imageUrl
        bookmark.bookmarkedAt = Date()
        manager.save()
    }
    
    func removeBookmark(eventID: String) {
        let request: NSFetchRequest<BookmarkEntity> = BookmarkEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", eventID)
        
        do {
            let results = try manager.context.fetch(request)
            results.forEach { manager.context.delete($0) }
            manager.save()
        } catch {
            AppLogger.persistence.logError(AppConstants.LogMessage.removeBookmarkFailed, error)
        }
    }
    
    func isBookmarked(eventID: String) -> Bool {
        let request: NSFetchRequest<BookmarkEntity> = BookmarkEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", eventID)
        request.fetchLimit = 1
        return ((try? manager.context.count(for: request)) ?? 0) > 0
    }
    
    // Newest first
    func fetchBookmarks() -> [Event] {
        let request: NSFetchRequest<BookmarkEntity> = BookmarkEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "bookmarkedAt", ascending: false)]
        
        guard let results = try? manager.context.fetch(request) else { return [] }
        return results.map {
            makeEvent(id: $0.id, title: $0.title, location: $0.location, time: $0.time, imageUrl: $0.imageUrl)
        }
    }
}
