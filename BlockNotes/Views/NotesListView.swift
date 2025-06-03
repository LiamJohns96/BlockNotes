import SwiftUI

struct NotesListView: View {
    @StateObject private var viewModel = NotesViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.notes) { note in
                    NavigationLink(destination: NoteDetailView(
                        note: note,
                        onUpdate: { updatedNote in
                            viewModel.update(note: updatedNote)
                        })) {
                        Text(note.title)
                    }
                }
            }
            .navigationTitle("BlockNotes")
            .toolbar {
                Button(action: {
                    let newNote = Note(id: UUID(), title: "New Note", blocks: [])
                    viewModel.add(note: newNote)
                }) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}
