//
//  RepoListCell.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 16/05/2025.
//

import SwiftUI

struct RepoListCellViewModel {
    let id: Int?
    let name: String?
    let desc: String?
    let language: String?
    let starCount: Int
    let updatedAt: Date?
    let githubLink: String?
    
    init(id: Int?, name: String?, desc: String?, language: String?, starCount: Int, updatedAt: Date?, githubLink: String?) {
        self.id = id
        self.name = name
        self.desc = desc
        self.language = language
        self.starCount = starCount
        self.updatedAt = updatedAt
        self.githubLink = githubLink
    }
    
    init(data: Repository) {
        self.id = data.id
        self.name = data.name
        self.desc = data.description
        self.language = data.language
        self.starCount = data.stargazersCount ?? 0
        self.updatedAt = data.updatedDate
        self.githubLink = data.htmlUrl
    }
}

struct RepoListCell: View {
    
    let viewModel: RepoListCellViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            repoName
            repoDescription
            repoInfo
            LineDivider()
        }
        .padding(.vertical, 6)
        .foregroundStyle(.softGray)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ZStack {
        Color.light.ignoresSafeArea()
        RepoListCell(viewModel: .init(data: MockData.repo1))
    }
}

extension RepoListCell {
    private var repoName: AnyView {
        if let name = viewModel.name {
            Text(name)
                .font(.poppinsSemiBold(size: 17))
                .foregroundStyle(.blue)
                .eraseToAnyView()
        } else {
            EmptyView()
                .eraseToAnyView()
        }
    }
    
    private var repoDescription: AnyView {
        if let desc = viewModel.desc {
            Text(desc)
                .font(.poppinsRegular(size: 14))
                .lineLimit(3)
                .eraseToAnyView()
        } else {
            EmptyView()
                .eraseToAnyView()
        }
    }
    
    private var repoInfo: some View {
        HStack(alignment: .center, spacing: 15) {
            if let language = viewModel.language {
                Text(language)
                    .foregroundStyle(.blue)
                    .font(.poppinsSemiBold(size: 14))
                    .padding(.horizontal, 7)
                    .padding(.vertical, 2)
                    .background(
                        Capsule()
                            .stroke(lineWidth: 1)
                            .fill(.blue)
                    )
            }
            
            HStack(alignment: .center, spacing: 5) {
                Image(systemName: "star")
                    .resizable()
                    .bold()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.softGray)
                    .frame(width: 15, height: 15)
                    .padding(.bottom, 2)
                
                Text("\(viewModel.starCount.abbreviated)")
                    .font(.poppinsRegular(size: 14))
            }
            
            Spacer(minLength: 0)
            
            if let date = viewModel.updatedAt?.toString(.mmmdyyyy) {
                Text("Updated: \(date)")
                    .font(.poppinsRegular(size: 14))
            }
        }
    }
}
