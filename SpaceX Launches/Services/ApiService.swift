//
//  ApiService.swift
//  SpaceX Launches
//
//  Created by Jekabs Solovjovs on 30/07/2024.
//

import Foundation
import Combine
import SwiftData

class ApiService {
    private let baseURL = "https://api.spacexdata.com/v5"
    private var cancellables = Set<AnyCancellable>()
    
    func updateLaunches(modelContext: ModelContext) {
        fetchLaunches()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { launches in
                launches.forEach { modelContext.insert($0) }
            }
            .store(in: &cancellables)
    }
    
    func fetchLaunches() -> AnyPublisher<[Launch], Error> {
        guard let url = URL(string: baseURL + "/launches") else {
            return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Launch].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
