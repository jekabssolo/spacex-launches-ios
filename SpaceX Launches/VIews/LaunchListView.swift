//
//  LaunchListView.swift
//  SpaceX Launches
//
//  Created by Jekabs Solovjovs on 30/07/2024.
//

import SwiftUI
import SwiftData

struct LaunchListView: View {
    @Environment(\.colorScheme) var colorScheme
    @Query private var launches: [Launch]
    
    var body: some View {
        List {
            ForEach(launches, id: \.id) { launch in
                NavigationLink {
                    Text(launch.name)
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
        .listRowSpacing(15)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Launch.self, configurations: config)
        Launch.sampleLaunches.forEach { container.mainContext.insert($0) }
        
        return LaunchListView().modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
