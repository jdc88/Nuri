//
//  HomeView.swift
//  Nuri
//
//  Created by sama saad on 11/17/25.
//

import SwiftUI
import PhotosUI
import Vision

struct HomeView: View {
    @State private var productName: String = ""
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    
    @State private var goToResults = false
    
    // helper function to scan
    private func decodeBarcode(from image: UIImage, completion: @escaping (String?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }

        let request = VNDetectBarcodesRequest { request, error in
            if let error = error {
                print("Barcode detection error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let results = request.results as? [VNBarcodeObservation],
                  let first = results.first,
                  let payload = first.payloadStringValue else {
                print("No barcode found in image")
                completion(nil)
                return
            }

            completion(payload)
        }

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("Failed to perform barcode request: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }


    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 245/255, green: 245/255, blue: 245/255)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    TopBar()
                    
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

                                NavigationLink(
                                    destination: MatchingResultsView(searchText: productName)
                                ) {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)
                                }
                                .disabled(productName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                                .opacity(productName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.4 : 1)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color(red: 105/255, green: 101/255, blue: 193/255), lineWidth: 1)
                            )
                            .frame(maxWidth: 350)

                            NavigationLink(
                                destination: MatchingResultsView(searchText: productName),
                                isActive: $goToResults
                            ) {
                                EmptyView()
                            }
                            .hidden()

                            
                            
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
                                        guard let img = selectedImage else { return }

                                        decodeBarcode(from: img) { decoded in
                                            DispatchQueue.main.async {
                                                if let code = decoded {
                                                    print("Decoded barcode: \(code)")
                                                    productName = code
                                                } else {
                                                    print("No barcode detected, falling back to test code")
                                                    productName = "8809504741653"   // backfall on qr data
                                                }
                                                goToResults = true
                                            }
                                        }
                                    }) {
                                        Text("Scan QR Code")
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
                    
                    NavBar()
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
}

#Preview {
    HomeView()
}

