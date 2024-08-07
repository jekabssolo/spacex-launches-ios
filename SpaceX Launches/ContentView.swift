//
//  ContentView.swift
//  SpaceX Launches
//
//  Created by Jekabs Solovjovs on 29/07/2024.
//

import SwiftUI

var isPreview: Bool {
    return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}

struct ContentView: View {
    @StateObject var viewModel = LaunchesViewModel(apiService: .shared)
    
    var body: some View {
        NavigationView {
            LaunchListView(launches: viewModel.launches)
                .navigationTitle("SpaceX Launches")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup {
                            Menu {
                                Picker("Filter", selection: $viewModel.filter) {
                                    ForEach(FilterType.allCases, id: \.rawValue) { option in
                                        Text(option.rawValue)
                                            .tag(option)
                                    }
                                }
                                .pickerStyle(.inline)
                            } label: {
                                Image(systemName: "line.horizontal.3.decrease.circle")
                            }
                            Menu {
                                Picker("Sort", selection: $viewModel.sort) {
                                    ForEach(SortType.allCases, id: \.rawValue) { option in
                                        Text(option.rawValue)
                                            .tag(option)
                                    }
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
            viewModel.retrieveLaunches()
        }
        .refreshable {
            guard !isPreview else { return }
            viewModel.forceFetchLaunches()
        }
    }
}

#Preview {
    ContentView()
}
