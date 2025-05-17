//
//  ImageCacheServiceTests.swift
//  GithubClientTests
//
//  Created by Aung Htoo Myat Khaing on 17/05/2025.
//

import XCTest
@testable import GithubClient

final class ImageCacheServiceTests: XCTestCase {
    
    private var sut: ImageCacheService!
    
    override func setUpWithError() throws {
        sut = ImageCacheService()
    }
    
    override func tearDownWithError() throws {
        sut.clear()
        sut = nil
    }
    
    func test_set_and_get_UIImage() throws {
        // Given
        let testImage = UIImage(systemName: "star.fill")!
        let key = "test_key"
        
        // When
        sut.setImage(testImage, forKey: key)
        let retrievedImage = sut.uiImage(forKey: key)
        
        // Then
        XCTAssertNotNil(retrievedImage)
        XCTAssertEqual(retrievedImage?.pngData(), testImage.pngData())
    }
    
    func test_set_and_get_SwiftUIImage() throws {
        // Given
        let testImage = UIImage(systemName: "star.fill")!
        let key = "test_key"
        
        // When
        sut.setImage(testImage, forKey: key)
        let retrievedImage = sut.image(forKey: key)
        
        // Then
        XCTAssertNotNil(retrievedImage)
    }
    
    func test_remove_image() throws {
        // Given
        let testImage = UIImage(systemName: "star.fill")!
        let key = "test_key"
        sut.setImage(testImage, forKey: key)
        
        // When
        sut.removeImage(forKey: key)
        
        // Then
        XCTAssertNil(sut.uiImage(forKey: key))
        XCTAssertNil(sut.image(forKey: key))
    }
    
    func test_clear_cache() throws {
        // Given
        let testImage1 = UIImage(systemName: "star.fill")!
        let testImage2 = UIImage(systemName: "heart.fill")!
        sut.setImage(testImage1, forKey: "key1")
        sut.setImage(testImage2, forKey: "key2")
        
        // When
        sut.clear()
        
        // Then
        XCTAssertNil(sut.uiImage(forKey: "key1"))
        XCTAssertNil(sut.uiImage(forKey: "key2"))
    }
    
    func test_memory_cache_limit() throws {
        // Given
        let largeImage = createLargeImage()
        let key = "large_image"
        
        // When
        sut.setImage(largeImage, forKey: key)
        
        // Then
        // The image should still be retrievable from disk even if it's evicted from memory cache
        XCTAssertNotNil(sut.uiImage(forKey: key))
    }
    
    // MARK: - Helper Methods
    
    private func createLargeImage() -> UIImage {
        let size = CGSize(width: 1000, height: 1000)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            UIColor.red.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
}
