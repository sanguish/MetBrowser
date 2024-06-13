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
    var loadedAmount: Double = 0

    @MainActor
    func performQuery(queryString: String) {
        var localMetObjects: [MetObject] = []
        Task {
            status = .loading(0.0)
            loadedAmount = 0.0
            let metObjectsCollection = await self.getQueries(queryString: queryString)
            if let metObjectsCollection,
               metObjectsCollection.total > 0 {
                var index = 0
                for objectID in metObjectsCollection.objectIDs {
                    let metObject = await getObject(objectID: objectID)
                    if let metObject,
                       metObject.classification != "" {
                        localMetObjects.append(metObject)
                        index = index + 1
                        status = .loading(Double(index) / 80.0)
                        loadedAmount = (Double(index) / 80.0)
                        if index > 79 { break }
                    }
                }
            }

            metObjects = localMetObjects
            sort()
            if metObjectsCollection?.total == 0 {
                status = .empty
            } else {
                status = .loaded
            }
        }
    }

    func sort(order: Sorting = .forward) {
        if order == .forward {
            metObjects.sort {
                $0.objectBeginDate < $1.objectBeginDate
            }
        } else {
            metObjects.sort {
                $0.objectBeginDate > $1.objectBeginDate
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
