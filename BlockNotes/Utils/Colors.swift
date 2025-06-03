import SwiftUI

let blockColors: [Color] = [
    Color(hex: "#FFF6A5"), // soft sunflower yellow
    Color(hex: "#FFB4A2"), // warm coral pink
    Color(hex: "#A2D2FF"), // fresh sky blue
    Color(hex: "#B5EAD7"), // mint cream
    Color(hex: "#DDBCFD"), // gentle lilac
    Color(hex: "#FFD6A5"), // soft peach
    Color(hex: "#9ED9CC"), // seafoam
    Color(hex: "#FEC8D8"), // light rose
    Color(hex: "#C2F784"), // lime pistachio
    Color(hex: "#D6E4F0"), // ice blue
    Color(hex: "#FFDE7D"), // pastel gold
    Color(hex: "#E0BBE4"), // soft orchid
    Color(hex: "#B4F8C8"), // minty green
    Color(hex: "#CAE9FF"), // powder blue
    Color(hex: "#FFA69E")  // sunset blush
]


func color(for index: Int) -> Color {
    blockColors[index % blockColors.count]
}
