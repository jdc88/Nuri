//
//  RecommendationEngine.swift
//  Nuri
//
//  Created by Nicklaus Marietta on 12/16/25.
//

import CoreData
import Foundation

struct RecommendationEngine {

    private static func logistic(_ x: Double) -> Double {
        return 1.0 / (1.0 + exp(-x))
    }

    private static func scoreProduct(
        preferredMatches: Int,
        avoidedMatches: Int,
        isSaved: Bool
    ) -> Double {
        // these are the "weights" which mimic the model
        let wPreferred = 2.0
        let wAvoided  = -3.0
        let wSaved    = 1.0

        let x =
            wPreferred * Double(preferredMatches) +
            wAvoided  * Double(avoidedMatches) +
            wSaved    * Double(isSaved ? 1 : 0)

        return logistic(x)
    }

    static func fetchRecommendations(
        context: NSManagedObjectContext,
        limit: Int = 10
    ) -> [AppProduct] {
        let prefRequest: NSFetchRequest<Preference> = Preference.fetchRequest()
        prefRequest.fetchLimit = 1

        guard let preference = try? context.fetch(prefRequest).first else {
            print("No Preference found, returning empty recommendations.")
            return []
        }

        // build the preferred and avoided ingredients
        let preferredSet = (preference.preferredIngredients as? Set<Ingredient>) ?? []
        let avoidedSet   = (preference.avoidedIngredients   as? Set<Ingredient>) ?? []

        // fetch all
        let productRequest: NSFetchRequest<AppProduct> = AppProduct.fetchRequest()
        guard let allProducts = try? context.fetch(productRequest) else {
            return []
        }

        // score each product with the classifier mimic
        let scored: [(product: AppProduct, score: Double)] = allProducts.map { product in
            let productIngredients = (product.ingredients as? NSOrderedSet)?
                .compactMap { $0 as? Ingredient } ?? []
            let productSet = Set(productIngredients)

            let preferredMatches = productSet.intersection(preferredSet).count
            let avoidedMatches   = productSet.intersection(avoidedSet).count

            let isSaved = (product.savedBy as? Set<SavedProduct>)?.isEmpty == false

            let probability = scoreProduct(
                preferredMatches: preferredMatches,
                avoidedMatches: avoidedMatches,
                isSaved: isSaved
            )

            return (product, probability)
        }

        return scored
            .filter { $0.score > 0.5 }       // can tweak this threshold as fit
            .sorted { $0.score > $1.score }  // highest probability first
            .prefix(limit)
            .map { $0.product }
    }
}
