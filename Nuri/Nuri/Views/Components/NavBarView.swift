//
//  NavBarView.swift
//  Nuri
//
//  Created by sama saad on 11/18/25.
//

import SwiftUI

struct NavBarView: View {
    var body: some View {
        HStack(spacing: 55) {
            
            NavigationLink(destination: HomeView()) {
                VStack {
                    Image("Home Icon")
                    Text("Home")
                        .foregroundColor(.white)
                        .font(.custom("Anuphan", size: 12))
                }
            }


            NavigationLink(destination: ProfileView()) {
                VStack {
                    Image("Profile Icon")
                    Text("Profile")
                        .foregroundColor(.white)
                        .font(.custom("Anuphan", size: 12))
                }
            }
            
            NavigationLink(destination: RecommendView()) {
                VStack {
                    Image("Recommend Icon")
                    Text("Recommend")
                        .foregroundColor(.white)
                        .font(.custom("Anuphan", size: 12))
                }
            }


            NavigationLink(destination: SavedView()) {
                VStack {
                    Image("Bookmark Icon")
                    Text("Saved")
                        .foregroundColor(.white)
                        .font(.custom("Anuphan", size: 12))
                }
            }
        }
        .font(.system(size: 40))
        .foregroundColor(.white)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(Color(red: 127/255, green: 96/255, blue: 112/255))
        .ignoresSafeArea(edges: .bottom)
    }
}
