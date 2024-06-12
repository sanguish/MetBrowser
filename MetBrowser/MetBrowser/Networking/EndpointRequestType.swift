//
//  EndpointRequestType.swift
//  iHangry
//
//  Created by Scott Anguish on 5/2/24.
//

import Foundation

/// The `EndpointRequestType` is used to create a `URLRequest` for a specific endpoint interaction.
enum EndpointRequestType {
    case query(queryString: String)
    case object(objectID: Int)

    func urlRequest() -> URLRequest {

        let headers = [
            "Content-Type": "application/json",
        ]
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "collectionapi.metmuseum.org"
        var queryItemsArray: [URLQueryItem] = []

        switch self {
        case .query(let queryString):
            urlComponents.path = "/public/collection/v1/search"
            queryItemsArray.append(URLQueryItem(name: "q", value: queryString))
        case .object(let objectID):
            urlComponents.path = "/public/collection/v1/objects/\(objectID)"

        }
        urlComponents.queryItems = queryItemsArray
        var request = URLRequest(url: urlComponents.url!)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"
        return request
    }
}
