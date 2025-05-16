//
//  LineDivider.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 16/05/2025.
//

import SwiftUI

struct LineDivider: View {
    var body: some View {
        Rectangle()
            .fill(.softGray.opacity(0.4))
            .frame(height: 0.5)
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    LineDivider()
}
