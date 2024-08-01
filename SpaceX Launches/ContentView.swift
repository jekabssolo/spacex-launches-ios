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
    @State private var sortOrder = SortDescriptor(\Launch.date, order: .forward)
    @AppStorage("lastUpdate") private var lastUpdate: Double = Date().timeIntervalSince1970
    private let apiService = ApiService()
    
    var body: some View {
        NavigationView {
            LaunchListView(sort: sortOrder)
                .navigationTitle("SpaceX Launches")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Picker("Sort", selection: $sortOrder) {
                                Text("By date ascending")
                                    .tag(SortDescriptor(\Launch.date, order: .forward))
                                
                                Text("By date descending")
                                    .tag(SortDescriptor(\Launch.date, order: .reverse))
                                
                                Text("By name")
                                    .tag(SortDescriptor(\Launch.name))
                            }
                            .pickerStyle(.inline)
                        } label: {
                            Image(systemName: "line.horizontal.3.decrease")
                        }
                    }
                }
        }
        .navigationViewStyle(.stack)
        .task {
            if shouldUpdateCache() {
                apiService.updateLaunches(modelContext: modelContext)
                lastUpdate = Date().timeIntervalSince1970
            }
        }
        .refreshable {
            apiService.updateLaunches(modelContext: modelContext)
            lastUpdate = Date().timeIntervalSince1970
        }
    }
    
    func shouldUpdateCache() -> Bool {
        let descriptor = FetchDescriptor<Launch>()
        let count = (try? modelContext.fetchCount(descriptor)) ?? 0
        
        // Load data if cache is empty
        guard count != 0 else { return true }
        
        let updateInterval = 600
        let lastUpdateTime = Date(timeIntervalSince1970: lastUpdate)
        
        guard let updateTimeDiff = Calendar.current.dateComponents([.second], from: lastUpdateTime, to: Date()).second else { return true }
        
        // Load data if cache age reached update interval = 10 min
        return updateTimeDiff >= updateInterval
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
