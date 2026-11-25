//
//  CachedAsyncImage.swift
//  LocalEventsExplorer
//
//  Created by Sonam Gour on 2026-11-25.
//

import SwiftUI

struct CachedAsyncImage: View {
    let url: URL?
    
    @Environment(\.imageCache) private var imageCache
    
    @State private var uiImage: UIImage?
    @State private var isLoading = false
    
    var body: some View {
        Group {
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else if isLoading {
                Color.gray.opacity(0.1)
                    .overlay(ProgressView())
            } else {
                // Placeholder
                Color.gray.opacity(0.2)
                    .overlay(
                        Image(systemName: AppConstants.Image.photo)
                            .foregroundStyle(.gray)
                    )
            }
        }
        // Reloads if URL changes; auto-cancelled on disappear
        .task(id: url) {
            guard let url else { return }
            isLoading = true
            uiImage = await imageCache.loadImage(from: url)
            isLoading = false
        }
    }
}

//#Preview {
//    CachedAsyncImage()
//}
