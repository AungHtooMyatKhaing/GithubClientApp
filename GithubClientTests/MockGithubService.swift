//
//  MockGithubService.swift
//  GithubClientTests
//
//  Created by Aung Htoo Myat Khaing on 17/05/2025.
//

import Foundation
import XCTest
@testable import GithubClient

final class MockGithubService: GithubServiceable {
    var mockUsers: [User] = []
    var mockRepos: [Repository] = []
    var mockHasNextPage: Bool = false
    var shouldFail: Bool = false
    
    let fetchUsersExpectation = XCTestExpectation(description: "Fetch users")
    let searchUsersExpectation = XCTestExpectation(description: "Search users")
    let userDetailExpectation = XCTestExpectation(description: "User detail")
    let searchReposExpectation = XCTestExpectation(description: "Search repos")
    
    func users(request: UserRequest) async throws -> NetworkResponse<[User]> {
        fetchUsersExpectation.fulfill()
        if shouldFail {
            throw NetworkError.invalidResponse
        }
        
        return NetworkResponse(value: mockUsers, hasNextPage: mockHasNextPage)
    }
    
    func searchUsers(request: SearchRequest) async throws -> NetworkResponse<Page<[User]>> {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.searchUsersExpectation.fulfill()
        }
        
        if shouldFail {
            throw NetworkError.invalidResponse
        }
        
        let page = Page.init(totalCount: 1, incompleteResults: false, items: mockUsers)
        return NetworkResponse(value: page, hasNextPage: mockHasNextPage)
    }
    
    func userDetail(userName: String) async throws -> NetworkResponse<User> {
        userDetailExpectation.fulfill()
        if shouldFail {
            throw NetworkError.invalidResponse
        }
        
        return NetworkResponse(value: mockUsers.first, hasNextPage: mockHasNextPage)
    }
    
    func searchRepos(request: GithubClient.SearchRequest) async throws -> NetworkResponse<Page<[Repository]>> {
        searchReposExpectation.fulfill()
        if shouldFail {
            throw NetworkError.invalidResponse
        }
        
        let page = Page.init(totalCount: 1, incompleteResults: false, items: mockRepos)
        return NetworkResponse(value: page, hasNextPage: mockHasNextPage)
    }
}
