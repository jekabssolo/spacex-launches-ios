//
//  ContentView.swift
//  SpaceX Launches
//
//  Created by Jekabs Solovjovs on 29/07/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    private let apiService = ApiService()
    
    var body: some View {
        NavigationView {
            LaunchListView()
                .navigationTitle("SpaceX Launches")
                .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
        .task {
            let descriptor = FetchDescriptor<Launch>()
            let count = (try? modelContext.fetchCount(descriptor)) ?? 0
            if count == 0 {
                apiService.updateLaunches(modelContext: modelContext)
            }
        }
        .refreshable {
            apiService.updateLaunches(modelContext: modelContext)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Launch.self, configurations: config)
        Launch.sampleLaunches.forEach { container.mainContext.insert($0) }
        
        return ContentView().modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
