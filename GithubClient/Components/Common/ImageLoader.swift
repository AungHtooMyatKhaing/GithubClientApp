//
//  ImageLoader.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 14/05/2025.
//

import SwiftUI

struct ImageLoader<PlaceholderContent: View>: View {
    private let url: URL?
    private let size: CGFloat?
    private let placeholder: PlaceholderContent?
    @StateObject private var loader: ImageLoaderService
    
    init(
        imageCache: ImageCacheServiceable = env.imageCache,
        url: URL?,
        size: CGFloat? = nil,
        @ViewBuilder placeholder: () -> PlaceholderContent
    ) {
        self._loader = .init(wrappedValue: .init(imageCache: imageCache))
        self.url = url
        self.size = size
        self.placeholder = placeholder()
    }
    
    var body: some View {
        Group {
            if let image = loader.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
            } else {
                placeholder?
                    .frame(width: size, height: size)
            }
        }
        .onAppear {
            if let urlString = url?.absoluteString {
                loader.load(from: urlString)
            }
        }
        
//        AsyncImage(url: url) { image in
//            image
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(width: size, height: size)
//        } placeholder: {
//            placeholder?
//                .frame(width: size, height: size)
//        }
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
