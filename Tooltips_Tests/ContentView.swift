import SwiftUI
import Tooltips

struct ContentView: View {
    var body: some View {
        List {
            Image(systemName: "photo")
                .resizable()
                .imageScale(.large)
                .frame(width: 256, height: 256)
                .tooltip {
                    Text("Surprise!")
                }
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
