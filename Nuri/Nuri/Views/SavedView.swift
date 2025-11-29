//
//  SavedView.swift
//  Nuri
//
//  Created by sama saad on 11/25/25.
//

import SwiftUI

struct SavedView: View {
    
    var body: some View {
        ZStack {
            Color(red: 245/255, green: 245/255, blue: 245/255)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                
                TopBarView()
                ScrollView {
                    VStack(spacing: 30) {
                        Text("Saved Products")
                            .font(.custom("Anuphan", size: 30))
                            .foregroundColor(Color(red: 127/255, green:96/255, blue: 112/255))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20).padding(.bottom, 7)
                        
                        // Need to fetch data from the product's profile where user hits save to list then style it
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
    SavedView()
}
