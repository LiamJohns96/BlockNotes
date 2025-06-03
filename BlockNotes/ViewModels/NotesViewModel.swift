import Foundation

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []

    init() {
        loadNotes()
    }

    func loadNotes() {
        notes = NotesStorage.shared.load()
    }

    func saveNotes() {
        NotesStorage.shared.save(notes: notes)
    }

    func add(note: Note) {
        notes.append(note)
        saveNotes()
    }

    func update(note: Note) {
        guard let index = notes.firstIndex(where: { $0.id == note.id }) else { return }
        notes[index] = note
        saveNotes()
    }
}
