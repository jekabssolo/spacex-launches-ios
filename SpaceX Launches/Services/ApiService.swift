//
//  ApiService.swift
//  SpaceX Launches
//
//  Created by Jekabs Solovjovs on 30/07/2024.
//

import Foundation
import Combine

class ApiService {
    static let shared = ApiService()
    
    private let baseURL = "https://api.spacexdata.com/v5"
    
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
