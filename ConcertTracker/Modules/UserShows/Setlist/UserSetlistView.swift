//
//  UserSetlistView.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 3/5/23.
//

import SwiftUI

struct UserSetlistView: View {

    @ObservedObject private var viewModel: UserSetlistViewModel
    init(viewModel: UserSetlistViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {

        VStack {

            List {

                Section("Setlist") {
                    ForEach(viewModel.setlist?.setlist.setSongs ?? [], id: \.self) { song in
                        Text(song)
                    }
                }

                if let encores = viewModel.setlist?.setlist.encores,
                   !encores.isEmpty {

                    ForEach(encores) { encore in
                        Section("Encore \(encore.number)") {
                            ForEach(encore.songs, id: \.self) { song in
                                Text(song)
                            }
                        }
                    }
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
        UserSetlistView(viewModel: UserSetlistViewModel(showId: "bb8a5f2"))
    }
}
