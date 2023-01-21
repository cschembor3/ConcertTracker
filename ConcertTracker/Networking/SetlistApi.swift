//
//  SetlistApi.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 5/28/22.
//

import Foundation

protocol SetlistApiInterface {
    func getConcertsAttended(for username: String) async throws -> UserSetlistResponse
    func searchArtists(artistName: String) async throws -> ArtistSearchResponse
}

struct SetlistApi: SetlistApiInterface {

    private static let baseUrl = "https://api.setlist.fm/rest/1.0"
    private static let acceptHeader: (header: String, responseType: String) = ("Accept", "application/json")
    private static let apiKeyHeader: (header: String, apiKey: String) = ("x-api-key", Secrets.setlistApiKey)

    func searchArtists(artistName: String) async throws -> ArtistSearchResponse {

        let encodedName = artistName.replacing(" ", with: "%20")
        guard let url = URL(string: "\(SetlistApi.baseUrl)/search/artists?p=1&sort=relevance&artistName=\(encodedName)") else {
            throw URLError(.badURL)
        }

        let request = constructGetRequest(from: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(ArtistSearchResponse.self, from: data)
    }

//    func getArtistSetlists(id: String) async throws -> Response {
//
//        guard let url = URL(string: "\(SetlistApi.baseUrl)/\(id)/setlists") else {
//            throw URLError(.badURL)
//        }
//
//        let request = constructGetRequest(from: url)
//        let (data, _) = try await URLSession.shared.data(for: request)
//        return try JSONDecoder().decode(Response.self, from: data)
//    }

    func getSetlist(id: String) async throws -> SetlistResponse {

        guard let url = URL(string: "\(SetlistApi.baseUrl)/setlist/\(id)") else {
            throw URLError(.badURL)
        }

        let request = constructGetRequest(from: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(SetlistResponse.self, from: data)
    }

    func getConcertsAttended(for username: String) async throws -> UserSetlistResponse {

        guard let url = URL(string: "\(SetlistApi.baseUrl)/user/\(username)/attended?p=1") else {
            throw URLError(.badURL)
        }

        let request = constructGetRequest(from: url)
        let (data,  _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(UserSetlistResponse.self, from: data)
    }
}

private extension SetlistApi {

    func constructGetRequest(from url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = RequestType.get.description
        request.addValue(Self.acceptHeader.responseType, forHTTPHeaderField: Self.acceptHeader.header)
        request.addValue(Self.apiKeyHeader.apiKey, forHTTPHeaderField: Self.apiKeyHeader.header)
        return request
    }
}

enum RequestType: CustomStringConvertible {
    case delete
    case get
    case post
    case put

    var description: String {
        switch self {
        case .delete:
            return "DELETE"
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        }
    }
}

struct ArtistSearchResponse: Codable {
    let artist: [ArtistSearch]?
    let total: Int?
    let page: Int?
    let itemsPerPage: Int?
}

struct ArtistSearch: Codable, Identifiable {
    let id: String
    let ticketMasterId: String?
    let name: String
    let sortName: String
    let disambiguation: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case id = "mbid"
        case ticketMasterId = "tmid"
        case name
        case sortName
        case disambiguation
        case url
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

struct Venue: Codable, Hashable {
    let id: String
    let name: String
    let city: Location
}

struct Location: Codable, Hashable {
    let id: String
    let name: String
    let state: String
    let stateCode: String
    let country: Country
}

struct Country: Codable, Hashable {
    let code: String
    let name: String
}

struct Tour: Codable, Hashable {
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
