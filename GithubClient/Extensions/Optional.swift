//
//  Optional.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 14/05/2025.
//

extension Optional where Wrapped == String {
    
    var orEmpty: String {
        self ?? ""
    }
}
