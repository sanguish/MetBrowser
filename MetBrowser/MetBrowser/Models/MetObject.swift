//
//  MetObject.swift
//  MetBrowser
//
//  Created by Scott Anguish on 6/11/24.
//

import Foundation

/// The `MetObject` contains a selection of data retrieved from the ``EndpointRequestType.object(let objectID)``.
class MetObject: Codable, Identifiable {
    let id: Int
    let isHighlight: Bool
    let accessionNumber, accessionYear: String
    let isPublicDomain: Bool
    let primaryImage, primaryImageSmall: String
    let department, objectName, title, culture: String
    let period, dynasty, reign, portfolio: String
    let artistRole, artistPrefix, artistDisplayName, artistDisplayBio: String
    let artistSuffix, artistAlphaSort, artistNationality, artistBeginDate: String
    let artistEndDate, artistGender: String
    let objectDate: String
    let objectBeginDate, objectEndDate: Int
    let medium, creditLine, city, state: String
    let country, region, metadataDate, repository: String
    
    enum CodingKeys: String, CodingKey {
        case id = "objectID"
        case isHighlight
        case accessionNumber
        case accessionYear
        case isPublicDomain
        case primaryImage
        case primaryImageSmall
        case department
        case objectName
        case title
        case culture
        case period
        case dynasty
        case reign
        case portfolio
        case artistRole
        case artistPrefix
        case artistDisplayName
        case artistDisplayBio
        case artistSuffix
        case artistAlphaSort
        case artistNationality
        case artistBeginDate
        case artistEndDate
        case artistGender
        case objectDate
        case objectBeginDate
        case objectEndDate
        case medium
        case creditLine
        case city
        case state
        case country
        case region
        case metadataDate
        case repository
    }
}

extension MetObject {
    var primaryImageURL: URL {
        if let theURL = URL(string: primaryImage) {
            return theURL
        } else {
            fatalError(primaryImage)
        }
    }

    var primaryImageSmallURL: URL {
        if let theURL = URL(string: primaryImageSmall) {
            return theURL
        } else {
            fatalError(primaryImageSmall)
        }
    }

}
