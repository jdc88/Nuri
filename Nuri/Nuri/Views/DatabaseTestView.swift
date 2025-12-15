//
//  DatabaseTestView.swift
//  Nuri
//
//  Created by Nicklaus Marietta on 12/7/25.
//

// TODO: take this file out but the functions inside are important. put them in NuriDataFunctions because they are reusable.

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

struct DatabaseTestView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \AppProduct.name, ascending: true)],
        animation: .default
    )
    private var products: FetchedResults<AppProduct>

    var body: some View {
        NavigationStack {
            List {
                ForEach(products) { product in
                    HStack(spacing: 12) {
                        // Image
                        if let imageName = product.imageName, !imageName.isEmpty {
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .clipped()
                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Image(systemName: "photo")
                                )
                                .foregroundStyle(.secondary)
                                .opacity(0.3)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(product.name ?? "Unnamed Product")
                                .font(.headline)
                            
                            Text(product.brand ?? "No Brand")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            if let barcode = product.barcode {
                                Text("Barcode: \(barcode)")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Database Products")
            .toolbar {
                Button("Add Test Product") {
                    addTestProducts()
                }
            }
        }
    }
    
    private func addTestProducts() {
        let masterList = MasterDataLoader.load()
        
        for item in masterList {
            let newProduct = AppProduct(context: viewContext)
            
            newProduct.id = item.id
            newProduct.name = item.name
            newProduct.brand = item.brand
            newProduct.last_updated_at = Date()
            newProduct.inciList = item.inciList
            newProduct.imageName = item.imageName
            newProduct.barcode = item.barcode
            
            do {
                try CoreDataManager.processAndLinkIngredients(
                    inciList: item.inciList,
                    toProduct: newProduct,
                    context: viewContext
                )
            } catch {
                print("Error processing ingredients for \(item.name)")
            }
        }
        
        do {
            try viewContext.save()
            print("Success: saved \(masterList.count) products to CoreData")
        } catch {
            print("Error saving the products. \(error.localizedDescription)")
        }
    }
}

#Preview {
    DatabaseTestView()
        .environment(\.managedObjectContext,
                     PreviewPersistenceController(inMemory: true).container.viewContext)
}
