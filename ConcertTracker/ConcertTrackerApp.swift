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
            if let _: String? = UserDefaultsService().getValue(for: UserDefaultsValues.usernameKey) {
                ConcertsView(viewModel: ConcertsViewModel())
            } else {
                InitUsernameView()
            }
        }
    }
}
