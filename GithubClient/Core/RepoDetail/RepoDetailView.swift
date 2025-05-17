//
//  RepoDetailView.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 17/05/2025.
//

import SwiftUI

struct RepoDetailView: View {
    
    let title: String?
    let url: String?
    
    @State private var isLoading: Bool = true
    
    init(tilte: String? = nil, url: String? = nil) {
        self.title = tilte
        self.url = url
    }
    
    var body: some View {
        ZStack {
            Color.light.ignoresSafeArea()
            
            VStack {
                CustomNavView(
                    title: title,
                    rightIcon: "safari",
                    rightAction: openLinkInSafari
                )
                
                if let url = url?.url {
                    WebView(url: url, isLoading: $isLoading)
                        .ignoresSafeArea()
                        .background(.light)
                }
            }
            
            if isLoading {
                ProgressView()
                    .tint(.dark)
            }
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
    }
}

#Preview {
    RepoDetailView(url: "https://www.google.com")
}

extension RepoDetailView {
    
    private func openLinkInSafari() {
        guard let url = url?.url, UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
}
