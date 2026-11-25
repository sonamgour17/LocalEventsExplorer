//
//  MapsNavigationService.swift
//  LocalEventsExplorer
//
//  Created by Sonam Gour on 2026-11-25.
//

import Foundation
import MapKit
import UIKit

/// Opens Apple Maps for an event.
@MainActor
enum MapsNavigationService {

    // Directions to the coordinate
    static func openDirections(to locationName: String, coordinate: CLLocationCoordinate2D) {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = locationName
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }

    // Fallback: search by name
    static func openSearch(for locationName: String) {
        var components = URLComponents(string: "https://maps.apple.com/")
        components?.queryItems = [URLQueryItem(name: "q", value: locationName)]
        guard let url = components?.url else { return }
        UIApplication.shared.open(url)
    }
}
