import SwiftUI

struct NoteDetailView: View {
    var note: Note

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(Array(note.blocks.enumerated()), id: \.1.id) { index, block in
                    HStack {
                        if index % 2 == 0 { Spacer() }
                        BlockView(block: block)
                            .frame(width: UIScreen.main.bounds.width * 0.7)
                        if index % 2 != 0 { Spacer() }
                    }
                }
            }
            .padding()
        }
    }
}
