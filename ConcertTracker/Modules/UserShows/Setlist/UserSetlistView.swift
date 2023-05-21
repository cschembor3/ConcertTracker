//
//  UserSetlistView.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 3/5/23.
//

import SwiftUI

struct UserSetlistView: View {
    var body: some View {

        VStack {

            List {

                Section("Setlist") {
                    ForEach(1..<5) { _ in
                        Text("Knife prty")
                    }
                }

                Section("Encore") {
                    Text("Passenger")
                }

                Section("Create Playlist") {
                    Button("Spotify") {
                        print("hi")
                    }
                }
            }
        }
        .toolbarRole(.navigationStack)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Text("Deftones")
            }
        }
        .navigationTitle("Gore Tour")
    }
}

struct UserSetlistView_Previews: PreviewProvider {
    static var previews: some View {
        UserSetlistView()
    }
}
