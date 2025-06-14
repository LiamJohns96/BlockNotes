import SwiftUI

struct BlockPosition: Equatable {
    var x: CGFloat
    var y: CGFloat
}

struct ReorderableBlockContainer: View {
    @Binding var title: String
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
        return CGSize(width: width, height: width)
    }
    private let spacing: CGFloat = 80
    private let columns = 2

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                
                VStack(spacing: 0) {
                    // TITLE INSIDE SCROLL VIEW
//                    TextField("Note Title", text: $title)
//                        .font(.custom("Times", size: 15))
//                        .fontWeight(.light)
//                        .multilineTextAlignment(.center)
//                        .padding(.top, 20)
//                        .padding(.horizontal, 16)
//                        .textFieldStyle(.plain)
//                        .accentColor(Color.black)
//                        .onChange(of: title) { _ in
//                            // Optional — trigger updates if needed
//                        }
                    
                    HStack(){
                        TextField("Note Title", text: $title)
                            .font(.custom("Aurora", size: 18))
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                            .padding(.vertical, 10)
                            .padding(.leading, 12)
                            .padding(.trailing, 8)
                            .foregroundColor(.white)
                            .textFieldStyle(.plain)
                            .background(RGB(220, 173, 247))
                            .cornerRadius(13)
                    }
                    .padding(10)
                    .background(RGB(233, 196, 255))
                    .offset(y: -1)

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
                                    .shadow(color: .black.opacity(0.2), radius: isDragging ? 8 : 2)
                                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: positions)
                                    .gesture(
                                        LongPressGesture(minimumDuration: 0.3)
                                            .onChanged { _ in isPressingID = block.id }
                                            .onEnded { success in
                                                if success {
                                                    draggingBlockID = block.id
                                                    originalIndex = index
                                                } else {
                                                    isPressingID = nil
                                                }
                                            }
                                            .sequenced(before: DragGesture())
                                            .onChanged { value in
                                                if case .second(true, let drag?) = value {
                                                    dragOffset = drag.translation
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
                    .frame(height: totalContentHeight() + blockSize.height * 3, alignment: .top)
                        }
                    }
                    .padding(.top, 0)
                    .background(Color.clear) // Needed for layout stability
                    .onAppear {
                        updatePositions(containerSize: geometry.size)
                    }
                    .onChange(of: blocks) { _ in
                        updatePositions(containerSize: geometry.size)
                    }
        }
        .ignoresSafeArea(.keyboard)

        
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
        let floatFromIndex = CGFloat(fromIndex)
        let floatColumns = CGFloat(columns)
        let dragY = CGFloat(floatFromIndex / floatColumns) * (blockSize.height + spacing) + offset.height
       
        let dragRow = Int((dragY + blockSize.height / 2) / (blockSize.height + spacing))
  
        let dragCol = offset.width > 50 ? 1 : (offset.width < -50 ? 0 : fromIndex % 2)
       
        let targetIndex = dragRow * columns + dragCol
        
        let clampedIndex = min(max(0, targetIndex), blocks.count - 1)
        
        return clampedIndex
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
