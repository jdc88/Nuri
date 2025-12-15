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
            print("JSON Decoding Error, failed on MasterList.json")
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
                        if let isUnsafe = product.ingredients?.compactMap({ ($0 as? Ingredient)?.isAllergen }).contains(true), isUnsafe {
                            Image(systemName: "flag.fill").foregroundColor(.red)
                        }
                        
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
                    Button("Add Test Product", action: addTestProducts)
                }
            }
            .onAppear {
                createTestPreferenceAndAvoidedIngredients()
            }
        }
    }
    
    private func createTestPreferenceAndAvoidedIngredients() {
                
        let fetchRequest: NSFetchRequest<Preference> = Preference.fetchRequest()
        do {
            let count = try viewContext.count(for: fetchRequest)
            if count > 0 {
                print("Preference entity already exists.")
                return
            }
        } catch {
            print("Error checking Preference count: \(error)")
        }
        
        let userPreference = Preference(context: viewContext)
        userPreference.id = UUID()
        
        // Use a list that will definitely conflict with your JSON data for testing
        let ingredientsToAvoid = ["Paraben", "Fragrance", "EDTA"]

        for name in ingredientsToAvoid {
            let avoidedIngredient = Ingredient(context: viewContext)
            avoidedIngredient.display_name = name
            
            userPreference.addToAvoidedIngredients(avoidedIngredient)
        }
        
        do {
            try viewContext.save()
            print("Success: Created test Preference object with \(ingredientsToAvoid.count) avoided ingredients.")
        } catch {
            print("Error saving test preference: \(error.localizedDescription)")
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
            print("Success: saved \(masterList.count) products to the CoreData")
        } catch {
            print("Error saving the products. \(error.localizedDescription)")
        }
    }
    
    private func saveFirstProductForTesting() {
        guard let product = products.first else {
            print("No products to save yet")
            return
        }

        let saved = SavedProduct(context: viewContext)
        saved.id = UUID()
        saved.saved_at = Date()
        saved.product = product

        do {
            try viewContext.save()
            print("Saved product: \(product.name ?? "Unnamed")")
        } catch {
            print("Error saving SavedProduct: \(error.localizedDescription)")
        }
    }

}


// don't forget to pass context into preview object

#Preview {
    DatabaseTestView().environment(\.managedObjectContext, PreviewPersistenceController(inMemory: true).container.viewContext)
}
