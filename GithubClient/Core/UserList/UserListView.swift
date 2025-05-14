//
//  UserListView.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 14/05/2025.
//

import SwiftUI

struct UserListView: View {
    
    @ObservedObject var viewModel: UserListViewModel
    @State private var showLoadMore: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.light.ignoresSafeArea()
                
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.users, id: \.id) { user in
                            UserListCell(
                                imageUrl: user.avatarUrl,
                                userName: user.userName
                            )
                            .onAppear {
                                loadMoreIfNeeded(id: user.id)
                            }
                        }
                        
                        if showLoadMore {
                            LoadMoreView()
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                        }
                    }
                }
                
                if viewModel.isEmpty {
                    EmptySearchView()
                }
                
            }
            .searchable(
                text: $viewModel.search,
                prompt: "Search by github user name"
            )
            .refreshable {
                viewModel.refresh()
            }
            .navigationTitle("Users")
        }
    }
    
    private func loadMoreIfNeeded(id: Int?) {
        // load more will only show
        // - it is last item
        // - not already loading
        // - and has next page
        guard viewModel.isLastItem(id: id), !viewModel.isLoading, viewModel.hasNextPage else {
            guard showLoadMore, !viewModel.isLoading else { return }
            showLoadMore = false
            return
        }
        showLoadMore = true
        viewModel.nextPage()
    }
}

#Preview {
    UserListView(viewModel: .init(service: env.githubService))
}
