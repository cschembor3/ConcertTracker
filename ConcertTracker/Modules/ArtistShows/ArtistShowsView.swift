//
//  ArtistShowsView.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 6/19/22.
//

import SwiftUI

struct ArtistShowsView: View {

    @State private var isLoading: Bool = false
    @State private var sets = [ShowDisplayInfo]()
    @ObservedObject private var viewModel: ArtistShowsViewModel

    init(viewModel: ArtistShowsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {

        ZStack {

            List(sets, id: \.id) { artistSet in
                NavigationLink(value: artistSet) {
                    Text("\(artistSet.formattedDate) - \(artistSet.venueName ?? "")")
                }
            }
            .id(UUID())
            .navigationDestination(for: ShowDisplayInfo.self) { setlist in
                SetlistView(viewModel: .init(setlist: setlist.setlist))
                    .navigationTitle(setlist.venueName ?? "")
            }

            ProgressView()
                .opacity(self.isLoading ? 1 : 0)
        }
        .navigationTitle(self.viewModel.artistName)
        .task {
            self.isLoading = true
            self.sets = await self.viewModel.fetch()
            self.isLoading = false
        }
    }
}

struct IdentifiableSong: Identifiable {
    let id: UUID = UUID()
    let songName: String
    init(songName: String) {
        self.songName = songName
    }
}

struct ArtistShowsView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistShowsView(viewModel: ArtistShowsViewModel(artist: (id: "12345", name: "Deftones")))
    }
}
