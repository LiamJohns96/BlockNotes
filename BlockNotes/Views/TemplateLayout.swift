import SwiftUI

/// Define a protocol for layout templates
protocol BlockLayoutTemplate {
    func position(for index: Int, containerSize: CGSize, blockSize: CGSize, spacing: CGFloat) -> BlockPosition
}

/// First layout: Left/Right alternating
struct AlternatingLeftRightLayout: BlockLayoutTemplate {
    func position(for index: Int, containerSize: CGSize, blockSize: CGSize, spacing: CGFloat) -> BlockPosition {
        let isLeft = index % 2 == 0
        let colOffset: CGFloat = isLeft ? 15 : containerSize.width - blockSize.width - 15
        let row = index / 2
        let baseY = CGFloat(row) * (blockSize.height + spacing) + blockSize.height / 2

        // ✅ Add half block height if it's an odd index
        let yOffset = isLeft ? 0 : blockSize.height / 2

        let x = colOffset + blockSize.width / 2
        let y = baseY + yOffset + blockSize.height / 2

        return BlockPosition(x: x, y: y)
    }
}


/// Second layout: Two side by side, then one centered below
struct PairThenCenterLayout: BlockLayoutTemplate {
    func position(for index: Int, containerSize: CGSize, blockSize: CGSize, spacing: CGFloat) -> BlockPosition {
        let triplet = index / 3
        let positionInTriplet = index % 3

        switch positionInTriplet {
        case 0:
            // Left
            return BlockPosition(
                x: blockSize.width / 2,
                y: CGFloat(triplet) * 2 * (blockSize.height + spacing) + blockSize.height / 2
            )
        case 1:
            // Right
            return BlockPosition(
                x: containerSize.width - blockSize.width / 2,
                y: CGFloat(triplet) * 2 * (blockSize.height + spacing) + blockSize.height / 2
            )
        case 2:
            // Center below
            return BlockPosition(
                x: containerSize.width / 2,
                y: CGFloat(triplet) * 2 * (blockSize.height + spacing) + 1.5 * (blockSize.height + spacing)
            )
        default:
            return .init(x: 0, y: 0)
        }
    }
}
