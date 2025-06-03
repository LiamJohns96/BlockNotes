import SwiftUI

struct NoteDetailView: View {
    @State var note: Note

    var onUpdate: (Note) -> Void

    var body: some View {
        VStack {
            ReorderableBlockContainer(blocks: $note.blocks) { updatedBlock in
                onUpdate(note)
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
}
