//
//  ConcertsView.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 6/6/22.
//

import SwiftUI

struct ConcertsView<ViewModel>: View where ViewModel: ConcertsViewModelProtocol {

    @State private var loading: Bool = false
    @State private var searchText: String = ""

    @ObservedObject private var viewModel: ViewModel
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {

        TabView {
            NavigationStack {
                ZStack {
                    List {
                        ForEach(viewModel.artists) { artistSeen in
                            NavigationLink(
                                value: ArtistData(id: artistSeen.id.uuidString, name: artistSeen.name)
                            ) {
                                Text(artistSeen.name)
                            }
                        }
                    }
                    .navigationDestination(for: ArtistData.self) { artist in
                        SetlistView(
                            viewModel: ShowsViewModel(
                                artist: (
                                    id: artist.id.lowercased(),
                                    name: artist.name
                                )
                            )
                        )
                    }
                    .searchable(text: self.$viewModel.searchText)

                    ProgressView()
                        .progressViewStyle(.circular)
                        .opacity(self.loading ? 1 : 0)
                }
                .navigationTitle(Constants.Artists.headerText)
            }
            .navigationTitle("")
            .padding(.bottom)
            .navigationBarHidden(true)
            .tabItem {
                Label("Add", systemImage: "magnifyingglass")
            }
            Text("howdy")
                .tabItem {
                    Label("Attended", systemImage: "music.note.list")
                }
            Button("sign out") {
                AuthenticationService().logOut()
            }
            .tabItem {
                Label("Account", systemImage: "person.crop.circle.fill")
            }
        }
    }
}

struct ConcertsView_Previews: PreviewProvider {
    static var previews: some View {
        ConcertsView(viewModel: MockConcertsViewModel())
    }
}

class MockConcertsViewModel: ConcertsViewModelProtocol {

    var artists: [ArtistSearch] = [
        .init(id: UUID(), ticketMasterId: 33333, name: "Deftones", sortName: "", disambiguation: "", url: ""),
        .init(id: UUID(), ticketMasterId: 44444, name: "Fleetwood Mac", sortName: "", disambiguation: "", url: ""),
        .init(id: UUID(), ticketMasterId: 55555, name: "ZZ Top", sortName: "", disambiguation: "", url: "")
    ]

    var searchText: String = ""
    func fetch() async {}
}

struct ArtistData: Hashable {
    let id: String
    let name: String
}
