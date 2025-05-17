//
//  GithubServiceTests.swift
//  GithubClientTests
//
//  Created by Aung Htoo Myat Khaing on 17/05/2025.
//

import XCTest
@testable import GithubClient

final class GithubServiceTests: XCTestCase {
    
    private var sut: GithubService!
    private var mockNetworkService: MockNetworkService!
    
    override func setUpWithError() throws {
        mockNetworkService = MockNetworkService()
        sut = GithubService(networkService: mockNetworkService)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockNetworkService = nil
    }
    
    // MARK: - Users Tests
    
    func test_Users_Success() async throws {
        // Given
        let expectedUsers = [MockData.user1]
        let request = UserRequest(since: 0)
        mockNetworkService.mockResponse = NetworkResponse(value: expectedUsers, hasNextPage: true)
        
        // When
        let response = try await sut.users(request: request)
        
        // Then
        XCTAssertEqual(response.value, expectedUsers)
        XCTAssertEqual(mockNetworkService.lastEndpoint, .users(request))
    }
    
    func test_Users_Failure() async throws {
        // Given
        let request = UserRequest(since: 0)
        mockNetworkService.mockError = NetworkError.invalidResponse
        
        // When/Then
        do {
            _ = try await sut.users(request: request)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? NetworkError, .invalidResponse)
        }
    }
    
    // MARK: - User Detail Tests
    
    func test_UserDetail_Success() async throws {
        // Given
        let expectedUser = MockData.user1
        let userName = MockData.user1.userName.orEmpty
        mockNetworkService.mockResponse = NetworkResponse(value: expectedUser, hasNextPage: false)
        
        // When
        let response = try await sut.userDetail(userName: userName)
        
        // Then
        XCTAssertEqual(response.value, expectedUser)
        XCTAssertEqual(mockNetworkService.lastEndpoint, .userDetail(userName: userName))
    }
    
    func test_UserDetail_Failure() async throws {
        // Given
        let userName = "testUser"
        mockNetworkService.mockError = NetworkError.invalidResponse
        
        // When/Then
        do {
            _ = try await sut.userDetail(userName: userName)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? NetworkError, .invalidResponse)
        }
    }
    
    // MARK: - Search Users Tests
    
    func test_SearchUsers_Success() async throws {
        // Given
        let expectedUsers = [MockData.user1]
        let page = Page(totalCount: 1, incompleteResults: false, items: expectedUsers)
        let request = SearchRequest(query: "test")
        mockNetworkService.mockResponse = NetworkResponse(value: page, hasNextPage: true)
        
        // When
        let response = try await sut.searchUsers(request: request)
        
        // Then
        XCTAssertEqual(response.value?.items, expectedUsers)
        XCTAssertEqual(mockNetworkService.lastEndpoint, .searchUsers(request))
    }
    
    func test_SearchUsers_Failure() async throws {
        // Given
        let request = SearchRequest(query: "test")
        mockNetworkService.mockError = NetworkError.invalidResponse
        
        // When/Then
        do {
            _ = try await sut.searchUsers(request: request)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? NetworkError, .invalidResponse)
        }
    }
    
    // MARK: - Search Repos Tests
    
    func test_SearchRepos_Success() async throws {
        // Given
        let expectedRepos = [MockData.repo1]
        let page = Page(totalCount: 1, incompleteResults: false, items: expectedRepos)
        let request = SearchRequest(query: "test")
        mockNetworkService.mockResponse = NetworkResponse(value: page, hasNextPage: true)
        
        // When
        let response = try await sut.searchRepos(request: request)
        
        // Then
        XCTAssertEqual(response.value?.items, expectedRepos)
        XCTAssertEqual(mockNetworkService.lastEndpoint, .searchRepos(request))
    }
    
    func test_SearchRepos_Failure() async throws {
        // Given
        let request = SearchRequest(query: "test")
        mockNetworkService.mockError = NetworkError.invalidResponse
        
        // When/Then
        do {
            _ = try await sut.searchRepos(request: request)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? NetworkError, .invalidResponse)
        }
    }
}
