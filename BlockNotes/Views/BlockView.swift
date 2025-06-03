import SwiftUI

struct BlockView: View {
    
    @Binding var block: Block
    var onUpdate: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("Title", text: $block.title)
                .font(.custom("Dashing Unicorn", size: 20))
                .padding(1)
                .background(Color.clear) // or Color.gray.opacity(0.05)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 6)
//                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
//                )
                .cornerRadius(6)
                .onChange(of: block.title) {
                    onUpdate()
                }

            TextEditor(text: bindingForBody())
                .font(.custom("Dashing Unicorn", size: 14))
                .frame(height: 120) // Fixed height
//                .scrollDisabled(true)
                .padding(1)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .cornerRadius(6)
                              // ensures it doesn't expand or scroll internally

        }
        .padding()
        .background(color(for: block.colorIndex))
        .cornerRadius(10)
    }

    private func bindingForBody() -> Binding<String> {
        Binding<String>(
            get: {
                if case .text(let content) = block.body {
                    return content
                } else {
                    return "" // could be extended for other types
                }
            },
            set: { newValue in
                block.body = .text(newValue)
                onUpdate()
            }
        )
    }
}

