//
//  ProfileView.swift
//  Nuri
//
//  Created by sama saad on 11/25/25.
//

import SwiftUI
import CoreData

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

    // core data helpers for the profile function
    private var userProfile: UserProfile {
        if let existing = profiles.first {
            return existing
        } else {
            let newProfile = UserProfile(context: viewContext)
            newProfile.user_id = UUID()
            newProfile.created_at = Date()
            newProfile.username = "SomeUser"
            newProfile.skin_type = "Normal"

            do {
                try viewContext.save()
            } catch {
                print("Error creating UserProfile: \(error.localizedDescription)")
            }

            return newProfile
        }
    }

    private var preference: Preference? {
        let request: NSFetchRequest<Preference> = Preference.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "user == %@", userProfile)

        do {
            return try viewContext.fetch(request).first
        } catch {
            print("Error fetching Preference for ProfileView: \(error)")
            return nil
        }
    }

    private var preferredIngredientNames: [String] {
        guard let set = preference?.preferredIngredients as? Set<Ingredient> else {
            return []
        }
        return set
            .compactMap { $0.display_name }
            .sorted()
    }

    private var avoidedIngredientNames: [String] {
        guard let set = preference?.avoidedIngredients as? Set<Ingredient> else {
            return []
        }
        return set
            .compactMap { $0.display_name }
            .sorted()
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
                            .padding(.horizontal, 20)
                            .padding(.bottom, 7)

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Skin Type")
                                .foregroundColor(Color(red: 91/255, green:36/255, blue: 122/255))
                                .font(.custom("Anuphan", size: 20))

                            Text(userProfile.skin_type ?? "Not set")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            // fits better with the layout on smaller screens
                            LazyVGrid(
                                columns: [
                                    GridItem(.flexible(), spacing: 12),
                                    GridItem(.flexible(), spacing: 12)
                                ],
                                spacing: 12
                            ) {
                                ForEach(skinTypes, id: \.self) { type in
                                    let isSelected = (type == (userProfile.skin_type ?? ""))

                                    Button {
                                        updateSkinType(to: type)
                                    } label: {
                                        Text(type)
                                            .font(.system(size: 14, weight: .semibold))
                                            .padding(.vertical, 10)
                                            .frame(maxWidth: .infinity)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(isSelected ?
                                                          Color(red: 127/255, green:96/255, blue: 112/255)
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

                        Rectangle()
                            .fill(Color(red: 154/255, green:152/255, blue: 216/255).opacity(0.52))
                            .frame(height: 2)
                            .frame(maxWidth: 350)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Preferred Ingredients")
                                .foregroundColor(Color(red: 91/255, green:36/255, blue: 122/255))
                                .font(.custom("Anuphan", size: 20))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            if preferredIngredientNames.isEmpty {
                                Text("No preferred ingredients set yet.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            } else {
                                ForEach(preferredIngredientNames, id: \.self) { name in
                                    Text("• \(name)")
                                        .font(.subheadline)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                        .padding(.horizontal, 20)

                        Rectangle()
                            .fill(Color(red: 154/255, green:152/255, blue: 216/255).opacity(0.52))
                            .frame(height: 2)
                            .frame(maxWidth: 350)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Avoidable Ingredients")
                                .foregroundColor(Color(red: 91/255, green:36/255, blue: 122/255))
                                .font(.custom("Anuphan", size: 20))
                                .frame(maxWidth: .infinity, alignment: .leading)

                            if avoidedIngredientNames.isEmpty {
                                Text("No avoidable ingredients set yet.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            } else {
                                ForEach(avoidedIngredientNames, id: \.self) { name in
                                    Text("• \(name)")
                                        .font(.subheadline)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 20) // Space below top bar
                }

                NavBar()
                    .ignoresSafeArea(edges: .bottom)
            }
        }
        .confirmationDialog(
            "Update your skin type",
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
