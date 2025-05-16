//
//  User.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 13/05/2025.
//

import Foundation

// /users [GET]
struct UserRequest: Encodable {
    var since: Int?
    var limit: Int
    
    init(since: Int?, limit: Int = 30) {
        self.since = since
        self.limit = limit
    }
    
    mutating func next(since: Int) {
        self.since = since
    }
    
    enum CodingKeys: String, CodingKey {
        case since
        case limit = "per_page"
    }
}

struct User: Decodable, Equatable {
    let userName: String?
    let id: Int?
    let nodeId: String?
    let avatarUrl: String?
    let htmlUrl: String?
    let type: String?
    let userViewType: String?
    let name: String?
    let company: String?
    let blog: String?
    let location: String?
    let email: String?
    let bio: String?
    let followers: Int?
    let following: Int?
    
    init(
        userName: String?,
        id: Int?,
        nodeId: String? = nil,
        avatarUrl: String? = nil,
        htmlUrl: String? = nil,
        type: String? = nil,
        userViewType: String? = nil,
        name: String? = nil,
        company: String? = nil,
        blog: String? = nil,
        location: String? = nil,
        email: String? = nil,
        bio: String? = nil,
        followers: Int? = nil,
        following: Int? = nil
    ) {
        self.userName = userName
        self.id = id
        self.nodeId = nodeId
        self.avatarUrl = avatarUrl
        self.htmlUrl = htmlUrl
        self.type = type
        self.userViewType = userViewType
        self.name = name
        self.company = company
        self.blog = blog
        self.location = location
        self.email = email
        self.bio = bio
        self.followers = followers
        self.following = following
    }
    
    enum CodingKeys: String, CodingKey {
        case userName = "login"
        case id
        case nodeId = "node_id"
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
        case type
        case userViewType = "user_view_type"
        case name
        case company
        case blog
        case location
        case email
        case bio
        case followers
        case following
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}
