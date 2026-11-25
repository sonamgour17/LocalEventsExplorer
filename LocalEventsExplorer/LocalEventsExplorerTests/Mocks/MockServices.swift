//
//  MockServices.swift
//  LocalEventsExplorerTests
//
//  Created by Sonam Gour on 2026-11-25.
//

import Foundation
@testable import LocalEventsExplorer

final class MockNetworkService: NetworkServiceProtocol {
    let events: [Event]
    let errorToThrow: Error?

    init(events: [Event] = [], errorToThrow: Error? = nil) {
        self.events = events
        self.errorToThrow = errorToThrow
    }

    func fetch<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        if let errorToThrow {
            throw errorToThrow
        }
        guard let result = events as? T else {
            throw APIError.decodingFailed
        }
        return result
    }
}
