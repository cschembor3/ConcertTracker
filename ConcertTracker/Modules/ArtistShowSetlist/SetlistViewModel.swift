//
//  SetlistViewModel.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 2/9/23.
//

import Foundation

@MainActor
final class SetlistViewModel: ObservableObject {

    @Published private(set) var songs: [Song]

    init(setlist: [Song]) {
        self.songs = setlist
    }
}
