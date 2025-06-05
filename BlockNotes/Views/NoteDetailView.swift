import SwiftUI

struct NoteDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State var note: Note
    var onUpdate: (Note) -> Void

    var body: some View {
        ZStack {
            // MARK: - Background Color (fills the entire screen including safe areas)
            Color(red: 254/255, green: 245/255, blue: 255/255)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // MARK: - Main Content Area
                ReorderableBlockContainer(title: $note.title, blocks: $note.blocks) { updatedBlock in
                    onUpdate(note)
                }
            }

            // MARK: - Floating Add Block Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: addBlock) {
                        Image(systemName: "plus")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80)
                            .background(Color.mint)
                            .cornerRadius(12)
                    }
                    .shadow(radius: 4)
                    .padding()
                }
            }
        }
        
        // MARK: - Custom Toolbar with Background Color
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.blue)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(
            Color(red: 233/255, green: 196/255, blue: 255/255), for: .navigationBar
        )
        .toolbarBackground(.visible, for: .navigationBar)
        .ignoresSafeArea(.keyboard)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        
    }

    // MARK: - Add Block Logic
    private func addBlock() {
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
