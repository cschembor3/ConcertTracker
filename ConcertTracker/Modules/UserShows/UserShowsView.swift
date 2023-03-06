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

    var body: some View {

        NavigationStack {
            List(self.viewModel.entries, children: \.children) { entry in
                switch entry.type {
                case .artist:
                    Text(entry.text).badge(entry.children?.count ?? 0)
                case .show:
                    NavigationLink(entry.text) {
                        UserSetlistView()
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Shows attended")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {

                        Button("A-Z") {

                        }

                        Button("Most recent") {

                        }

                        Button("Least recent") {

                        }

                        Button("Most seen") {

                        }
                    } label: {

                        Image(systemName: "slider.vertical.3")
                    }
                }
            }
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
        .init(
            id: "1",
            name: "Deftones",
            text: "Deftones",
            type: .artist,
            children: [
                .init(
                    id: "2",
                    name: "Saint Vitus",
                    text: "12/04/1998 - Saint Vitus",
                    type: .show,
                    children: nil,
                    date: nil
                )
            ],
            date: nil
        )
    ]
}
