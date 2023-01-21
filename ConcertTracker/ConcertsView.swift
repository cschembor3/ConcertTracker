//
//  ConcertsView.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 6/6/22.
//

import SwiftUI

struct ConcertsView: View {

    @State private var loading: Bool = false

    private var viewModel: ConcertsViewModelProtocol
    init(viewModel: ConcertsViewModelProtocol) {
        self.viewModel = viewModel
    }

    var body: some View {
        
        NavigationView {
            ZStack {
                ScrollView {
                    ForEach(viewModel.concertsAttended) { artistSeen in
                        ArtistCell(artistShowsSeen: artistSeen)
                            .padding(.leading)
                            .padding(.top, 5)
                            .padding(.bottom, 5)
                    }
                }
                
                ProgressView()
                    .progressViewStyle(.circular)
                    .opacity(self.loading ? 1 : 0)
            }
            .navigationTitle("Artists")
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
    }
}

struct ConcertsView_Previews: PreviewProvider {
    static var previews: some View {
        ConcertsView(viewModel: MockConcertsViewModel())
    }
}

struct MockConcertsViewModel: ConcertsViewModelProtocol {
    var concertsAttended: [ArtistSeen] = [
        ArtistSeen(id: UUID().uuidString, name: "Deerhoof", shows: [
            Concert(
                id: UUID(),
                tour: nil,
                venue: Venue(
                    id: UUID().uuidString,
                    name: "Brooklyn",
                    city: Location(
                        id: UUID().uuidString,
                        name: "Elsewhere",
                        state: "New York",
                        stateCode: "",
                        country: Country(code: "", name: "US")
                    )
                ),
                setlist: Setlist(songs: []),
                date: nil
            ),
            Concert(
                id: UUID(),
                tour: nil,
                venue: Venue(
                    id: UUID().uuidString,
                    name: "Brooklyn",
                    city: Location(
                        id: UUID().uuidString,
                        name: "Saint Vitus",
                        state: "New York",
                        stateCode: "",
                        country: Country(code: "", name: "US")
                    )
                ),
                setlist: Setlist(songs: []),
                date: nil
            )
        ]),
        ArtistSeen(id: UUID().uuidString, name: "Deftones", shows: [])
    ]
    func fetch() async {}
}
