//
//  BookmarkButton.swift
//  LocalEventsExplorer
//
//  Created by Sonam Gour on 2026-11-25.
//

import Foundation
import SwiftUI

/// Reusable bookmark toggle button.
struct BookmarkButton: View {
    let isBookmarked: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                .font(.title2)
                .foregroundStyle(isBookmarked ? .orange : .secondary)
        }
        .accessibilityLabel(isBookmarked ? AppConstants.Button.removeBookmark : AppConstants.Button.addBookmark)
    }
}

#Preview {
    BookmarkButton(isBookmarked: true) {}
}
