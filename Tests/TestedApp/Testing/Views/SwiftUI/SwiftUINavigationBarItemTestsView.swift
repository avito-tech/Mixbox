import UIKit
import SwiftUI

final class SwiftUINavigationBarItemTestsView: UIView {
    private struct RootView: View {
        var body: some View {
            if #available(iOS 14.0, *) {
                Text("Hello, world!")
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Custom item") {
                                // Do nothing
                            }
                        }
                    }
            }
        }
    }

    private let navigationController: UINavigationController

    override init(frame: CGRect) {
        self.navigationController = UINavigationController(rootViewController: UIHostingController(rootView: RootView()))

        super.init(frame: frame)

        addSubview(navigationController.view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        navigationController.view.frame = bounds
    }
}
