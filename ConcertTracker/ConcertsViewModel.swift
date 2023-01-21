//
//  ConcertsViewModel.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 6/8/22.
//

import Combine
import Foundation

@MainActor protocol ConcertsViewModelProtocol: ObservableObject {
    var concertsAttended: [ArtistSeen] { get }
    var artists: [ArtistSearch] { get }
    var searchText: String { get set }
    func fetch() async
}

class ConcertsViewModel: ConcertsViewModelProtocol {

    private let setlistApi = SetlistApi()
    
    @Published private(set) var concertsAttended: [ArtistSeen] = []
    @Published private(set) var artists: [ArtistSearch] = []
    @Published var searchText: String = ""

    private var cancellables: Set<AnyCancellable> = []

    init() {
        $searchText
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main)
            .sink { query in
                Task { @MainActor in
                    do {
                        self.artists = try await SetlistService(setlistApi: self.setlistApi)
                            .search(artistName: query)
                            .artist ?? []
                    } catch {
                        print(error)
                    }
                }
            }
            .store(in: &self.cancellables)
    }

    func fetch() async {

        do {
            self.artists = try await SetlistService(setlistApi: self.setlistApi)
                .search(artistName: "beat")
                .artist ?? []
        } catch {
            print(error)
        }
        
//        do {
//            let username: String? = UserDefaultsService().getValue(for: UserDefaultsValues.usernameKey)
//            guard let username else { return }
//            self.concertsAttended = try await SetlistService(setlistApi: self.setlistApi)
//                .getConcertsAttended(for: username, sortedBy: .dateDescending)
//        } catch {
//            // TODO: handle error
//        }
    }
}
