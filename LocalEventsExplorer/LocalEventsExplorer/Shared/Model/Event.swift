//
//  Event.swift
//  LocalEventsExplorer
//
//  Created by Sonam Gour on 2026-11-25.
//

import Foundation

/// One event returned by the API.
struct Event: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let title: String
    let location: String
    let time: String
    let imageUrl: String

    /// Event time as a Date. nil if the API sends an unexpected format.
    var eventDate: Date? {
        (try? Date(time, strategy: Self.isoWithMilliseconds))
            ?? (try? Date(time, strategy: Self.isoWithoutMilliseconds))
    }

    // Created once and reused. ISO8601FormatStyle is thread-safe.
    private static let isoWithMilliseconds = Date.ISO8601FormatStyle(includingFractionalSeconds: true)
    private static let isoWithoutMilliseconds = Date.ISO8601FormatStyle()
}

extension Event {

    /// Sample event for SwiftUI previews.
    static let preview = Event(
        id: "1",
        title: "SwiftUI Conference",
        location: "Toronto",
        time: "2026-09-10T18:00:00.000Z",
        imageUrl: "https://picsum.photos/400"
    )
}
