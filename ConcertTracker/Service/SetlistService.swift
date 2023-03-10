//
//  SetlistService.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 6/8/22.
//

import Foundation

protocol SetlistServiceInterface {
    func search(artistName: String) async throws -> ArtistSearchResponse
}

class SetlistService: SetlistServiceInterface {

    private lazy var dateFormatter: DateFormatter = {
        let _dateFormatter = DateFormatter()
        _dateFormatter.dateFormat = "dd-MM-yyyy"
        return _dateFormatter
    }()
   
    private let setlistApi: SetlistApiInterface
    init(setlistApi: SetlistApiInterface) {
        self.setlistApi = setlistApi
    }

    func search(artistName: String) async throws -> ArtistSearchResponse {
        try await self.setlistApi.searchArtists(artistName: artistName)
    }
}

struct Concert: Hashable, Identifiable {
    let id: UUID
    let tour: Tour?
    let venue: Venue
    let setlist: Setlist
    let date: Date?
}

extension Concert {

    init(from show: SetlistResponse, dateFormatter: DateFormatter) {
        self.id = UUID()
        self.tour = show.tour
        self.venue = show.venue
        self.date = dateFormatter.date(from: show.eventDate)
        self.setlist = Setlist(
            artist: show.artist.name,
            songs: show.sets.set.flatMap { $0.song?.map { $0.name } ?? [] }
        )
    }
}

struct Setlist: Hashable {
    let artist: String
    let songs: [String]
}
