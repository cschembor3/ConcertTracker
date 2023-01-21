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
            NavigationView {
                ZStack {
                    List {
                        ForEach(viewModel.artists) { artistSeen in
                            Text(artistSeen.name)
                        }
                    }
                    .searchable(text: self.$viewModel.searchText)

                    ProgressView()
                        .progressViewStyle(.circular)
                        .opacity(self.loading ? 1 : 0)
                }
                .navigationTitle(Constants.Artists.headerText)
                .task {
                    Task {
                        self.loading = true
                        await self.viewModel.fetch()
                        self.loading = false
                    }
                }
            }
            .navigationTitle("")
            .padding(.bottom)
            .navigationBarHidden(true)
            .badge(2)
            .tabItem {
                Label("Received", systemImage: "tray.and.arrow.down.fill")
            }
            Text("howdy")
                .tabItem {
                    Label("Sent", systemImage: "tray.and.arrow.up.fill")
                }
            Text("hola")
                .badge("!")
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle.fill")
                }
        }
    }
}

//struct ConcertsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConcertsView(viewModel: MockConcertsViewModel())
//    }
//}

//struct MockConcertsViewModel: ConcertsViewModelProtocol {
//    var concertsAttended: [ArtistSeen] = [
//        ArtistSeen(id: UUID().uuidString, name: "Deerhoof", shows: [
//            Concert(
//                id: UUID(),
//                tour: nil,
//                venue: Venue(
//                    id: UUID().uuidString,
//                    name: "Brooklyn",
//                    city: Location(
//                        id: UUID().uuidString,
//                        name: "Elsewhere",
//                        state: "New York",
//                        stateCode: "",
//                        country: Country(code: "", name: "US")
//                    )
//                ),
//                setlist: Setlist(
//                    artist: "Deerhoof",
//                    songs: []
//                ),
//                date: nil
//            ),
//            Concert(
//                id: UUID(),
//                tour: nil,
//                venue: Venue(
//                    id: UUID().uuidString,
//                    name: "Brooklyn",
//                    city: Location(
//                        id: UUID().uuidString,
//                        name: "Saint Vitus",
//                        state: "New York",
//                        stateCode: "",
//                        country: Country(code: "", name: "US")
//                    )
//                ),
//                setlist: Setlist(
//                    artist: "Deerhoof",
//                    songs: []
//                ),
//                date: nil
//            )
//        ]),
//        ArtistSeen(id: UUID().uuidString, name: "Deftones", shows: [])
//    ]
//    func fetch() async {}
//}
