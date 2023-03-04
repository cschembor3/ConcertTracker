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
                    .init(id: "1", venueName: "Saint Vitus", city: "Brooklyn", date: "02/21/2023"),
                    .init(id: "2", venueName: "Saint Vitus", city: "Brooklyn", date: "02/21/2023")
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
        NavigationLink(destination: Text("Deftones")) {
            HStack {
                Image("music.note")
                    .padding(.leading)

                Text(self.viewModel.displayString)
                    .font(.body)
                    .padding(.leading)

                Spacer()
            }
        }
        .isDetailLink(false)
        .foregroundColor(colorScheme == .dark ? .white : .black)
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
