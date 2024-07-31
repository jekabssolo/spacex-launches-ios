//
//  LaunchListItemView.swift
//  SpaceX Launches
//
//  Created by Jekabs Solovjovs on 30/07/2024.
//

import SwiftUI

struct LaunchListItemView: View {
    let launch: Launch
    
    var body: some View {
        HStack {
            if let imageUrl = launch.patchImageSmall ?? launch.patchImageLarge {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 45, height: 45)
            } else {
                Image("rocket_placeholder")
                    .resizable()
                    .frame(width: 45, height: 45)
            }
            Spacer()
                .frame(width: 20)
            VStack(alignment: .leading) {
                Text(launch.name)
                let launchStatus = formatLaunchStatus(
                    upcoming: launch.upcoming,
                    success: launch.success
                )
                Text(launchStatus.title)
                    .foregroundStyle(launchStatus.color)
            }
        }
    }
}

#Preview("Successful") {
    LaunchListItemView(launch: Launch.sampleLaunches[0])
}

#Preview("Upcoming") {
    LaunchListItemView(launch: Launch.sampleLaunches[1])
}

#Preview("Unsuccessful") {
    LaunchListItemView(launch: Launch.sampleLaunches[2])
}
