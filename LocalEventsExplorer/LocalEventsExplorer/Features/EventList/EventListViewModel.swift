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
    private let cacheService: CacheServiceProtocol
    
    init(networkService: NetworkServiceProtocol, cacheService: CacheServiceProtocol) {
        self.networkService = networkService
        self.cacheService = cacheService
    }
    
    /// Events currently on screen (empty if not loaded).
    var events: [Event] {
        if case .loaded(let events) = state { return events }
        return []
    }
    
    /// Loads events:
    /// 1. From cache if valid (skipped when `forceRefresh` is true)
    /// 2. Shows spinner on first load
    /// 3. Fetches from network and saves to cache
    /// 4. Shows error if the request fails
    func loadEvents(forceRefresh: Bool = false) async {
        // 1. Use cache if valid
        if !forceRefresh, let cached = await cacheService.fetch() {
            print("CACHE: \(cached.count) events")
            show(cached)
            return
        }
        
        // 2. Spinner only on first load
        if events.isEmpty {
            state = .loading
        }
        
        // 3. Fetch from network and cache it
        do {
            print("NETWORK: fetching...")
            let fetchedEvents: [Event] = try await networkService.fetch(.events)
            await cacheService.save(fetchedEvents)
            show(fetchedEvents)
        } catch is CancellationError {
            // Screen closed; ignore
        } catch {
            // 4. Show error
            state = .error(error as? APIError ?? .unknown)
        }
    }
    
    // MARK: - Private
    private func show(_ events: [Event]) {
        state = events.isEmpty ? .empty : .loaded(events)
    }
}
