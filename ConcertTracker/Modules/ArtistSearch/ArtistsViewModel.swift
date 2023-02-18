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
}

final class ArtistsViewModel: ArtistsViewModelProtocol {

    private let setlistApi = SetlistApi()
    
    @Published private(set) var artists: [ArtistSearch] = []
    @Published var searchText: String = ""

    private var cancellables: Set<AnyCancellable> = []

    init() {
        $searchText
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main)
            .sink { query in
                Task {
                    await self.fetch(artistNameQuery: query)
                }
            }
            .store(in: &self.cancellables)
    }

    private func fetch(artistNameQuery: String) async {

        do {
            self.artists = try await SetlistService(setlistApi: self.setlistApi)
                .search(artistName: artistNameQuery)
                .artist ?? []
        } catch {
            print(error)
        }
    }
}
