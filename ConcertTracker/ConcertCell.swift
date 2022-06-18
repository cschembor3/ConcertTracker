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
                    }
                }
                .transition(.asymmetric(insertion: .opacity, removal: .scale))
            }
        }
    }
}

//struct ArtistCell_Previews: PreviewProvider {
//    static var previews: some View {
//        ArtistCell(artistName: "Deftones")
//    }
//}

struct ConcertCell: View {

    private let viewModel: ConcertCellViewModel
    init(with viewModel: ConcertCellViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {

        HStack {
            Text(self.viewModel.displayString)
                .padding()

            Spacer()

            Image("music.note.list")
                .padding()
        }
    }
}

//struct ConcertCell_Previews: PreviewProvider {
//    static var previews: some View {
//        ConcertCell()
//    }
//}
