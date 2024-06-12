//
//  EndpointRequest.swift
//  SwiftMovies
//
//  Created by Scott Anguish on 10/26/23.
//

import Foundation
@MainActor
final class EndpointRequest {

    /// Downloads the provided ``EndpointRequestType`` and decodes it as specified by `T`
    /// - Parameters:
    ///   - _: The type of the data to decode
    ///   - endpointRequest: The ``EndpointRequestType`` to fetch.
    /// - Returns: if successful, returns the decoded type from the JSON, otherwise throws.
    func downloadAsyncAndDecode<T: Decodable>(_: T.Type, endpointRequest: EndpointRequestType) async throws -> T? {

        func handleResponse(data: Data?, response: URLResponse?) -> Data? {
            // Legitimate status codes
            let statusCodeRange = 200...299
            let response = response as? HTTPURLResponse
            guard let data,
                  let response,
                  statusCodeRange.contains(response.statusCode) else {
                // If the `response.statusCode` is wrong this should really throw
                return nil
            }
            return data
        }

        do {
            let request = endpointRequest.urlRequest()
            let (JSONData, response) = try await URLSession.shared.data(for: request)
            let rawJSONData = handleResponse(data: JSONData, response: response)
            if let rawJSONData {
                return try JSONDecoder().decode(T.self, from: rawJSONData)
            }
        } catch let error as NSError {
            throw error
        }
        return nil
    }
}
