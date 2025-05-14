//
//  Endpoint.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 13/05/2025.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case put = "PUT"
    case delete = "DELETE"
    case head = "HEAD"
}

enum Endpoint {
    case users(Encodable)
    case userDetail(userName: String)
    case userRepos(userName: String, Encodable)
    case searchUsers(Encodable)
    case searchRepos(Encodable)
}

extension Endpoint {
    var path: String {
        switch self {
        case .users:
            return "/users"
        case .userDetail(let userName):
            return "/users/\(userName)"
        case .userRepos(let userName, _):
            return "/users/\(userName)/repos"
        case .searchUsers:
            return "/search/users"
        case .searchRepos:
            return "/search/repositories"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .users, .userDetail, .userRepos, .searchUsers, .searchRepos:
            return .get
        }
    }
    
    var body: Encodable? {
        // nil because current endpoints aren't using body request
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .users(let request):
            return request.queryItems()
        case .userDetail:
            return nil
        case .userRepos(_, let request):
            return request.queryItems()
        case .searchUsers(let request):
            return request.queryItems()
        case .searchRepos(let request):
            return request.queryItems()
        }
    }
    
    func headers(appEnvironment: AppEnvironment) -> [String: String]? {
        if let accessToken = appEnvironment.secret.get(key: .accessToken) {
            return [
                "Authorization": "Bearer \(accessToken)",
                "Accept": "application/vnd.github+json"
            ]
        } else {
            return [
                "Accept": "application/vnd.github+json"
            ]
        }
    }
    
    func url(appEnvironment: AppEnvironment) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = appEnvironment.environment.baseURL
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }
    
    func urlRequest(appEnvironment: AppEnvironment) -> URLRequest? {
        guard let url = url(appEnvironment: appEnvironment) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers(appEnvironment: appEnvironment)
        
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        return request
    }
}
