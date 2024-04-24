import UIKit
import SwiftUI
import MixboxTestability

final class SwiftUICustomValuesTestsView: UIView {
    private struct RootView: View {
        var body: some View {
            VStack {
                label("string", value: "value")
                label("int", value: 42)
                label("double", value: 3.14)
                label("bool", value: true)
            }
            .background(Color.white)
        }

        func label(_ id: String, value: Any) -> some View {
            Text("\(id): \(String(describing: value))")
                .accessibility(identifier: id)
                .mb_testability_customValues(["value": value])
        }
    }

    private let hostingView = UIHostingView(rootView: RootView())

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
