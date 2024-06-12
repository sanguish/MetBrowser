//
//  MainViewModel.swift
//  MetBrowser
//
//  Created by Scott Anguish on 6/11/24.
//

import Foundation

@Observable
class MainViewModel {
    var metObjects: [MetObject] = []
    var status: Status
    var count: Int = 0
    var count2: Int = 0

    @MainActor
    func performQuery(queryString: String) {
        Task {
            let metObjectsCollection = await self.getQueries(queryString: queryString)
            if let metObjectsCollection,
               metObjectsCollection.total > 0 {
                count2 = metObjectsCollection.total
                var index = 0
                count = 0
                for objectID in metObjectsCollection.objectIDs {
                    let metObject = await getObject(objectID: objectID)
                    if let metObject,
                       metObject.classification != "" {
                        metObjects.append(metObject)
                        index = index + 1
                        count = count + 1
                        if index > 79 { break }
                    }
                }
            }
            if metObjectsCollection?.total == 0 {
                status = .empty
            }
        }
    }

    func getQueries(queryString: String) async -> MetObjectsCollection? {
        do {
            let requestType: EndpointRequestType = .query(queryString: queryString)
            let queryObjects = try await EndpointRequest().downloadAsyncAndDecode(MetObjectsCollection.self,
                                                                                  endpointRequest: requestType)
            return queryObjects
        } catch let error as NSError {
            status = .error
            debugPrint("Provide proper user feedback \(error.localizedDescription)")
        }
        return nil
    }

    func getObject(objectID: Int) async -> MetObject?  {
        do {
            let requestType: EndpointRequestType = .object(objectID: objectID)
            let queryObjects = try await EndpointRequest().downloadAsyncAndDecode(MetObject.self,
                                                                                  endpointRequest: requestType)
            return queryObjects
        } catch let error as NSError {
            debugPrint("objectid = \(objectID)")
            debugPrint("Provide proper user feedback \(error.localizedDescription)")
        }
        return nil
    }

    @MainActor
    func updateViews(queryString: String) {
        metObjects = []
        performQuery(queryString: queryString)
    }

    init() {
        status = .noSearch
    }
}
