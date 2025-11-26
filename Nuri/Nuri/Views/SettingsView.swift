//
//  SettingsView.swift
//  Nuri
//
//  Created by sama saad on 11/25/25.
//

import SwiftUI

struct SettingsView: View {
    @State private var password: String = "password123"

    var body: some View {
        ZStack {
            Color(red: 245/255, green: 245/255, blue: 245/255)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                
                TopBarView()
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Settings")
                            .font(.custom("Anuphan", size: 30))
                            .foregroundColor(Color(red: 127/255, green:96/255, blue: 112/255))
                            .frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal, 20)
                        
                        Text("Account")
                            .font(.custom("Anuphan", size: 20))
                            .foregroundColor(Color(red: 127/255, green:96/255, blue: 112/255))
                            .frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal, 20)
                        
                        // Settings Card
                        VStack(spacing: 15) {
                            SettingRow(label: "Full Name", value: "John Doe")
                            Rectangle()
                                .fill(Color(.white))
                                .frame(width: 320, height: 2).opacity(0.38)
                            
                            SettingRow(label: "Email Address", value: "johndoe@icloud.com")

                            Rectangle()
                                .fill(Color(.white))
                                .frame(width: 320, height: 2).opacity(0.38)
                            
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
                        .padding(20)
                        .background(Color(red: 154/255, green:152/255, blue: 216/255)).opacity(0.75)
                        .cornerRadius(15)
                        .padding(.horizontal, 20)
                        
                        Text("Notifications")
                            .font(.custom("Anuphan", size: 20))
                            .foregroundColor(Color(red: 127/255, green:96/255, blue: 112/255))
                            .frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal, 20)
                        
                        Text("System")
                            .font(.custom("Anuphan", size: 20))
                            .foregroundColor(Color(red: 127/255, green:96/255, blue: 112/255))
                            .frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal, 20)
                        
                        
                        // System Card
                        VStack(spacing: 15) {
                            SettingRow(label: "Language", value: "English")
                            
                            Rectangle()
                                .fill(Color(.white))
                                .frame(width: 320, height: 2).opacity(0.38)
                            
                            SettingRow(label: "Region", value: "North America")

                            Rectangle()
                                .fill(Color(.white))
                                .frame(width: 320, height: 2).opacity(0.38)
                            
                            SettingRow(label: "App Version", value: "1.0")
                            

                        }
                        .padding(20)
                        .background(Color(red: 154/255, green:152/255, blue: 216/255)).opacity(0.75)
                        .cornerRadius(15)
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)

                }
                
                NavBarView()
                    .ignoresSafeArea(edges: .bottom)
            }
        }
    }
}

#Preview {
    SettingsView()
}

// Reusable rows
struct SettingRow: View {
    var label: String
    var value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.custom("Anuphan", size: 17))
                .foregroundColor(Color(red: 105/255, green: 101/255, blue: 193/255))
            Spacer()
            Text(value)
                .font(.custom("Anuphan", size: 17))
                .foregroundColor(Color(red: 105/255, green: 101/255, blue: 193/255))
        }
    }
}
