//  AppLogger.swift
//  LocalEventsExplorer
//  Created by Sonam Gour on 2026-11-25.

import Foundation
import OSLog

// Centralized logging using OSLog.
nonisolated enum AppLogger {
    private static let subsystem = "com.sonamgour.LocalEventsExplorer"

    static let network = Logger(subsystem: subsystem, category: "Network")
    
    static let persistence = Logger(subsystem: subsystem, category: "Persistence")
    
    static let location = Logger(subsystem: subsystem, category: "Location")
}

extension Logger {

    nonisolated func logError(_ message: String, _ error: Error) {
        self.error("\(message, privacy: .public): \(error.localizedDescription)")
    }
}
