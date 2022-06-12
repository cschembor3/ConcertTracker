//
//  SetlistService.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 6/8/22.
//

import Foundation

protocol SetlistServiceInterface {
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

    func getConcertsAttended(for username: String, sortedBy: SortOption = .alphabetically) async throws -> [ArtistSeen] {
        let response = try await self.setlistApi.getConcertsAttended(for: username)
        let artists = Dictionary(grouping: response.setlist, by: {$0.artist.mbid})
        var data: [ArtistSeen] = []
        for (artistId, artist) in artists {
            var concerts: [Concert] = []
            for show in artist {
                let date = self.dateFormatter.date(from: show.eventDate)
                let venue = show.venue
                let tour = show.tour
                let setlist = Setlist(
                    songs: show.sets.set.flatMap { $0.song?.map { $0.name } ?? [] }
                )

                concerts.append(
                    Concert(
                        tour: tour,
                        venue: venue,
                        setlist: setlist,
                        date: date
                    )
                )
            }

            guard let name = artist.first?.artist.name else { continue }
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

struct ArtistSeen {
    let id: String
    let name: String
    let shows: [Concert]
}

struct Concert {
    let tour: Tour?
    let venue: Venue
    let setlist: Setlist
    let date: Date?
}

struct Setlist {
    let songs: [String]
}
