//
//  Network.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 13/05/2025.
//

import Foundation

protocol Networkable {
    func request<T: Decodable>(endpoint: Endpoint) async throws -> NetworkResponse<T>
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidStatus(Int)
    case commonError(ErrorResponse)
    case invalidDecode(Error)
}

final class NetworkService: Networkable {
    
    private let envorinment: Environment
    private let session = URLSession.shared
    private let decoder: JSONDecoder
    
    init(environment: Environment) {
        self.envorinment = environment
        self.decoder = JSONDecoder()
    }
    
    func request<T: Decodable>(endpoint: Endpoint) async throws -> NetworkResponse<T> {
        
        // create request url with query or body data
        guard let request = endpoint.urlRequest(appEnvironment: envorinment.appEnvironment) else {
            throw NetworkError.invalidURL
        }
        print(3, Thread.isMainThread, #function)
        // data request
        let (data, response) = try await session.data(for: request)
        
        // check response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        // check status code within 2xx
        guard (200...299).contains(httpResponse.statusCode) else {
            do {
                let errorData = try decoder.decode(ErrorResponse.self, from: data)
                throw NetworkError.commonError(errorData)
            } catch {
                throw NetworkError.invalidStatus(httpResponse.statusCode)
            }
        }
        
        // check next page
        let linkHeader = httpResponse.value(forHTTPHeaderField: "Link")
        let hasNextPage = linkHeader?.contains("rel=\"next\"") ?? false
        
        // decode data
        do {
            let data = try decoder.decode(T.self, from: data)
            return NetworkResponse(value: data, hasNextPage: hasNextPage)
        } catch {
            throw NetworkError.invalidDecode(error)
        }
    }
}
