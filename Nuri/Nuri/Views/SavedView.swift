//
//  SavedView.swift
//  Nuri
//
//  Created by sama saad on 11/25/25.
//

import SwiftUI

struct SavedView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SavedProduct.saved_at, ascending: false)],
        animation: .default
    )
    private var savedProducts: FetchedResults<SavedProduct>
    
    var body: some View {
        ZStack {
            Color(red: 245/255, green: 245/255, blue: 245/255)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                
                TopBar()
                ScrollView {
                    VStack(spacing: 30) {
                        Text("Saved Products")
                            .font(.custom("Anuphan", size: 30))
                            .foregroundColor(Color(red: 127/255, green:96/255, blue: 112/255))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20).padding(.bottom, 7)
                        
                        // TODO: Need to fetch data from the product's profile where user hits save to list then style it
                        List {
                            ForEach(savedProducts) { saved in
                                if let product = saved.product {
                                    NavigationLink(destination: ProductDetailView(product: product)) {
                                        HStack {
                                            if let isUnsafe = product.ingredients?
                                                .compactMap({ ($0 as? Ingredient)?.isAllergen })
                                                .contains(true), isUnsafe {
                                                Image(systemName: "flag.fill")
                                                    .foregroundColor(.red)
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
                            }
                            .onDelete(perform: deleteProducts)
                        }
                        // Set a specific height for the list if it's inside a ScrollView
                        .frame(height: 500)
                        .listStyle(.plain)
                        
                    }
                    .padding(.top, 20) // Space below top bar
                }
                NavBar()
                    .ignoresSafeArea(edges: .bottom)
            }
        }
    }
    
    
    private func deleteProducts(offsets: IndexSet) {
        withAnimation {
            offsets.map { savedProducts[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                print("Error deleting saved product: \(error.localizedDescription)")
            }
        }
    }
}



#Preview {
    SavedView().environment(\.managedObjectContext, PreviewPersistenceController(inMemory: true).container.viewContext)
}
