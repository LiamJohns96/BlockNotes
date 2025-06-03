import Foundation

struct Block: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var body: BlockBody
    var colorIndex: Int
}
