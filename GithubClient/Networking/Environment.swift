//
//  Environment.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 13/05/2025.
//

import Foundation

enum Environment {
    case live
    case mock
}

class AppEnvironment {
    let environment: Environment
    let network: Networkable
    let secret: Secretable
    let imageCache: ImageCacheServiceable
    
    init(environment: Environment, network: Networkable, secret: Secretable, imageCache: ImageCacheServiceable) {
        self.environment = environment
        self.network = network
        self.secret = secret
        self.imageCache = imageCache
    }
    
    lazy var githubService: GithubService = {
        .init(networkService: network)
    }()
}

extension Environment {
    var baseURL: String {
        switch self {
        case .live:
            return "api.github.com"
        case .mock:
            return "localhost:8080"
        }
    }
    
    var appEnvironment: AppEnvironment {
        switch self {
        case .live:
            return .init(
                environment: .live,
                network: NetworkService(environment: .live),
                secret: ConfigLoaderService(),
                imageCache: ImageCacheService()
            )
            
        case .mock:
            return .init(
                environment: .mock,
                network: MockNetworkService(),
                secret: ConfigLoaderService(),
                imageCache: ImageCacheService()
            )
        }
    }
}
