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
        .padding(.vertical, AppConstants.Layout.verticalPadding)
        .accessibilityElement(children: .combine) // VoiceOver reads the row as one item.
    }
}

#Preview {
    EventRowView(event: .preview)
        .padding()
}

