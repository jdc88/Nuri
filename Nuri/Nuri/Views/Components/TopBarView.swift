//
//  TopBar.swift
//  Nuri
//
//  Created by sama saad on 11/25/25.
//

import SwiftUI

struct TopBarView: View {
    var body: some View {
        HStack {
            Image("Nuri Logo")
                .resizable()
                .scaledToFit()
                .frame(height: 60)

            Spacer()

            Image("Settings Icon")
                .font(.system(size: 30))
                .foregroundColor(Color(red: 105/255, green: 101/255, blue: 193/255))
        }
        .padding(.horizontal)
        .padding(8)
        .padding(.top, 15)
        .ignoresSafeArea(edges: .top)
        
    }
}
