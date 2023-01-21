//
//  SetlistView.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 6/19/22.
//

import SwiftUI

struct SetlistView: View {

    private let setlist: Setlist
    init(setlist: Setlist) {
        self.setlist = setlist
    }

    var body: some View {

        List {
            ForEach(self.setlist.songs.map { IdentifiableSong(songName: $0)}) { song in
                Text(song.songName)
            }
        }
        .navigationTitle(self.setlist.artist)
        .padding(.bottom)
    }
}

struct IdentifiableSong: Identifiable {
    let id: UUID = UUID()
    let songName: String
    init(songName: String) {
        self.songName = songName
    }
}

//struct SetlistView_Previews: PreviewProvider {
//    static var previews: some View {
//        SetlistView()
//    }
//}
