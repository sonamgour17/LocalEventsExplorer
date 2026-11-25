//
//  AppConstants.swift
//  LocalEventsExplorer
//
//  Created by Sonam Gour on 2026-11-25.
//

import Foundation

/// All app-wide values in one place (texts, icons).
enum AppConstants {
    
    enum Title {
        static let events = "Events"
        static let bookmarks = "Bookmarks"
    }
    
    enum Image {
        static let events = "calendar"
        static let bookmarks = "bookmark.fill"
        static let emptyEvents = "calendar.badge.exclamationmark"
        static let networkError = "wifi.exclamationmark"
    }
    
    nonisolated enum Message {
        static let invalidURL = "Invalid request URL."
        static let noInternet = "No internet connection. Please try again."
        static let decodingFailed = "Failed to parse server response."
        static let unknownError = "Something went wrong. Please try again."
        static let loadingEvents = "Loading events..."
        static let somethingWentWrong = "Something went wrong."
        static let noEvents = "No events found"
        
        static func serverError(statusCode: Int) -> String {
            "Server error (\(statusCode)). Please try again later."
        }
    }
    
    enum Button {
        static let retry = "Retry"
    }
    
    enum Layout {
        static let standardSpacing: CGFloat = 12
        static let smallSpacing: CGFloat = 4
        static let verticalPadding: CGFloat = 4
    }
    
    enum API {
        static let baseURL = "https://6a7e37d0f8b2ed99ca4f25b9.mockapi.io/api/v1"
        static let eventsPath = "/events"
    }
    
    /// Developer-only console messages. `nonisolated` so they can be used from any thread.
    nonisolated enum LogMessage {
        static let networkRequestFailed = "Network request failed"
    }
}
