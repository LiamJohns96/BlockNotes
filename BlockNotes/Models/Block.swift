import Foundation

struct Block: Identifiable, Codable {
    let id: UUID
    var title: String
    var body: BlockBody
    var colorIndex: Int
}
