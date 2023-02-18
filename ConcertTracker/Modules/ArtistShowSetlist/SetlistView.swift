//
//  SetlistView.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 2/8/23.
//

import SwiftUI

struct SetlistView: View {

    @ObservedObject private var viewModel: SetlistViewModel

    init(viewModel: SetlistViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        List {
            ForEach(viewModel.songs, id: \.id) { song in
                Text(song.name)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("I was here") {
                    
                }
            }
        }
    }
}

struct SetlistView_Previews: PreviewProvider {
    static var previews: some View {
        SetlistView(viewModel: SetlistViewModel(setlist: []))
    }
}
