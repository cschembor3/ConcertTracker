//
//  ConcertsViewModel.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 6/8/22.
//

import Foundation

@MainActor class ConcertsViewModel: ObservableObject {
    
    private let setlistApi = SetlistApi()
    
    @Published private(set) var concertsAttended: [ArtistSeen] = []
    
    func fetch() async {
        
        do {
            self.concertsAttended = try await SetlistService(setlistApi: self.setlistApi)
                .getConcertsAttended(for: "cschembor", sortedBy: .dateDescending)
        } catch {
            // TODO: handle error
        }
    }
}
