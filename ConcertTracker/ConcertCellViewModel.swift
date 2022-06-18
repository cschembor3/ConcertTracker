//
//  ConcertCellViewModel.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 6/18/22.
//

import Foundation

struct ConcertCellViewModel {

    private static var dateFormatter: DateFormatter = {
        let _dateFormatter = DateFormatter()
        _dateFormatter.dateFormat = "MM/dd/yyyy"
        return _dateFormatter
    }()

    private let show: Concert
    init(for show: Concert) {
        self.show = show
    }

    var displayString: String {

        let dateString: String = {
            guard let date = show.date else {
                return ""
            }

            return ConcertCellViewModel.dateFormatter.string(from: date)
        }()

        return "\(dateString) - \(self.show.venue.name)"
    }
}
