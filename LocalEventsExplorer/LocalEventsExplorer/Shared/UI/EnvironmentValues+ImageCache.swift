//
//  EnvironmentValues+ImageCache.swift
//  LocalEventsExplorer
//
//  Created by Sonam Gour on 2026-11-25.
//

import SwiftUI

/// Shared image cache available to any view via @Environment.
extension EnvironmentValues {
    @Entry var imageCache: ImageCacheServiceProtocol = ImageCacheService()
}
