import SwiftUI

public func RGB(_ red: Double, _ green: Double, _ blue: Double) -> Color {
    return Color(red: red / 255, green: green / 255, blue: blue / 255)
}
