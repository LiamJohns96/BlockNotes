import Foundation

enum BlockBody: Codable, Equatable {
    case text(String)
    case bullets([String])
    case numbered([String])

    enum CodingKeys: String, CodingKey {
        case type, value
    }

    enum BlockType: String, Codable {
        case text, bullets, numbered
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(BlockType.self, forKey: .type)
        switch type {
        case .text:
            self = .text(try container.decode(String.self, forKey: .value))
        case .bullets:
            self = .bullets(try container.decode([String].self, forKey: .value))
        case .numbered:
            self = .numbered(try container.decode([String].self, forKey: .value))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .text(let text):
            try container.encode(BlockType.text, forKey: .type)
            try container.encode(text, forKey: .value)
        case .bullets(let items):
            try container.encode(BlockType.bullets, forKey: .type)
            try container.encode(items, forKey: .value)
        case .numbered(let items):
            try container.encode(BlockType.numbered, forKey: .type)
            try container.encode(items, forKey: .value)
        }
    }
}
