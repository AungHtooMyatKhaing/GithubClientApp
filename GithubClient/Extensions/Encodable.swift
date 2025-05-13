//
//  Encodable.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 13/05/2025.
//

import Foundation

extension Encodable {
    
    /// Convert encodable properties to URLQueryItem array
    func queryItems() -> [URLQueryItem]? {
        // encode to dict
        guard let data = try? JSONEncoder().encode(self),
              let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }
        
        // map dict to query items
        return dict.map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }
    }
}
