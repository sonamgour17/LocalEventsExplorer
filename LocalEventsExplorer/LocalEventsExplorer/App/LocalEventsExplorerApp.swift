//
//  LocalEventsExplorerApp.swift
//  LocalEventsExplorer
//
//  Created by Sonam Gour on 2026-11-25.
//

import SwiftUI

/// App entry point.
@main
struct LocalEventsExplorerApp: App {
    
    /// Created once when the app starts and passed down (no singleton).
    private let container = AppContainer()
    
    var body: some Scene {
        WindowGroup {
            MainTabView(container: container)
        }
    }
}
