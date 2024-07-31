//
//  formatLaunchStatus.swift
//  SpaceX Launches
//
//  Created by Jekabs Solovjovs on 31/07/2024.
//

import SwiftUI

struct LaunchStatus {
    let title: String
    let color: Color
}

extension LaunchStatus: Equatable {
    static func ==(lhs: LaunchStatus, rhs: LaunchStatus) -> Bool {
        return lhs.title == rhs.title && lhs.color == rhs.color
    }
}

func formatLaunchStatus(upcoming: Bool, success: Bool?) -> LaunchStatus {
    guard !upcoming else { return LaunchStatus(title: "Upcoming", color: Color.yellow) }
    guard let success = success else { return LaunchStatus(title: "Unknown", color: Color.gray) }
    
    return success
    ? LaunchStatus(title: "Successful", color: Color.green)
    : LaunchStatus(title: "Unsuccessful", color: Color.red)
}
