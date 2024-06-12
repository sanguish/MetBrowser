//
//  Status.swift
//  MetBrowser
//
//  Created by Scott Anguish on 6/12/24.
//

import Foundation

enum Status {
    case error
    case loading
    case empty
    case noSearch
    case loaded

    var message: String {
        return switch self {
        case .error:
            "Error"
        case .loaded:
            "Loaded"
        case .loading:
            "Loading"
        case .empty:
            "No values found"
        case .noSearch:
            "Begin Search"
        }
    }
}
