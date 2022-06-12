//
//  SetlistApi.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 5/28/22.
//

import Foundation

protocol SetlistApiInterface {
    func getConcertsAttended(for username: String) async throws -> UserSetlistResponse
}

struct SetlistApi: SetlistApiInterface {

    static let baseUrl = "https://api.setlist.fm/rest/1.0"

    func getConcertsAttended(for username: String) async throws -> UserSetlistResponse {

        guard let url = URL(string: "\(SetlistApi.baseUrl)/user/\(username)/attended?p=1") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod =  "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(Secrets.setlistApiKey, forHTTPHeaderField: "x-api-key")

        let (data,  _) = try await URLSession.shared.data(for: request)
        return try! JSONDecoder().decode(UserSetlistResponse.self, from: data)
    }
}

struct UserSetlistResponse: Codable {
    let type: String
    let itemsPerPage: Int
    let page: Int
    let total: Int
    let setlist: [SetlistResponse]
}

struct SetlistResponse: Codable {
    let id: String
    let versionId: String
    let eventDate: String
    let artist: Artist
    let venue: Venue
    let tour: Tour?
    let sets: Sets
    let url: String
}

struct Artist: Codable {
    let mbid:  String
    let name: String
}

struct Venue: Codable {
    let id: String
    let name: String
    let city: Location
}

struct Location: Codable {
    let id: String
    let name: String
    let state: String
    let stateCode: String
    let country: Country
}

struct Country: Codable {
    let code: String
    let name: String
}

struct Tour: Codable {
    let name: String
}

struct Sets: Codable {
    let set: [Songs]
}

struct Songs: Codable {
    let song: [Song]?
}

struct Song: Codable {
    let name: String
}
