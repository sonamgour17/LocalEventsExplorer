//
//  LocationService.swift
//  LocalEventsExplorer
//
//  Created by Sonam Gour on 2026-11-25.
//

import Foundation
import CoreLocation
import Observation
import OSLog

@MainActor
protocol LocationServiceProtocol: AnyObject {
    var userLocation: CLLocation? { get }
    func requestLocation()
}

/// Gets the user's location once. Used only on device, never saved.
@MainActor
@Observable
final class LocationService: NSObject, LocationServiceProtocol {
    private(set) var userLocation: CLLocation?

    @ObservationIgnored private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        // City level is enough and saves battery
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    // First time asks permission, then gets location once
    func requestLocation() {
        if manager.authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else {
            manager.requestLocation()
        }
    }
}

// MARK: - CLLocationManagerDelegate
// nonisolated: iOS can call these on any thread

extension LocationService: CLLocationManagerDelegate {

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        Task { @MainActor in
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                self.manager.requestLocation()
            }
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestLocation = locations.last
        Task { @MainActor in
            self.userLocation = latestLocation
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        AppLogger.location.logError(AppConstants.LogMessage.locationFailed, error)
    }
}
