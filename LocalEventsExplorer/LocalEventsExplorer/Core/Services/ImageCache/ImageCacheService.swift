//
//  ImageCacheService.swift
//  LocalEventsExplorer
//
//  Created by Sonam Gour on 2026-11-25.
//

import Foundation
import UIKit

protocol ImageCacheServiceProtocol: Sendable {
    func loadImage(from url: URL) async -> UIImage?
}

/// In-memory image cache with an LRU limit. Actor = thread-safe.
actor ImageCacheService: ImageCacheServiceProtocol {
    
    private var cache: [URL: UIImage] = [:]
    private var accessOrder: [URL] = []    // oldest first
    private let maxItems: Int
    private let session: URLSession

    init(maxItems: Int = AppConstants.Cache.maximumImages, session: URLSession = .shared) {
        self.maxItems = maxItems
        self.session = session
    }

    func loadImage(from url: URL) async -> UIImage? {
        
        // 1. Return from cache
        if let cached = cache[url] {
            print("CACHE HIT")
            markAsRecentlyUsed(url)
            return cached
        }

        // 2. Download and store
        do {
            let (data, _) = try await session.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            store(image, for: url)
            return image
        } catch {
            return nil   // UI shows a placeholder
        }
    }

    // MARK: - Private
    private func store(_ image: UIImage, for url: URL) {
        cache[url] = image
        markAsRecentlyUsed(url)

        // Over the limit: remove the least recently used
        if accessOrder.count > maxItems {
            
            let oldest = accessOrder.removeFirst()
            cache.removeValue(forKey: oldest)
            print("REMOVED oldest, count: \(cache.count)")
        }
    }

    private func markAsRecentlyUsed(_ url: URL) {
        accessOrder.removeAll { $0 == url }
        accessOrder.append(url)
    }
}
