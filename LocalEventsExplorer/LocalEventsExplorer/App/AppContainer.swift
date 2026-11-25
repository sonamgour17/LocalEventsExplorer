//
//  AppContainer.swift
//  LocalEventsExplorer
//
//  Created by Sonam Gour on 2026-11-25.
//

import Foundation

/// Dependency Injection container.
/// Creates every service once and gives them to ViewModels through their init.
/// ViewModels depend on protocols, so tests can pass mocks.
@MainActor
final class AppContainer {
    
    // MARK: - Services
    let networkService: NetworkServiceProtocol
    let cacheService: CacheServiceProtocol
    let imageCacheService: ImageCacheServiceProtocol
    let coreDataService: CoreDataServiceProtocol
    let locationService: LocationServiceProtocol
    let backgroundRefreshService: BackgroundRefreshService
    
    
    init() {
        // Same instances are shared with the background service
        let networkService = NetworkService()
        let cacheService = CacheService()
        let coreDataService = CoreDataService(manager: CoreDataManager())
        
        self.networkService = networkService
        self.cacheService = cacheService
        self.coreDataService = coreDataService
        self.imageCacheService = ImageCacheService()
        self.locationService = LocationService()
        self.backgroundRefreshService = BackgroundRefreshService(
            networkService: networkService,
            cacheService: cacheService,
            coreDataService: coreDataService
        )
    }
    
    // MARK: - ViewModel factories
    func makeEventListViewModel() -> EventListViewModel {
        EventListViewModel(
            networkService: networkService,
            cacheService: cacheService,
            coreDataService: coreDataService
        )
    }
    
    func makeEventDetailViewModel(event: Event) -> EventDetailViewModel {
        EventDetailViewModel(
            event: event,
            coreDataService: coreDataService,
            locationService: locationService
        )
    }
    
    func makeBookmarksViewModel() -> BookmarksViewModel {
        BookmarksViewModel(coreDataService: coreDataService)
    }
    
    // Called by iOS for the background task
    func handleBackgroundRefresh() async {
        await backgroundRefreshService.handleRefresh()
    }
}
