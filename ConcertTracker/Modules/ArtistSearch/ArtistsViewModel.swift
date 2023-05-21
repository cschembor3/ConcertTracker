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
    var hasMore: Bool { get }
    var searchText: String { get set }
    func fetch(searchQuery: String) async
    func fetchMore() async
}

final class ArtistsViewModel: ArtistsViewModelProtocol {

    private let setlistApi = SetlistApi()
    
    @Published private(set) var artists: [ArtistSearch] = []
    @Published private(set) var hasMore: Bool = false
    @Published var searchText: String = ""

    private var page: Int = 1
    private var searchQuery: String = ""
    private var cancellables: Set<AnyCancellable> = []

    init() {
        $searchText
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main)
            .sink { query in
                self.searchQuery = query
                Task {
                    await self.fetch(searchQuery: query)
                }
            }
            .store(in: &self.cancellables)
    }

    func fetch(searchQuery: String) async {

        guard !searchQuery.isEmpty else {
            self.artists = []
            self.page = 1
            self.hasMore = false
            return
        }

        do {
            let response = try await SetlistService(setlistApi: self.setlistApi)
                .search(artistName: searchQuery, page: page)

            guard let artists = response.artist,
                  let total = response.total else { return }

            self.artists = artists
            self.page = 1
            self.hasMore = total > self.artists.count
        } catch {
            print(error)
        }
    }

    func fetchMore() async {
        do {
            defer { self.page += 1 }
            let response = try await SetlistService(setlistApi: self.setlistApi)
                .search(artistName: self.searchQuery, page: page)

            guard let artists = response.artist,
                  let total = response.total else { return }

            self.artists.append(contentsOf: artists)
            self.hasMore = total > self.artists.count
        } catch {
            print(error)
        }
    }
}
