//
//  fileDataStore.swift
//  EVC
//
//  Created by Benjamin Garrigues on 05/09/2017.

import Foundation


// FileDataStore capability example.
// Persists data on disk, as a single file archive.

class FileDataStore {

    //MARK: - Public Interface
    func persistToDisk(model: SampleModel) {
    }

    func loadModelFromDisk(callback: ((SampleModel?) -> Void)) {
    }
}


//MARK: - EVCEngineComponent
extension FileDataStore: EVCEngineComponent {
    func onEngineContextUpdate(context: EVCEngineContext) {
    }
}
