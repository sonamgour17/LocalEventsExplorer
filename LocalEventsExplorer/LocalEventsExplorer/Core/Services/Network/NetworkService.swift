//
//  NetworkService.swift
//  LocalEventsExplorer
//
//  Created by Sonam Gour on 2026-11-25.
//

import Foundation
import OSLog

protocol NetworkServiceProtocol: Sendable {
    func fetch<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetch<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        guard let url = endpoint.url else { throw APIError.invalidURL }

        do {
            let (data, response) = try await session.data(from: url)

            // HTTP response.
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.unknown
            }

            // Status codes
            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.serverError(statusCode: httpResponse.statusCode)
            }
            // Convert the JSON into our model.
            return try JSONDecoder().decode(T.self, from: data)

        } catch let error as APIError {
            throw error
        } catch is DecodingError {
            throw APIError.decodingFailed
        } catch let error as URLError where error.code == .cancelled {
            throw CancellationError()
        } catch let error as URLError {
            // No internet
            AppLogger.network.logError(AppConstants.LogMessage.networkRequestFailed, error)
            throw APIError.noInternet
        } catch {
            throw APIError.unknown
        }
    }
}
