//
//  ArtistsView.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 6/6/22.
//

import SwiftUI

struct ArtistsView<ViewModel>: View where ViewModel: ArtistsViewModelProtocol {

    @State private var intitialLoading: Bool = false
    @State private var loadingMore: Bool = false
    @State private var searchText: String = ""

    @ObservedObject private var concertService = UserConcertsService.shared

    @ObservedObject private var viewModel: ViewModel
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {

        TabView {
            NavigationStack {
                ZStack {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .opacity(self.intitialLoading ? 1 : 0)

                    VStack {
                        List(viewModel.artists, id: \.id) { artist in
                            NavigationLink(
                                value: ArtistData(id: artist.id.uuidString, name: artist.name)
                            ) {
                                Text(artist.name)
                            }
                            .onAppear {
                                if viewModel.needsToFetchMore(artist: artist) {
                                    self.loadingMore = true
                                    Task {
                                        _ = await self.viewModel.fetchMore()
                                        self.loadingMore = false
                                    }
                                }
                            }
                            if self.intitialLoading {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .opacity(self.loadingMore ? 1 : 0)
                            }
                        }
                        .navigationDestination(for: ArtistData.self) { artist in
                            ArtistShowsView(
                                viewModel: ArtistShowsViewModel(
                                    artist: (
                                        id: artist.id.lowercased(),
                                        name: artist.name
                                    )
                                )
                            )
                        }
                        .searchable(text: self.$viewModel.searchText)


                        if self.viewModel.searchText.isEmpty {
                            SearchIconView()
                                .padding(80)
                                .layoutPriority(1)
                        }

                        Spacer()
                    }
                }
                .navigationTitle(Constants.Artists.headerText)
            }
            .listStyle(.inset)
            .padding(.bottom)
            .tabItem {
                Label("Add", systemImage: "magnifyingglass")
            }
            UserShowsView(viewModel: UserShowsViewModel())
                .tabItem {
                    Label("Attended", systemImage: "music.note.list")
                }
                .badge(
                    concertService.newShowAttendedCount > 0 ? "\(concertService.newShowAttendedCount)" : nil
                )
            Button("sign out") {
                AuthenticationService().logOut()
            }
            .tabItem {
                Label("Account", systemImage: "person.crop.circle.fill")
            }
        }
    }
}

struct SearchIconView: View {

    var body: some View {

        VStack {
            Text("Search for an artist/band")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.bottom)

            Image(systemName: "music.mic.circle")
                .resizable()
                .scaledToFit()
                .padding(.bottom)
                .foregroundColor(.gray)
        }
    }
}

struct ArtistsView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistsView(viewModel: MockArtistsViewModel())
    }
}

class MockArtistsViewModel: ArtistsViewModelProtocol {
    var artists: [ArtistSearch] = [
//        .init(id: UUID(), ticketMasterId: 33333, name: "Deftones", sortName: "", disambiguation: "", url: ""),
//        .init(id: UUID(), ticketMasterId: 44444, name: "Fleetwood Mac", sortName: "", disambiguation: "", url: ""),
//        .init(id: UUID(), ticketMasterId: 55555, name: "ZZ Top", sortName: "", disambiguation: "", url: "")
    ]

    var searchText: String = ""
    func fetch(searchQuery: String) async {}
    func fetchMore() async {}
    func needsToFetchMore(artist: ArtistSearch) -> Bool {
        false
    }
}

struct ArtistData: Hashable {
    let id: String
    let name: String
}
