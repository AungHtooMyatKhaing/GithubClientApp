//
//  UserListViewModelTests.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 14/05/2025.
//

import XCTest
import Combine
@testable import GithubClient

@MainActor
final class UserListViewModelTests: XCTestCase {
    
    private var sut: UserListViewModel!
    private var mockService: MockGithubService!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        sut = UserListViewModel(service: mockService)
        mockService = MockGithubService()
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Fetch Users Tests
    
    func test_fetchUsers_success() async {
        // Given
        let expectedUsers = [User(userName: "user1", id: 1), User(userName: "user2", id: 2)]
        mockService.mockUsers = expectedUsers
        mockService.mockHasNextPage = true
        
        // When
        sut.fetchUsers()
        
        // Then
        await fulfillment(of: [mockService.fetchUsersExpectation], timeout: 1.0)
        XCTAssertEqual(sut.users, expectedUsers)
        XCTAssertTrue(sut.hasNextPage)
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.isEmpty)
    }
    
    func test_fetchUsers_failure() async {
        // Given
        mockService.shouldFail = true
        
        // When
        sut.fetchUsers()
        
        // Then
        await fulfillment(of: [mockService.fetchUsersExpectation], timeout: 1.0)
        XCTAssertTrue(sut.users.isEmpty)
        XCTAssertFalse(sut.hasNextPage)
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.isEmpty)
    }
    
    // MARK: - Search Users Tests
    
    func test_searchUsers_success() async {
        // Given
        let expectedUsers = [User(userName: "search1", id: 1), User(userName: "search2", id: 2)]
        mockService.mockUsers = expectedUsers
        mockService.mockHasNextPage = true
        sut.search = "test"
        
        // When
        sut.searchUsers()
        
        // Then
        await fulfillment(of: [mockService.searchUsersExpectation], timeout: 1.0)
        XCTAssertEqual(sut.users, expectedUsers)
        XCTAssertTrue(sut.hasNextPage)
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.isEmpty)
    }
    
    func test_searchUsers_failure() async {
        // Given
        mockService.shouldFail = true
        sut.search = "test"
        
        // When
        sut.searchUsers()
        
        // Then
        await fulfillment(of: [mockService.searchUsersExpectation], timeout: 1.0)
        XCTAssertTrue(sut.users.isEmpty)
        XCTAssertFalse(sut.hasNextPage)
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.isEmpty)
    }
    
    // MARK: - Refresh Tests
    
    func test_refresh_whenSearching() async {
        // Given
        sut.search = "test"
        let expectedUsers = [User(userName: "refresh1", id: 1)]
        mockService.mockUsers = expectedUsers
        
        // When
        sut.refresh()
        
        // Then
        await fulfillment(of: [mockService.searchUsersExpectation], timeout: 1.0)
        XCTAssertEqual(sut.users, expectedUsers)
    }
    
    func test_refresh_whenNotSearching() async {
        // Given
        let expectedUsers = [User(userName: "refresh1", id: 1)]
        mockService.mockUsers = expectedUsers
        
        // When
        sut.refresh()
        
        // Then
        await fulfillment(of: [mockService.fetchUsersExpectation], timeout: 1.0)
        XCTAssertEqual(sut.users, expectedUsers)
    }
    
    // MARK: - Next Page Tests
    
    func test_nextPage_whenSearching() async {
        // Given
        sut.search = "test"
        let initialUsers = [User(userName: "user1", id: 1)]
        let nextPageUsers = [User(userName: "user2", id: 1)]
        mockService.mockUsers = initialUsers
        
        // When
        sut.searchUsers()
        await fulfillment(of: [mockService.searchUsersExpectation], timeout: 1.0)
        
        mockService.mockUsers = nextPageUsers
        sut.nextPage()
        
        // Then
        await fulfillment(of: [mockService.searchUsersExpectation], timeout: 1.0)
        XCTAssertEqual(sut.users, initialUsers + nextPageUsers)
    }
    
    func test_nextPage_whenNotSearching() async {
        // Given
        let initialUsers = [User(userName: "user1", id: 1)]
        let nextPageUsers = [User(userName: "user2", id: 2)]
        mockService.mockUsers = initialUsers
        
        // When
        sut.fetchUsers()
        await fulfillment(of: [mockService.fetchUsersExpectation], timeout: 1.0)
        
        mockService.mockUsers = nextPageUsers
        sut.nextPage()
        
        // Then
        await fulfillment(of: [mockService.fetchUsersExpectation], timeout: 1.0)
        XCTAssertEqual(sut.users, initialUsers + nextPageUsers)
    }
    
    // MARK: - Search Debounce Tests
    
    func test_searchDebounce() async {
        // Given
        let expectation = XCTestExpectation(description: "Search debounce")
        let expectedUsers = [User(userName: "debounce1", id: 1)]
        mockService.mockUsers = expectedUsers
        
        // When
        sut.search = "test"
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.users, expectedUsers)
    }
    
//    func test_isLastItem() {
//        // Given
//        let users = [User(userName: "user1", id: 1), User(userName: "user2", id: 2)]
//        sut.users = users
//        
//        // Then
//        XCTAssertTrue(sut.isLastItem(id: 2))
//        XCTAssertFalse(sut.isLastItem(id: 1))
//        XCTAssertFalse(sut.isLastItem(id: nil))
//    }
}

// MARK: - Mock Service

private class MockGithubService: GithubServiceable {
    var mockUsers: [User] = []
    var mockRepos: [Repository] = []
    var mockHasNextPage: Bool = false
    var shouldFail: Bool = false
    
    let fetchUsersExpectation = XCTestExpectation(description: "Fetch users")
    let searchUsersExpectation = XCTestExpectation(description: "Search users")
    
    func users(request: UserRequest) async throws -> NetworkResponse<[User]> {
        fetchUsersExpectation.fulfill()
        if shouldFail {
            throw NetworkError.invalidResponse
        }
        
        return NetworkResponse(value: mockUsers, hasNextPage: mockHasNextPage)
    }
    
    func searchUsers(request: SearchRequest) async throws -> NetworkResponse<Page<[User]>> {
        searchUsersExpectation.fulfill()
        if shouldFail {
            throw NetworkError.invalidResponse
        }
        
        let page = Page.init(totalCount: 1, incompleteResults: false, items: mockUsers)
        return NetworkResponse(value: page, hasNextPage: mockHasNextPage)
    }
    
    func userDetail(userName: String) async throws -> NetworkResponse<User> {
        if shouldFail {
            throw NetworkError.invalidResponse
        }
        
        return NetworkResponse(value: mockUsers.first, hasNextPage: mockHasNextPage)
    }
    
    func searchRepos(request: GithubClient.SearchRequest) async throws -> NetworkResponse<Page<[Repository]>> {
        if shouldFail {
            throw NetworkError.invalidResponse
        }
        
        let page = Page.init(totalCount: 1, incompleteResults: false, items: mockRepos)
        return NetworkResponse(value: page, hasNextPage: mockHasNextPage)
    }
}
