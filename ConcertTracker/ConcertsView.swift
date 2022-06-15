//
//  ConcertsView.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 6/6/22.
//

import SwiftUI

struct ConcertsView: View {
    
    @ObservedObject private var viewModel = ConcertsViewModel()
    @State private var loading: Bool = false
    
    var body: some View {
        
        NavigationView {
            ZStack {
                List {
                    ForEach(viewModel.concertsAttended) { artistSeen in
                        ArtistCell(artistShowsSeen: artistSeen)
                    }
                }
                
                ProgressView()
                    .progressViewStyle(.circular)
                    .opacity(self.loading ? 1 : 0)
            }
            .navigationTitle("Artists")
            .task {
                Task {
                    self.loading = true
                    await self.viewModel.fetch()
                    self.loading = false
                }
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}

struct ConcertsView_Previews: PreviewProvider {
    static var previews: some View {
        ConcertsView()
    }
}
