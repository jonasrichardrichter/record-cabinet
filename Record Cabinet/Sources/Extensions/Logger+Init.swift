//
//  Logger+Init.swift
//  Record Cabinet
//
//  Created by Jonas Richard Richter on 17.03.22.
//

import Foundation
import Logging

internal extension Logger {
    init(for label: String) {
        let bundleIdentifier = Bundle.main.bundleIdentifier
        self.init(label: "\(bundleIdentifier ?? "noBundle").\(label)")
    }
}
