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
    @State private var isLongPressingID: UUID?
    @State private var isPressingID: UUID? = nil


    var onUpdate: (Block) -> Void


    private var blockSize: CGSize {
        let width = UIScreen.main.bounds.width / 2 - 24  // half screen width minus padding
        return CGSize(width: width, height: 160)
    }
    private let spacing: CGFloat = 100
    private let columns = 2

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                ZStack(alignment: .topLeading) {
                    ForEach(blocks.indices, id: \.self) { index in
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
                        .scaleEffect(
                            isDragging ? 1.05 : (isPressingID == block.id ? 1.08 : 1.0)
                        )
                        .animation(.easeInOut(duration: 1.3), value: isPressingID == block.id)
                        .shadow(color: .black.opacity(0.2), radius: isDragging ? 8 : 2)
                        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: positions)
                        .gesture(
                            LongPressGesture(minimumDuration: 0.3)
                                .onChanged { _ in
                                    isPressingID = block.id
                                }
                                .onEnded { success in
                                    if success {
                                        // Start drag after long press completes
                                        draggingBlockID = block.id
                                        originalIndex = index
                                    } else {
                                        // Cancelled before long press duration
                                        isPressingID = nil
                                    }
                                }
                                .sequenced(before: DragGesture())
                                .onChanged { value in
                                    switch value {
                                    case .second(true, let drag?):
                                        dragOffset = drag.translation
                                    default:
                                        break
                                    }
                                }
                                .onEnded { value in
                                    isPressingID = nil
                                    if case .second(true, let drag?) = value,
                                       let from = originalIndex,
                                       let to = dropTarget(in: geometry.size, offset: drag.translation, fromIndex: from) {
                                        move(from: from, to: to)
                                    }
                                    draggingBlockID = nil
                                    originalIndex = nil
                                    dragOffset = .zero
                                }
                        )
                    }
                }
                .frame(height: totalContentHeight(), alignment: .top) // <-- key line for scrollable height
            }
            .padding(.top, 60)
            .onAppear {
                updatePositions(containerSize: geometry.size)
            }
            .onChange(of: blocks) { _ in
                updatePositions(containerSize: geometry.size)
            }
        }

        
//        Button("Switch Layout") {
//            layoutTemplate = layoutTemplate is AlternatingLeftRightLayout
//                ? PairThenCenterLayout()
//                : AlternatingLeftRightLayout()
//        }
    }
    
    private func totalContentHeight() -> CGFloat {
        let rows = (blocks.count + columns - 1) / columns
        return CGFloat(rows) * (blockSize.height + spacing)
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
