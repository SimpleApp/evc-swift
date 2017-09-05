//
//  EVCEngineContext.swift
//  EVC
//
//  Created by Benjamin Garrigues on 05/09/2017.

import Foundation
//Configuration environment
enum Environment {
    case development
    case integration
    case production
}

//A context contains common values
struct EVCEngineContext {
    var environment: Environment
    var applicationForeground: Bool
    /* Add any other properties you may find useful to your services and capabilities here */
}
