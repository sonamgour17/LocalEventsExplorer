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
    }
    
    nonisolated enum Message {
            static let invalidURL = "Invalid request URL."
            static let noInternet = "No internet connection. Please try again."
            static let decodingFailed = "Failed to parse server response."
            static let unknownError = "Something went wrong. Please try again."

            static func serverError(statusCode: Int) -> String {
                "Server error (\(statusCode)). Please try again later."
            }
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
