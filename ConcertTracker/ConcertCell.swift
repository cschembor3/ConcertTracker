//
//  ConcertCell.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 6/12/22.
//

import SwiftUI

struct ArtistCell: View {

    @State private var isExpanded: Bool = false

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

                Text("Artist")

                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                self.isExpanded = !self.isExpanded
            }

            if isExpanded {
                Group {
                    ConcertCell()
                    ConcertCell()
                    ConcertCell()
                }
            }
        }
    }
}

struct ArtistCell_Previews: PreviewProvider {
    static var previews: some View {
        ArtistCell()
    }
}

struct ConcertCell: View {

    var body: some View {

        HStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .padding()

            Spacer()

            Image("music.note.list")
                .padding()
        }
    }
}

struct ConcertCell_Previews: PreviewProvider {
    static var previews: some View {
        ConcertCell()
    }
}
