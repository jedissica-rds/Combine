//
//  Menu.swift
//  Combine_Study
//
//  Created by Jessica Rodrigues on 24/09/24.
//

import SwiftUI

struct Menu: View {
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink {
                    Password()
                } label: {
                    Text("Password - UI Update")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                NavigationLink {
                    Search()
                } label: {
                    Text("Search - API Consumption")
                        .font(.headline)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                NavigationLink {
                    TeamScore()
                } label: {
                    Text("Team Score - Fast-Paced Data")
                        .font(.headline)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}

#Preview {
    Menu()
}
