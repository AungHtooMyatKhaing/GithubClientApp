//
//  ImageLoader.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 14/05/2025.
//

import SwiftUI

struct ImageLoader<PlaceholderContent: View>: View {
    let url: URL?
    let size: CGFloat?
    let placeholder: PlaceholderContent?
    
    init(url: URL?, size: CGFloat? = nil, @ViewBuilder placeholder: () -> PlaceholderContent) {
        self.url = url
        self.size = size
        self.placeholder = placeholder()
    }
    
    var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
        } placeholder: {
            placeholder?
                .frame(width: size, height: size)
        }
    }
}

#Preview {
    ZStack {
        ImageLoader(url: .init(string: "https://avatars.githubusercontent.com/u/65956?v=4"), size: 100) {
            Image(systemName: "person.crop.circle")
                .resizable()
        }
    }
}
