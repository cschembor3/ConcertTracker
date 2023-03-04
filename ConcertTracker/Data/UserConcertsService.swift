//
//  UserConcertsService.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 2/12/23.
//

import FirebaseDatabase

protocol UserConcertsServiceProtocol {
    func getSetlist(concertId: String)
    func getShowsAttended() async -> [UserShowDbModel]
}

final class UserConcertsService: UserConcertsServiceProtocol {

    private let reference = Database.database().reference()

    private lazy var databasePath: DatabaseReference? = {
        guard let userId = AuthenticationService().user?.uid else { return nil }
        return reference.ref.child("users/\(userId)/showsAttended")
    }()

    func getShowsAttended() async -> [UserShowDbModel] {

        let showsAttended: [UserShowDbModel] = await withCheckedContinuation { continuation in

            guard let databasePath else {
                continuation.resume(returning: [])
                return
            }

            databasePath.observeSingleEvent(of: .value, with: { data in

                guard let json = data.value as? [String: Any] else {
                    continuation.resume(returning: [])
                    return
                }

                do {
                    let data = try JSONSerialization.data(withJSONObject: json)
                    let showsDecoded = try JSONDecoder().decode([String: UserShowDbModel].self, from: data)
                    let shows = showsDecoded.values.map { $0 }
                    continuation.resume(returning: shows)
                } catch {
                    print(error)
                    continuation.resume(returning: [])
                }
            })
        }

        return showsAttended
    }

    func getSetlist(concertId: String) {

    }

    func addShowAsAttended(_ show: SetlistResponse) {

        let user = AuthenticationService().user!

        do {
            let userShowData = try JSONEncoder().encode(show.toUserShowDbModel())
            let userShow = try JSONSerialization.jsonObject(with: userShowData)

            self.reference
                .ref
                .child("users")
                .child(user.uid)
                .child("showsAttended")
                .updateChildValues([show.id: userShow])
        } catch {

        }


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

struct UserShowDbModel: Codable {
    let id: String
    let artistName: String
    let showDate: String
}

extension SetlistResponse {

    func toUserShowDbModel() -> UserShowDbModel {
        UserShowDbModel(id: self.id, artistName: self.artist.name, showDate: self.eventDate)
    }

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
