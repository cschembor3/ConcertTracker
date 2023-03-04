//
//  UserShowsView.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 2/20/23.
//

import SwiftUI

struct UserShowsView<ViewModel>: View where ViewModel: UserShowsViewModelProtocol {

    @ObservedObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    struct Test: Identifiable {
        let id: String
        let name: String
        let children: [Test]?
    }

    var body: some View {

        NavigationStack {
            List(self.viewModel.entries, children: \.children) { entry in
                switch entry.type {
                case .artist:
                    Text(entry.text)
                case .show:
                    NavigationLink(entry.text) {
                        Text("Hellllllooooooooo")
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Shows attended")
        }
    }
}

struct UserShowsView_Previews: PreviewProvider {
    static var previews: some View {
        UserShowsView(viewModel: MockUserShowsViewModel())
    }
}

class MockUserShowsViewModel: UserShowsViewModelProtocol {
    var entries: [ShowSeenEntry] = [
        .init(id: "1", text: "Deftones", type: .artist, children: [.init(id: "2", text: "12/04/1998 - Saint Vitus", type: .show, children: nil)])
    ]
}
