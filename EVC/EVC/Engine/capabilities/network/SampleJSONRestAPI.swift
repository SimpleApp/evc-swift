//
//  SampleRestAPI.swift
//  EVC
//
//  Created by Benjamin Garrigues on 05/09/2017.

import Foundation


// Sample JSON Rest API Capability
// Call jsonplaceholder.typicode.com fake rest apis.
// The threading model for this sample is to work in a background queue, and call the success / error callbacks on the main queue.
class SampleJSONRestAPI: JSONRestAPIBase {


    //MARK: - Properties
    //MARK: - Init & Configuration
    override func apiBaseURL(for environment: EVCEngineEnvironment) -> String {
        // Customize your server url depending on the environment
        switch environment {
        case .development:
            return "http://jsonplaceholder.typicode.com"
        case .integration:
            return "http://jsonplaceholder.typicode.com"
        case .production:
            return "http://jsonplaceholder.typicode.com"
        }
    }

    //MARK: - Public interface
    //Parsing is done on the background queue. callbacks are called on the main queue.
    func getSampleModel(onSuccess: @escaping ((_ model: SampleModel?) -> Void),
                        onError: ((_ error: Error?) -> Void)?) {

        //As an example, we return a the lenght of the body
        launchRequest(verb: .get,
                      path: "/posts",
                      onSuccess: { (data, response) in
                        if let randomPostLength = SampleJSONRestAPI.parsePostsList(data).randomItem() {
                            DispatchQueue.main.async {
                                onSuccess(SampleModel(value: randomPostLength))
                            }
                        } else {
                            DispatchQueue.main.async {
                                onSuccess(nil)
                            }
                        }
        },
                      onError: { (error, data, response) in
                        DispatchQueue.main.async {
                            onError?(error)
                        }
        })
    }
}

//Model Parsing
extension SampleJSONRestAPI {
    static func parsePostsList(_ data: Any?) -> [Int] {
        guard let dataArray = data as? [[String:Any]] else { return []}
        return dataArray.map { (($0["body"] as? String) ?? "").count }
    }
}


//MARK: - EVCEngineComponent
extension SampleJSONRestAPI : EVCEngineComponent {
    func onEngineContextUpdate(context: EVCEngineContext) {
    }
}
