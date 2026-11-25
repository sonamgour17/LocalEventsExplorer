//
//  BookmarksView.swift
//  LocalEventsExplorer
//
//  Created by Sonam Gour on 2026-11-25.
//

import SwiftUI

struct BookmarksView: View {

    @State private var viewModel: BookmarksViewModel

    init(viewModel: BookmarksViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        Group {
            if viewModel.bookmarkedEvents.isEmpty {
                emptyState
            } else {
                List {
                    ForEach(viewModel.bookmarkedEvents) { event in
                        NavigationLink(value: AppRoute.eventDetail(event)) {
                            EventRowView(event: event)
                        }
                    }
                    .onDelete { offsets in
                        viewModel.removeBookmarks(at: offsets)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle(AppConstants.Title.bookmarks)
        .onAppear {
            // Reload so new bookmarks show up
            viewModel.loadBookmarks()
        }
    }

    private var emptyState: some View {
        VStack(spacing: AppConstants.Layout.standardSpacing) {
            Image(systemName: AppConstants.Image.emptyBookmark)
                .font(.largeTitle)
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)
            Text(AppConstants.Message.noBookmarks)
                .foregroundStyle(.secondary)
        }
    }
}

// #Preview {
//    BookmarksView()
// }
