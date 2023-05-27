//
//  ArtistsViewModel.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 6/8/22.
//

import Combine
import Foundation

@MainActor protocol ArtistsViewModelProtocol: ObservableObject {
    var artists: [ArtistSearch] { get }
    var searchText: String { get set }
    func fetch(searchQuery: String) async
    func fetchMore() async
    func needsToFetchMore(artist: ArtistSearch) -> Bool
}

final class ArtistsViewModel: ArtistsViewModelProtocol {

    private let setlistApi = SetlistApi()
    
    @Published private(set) var artists: [ArtistSearch] = []
    @Published var searchText: String = ""

    private var page: Int = 1
    private var searchQuery: String = ""
    private var cancellables: Set<AnyCancellable> = []

    init() {
        $searchText
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { query in
                self.searchQuery = query
                self.fetch(searchQuery: query)
            }
            .store(in: &self.cancellables)
    }

    @MainActor
    func fetch(searchQuery: String) {

        guard !searchQuery.isEmpty else {
            self.artists = []
            self.page = 1
            return
        }

        Task {
            do {
                let response = try await SetlistService(setlistApi: self.setlistApi)
                    .search(artistName: searchQuery, page: page)

                guard let artists = response.artist else { return }
                    self.artists = artists
                self.page = 1
            } catch {
                print(error)
            }
        }
    }

    func fetchMore() async {
        do {
            self.page += 1
            let response = try await SetlistService(setlistApi: self.setlistApi)
                .search(artistName: self.searchQuery, page: page)

            guard let artists = response.artist else { return }
            self.artists.append(contentsOf: artists)
        } catch {
            print(error)
        }
    }

    func needsToFetchMore(artist: ArtistSearch) -> Bool {
        guard let indexOfCurrArtist = self.artists.firstIndex(of: artist) else { return false }
        return self.artists.count - indexOfCurrArtist < 3
    }
}
