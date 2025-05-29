//
//  UserDetailView.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 15/05/2025.
//

import SwiftUI

struct UserDetailView: View {
    
    @StateObject var viewModel: UserDetailViewModel
    @State private var showLoadMore: Bool = false
//    @State private var showFilter: Bool = false
//    @State private var selectedUrl: String? = nil
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        ZStack {
            Color.light.ignoresSafeArea()
            
            ScrollView {
                LazyVStack {
                    if let detail = viewModel.detail {
                        UserDetailHeaderView(viewModel: detail, onTapUrl: { url in
//                            selectedUrl = url
                            coordinator.routeToRepoDetail(url: url)
                        }).padding(.top, 35)
                    }
                    
                    if viewModel.repos.count > 0 {
                        repoHeaderView
                    }
                    
                    if viewModel.isEmpty {
                        NoResultsView(type: .noRepo)
                            .frame(height: 300)
                    }
                    
                    ForEach(viewModel.repos, id: \.id) { repo in
                        RepoListCell(viewModel: repo)
                            .onTapGesture {
//                                selectedUrl = repo.githubLink
                                coordinator.routeToRepoDetail(url: repo.githubLink)
                            }
                            .onAppear {
                                loadMoreIfNeeded(id: repo.id)
                            }
                    }
                    
                    if showLoadMore {
                        LoadMoreView()
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    }
                    
                }
                .padding(.horizontal, 20)
            }
            
            VStack {
                CustomNavView(title: viewModel.detail?.name)
                Spacer()
            }
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
//        .sheet(isPresented: $showFilter) {
//            FilterOptionView(selected: $viewModel.sortBy)
//                .presentationDetents([.height(180)])
//        }
//        .navigationDestination(item: $selectedUrl) { url in
//            RepoDetailView(url: url)
//        }
        .onFirstAppear {
            viewModel.fetchDetail()
        }
//        .alert("Oops!", isPresented: .constant(viewModel.error != nil)) {
//            Button("OK") {
//                viewModel.error = nil
//            }
//        } message: {
//            if let error = viewModel.error {
//                Text(error)
//            }
//        }
        .onChange(of: viewModel.error) { _, newValue in
            coordinator.showAlert(message: .init(message: newValue))
        }
    }
}

#Preview {
    @Previewable @StateObject var appCoordinator = AppCoordinator()
    
    NavigationStack(path: $appCoordinator.path) {
        UserDetailView(viewModel: .init(userName: "achille-roussel", service: env.githubService))
    }
    .environmentObject(appCoordinator)
}

extension UserDetailView {
    
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
    
    private var repoHeaderView: some View {
        HStack(alignment: .center) {
            Text("Repositories")
                .font(.poppinsMedium(size: 18))
                .foregroundStyle(.dark)
                
            Spacer()
            
            sortOptionsView
        }
        .padding(.top)
    }
    
    private var sortOptionsView: some View {
        HStack {
            Text("Sort:")
                .font(.poppinsRegular(size: 14))
                .foregroundStyle(.dark)
            
            HStack(spacing: 7) {
                Text(viewModel.sortBy.title)
                    .font(.poppinsRegular(size: 13))
                    .foregroundStyle(.blue)
                    
                Image(systemName: "chevron.down")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 7, height: 7)
                    .foregroundStyle(.blue)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .overlay {
                RoundedRectangle(cornerRadius: 3)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(.blue)
            }
            .onTapGesture {
                toggleSortBy()
            }
            
            Button {
                toggleOrderBy()
            } label: {
                Image(systemName: viewModel.orderBy.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 10, height: 10)
                    .foregroundStyle(.blue)
                    .padding(9)
                    .overlay {
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(lineWidth: 1)
                            .foregroundStyle(.blue)
                    }
            }
        }
    }
    
    private func toggleSortBy() {
//        showFilter = true
        coordinator.routeToFileOptions(sort: $viewModel.sortBy)
    }
    
    private func toggleOrderBy() {
        if viewModel.orderBy == .asc {
            viewModel.orderBy = .desc
        } else {
            viewModel.orderBy = .asc
        }
    }
}
