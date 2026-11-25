//
//  EventRowView.swift
//  LocalEventsExplorer
//
//  Created by Sonam Gour on 2026-11-25.
//

import SwiftUI

/// One row in the events list.
struct EventRowView: View {
    let event: Event

    var body: some View {
        HStack(spacing: AppConstants.Layout.standardSpacing) {
            CachedAsyncImage(url: URL(string: event.imageUrl))
                .frame(width: AppConstants.Layout.imageSize, height: AppConstants.Layout.imageSize)
                .clipShape(RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadius))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: AppConstants.Layout.smallSpacing) {
                Text(event.title)
                    .font(.headline)
                    .lineLimit(1)

                Text(event.location)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                if let date = event.eventDate {
                    Text(date.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, AppConstants.Layout.verticalPadding)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    EventRowView(event: .preview)
        .padding()
}
