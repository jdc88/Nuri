//
//  MatchingResultsView.swift
//  Nuri
//
//  Created by sama saad on 12/14/25.
//

// this is after the query so pass the searchedText to the function from HomeView

import SwiftUI

struct MatchingResultsView: View {
    @Environment(\.managedObjectContext) private var viewContext

    let searchText: String

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \AppProduct.name, ascending: true)],
        animation: .default
    )
    private var products: FetchedResults<AppProduct>

    // based on the search, filter the products
    private var filteredProducts: [AppProduct] {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            // return all for now if nothing is searched
            return Array(products)
        }

        return products.filter { product in
            let name = product.name ?? ""
            let brand = product.brand ?? ""
            let barcode = product.barcode ?? ""

            return name.localizedCaseInsensitiveContains(trimmed)
                || brand.localizedCaseInsensitiveContains(trimmed)
                || barcode == trimmed
        }
    }
    
    
    var body: some View {
        ZStack {
            Color(red: 245/255, green: 245/255, blue: 245/255)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                
                TopBar()
                ScrollView {
                    VStack(spacing: 30) {
                        Text("Matching Results")
                            .font(.custom("Anuphan", size: 30))
                            .foregroundColor(Color(red: 127/255, green:96/255, blue: 112/255))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20).padding(.bottom, 7)
                        
                        // TODO: Add product list
                        if filteredProducts.isEmpty {
                            Text("No matching products found.").foregroundColor(.secondary).frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal, 20)
                        } else {
                            VStack(spacing: 16) {
                                ForEach(filteredProducts) { product in
                                    NavigationLink(destination: ProductProfileView(product: product)) {
                                        displayProductRow(for: product).padding(.horizontal, 20)
                                    }
                                }
                            }
                        }
                        
                    }
                    .padding(.top, 20) // Space below top bar
                }
                NavBar()
                    .ignoresSafeArea(edges: .bottom)
            }
        }
    }
}

@ViewBuilder
private func displayProductRow(for product: AppProduct) -> some View {
    HStack(spacing: 12) {
        if let imageName = product.imageName, !imageName.isEmpty {
                Image(imageName).resizable().scaledToFill().frame(width: 50, height: 50).clipShape(RoundedRectangle(cornerRadius: 10)).clipped()
        } else {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 50, height: 50)
                .overlay(Image(systemName: "photo"))
                .foregroundStyle(.secondary)
                .opacity(0.3)
        }

        VStack(alignment: .leading, spacing: 4) {
            Text(product.name ?? "Product w/ No Name")
                .font(.headline)

            Text(product.brand ?? "No Brand")
                .font(.subheadline)
                .foregroundColor(.secondary)

            if let barcode = product.barcode, !barcode.isEmpty {
                Text("Barcode: \(barcode)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }

        Spacer()
    }
    .padding(.vertical, 8)
    .background(
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.white)
            .shadow(radius: 1, y: 1)
        )
    }

#Preview {
    MatchingResultsView(searchText: "serum").environment(\.managedObjectContext, PreviewPersistenceController(inMemory: true).container.viewContext)
}
