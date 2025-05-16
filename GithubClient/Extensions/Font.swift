//
//  Font.swift
//  GithubClient
//
//  Created by Aung Htoo Myat Khaing on 15/05/2025.
//

import SwiftUI

enum CustomFonts: String {
    case poppinsBold = "Poppins Bold"
    case poppinsBoldItalic = "Poppins Bold Italic"
    case poppinsItalic = "Poppins Italic"
    case poppinsMedium = "Poppins Medium"
    case poppinsMediumItalic = "Poppins Medium Italic"
    case poppinsRegular = "Poppins Regular"
    case poppinsSemiBold = "Poppins SemiBold"
    case poppinsSemiBoldItalic = "Poppins SemiBold Italic"
}

extension Font {
    
    public static func poppinsBold(size: CGFloat) -> Font {
        .custom(CustomFonts.poppinsBold.rawValue, size: size)
    }
    
    public static func poppinsBoldItalic(size: CGFloat) -> Font {
        .custom(CustomFonts.poppinsBoldItalic.rawValue, size: size)
    }
    
    public static func poppinsItalic(size: CGFloat) -> Font {
        .custom(CustomFonts.poppinsItalic.rawValue, size: size)
    }
    
    public static func poppinsMedium(size: CGFloat) -> Font {
        .custom(CustomFonts.poppinsMedium.rawValue, size: size)
    }
    
    public static func poppinsMediumItalic(size: CGFloat) -> Font {
        .custom(CustomFonts.poppinsMediumItalic.rawValue, size: size)
    }
    
    public static func poppinsRegular(size: CGFloat) -> Font {
        .custom(CustomFonts.poppinsRegular.rawValue, size: size)
    }
    
    public static func poppinsSemiBold(size: CGFloat) -> Font {
        .custom(CustomFonts.poppinsSemiBold.rawValue, size: size)
    }
    
    public static func poppinsSemiBoldItalic(size: CGFloat) -> Font {
        .custom(CustomFonts.poppinsSemiBoldItalic.rawValue, size: size)
    }
    
//    /// JetBrains Mono Bold, 25px
//    public static var JBMBold25: Font {
//        .custom(CustomFonts.JBMonoBold.rawValue, size: 25)
//    }
//    
//    /// JetBrains Mono Bold, 20px
//    public static var JBMBold20: Font {
//        .custom(CustomFonts.JBMonoBold.rawValue, size: 20)
//    }
//    
//    /// JetBrains Mono Bold, 17px
//    public static var JBMBold17: Font {
//        .custom(CustomFonts.JBMonoBold.rawValue, size: 17)
//    }
//    
//    /// JetBrains Mono Bold, 13px
//    public static var JBMBold13: Font {
//        .custom(CustomFonts.JBMonoBold.rawValue, size: 13)
//    }
//    
//    /// JetBrains Mono Medium, 20px
//    public static var JBMMedium20: Font {
//        .custom(CustomFonts.JBMonoMedium.rawValue, size: 20)
//    }
//    
//    /// DS-Digital Bold, 30px
//    public static var DSBold30: Font {
//        .custom(CustomFonts.digitalBol.rawValue, size: 30)
//    }
//    
//    /// DS-Digital Bold, 40px
//    public static var DSBold40: Font {
//        .custom(CustomFonts.digitalBol.rawValue, size: 40)
//    }
}
