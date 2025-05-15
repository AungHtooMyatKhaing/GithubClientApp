//
//  ImageCacheService.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 15/05/2025.
//

import Foundation
import SwiftUI
import UIKit

protocol ImageCacheServiceable {
    func uiImage(forKey key: String) -> UIImage?
    func image(forKey key: String) -> Image?
    func setImage(_ image: UIImage, forKey key: String)
    func removeImage(forKey key: String)
    func clear()
}

final class ImageCacheService: ImageCacheServiceable {
    
    private let memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private var diskCacheURL: URL? = nil
    
    init() {
        memoryCache.countLimit = 100
        memoryCache.totalCostLimit = 50 * 1024 * 1024
        
        if let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
            diskCacheURL = cacheDirectory.appendingPathComponent("ImageCache", isDirectory: true)
            
            // Create folder if needed
            guard let diskCacheURL else { return }
            if !fileManager.fileExists(atPath: diskCacheURL.path) {
                try? fileManager.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
            }
        }
    }
    
    /// load UIKit UIImage by key
    func uiImage(forKey key: String) -> UIImage? {
        if let image = memoryCache.object(forKey: key as NSString) {
            return image
        }
        
        guard let diskCacheURL else { return nil }
        let diskURL = diskCacheURL.appendingPathComponent(safeFileName(for: key))
        
        if let data = try? Data(contentsOf: diskURL),
           let image = UIImage(data: data) {
            memoryCache.setObject(image, forKey: key as NSString)
            return image
        }
        
        return nil
    }
    
    /// load SwiftUI Image by key
    func image(forKey key: String) -> Image? {
        guard let uiImage = uiImage(forKey: key) else { return nil }
        return Image(uiImage: uiImage)
    }
    
    /// save image cache by given key
    func setImage(_ image: UIImage, forKey key: String) {
        let cost = image.jpegData(compressionQuality: 1.0)?.count ?? 0
        memoryCache.setObject(image, forKey: key as NSString, cost: cost)
        
        // Write to disk
        guard let diskCacheURL else { return }
        let diskURL = diskCacheURL.appendingPathComponent(safeFileName(for: key))
        
        if let data = image.jpegData(compressionQuality: 0.9) {
            try? data.write(to: diskURL, options: .atomic)
        }
    }
    
    /// delete image cache by key
    func removeImage(forKey key: String) {
        memoryCache.removeObject(forKey: key as NSString)
        guard let diskCacheURL else { return }
        let diskURL = diskCacheURL.appendingPathComponent(safeFileName(for: key))
        
        try? fileManager.removeItem(at: diskURL)
    }
    
    /// clear all cache (both memory & disk)
    func clear() {
        memoryCache.removeAllObjects()
        guard let diskCacheURL else { return }
        try? fileManager.removeItem(at: diskCacheURL)
        try? fileManager.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
    }
    
    private func safeFileName(for key: String) -> String {
        return key.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? UUID().uuidString
    }
}
