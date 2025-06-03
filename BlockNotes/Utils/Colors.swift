import SwiftUI

let blockColors: [Color] = [
    Color(hex: "#F7EC08"),
    Color(hex: "#FF6F61"),
    Color(hex: "#4FC3F7"),
    Color(hex: "#4DB6AC"),
    Color(hex: "#BA68C8"),
    Color(hex: "#FFCCBC"),
    Color(hex: "#0288D1"),
    Color(hex: "#F06292"),
    Color(hex: "#80CBC4"),
    Color(hex: "#B0BEC5"),
    Color(hex: "#FFB300"),
    Color(hex: "#6A1B9A"),
    Color(hex: "#43A047"),
    Color(hex: "#B3E5FC"),
    Color(hex: "#E53935")
]

func color(for index: Int) -> Color {
    blockColors[index % blockColors.count]
}
