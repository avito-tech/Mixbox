import SwiftUI

final class UIHostingView<Content: View>: UIView {
    override var intrinsicContentSize: CGSize {
        hostingController.view.intrinsicContentSize
    }

    var rootView: Content {
        get { hostingController.rootView }
        set { hostingController.rootView = newValue }
    }

    private let hostingController: UIHostingController<Content>

    init(rootView: Content) {
        self.hostingController = UIHostingController(rootView: rootView)

        super.init(frame: .zero)

        addSubview(hostingController.view)
        hostingController.view.backgroundColor = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        hostingController.view.frame = bounds
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        hostingController.view.sizeThatFits(size)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
