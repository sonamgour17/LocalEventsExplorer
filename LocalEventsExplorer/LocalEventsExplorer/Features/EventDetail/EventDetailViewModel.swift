//
//  EventDetailViewModel.swift
//  LocalEventsExplorer
//
//  Created by Sonam Gour on 2026-11-25.
//

import Foundation
import Observation

/// Detail screen state and actions.
@MainActor
@Observable
final class EventDetailViewModel {
    let event: Event
    private(set) var isBookmarked: Bool

    private let coreDataService: CoreDataServiceProtocol

    init(event: Event, coreDataService: CoreDataServiceProtocol) {
        self.event = event
        self.coreDataService = coreDataService
        self.isBookmarked = coreDataService.isBookmarked(eventID: event.id)
    }

    func toggleBookmark() {
        if isBookmarked {
            coreDataService.removeBookmark(eventID: event.id)
        } else {
            coreDataService.saveBookmark(event)
        }
        isBookmarked.toggle()
    }
}
