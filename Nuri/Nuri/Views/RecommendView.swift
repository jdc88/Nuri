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
                
                TopBarView()
                ScrollView {
                    VStack(spacing: 30) {
                        // Need to add logic for ai recommendations
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
    RecommendView()
}
