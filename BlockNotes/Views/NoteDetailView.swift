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
                .background(Color.mint)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding([.horizontal, .bottom])
            }
        }.background(Color(red: 254/255, green: 245/255, blue: 255/255)) // same as above
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
