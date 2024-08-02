//
//  ContentView.swift
//  SpaceX Launches
//
//  Created by Jekabs Solovjovs on 29/07/2024.
//

import SwiftUI
import SwiftData

enum FilterType: String, CaseIterable {
    case all = "All"
    case upcoming = "Upcoming"
    case successful = "Successful"
    case unsuccessful = "Unsuccessful"
    
    func toPredicate() -> Predicate<Launch> {
        switch self {
            case .all:
                .true
            case .upcoming:
                #Predicate<Launch> { $0.upcoming }
            case .successful:
                #Predicate<Launch> { $0.success ?? false }
            case .unsuccessful:
                #Predicate<Launch> { !($0.success ?? true) }
        }
    }
}

var isPreview: Bool {
    return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var sortOrder = SortDescriptor(\Launch.date, order: .forward)
    @State private var filter: FilterType = .all
    @State private var filterPredicate: Predicate<Launch> = .true
    @AppStorage("lastUpdate") private var lastUpdate: Double = Date().timeIntervalSince1970
    private let apiService = ApiService()
    
    var body: some View {
        NavigationView {
            LaunchListView(sort: sortOrder, filterPredicate: filterPredicate)
                .navigationTitle("SpaceX Launches")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup {
                            Menu {
                                Picker("Filter", selection: $filter) {
                                    ForEach(FilterType.allCases, id: \.rawValue) { option in
                                        Text(option.rawValue)
                                            .tag(option)
                                    }
                                }
                                .pickerStyle(.inline)
                            } label: {
                                Image(systemName: "line.horizontal.3.decrease.circle")
                            }
                            .onChange(of: filter) {
                                filterPredicate = filter.toPredicate()
                            }
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
                                Image(systemName: "arrow.up.arrow.down.circle")
                            }
                    }
                }
        }
        .navigationViewStyle(.stack)
        .task {
            guard !isPreview else { return }
            
            if shouldUpdateCache() {
                apiService.updateLaunches(modelContext: modelContext)
                lastUpdate = Date().timeIntervalSince1970
            }
        }
        .refreshable {
            guard !isPreview else { return }
            
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
