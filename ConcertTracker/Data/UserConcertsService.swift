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

    func getShowsAttended() {

    }

    func getSetlist(concertId: String) {

    }
}

/*

 Users:
 {
   userId: "3456",
   showsAttended: [
     showId: "1234",
     showId: "12345"
   ]
 }

 Artists:
 {
   id: "234234",
   name: "
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
