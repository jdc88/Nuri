//
//  HomeView.swift
//  Nuri
//
//  Created by sama saad on 11/17/25.
//

import SwiftUI

struct HomeView: View {
    @State private var productName: String = ""
    
    var body: some View {
        ZStack {
            Color(red: 245/255, green: 245/255, blue: 245/255)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                
                TopBarView()

                ScrollView {
                    VStack(spacing: 30) {

                        Text("What product would you like to look up?")
                            .foregroundColor(Color(red: 105/255, green:101/255, blue: 193/255))
                            .font(.custom("Anuphan", size: 20))

                        // Search Bar
                        HStack {
                            TextField("Search Product", text: $productName)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                            
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color(red: 105/255, green: 101/255, blue: 193/255), lineWidth: 1)
                        )
                        .frame(maxWidth: 350)

                        Rectangle()
                            .fill(Color(red: 105/255, green: 101/255, blue: 193/255))
                            .frame(width: 300, height: 2)

                        Text("Previously Searched")
                            .foregroundColor(Color(red: 105/255, green:101/255, blue: 193/255))
                            .font(.custom("Anuphan", size: 20)).frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                        
                        // Need to add the logic where all the recently searched products are displayed

                        Spacer().frame(height: 40)
                    }
                    .padding(.top, 20) // Space below top bar
                }

                NavBarView()
                    .ignoresSafeArea(edges: .bottom)
            }
        }
    }
}

#Preview {
    HomeView()
}
