//
//  GeocodingHelper.swift
//  LocalEventsExplorer
//
//  Created by Sonam Gour on 2026-11-25.
//

import Foundation
import CoreLocation
import OSLog

@MainActor
enum GeocodingHelper {
    private static var cache: [String: CLLocationCoordinate2D] = [:]

    static func coordinate(for locationName: String) async -> CLLocationCoordinate2D? {
        if let cached = cache[locationName] {
            return cached
        }

        do {
            let placemarks = try await CLGeocoder().geocodeAddressString(locationName)
            let coordinate = placemarks.first?.location?.coordinate
            if let coordinate {
                cache[locationName] = coordinate
            }
            return coordinate
        } catch {
            AppLogger.location.logError(AppConstants.LogMessage.geocodingFailed, error)
            return nil
        }
    }
}
