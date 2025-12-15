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

