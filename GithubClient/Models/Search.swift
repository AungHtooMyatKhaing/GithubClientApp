//
//  Search.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 14/05/2025.
//

enum SortBy: String, Encodable {
    case followers
    case repositories
    case joined
    case stars
    case forks
    case helpWantedIssues = "help-wanted-issues"
    case updated
}

enum OrderBy: String, Encodable {
    case desc
    case asc
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
    
    init(repoName: String?, userName: String?, sort: SortBy? = nil, order: OrderBy? = nil, limit: Int = 30, page: Int = 1) {
        
        let query = "\(repoName.orEmpty) in:name in:description user: \(userName.orEmpty)"
        
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
