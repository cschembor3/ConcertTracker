//
//  SetlistService.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 6/8/22.
//

import Foundation

protocol SetlistServiceInterface {
    func search(artistName: String) async throws -> ArtistSearchResponse
    func getConcertsAttended(for username: String, sortedBy: SetlistService.SortOption) async throws -> [ArtistSeen]
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

    func getConcertsAttended(for username: String, sortedBy: SortOption = .alphabetically) async throws -> [ArtistSeen] {
        let response = try await self.setlistApi.getConcertsAttended(for: username)
        let artists = Dictionary(grouping: response.setlist, by: {$0.artist.mbid})
        var data: [ArtistSeen] = []
        artists.forEach { (artistId, artist) in
            let concerts = artist.map { show in
                Concert(from: show, dateFormatter: self.dateFormatter)
            }

            guard let name = artist.first?.artist.name else { return }
            data.append(
                ArtistSeen(
                    id: artistId,
                    name: name,
                    shows: concerts
                )
            )
        }

        switch sortedBy {
        case .dateAscending:
            return data.sorted { artist1, artist2 in
                self.getMostRecentDate(from: artist1.shows) ?? Date.distantPast <
                    self.getMostRecentDate(from: artist2.shows) ?? Date.distantPast
            }
        case .dateDescending:
            return data.sorted { artist1, artist2 in
                self.getMostRecentDate(from: artist1.shows) ?? Date.distantPast <
                    self.getMostRecentDate(from: artist2.shows) ?? Date.distantPast
            }.reversed()
        case .alphabetically:
            return data.sorted { artist1, artist2 in
                artist1.name < artist2.name
            }
        }
    }

    enum SortOption {
        case dateAscending
        case dateDescending
        case alphabetically
    }

    private func getMostRecentDate(from shows: [Concert]) -> Date? {
        let mostRecentShow = shows.reduce(nil as Concert?, { show1, show2 in
            if let date1 = show1?.date {
                if let date2 = show2.date {
                    return date1 > date2 ? show1 : show2
                } else {
                    return show1
                }
            } else if let _ = show2.date {
                return show2
            }

            return show1
        })

        return mostRecentShow?.date
    }
}

struct ArtistSeen: Hashable, Identifiable {
    let id: String
    let name: String
    let shows: [Concert]
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
