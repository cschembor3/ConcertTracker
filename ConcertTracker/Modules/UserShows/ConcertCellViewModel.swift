//
//  ConcertCellViewModel.swift
//  ConcertTracker
//
//  Created by Connor Schembor on 6/18/22.
//

import Foundation

protocol ConcertCellViewModelProtocol {
    var displayString: String { get }
}

struct ConcertCellViewModel: ConcertCellViewModelProtocol {

    private static var dateStringFormatter: DateFormatter = {
        let _dateFormatter = DateFormatter()
        _dateFormatter.dateFormat = "MM/dd/yyyy"
        return _dateFormatter
    }()

    private static var dateFormatter: DateFormatter = {
        let _dateFormatter = DateFormatter()
        _dateFormatter.dateFormat = "dd/MM/yyyy"
        return _dateFormatter
    }()

    private let show: ShowSeen
    init(for show: ShowSeen) {
        self.show = show
    }

    var displayString: String {

        let dateString: String = {
            guard let date = Self.dateFormatter.date(from: show.date) else {
                return ""
            }

            return ConcertCellViewModel.dateStringFormatter.string(from: date)
        }()

        return "\(dateString) - \(show.venueName)"
    }
}
