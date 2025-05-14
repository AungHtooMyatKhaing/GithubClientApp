//
//  UserListCell.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 14/05/2025.
//

import SwiftUI

struct UserListCell: View {
    
    let imageUrl: String?
    let userName: String?
    
    var body: some View {
        HStack(spacing: 15) {
            ImageLoader(url: imageUrl?.url, size: 55) {
                Image(systemName: "person.crop.circle")
                    .resizable()
            }
            .clipShape(Circle())
            .overlay {
                Circle()
                    .stroke(.lightGray, lineWidth: 2)
            }
            
            if let userName {
                Text(userName)
                    .font(.body)
                    .foregroundColor(.dark)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Spacer()
            }
        }
        .frame(height: 70)
        .padding(.horizontal, 20)
    }
}

#Preview {
    UserListCell(
        imageUrl: "https://avatars.githubusercontent.com/u/65956?v=4",
        userName: "User Name"
    )
}
