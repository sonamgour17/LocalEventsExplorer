//
//  BookmarksViewModel.swift
//  LocalEventsExplorer
//
//  Created by Sonam Gour on 2026-11-25.
//

import Foundation
import Observation

/// Bookmarks screen state and actions.
@MainActor
@Observable
final class BookmarksViewModel {
    private(set) var bookmarkedEvents: [Event] = []

    private let coreDataService: CoreDataServiceProtocol

    init(coreDataService: CoreDataServiceProtocol) {
        self.coreDataService = coreDataService
    }

    func loadBookmarks() {
        bookmarkedEvents = coreDataService.fetchBookmarks()
    }

    // Swipe to delete
    func removeBookmarks(at offsets: IndexSet) {
        for index in offsets {
            coreDataService.removeBookmark(eventID: bookmarkedEvents[index].id)
        }
        loadBookmarks()
    }
}
