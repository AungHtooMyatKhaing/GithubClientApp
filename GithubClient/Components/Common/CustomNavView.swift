//
//  CustomNavView.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 16/05/2025.
//

import SwiftUI

struct CustomNavView: View {
    
    @SwiftUI.Environment(\.dismiss) private var dismiss
    
    var title: String? = nil
    var backgroundColor: Color? = .light
    var hideDivider: Bool = false
    var leftIcon: String? = "chevron.left"
    var leftAction: (() -> Void)? = nil
    var rightIcon: String? = nil
    var rightAction: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            backgroundColor?.ignoresSafeArea()
            
            HStack {
                // left action
                Button {
                    // action
                    if let leftAction {
                        leftAction()
                    } else {
                        dismiss()
                    }
                } label: {
                    if let leftIcon {
                        Image(systemName: leftIcon)
                            .font(.system(size: 20))
                    }
                }
                .frame(width: 45, height: 45)
                .padding(.leading, 8)
                
                Spacer()
                
                // title
                Text(title.orEmpty)
                    .font(.poppinsMedium(size: 18))
                
                Spacer()
                
                // right action
                Button {
                    // action
                    rightAction?()
                } label: {
                    if let rightIcon {
                        Image(systemName: rightIcon)
                            .font(.system(size: 20))
                    }
                }
                .frame(width: 45, height: 45)
                .padding(.trailing, 8)
            }
            .background(alignment: .bottom) {
                LineDivider()
                    .opacity(hideDivider ? 0 : 0.4)
            }
        }
        .foregroundStyle(.dark)
        .frame(maxWidth: .infinity)
        .frame(height: 42)
    }
}

#Preview {
    CustomNavView()
}
