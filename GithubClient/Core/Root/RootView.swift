//
//  RootView.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 22/05/2025.
//

import SwiftUI

struct RootView: View {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            UserListView(viewModel: .init(service: env.githubService))
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .userList:
                        UserListView(viewModel: .init(service: env.githubService))
                    case .userDetail(let userName):
                        UserDetailView(viewModel: .init(userName: userName.orEmpty, service: env.githubService))
                    case .repoDetail(let title, let url):
                        RepoDetailView(tilte: title, url: url)
                    }
                }
        }
        .sheet(item: $coordinator.presentedModal) { modal in
            switch modal {
            case .filerOptions(let sort):
                FilterOptionView(selected: sort)
                    .presentationDetents([.height(180)])
            }
        }
        .alert(item: $coordinator.presentedAlert) { alert in
            Alert(
                title: Text(alert.title ?? "Oops!"),
                message: Text(alert.message.orEmpty),
                dismissButton: .default(Text("OK"))
            )
        }
        .environmentObject(coordinator)
    }
}

#Preview {
    RootView()
}
