import UIKit
import SwiftUI
import MixboxTestability

final class SwiftUITestsView: UIView {
    private struct RootViewA: View {
        var body: some View {
            VStack {
                HStack {
                    customTextLeft

                    Text("Custom text right")
                        .disabled(true)
                        .mb_testability_customValues(["custom_string": "string", "custom_int": 42])
                }

                Button("Press me", action: { })
            }
        }

        @ViewBuilder
        var customTextLeft: some View {
            if #available(iOS 14.0, *) {
                Text("Custom text left")
                    .accessibilityHint(Text("This is a custom hint"))
                    .accessibilityIdentifier("custom identifier")
                    .accessibilityValue(Text("This is a value"))
            } else {
                Text("Custom text left")
            }
        }
    }

    private struct RootViewB: View {
        var body: some View {
            List(0..<50) { index in
                Text("\(index)")
            }
        }
    }

    private struct RootViewC: View {
        var body: some View {
            ScrollView {
                if #available(iOS 14.0, *) {
                    LazyVStack {
                        ForEach(0..<50) { index in
                            Text("\(index)")
                        }
                    }
                }
            }
        }
    }

    private let hostingView = UIHostingView(rootView: RootViewA())

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(hostingView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        hostingView.frame = bounds
    }
}
