//
//  ImageLoaderService.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 15/05/2025.
//

import SwiftUI

@MainActor
protocol ImageLoaderServiceable: ObservableObject {
    var image: Image? { get }
    
    func load(from urlString: String)
}

@MainActor
public class ImageLoaderService: ImageLoaderServiceable {
    
    @Published var image: Image?
    
    private var imageCache: ImageCacheServiceable
    
    init(imageCache: ImageCacheServiceable) {
        self.imageCache = imageCache
    }
    
    func load(from urlString: String) {
        // check cache
        if let cached = imageCache.image(forKey: urlString) {
            self.image = cached
            return
        }
        
        // load from network
        guard let url = urlString.url else { return }
        
        Task {
            do {
                // download image data
                let (data, _) = try await URLSession.shared.data(from: url)
                if let downloaded = UIImage(data: data) {
                    // save to cache using urlString as key for cache
                    imageCache.setImage(downloaded, forKey: urlString)
                    self.image = Image(uiImage: downloaded)
                }
            } catch {
                print("Failed to load image:", error)
            }
        }
    }
    
    deinit {
        print("deinit: ImageLoaderService")
    }
}
