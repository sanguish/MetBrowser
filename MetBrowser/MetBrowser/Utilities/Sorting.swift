//
//  Sorting.swift
//  MetBrowser
//
//  Created by Scott Anguish on 6/13/24.
//

import Foundation

enum Sorting: Int, CaseIterable, Identifiable {
    var id: Self {
        return self
    }

    case forward = 1
    case reverse = 2

    var string: String {
        return switch self {
        case .forward:
            "Ascending"
        case .reverse:
            "Decending"
        }
    }
}
