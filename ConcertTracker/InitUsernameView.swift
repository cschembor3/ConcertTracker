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
                
                NavigationLink(destination: ConcertsView()) {
                    
                    Text("Submit")

//                    Task{
//                        let response = try! await SetlistApi().getConcertsAttended(for: username)
//                        bands = response.setlist.map { $0.artist.name }
//                    }
                }
                
//                List {
//                    ForEach(bands, id: \.self) { band in
//                        Text(band)
//                    }
//                }
                
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
