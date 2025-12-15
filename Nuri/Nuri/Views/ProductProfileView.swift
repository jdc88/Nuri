//
//  ProductProfileView.swift
//  Nuri
//
//  Created by sama saad on 12/14/25.
//

import SwiftUI

struct ProductProfileView: View {
    @ObservedObject var product: AppProduct

    // helper function which turns the relationship into an array
    private var ingredientsArray: [Ingredient] {
        (product.ingredients as? NSOrderedSet)?
            .array as? [Ingredient] ?? []
    }

    var body: some View {
        ZStack {
            Color(red: 245/255, green: 245/255, blue: 245/255)
                .ignoresSafeArea()

            VStack(spacing: 0) {

                TopBar()

                ScrollView {
                    VStack(spacing: 30) {
                        Text("Product Details")
                            .font(.custom("Anuphan", size: 30))
                            .foregroundColor(Color(red: 127/255, green:96/255, blue: 112/255))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 7)

                        // Main content
                        VStack(alignment: .leading, spacing: 16) {

                            // Image
                            if let imageName = product.imageName, !imageName.isEmpty {
                                Image(imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .padding(.bottom, 8)
                            }

                            Group {
                                Text("Name:")
                                    .font(.headline)
                                Text(product.name ?? "N/A")

                                Text("Brand:")
                                    .font(.headline)
                                    .padding(.top, 8)
                                Text(product.brand ?? "N/A")

                                if let barcode = product.barcode, !barcode.isEmpty {
                                    Text("Barcode:")
                                        .font(.headline)
                                        .padding(.top, 8)
                                    Text(barcode)
                                }

                                Text("INCI List:")
                                    .font(.headline)
                                    .padding(.top, 8)
                                Text(product.inciList ?? "No INCI list available.")
                                    .font(.subheadline)
                            }

                            if !ingredientsArray.isEmpty {
                                Text("Ingredients:")
                                    .font(.headline)
                                    .padding(.top, 8)

                                VStack(alignment: .leading, spacing: 6) {
                                    ForEach(ingredientsArray, id: \.self) { ingredient in
                                        HStack(spacing: 8) {
                                            if ingredient.isAllergen {
                                                Image(systemName: "exclamationmark.triangle.fill")
                                                    .foregroundColor(.red)
                                            } else {
                                                    Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(.green)
                                            }

                                            Text(ingredient.display_name ?? "Unknown Ingredient")
                                                .foregroundColor(
                                                    ingredient.isAllergen ? .red : .primary
                                                )
                                        }
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 20) // Space below top bar
                }

                NavBar()
                    .ignoresSafeArea(edges: .bottom)
            }
        }
    }
}

#Preview {
    let controller = PreviewPersistenceController(inMemory: true)
    let context = controller.container.viewContext

    // this is sample data, it will be different once it's plugged into the actual NuriApp!!
    let product = AppProduct(context: context)
    product.id = UUID()
    product.name = "Random Product"
    product.brand = "Random Brand"
    product.inciList = "Water, Glycerin, Hyaluronic Acid"
    product.imageName = "Nuri Logo"
    product.barcode = "1234567890"

    let ingredient = Ingredient(context: context)
    ingredient.display_name = "Hyaluronic Acid"
    ingredient.isAllergen = false
    product.addToIngredients(ingredient)

    return ProductProfileView(product: product)
        .environment(\.managedObjectContext, context)
}
