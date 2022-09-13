//
//  String+isBlank.swift
//  Snake
//
//  Created by Zvonimir Medak on 22.06.2022..
//

import Foundation

extension String {

    /// Checks if string is empty or contains only whitespaces and newlines
    ///
    /// Returns `true` if string is empty or contains only whitespaces and newlines
    var isBlank: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var isNotBlank: Bool {
        return !isBlank
    }
}

extension Optional where Wrapped == String {

    /// Helper to check if string is nil or empty
    ///
    /// Returns `true` if string is nil, empty or contains only whitespaces and newlines
    var isBlank: Bool {
        return (self ?? "").isBlank
    }

    var isNotBlank: Bool {
        return !isBlank
    }
}
