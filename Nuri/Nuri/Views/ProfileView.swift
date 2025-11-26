//
//  ProfileView.swift
//  Nuri
//
//  Created by sama saad on 11/25/25.
//

import SwiftUI

struct ProfileView: View {
    
    var body: some View {
        ZStack {
            Color(red: 245/255, green: 245/255, blue: 245/255)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                
                TopBarView()
                ScrollView {
                    VStack(spacing: 30) {

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
    ProfileView()
}
