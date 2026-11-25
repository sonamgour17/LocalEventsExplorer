//
//  APIEndpoint.swift
//  LocalEventsExplorer
//
//  Created by Sonam Gour on 2026-11-25.
//

import Foundation

/// All API endpoints. Adding a new endpoint = adding a new case here.
enum APIEndpoint: Sendable {
    case events

    var url: URL? {
        switch self {
        case .events:
            return URL(string: AppConstants.API.baseURL + AppConstants.API.eventsPath)
        }
    }
}
