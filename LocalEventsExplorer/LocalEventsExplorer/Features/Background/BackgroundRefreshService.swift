//
//  BackgroundRefreshService.swift
//  LocalEventsExplorer
//
//  Created by Sonam Gour on 2026-11-25.
//

import Foundation
import BackgroundTasks
import OSLog

@MainActor
final class BackgroundRefreshService {
    private let networkService: NetworkServiceProtocol
    private let cacheService: CacheServiceProtocol
    private let coreDataService: CoreDataServiceProtocol

    init(networkService: NetworkServiceProtocol,
         cacheService: CacheServiceProtocol,
         coreDataService: CoreDataServiceProtocol) {
        self.networkService = networkService
        self.cacheService = cacheService
        self.coreDataService = coreDataService
    }

    // Called when the app goes to background
    func scheduleRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: AppConstants.Background.refreshTaskIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: AppConstants.Background.refreshInterval)

        do {
            try BGTaskScheduler.shared.submit(request)

        } catch {

            // Expected on Simulator
            AppLogger.background.logError(AppConstants.LogMessage.scheduleRefreshFailed, error)
        }
    }

    // Called by iOS in background
    func handleRefresh() async {
        scheduleRefresh() // schedule the next one first

        do {
            let events: [Event] = try await networkService.fetch(.events)
            await cacheService.save(events)
            coreDataService.saveLastFetchedEvents(events)
        } catch {
            AppLogger.background.logError(AppConstants.LogMessage.backgroundRefreshFailed, error)
        }
    }
}
