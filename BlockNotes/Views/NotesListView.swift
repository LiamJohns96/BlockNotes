import SwiftUI

struct NotesListView: View {
    @StateObject private var viewModel = NotesViewModel()
    @State private var pressedNoteID: UUID? = nil
    @State private var navigateToNoteID: UUID? = nil


    var body: some View {
        NavigationView {
            ZStack {
                // Background color
                Color(red: 254/255, green: 245/255, blue: 255/255)
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 0) {
                    // Custom Title and Add Button
                    HStack {
                        Text("BlockNotes")
                            .font(.custom("Aurora", size: 28))
                            .fontWeight(.bold)
                            .foregroundColor(.black)

                        Spacer()

                        Button(action: {
                            let newNote = Note(id: UUID(), title: generateDate(), blocks: [])
                            viewModel.add(note: newNote)
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Color.mint)
                                .cornerRadius(12)
                        }
                        .shadow(radius: 4)
                    }
                    .padding([.horizontal, .top])

                    Spacer().frame(height: 15)

                    // Scrollable Note Cards
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.notes) { note in
                                ZStack {
                                    NoteCard(note: note)
                                        .padding(.horizontal)
                                        .scaleEffect(pressedNoteID == note.id ? 0.97 : 1.0)
                                        .opacity(pressedNoteID == note.id ? 0.85 : 1.0)
                                        .foregroundColor(pressedNoteID == note.id ? Color.blue : Color.black)
                                        .onTapGesture {
                                            pressedNoteID = note.id
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                pressedNoteID = nil
                                                navigateToNoteID = note.id
                                            }
                                        }

                                    NavigationLink(
                                        destination: NoteDetailView(
                                            note: note,
                                            onUpdate: { updatedNote in
                                                viewModel.update(note: updatedNote)
                                            }),
                                        tag: note.id,
                                        selection: $navigateToNoteID
                                    ) {
                                        EmptyView()
                                    }
                                    .hidden()
                                }
                            }
                        }
                        .padding(.top)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }

    func generateDate() -> String {
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let year = calendar.component(.year, from: date)

        let suffix: String
        switch day {
        case 11, 12, 13: suffix = "th"
        default:
            switch day % 10 {
            case 1: suffix = "st"
            case 2: suffix = "nd"
            case 3: suffix = "rd"
            default: suffix = "th"
            }
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        let month = formatter.string(from: date)

        return "\(calendar.weekdaySymbols[calendar.component(.weekday, from: date) - 1]), \(day)\(suffix) \(month) \(year)"
    }
}

struct NoteCard: View {
    let note: Note
    @State var backColor: Color = .white

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(note.title)
                .font(.headline)
                .lineLimit(1)

            HStack(spacing: 6) {
                ForEach(note.blocks.prefix(3)) { block in
                    if case let .text(bodyText) = block.body {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(block.title)
                                .font(.custom("Dashing Unicorn", size: 8))
                                .foregroundColor(.black)
                                .lineLimit(1)

                            Text(bodyText)
                                .font(.system(size: 5))
                                .foregroundColor(.black)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(4)
                        .frame(width: 80, height: 80, alignment: .topLeading)
                        .background(color(for: block.colorIndex))
                        .cornerRadius(8)
                    }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.75)
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
    }
    
    public func changeBack(_ Color: Color) {
        backColor = Color
    }
}
