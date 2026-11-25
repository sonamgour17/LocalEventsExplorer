//
//  AppRouter.swift
//  LocalEventsExplorer
//
//  Created by Sonam Gour on 2026-11-25.
//

import Foundation
import SwiftUI
import Observation

/// Holds the navigation state: the selected tab and each tab's own back stack.
@MainActor
@Observable
final class AppRouter {
    var selectedTab: AppTab = .events
    var eventsPath = NavigationPath()
    var bookmarksPath = NavigationPath()
}
