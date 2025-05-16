//
//  CustomTextField.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 16/05/2025.
//

import SwiftUI

enum FocusField: Hashable {
    case search
}

struct CustomTextField: View {
    
    @Binding var text: String
    var placeHolder: String?
//    var keyboardType: UIKeyboardType = .default
    var focusField: FocusField?
    @FocusState.Binding var focusedField: FocusField?
    var multilineTextAlignment: TextAlignment = .leading
    var maxLength: Int?
    var maxLengthReached: ((FocusField?) -> Void)?
    var rightIcon: String?
    var rightAction: (() -> Void)?
    @State private var borderColor: Color = .clear
    
    var body: some View {
        HStack(spacing: 3) {
            
            TextField(
                "",
                text: $text,
                prompt: Text(placeHolder ?? "")
                    .foregroundStyle(.softGray.opacity(0.5))
            )
                .multilineTextAlignment(multilineTextAlignment)
                .font(.poppinsRegular(size: 15))
                .foregroundStyle(.softGray)
                .frame(height: 43)
                .padding(.leading, multilineTextAlignment == .center ? 0 : 12)
//                .keyboardType(keyboardType)
                .focused($focusedField, equals: focusField)
                .onChange(of: focusedField) { _, _ in
                    isFocused()
                }
                .onChange(of: text, { _, newValue in
                    isValidMaxLength(newValue: newValue)
                })
                .tint(.softGray)
             
            if let rightIcon {
                Button {
                    rightAction?()
                } label: {
                    Image(systemName: rightIcon)
                        .foregroundStyle(.softGray.opacity(0.5))
                        .frame(width: 40, height: 20)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(.dark.opacity(0.1))
                .stroke(borderColor, style: .init(lineWidth: 1))
        )
    }
    
    private func isFocused() {
        withAnimation(.easeInOut) {
            borderColor = focusedField == focusField ? .white : .clear
        }
    }
    
    private func isValid() {
        
    }
    
    private func isValidMaxLength(newValue: String) {
        if let maxLength = maxLength {
            text = String(newValue.prefix(maxLength))
            maxLengthReached?(focusField)
        }
    }
}

#Preview {
    @Previewable @State var text: String = ""
    @FocusState var focusField: FocusField?
    
    ZStack {
        Color.light.ignoresSafeArea()
        
        CustomTextField(
            text: $text,
            placeHolder: "Search",
            focusField: .search,
            focusedField: $focusField,
            rightIcon: "magnifyingglass"
        )
        .frame(width: 190)
    }
}
