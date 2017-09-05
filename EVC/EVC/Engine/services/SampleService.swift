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

    //MARK: - Public Service API
    //Those are the functions your GUI layer will call.
    //Those are the functions you would create a protocol from, in order to create a mock for unit-testing your GUI.
    public var currentSampleData: SampleModel? { return sampleData }
    public func doSomething() {
    }
}

//MARK: - EVCEngineComponent
extension SampleService: EVCEngineComponent {
    //load data the first time the engine provide us with some context.
    func onEngineContextUpdate(context: EVCEngineContext) {
        guard dataLoaded == false else { return }
        dataStore.loadModelFromDisk(callback: {[weak self] (model) in
            if let model = model {
                self?.sampleData = model
            }
            self?.dataLoaded = true
        })
    }
}
