//
//  EVCEngine.swift
//  EVC
//
//  Created by Benjamin Garrigues on 04/09/2017.

import Foundation


class EVCEngine {

    //MARK: - Context
    fileprivate (set) var context: EVCEngineContext

    //MARK: - Capabilities
    //Replace and add your own capabilities
    fileprivate let dataStore : FileDataStore
    fileprivate let restAPI   : SampleJSONRestAPI

    //MARK: - Middlewares
    //Add your own middleware here

    //MARK: - Services
    //Service are the only properties visible from the GUI Layer.
    //Replace and add your own services
    let sampleService: SampleService

    //type of allComponents is array of nullable because a common scenario
    //is to disable components when using the engine in an extension.
    fileprivate var allComponents : [EVCEngineComponent?] {
    return [
        //Capabilities
        dataStore,
        restAPI,
        //Middleware
        //Service
        sampleService]
    }


    //MARK: - Initialization
    //init may become a big function if your engine has a lot of components.
    //This function however should have very little logic beyond creating and injecting components
    init(initialContext : EVCEngineContext,
         //Mock injection for unit-testing purpose
         mockedDatastore: FileDataStore?     = nil,
         mockedRestAPI  : SampleJSONRestAPI? = nil,
         mockedService  : SampleService?     = nil
         ) {

        //Capabilities
        dataStore = mockedDatastore ?? FileDataStore()
        restAPI   = try! mockedRestAPI ?? SampleJSONRestAPI(environment: initialContext.environment)

        //Middlewares

        //Services
        //FIXME: ?? syntax creating a compiler error for unknown reason..
        // sampleService = mockedService ?? SampleService(restAPI: restAPI)
        if let mockedService = mockedService {
            sampleService = mockedService
        } else {
            sampleService = SampleService(dataStore: dataStore,
                                          restAPI: restAPI)
        }

        //Context
        context = initialContext
        propagateContext()
    }

    //MARK: - Internal flow
    fileprivate func propagateContext() {
        for o in allComponents { o?.onEngineContextUpdate(context: context) }
    }

    //MARK: - Public interface
    //MARK: Application State
    //Note : application state may not be available on all platforms (such as extensions)
    //so we don't directly use UIApplication inside the engine, but let the outside provide us with the information
    public func onApplicationDidEnterBackground() {
        context.applicationForeground = false
        propagateContext()
    }

    public func onApplicationDidBecomeActive() {
        context.applicationForeground = true
        propagateContext()
    }
}
