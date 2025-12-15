//
//  RecommendView.swift
//  Nuri
//
//  Created by sama saad on 12/2/25.
//

import SwiftUI

struct RecommendView: View {
    
    var body: some View {
        ZStack {
            Color(red: 245/255, green: 245/255, blue: 245/255)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                
                TopBar()
                ScrollView {
                    VStack(spacing: 15) {
                        
                        // Need to add logic for ai recommendations
                        Text("Recommendations")
                            .font(.custom("Anuphan", size: 30))
                            .foregroundColor(Color(red: 127/255, green:96/255, blue: 112/255))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20).padding(.bottom, 7)
                    }
                    .padding(.top, 20) // Space below top bar
                }
                NavBar()
                    .ignoresSafeArea(edges: .bottom)
            }
        }.ignoresSafeArea(.container, edges: .top)
    }
}

#Preview {
    RecommendView()
}
