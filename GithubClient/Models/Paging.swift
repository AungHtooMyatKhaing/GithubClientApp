//
//  Paging.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 13/05/2025.
//

import Foundation

struct Page<T: Decodable>: Decodable {
    let totalCount: Int?
    let incompleteResults: Bool?
    let items: T?
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}
