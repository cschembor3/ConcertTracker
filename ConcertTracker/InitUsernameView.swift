//
//  ContentView.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 5/28/22.
//

import SwiftUI

struct InitUsernameView: View {
    
    @State private var username: String  = ""
    @State private var bands: [String]  = []
    
    var body: some View {
        
        NavigationView {
            VStack {
                Spacer()
                
                Text("Concert Tracker")
                    .padding()
                
                TextField("User name", text: $username)
                    .disableAutocorrection(true)
                    .padding()
                    .textFieldStyle(.roundedBorder)

                Button(action: {
                    let service = UserDefaultsService()
                    service.setValue(username, for: UserDefaultsValues.usernameKey)
                }, label: {
                    NavigationLink(destination: ConcertsView(viewModel: ConcertsViewModel())) {
                        Text("Submit")
                    }
                })

                Spacer()
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        InitUsernameView()
    }
}
