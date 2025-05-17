//
//  Repository.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 14/05/2025.
//

import Foundation

struct Repository: Decodable {
    let id: Int?
    let nodeId: String?
    let name: String?
    let fullName: String?
    let isPrivate: Bool?
    let owner: User?
    let htmlUrl: String?
    let description: String?
    let fork: Bool?
    let url: String?
    let stargazersCount: Int?
    let watchersCount: Int?
    let language: String?
    let forksCount: Int?
    let license: License?
    let createdAt: String?
    let updatedAt: String?
    
    var createdDate: Date? {
        return createdAt?.toDate(.utc)
    }
    
    var updatedDate: Date? {
        return updatedAt?.toDate(.utc)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case nodeId = "node_id"
        case name
        case fullName = "full_name"
        case isPrivate = "private"
        case owner
        case htmlUrl = "html_url"
        case description
        case fork
        case url
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case language
        case forksCount = "forks_count"
        case license
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

extension Repository: Equatable {
    static func == (lhs: Repository, rhs: Repository) -> Bool {
        lhs.id == rhs.id
    }
}

struct License: Decodable {
    let key: String?
    let name: String?
    let spdxId: String?
    let url: String?
    let nodeId: String?
    
    enum CodingKeys: String, CodingKey {
        case key
        case name
        case spdxId = "spdx_id"
        case url
        case nodeId = "node_id"
    }
}
