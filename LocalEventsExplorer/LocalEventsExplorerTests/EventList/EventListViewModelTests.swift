//
//  EventListViewModelTests.swift
//  LocalEventsExplorerTests
//
//  Created by Sonam Gour on 2026-11-25.
//

import XCTest
@testable import LocalEventsExplorer

@MainActor
final class EventListViewModelTests: XCTestCase {
    
    private var events: [Event] {
        [
            Event(id: "1", title: "SwiftUI Conf", location: "Toronto",
                  time: "2026-09-10", imageUrl: ""),
            Event(id: "2", title: "iOS Meetup", location: "Milton",
                  time: "2026-09-15", imageUrl: "")
        ]
    }
    
    private func makeSUT(
        network: MockNetworkService,
        cache: CacheService? = nil,
        coreData: CoreDataService? = nil
    ) -> EventListViewModel {
        EventListViewModel(
            networkService: network,
            cacheService: cache ?? CacheService(),
            coreDataService: coreData ?? CoreDataService(manager: CoreDataManager(inMemory: true))
        )
    }
    
    func test_success_showsEvents() async {
        let sut = makeSUT(network: MockNetworkService(events: events))
        
        await sut.loadEvents()
        
        XCTAssertEqual(sut.state, .loaded(events))
    }
    
    func test_emptyResponse_showsEmptyState() async {
        let sut = makeSUT(network: MockNetworkService(events: []))
        
        await sut.loadEvents()
        
        XCTAssertEqual(sut.state, .empty)
    }
    
    func test_noInternet_withNoSavedData_showsError() async {
        let sut = makeSUT(network: MockNetworkService(errorToThrow: APIError.noInternet))
        
        await sut.loadEvents()
        
        XCTAssertEqual(sut.state, .error(.noInternet))
    }
    
    func test_failure_withSavedEvents_showsOfflineData() async {
        let coreData = CoreDataService(manager: CoreDataManager(inMemory: true))
        coreData.saveLastFetchedEvents(events)
        let sut = makeSUT(network: MockNetworkService(errorToThrow: APIError.noInternet), coreData: coreData)
        
        await sut.loadEvents()
        
        XCTAssertEqual(sut.state, .loaded(events))
        XCTAssertTrue(sut.isShowingOfflineData)
    }
    
    func test_cacheHit_skipsNetwork() async {
        let cache = CacheService()
        await cache.save(events)
        // Network would fail, so events must come from the cache
        let sut = makeSUT(network: MockNetworkService(errorToThrow: APIError.unknown), cache: cache)
        
        await sut.loadEvents()
        
        XCTAssertEqual(sut.state, .loaded(events))
    }
    
    func test_forceRefresh_skipsCache() async {
        let cache = CacheService()
        await cache.save([events[0]])   // old data
        let sut = makeSUT(network: MockNetworkService(events: events), cache: cache)
        
        await sut.loadEvents(forceRefresh: true)
        
        XCTAssertEqual(sut.state, .loaded(events))
    }
}
