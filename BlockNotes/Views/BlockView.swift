import SwiftUI

struct BlockView: View {
    @Binding var block: Block
    var onUpdate: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("Title", text: $block.title)
                .font(.system(size: 16, weight: .bold))
                .textFieldStyle(.roundedBorder)
                .onChange(of: block.title) {
                    onUpdate()
                }

            TextEditor(text: bindingForBody())
                .font(.system(size: 10))
                .frame(height: 100)
                .padding(4)
                .background(Color.clear)
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
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

