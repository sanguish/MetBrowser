//
//  Status.swift
//  MetBrowser
//
//  Created by Scott Anguish on 6/12/24.
//

import Foundation

enum Status: Equatable {
    case loading(Double)
    case empty
    case loaded
    case noSearch
    case error(String)
}
