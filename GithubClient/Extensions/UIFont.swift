//
//  UIFont.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 15/05/2025.
//

import UIKit

extension UIFont {
    
    static func poppinsBold(size: CGFloat) -> UIFont {
        UIFont(name: CustomFonts.poppinsBold.rawValue, size: size) ?? .systemFont(ofSize: size)
    }
    
    static func poppinsMedium(size: CGFloat) -> UIFont {
        UIFont(name: CustomFonts.poppinsMedium.rawValue, size: size) ?? .systemFont(ofSize: size)
    }
}
