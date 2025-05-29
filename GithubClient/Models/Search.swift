//
//  Search.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 14/05/2025.
//

enum SortBy: String, Encodable, Hashable {
    case followers
    case repositories
    case joined
    case stars
    case forks
    case helpWantedIssues = "help-wanted-issues"
    case updated
}

extension SortBy {
    var title: String {
        switch self {
        case .followers:
            return "Followers"
        case .repositories:
            return "Repositories"
        case .joined:
            return "Joined"
        case .stars:
            return "Stars"
        case .forks:
            return "Forks"
        case .helpWantedIssues:
            return "Help Wanted"
        case .updated:
            return "Updated"
        }
    }
}

enum OrderBy: String, Encodable {
    case desc
    case asc
}

extension OrderBy {
    var imageName: String {
        switch self {
        case .desc:
            return "arrow.down"
        case .asc:
            return "arrow.up"
        }
    }
}

enum ForkStatus: String, Encodable {
    case `true`
    case `false`
    case only
}

// /search/users [GET]
// /search/repos [GET]
struct SearchRequest: Encodable {
    let query: String
    let sort: SortBy?
    let order: OrderBy?
    let limit: Int
    var page: Int
    
    init(query: String, sort: SortBy? = nil, order: OrderBy? = nil, limit: Int = 30, page: Int = 1) {
        self.query = query
        self.sort = sort
        self.order = order
        self.limit = limit
        self.page = page
    }
    
    init(repoName: String? = nil, userName: String?, sort: SortBy? = nil, order: OrderBy? = nil, fork: ForkStatus? = nil, limit: Int = 30, page: Int = 1) {
        
        var query = ""
        
        if let repoName {
            query += "\(repoName) "
        }
        
        if let userName {
            query += "user:\(userName) "
        }
        
        if let fork {
            query += "fork:\(fork.rawValue) "
        }
        
        self.init(
            query: query,
            sort: sort,
            order: order,
            limit: limit,
            page: page
        )
    }
    
    enum CodingKeys: String, CodingKey {
        case query = "q"
        case sort
        case order
        case limit = "per_page"
        case page
    }
    
    mutating func next() {
        page += 1
    }
}
