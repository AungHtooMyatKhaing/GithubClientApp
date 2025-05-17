//
//  View.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 16/05/2025.
//

import SwiftUI

extension View {
    func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
    
    func trackScrollY(_ onChange: @escaping (CGFloat) -> Void) -> some View {
        self.background(
            GeometryReader { proxy in
                Color.clear
                    .preference(
                        key: ScrollOffsetPreferenceKey.self,
                        value: proxy.frame(in: .global).minY
                    )
            }
                .onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: onChange)
        )
    }
    
    func onFirstAppear(_ perform: @escaping () -> Void) -> some View {
        self.modifier(OnFirstAppearModifier(action: perform))
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct OnFirstAppearModifier: ViewModifier {
    @State private var hasAppeared = false
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                guard !hasAppeared else { return }
                hasAppeared = true
                action()
            }
    }
}
