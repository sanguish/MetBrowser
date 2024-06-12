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

    @MainActor
    func performQuery(queryString: String) {
        Task {
            let metObjectsCollection = await self.getQueries(queryString: queryString)
            if let metObjectsCollection {
                let subArray = Array(metObjectsCollection.objectIDs.prefix(80))
                for objectID in subArray {
                    let metObject = await getObject(objectID: objectID)
                    if let metObject {
                        metObjects.append(metObject)
                    }
                }
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
            debugPrint("Provide proper user feedback \(error.localizedDescription)")
        }
        return nil
    }


    // this is called when the field gets a return
    @MainActor
    func updateViews(queryString: String) {
        metObjects = []
        performQuery(queryString: queryString)
    }

    init() {
        status = .noSearch
    }
}
