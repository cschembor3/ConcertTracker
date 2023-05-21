//
//  ArtistShowsView.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 6/19/22.
//

import SwiftUI

struct ArtistShowsView: View {

    @State private var isLoading: Bool = false
    @State private var loadingMore: Bool = false
    @State private var sets = [ShowDisplayInfo]()
    @ObservedObject private var viewModel: ArtistShowsViewModel

    init(viewModel: ArtistShowsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {

        ZStack {

            // TODO: update to paginate and fetch more results, like in ``ArtistsView``
            List(viewModel.shows, id: \.id) { show in
                NavigationLink(value: show) {
                    Text("\(show.formattedDate) - \(show.venueName ?? "")")
                        .font(.monospaced(.body)())
                }
                .onAppear {
                    if viewModel.needsToFetchMore(show: show) {
                        self.loadingMore = true
                        Task {
                            _ = await self.viewModel.fetchMore()
                            self.loadingMore = false
                        }
                    }
                }
            }
            .navigationDestination(for: ShowDisplayInfo.self) { setlist in
                SetlistView(viewModel: .init(response: setlist.setlistResponse))
                    .navigationTitle(setlist.venueName ?? "")
            }

            ProgressView()
                .opacity(self.isLoading ? 1 : 0)
        }
        .navigationTitle(self.viewModel.artistName)
        .task {
            self.isLoading = true
            _ = await self.viewModel.fetch()
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
