//
//  UserDetailViewModel.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 15/05/2025.
//

import Foundation
import Combine

@MainActor
protocol UserDetailViewModelProtocol: ObservableObject {
    var detail: UserDetailHeaderViewModel? { get }
    var repos: [RepoListCellViewModel] { get }
    var sortBy: SortBy { get }
    var orderBy: OrderBy { get }
    var hasNextPage: Bool { get }
    var isLoading: Bool { get }
    var isEmpty: Bool { get }
    var error: String? { get }
    
    func fetchDetail()
    func fetchRepos()
    func refresh()
    func nextPage()
    func isLastItem(id: Int?) -> Bool
}

enum FetchResult {
    case userDetail(NetworkResponse<User>)
    case repos(NetworkResponse<Page<[Repository]>>)
}

@MainActor
final class UserDetailViewModel: UserDetailViewModelProtocol {
    
    // MARK: - Published Perperties
    
    @Published private(set) var detail: UserDetailHeaderViewModel? = nil
    @Published private(set) var repos: [RepoListCellViewModel] = []
    @Published private(set) var hasNextPage: Bool = false
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var isEmpty: Bool = false
    
    @Published var sortBy: SortBy = .updated
    @Published var orderBy: OrderBy = .desc
    @Published var error: String? = nil
    
    // MARK: - Private Properties
    
    private var tasks: Set<Task<Void, Never>> = []
    private var cancellables: Set<AnyCancellable> = []
    private let userName: String
    private let service: GithubServiceable
    private var fetchReposRequest: SearchRequest
    
    // MARK: - Init
    
    init(userName: String, service: GithubServiceable) {
        self.userName = userName
        self.service = service
        self.fetchReposRequest = .init(userName: userName, sort: .updated, order: .desc, fork: .false)
        observeSortOptions()
    }
    
    // MARK: - Public Methods
    
    func fetchDetail() {
        guard !isLoading else { return }
        isLoading = true
        error = nil
        
        let task = Task {
            
            // create a task group for user detail and repo list parallel call
            let fetchResults = await withThrowingTaskGroup(of: FetchResult.self) { group in
                
                // fetch user detail by user name
                group.addTask {
                    let response = try await self.service.userDetail(userName: self.userName)
                    
                    // send back FetchResult.userDetail, with network response
                    return .userDetail(response)
                }
                
                // fetch repos by username
                group.addTask {
                    let response = try await self.service.searchRepos(request: self.fetchReposRequest)
                    
                    // send back FetchResult.repos, with network response
                    return .repos(response)
                }
                
                // temp holding for each task
                var user: User?
                var repos: [Repository]?
                var hasNextPage: Bool = false
                
                // read and copy data from each task inside task group
                do {
                    for try await value in group {
                        switch value {
                        case .userDetail(let response):
                            user = response.value
                            
                        case .repos(let response):
                            repos = response.value?.items
                            hasNextPage = response.hasNextPage
                        }
                    }
                } catch {
                    handleError(error: error)
                }
                
                // send back fetched data as turple
                // 0. user detail
                // 1. repo list
                // 2. hasNextPage flag
                // ** replace with custom struct if you don't want to use turple **
                return (user, repos, hasNextPage)
            }
            
            if let user = fetchResults.0 {
                self.detail = .init(data: user)
            }
            
            if let repos = fetchResults.1 {
                self.repos = repos.map { RepoListCellViewModel(data: $0) }
            }
            
            updateState(hasNextPage: fetchResults.2)
        }
        
        tasks.insert(task)
    }
    
    func fetchRepos() {
        guard !isLoading else { return }
        isLoading = true
        
        let task = Task {
            do {
                
                let response = try await service.searchRepos(request: fetchReposRequest)
                let repos = response.value?.items ?? []
                
                if fetchReposRequest.page == 1 {
                    // first page
                    self.repos = repos.map { RepoListCellViewModel(data: $0) }
                } else {
                    // next page
                    let vm = repos.map { RepoListCellViewModel(data: $0) }
                    self.repos.append(contentsOf: vm)
                }
                
                self.updateState(hasNextPage: response.hasNextPage)
                
            } catch {
                handleError(error: error)
            }
        }
        
        tasks.insert(task)
    }
    
    func refresh() {
        fetchReposRequest = .init(userName: userName, sort: sortBy, order: orderBy, fork: .false)
        fetchDetail()
    }
    
    func nextPage() {
        fetchReposRequest.next()
        fetchRepos()
    }
    
    func isLastItem(id: Int?) -> Bool {
        repos.last?.id == id
    }
    
    // MARK: - deinit
    
    deinit {
        tasks.forEach { $0.cancel() }
        cancellables.forEach { $0.cancel() }
        print("deinit: UserDetailViewModel")
    }
    
    // MARK: - Private Helpers Methods

    private func observeSortOptions() {
        let scheduler = RunLoop.main
        
        $sortBy
            .dropFirst()
            .receive(on: scheduler)
            .sink { [weak self] value in
                guard let self else { return }
                self.fetchReposRequest = .init(userName: self.userName, sort: value, order: self.orderBy, fork: .false)
                self.fetchRepos()
            }
            .store(in: &cancellables)
        
        $orderBy
            .dropFirst()
            .receive(on: scheduler)
            .sink { [weak self] value in
                guard let self else { return }
                self.fetchReposRequest = .init(userName: self.userName, sort: self.sortBy, order: value, fork: .false)
                self.fetchRepos()
            }
            .store(in: &cancellables)
    }
    
    private func handleError(error: Error) {
        if let networkError = error as? NetworkError {
            self.error = networkError.message
        } else {
            self.error = error.localizedDescription
        }
        
        self.isLoading = false
        self.isEmpty = repos.count == 0
        print("Error: \(error)")
    }
    
    private func updateState(hasNextPage: Bool) {
        self.hasNextPage = hasNextPage
        self.isEmpty = self.repos.count == 0
        self.isLoading = false
    }
}
