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
    
    
    init() {
        self.networkService = NetworkService()
        self.cacheService = CacheService()
    }
    
    // MARK: - ViewModel factories
    func makeEventListViewModel() -> EventListViewModel {
        EventListViewModel(
            networkService: networkService,
            cacheService: cacheService
            
        )
    }
}
