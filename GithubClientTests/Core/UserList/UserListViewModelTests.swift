import XCTest
import Combine
@testable import GithubClient

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
        let expectedUsers = [User(id: 1, login: "user1"), User(id: 2, login: "user2")]
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
        let expectedUsers = [User(id: 1, login: "search1"), User(id: 2, login: "search2")]
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
        let expectedUsers = [User(id: 1, login: "refresh1")]
        mockService.mockUsers = expectedUsers
        
        // When
        sut.refresh()
        
        // Then
        await fulfillment(of: [mockService.searchUsersExpectation], timeout: 1.0)
        XCTAssertEqual(sut.users, expectedUsers)
    }
    
    func test_refresh_whenNotSearching() async {
        // Given
        let expectedUsers = [User(id: 1, login: "refresh1")]
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
        let initialUsers = [User(id: 1, login: "user1")]
        let nextPageUsers = [User(id: 2, login: "user2")]
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
        let initialUsers = [User(id: 1, login: "user1")]
        let nextPageUsers = [User(id: 2, login: "user2")]
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
        let expectedUsers = [User(id: 1, login: "debounce1")]
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
    
    func test_isLastItem() {
        // Given
        let users = [User(id: 1, login: "user1"), User(id: 2, login: "user2")]
        sut.users = users
        
        // Then
        XCTAssertTrue(sut.isLastItem(id: 2))
        XCTAssertFalse(sut.isLastItem(id: 1))
        XCTAssertFalse(sut.isLastItem(id: nil))
    }
}

// MARK: - Mock Service

private class MockGithubService: GithubServiceable {
    var mockUsers: [User] = []
    var mockHasNextPage: Bool = false
    var shouldFail: Bool = false
    
    let fetchUsersExpectation = XCTestExpectation(description: "Fetch users")
    let searchUsersExpectation = XCTestExpectation(description: "Search users")
    
    func users(request: UserRequest) async throws -> PaginatedResponse<[User]> {
        fetchUsersExpectation.fulfill()
        if shouldFail {
            throw NSError(domain: "test", code: -1)
        }
        return PaginatedResponse(value: mockUsers, hasNextPage: mockHasNextPage)
    }
    
    func searchUsers(request: SearchRequest) async throws -> PaginatedResponse<SearchResponse> {
        searchUsersExpectation.fulfill()
        if shouldFail {
            throw NSError(domain: "test", code: -1)
        }
        return PaginatedResponse(value: SearchResponse(items: mockUsers), hasNextPage: mockHasNextPage)
    }
} 