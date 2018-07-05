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
    // Remove fileprivate(set) modifier if using EVCObservableEngineComponent

    //MARK: - Init
    init( dataStore: FileDataStore,
          restAPI: SampleJSONRestAPI ) {
        self.dataStore = dataStore
        self.restAPI   = restAPI
    }

    //MARK: - Internal functions
    fileprivate func updateCurrentSampleData(with data: SampleModel?) {
        assert(Thread.isMainThread, "[SampleService] updateCurrentSampleData from background thread")
        sampleData = data
        observers.invoke { $0.onSampleService(self, didUpdateSampleDataTo: sampleData) }
        dataStore.saveModel(sampleData)
    }

    //MARK: - Public Service API
    //Those are the functions your GUI layer will call.
    //Those are the functions you would create a protocol from, in order to create a mock for unit-testing your GUI.
    // Methods for (un/)registering observer can be omitted if using EVCObservableEngineComponent

    public var currentSampleData: SampleModel? { return sampleData }
    public func register(observer : SampleServiceObserver) {
        assert(Thread.isMainThread, "[SampleService] register observer from background thread")
        observers.add(value: observer)
    }
    public func unregister(observer: SampleServiceObserver) {
        assert(Thread.isMainThread, "[SampleService] unregister observer from background thread")
        observers.remove(value: observer)
    }
    public func refreshData(onError: ((_ error: Error?) -> Void)?) {
        assert(Thread.isMainThread, "[SampleService] refreshData from background thread")
        restAPI.getSampleModel(
            onSuccess: { [weak self](model) in guard let strongSelf = self else { return }
                strongSelf.updateCurrentSampleData(with: model) },
            onError: onError)
    }
}

//MARK: - EVCEngineComponent
//
extension SampleService: EVCEngineComponent {
    
    //load data the first time the engine provide us with some context.
    func onEngineContextUpdate(context: EVCEngineContext) {
        if dataLoaded == false {
            sampleData = dataStore.loadModel()
            dataLoaded = true
        }
    }
    
}
/*
    You can use EVCObservableEngineComponent to avoid defining (un/)registering
    methods. As a tradeof, you'll loose fileprivate(set) modifier for observer
    property
 
extension SampleService: EVCObservableEngineComponent {
    typealias Observer = SampleServiceObserver
    
    // Forward data to new observer
    func onRegister(observer: SampleServiceObserver) {
        observer.onSampleService(self, didUpdateSampleDataTo: sampleData)
    }
    
    //load data the first time the engine provide us with some context.
    func onEngineContextUpdate(context: EVCEngineContext) {
        if dataLoaded == false {
            sampleData = dataStore.loadModel()
            dataLoaded = true
        }
    }
}
*/
