//
//  DatabaseTestView.swift
//  Nuri
//
//  Created by Nicklaus Marietta on 12/7/25.
//

import SwiftUI
import CoreData
import Foundation

class MasterList: Identifiable, Decodable {
    let id: UUID
    let name: String
    let brand: String
    let inciList: String
}

class MasterDataLoader {
    static func load() -> [MasterList] {
        guard let url = Bundle.main.url(forResource: "ProductCatalog", withExtension: "json") else {
            fatalError("Failed to load Product Catalog")
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            
            let products = try decoder.decode([MasterList].self, from: data)
            return products
        } catch {
            print("JSON Decoding Error, failed on ProductCatalog.json")
            fatalError("ProductCatalog Error")
        }
    }
}

fileprivate class PreviewPersistenceController {
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
        // order the results with sortdescriptor
        sortDescriptors: [NSSortDescriptor(keyPath: \AppProduct.name, ascending: true)],
        animation: .default
    )
    // array will be populated with the saved products
    private var products: FetchedResults<Nuri.AppProduct>

    var body: some View {
        NavigationStack {
            List {
                // iterate over the fetched products and then display their name
                ForEach(products) { product in
                    HStack {
                        Text(product.name ?? "Unnamed Product")
                            .font(.headline)
                        
                        Spacer()
                        
                        Text(product.brand ?? "No Brand")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Database Products")
            
            // add button
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Test Product", action: addTestProduct)
                }
            }
        }
    }
    
    private func addTestProduct() {
        let testData: [(name: String, brand: String)] = [
            ("Test Serum", "Brand A"),
            ("Test Cream", "Brand B"),
            ("Test Toner", "Brand C")
        ]
        
        for item in testData {
            let newProduct = AppProduct(context: viewContext)
            
            newProduct.id = UUID()
            newProduct.name = item.name
            newProduct.brand = item.brand
            newProduct.last_updated_at = Date()
        }

        do {
            try viewContext.save()
        } catch {
            print("Error saving test data: \(error.localizedDescription)")
        }
    }
}

// don't forget to pass context into preview object
#Preview {
    DatabaseTestView().environment(\.managedObjectContext, PreviewPersistenceController(inMemory: true).container.viewContext)
}
