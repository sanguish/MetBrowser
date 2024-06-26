//
//  MainViewModel.swift
//  MetBrowser
//
//  Created by Scott Anguish on 6/11/24.
//

import Foundation

@Observable
class MainViewModel {
    @MainActor var metArtifacts: [MetArtifact] = []
    var status: Status
    var myTask: Task<Void, Never>?

    /// Performs the query, creating a task group that first loads a ``MetArtifactsCollection`` and then iterates over the items until 80 successful objects are returned.
    /// - Parameter queryString: The query string.
    @MainActor
    func performTaskQuery(queryString: String) async {
        var artifactsRetrievedWithClassification = 0.0
        metArtifacts = await withTaskGroup(of: Optional<MetArtifact>.self, returning: [MetArtifact].self) { taskGroup in
            let metArtifactsCollection = await getQueries(queryString: queryString)
            if let metArtifactsCollection {
                let partialArtifactsCollection = Array(metArtifactsCollection.objectIDs.prefix(80))
                artifactsRetrievedWithClassification = Double(partialArtifactsCollection.count)
                for objectID in partialArtifactsCollection {
                    _ = taskGroup.addTaskUnlessCancelled { await self.getObject(objectID: objectID)}
                }
            }

            // In the, currently impossible, case of no results, set the status and return an empty array.
            if let metArtifactsCollection,
               metArtifactsCollection.total == 0 {
                status = .empty
                return [MetArtifact]()
            }
            var localMetArtifacts: [MetArtifact] = []
            var percentage = 0.0
            for await result in taskGroup {
                if let result {
                    status = .loading(percentage / artifactsRetrievedWithClassification)
                    localMetArtifacts.append(result)
                }
                percentage += 1

            }
            sort()
            if case .loading = status {
                status = .loaded
            }
            return localMetArtifacts
        }
    }
    
    /// Requests a collection of artifact objectIDs for the specific queryString. The `hasImages` flag is set to `true`.
    /// - Parameter queryString: The string to query.
    /// - Returns: A ``MetArtifactsCollection``.
    @MainActor
    func getQueries(queryString: String) async -> MetArtifactsCollection? {
        do {
            let requestType: EndpointRequestType = .query(queryString: queryString)
            let queryObjects = try await EndpointRequest().downloadAsyncAndDecode(MetArtifactsCollection.self,
                                                                                  endpointRequest: requestType)
            return queryObjects
        } catch {
            status = .error(error.localizedDescription)
        }
        return nil
    }
    
    /// Requests an article with the given `objectID` from the `.object(objectID)` endpoint. Each successful return also increments the counter to ensure that we shouldn't be exceeding the 80 total results.
    /// - Parameter objectID: The objectID returned by the query call
    /// - Returns: If the artifact exists and has a classification, it returns the artifact.
    @MainActor
    func getObject(objectID: Int) async -> MetArtifact?  {
        do {
            let requestType: EndpointRequestType = .object(objectID: objectID)
            let metObject = try await EndpointRequest().downloadAsyncAndDecode(MetArtifact.self,
                                                                                  endpointRequest: requestType)
            if metObject?.classification != "" {
                return metObject
            }
        } catch {
            // Some feedback should be provided here. However, it's unclear what. Sometimes we are given objectIDs that don't actually exist and there is no recovery from that.
        }
        return nil
    }

    // MARK: Actions called by MainView

    /// Sort the artifacts in the correct order. Whem a fetch is done, the default is to sort in the forward mode
    /// - Parameter order: Sorts forward or backward
    @MainActor
    func sort(order: Sorting = .forward) {
        metArtifacts.sort {
            if order == .forward {
                $0.objectBeginDate < $1.objectBeginDate
            } else {
                $0.objectBeginDate > $1.objectBeginDate
            }
        }
    }

    @MainActor
    func killFetch() {
        myTask?.cancel()
        myTask = nil
    }

    @MainActor
    func updateViews(queryString: String) {
        metArtifacts = []
        myTask = Task {
            await performTaskQuery(queryString: queryString)
        }
    }

    init() {
        status = .noSearch
    }
}
