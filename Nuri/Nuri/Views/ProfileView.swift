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
                    VStack(spacing: 15) {
                        
                        Text("Preferences")
                            .font(.custom("Anuphan", size: 30))
                            .foregroundColor(Color(red: 127/255, green:96/255, blue: 112/255))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20).padding(.bottom, 7)
                        
                        HStack {
                            Text("Skin Type")
                                .foregroundColor(Color(red: 91/255, green:36/255, blue: 122/255))
                                .font(.custom("Anuphan", size: 20))

                            Spacer()

                            Button(action: {
                                // TODO: Add the proper functionality for user to edit their skin type
                                print("Update tapped")
                            }) {
                                Text("Update")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 18)
                                    .background(Color(red: 127/255, green:96/255, blue: 112/255))
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal, 20)

                        
                        
                        Rectangle().fill(Color(red: 154/255, green:152/255, blue: 216/255).opacity(0.52)).frame(height: 2).frame(maxWidth: 350)
                        
                        Text("Preferred Ingredients").foregroundColor(Color(red: 91/255, green:36/255, blue: 122/255))
                            .font(.custom("Anuphan", size: 20)).frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                        
                        // Need to fetch the data saved from when the user chose their preferred ingredients then style it
                        
                        Rectangle().fill(Color(red: 154/255, green:152/255, blue: 216/255).opacity(0.52)).frame(height: 2).frame(maxWidth: 350)
                        
                        Text("Avoidable Ingredients").foregroundColor(Color(red: 91/255, green:36/255, blue: 122/255))
                            .font(.custom("Anuphan", size: 20)).frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                        
                        // Need to fetch the data saved from when the user chose their avoidable ingredients then style it
                        
                    }
                    .padding(.top, 20) // Space below top bar
                }
                NavBarView()
                    .ignoresSafeArea(edges: .bottom)
            }
        }.ignoresSafeArea(.container, edges: .top)
    }
}

#Preview {
    ProfileView()
}
