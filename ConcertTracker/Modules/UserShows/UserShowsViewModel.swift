//
//  UserShowsViewModel.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 2/20/23.
//

import Foundation

@MainActor
protocol UserShowsViewModelProtocol: ObservableObject {
    var entries: [ShowSeenEntry] { get }
}

struct ShowSeenEntry: Identifiable {
    let id: String
    let text: String
    let type: EntryType
    let children: [ShowSeenEntry]?

    enum EntryType {
        case artist
        case show
    }
}

final class UserShowsViewModel: UserShowsViewModelProtocol {

    @Published var artistsSeen = [ArtistSeen]()
    @Published var entries = [ShowSeenEntry]()

    private let concertService: UserConcertsServiceProtocol

    init(concertService: UserConcertsServiceProtocol = UserConcertsService()) {
        self.concertService = concertService

        Task {
            let showsAttended = await concertService.getShowsAttended()
            let artists = Dictionary(grouping: showsAttended, by: { $0.artistName }) // TODO: group by artist id instead of name
            var artistsSeen = [ArtistSeen]()
            artists.forEach { (artistName, artist) in
                let shows = artist.map { ShowSeen(id: $0.id, venueName: "Saint Vitus", city: "Brooklyn", date: $0.showDate) }
                artistsSeen.append(.init(id: "", name: artistName, shows: shows))
            }

            self.entries = artistsSeen.map { artist in
                .init(
                    id: artist.id,
                    text: artist.name,
                    type: .artist,
                    children: artist.shows.map { show in
                        .init(
                            id: show.id,
                            text: "\(show.date) - \(show.venueName)",
                            type: .show,
                            children: nil
                        )
                    }
                )
            }

            self.artistsSeen = artistsSeen
        }
    }

//        switch sortedBy {
//        case .dateAscending:
//            return data.sorted { artist1, artist2 in
//                self.getMostRecentDate(from: artist1.shows) ?? Date.distantPast <
//                    self.getMostRecentDate(from: artist2.shows) ?? Date.distantPast
//            }
//        case .dateDescending:
//            return data.sorted { artist1, artist2 in
//                self.getMostRecentDate(from: artist1.shows) ?? Date.distantPast <
//                    self.getMostRecentDate(from: artist2.shows) ?? Date.distantPast
//            }.reversed()
//        case .alphabetically:
//            return data.sorted { artist1, artist2 in
//                artist1.name < artist2.name
//            }
//        }
//    }

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
    let shows: [ShowSeen]
}

struct ShowSeen: Hashable, Identifiable {
    let id: String
    let venueName: String
    let city: String
    let date: String
}
