//
//  ConcertTrackerApp.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 5/28/22.
//

import SwiftUI

@main
struct ConcertTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            if UserDefaultsService().valueExists(for: UserDefaultsValues.usernameKey) {
                ConcertsView(viewModel: ConcertsViewModel())
            } else {
                InitUsernameView()
            }
        }
    }
}
