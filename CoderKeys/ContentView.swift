//
//  ContentView.swift
//  CoderKeys
//
//  Created by Justin Chen on 8/30/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // App Logo
                    Image("app_logo")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .cornerRadius(16)
                    
                    // App Title and Copyright
                    VStack(spacing: 16) {
                        Text("CoderKeys")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("© 2025 nerdyStuff")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                    
                    // App Description
                    VStack(spacing: 16) {
                        Text("A powerful keyboard extension designed specifically for programmers.")
                            .font(.system(size: 16))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    // Setup Instructions
                    VStack(spacing: 16) {
                        Text("How to Use")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        VStack(spacing: 12) {
                            InstructionStep(number: "1", text: "Go to Settings > General > Keyboard > Keyboards")
                            InstructionStep(number: "2", text: "Tap 'Add New Keyboard' and select 'CoderKeys'")
                            InstructionStep(number: "3", text: "Tap on 'CoderKeys' and enable 'Allow Full Access'")
                            InstructionStep(number: "4", text: "Switch to the keyboard by tapping the globe icon")
                        }
                        .padding(.horizontal)
                    }
                    
                    // Action Links
                    VStack(spacing: 12) {
                        Link(destination: URL(string: "https://www.nerdystuff.xyz")!) {
                            HStack {
                                Text("About Us")
                                Spacer()
                                Image(systemName: "arrow.up.right.circle.fill")
                            }
                            .foregroundColor(.blue)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue.opacity(0.1))
                            )
                        }
                        
                        Link(destination: URL(string: "https://www.nerdystuff.xyz/pages/contact-us")!) {
                            HStack {
                                Text("Contact")
                                Spacer()
                                Image(systemName: "arrow.up.right.circle.fill")
                            }
                            .foregroundColor(.blue)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue.opacity(0.1))
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 0)
                }
                .padding(.top, 40)
                .frame(maxWidth: 400) // Fixed maximum width
                .frame(maxHeight: .infinity)
                .padding(.horizontal)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("CoderKeys")
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Forces modal style in all orientations
    }
}

// MARK: - Supporting Views

struct InstructionStep: View {
    let number: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Text(number)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(
                    Circle()
                        .fill(Color.blue)
                )
            
            Text(text)
                .font(.system(size: 14))
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
