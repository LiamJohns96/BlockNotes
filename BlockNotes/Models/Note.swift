import Foundation

struct Note: Identifiable, Codable {
    var id: UUID
    var title: String
    var blocks: [Block]
}
