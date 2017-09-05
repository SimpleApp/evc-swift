//
//  JSONRestAPIBase.swift
//  EVC
//
//  Created by Benjamin Garrigues on 06/09/2017.

import Foundation

// This class can be used as a simple base class for your json rest api capabilities
// Note that it expects a JSON response both in the case of success and errors.
// It can however send a raw body, by setting "bodyIsJson" parameter to false

class JSONRestAPIBase {

    //MARK: - Types
    public enum HTTPVerb:String {
        case get    = "GET"
        case post   = "POST"
        case put    = "PUT"
        case delete = "DELETE"
    }

    public enum JSONRestAPIBaseError: Error {
        case invalidBaseURL(for: EVCEngineEnvironment)
        case invalidRequestURL(path: String?)
        case invalidRequestBody(body: Any?, error:Error?)
        case invalidResponseData(response: URLResponse?)
    }


    //MARK: - Properties
    var urlSession : URLSession
    private (set) var apiBaseURL: URL = URL(fileURLWithPath: "")

    //MARK: - Init & Configuration
    func apiBaseURL(for environment: EVCEngineEnvironment) -> String {
        assertionFailure("[JSONRestAPIBase] apiBaseURL should be overriden")
        return ""
    }

    //MARK: Init
    // For simplicity, we assume that the environment will not change once the app is launched.
    // If you want it to be able to change, then you just have to rebuild the apiBaseURL in onEngineContextUpdate calls.
    init(environment : EVCEngineEnvironment) throws {

        urlSession = URLSession(configuration: URLSessionConfiguration.default)

        guard let baseURL = URL(string: apiBaseURL(for: environment)) else {
            throw JSONRestAPIBaseError.invalidBaseURL(for: environment)
        }
        apiBaseURL = baseURL
    }
    
    //MARK: - Request building
    //MARK: Path builder
    fileprivate func urlForPath( baseURL:URL? = nil,
                             path:String? = nil,
                             parameters:[String:String]?) -> URL? {
        let rootURL = baseURL ?? apiBaseURL
        guard var urlComponents = URLComponents(url:rootURL, resolvingAgainstBaseURL: false) else {return nil}
        if let path = path {
            if urlComponents.path == "" {
                urlComponents.path = path
            } else {
                urlComponents.path += path
            }
        }
        if let parameters = parameters {
             var queryItems = [URLQueryItem]()
             for key in parameters.keys.sorted() {
             queryItems.append(URLQueryItem(name: key, value: parameters[key]))
             }
             urlComponents.queryItems = queryItems
        }
        return urlComponents.url
    }

    //MARK: - Request launching
    func launchRequest(verb: HTTPVerb = .get ,
                              baseURL:URL? = nil, // in case you need to force a base URL only for one specific request.
                              path: String? = nil ,
                              parameters:[String:String]? = nil,
                              headers:[String:String]? = nil,
                              bodyIsJSON: Bool = true,
                              body: Any? = nil,
                              onSuccess:((_ data : Any?, _ response: URLResponse?)->Void)? = nil,
                              onError:((_ error:Error? , _ data: Any?, _ response: URLResponse?) -> Void)? = nil) {
        guard let
            url = self.urlForPath(baseURL: baseURL,
                                  path: path,
                                  parameters: parameters) else {
                onError?(JSONRestAPIBaseError.invalidRequestURL(path: path), nil, nil)
                return
        }

        var request = URLRequest(url: url)
        request.httpMethod = verb.rawValue
        for (header, value) in headers ?? [String:String]() {
            request.setValue(value, forHTTPHeaderField: header)
        }

        //Build request body
        do {
            if let body = body {
                if bodyIsJSON {
                    request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
                } else {
                    request.httpBody = body as? Data
                }
            }
        } catch let error as NSError {
            //JSON body serialization error
            onError?(JSONRestAPIBaseError.invalidRequestBody(body: body, error: error),
                     body, nil)
            return
        }

        //Build data Task
        let dataTask = urlSession.dataTask(with : request){
            (data: Data?, response: URLResponse?, error: Error?) in

            if let httpResponse = response as? HTTPURLResponse {

                let statusSuccess = httpResponse.statusCode >= 200 && httpResponse.statusCode < 300

                //Body JSON parsing (both for success and errors)
                var bodyJSONDeserializeError: Error? = nil
                var dataDic : Any? = nil
                if let data = data, data.isEmpty == false,
                    //We only try to parse the response's body if a handler is provided.
                    (statusSuccess && onSuccess != nil) || (!statusSuccess && onError != nil) {
                    do {
                        dataDic = try JSONSerialization.jsonObject(with: data, options: [])
                    } catch let error {
                        bodyJSONDeserializeError = error
                    }
                }

                //The given error has higher priority than the json deserialization one.
                let forwardedError = error ?? bodyJSONDeserializeError

                //Call the callbacks.
                if statusSuccess && forwardedError == nil {
                    onSuccess?(dataDic, response)
                } else {
                    onError?(forwardedError, dataDic, response)
                }
            } else {
                onError?(error, nil, response)
            }
        }
        dataTask.resume()
    }
}
