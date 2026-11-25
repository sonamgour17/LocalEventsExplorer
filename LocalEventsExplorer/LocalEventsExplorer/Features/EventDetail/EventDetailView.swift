//
//  EventDetailView.swift
//  LocalEventsExplorer
//
//  Created by Sonam Gour on 2026-11-25.
//

import SwiftUI

/// Full details of one event.
struct EventDetailView: View {
    @State private var viewModel: EventDetailViewModel

    init(viewModel: EventDetailViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    private var event: Event { viewModel.event }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                CachedAsyncImage(url: URL(string: event.imageUrl))
                    .frame(height: AppConstants.Layout.detailImageHeight)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(event.title)
                            .font(.title2.bold())
                        Spacer()
                        BookmarkButton(isBookmarked: viewModel.isBookmarked) {
                            viewModel.toggleBookmark()
                        }
                    }

                    Label(event.location, systemImage: AppConstants.Image.location)
                        .foregroundStyle(.secondary)

                    if let date = event.eventDate {
                        Label(date.formatted(date: .abbreviated, time: .shortened),
                              systemImage: AppConstants.Image.date)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(AppConstants.Title.details)
        .navigationBarTitleDisplayMode(.inline)
    }
}
