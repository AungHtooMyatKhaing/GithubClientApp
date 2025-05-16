//
//  Int.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 15/05/2025.
//

extension Int {
    var string: String {
        return String(describing: self)
    }
    
    var abbreviated: String {
        let num = Double(self)
        let thousand = num / 1_000
        let million = num / 1_000_000

        if million >= 1.0 {
            return String(format: "%.1fm", million)
        } else if thousand >= 1.0 {
            return String(format: "%.1fk", thousand)
        } else {
            return self.string
        }
    }
}
