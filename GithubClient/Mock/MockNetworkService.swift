//
//  MockNetworkService.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 17/05/2025.
//

class MockNetworkService: Networkable {
    var mockResponse: Any?
    var mockError: Error?
    var lastEndpoint: Endpoint?
    
    func request<T: Decodable>(endpoint: Endpoint) async throws -> NetworkResponse<T> {
        lastEndpoint = endpoint
        
        if let error = mockError {
            throw error
        }
        
        guard let response = mockResponse as? NetworkResponse<T> else {
            throw NetworkError.invalidResponse
        }
        
        return response
    }
}
