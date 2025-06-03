import Foundation

class NotesStorage {
    static let shared = NotesStorage()
    private let notesURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("notes.json")

    func save(notes: [Note]) {
        do {
            let data = try JSONEncoder().encode(notes)
            try data.write(to: notesURL, options: [.atomicWrite])
        } catch {
            print("Save error: \(error)")
        }
    }

    func load() -> [Note] {
        do {
            let data = try Data(contentsOf: notesURL)
            return try JSONDecoder().decode([Note].self, from: data)
        } catch {
            print("Load error: \(error)")
            return []
        }
    }
}
