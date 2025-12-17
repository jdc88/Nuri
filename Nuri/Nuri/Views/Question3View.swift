//
//  Question3View.swift
//  Nuri
//
//  Created by Josephine Choi on 12/10/25.
//

import SwiftUI
import CoreData

struct Question3View: View {
    @State private var selectedAvoidIngredient: String? = nil
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext

    let avoidIngredients = ["Retinol", "Niacinamide", "Salicylic Acid", "Fragrances", "Alcohols"]

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 220/255, green: 205/255, blue: 227/255)
                    .edgesIgnoringSafeArea(.all)

                ScrollView {
                    VStack(spacing: 0) {
                        // Progress Bar
                        HStack(spacing: 10) {
                            Button(action: {
                                dismiss()
                            }) {
                                Image(systemName: "arrow.left")
                                    .foregroundColor(Color(red: 122/255, green: 97/255, blue: 132/255))
                                    .font(.system(size: 20))
                            }

                            HStack(spacing: 8) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(red: 105/255, green: 101/255, blue: 193/255))
                                    .frame(height: 8)

                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(red: 105/255, green: 101/255, blue: 193/255))
                                    .frame(height: 8)

                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(red: 105/255, green: 101/255, blue: 193/255))
                                    .frame(height: 8)
                            }
                        }
                        .padding(.horizontal, 30)
                        .padding(.top, 20)

                        Spacer()
                            .frame(height: 25)

                        VStack(alignment: .leading, spacing: 0) {
                            Text("Let's Personalize Your Glow")
                                .font(.custom("Anuphan-Bold", size: 26))
                                .foregroundColor(Color(red: 122/255, green: 97/255, blue: 132/255))
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Spacer()
                                .frame(height: 15)

                            Text("Tell us about your skin and preferences so Nuri can tailor ingredient insights just for you.")
                                .font(.custom("Anuphan", size: 16))
                                .foregroundColor(Color(red: 122/255, green: 97/255, blue: 132/255))
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Spacer()
                                .frame(height: 12)

                            // Settings note
                            Text("You can always change these later in Settings.")
                                .font(.custom("Anuphan", size: 16))
                                .foregroundColor(Color(red: 122/255, green: 97/255, blue: 132/255))
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.horizontal, 30)

                        Spacer()
                            .frame(height: 25)

                        Text("Are there any ingredients you prefer to avoid?")
                            .font(.custom("Anuphan-Bold", size: 23))
                            .foregroundColor(Color(red: 91/255, green: 36/255, blue: 122/255))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 30)

                        Spacer()
                            .frame(height: 15)

                        VStack(spacing: 12) {
                            ForEach(avoidIngredients, id: \.self) { ingredientType in
                                Button(action: {
                                    selectedAvoidIngredient = ingredientType
                                }) {
                                    Text(ingredientType)
                                        .font(.custom("Anuphan", size: 20))
                                        .foregroundColor(Color(red: 91/255, green: 36/255, blue: 122/255))
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 55)
                                        .background(
                                            selectedAvoidIngredient == ingredientType
                                                ? Color(red: 232/255, green: 223/255, blue: 245/255)
                                                : Color.clear
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 27.5)
                                                .stroke(Color(red: 91/255, green: 36/255, blue: 122/255), lineWidth: 1.5)
                                        )
                                        .cornerRadius(27.5)
                                }
                            }
                        }
                        .padding(.horizontal, 30)

                        Spacer()
                            .frame(height: 45)

                        NavigationLink(destination: HomeView()) {
                            Text("Save & Continue")
                                .font(.custom("MergeOne-Regular", size: 23))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color(red: 105/255, green: 101/255, blue: 193/255))
                                .cornerRadius(30)
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            if let name = selectedAvoidIngredient {
                                saveAvoidedIngredient(named: name)
                            }
                        })
                        .padding(.horizontal, 30)
                        .disabled(selectedAvoidIngredient == nil)
                        .opacity(selectedAvoidIngredient == nil ? 0.6 : 1)


                        Spacer()
                            .frame(height: 15)

                        Button(action: {
                            dismiss()
                        }) {
                            Text("Skip for now")
                                .font(.custom("MergeOne-Regular", size: 23))
                                .foregroundColor(Color(red: 122/255, green: 97/255, blue: 132/255))
                        }

                        Spacer()
                            .frame(height: 40)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Core Data helpers

    private func getOrCreateUserProfile() -> UserProfile {
        let request: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        request.fetchLimit = 1

        if let existing = (try? viewContext.fetch(request))?.first {
            return existing
        }

        let newProfile = UserProfile(context: viewContext)
        newProfile.user_id = UUID()
        newProfile.created_at = Date()
        newProfile.username = "Guest"
        newProfile.skin_type = "Normal"

        do {
            try viewContext.save()
        } catch {
            print("Error creating default UserProfile: \(error.localizedDescription)")
        }

        return newProfile
    }

    private func saveAvoidedIngredient(named name: String) {
        // 1. Get or create the current user
        let userProfile = getOrCreateUserProfile()

        // 2. Fetch or create Preference for THIS user
        let prefRequest: NSFetchRequest<Preference> = Preference.fetchRequest()
        prefRequest.fetchLimit = 1
        prefRequest.predicate = NSPredicate(format: "user == %@", userProfile)

        let preference: Preference
        do {
            if let existingPref = try viewContext.fetch(prefRequest).first {
                preference = existingPref
            } else {
                preference = Preference(context: viewContext)
                preference.id = UUID()
                preference.type = "preferred"   // or "profile" if you want, not critical
                preference.user = userProfile   // 👈 required, since user is non-optional
            }
        } catch {
            print("Failed to fetch Preference: \(error)")
            return
        }

        // 3. Find matching Ingredient by name (lenient match)
        let ingredientRequest: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        ingredientRequest.fetchLimit = 1
        ingredientRequest.predicate = NSPredicate(
            format: "display_name CONTAINS[cd] %@", name
        )

        do {
            if let ingredient = try viewContext.fetch(ingredientRequest).first {
                preference.addToAvoidedIngredients(ingredient)
                try viewContext.save()
                print("Added \(name) to avoidedIngredients for user \(userProfile.username ?? "")")
            } else {
                print("No Ingredient found with display_name containing \(name)")
            }
        } catch {
            print("Error adding avoided ingredient: \(error)")
        }
    }
}

#Preview {
    Question3View()
        .environment(
            \.managedObjectContext,
            PreviewPersistenceController(inMemory: true).container.viewContext
        )
}
