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
        .environment(\.imageCache, container.imageCacheService)
    }

    private var eventsTab: some View {
        NavigationStack(path: $router.eventsPath) {
            EventListView(viewModel: container.makeEventListViewModel())
                .navigationDestination(for: AppRoute.self) { route in
                    destination(for: route)
                }

        }
    }

    private var bookmarksTab: some View {
        NavigationStack(path: $router.bookmarksPath) {
            BookmarksView(viewModel: container.makeBookmarksViewModel())
                .navigationDestination(for: AppRoute.self) { route in
                    destination(for: route)
                }
        }
    }

    // All destinations in one place
    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .eventDetail(let event):
            EventDetailView(viewModel: container.makeEventDetailViewModel(event: event))
        }
    }
}

#Preview {
    MainTabView(container: AppContainer())
}
