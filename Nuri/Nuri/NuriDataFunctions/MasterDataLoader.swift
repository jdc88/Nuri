//
//  MasterDataLoader.swift
//  Nuri
//
//  Created by Nicklaus Marietta on 12/14/25.
//

import SwiftUI
import CoreData
import Foundation

class MasterList: Identifiable, Decodable {
    let id: UUID
    let name: String
    let brand: String
    let inciList: String
    let imageName: String?   // must match JSON key
    let barcode: String?
}

class MasterDataLoader {
    static func load() -> [MasterList] {
        guard let url = Bundle.main.url(forResource: "MasterList", withExtension: "json") else {
            fatalError("Failed to load MasterList")
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            
            let products = try decoder.decode([MasterList].self, from: data)
            return products
        } catch {
            print("JSON Decoding Error, failed on MasterList.json: \(error)")
            fatalError("MasterList Error")
        }
    }
}

class PreviewPersistenceController {
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "NuriData")
        
        if inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            container.persistentStoreDescriptions = [description]
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Core Data store failed to load: \(error)")
            }
        })
    }
}
