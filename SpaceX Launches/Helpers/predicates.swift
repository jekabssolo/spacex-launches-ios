//
//  predicates.swift
//  SpaceX Launches
//
//  Created by Jekabs Solovjovs on 06/08/2024.
//

import Foundation

enum FilterType: String, CaseIterable {
    case all = "All"
    case upcoming = "Upcoming"
    case successful = "Successful"
    case unsuccessful = "Unsuccessful"
    
    func toPredicate() -> (Launch) -> Bool {
        switch self {
            case .all:
                { _ in true }
            case .upcoming:
                { $0.upcoming }
            case .successful:
                { $0.success ?? false }
            case .unsuccessful:
                { !($0.success ?? true) }
        }
    }
}

enum SortType: String, CaseIterable {
    case dateAscending = "By date ascending"
    case dateDescending = "By date descending"
    case name = "By name"
    
    func toPredicate() -> (Launch, Launch) -> Bool {
        switch self {
            case .dateAscending:
                { $0.date < $1.date }
            case .dateDescending:
                { $0.date > $1.date }
            case .name:
                { $0.name < $1.name }
        }
    }
}
