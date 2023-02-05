//
//  ShowsViewModel.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 2/4/23.
//

import Foundation

@MainActor
final class ShowsViewModel: ObservableObject {

    @Published private(set) var shows = [ShowDisplayInfo]()


    private let artist: (id: String, name: String)
    private let setlistApi: SetlistApiInterface
    init(
        artist: (id: String, name: String),
        setlistApi: SetlistApiInterface = SetlistApi()
    ) {
        self.artist = artist
        self.setlistApi = setlistApi
    }

    func fetch() async -> [ShowDisplayInfo] {
        do {
            let a = try await self.setlistApi.getArtistSetlists(id: self.artist.id).setlist
            self.shows = a.map { ShowDisplayInfo(setlistResponse: $0) }
        } catch {
            self.shows = []
        }

        return self.shows
    }

    var artistName: String {
        self.artist.name
    }
}

struct ShowDisplayInfo: Identifiable, Hashable {

    private static var inputDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()

    private static var outputDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()

    let id: String
    let formattedDate: String
    let venueName: String?
    let setlist: [Song]

    init(setlistResponse: SetlistResponse) {
        self.id = setlistResponse.id
        self.venueName = setlistResponse.venue.name
        self.setlist = setlistResponse.sets.set.flatMap { $0.song ?? [] }

        if let date = Self.inputDateFormatter.date(from: setlistResponse.eventDate) {
            self.formattedDate = Self.outputDateFormatter.string(from: date)
        } else {
            self.formattedDate = ""
        }
    }
}
