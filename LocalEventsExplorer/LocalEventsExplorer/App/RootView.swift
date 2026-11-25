//
//  RootView.swift
//  LocalEventsExplorer
//
//  Created by Sonam Gour on 2026-11-25.
//

import SwiftUI

struct RootView: View {
    let container: AppContainer

    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        MainTabView(container: container)
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .background {
                    container.backgroundRefreshService.scheduleRefresh()
                }
            }
    }
}
