//
//  EVCEngineContext.swift
//  EVC
//
//  Created by Benjamin Garrigues on 05/09/2017.

import Foundation
//Configuration environment
enum EVCEngineEnvironment {
    case development
    case integration
    case production
}

//A context contains common values
struct EVCEngineContext {
    var environment: EVCEngineEnvironment
    var applicationForeground: Bool
    /* Add any other properties you may find useful to your services and capabilities here */
}
