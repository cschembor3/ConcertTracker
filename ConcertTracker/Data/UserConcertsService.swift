//
//  UserConcertsService.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 2/12/23.
//

import FirebaseDatabase

protocol UserConcertsServiceProtocol {
    func getShowsAttended()
    func getSetlist(concertId: String)
}

final class UserConcertsService: UserConcertsServiceProtocol {

    private let reference = Database.database().reference()

    func getShowsAttended() {

    }

    func getSetlist(concertId: String) {

    }

    func addShowAsAttended(_ show: SetlistResponse) {

        let user = AuthenticationService().user!

        self.reference
            .ref
            .child("users")
            .child(user.uid)
            .child("showsAttended")
            .updateChildValues([show.artist.id.uuidString: true])

        self.reference
            .ref
            .child("artists")
            .child(show.artist.id.uuidString)
            .child("name")
            .setValue(show.artist.name)

        self.reference
            .ref
            .child("artists")
            .child(show.artist.id.uuidString)
            .child("shows")
            .updateChildValues([show.id: true])

        let showDbModel = show.toDbModel()
        self.reference
            .ref
            .child("shows")
            .child(showDbModel.id)
            .child("artistId")
            .setValue(showDbModel.artistId)

        do {
            let songsData = try JSONEncoder().encode(showDbModel.songs)
            let songs = try JSONSerialization.jsonObject(with: songsData)
            self.reference
                .ref
                .child("shows")
                .child(showDbModel.id)
                .child("songs")
                .setValue(songs)
        } catch {
            fatalError("Error serializing song data - \(#function)")
        }
    }
}

/*

 Users:
 {
   userId: "3456",
   showsAttended: {
     "1234",
     "12345"
   }
 }

 Artists:
 {
   id: "234234",
   name: "Deftones",
   shows: [
     id: "2468",
     id: "0909"
   ]
 }

 Shows:
 {
   id: "9876",
   artistId: "234234",
   venue: {
     id: "11222",
     name: "Saint Vitus Bar",
     city: "Brooklyn",
     state: "NY
   },
   songs: [
     name: "Take on me",
     name: "Come sail away"
   ]
 }

 */

struct ShowDbModel: Codable {
    let id: String
    let artistId: String
    let venue: VenueDbModel
    let songs: [SongDbModel]

    struct VenueDbModel: Codable {
        let id: String
        let name: String?
        let city: String?
        let state: String?
    }

    struct SongDbModel: Codable {
        let name: String
    }
}

extension SetlistResponse {

    func toDbModel() -> ShowDbModel {
        let songs = self.sets.set.compactMap { $0.song }.flatMap { $0 }.map { ShowDbModel.SongDbModel(name: $0.name) }
        return ShowDbModel(
            id: self.id,
            artistId: self.artist.id.uuidString,
            venue: .init(id: self.venue.id, name: self.venue.name, city: self.venue.city.name, state: self.venue.city.state),
            songs: songs
        )
    }
}
