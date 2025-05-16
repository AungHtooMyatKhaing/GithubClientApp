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
        mockService = MockGithubService()
        sut = UserListViewModel(service: mockService)
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
        let expectedUsers = [MockData.user1, MockData.user2]
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
        let expectedUsers = [MockData.user1, MockData.user2]
        mockService.mockUsers = expectedUsers
        mockService.mockHasNextPage = true
        
        // When
        sut.search = "test"
        
        // Then
        await fulfillment(of: [mockService.searchUsersExpectation], timeout: 2.0)
        XCTAssertEqual(sut.users, expectedUsers)
        XCTAssertTrue(sut.hasNextPage)
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.isEmpty)
    }
    
    func test_searchUsers_failure() async {
        // Given
        mockService.shouldFail = true
        
        // When
        sut.search = "test"
        
        // Then
        await fulfillment(of: [mockService.searchUsersExpectation], timeout: 2.0)
        XCTAssertTrue(sut.users.isEmpty)
        XCTAssertFalse(sut.hasNextPage)
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.isEmpty)
    }
    
    // MARK: - Refresh Tests
    
    func test_refresh_whenSearching() async {
        // Given
        sut.search = "test"
        let expectedUsers = [MockData.user1]
        mockService.mockUsers = expectedUsers
        
        // When
        sut.refresh()
        
        // Then
        await fulfillment(of: [mockService.searchUsersExpectation], timeout: 2.0)
        XCTAssertEqual(sut.users, expectedUsers)
    }
    
    func test_refresh_whenNotSearching() async {
        // Given
        let expectedUsers = [MockData.user1]
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
        let initialUsers = [MockData.user1]
        let nextPageUsers = [MockData.user2]
        mockService.mockUsers = initialUsers
        mockService.mockHasNextPage = true
        
        // When - search
        sut.search = "test"
        
        // When - load more
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.mockService.mockUsers = nextPageUsers
            self.sut.nextPage()
        }
        
        // Then
        await fulfillment(of: [mockService.searchUsersExpectation], timeout: 5.0)
        XCTAssertEqual(sut.users, initialUsers + nextPageUsers)
    }
    
    func test_nextPage_whenNotSearching() async {
        // Given
        let initialUsers = [MockData.user1]
        let nextPageUsers = [MockData.user2]
        mockService.mockUsers = initialUsers
        mockService.mockHasNextPage = true
        
        // When
        sut.fetchUsers()
        try! await Task.sleep(nanoseconds: 1_000_000)
        
        mockService.mockUsers = nextPageUsers
        sut.nextPage()
        
        // Then
        await fulfillment(of: [mockService.fetchUsersExpectation], timeout: 1.0)
        XCTAssertEqual(sut.users, initialUsers + nextPageUsers)
    }
    
    // MARK: - Search Debounce Tests
    
    func test_searchDebounce() async {
        // Given
        let expectedUsers = [MockData.user1]
        mockService.mockUsers = expectedUsers
        
        // When
        sut.search = "test"
        
        // Then
        await fulfillment(of: [mockService.searchUsersExpectation], timeout: 2.0)
        XCTAssertEqual(sut.users, expectedUsers)
    }
    
    func test_isLastItem() async {
        // Given
        let expectedUsers = [MockData.user1, MockData.user2]
        mockService.mockUsers = expectedUsers
        
        // When
        sut.fetchUsers()
        
        // Then
        await fulfillment(of: [mockService.fetchUsersExpectation], timeout: 2.0)
        XCTAssertTrue(sut.isLastItem(id: MockData.user2.id))
        XCTAssertFalse(sut.isLastItem(id: MockData.user1.id))
        XCTAssertFalse(sut.isLastItem(id: nil))
    }
}
