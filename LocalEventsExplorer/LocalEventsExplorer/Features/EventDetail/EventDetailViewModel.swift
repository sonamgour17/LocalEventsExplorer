//
//  EventDetailViewModel.swift
//  LocalEventsExplorer
//
//  Created by Sonam Gour on 2026-11-25.
//

import Foundation
import CoreLocation
import Observation
import MapKit

/// Detail screen state and actions.
@MainActor
@Observable
final class EventDetailViewModel {

    let event: Event
    private(set) var isBookmarked: Bool
    private var eventCoordinate: CLLocationCoordinate2D?

    private let coreDataService: CoreDataServiceProtocol
    private let locationService: LocationServiceProtocol

    init(event: Event,
         coreDataService: CoreDataServiceProtocol,
         locationService: LocationServiceProtocol
    ) {
        self.event = event
        self.coreDataService = coreDataService
        self.locationService = locationService
        self.isBookmarked = coreDataService.isBookmarked(eventID: event.id)
    }

    var distanceText: String? {
        guard let userLocation = locationService.userLocation,
              let eventCoordinate else { return nil }

        let eventLocation = CLLocation(latitude: eventCoordinate.latitude,
                                       longitude: eventCoordinate.longitude)
        return MKDistanceFormatter().string(fromDistance: userLocation.distance(from: eventLocation))
    }

    func onAppear() async {
        locationService.requestLocation()
        eventCoordinate = await GeocodingHelper.coordinate(for: event.location)
    }

    func toggleBookmark() {
        if isBookmarked {
            coreDataService.removeBookmark(eventID: event.id)
        } else {
            coreDataService.saveBookmark(event)
        }
        isBookmarked.toggle()
    }

    // Directions if we have coordinates, otherwise search
    func openInMaps() {
        if let eventCoordinate {
            MapsNavigationService.openDirections(to: event.location, coordinate: eventCoordinate)
        } else {
            MapsNavigationService.openSearch(for: event.location)
        }
    }
}
