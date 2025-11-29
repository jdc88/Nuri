//
//  ContentView.swift
//  Nuri
//
//  Created by Josephine Choi on 11/2/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showLogin = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 248/255, green: 238/255, blue: 233/255)
                    .edgesIgnoringSafeArea(.all)

                Image("Nuri Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 231)
                    .opacity(showLogin ? 0 : 1)

                // Login page
                if showLogin {
                    LoginSignupView()
                        .transition(.opacity)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        showLogin = true
                    }
                }
            }
        }
    }
}


// Second page
struct LoginSignupView: View {
    var body: some View {
        ZStack {
            Color(red: 248/255, green: 238/255, blue: 233/255)
                .edgesIgnoringSafeArea(.all)
            
            Image("Nuri Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 185)
                .offset(y: -130)
            
            Text("Illuminate Your Routine")
                .foregroundColor(Color(red: 91/255, green: 36/255, blue: 122/255))
                .font(.custom("Anuphan", size: 20))
// [wght] in the file name is often ignored for the PostScript name; use only the actual PostScript name
                .fontWeight(.bold)
                .offset(y: -55)
            
            Text("Discover clean beauty through clarity, science, and light. With every scan, uncover the truth behind your products, understand what your skin truly needs, and glow with confidence in every choice.")
                .foregroundColor(Color(red: 91/255, green: 36/255, blue: 122/255))
                .font(.custom("Anuphan", size: 12.5))
                .multilineTextAlignment(.center)
                // centers text inside its frame
                .frame(maxWidth: 391)
                .offset(y: -15)
            
            Text("Already have an account? Just sign in!")
                .foregroundColor(Color(red: 122/255, green: 97/255, blue: 132/255))
                .font(.custom("Anuphan", size: 12.5))
                .multilineTextAlignment(.center)
                .frame(maxWidth: 391)
                .offset(y: 150)
            
            VStack(spacing: 13) {

                Button("Get Started") { }
                    .padding()
                    .frame(width: 162, height: 43)
                    .background(Color(red: 0x7A / 255.0, green: 0x61 / 255.0, blue: 0x84 / 255.0))
                    .foregroundColor(Color.white)
                    .cornerRadius(20.84)
                    .offset(y: 88)
                    .font(.custom("MergeOne-Regular", size: 24))

                Button("Sign In") { }
                    .padding()
                    .frame(width: 162, height: 43)
                    .background(Color(red: 154/255, green: 152/255, blue: 216/255))
                    .foregroundColor(Color.white)
                    .cornerRadius(20.84)
                    .offset(y: 88)
                    .font(.custom("MergeOne-Regular", size: 24))
            }
        }
    }
}

#Preview {
    ContentView()
}

#Preview {
    LoginSignupView()
}
