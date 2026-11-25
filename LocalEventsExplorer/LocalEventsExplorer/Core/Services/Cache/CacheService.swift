//
//  CacheService.swift
//  LocalEventsExplorer
//
//  Created by Sonam Gour on 2026-11-25.
//

import Foundation

nonisolated protocol CacheServiceProtocol: Sendable {
    func save(_ events: [Event]) async
    func fetch() async -> [Event]?
}

/// In-memory events cache with TTL. Actor = thread-safe.
actor CacheService: CacheServiceProtocol {
    private var cachedEvents: [Event]?
    private var cachedAt: Date?
    private let ttl: TimeInterval

    init(ttl: TimeInterval = AppConstants.Cache.eventTTL) {
        self.ttl = ttl
    }

    func save(_ events: [Event]) {
        cachedEvents = events
        cachedAt = Date()
    }

    /// Returns nil if empty or expired.
    func fetch() -> [Event]? {
        guard let cachedAt, let cachedEvents else { return nil }
        let isExpired = Date().timeIntervalSince(cachedAt) > ttl
        return isExpired ? nil : cachedEvents
    }
}
