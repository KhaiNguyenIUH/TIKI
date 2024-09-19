// Extensions/UIColor+Hex.swift

import UIKit

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)
        if hex.hasPrefix("#") {
            scanner.currentIndex = hex.index(after: hex.startIndex)
        }
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        let r = CGFloat((color >> 16) & 0xff) / 255
        let g = CGFloat((color >> 8) & 0xff) / 255
        let b = CGFloat(color & 0xff) / 255
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
}
