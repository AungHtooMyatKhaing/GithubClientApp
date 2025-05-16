//
//  UserDetailViewModelTests.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 17/05/2025.
//

import XCTest
import Combine
@testable import GithubClient

@MainActor
final class UserDetailViewModelTests: XCTestCase {
    
    private let testUserName: String = MockData.user1.userName.orEmpty
    private var sut: UserDetailViewModel!
    private var mockService: MockGithubService!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockService = MockGithubService()
        sut = UserDetailViewModel(userName: testUserName, service: mockService)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Fetch Detail Tests
    
    func test_fetchDetail_success() async {
        // Given
        let expectedUser = MockData.user1
        let expectedRepos = [MockData.repo1, MockData.repo2]
        mockService.mockUsers = [expectedUser]
        mockService.mockRepos = expectedRepos
        mockService.mockHasNextPage = true
        
        // When
        sut.fetchDetail()
        try! await Task.sleep(nanoseconds: 1_000_000)
        
        // Then
        await fulfillment(of: [mockService.userDetailExpectation, mockService.searchReposExpectation], timeout: 2.0)
        XCTAssertEqual(sut.detail?.userName, expectedUser.userName)
        XCTAssertEqual(sut.repos.count, expectedRepos.count)
        XCTAssertTrue(sut.hasNextPage)
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.isEmpty)
    }
    
    func test_fetchDetail_failure() async {
        // Given
        mockService.shouldFail = true
        
        // When
        sut.fetchDetail()
        
        // Then
        await fulfillment(of: [mockService.userDetailExpectation, mockService.searchReposExpectation], timeout: 1.0)
        XCTAssertNil(sut.detail)
        XCTAssertTrue(sut.repos.isEmpty)
        XCTAssertFalse(sut.hasNextPage)
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.isEmpty)
    }
    
    // MARK: - Fetch Repos Tests
    
    func test_fetchRepos_success_firstPage() async {
        // Given
        let expectedRepos = [MockData.repo1, MockData.repo2]
        mockService.mockRepos = expectedRepos
        mockService.mockHasNextPage = true
        
        // When
        sut.fetchRepos()
        
        // Then
        await fulfillment(of: [mockService.searchReposExpectation], timeout: 1.0)
        XCTAssertEqual(sut.repos.count, expectedRepos.count)
        XCTAssertTrue(sut.hasNextPage)
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.isEmpty)
    }
    
    func test_fetchRepos_success_nextPage() async {
        // Given
        let initialRepos = [MockData.repo1]
        let nextPageRepos = [MockData.repo2]
        mockService.mockRepos = initialRepos
        
        // When
        sut.fetchRepos()
        try! await Task.sleep(nanoseconds: 1_000_000)
        
        mockService.mockRepos = nextPageRepos
        sut.nextPage()
        
        // Then
        await fulfillment(of: [mockService.searchReposExpectation], timeout: 2.0)
        XCTAssertEqual(sut.repos.count, initialRepos.count + nextPageRepos.count)
    }
    
    func test_fetchRepos_failure() async {
        // Given
        mockService.shouldFail = true
        
        // When
        sut.fetchRepos()
        
        // Then
        await fulfillment(of: [mockService.searchReposExpectation], timeout: 1.0)
        XCTAssertTrue(sut.repos.isEmpty)
        XCTAssertFalse(sut.hasNextPage)
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_fetchRepos_preventsMultipleCalls() async {
        // Given
        let expectedRepos = [MockData.repo1]
        mockService.mockRepos = expectedRepos
        
        // When
        sut.fetchRepos()
        sut.fetchRepos() // Second call should be ignored
        
        // Then
        await fulfillment(of: [mockService.searchReposExpectation], timeout: 1.0)
        XCTAssertEqual(sut.repos.count, expectedRepos.count)
    }
    
    // MARK: - Sort Options Tests
    
    func test_sortBy_changes_triggersFetch() async {
        // Given
        let expectedRepos = [MockData.repo1]
        mockService.mockRepos = expectedRepos
        
        // When
        sut.sortBy = .stars
        try! await Task.sleep(nanoseconds: 1_000_000)
        
        // Then
        await fulfillment(of: [mockService.searchReposExpectation], timeout: 1.0)
        XCTAssertEqual(sut.repos.count, expectedRepos.count)
    }
    
    func test_orderBy_changes_triggersFetch() async {
        // Given
        let expectedRepos = [MockData.repo1]
        mockService.mockRepos = expectedRepos
        
        // When
        sut.orderBy = .asc
        try! await Task.sleep(nanoseconds: 1_000_000)
        
        // Then
        await fulfillment(of: [mockService.searchReposExpectation], timeout: 1.0)
        XCTAssertEqual(sut.repos.count, expectedRepos.count)
    }
    
    // MARK: - Refresh Tests
    
    func test_refresh() async {
        // Given
        let expectedUser = MockData.user1
        let expectedRepos = [MockData.repo1]
        mockService.mockUsers = [expectedUser]
        mockService.mockRepos = expectedRepos
        
        // When
        sut.refresh()
        try! await Task.sleep(nanoseconds: 1_000_000)
        
        // Then
        await fulfillment(of: [mockService.userDetailExpectation, mockService.searchReposExpectation], timeout: 2.0)
        XCTAssertEqual(sut.detail?.userName, expectedUser.userName)
        XCTAssertEqual(sut.repos.count, expectedRepos.count)
    }
    
    // MARK: - Next Page Tests
    
    func test_nextPage() async {
        // Given
        let initialRepos = [MockData.repo1]
        let nextPageRepos = [MockData.repo2]
        mockService.mockRepos = initialRepos
        
        // When
        sut.fetchRepos()
        try! await Task.sleep(nanoseconds: 1_000_000)
        
        mockService.mockRepos = nextPageRepos
        sut.nextPage()
        
        // Then
        await fulfillment(of: [mockService.searchReposExpectation], timeout: 1.0)
        XCTAssertEqual(sut.repos.count, initialRepos.count + nextPageRepos.count)
    }
    
    // MARK: - Last Item Tests
    
    func test_isLastItem() async {
        // Given
        let repos = [MockData.repo1, MockData.repo2]
        mockService.mockRepos = repos
        
        // When
        sut.fetchRepos()
        
        // Then
        await fulfillment(of: [mockService.searchReposExpectation], timeout: 2.0)
        XCTAssertTrue(sut.isLastItem(id: MockData.repo2.id))
        XCTAssertFalse(sut.isLastItem(id: MockData.repo1.id))
        XCTAssertFalse(sut.isLastItem(id: nil))
    }
}
