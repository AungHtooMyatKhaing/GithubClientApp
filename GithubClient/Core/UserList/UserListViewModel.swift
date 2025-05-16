//
//  UserListViewModel.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 14/05/2025.
//

import Foundation
import Combine

@MainActor
protocol UserListViewModelProtocol: ObservableObject {
    var users: [User] { get }
    var search: String { get }
    var hasNextPage: Bool { get }
    var isSearching: Bool { get }
    var isLoading: Bool { get }
    var isEmpty: Bool { get }
    
    func fetchUsers()
    func searchUsers()
    func refresh()
    func nextPage()
    func isLastItem(id: Int?) -> Bool
}

@MainActor
final class UserListViewModel: UserListViewModelProtocol {
    
    // MARK: - Published Perperties
    
    @Published private(set) var users: [User] = []
    @Published var search: String = ""
    @Published private(set) var hasNextPage: Bool = false
    @Published private(set) var isSearching: Bool = false
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var isEmpty: Bool = false
    
    // MARK: - Private Properties
    
    private var tasks: Set<Task<Void, Never>> = []
    private var cancellables: Set<AnyCancellable> = []
    private let service: GithubServiceable
    private var fetchUserRequest = UserRequest(since: nil)
    private var searchUserRequest = SearchRequest(query: "")
    
    // MARK: - Init
    
    init(service: GithubServiceable) {
        self.service = service
        observeSearch()
    }
    
    // MARK: - Public Methods
    
    func fetchUsers() {
        guard !isLoading else { return }
        
        isLoading = true
        isSearching = false
        
        let task = Task {
            do {
                
                let response = try await service.users(request: fetchUserRequest)
                let fetchedUsers = response.value ?? []
                
                if fetchUserRequest.since == nil {
                    // first page
                    self.users = fetchedUsers
                } else {
                    // next page
                    self.users.append(contentsOf: fetchedUsers)
                }
                
                self.updateState(hasNextPage: response.hasNextPage)
                
            } catch {
                isLoading = false
                isEmpty = true
                print("Error:", error)
            }
        }
        
        tasks.insert(task)
    }
    
    func searchUsers() {
        guard !isLoading else { return }
        
        isLoading = true
        isSearching = true
        
        let task = Task {
            do {
                
                let response = try await service.searchUsers(request: searchUserRequest)
                let searchedUsers = response.value?.items ?? []
                
                if searchUserRequest.page == 1 {
                    // first page
                    self.users = searchedUsers
                } else {
                    // next page
                    self.users.append(contentsOf: searchedUsers)
                }
                
                self.updateState(hasNextPage: response.hasNextPage)
                
            } catch {
                isLoading = false
                isEmpty = true
                print("Error:", error)
            }
        }
        
        tasks.insert(task)
    }
    
    func refresh() {
        if isSearching {
            searchUserRequest = .init(query: search)
            searchUsers()
        } else {
            fetchUserRequest = .init(since: nil)
            fetchUsers()
        }
    }
    
    func nextPage() {
        if isSearching {
            searchUserRequest.next()
            searchUsers()
        } else {
            guard let lastId = users.last?.id else { return }
            fetchUserRequest.next(since: lastId)
            fetchUsers()
        }
    }
    
    func isLastItem(id: Int?) -> Bool {
        users.last?.id == id
    }
    
    // MARK: - deinit
    
    deinit {
        tasks.forEach { $0.cancel() }
        cancellables.forEach { $0.cancel() }
    }
    
    // MARK: - Private Helpers Methods
    
    private func observeSearch() {
        // debounce 0.5 sec for user search input
        $search
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] value in
                guard let self else { return }
                
                if value.isEmpty {
                    self.fetchUserRequest = UserRequest(since: nil)
                    self.fetchUsers()
                } else {
                    self.searchUserRequest = SearchRequest(query: value)
                    self.searchUsers()
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateState(hasNextPage: Bool) {
        self.hasNextPage = hasNextPage
        self.isEmpty = self.users.isEmpty
        self.isLoading = false
    }
}
