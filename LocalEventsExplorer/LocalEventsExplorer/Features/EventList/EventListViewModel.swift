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

    /// True when showing saved events because the network failed.
    private(set) var isShowingOfflineData = false

    private let networkService: NetworkServiceProtocol
    private let cacheService: CacheServiceProtocol
    private let coreDataService: CoreDataServiceProtocol

    init(
        networkService: NetworkServiceProtocol,
        cacheService: CacheServiceProtocol,
        coreDataService: CoreDataServiceProtocol) {

            self.networkService = networkService
            self.cacheService = cacheService
            self.coreDataService = coreDataService

        }

    /// Events currently on screen (empty if not loaded).
    var events: [Event] {
        if case .loaded(let events) = state { return events }
        return []
    }

    /// Loads events:
    /// 1. From cache if valid (skipped when `forceRefresh` is true)
    /// 2. Shows spinner on first load
    /// 3. Fetches from network, saves to cache and Core Data
    /// 4. On failure, shows saved events (offline) or an error
    func loadEvents(forceRefresh: Bool = false) async {
        // 1. Use cache if valid
        if !forceRefresh, let cached = await cacheService.fetch() {
            isShowingOfflineData = false
            show(cached)
            return
        }

        // 2. Spinner only on first load
        if events.isEmpty {
            state = .loading
        }

        // 3. Fetch from network and save
        do {
            let fetchedEvents: [Event] = try await networkService.fetch(.events)
            await cacheService.save(fetchedEvents)
            coreDataService.saveLastFetchedEvents(fetchedEvents)
            isShowingOfflineData = false
            show(fetchedEvents)
        } catch is CancellationError {
            // Screen closed; ignore
        } catch {
            // 4. Offline fallback
            handleFailure(error)
        }
    }

    /// Shows saved events if any, otherwise the error.
    private func handleFailure(_ error: Error) {
        let savedEvents = coreDataService.fetchLastFetchedEvents()

        if savedEvents.isEmpty {
            state = .error(error as? APIError ?? .unknown)
        } else {
            isShowingOfflineData = true
            state = .loaded(savedEvents)
        }
    }

    // MARK: - Private
    private func show(_ events: [Event]) {
        state = events.isEmpty ? .empty : .loaded(events)
    }
}
