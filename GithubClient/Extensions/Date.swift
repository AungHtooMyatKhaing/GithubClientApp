//
//  Date.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 14/05/2025.
//

import Foundation

extension Date {
    
    /// convert date to formatted string
    func toString(_ format: DateFormat) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
    }
}
