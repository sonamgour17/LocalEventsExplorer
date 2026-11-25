//
//  EventListViewModel.swift
//  LocalEventsExplorer
//
//  Created by Sonam Gour on 2026-11-25.
//

import Foundation
import Observation

/// Every possible state of the Events screen. Only one can be active at a time.
enum EventListViewState: Equatable {
    case loading
    case loaded([Event])
    case empty
    case error(APIError)
}

/// State and loading logic for the Events list screen.
@MainActor
@Observable
final class EventListViewModel {
    private(set) var state: EventListViewState = .loading
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    /// Events currently on screen (empty if not loaded).
    var events: [Event] {
        if case .loaded(let events) = state { return events }
        return []
    }
    
    /// Loads events from the network. Used on appear, pull to refresh and Retry.
    func loadEvents() async {
        
        // Show the spinner only if nothing is on screen yet.
        if events.isEmpty {
            state = .loading
        }
        
        do {
            let fetchedEvents: [Event] = try await networkService.fetch(.events)
            show(fetchedEvents)
            
        } catch is CancellationError {
            // The screen went away before loading finished. Nothing to update.
        } catch {
            state = .error(error as? APIError ?? .unknown)
        }
    }
    
    // MARK: - Private
    private func show(_ events: [Event]) {
        state = events.isEmpty ? .empty : .loaded(events)
    }
}
