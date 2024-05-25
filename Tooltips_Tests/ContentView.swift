import SwiftUI
import Tooltips

struct ContentView: View {
    var body: some View {
        List {
            Text("Hover me!")
                .tooltip {
                    Text("Surprise!")
                }
            Text("Hover me! Hover me! Hover me! Hover me! Hover me! Hover me! Hover me! Hover me! Hover me! Hover me!")
                .tooltipExpansion()
                .lineLimit(1)
        }.tooltipHost()
    }
}

#Preview {
    ContentView()
}
