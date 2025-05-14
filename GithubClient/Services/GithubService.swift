//
//  GithubService.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 13/05/2025.
//

import Foundation

protocol GithubServiceable {
    func users(request: UserRequest) async throws -> NetworkResponse<[User]>
    func userDetail(userName: String) async throws -> NetworkResponse<User>
    func searchUsers(request: SearchRequest) async throws -> NetworkResponse<Page<[User]>>
    func searchRepos(request: SearchRequest) async throws -> NetworkResponse<Page<[Repository]>>
}

final class GithubService: GithubServiceable {
    
    private let networkService: Networkable
    
    init(networkService: Networkable) {
        self.networkService = networkService
    }
    
    func users(request: UserRequest) async throws -> NetworkResponse<[User]> {
        try await networkService.request(endpoint: .users(request))
    }
    
    func userDetail(userName: String) async throws -> NetworkResponse<User> {
        try await networkService.request(endpoint: .userDetail(userName: userName))
    }
    
    func searchUsers(request: SearchRequest) async throws -> NetworkResponse<Page<[User]>> {
        try await networkService.request(endpoint: .searchUsers(request))
    }
    
    func searchRepos(request: SearchRequest) async throws -> NetworkResponse<Page<[Repository]>> {
        try await networkService.request(endpoint: .searchRepos(request))
    }
}
