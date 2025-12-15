//
//  CoreDataManager.swift
//  Nuri
//
//  Created by Nicklaus Marietta on 12/13/25.
//

import CoreData
import Foundation

class CoreDataManager {
    
    static func processAndLinkIngredients(inciList: String, toProduct: AppProduct, context: NSManagedObjectContext) throws{
        let fetchedPref: NSFetchRequest<Preference> = Preference.fetchRequest()
        // use var since we assign this in the do section
        var avoidedNames: [String]
        
        do {
            let userPreference = try context.fetch(fetchedPref).first
            
            let avoidedIngredientsSet = (userPreference?.avoidedIngredients as? Set<Ingredient> ?? [])
            
            avoidedNames = avoidedIngredientsSet.compactMap({ $0.display_name })
        } catch {
            print("Error fetching the user preference.")
            // fallback initialization of the list
            avoidedNames = ["Paraben"]
        }
        
        let ingredientNames = inciList.components(separatedBy: ",").map{ $0.trimmingCharacters(in: .whitespacesAndNewlines)}.filter{ !$0.isEmpty}
        
        for name in ingredientNames {
            let newIngredient = Ingredient(context: context)
            newIngredient.display_name = name
            
            if avoidedNames.contains(name) {
                newIngredient.isAllergen = true
            } else {
                newIngredient.isAllergen = false
            }
            
            // link the ingredient to the product
            toProduct.addToIngredients(newIngredient)
        }
        
    }
}

struct ProductImporter {

    static func importMasterListIfNeeded(context: NSManagedObjectContext) {

        let request: NSFetchRequest<AppProduct> = AppProduct.fetchRequest()
        request.fetchLimit = 1

        let existingCount = (try? context.count(for: request)) ?? 0
        guard existingCount == 0 else {
            print("MasterList already imported and added to CoreData.")
            return
        }

        let masterList = MasterDataLoader.load()
        print("Importing \(masterList.count) products from MasterList.json")

        for item in masterList {
            let product = AppProduct(context: context)
            product.id = item.id
            product.name = item.name
            product.brand = item.brand
            product.inciList = item.inciList
            product.last_updated_at = Date()

            do {
                try CoreDataManager.processAndLinkIngredients(
                    inciList: item.inciList,
                    toProduct: product,
                    context: context
                )
            } catch {
                print("Error linking ingredients for product \(item.name)")
            }
        }

        do {
            try context.save()
            print("MasterList import completed.")
        } catch {
            print("Failed saving imported products: \(error.localizedDescription)")
        }
    }
}
