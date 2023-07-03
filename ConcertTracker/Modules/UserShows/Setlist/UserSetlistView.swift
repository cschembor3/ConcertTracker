//
//  UserSetlistView.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 3/5/23.
//

import SwiftUI

struct UserSetlistView: View {

    @Environment(\.colorScheme) var colorScheme
    @ObservedObject private var viewModel: UserSetlistViewModel
    @State private var hasDivider: Bool = false
    init(viewModel: UserSetlistViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {

        List {
            Section {
                VStack(spacing: 2) {
                    mostlyLeftAligned(
                        Text(viewModel.setlistInfo?.artistName ?? "")
                            .font(.title)
                    )

                    if viewModel.setlistInfo?.tourName != nil ||
                        viewModel.setlistInfo?.venueName != nil {
                        Divider()
                    }

                    if let tour = viewModel.setlistInfo?.tourName {
                        mostlyLeftAligned(
                            Text(tour)
                                .font(.title2)
                        )
                    }

                    if let venue = viewModel.setlistInfo?.venueName {
                        mostlyLeftAligned(
                            Text(venue)
                                .font(.title3)
                        )
                    }
                }
                .background(
                    colorScheme == .dark ?
                        Color(UIColor.systemBackground) :
                        Color(UIColor.secondarySystemBackground)
                )
                .listRowInsets(.init())
            }

            Section("Setlist") {
                ForEach(viewModel.setlistInfo?.setlist.setSongs ?? [], id: \.self) { song in
                    Text(song)
                }
            }

            if let encores = viewModel.setlistInfo?.setlist.encores,
               !encores.isEmpty {

                ForEach(encores) { encore in
                    Section("Encore \(encore.number)") {
                        ForEach(encore.songs, id: \.self) { song in
                            Text(song)
                        }
                    }
                }
            }

            Section("Create Playlist") {
                Button("Spotify") {
                    print("hi")
                }
            }
        }
        .background(Color(UIColor.secondarySystemBackground))
        .navigationTitle("")
        .toolbarRole(.navigationStack)
    }
}

extension UserSetlistView {
    private func mostlyLeftAligned(_ view: some View) -> some View {
        return HStack {
            view
            Spacer()
        }
        .padding(.leading)
    }
}

struct UserSetlistView_Previews: PreviewProvider {
    static var previews: some View {
        UserSetlistView(viewModel: UserSetlistViewModel(showId: "be1b9e2"))
    }
}
