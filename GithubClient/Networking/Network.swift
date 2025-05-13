//
//  Network.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 13/05/2025.
//

import Foundation

protocol Networkable {
    func request<T: Decodable>(endpoint: Endpoint) async throws -> (T, Bool)
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidStatus(Int)
    case invalidDecode(Error)
}

final class NetworkService: Networkable {
    
    private let envorinment: Environment
    private let session = URLSession.shared
    
    init(environment: Environment) {
        self.envorinment = environment
    }
    
    func request<T: Decodable>(endpoint: Endpoint) async throws -> (T, Bool) {
        
        // create request url with query or body data
        guard let request = endpoint.urlRequest(appEnvironment: envorinment.appEnvironment) else {
            throw NetworkError.invalidURL
        }
        
        // data request
        let (data, response) = try await session.data(for: request)
        
        // check response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        // check status code within 2xx
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidStatus(httpResponse.statusCode)
        }
        
        // check next page
        let linkHeader = httpResponse.value(forHTTPHeaderField: "Link")
        let nextPageExists = linkHeader?.contains("rel=\"next\"") ?? false
        
        // decode data
        do {
            let data = try JSONDecoder().decode(T.self, from: data)
            return (data, nextPageExists)
        } catch {
            throw NetworkError.invalidDecode(error)
        }
    }
}
