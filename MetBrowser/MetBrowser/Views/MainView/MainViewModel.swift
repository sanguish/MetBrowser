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
    var myTask: Task<Void, Never>?

    var globalSuccessfulObjects: Int = 0

    @MainActor
    func performQuery(queryString: String) {
        var localMetObjects: [MetObject] = []
        Task {
            status = .loading(0.0)
            let metObjectsCollection = await self.getQueries(queryString: queryString)
            if let metObjectsCollection,
               metObjectsCollection.total > 0 {
                var index = 0
                for objectID in metObjectsCollection.objectIDs {
                    let metObject = await getObject(objectID: objectID)
                    if let metObject {
                        localMetObjects.append(metObject)
                        index = index + 1
                        status = .loading(Double(index) / 80.0)
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

    func performTaskQuery(queryString: String) async {
        globalSuccessfulObjects = 0
        metObjects = await withTaskGroup(of: Optional<MetObject>.self, returning: [MetObject].self) { taskGroup in
            let metObjectsCollection = await getQueries(queryString: queryString)
            if let metObjectsCollection {
                for objectID in metObjectsCollection.objectIDs { 
                    taskGroup.addTask { await self.getObject(objectID: objectID)}
                    if globalSuccessfulObjects == 80 {
                        break
                    }
                }
            }

            var metObjects: [MetObject] = []
            var i = 0
            for await result in taskGroup {
                if let result {
                    status = .loading(Double(i) / 100 )
                    metObjects.append(result)
                    i = i + 1
                }
            }
            sort()
            if metObjectsCollection?.total == 0 {
                status = .empty
            } else {
                status = .loaded
            }
            return metObjects
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
        } catch {
        }
        return nil
    }

    func getObject(objectID: Int) async -> MetObject?  {
        do {
            let requestType: EndpointRequestType = .object(objectID: objectID)
            let metObject = try await EndpointRequest().downloadAsyncAndDecode(MetObject.self,
                                                                                  endpointRequest: requestType)
            if metObject?.classification != "",
            let metObject {
                globalSuccessfulObjects = globalSuccessfulObjects + 1
                return metObject
            }
        } catch {
        }
        return nil
    }

    @MainActor
    func killFetch() {
        myTask?.cancel()
        metObjects = []
        status = .noSearch
        myTask = nil 
    }

    @MainActor
    func updateViews(queryString: String) {
        metObjects = []
        myTask = Task {
            await performTaskQuery(queryString: queryString)
        }
    }
    @MainActor func updateViewsSlow(queryString: String) {
        metObjects = []
        performQuery(queryString: queryString)
    }

    init() {
        status = .noSearch
    }
}
