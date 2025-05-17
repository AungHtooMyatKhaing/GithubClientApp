//
//  UserListView.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 14/05/2025.
//

import SwiftUI

struct UserListView: View {
    
    @StateObject var viewModel: UserListViewModel
    @State private var showLoadMore: Bool = false
    @State private var selectedUser: String? = nil
    @FocusState var focusField: FocusField?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.light.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    navView
                    searchView
                    userList
                }
                
                if viewModel.isEmpty {
                    NoResultsView(type: .searchNoUser)
                }
            }
            .refreshable {
                viewModel.refresh()
            }
            .onFirstAppear {
                viewModel.fetchUsers()
            }
            .toolbarVisibility(.hidden, for: .navigationBar)
            .navigationDestination(item: $selectedUser) { user in
                UserDetailView(
                    viewModel: .init(
                        userName: user,
                        service: env.githubService
                    )
                )
            }
            .alert("Oops!", isPresented: .constant(viewModel.error != nil)) {
                Button("OK") {
                    viewModel.error = nil
                }
            } message: {
                if let error = viewModel.error {
                    Text(error)
                }
            }
        }
    }
}

#Preview {
    UserListView(viewModel: .init(service: env.githubService))
}

extension UserListView {
    private var navView: some View {
        CustomNavView(
            title: "Users",
            hideDivider: true,
            leftIcon: nil
        )
    }
    
    private var searchView: some View {
        CustomTextField(
            text: $viewModel.search,
            placeHolder: "Search by github user name",
            focusField: .search,
            focusedField: $focusField,
            rightIcon: viewModel.search != "" ? "xmark" : "magnifyingglass",
            rightAction: {
                if viewModel.search != "" {
                    focusField = nil
                    viewModel.search = ""
                } else {
                    focusField = .search
                }
            }
        )
        .accessibilityIdentifier("SearchTextField")
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
    
    private var userList: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.users, id: \.id) { user in
                    UserListCell(
                        imageUrl: user.avatarUrl,
                        userName: user.userName
                    )
                    .onTapGesture {
                        selectedUser = user.userName
                    }
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
            .trackScrollY { _ in
                // dismiss keyboard when user is scrolling
                focusField = nil
            }
        }
    }
    
    private func loadMoreIfNeeded(id: Int?) {
        // load more will only show
        // - it is last item
        // - haven't already loading
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
