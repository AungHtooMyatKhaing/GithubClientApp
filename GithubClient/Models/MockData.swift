//
//  MockData.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 15/05/2025.
//

final class MockData {
    static var user1: User {
        .init(
            userName: "achille-roussel",
            id: 0,
            nodeId: "node_0",
            avatarUrl: "https://avatars.githubusercontent.com/u/865510?v=4",
            htmlUrl: "https://github.com/achille-roussel",
            type: "User",
            userViewType: "public",
            name: "Achille",
            company: "Firetiger",
            blog: "",
            location: "San Francisco",
            email: "achille@firetiger.com",
            bio: "Gold dusted all we drank and ate\r\n",
            followers: 243,
            following: 47
        )
    }
    
    static var user2: User {
        .init(
            userName: "achille-roussel-2",
            id: 1,
            nodeId: "node_1",
            avatarUrl: "https://avatars.githubusercontent.com/u/865510?v=4",
            htmlUrl: "https://github.com/achille-roussel-long-long-looooooong12232-123123ADFadf",
            type: "User",
            userViewType: "public",
            name: "Achille Long Long Long Name ADS",
            company: "Firetiger",
            blog: "",
            location: "San Francisco. This is the location with long text. This is the location with long text.",
            email: "achille@firetiger.com",
            bio: "Gold dusted all we drank and ate. This is the bio with long text. This is the bio with long text. This is the bio with long text.",
            followers: 243,
            following: 47
        )
    }
    
    static var repo1: Repository {
        .init(
            id: 1,
            nodeId: "repo_1",
            name: "sqlrange",
            fullName: "achille-roussel/sqlrange",
            isPrivate: false,
            owner: MockData.user1,
            htmlUrl: "https://github.com/achille-roussel/sqlrange",
            description: "Go 1.23 range functions with database/sql",
            fork: false,
            url: "https://api.github.com/repos/achille-roussel/sqlrange",
            stargazersCount: 146,
            watchersCount: 146,
            language: "Ruby-on-rails",
            forksCount: 4,
            license: nil,
            createdAt: "2024-01-13T00:58:45Z",
            updatedAt: "2025-04-16T12:32:58Z"
        )
    }
    
    static var repo2: Repository {
        .init(
            id: 2,
            nodeId: "repo_2",
            name: "WasmEdge",
            fullName: "achille-roussel/WasmEdge",
            isPrivate: false,
            owner: MockData.user2,
            htmlUrl: "https://github.com/achille-roussel/WasmEdge",
            description:"WasmEdge is a lightweight, high-performance, and extensible WebAssembly runtime for cloud native, edge, and decentralized applications. It powers serverless apps, embedded functions, microservices.",
            fork: false,
            url: "https://api.github.com/achille-roussel/WasmEdge",
            stargazersCount: 9563,
            watchersCount: 106,
            language: "C++",
            forksCount: 820,
            license: nil,
            createdAt: "2020-01-13T00:58:45Z",
            updatedAt: "2025-09-04T12:32:58Z"
        )
    }
}
