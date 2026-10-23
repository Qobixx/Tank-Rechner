//
//  Color+Extension.swift
//  Tank-Rechner
//
//  Created by Jonas Lubbe on 16.10.26.
//

import SwiftUI

// Bringt SwiftUI bei, wie eine Color direkt in @AppStorage gespeichert werden kann
extension Color: @retroactive RawRepresentable {
    public typealias RawValue = String

    public init?(rawValue: String) {
        let parts = rawValue.split(separator: ",").compactMap { Double($0) }
        guard parts.count == 4 else { return nil }
        self.init(.sRGB, red: parts[0], green: parts[1], blue: parts[2], opacity: parts[3])
    }

    public var rawValue: String {
        let uic = UIColor(self)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uic.getRed(&r, green: &g, blue: &b, alpha: &a)
        return "\(r),\(g),\(b),\(a)"
    }
}
