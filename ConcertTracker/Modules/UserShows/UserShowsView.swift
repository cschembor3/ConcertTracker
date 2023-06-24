//
//  UserShowsView.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 2/20/23.
//

import SwiftUI

struct UserShowsView<ViewModel>: View where ViewModel: UserShowsViewModelProtocol {

    @State private var chosenArtist: ShowSeenEntry?
    @StateObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {

        NavigationStack {
            List {
                ForEach(self.viewModel.entries, id: \.id) { entry in
                    ShowsAttendedByArtistView(showsSeenEntry: entry) { entryId, showIdToDelete in
                        self.viewModel.remove(entryId: entryId, showId: showIdToDelete)
                    }
                }
            }
            .onAppear {
                self.viewModel.resetNewShowCount()
            }
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

    struct ShowsAttendedByArtistView: View {

        private let showsSeenEntry: ShowSeenEntry
        private let onDelete: (String, String) -> Void
        init(showsSeenEntry: ShowSeenEntry, onDelete: @escaping (String, String) -> Void) {
            self.showsSeenEntry = showsSeenEntry
            self.onDelete = onDelete
        }

        var body: some View {
            Section(showsSeenEntry.text) {
                DisclosureGroup(
                    content: {
                        ForEach(showsSeenEntry.children ?? []) { show in
                            NavigationLink(show.text) {
                                UserSetlistView(viewModel: .init(showId: show.setlistFmShowId))
                            }
                        }
                        .onDelete { indexSet in
                            self.onDelete(
                                showsSeenEntry.id.uuidString,
                                showsSeenEntry.children![indexSet.first!].setlistFmShowId
                            )
                        }
                    },
                    label: {
                        Text(showsSeenEntry.text)
                            .badge(showsSeenEntry.children?.count ?? 0)
                    }
                )
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
    func remove(entryId: String, showId: String) { }
    func remove(showId: String) { }
    var entries: [ShowSeenEntry] = [
        .init(
//            id: UUID(),
            setlistFmShowId: "",
            name: "Deftones",
            text: "Deftones",
            type: .artist,
            children: [
                .init(
//                    id: UUID(),
                    setlistFmShowId: "",
                    name: "Saint Vitus",
                    text: "12/04/1998 - Saint Vitus",
                    type: .show,
                    children: nil,
                    date: nil
                ),
                .init(
//                    id: UUID(),
                    setlistFmShowId: "",
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
            setlistFmShowId: "",
            name: "Deerhoof",
            text: "Deerhoof",
            type: .artist,
            children: [
                .init(
//                    id: UUID(),
                    setlistFmShowId: "",
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

    func resetNewShowCount() { }
    func sort(_ option: UserShowsViewModel.SortOption) { }
}
