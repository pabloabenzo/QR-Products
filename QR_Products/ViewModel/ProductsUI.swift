//
//  ProductsUI.swift
//  QR_Products
//
//  Created by Pablo Benzo on 12/06/2025.
//

import UIKit
import SwiftUI

@MainActor
final class ProductsUI: ObservableObject {
    
    public var deviceHeight = UIScreen.main.bounds.height
    public var deviceWidth = UIScreen.main.bounds.width

    enum AppColor: String {
        case primary
        case secondary
        case success
        case error
        case base_white
        case base_black
        case base_gray
        case system_blue
        case unknown

        init(from string: String) {
            self = AppColor(rawValue: string) ?? .unknown
        }

        var uiColor: UIColor {
            switch self {
            case .primary:
                return UIColor(red: 121/255, green: 2/255, blue: 170/255, alpha: 1.0)
            case .secondary:
                return UIColor(red: 239/255, green: 206/255, blue: 141/255, alpha: 1.0)
            case .success:
                return UIColor(red: 164/255, green: 244/255, blue: 231/255, alpha: 1.0)
            case .error:
                return UIColor(red: 228/255, green: 98/255, blue: 111/255, alpha: 1.0)
            case .base_white:
                return UIColor(white: 1.0, alpha: 1.0)
            case .base_black:
                return UIColor(white: 0.0, alpha: 1.0)
            case .base_gray:
                return UIColor (red: 128/255, green: 128/255, blue: 128/255, alpha: 1.0)
            case .system_blue:
                return UIColor (red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
            case .unknown:
                return UIColor(red: 10/255, green: 10/255, blue: 11/255, alpha: 1.0)
            }
        }

        var color: Color {
            Color(uiColor)
        }
    }

    // Uso en SwiftUI
    func colorManager(color: String) -> Color {
        AppColor(from: color).color
    }

    // Uso en UIKit
    func uiColorManager(color: String) -> UIColor {
        AppColor(from: color).uiColor
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
