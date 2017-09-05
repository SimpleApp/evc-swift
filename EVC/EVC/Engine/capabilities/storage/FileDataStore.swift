//
//  fileDataStore.swift
//  EVC
//
//  Created by Benjamin Garrigues on 05/09/2017.

import Foundation


// FileDataStore capability example.
// Persists data on disk, as a single file archive.

class FileDataStore {

    //MARK: - Custom types
    enum FileDataStoreError: Error {
        case documentDirectoryNotFound
        case invalidRootPath(path: URL?)
    }

    //MARK: - Properties
    let rootPath: URL

    //MARK: - Init & configuration
    init(
        //parameters overriding default configuration
        rootPath : URL? = nil) throws {
        guard let rootPath: URL = rootPath ??
                FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first else {
                    throw FileDataStoreError.documentDirectoryNotFound
        }
        self.rootPath = rootPath
    }

    //MARK: - Internal functions
    fileprivate var sampleModelArchivePath : URL {
        return rootPath.appendingPathComponent("sampleModel")
    }

    //MARK: - Public Interface
    func saveModel(_ model: SampleModel?) {
        if let model = model {
            let data = try! JSONEncoder().encode(model)
            try! data.write(to: sampleModelArchivePath)
        } else if FileManager.default.fileExists(atPath: sampleModelArchivePath.path) {
            do {
                try FileManager.default.removeItem(at: sampleModelArchivePath)
            } catch let error {
                print("[FileDataStore] ERROR while trying to remove file at path \(sampleModelArchivePath) : \(error)")
            }
        }
    }

    func loadModel() -> SampleModel? {
        guard let data = try? Data(contentsOf: sampleModelArchivePath) else { return nil }
       return try? JSONDecoder().decode(SampleModel.self,
                            from: data)
    }
}


//MARK: - EVCEngineComponent
extension FileDataStore: EVCEngineComponent {
    func onEngineContextUpdate(context: EVCEngineContext) {
    }
}
