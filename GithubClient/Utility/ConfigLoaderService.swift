//
//  ConfigLoaderService.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 13/05/2025.
//

import Foundation

enum SecretKey: String {
    case accessToken = "GITHUB_ACCESS_TOKEN"
}

protocol Secretable {
    func get(key: SecretKey) -> String?
}

final class ConfigLoaderService: Secretable {
    func get(key: SecretKey) -> String? {
        guard let value = Bundle.main.infoDictionary?[key.rawValue] as? String else {
            return nil
        }
        
        return value
    }
}
