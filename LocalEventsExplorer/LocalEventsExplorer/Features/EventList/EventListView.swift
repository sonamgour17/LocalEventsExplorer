//
//  EventListView.swift
//  LocalEventsExplorer
//
//  Created by Sonam Gour on 2026-11-25.
//

import SwiftUI

/// Events list screen: loading, list, empty and error states.
struct EventListView: View {
    
    @State private var viewModel: EventListViewModel
    
    init(viewModel: EventListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        content
            .navigationTitle(AppConstants.Title.events)
            .task {
                await viewModel.loadEvents()
            }
        
    }
    
    /// Picks what to show based on the current state.
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView(AppConstants.Message.loadingEvents)
            
        case .loaded(let events):
            List(events) { event in
                EventRowView(event: event)
            }
            .listStyle(.plain)
            .refreshable {
                await viewModel.loadEvents()
            }
            
        case .empty:
            emptyView
            
        case .error(let apiError):
            errorView(apiError.errorDescription ?? AppConstants.Message.somethingWentWrong)
        }
    }
    
    private var emptyView: some View {
        VStack(spacing: AppConstants.Layout.standardSpacing) {
            Image(systemName: AppConstants.Image.emptyEvents)
                .font(.largeTitle)
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)
            Text(AppConstants.Message.noEvents)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
    
    private func errorView(_ message: String) -> some View {
        VStack(spacing: AppConstants.Layout.standardSpacing) {
            Image(systemName: AppConstants.Image.networkError)
                .font(.largeTitle)
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            Button(AppConstants.Button.retry) {
                Task { await viewModel.loadEvents() }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}


#Preview {
    NavigationStack {
        EventListView(viewModel: AppContainer().makeEventListViewModel())
    }
}
