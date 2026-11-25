//
//  MainTabView.swift
//  LocalEventsExplorer
//
//  Created by Sonam Gour on 2026-11-25.
//

import SwiftUI

/// Root screen: two tabs, each with its own navigation stack (own back history).
struct MainTabView: View {
    
    /// @State keeps the router alive while this view exists.
    @State private var router = AppRouter()
    
    private let container: AppContainer
    
    
    init(container: AppContainer) {
        self.container = container
    }
    
    var body: some View {
        
        TabView(selection: $router.selectedTab) {
            
            eventsTab
                .tabItem { Label(AppTab.events.title, systemImage: AppTab.events.systemImage) }
                .tag(AppTab.events)
            
            bookmarksTab
                .tabItem { Label(AppTab.bookmarks.title, systemImage: AppTab.bookmarks.systemImage) }
                .tag(AppTab.bookmarks)
        }
    }
    
    
    
    private var eventsTab: some View {
        NavigationStack(path: $router.eventsPath) {
            EventListView(viewModel: container.makeEventListViewModel())
        }
    }
    
    private var bookmarksTab: some View {
        NavigationStack(path: $router.bookmarksPath) {
            BookmarksView()
        }
    }
}

#Preview {
    MainTabView(container: AppContainer())
}
