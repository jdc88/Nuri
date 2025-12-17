//
//  ProfileView.swift
//  Nuri
//
//  Created by sama saad on 11/25/25.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [],
        animation: .default
    )
    private var profiles: FetchedResults<UserProfile>

    @State private var showingSkinTypePicker = false
    
    private let skinTypes = [
            "Normal", "Dry", "Oily", "Combination", "Sensitive"
        ]
    
    private var userProfile: UserProfile {
        if let existing = profiles.first {
            return existing
        } else {
            let newProfile = UserProfile(context: viewContext)
            newProfile.user_id = UUID()
            newProfile.created_at = Date()
            newProfile.username = "SomeUser"
            newProfile.skin_type = "Nromal"

            do {
                try viewContext.save()
            } catch {
                print("Error creating UserProfile: \(error.localizedDescription)")
            }

            return newProfile
        }
    }
    
    var body: some View {
        ZStack {
            Color(red: 245/255, green: 245/255, blue: 245/255)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                
                TopBar()
                ScrollView {
                    VStack(spacing: 15) {
                        
                        Text("Preferences")
                            .font(.custom("Anuphan", size: 30))
                            .foregroundColor(Color(red: 127/255, green:96/255, blue: 112/255))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20).padding(.bottom, 7)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Skin Type")
                                .foregroundColor(Color(red: 91/255, green:36/255, blue: 122/255))
                                .font(.custom("Anuphan", size: 20))

                            // this is what the user  currently has
                            Text(userProfile.skin_type ?? "Not set")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            // map the skin type to the boxes
                            HStack(spacing: 10) {
                                ForEach(skinTypes, id: \.self) { type in
                                    let isSelected = (type == (userProfile.skin_type ?? ""))

                                    Button {
                                        updateSkinType(to: type)
                                    } label: {
                                        Text(type)
                                            .font(.system(size: 14, weight: .semibold))
                                            .padding(.vertical, 10)
                                            .padding(.horizontal, 14)
                                            .frame(maxWidth: .infinity)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(isSelected
                                                          ? Color(red: 127/255, green:96/255, blue: 112/255)
                                                          : Color.white)
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(
                                                        Color(red: 127/255, green:96/255, blue: 112/255)
                                                            .opacity(isSelected ? 1.0 : 0.4),
                                                        lineWidth: isSelected ? 2 : 1
                                                    )
                                            )
                                            .foregroundColor(isSelected ? .white : .primary)
                                    }
                                    .buttonStyle(.plain)
                                }
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
                NavBar().ignoresSafeArea(edges: .bottom)
            }
        }
        .confirmationDialog(
            "Select your skin type",
            isPresented: $showingSkinTypePicker,
            titleVisibility: .visible
        ) {
            ForEach(skinTypes, id: \.self) { type in
                Button(type) {
                    updateSkinType(to: type)
                }
            }
            Button("Cancel", role: .cancel) { }
        }
        .ignoresSafeArea(.container, edges: .top)
    }

private func updateSkinType(to type: String) {
        userProfile.skin_type = type
        do {
            try viewContext.save()
        } catch {
            print("Error saving skin type: \(error.localizedDescription)")
        }
    }
}
    
#Preview {
    ProfileView()
        .environment(
            \.managedObjectContext,
            PreviewPersistenceController(inMemory: true).container.viewContext
        )
}
