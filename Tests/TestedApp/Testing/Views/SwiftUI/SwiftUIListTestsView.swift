import UIKit
import SwiftUI
import MixboxTestability

final class SwiftUIListTestsView: UIView {
    private struct RootView: View {
        var body: some View {
            List(0..<100) { index in
                Text("\(index + 1)")
            }
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
