//
//  RecommendView.swift
//  Nuri
//
//  Created by sama saad on 12/2/25.
//

import SwiftUI
import CoreData

struct RecommendView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var recommendedProducts: [AppProduct] = []

    var body: some View {
        ZStack {
            Color(red: 245/255, green: 245/255, blue: 245/255)
                .ignoresSafeArea()

            VStack(spacing: 0) {

                TopBar()

                ScrollView {
                    VStack(spacing: 15) {

                        Text("Recommendations")
                            .font(.custom("Anuphan", size: 30))
                            .foregroundColor(Color(red: 127/255, green:96/255, blue: 112/255))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 7)

                        if recommendedProducts.isEmpty {
                            Text("No recommendations yet. Try setting your preferred and avoided ingredients first.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 20)
                        } else {
                            VStack(spacing: 12) {
                                ForEach(recommendedProducts) { product in
                                    NavigationLink(destination: ProductProfileView(product: product)) {
                                        recommendationRow(for: product)
                                            .padding(.horizontal, 20)
                                    }
                                    .buttonStyle(.plain)
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
        .ignoresSafeArea(.container, edges: .top)
        .onAppear {
            recommendedProducts = RecommendationEngine.fetchRecommendations(
                context: viewContext,
                limit: 10
            )
        }
    }

    @ViewBuilder
    private func recommendationRow(for product: AppProduct) -> some View {
        HStack(spacing: 12) {
            if let imageName = product.imageName, !imageName.isEmpty {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .clipped()
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 50, height: 50)
                    .overlay(Image(systemName: "sparkles"))
                    .foregroundStyle(.secondary)
                    .opacity(0.3)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(product.name ?? "Unnamed Product")
                    .font(.headline)

                Text(product.brand ?? "No Brand")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
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
}
