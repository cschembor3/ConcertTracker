//
//  ConcertsViewModel.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 6/8/22.
//

import Foundation

@MainActor class ConcertsViewModel: ObservableObject {
    
    private let setlistApi = SetlistApi()
    
    @Published private(set) var bands: [String] = []
    
    func fetch() async {
        
        do {
            let response = try await SetlistService(setlistApi: self.setlistApi)
                .getConcertsAttended(for: "cschembor", sortedBy: .dateDescending)

            self.bands = response.map { $0.name }
        } catch {
            // TODO: handle error
        }
    }
}
