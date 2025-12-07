//
//  HomeView.swift
//  Nuri
//
//  Created by sama saad on 11/17/25.
//

import SwiftUI
import PhotosUI

struct HomeView: View {
    @State private var productName: String = ""
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil

    var body: some View {
        ZStack {
            Color(red: 245/255, green: 245/255, blue: 245/255)
                .ignoresSafeArea()

            VStack(spacing: 0) {

                TopBarView()

                ScrollView {
                    VStack(spacing: 30) {

                        Text("What product would you like to look up?")
                            .foregroundColor(Color(red: 105/255, green:101/255, blue: 193/255))
                            .font(.custom("Anuphan", size: 20))

                        // Search Bar
                        HStack {
                            TextField("Search Product", text: $productName)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)

                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color(red: 105/255, green: 101/255, blue: 193/255), lineWidth: 1)
                        )
                        .frame(maxWidth: 350)


                        Text("Or")
                            .foregroundColor(Color(red: 105/255, green:101/255, blue: 193/255))
                            .font(.custom("Anuphan", size: 20))

                        // Upload button when no image is selected
                        if selectedImage == nil {
                            PhotosPicker(
                                selection: $selectedItem,
                                matching: .images,
                                label: {
                                    Text("Upload QR Code")
                                        .padding(.vertical, 15)
                                        .padding(.horizontal, 50)
                                        .foregroundColor(.white)
                                        .font(.system(size: 16, weight: .semibold))
                                        .background(Color(red: 105/255, green: 101/255, blue: 193/255))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            )
                        }

                        // If an image is selected, show it with an "X" button in case the user chnages their mind and want to upload a different image
                        if let img = selectedImage {
                            VStack(spacing: 12) {
                                ZStack(alignment: .topTrailing) {
                                    Image(uiImage: img)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 230)
                                        .cornerRadius(12)

                                    // X button to clear image
                                    Button {
                                        selectedImage = nil
                                        selectedItem = nil
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(.gray)
                                            .padding(6)
                                    }
                                }

                                // Scan/Search button
                                Button(action: {
                                    print("Run QR scan or product search")
                                    // TODO: Add QR decoding logic here later
                                }) {
                                    Text("Scan QR Code")    // or "Search Product"
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                        .padding(.vertical, 12)
                                        .frame(maxWidth: 250)
                                        .background(Color(red: 105/255, green: 101/255, blue: 193/255))
                                        .cornerRadius(10)
                                }
                            }
                        }


                        Rectangle()
                            .fill(Color(red: 105/255, green: 101/255, blue: 193/255).opacity(0.4))
                            .frame(width: 300, height: 2)

                        Text("Previously Searched")
                            .foregroundColor(Color(red: 105/255, green:101/255, blue: 193/255))
                            .font(.custom("Anuphan", size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)

                        Spacer().frame(height: 40)
                    }
                    .padding(.top, 20)
                }

                NavBarView()
                    .ignoresSafeArea(edges: .bottom)
            }
        }

        .task(id: selectedItem) {
            if let item = selectedItem,
               let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                selectedImage = uiImage
            }
        }
    }
}

#Preview {
    HomeView()
}

