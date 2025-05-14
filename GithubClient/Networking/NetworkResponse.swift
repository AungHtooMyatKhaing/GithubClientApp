//
//  NetworkResponse.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 14/05/2025.
//

import Foundation

struct NetworkResponse<T: Decodable> {
    let value: T?
    let hasNextPage: Bool
}

struct ErrorResponse: Decodable {
    let message: String?
    let errors: [ErrorItem]?
    let status: String?
}

struct ErrorItem: Decodable {
    let resource: String?
    let field: String?
    let code: String?
}
