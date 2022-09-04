//
//  ConcertsViewModel.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 6/8/22.
//

import Foundation

@MainActor protocol ConcertsViewModelProtocol {
    var concertsAttended: [ArtistSeen] { get }
    func fetch() async
}

class ConcertsViewModel: ConcertsViewModelProtocol, ObservableObject {
    
    private let setlistApi = SetlistApi()
    
    @Published private(set) var concertsAttended: [ArtistSeen] = []
    
    func fetch() async {
        
        do {
            let username: String? = UserDefaultsService().getValue(for: UserDefaultsValues.usernameKey)
            guard let username else { return }
            self.concertsAttended = try await SetlistService(setlistApi: self.setlistApi)
                .getConcertsAttended(for: username, sortedBy: .dateDescending)
        } catch {
            // TODO: handle error
        }
    }
}
