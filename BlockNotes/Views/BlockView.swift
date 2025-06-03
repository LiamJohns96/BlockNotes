import SwiftUI

struct BlockView: View {
    var block: Block

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(block.title)
                .font(.headline)
            content
        }
        .padding()
        .background(color(for: block.colorIndex))
        .cornerRadius(10)
    }

    @ViewBuilder
    var content: some View {
        switch block.body {
        case .text(let str):
            Text(str)
        case .bullets(let items):
            VStack(alignment: .leading) {
                ForEach(items, id: \.self) { item in
                    Text("• \(item)")
                }
            }
        case .numbered(let items):
            VStack(alignment: .leading) {
                ForEach(Array(items.enumerated()), id: \.0) { i, item in
                    Text("\(i+1). \(item)")
                }
            }
        }
    }
}
