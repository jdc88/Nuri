//
//  SettingsView.swift
//  Nuri
//
//  Created by sama saad on 11/25/25.
//

import SwiftUI

struct SettingsView: View {
    @State private var password: String = "password123"
    @State private var isEnabled1 = false
    @State private var isEnabled2 = false

    var body: some View {
        ZStack {
            Color(red: 245/255, green: 245/255, blue: 245/255)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                TopBarView()

                ScrollView {
                    VStack(spacing: 15) {

                        Text("Settings")
                            .font(.custom("Anuphan", size: 30))
                            .foregroundColor(Color(red: 127/255, green:96/255, blue: 112/255))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20).padding(.bottom, 7)

                        HStack {
                            Text("Account")
                                .font(.custom("Anuphan", size: 20))
                                .foregroundColor(Color(red: 127/255, green:96/255, blue: 112/255))

                            Spacer()

                            Button(action: {
                                // TODO: Add proper functionality to edit user information
                                print("Update tapped")
                            }) {
                                Text("Update")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.vertical, 5)
                                    .padding(.horizontal, 20)
                                    .background(Color(red: 127/255, green:96/255, blue: 112/255))
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal, 20)


                        SettingsCard {
                            SettingRow(label: "Full Name", value: "John Doe")
                            
                            Rectangle().fill(Color.white.opacity(0.38)).frame(height: 1).frame(maxWidth: .infinity)
                            SettingRow(label: "Email Address", value: "johndoe@icloud.com")
                            
                            Rectangle().fill(Color.white.opacity(0.38)).frame(height: 1).frame(maxWidth: .infinity)

                            HStack {
                                Text("Password")
                                    .font(.custom("Anuphan", size: 17))
                                    .foregroundColor(Color(red: 105/255, green: 101/255, blue: 193/255))
                                
                                Spacer()
                                
                                SecureField("••••••••", text: $password)
                                    .font(.custom("Anuphan", size: 17))
                                    .foregroundColor(Color(red: 105/255, green: 101/255, blue: 193/255))
                                    .frame(width: 120)
                            }
                        }
                        
                        Spacer()
                        
                        Text("Notifications")
                            .font(.custom("Anuphan", size: 20))
                            .foregroundColor(Color(red: 127/255, green:96/255, blue: 112/255))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)

                        SettingsCard {
                            HStack {
                                Toggle("Allow Notifications", isOn: $isEnabled1)
                                    .font(.custom("Anuphan", size: 17))
                                    .foregroundColor(Color(red: 105/255, green: 101/255, blue: 193/255))
                                    .toggleStyle(SwitchToggleStyle(tint: Color(red: 127/255, green:96/255, blue: 112/255)))
                                
                                Spacer()
                            }
                            
                            Rectangle().fill(Color.white.opacity(0.38)).frame(height: 1).frame(maxWidth: .infinity)

                            HStack {
                                Toggle("Ingredient Alerts", isOn: $isEnabled2)
                                    .font(.custom("Anuphan", size: 17))
                                    .foregroundColor(Color(red: 105/255, green: 101/255, blue: 193/255))
                                    .toggleStyle(SwitchToggleStyle(tint: Color(red: 127/255, green:96/255, blue: 112/255)))
                                
                                Spacer()
                            }
                        }

                        Spacer()
                        
                        Text("System")
                            .font(.custom("Anuphan", size: 20))
                            .foregroundColor(Color(red: 127/255, green:96/255, blue: 112/255))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)

                        SettingsCard {
                            SettingRow(label: "Language", value: "English")
                            
                            Rectangle().fill(Color.white.opacity(0.38)).frame(height: 1).frame(maxWidth: .infinity)
                            
                            SettingRow(label: "Region", value: "North America")
                            
                            Rectangle().fill(Color.white.opacity(0.38)).frame(height: 1).frame(maxWidth: .infinity)
                            
                            SettingRow(label: "App Version", value: "1.0")
                        }
                    }
                    .padding(.top, 20)
                }

                NavBarView()
                    .ignoresSafeArea(edges: .bottom)
            }
        }
        .ignoresSafeArea(.container, edges: .top)
    }
    // TODO: Add a logout button somewhere
}

#Preview {
    SettingsView()
}

struct SettingsCard<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(spacing: 10) {
            content()
        }
        .padding(17)
        .background(
            Color(red: 154/255, green:152/255, blue: 216/255).opacity(0.44)
        )
        .cornerRadius(10)
        .padding(.horizontal, 20)
    }
}

struct SettingRow: View {
    var label: String
    var value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.custom("Anuphan", size: 15))
                .foregroundColor(Color(red: 105/255, green: 101/255, blue: 193/255))
            
            Spacer()
            
            Text(value)
                .font(.custom("Anuphan", size: 15))
                .foregroundColor(Color(red: 105/255, green: 101/255, blue: 193/255))
        }
    }
}
