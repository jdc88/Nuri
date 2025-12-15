//
//  ProductDetailView.swift
//  Nuri
//
//  Created by Nicklaus Marietta on 12/14/25.
//

// TODO: fix this because it is throwing warning with NSOrderedSet. Suspicion it is due to type mismatch in the entity's attribute field

import SwiftUI
import CoreData

struct ProductDetailView: View {
    @ObservedObject var product: AppProduct
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest var savedEntry: FetchedResults<SavedProduct>
    @FetchRequest var ingredients: FetchedResults<Ingredient>

    init(product: AppProduct) {
        self.product = product

        // fetch all ingredients
        let ingredientIDs = (product.ingredients as? Set<Ingredient>) ?? []
        _ingredients = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Ingredient.display_name, ascending: true)],
            predicate: NSPredicate(format: "self IN %@", ingredientIDs)
        )

        // check if saved already
        _savedEntry = FetchRequest(
            sortDescriptors: [],
            predicate: NSPredicate(format: "product == %@", product)
        )
    }

    var isSaved: Bool { !savedEntry.isEmpty }

    var body: some View {
        List {
            Section(header: Text("Product Details")) {
                Text("**Name:** \(product.name ?? "N/A")")
                Text("**Brand:** \(product.brand ?? "N/A")")
                Text("**INCI List (Raw):**\n\(product.inciList ?? "N/A")")
            }

            Section(header: Text("Ingredients (\(ingredients.count))")) {
                ForEach(ingredients) { ingredient in
                    HStack {
                        Image(systemName: ingredient.isAllergen
                              ? "exclamationmark.triangle.fill"
                              : "checkmark.circle.fill")
                            .foregroundColor(ingredient.isAllergen ? .red : .green)

                        Text(ingredient.display_name ?? "")
                            .font(ingredient.isAllergen ? .headline : .subheadline)
                            .foregroundColor(ingredient.isAllergen ? .red : .primary)
                    }
                }
            }
        }
        .navigationTitle(product.name ?? "Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button(action: toggleSaved) {
                Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
            }
        }
    }

    private func toggleSaved() {
        if let existing = savedEntry.first {
            viewContext.delete(existing) // unsave
        } else {
            let saved = SavedProduct(context: viewContext)
            saved.id = UUID()
            saved.saved_at = Date()
            saved.product = product
        }
        try? viewContext.save()
    }
}
