import UIKit
import SwiftUI
import MixboxTestability

final class AssertingCustomValuesTestsView: TestStackScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSwiftUIView()

        add("string", "the string")
        add("bool_false", false)
        add("bool_true", true)
        add("int_0", 0)
        add("int_1", 1)
        add("int_-1", -1)
        add("double_0", Double(0))
        add("double_inf", Double.infinity)
        add("double_nan", Double.nan)
        
        add("double_1.0", Double(1.0))
        
        // TODO: test mathing text, startsWith/endsWith/contains/etc
    }
    
    private func add<T: Codable>(_ id: String, _ value: T) {
        addLabel(id: id) {
            $0.text = id
            $0.mb_testability_customValues["valueKey"] = value
        }
    }

    private func addSwiftUIView() {
        let id = "swiftui_button"
        let hostingView = UIHostingView(rootView: Button(id, action: { }))

        add(
            view: hostingView,
            id: id,
            userConfig: { },
            defaultConfig: { }
        )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Copied from Avito
private final class UIHostingView<Content: View>: UIView {
    override public var intrinsicContentSize: CGSize {
        hostingController.view.intrinsicContentSize
    }

    public var rootView: Content {
        get { hostingController.rootView }
        set { hostingController.rootView = newValue }
    }

    private let hostingController: UIHostingController<Content>

    public init(rootView: Content) {
        self.hostingController = UIHostingController(rootView: rootView)

        super.init(frame: .zero)

        addSubview(hostingController.view)
        hostingController.view.backgroundColor = nil
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        hostingController.view.frame = bounds
    }

    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        hostingController.view.sizeThatFits(size)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
