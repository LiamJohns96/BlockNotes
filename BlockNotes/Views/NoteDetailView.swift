import SwiftUI

struct NoteDetailView: View {
    @State var note: Note
    @GestureState private var dragOffset: CGSize = .zero
    @State private var draggingBlock: UUID?

    var onUpdate: (Note) -> Void

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach($note.blocks.indices, id: \.self) { index in
                        let isLeftAligned = index % 2 == 0
                        let blockID = note.blocks[index].id

                        HStack {
                            if !isLeftAligned { Spacer() }

                            BlockView(block: $note.blocks[index]) {
                                onUpdate(note)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.75)
                            .offset(draggingBlock == blockID ? dragOffset : .zero)
                            .gesture(dragGesture(for: note.blocks[index]))
                            .scaleEffect(draggingBlock == blockID ? 1.05 : 1.0)
                            .animation(.easeInOut(duration: 0.2), value: draggingBlock)

                            if isLeftAligned { Spacer() }
                        }
                    }
                }
                .padding()
            }

            Button(action: addBlock) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Block")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding([.horizontal, .bottom])
            }
        }
    }
    
    func addBlock() {
        let newBlock = Block(
            id: UUID(),
            title: "New Block",
            body: .text(""),
            colorIndex: note.blocks.count
        )
        note.blocks.append(newBlock)
        onUpdate(note)
    }
    
    func updateBlock(_ newBlock: Block) {
        if let index = note.blocks.firstIndex(where: { $0.id == newBlock.id }) {
            note.blocks[index] = newBlock
            onUpdate(note)
        }
    }
    
    func dragGesture(for block: Block) -> some Gesture {
        LongPressGesture(minimumDuration: 0.3)
            .sequenced(before: DragGesture())
            .updating($dragOffset) { value, state, _ in
                if case .second(true, let drag?) = value {
                    state = drag.translation
                }
            }
            .onChanged { value in
                if case .second(true, _) = value {
                    draggingBlock = block.id
                }
            }
            .onEnded { value in
                if let index = note.blocks.firstIndex(where: { $0.id == block.id }) {
                    if case .second(true, let drag?) = value {
                        let threshold: CGFloat = 50
                        let isDown = drag.translation.height > threshold
                        let isUp = drag.translation.height < -threshold
                        var newIndex = index

                        if isDown && index < note.blocks.count - 1 {
                            newIndex += 1
                        } else if isUp && index > 0 {
                            newIndex -= 1
                        }

                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8, blendDuration: 0.25)) {
                            let moved = note.blocks.remove(at: index)
                            note.blocks.insert(moved, at: newIndex)
                            onUpdate(note)
                            draggingBlock = nil
                        }

                    }
                }
            }
    }



}
