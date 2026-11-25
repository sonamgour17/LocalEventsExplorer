//
//  AppTab.swift
//  LocalEventsExplorer
//
//  Created by Sonam Gour on 2026-11-25.
//

import Foundation

/// The tabs of the app.
enum AppTab: Hashable, Sendable {
    case events
    case bookmarks

    var title: String {
        switch self {
        case .events:
            return AppConstants.Title.events
        case .bookmarks:
            return AppConstants.Title.bookmarks
        }
    }

    var systemImage: String {
        switch self {
        case .events:
            return AppConstants.Image.events
        case .bookmarks:
            return AppConstants.Image.bookmarks
        }
    }
}
