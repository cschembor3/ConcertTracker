//
//  UserShowsView.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 2/20/23.
//

import SwiftUI

struct UserShowsView<ViewModel>: View where ViewModel: UserShowsViewModelProtocol {

    @State private var chosenArtist: ShowSeenEntry?
    @ObservedObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {

        NavigationStack {
            List {
                ForEach(self.viewModel.entries, id: \.id) { entry in
                    Section(entry.text) {
                        OutlineGroup(entry.children ?? [], id: \.id, children: \.children) { a in
                            NavigationLink(a.text) {
                                UserSetlistView()
                            }
                        }
                    }
                    .headerProminence(.increased)
                }
            }
            .id(UUID())
            .listStyle(.sidebar)
            .navigationTitle("Shows attended")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("A-Z") {
                            self.viewModel.sort(.alphabetically)
                        }

                        Button("Most recent") {
                            self.viewModel.sort(.dateAscending)
                        }

                        Button("Least recent") {
                            self.viewModel.sort(.dateDescending)
                        }

                        Button("Most seen") {
                            self.viewModel.sort(.amountSeen)
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
//            id: UUID(),
            name: "Deftones",
            text: "Deftones",
            type: .artist,
            children: [
                .init(
//                    id: UUID(),
                    name: "Saint Vitus",
                    text: "12/04/1998 - Saint Vitus",
                    type: .show,
                    children: nil,
                    date: nil
                ),
                .init(
//                    id: UUID(),
                    name: "Saint Vitus",
                    text: "12/04/1998 - Saint Vitus",
                    type: .show,
                    children: nil,
                    date: nil
                )
            ],
            date: nil
        ),
        .init(
//            id: UUID(),
            name: "Deerhoof",
            text: "Deerhoof",
            type: .artist,
            children: [
                .init(
//                    id: UUID(),
                    name: "Brooklyn Monarch",
                    text: "Brooklyn Monarch",
                    type: .show,
                    children: nil,
                    date: nil
                )
            ],
            date: nil
        )
    ]

    func sort(_ option: UserShowsViewModel.SortOption) { }
}
