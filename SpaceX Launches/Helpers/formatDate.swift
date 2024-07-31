//
//  formatDate.swift
//  SpaceX Launches
//
//  Created by Jekabs Solovjovs on 31/07/2024.
//

import Foundation

func formatDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.YYYY."
    return dateFormatter.string(from: date)
}
