//
//  SampleService.swift
//  EVC
//
//  Created by Benjamin Garrigues on 05/09/2017.

import Foundation

protocol SampleServiceObserver {
    func onSampleService(_ service: SampleService, didUpdateSampleDataTo newValue:SampleModel?)
}

// Sample Service
// Provide function for manipulating dummy SampleModel and persist them.
class SampleService {

    //MARK: - Dependencies
    fileprivate let dataStore : FileDataStore
    fileprivate let restAPI   : SampleJSONRestAPI

    //MARK: - Internal State
    fileprivate      var dataLoaded: Bool = false
    fileprivate      var sampleData: SampleModel? = nil
    fileprivate(set) var observers  = WeakObserverOrderedSet<SampleServiceObserver>()

    //MARK: - Init
    init( dataStore: FileDataStore,
          restAPI: SampleJSONRestAPI ) {
        self.dataStore = dataStore
        self.restAPI   = restAPI
    }

    //MARK: - Internal functions
    fileprivate func updateCurrentSampleData(with data: SampleModel?) {
        assert(Thread.isMainThread, "[SampleService] updateCurrentSampleData error : service works on the main thread only.")
        sampleData = data
        observers.invoke { $0.onSampleService(self, didUpdateSampleDataTo: sampleData) }
        dataStore.saveModel(sampleData)
    }

    //MARK: - Public Service API
    //Those are the functions your GUI layer will call.
    //Those are the functions you would create a protocol from, in order to create a mock for unit-testing your GUI.

    public var currentSampleData: SampleModel? { return sampleData }

    public func refreshPosts(onError: ((_ error: Error?) -> Void)?) {
        assert(Thread.isMainThread, "[SampleService] refreshPosts error : service method should be called on the main thread only.")
        restAPI.getSampleModel(
            onSuccess: { [weak self](model) in guard let strongSelf = self else { return }
                strongSelf.updateCurrentSampleData(with: model) },
            onError: onError)
    }
}

//MARK: - EVCEngineComponent
extension SampleService: EVCEngineComponent {
    //load data the first time the engine provide us with some context.
    func onEngineContextUpdate(context: EVCEngineContext) {
        guard dataLoaded == false else { return }
        dataStore.loadModel(callback: {[weak self] (model) in
            if let model = model {
                self?.sampleData = model
            }
            self?.dataLoaded = true
        })
    }
}
