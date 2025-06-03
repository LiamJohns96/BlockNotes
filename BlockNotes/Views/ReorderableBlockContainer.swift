// Reworked ReorderableBlockContainer with per-block A-to-B animations using custom layout positions

import SwiftUI

struct BlockPosition: Equatable {
    var x: CGFloat
    var y: CGFloat
}

struct ReorderableBlockContainer: View {
    @Binding var blocks: [Block]
    @State private var draggingBlockID: UUID?
    @State private var dragOffset: CGSize = .zero
    @State private var originalIndex: Int?
    @State private var positions: [UUID: BlockPosition] = [:]
    @State private var layoutTemplate: BlockLayoutTemplate = AlternatingLeftRightLayout()


    var onUpdate: (Block) -> Void


    private let blockSize = CGSize(width: 160, height: 160)
    private let spacing: CGFloat = 20
    private let columns = 2

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                ForEach(blocks.indices, id: \ .self) { index in
                    let block = blocks[index]
                    let isDragging = block.id == draggingBlockID
                    let position = positions[block.id] ?? positionFor(index: index, container: geometry.size)

                    BlockView(block: binding(for: block)) {
                        onUpdate(block)
                    }
                    .frame(width: blockSize.width, height: blockSize.height)
                    .position(x: position.x, y: position.y)
                    .offset(isDragging ? dragOffset : .zero)
                    .zIndex(isDragging ? 1 : 0)
                    .scaleEffect(isDragging ? 1.05 : 1.0)
                    .shadow(color: .black.opacity(0.2), radius: isDragging ? 8 : 2)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: positions)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if draggingBlockID == nil {
                                    draggingBlockID = block.id
                                    originalIndex = index
                                }
                                dragOffset = value.translation
                            }
                            .onEnded { _ in
                                if let from = originalIndex,
                                   let to = dropTarget(in: geometry.size, offset: dragOffset, fromIndex: from) {
                                    move(from: from, to: to)
                                }
                                draggingBlockID = nil
                                originalIndex = nil
                                dragOffset = .zero
                            }
                    )
                }
            }
            .onAppear {
                updatePositions(containerSize: geometry.size)
            }
            .onChange(of: blocks) { _ in
                updatePositions(containerSize: geometry.size)
            }
        }
        
        Button("Switch Layout") {
            layoutTemplate = layoutTemplate is AlternatingLeftRightLayout
                ? PairThenCenterLayout()
                : AlternatingLeftRightLayout()
        }
    }

    private func updatePositions(containerSize: CGSize) {
        for index in blocks.indices {
            let block = blocks[index]
            positions[block.id] = positionFor(index: index, container: containerSize)
        }
    }

    private func positionFor(index: Int, container: CGSize) -> BlockPosition {
        layoutTemplate.position(for: index, containerSize: container, blockSize: blockSize, spacing: spacing)
    }


    private func dropTarget(in containerSize: CGSize, offset: CGSize, fromIndex: Int) -> Int? {
        let dragY = CGFloat(fromIndex / columns) * (blockSize.height + spacing) + offset.height
        let dragRow = Int((dragY + blockSize.height / 2) / (blockSize.height + spacing))
        let dragCol = offset.width > 50 ? 1 : (offset.width < -50 ? 0 : fromIndex % 2)
        let targetIndex = dragRow * columns + dragCol
        return min(max(0, targetIndex), blocks.count - 1)
    }

    private func move(from: Int, to: Int) {
        guard from != to else { return }
        let moved = blocks.remove(at: from)
        blocks.insert(moved, at: to)
    }

    private func binding(for block: Block) -> Binding<Block> {
        guard let i = blocks.firstIndex(where: { $0.id == block.id }) else {
            fatalError("Block not found")
        }
        return $blocks[i]
    }
}
