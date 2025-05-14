//
//  EmptySearchView.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 14/05/2025.
//

import SwiftUI

struct EmptySearchView: View {
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.magnifyingglass")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.lightGray)
         
            Text("No data found!")
                .font(.title3)
                .foregroundColor(.lightGray)
        }
    }
}

#Preview {
    EmptySearchView()
}
