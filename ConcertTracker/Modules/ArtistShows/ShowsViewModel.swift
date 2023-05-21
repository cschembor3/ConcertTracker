//
//  ArtistShowsViewModel.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 2/4/23.
//

import Foundation

@MainActor
final class ArtistShowsViewModel: ObservableObject {

    @Published private(set) var shows = [ShowDisplayInfo]()
    @Published private(set) var hasMore: Bool

    private var page: Int = 1

    private let artist: (id: String, name: String)
    private let setlistApi: SetlistApiInterface
    init(
        artist: (id: String, name: String),
        setlistApi: SetlistApiInterface = SetlistApi()
    ) {
        self.artist = artist
        self.setlistApi = setlistApi
        self.hasMore = true
    }

    func fetch() async -> [ShowDisplayInfo] {
        do {
            let a = try await self.setlistApi.getArtistSetlists(id: self.artist.id, page: 1).setlist
            self.shows = a.map { ShowDisplayInfo(setlistResponse: $0) }
        } catch {
            print("🚨 Error at \(#function): \(error)")
            self.shows = []
        }

        return self.shows
    }

    func fetchMore() async -> [ShowDisplayInfo] {
        do {
            self.page += 1
            let response = try await self.setlistApi.getArtistSetlists(id: self.artist.id, page: self.page)
            guard let total = response.total else { return [] }
            self.shows.append(contentsOf: response.setlist.map { ShowDisplayInfo(setlistResponse: $0) })
            self.hasMore = total > self.shows.count
        } catch {
            print("🚨 Error at \(#function): \(error)")
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
    let setlistResponse: SetlistResponse

    init(setlistResponse: SetlistResponse) {
        self.setlistResponse = setlistResponse
        
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
