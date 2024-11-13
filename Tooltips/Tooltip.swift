import SwiftUI

extension LabelStyle where Self == TooltipLabelStyle {
    public static var tooltip: Self { TooltipLabelStyle() }
}

public struct TooltipLabelStyle: LabelStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.title.font(.body)
    }
}

extension View {
    /// A hosting container for overlaying tooltips on a view.
    public func tooltipHost() -> some View {
        self
            .modifier(TooltipHostModifier())
    }
    /// Expands truncated text via tooltip.
    public func tooltipExpansion() -> some View {
        TooltipExpansionView(content: self)
    }
    /// Adds a tooltip with the provided text to the view.
    /// - Parameters:
    ///   - text: The text to display.
    ///   - inline: Whether the tooltip displays as an expansion of the hovered view, such as revealing an expanded version of truncated text.
    public func tooltip(_ text: String, inline: Bool = false) -> some View {
        tooltip(inline: inline) {
            Text(text)
        }
    }
    /// Adds a tooltip with the provided custom content to the view.
    /// - Parameters:
    ///   - inline: Whether the tooltip displays as an expansion of the hovered view, such as revealing an expanded version of truncated text.
    ///   - content: The view to display within the tooltip.
    public func tooltip(inline: Bool = false, @ViewBuilder content: @escaping () -> some View) -> some View {
        TooltipModifier(inline: inline) {
            self 
        } tooltipContent: {
            content() 
        }
    }
}

enum TooltipPreferenceKey: PreferenceKey {
    static var defaultValue: Tooltip?
    static func reduce(value: inout Tooltip?, nextValue: () -> Tooltip?) {
        value = value ?? nextValue()
    }
    struct Tooltip {
        var anchor: Anchor<CGRect>
        var inline: Bool
        var content: AnyView
    }
}

struct TooltipExpansionView<Content: View>: View {
    var content: Content
    @Environment(\.font) private var font
    
    var body: some View {
        ViewThatFits {
            content
            
            TooltipModifier(inline: true) {
                content
            } tooltipContent: {
                if let font {
                    content.font(font)
                } else {
                    content   
                }
            }
        }
    }
}

// Can't capture ViewModifier's content param, so must be a View
struct TooltipModifier<Content: View, TooltipContent: View>: View {
    var inline: Bool
    @ViewBuilder var content: () -> Content
    @ViewBuilder var tooltipContent: () -> TooltipContent
    @State private var timer: Task<(), Error>?
    @State private var isHovering = false
    
    var body: some View {
        content()
            .opacity(isHovering && inline ? 0 : 1)
            .onHover { hovering in
                if hovering {
                    if timer?.isCancelled != false {
                        timer = Task {
                            try await Task.sleep(for: .seconds(1))
                            isHovering = true
                        }
                    }
                } else {
                    timer?.cancel()
                    isHovering = false
                }
            }
            .anchorPreference(key: TooltipPreferenceKey.self, value: .bounds) { anchor in
                if isHovering {
                    TooltipPreferenceKey.Tooltip(anchor: anchor, inline: inline, content: AnyView(tooltipContent()))
                } else {
                    nil
                }
            }
    }
}

struct TooltipHostModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlayPreferenceValue(TooltipPreferenceKey.self, alignment: .leading) { tooltip in
                if let tooltip {
                    GeometryReader { geometry in
                        let frame = geometry[tooltip.anchor]
                        let verticalOffset: CGFloat = ((geometry.size.height - frame.maxY) < 64 ? -frame.height - 4 : frame.height + 4)
                        tooltip.content
                            .padding(2)
                            .border(Color(uiColor: .systemGray5))
                            .background(.background)
                            .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
                            .padding(-2)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(
                                width: geometry.size.width - frame.minX - 2,
                                height: frame.height,
                                alignment: verticalOffset > 0 ? .topLeading : .bottomLeading
                            )
                            .offset(
                                x: frame.minX,
                                y: frame.minY + (tooltip.inline ? 0 : verticalOffset)
                            )
                            .allowsHitTesting(false)
                    }.accessibilityHidden(true)
                }
            }
    }
}

#Preview("Expansion") {
    List {
        Text("Hover me! Hover me! Hover me! Hover me! Hover me! Hover me! Hover me! Hover me! Hover me! Hover me!")
            .tooltipExpansion()
            .lineLimit(1)
    }.tooltipHost()
}

#Preview("Custom non-inline") {
    List {
        Text("Hover me!")
            .tooltip {
                Text("Surprise!")
            }
    }.tooltipHost()
}
