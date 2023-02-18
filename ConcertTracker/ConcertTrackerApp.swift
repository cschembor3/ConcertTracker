//
//  ConcertTrackerApp.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 5/28/22.
//

import FirebaseAuth
import SwiftUI
import FirebaseCore

@main
struct ConcertTrackerApp: App {

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ArtistsView(viewModel: ArtistsViewModel())
//            SplashScreen()
//                .environmentObject(AuthenticationService())
//            if Auth.auth().currentUser != nil {
//                ConcertsView(viewModel: ConcertsViewModel())
//            } else {
//                InitUsernameView()
//            }
        }
    }
}
