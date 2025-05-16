//
//  FilterOptionView.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 16/05/2025.
//

import SwiftUI

struct FilterOptionView: View {
    
    @SwiftUI.Environment(\.dismiss) private var dismiss
    @Binding var selected: SortBy
    let sortBy: [SortBy] = [.updated, .stars]
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavView(title: "Sort by", hideDivider: true, leftIcon: "xmark")
                .frame(height: 70)

            ForEach(sortBy, id: \.self) { item in
                HStack {
                    Text(item.title)
                        .foregroundStyle(.dark)
                        .font(.poppinsRegular(size: 17))
                    Spacer()

                    if item == selected {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.blue)
                    }
                }
                .background(.light.opacity(0.001))
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .onTapGesture {
                    selected = item
                    dismiss()
                }
            }
            Spacer()
        }
    }
}

#Preview {
    FilterOptionView(selected: .constant(.updated))
}
