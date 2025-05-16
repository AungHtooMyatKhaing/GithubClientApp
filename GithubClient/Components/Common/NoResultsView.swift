//
//  NoResultsView.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 14/05/2025.
//

import SwiftUI

enum NoResultsType {
    case searchNoUser
    case searchNoRepo
    case noRepo
}

extension NoResultsType {
    var imageName: String {
        switch self {
        case .searchNoUser:
            return "exclamationmark.magnifyingglass"
        case .searchNoRepo:
            return "exclamationmark.magnifyingglass"
        case .noRepo:
            return "folder.badge.questionmark"
        }
    }
    
    var message: String {
        switch self {
        case .searchNoUser:
            return "No data found!"
        case .searchNoRepo:
            return "No data found!"
        case .noRepo:
            return "No repository to display!"
        }
    }
}

struct NoResultsView: View {
    
    let type: NoResultsType
    
    var body: some View {
        VStack {
            Image(systemName: type.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .foregroundColor(.softGray)
         
            Text(type.message)
                .font(.title3)
                .foregroundColor(.softGray)
        }
    }
}

#Preview {
    NoResultsView(type: .noRepo)
}
