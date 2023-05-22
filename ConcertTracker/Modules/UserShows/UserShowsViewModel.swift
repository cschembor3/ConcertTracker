//
//  UserShowsViewModel.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 2/20/23.
//

import Foundation
import SwiftUI

@MainActor
protocol UserShowsViewModelProtocol: ObservableObject {
    var entries: [ShowSeenEntry] { get }
    func resetNewShowCount()
    func sort(_ option: UserShowsViewModel.SortOption)
}

struct ShowSeenEntry: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let text: String
    let type: EntryType
    let children: [ShowSeenEntry]?
    let date: Date?

    enum EntryType {
        case artist
        case show
    }
}

final class UserShowsViewModel: UserShowsViewModelProtocol {

    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()

    @Published var entries = [ShowSeenEntry]()

    private var concertService: any UserConcertsServiceProtocol = UserConcertsService.shared

    init(concertService: any UserConcertsServiceProtocol = UserConcertsService.shared) {
        self.concertService = concertService

        Task {
            let showsAttended = await concertService.getShowsAttended()
            let artists = Dictionary(grouping: showsAttended, by: { $0.artistName }) // TODO: group by artist id instead of name
            var artistsSeen = [ArtistSeen]()
            artists.forEach { (artistName, artists) in
                let shows = artists.map { ShowSeen(id: $0.id, venueName: "Saint Vitus", city: "Brooklyn", date: $0.showDate) }
                artistsSeen.append(.init(id: artistName, name: artistName, shows: shows))
            }

            self.entries = artistsSeen.map { artist in
                .init(
                    name: artist.name,
                    text: artist.name,
                    type: .artist,
                    children: artist.shows.map { show in
                        .init(
                            name: show.venueName,
                            text: "\(show.date) - \(show.venueName)",
                            type: .show,
                            children: nil,
                            date: Self.dateFormatter.date(from: show.date)
                        )
                    },
                    date: nil
                )
            }
        }
    }

    func resetNewShowCount() {
        self.concertService.newShowAttendedCount = 0
    }

    func sort(_ option: SortOption) {
        self.entries = self.getSortedEntries(sortOption: option)
    }

    private func getSortedEntries(sortOption: SortOption) -> [ShowSeenEntry] {
        switch sortOption {
        case .dateAscending:
            return entries.sorted { artist1, artist2 in
                self.getMostRecentDate(from: artist1.children ?? []) ?? Date.distantPast <
                    self.getMostRecentDate(from: artist2.children ?? []) ?? Date.distantPast
            }
        case .dateDescending:
            return entries.sorted { artist1, artist2 in
                self.getMostRecentDate(from: artist1.children ?? []) ?? Date.distantPast <
                    self.getMostRecentDate(from: artist2.children ?? []) ?? Date.distantPast
            }.reversed()
        case .alphabetically:
            return entries.sorted { artist1, artist2 in
                artist1.name < artist2.name
            }
        case .amountSeen:
            return entries.sorted { artist1, artist2 in
                artist1.children?.count ?? 0 > artist2.children?.count ?? 0
            }
        }
    }

    enum SortOption {
        case dateAscending
        case dateDescending
        case alphabetically
        case amountSeen
    }

    private func getMostRecentDate(from shows: [ShowSeenEntry]) -> Date? {
        let mostRecentShow = shows.reduce(nil as ShowSeenEntry?, { show1, show2 in
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
