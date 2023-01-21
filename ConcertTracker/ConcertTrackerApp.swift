//
//  ConcertTrackerApp.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 5/28/22.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
  ) -> Bool {

    FirebaseApp.configure()

    return true
  }
}

@main
struct ConcertTrackerApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
//            if UserDefaultsService().valueExists(for: UserDefaultsValues.usernameKey) {
//                ConcertsView(viewModel: ConcertsViewModel())
//            InitUsernameView()
            ConcertsView(viewModel: ConcertsViewModel())
            //            } else {
//                InitUsernameView()
//            }
        }
    }
}
