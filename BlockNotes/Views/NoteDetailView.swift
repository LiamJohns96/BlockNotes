import SwiftUI

struct NoteDetailView: View {
    @State var note: Note
    var onUpdate: (Note) -> Void

    var body: some View {
        ZStack {
            Color(red: 254/255, green: 245/255, blue: 255/255) // light purple
                .ignoresSafeArea() // ensure it fills entire screen

            VStack(spacing: 0) {
                TextField("Note Title", text: $note.title)
                    .font(.system(size: 14, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.top, 5)
                    .padding(.horizontal, 16)
                    .textFieldStyle(.plain)
                    .onChange(of: note.title) {
                        onUpdate(note)
                    }

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
