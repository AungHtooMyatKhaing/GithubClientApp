//
//  UserDetailHeaderView.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 15/05/2025.
//

import SwiftUI

struct UserDetailHeaderViewModel {
    let imageUrl: String?
    let name: String?
    let userName: String?
    let followers: Int
    let following: Int
    let bio: String?
    let company: String?
    let location: String?
    let email: String?
    let githubProfileLink: String?
    
    init(imageUrl: String?, name: String?, userName: String?, followers: Int, following: Int, bio: String?, company: String?, location: String?, email: String?, githubProfileLink: String?) {
        self.imageUrl = imageUrl
        self.name = name
        self.userName = userName
        self.followers = followers
        self.following = following
        self.bio = bio
        self.company = company
        self.location = location
        self.email = email
        self.githubProfileLink = githubProfileLink
    }
    
    init(data: User) {
        self.imageUrl = data.avatarUrl
        self.name = data.name
        self.userName = data.userName
        self.followers = data.followers ?? 0
        self.following = data.following ?? 0
        self.bio = data.bio?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.company = data.company
        self.location = data.location
        self.email = data.email
        self.githubProfileLink = data.htmlUrl
    }
}

struct UserDetailHeaderView: View {
    
    let viewModel: UserDetailHeaderViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 17) {
            HStack(alignment: .center, spacing: 20) {
                profileImage
                profileInfo
            }
                
            VStack(alignment: .leading, spacing: 4) {
                generalInfo
            }
            
            LineDivider()
        }
        .padding(.top)
    }
}

#Preview {
    ZStack {
        Color.light.ignoresSafeArea()
        UserDetailHeaderView(viewModel: .init(data: MockData.user2))
    }
}

extension UserDetailHeaderView {

    private var profileImage: some View {
        ImageLoader(
            url: viewModel.imageUrl?.url,
            size: 80
        ) {
            Image(systemName: "person.crop.circle")
                .resizable()
        }
        .clipShape(Circle())
        .overlay {
            Circle()
                .stroke(.softGray, lineWidth: 2)
        }
    }
    
    private var profileInfo: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let name = viewModel.name {
                Text(name)
                    .font(.poppinsSemiBold(size: 21))
                    .foregroundStyle(.dark)
            }
            
            if let userName = viewModel.userName {
                Text(userName)
                    .font(.poppinsSemiBold(size: 15))
                    .foregroundStyle(.softGray)
            }
            
            (
                Text(viewModel.followers.abbreviated) +
                Text(" followers,")
                    .font(.poppinsRegular(size: 15))
                    .foregroundStyle(.softGray) +
                Text(" \(viewModel.following.abbreviated)") +
                Text(" following")
                    .font(.poppinsRegular(size: 15))
                    .foregroundStyle(.softGray)
            )
            .font(.poppinsSemiBold(size: 15))
            .foregroundStyle(.dark)
            .padding(.vertical, 5)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var generalInfo: some View {
        Group {
            if let bio = viewModel.bio {
                Text(bio)
                    .font(.poppinsMedium(size: 14))
                    .padding(.bottom, 13)
            }
            
            if let company = viewModel.company {
                infoView(imageName: "building.2", value: company)
            }
            
            if let location = viewModel.location {
                infoView(imageName: "mappin.circle", value: location)
            }
            
            if let email = viewModel.email {
                infoView(imageName: "envelope", value: email)
            }
            
            if let github = viewModel.githubProfileLink {
                infoView(imageName: "link", value: github)
            }
            
        }
        .font(.poppinsRegular(size: 14))
        .foregroundStyle(.dark)
    }
    
    private func infoView(imageName: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.softGray)
                .frame(width: 15, height: 15)
                .padding(.top, 2.6)
            
            Text(value)
        }
    }
}
