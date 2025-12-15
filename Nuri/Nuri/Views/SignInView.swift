//
//  SignInView.swift
//  Nuri
//
//  Created by Josephine Choi on 12/13/25.
//
import SwiftUI

struct SignInView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 245/255, green: 245/255, blue: 245/255)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Image("Nuri Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80)
                        .padding(.top, 60)
                        .offset(y: -70)
                    
//                    Spacer()
//                        .frame(height: 40)
                    
                    // Title
                    HStack {
                        Text("Welcome back!")
                            .font(.custom("Anuphan", size: 28))
                            .foregroundColor(Color(red: 91/255, green: 36/255, blue: 122/255))
                            .fontWeight(.bold)
                        
                    Spacer()}
                    .padding(.horizontal, 40)
                    
//                    Spacer()
//                        .frame(height: 10)
                    
                    // Form Fields
                    VStack(spacing: 20) {
                        
                        FloatingTxtField(label: "Email", text: $email)
                        
                        FloatingSecField(label: "Password", text: $password)
                        
                        VStack(spacing: 1) {
                            Text("We've missed you!")
                                .font(.custom("Anuphan", size: 16))
                                .foregroundColor(Color(red: 91/255, green: 36/255, blue: 122/255))
                                .multilineTextAlignment(.center)
                            
                            Text("Let's light up your skincare journey! 😊✨")
                                .font(.custom("Anuphan", size: 16))
                                .foregroundColor(Color(red: 91/255, green: 36/255, blue: 122/255))
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal, 40)
                    
//                    Spacer()
//                        .frame(height: 5)
                    
                    Button(action: {
                    }) {
                        Text("Sign In")
                            .font(.custom("MergeOne-Regular", size: 30))
                            .foregroundColor(.white)
                            .frame(width: 220, height: 55)
                            .background(Color(red: 154/255, green: 152/255, blue: 216/255))
                            .cornerRadius(27.5)
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

// Floating TextField Component
struct FloatingTxtField: View {
    let label: String
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Background and border
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color(red: 91/255, green: 36/255, blue: 122/255), lineWidth: 1.5)
                .frame(height: 55)
                .background(Color(red: 245/255, green: 245/255, blue: 245/255))
                .cornerRadius(25)
            
            // Floating label
            Text(label)
                .font(.custom("Anuphan", size: !text.isEmpty || isFocused ? 12 : 16))
                .foregroundColor(Color(red: 91/255, green: 36/255, blue: 122/255).opacity(0.7))
                .padding(.horizontal, 8)
                .background(Color(red: 245/255, green: 245/255, blue: 245/255))
                .offset(x: 20, y: !text.isEmpty || isFocused ? -28 : 0)
            
            // Text field
            TextField("", text: $text)
                .font(.custom("Anuphan", size: 16))
                .foregroundColor(.black)
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .focused($isFocused)
        }
        .animation(.easeInOut(duration: 0.2), value: text.isEmpty)
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

// Floating SecureField Component
struct FloatingSecField: View {
    let label: String
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Background and border
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color(red: 91/255, green: 36/255, blue: 122/255), lineWidth: 1.5)
                .frame(height: 55)
                .background(Color(red: 245/255, green: 245/255, blue: 245/255))
                .cornerRadius(25)
            
            // Floating label
            Text(label)
                .font(.custom("Anuphan", size: !text.isEmpty || isFocused ? 12 : 16))
                .foregroundColor(Color(red: 91/255, green: 36/255, blue: 122/255).opacity(0.7))
                .padding(.horizontal, 8)
                .background(Color(red: 245/255, green: 245/255, blue: 245/255))
                .offset(x: 20, y: !text.isEmpty || isFocused ? -28 : 0)
            
            // Secure field
            SecureField("", text: $text)
                .font(.custom("Anuphan", size: 16))
                .foregroundColor(.black)
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .focused($isFocused)
        }
        .animation(.easeInOut(duration: 0.2), value: text.isEmpty)
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

#Preview {
    SignInView()
}
