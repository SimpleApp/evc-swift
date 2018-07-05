//
//  EVCObservableEngineComponent.swift
//  EVC
//
//  Created by Thibaud David on 05/07/2018.
//  Copyright © 2018 SimpleApp. All rights reserved.
//

import Foundation

protocol EVCObservableEngineComponent: class, EVCEngineComponent {
    
    associatedtype Observer
    
    var observers: WeakObserverOrderedSet<Observer> { get set }
    func register(observer: Observer)
    func unregister(observer: Observer)
    func onRegister(observer: Observer)
}

extension EVCObservableEngineComponent {
    func register(observer: Observer) {
        assert(Thread.isMainThread, "[\(self)] register observer from background thread")
        observers.add(value: observer)
        onRegister(observer: observer)
    }
    func unregister(observer: Observer) {
        assert(Thread.isMainThread, "[\(self)] unregister observer from background thread")
        observers.remove(value: observer)
    }
}
