//
//  MetArtifactsCollection.swift
//  MetBrowser
//
//  Created by Scott Anguish on 6/11/24.
//

import Foundation

/// The `MetArtifactsCollection` is the data model that is returned by the ``EndpointRequestType.query(let queryString)``.
class MetArtifactsCollection: Codable, Identifiable {
    let id = UUID()
    let total: Int
    let objectIDs: [Int]

    enum CodingKeys: String, CodingKey {
        case total
        case objectIDs
    }
}
