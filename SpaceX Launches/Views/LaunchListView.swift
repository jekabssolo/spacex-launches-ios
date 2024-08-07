//
//  LaunchListView.swift
//  SpaceX Launches
//
//  Created by Jekabs Solovjovs on 30/07/2024.
//

import SwiftUI

struct LaunchListView: View {
    @Environment(\.colorScheme) private var colorScheme
    var launches: [Launch]
    
    var body: some View {
        List {
            ForEach(launches, id: \.id) { launch in
                NavigationLink {
                    LaunchDetailsView(launch: launch)
                } label: {
                    LaunchListItemView(launch: launch)
                }
            }
            .listRowBackground(
                Capsule()
                    .fill(colorScheme == .dark ? Color(red: 0.1, green: 0.1, blue: 0.1) : Color.white)
            )
            .listRowSeparator(.hidden)
        }
        .id(UUID())
        .listRowSpacing(15)
    }
}

#Preview {
    LaunchListView(launches: Launch.sampleLaunches)
}
