//
//  User.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 13/05/2025.
//

import Foundation

struct User: Decodable {
    let userName: String?
    let id: Int?
    let nodeId: String?
    let avatarUrl: String?
    let type: String?
    let userViewType: String?
    
    enum CodingKeys: String, CodingKey {
        case userName
        case id
        case nodeId = "node_id"
        case avatarUrl = "avatar_url"
        case type
        case userViewType = "user_view_type"
    }
}
