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
        static let details = "Details"

    }

    enum Image {
        static let events = "calendar"
        static let bookmarks = "bookmark.fill"
        static let emptyEvents = "calendar.badge.exclamationmark"
        static let networkError = "wifi.exclamationmark"
        static let photo = "photo"
        static let offline = "wifi.slash"
        static let emptyBookmark = "bookmark.slash"
        static let location = "mappin.and.ellipse"
        static let date = "calendar"
        static let distance = "location.fill"
        static let map = "map"

    }

    nonisolated enum Cache {
        static let eventTTL: TimeInterval = 300        // 5 minutes
        static let maximumImages = 50  // LRU limit (memory)

    }

    nonisolated enum Message {
        static let invalidURL = "Invalid request URL."
        static let noInternet = "No internet connection. Please try again."
        static let decodingFailed = "Failed to parse server response."
        static let unknownError = "Something went wrong. Please try again."
        static let loadingEvents = "Loading events..."
        static let somethingWentWrong = "Something went wrong."
        static let noEvents = "No events found"
        static let offline = "You're offline. Showing saved events."
        static let noBookmarks = "No bookmarks yet"

        static func serverError(statusCode: Int) -> String {
            "Server error (\(statusCode)). Please try again later."
        }
    }

    enum Button {
        static let retry = "Retry"
        static let addBookmark = "Add bookmark"
        static let removeBookmark = "Remove bookmark"
        static let openInMaps = "Open in Maps"

    }

    enum Layout {
        static let standardSpacing: CGFloat = 12
        static let smallSpacing: CGFloat = 4
        static let verticalPadding: CGFloat = 4
        static let imageSize: CGFloat = 70
        static let cornerRadius: CGFloat = 8
        static let detailImageHeight: CGFloat = 220

    }

    enum API {
        static let baseURL = "https://6a7e37d0f8b2ed99ca4f25b9.mockapi.io/api/v1"
        static let eventsPath = "/events"
    }

    nonisolated enum LogMessage {
        static let networkRequestFailed = "Network request failed"
        static let coreDataLoadFailed = "Core Data failed to load"
        static let coreDataSaveFailed = "Core Data save failed"
        static let removeBookmarkFailed = "Failed to remove bookmark"
        static let locationFailed = "Location error"
        static let geocodingFailed = "Geocoding failed"
        static let scheduleRefreshFailed = "Could not schedule refresh"
        static let backgroundRefreshFailed = "Background refresh failed"
    }

    nonisolated enum Background {
        static let refreshTaskIdentifier = "com.sonamgour.LocalEventsExplorer.refresh" // must match Info
        static let refreshInterval: TimeInterval = 4 * 60 * 60 // 4 hours
    }
}
