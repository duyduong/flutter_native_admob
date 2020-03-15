//
//  Extensions.swift
//  flutter_native_admob
//
//  Created by Dao Duy Duong on 3/8/20.
//

import UIKit

extension UIColor {
    
    convenience init(hex: Int) {
        self.init(hex: hex, a: 1.0)
    }
    
    convenience init(hex: Int, a: CGFloat) {
        self.init(r: (hex >> 16) & 0xff, g: (hex >> 8) & 0xff, b: hex & 0xff, a: a)
    }
    
    convenience init(r: Int, g: Int, b: Int) {
        self.init(r: r, g: g, b: b, a: 1.0)
    }
    
    convenience init(r: Int, g: Int, b: Int, a: CGFloat) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }
    
    convenience init?(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    static func fromHex(_ hexString: String) -> UIColor {
        return UIColor(hexString: hexString) ?? .clear
    }
}

extension UIEdgeInsets {
    
    static func parse(_ value: String) -> UIEdgeInsets {
        let parts = value.components(separatedBy: ",").map { val -> CGFloat in
            let trimmedVal = val.trimmingCharacters(in: .whitespacesAndNewlines)
            return CGFloat((trimmedVal as NSString).doubleValue)
        }
        
        if parts.count < 4 {
            return .zero
        }
        
        return UIEdgeInsets(top: parts[1], left: parts[0], bottom: parts[3], right: parts[2])
    }
}

extension UIImage {
    
    /// Create image from mono color
    static func from(color: UIColor) -> UIImage {
        let size = CGSize(width: 1, height: 1)
        return from(color: color, withSize: size)
    }
    
    /// Create image from mono color with specific size and corner radius
    static func from(color: UIColor, withSize size: CGSize, cornerRadius: CGFloat = 0) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: cornerRadius)
        path.addClip()
        color.setFill()
        path.fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension Optional where Wrapped == String {
    
  var isNilOrEmpty: Bool {
    return self == nil || self!.isEmpty
  }
}
