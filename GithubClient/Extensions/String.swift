//
//  String.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 14/05/2025.
//

import Foundation

enum DateFormat: String {
    case utc = "yyyy-MM-dd'T'HH:mm:ssZ"
    case mmmdyyyy = "MMM d, yyyy"
}

extension String {
    
    /// convert to URL
    var url: URL? {
        URL(string: self)
    }
    
    /// convert string to date
    func toDate(_ format: DateFormat) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.date(from: self)
    }
}
