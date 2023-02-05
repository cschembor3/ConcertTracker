//
//  ConcertCell.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 6/12/22.
//

import SwiftUI

struct ArtistCell: View {

    @State private var isExpanded: Bool = false

    private let artistShowsSeen: ArtistSeen
    init(artistShowsSeen: ArtistSeen) {
        self.artistShowsSeen = artistShowsSeen
    }

    var body: some View {

        VStack(alignment: .leading) {
            HStack {
                if isExpanded {
                    Image("chevron.down.circle")
                        .padding(.leading)
                } else {
                    Image("chevron.right.circle")
                        .padding(.leading)
                }

                Text(self.artistShowsSeen.name)
                    .font(.title2)

                Spacer()
            }
            .animation(nil, value: self.isExpanded)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    self.isExpanded.toggle()
                }
            }

            if isExpanded {
                Group {
                    ForEach(self.artistShowsSeen.shows) { show in

                        ConcertCell(with: ConcertCellViewModel(for: show))
                            .padding(.leading)
                    }
                }
                .padding(.top, 5)
                .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeOut, value: isExpanded)
            }
        }
    }
}

struct ArtistCell_Previews: PreviewProvider {
    static var previews: some View {
        ArtistCell(
            artistShowsSeen: ArtistSeen(
                id: UUID().uuidString,
                name: "Deftones",
                shows: [
                    Concert(
                        id: UUID(),
                        tour: nil,
                        venue: Venue(
                            id: UUID().uuidString,
                            name: "Webster Hall",
                            city: Location(
                                id: UUID().uuidString,
                                name: "New York",
                                state: "NY",
                                stateCode: "",
                                country: Country(code: "", name: "US")
                            )
                        ),
                        setlist: Setlist(
                            artist: "Deftones",
                            songs: [
                                "Be quiet"
                            ]),
                        date: nil
                    ),
                    Concert(
                        id: UUID(),
                        tour: nil,
                        venue: Venue(
                            id: UUID().uuidString,
                            name: "Webster Hall",
                            city: Location(
                                id: UUID().uuidString,
                                name: "New York",
                                state: "NY",
                                stateCode: "",
                                country: Country(code: "", name: "US")
                            )
                        ),
                        setlist: Setlist(
                            artist: "Deftones",
                            songs: [
                                "Be quiet"
                            ]),
                        date: nil
                    )
                ]
            )
        )
    }
}

struct ConcertCell: View {

    @Environment(\.colorScheme) var colorScheme

    private let viewModel: ConcertCellViewModelProtocol
    init(with viewModel: ConcertCellViewModelProtocol) {
        self.viewModel = viewModel
    }

    var body: some View {
//        NavigationLink(destination: SetlistView(artist: (id: "12345", name: "Deftones"))) {
//            HStack {
//                Text(self.viewModel.displayString)
//                    .font(.body)
//                    .padding(.leading)
//
//                Spacer()
//
//                Image("music.note.list")
//                    .padding(.trailing)
//            }
//        }
//        .foregroundColor(colorScheme == .dark ? .white : .black)
        Text("hi")
    }
}

struct ConcertCell_Previews: PreviewProvider {
    static var previews: some View {
        ConcertCell(with: MockConcertCellViewModel())
    }
}

class MockConcertCellViewModel: ConcertCellViewModelProtocol {
    var displayString: String = "Test"
    var setlist: Setlist = Setlist(artist: "Deftones", songs: [])
}
