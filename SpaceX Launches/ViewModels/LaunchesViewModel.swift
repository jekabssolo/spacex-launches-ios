//
//  LaunchesViewModel.swift
//  SpaceX Launches
//
//  Created by Jekabs Solovjovs on 06/08/2024.
//

import Foundation
import Combine

class LaunchesViewModel: ObservableObject {
    @Published private(set) var launches = [Launch]()
    @Published var filter: FilterType = .all
    @Published var sort: SortType = .dateAscending
    
    private let apiService: ApiService
    private let userDefaults = UserDefaults.standard
    private let launchesKey = "launches"
    private let lastUpdateKey = "lastUpdate"
    private let updateInterval = 600
    
    private var cancellables = Set<AnyCancellable>()
    private var internalLaunches = PassthroughSubject<[Launch], Never>()
    
    init(apiService: ApiService) {
        self.apiService = apiService
        
        Publishers.CombineLatest3(internalLaunches, $filter, $sort)
            .map { launches, filter, sort in
                launches
                    .filter(filter.toPredicate())
                    .sorted(by: sort.toPredicate())
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.launches = $0
            }
            .store(in: &cancellables)
    }
    
    func cacheLaunches(_ launches: [Launch]) {
        if let encoded = try? JSONEncoder().encode(launches) {
            userDefaults.set(encoded, forKey: launchesKey)
        }
    }
    
    func getCachedLaunches() -> [Launch]? {
        guard let data: Data = userDefaults.object(forKey: launchesKey) as? Data
        else {
            return nil
        }
        
        do {
            let decoded = try JSONDecoder().decode([Launch].self, from: data)
            return decoded
        } catch {
            return nil
        }
    }
    
    func setUpdateTime() {
        let now = Date.now
        userDefaults.set(now.timeIntervalSince1970, forKey: lastUpdateKey)
    }
    
    func getLastUpdateTime() -> Double? {
        return userDefaults.double(forKey: lastUpdateKey)
    }
    
    func forceFetchLaunches() {
        apiService.fetchLaunches()
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] in
                self?.internalLaunches.send($0)
                self?.cacheLaunches($0)
                self?.setUpdateTime()
            })
            .store(in: &cancellables)
    }
    
    func retrieveLaunches() {
        let cachedLaunches = getCachedLaunches() ?? []
        let lastUpdate = getLastUpdateTime() ?? 0
        if cachedLaunches.count == 0 || shouldForceFetch(lastUpdate: lastUpdate) {
            forceFetchLaunches()
        } else {
            self.internalLaunches.send(cachedLaunches)
        }
    }
    
    private func shouldForceFetch(lastUpdate: Double) -> Bool {
        let lastUpdateTime = Date(timeIntervalSince1970: lastUpdate)
        
        guard let updateTimeDiff = Calendar.current.dateComponents(
            [.second],
            from: lastUpdateTime,
            to: Date()
        ).second
        else { return true }
        
        // Load data if cache age reached update interval = 10 min
        return updateTimeDiff >= updateInterval
    }
}
