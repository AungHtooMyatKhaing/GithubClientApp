//
//  GithubClientApp.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 13/05/2025.
//

import SwiftUI

let env = Environment.live.appEnvironment

@main
struct GithubClientApp: App {
    
    var body: some Scene {
        WindowGroup {
            UserListView(viewModel: .init(service: env.githubService))
        }
    }
}
