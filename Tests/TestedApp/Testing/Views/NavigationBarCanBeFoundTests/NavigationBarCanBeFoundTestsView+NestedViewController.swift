import UIKit
import TestsIpc

extension NavigationBarCanBeFoundTestsView {
    class NestedViewController: UIViewController, ViewWithUtilities {
        private let configuration: NavigationBarCanBeFoundTestsViewConfiguration
        
        init(configuration: NavigationBarCanBeFoundTestsViewConfiguration) {
            self.configuration = configuration
            
            super.init(nibName: nil, bundle: nil)
            
            switch configuration.testType {
            case .defaultBackButton:
                // default back button will be used, nothing to do
                break
            case let .customBackButton(barButtonItem):
                navigationItem.backBarButtonItem = uiBarButtonItem(
                    barButtonItem: barButtonItem
                )
            case let .rightBarButtonItem(barButtonItem):
                navigationItem.hidesBackButton = true
                navigationItem.rightBarButtonItem = uiBarButtonItem(
                    barButtonItem: barButtonItem
                )
            case let .rightBarButtonItems(barButtonItems):
                navigationItem.hidesBackButton = true
                navigationItem.rightBarButtonItems = barButtonItems.map {
                    uiBarButtonItem(
                        barButtonItem: $0
                    )
                }
            }
        }
        
        override func loadView() {
            let label = UILabel()
            
            label.text =
            """
            This is NestedViewController.
            
            It should be opened in the test.
            It contains navigation bar with items.
            Items can be buttons. Buttons can be tapped.
            Tapping buttons will lead to popping to previous view controller.

            View configuration:

            \(valueCodeGenerator.generateCode(
                value: configuration,
                typeCanBeInferredFromContext: false
            ))
            """
            
            label.numberOfLines = 0
            
            label.backgroundColor = .white
            label.accessibilityIdentifier = "NestedViewController"
            
            self.view = label
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func uiBarButtonItem(
            barButtonItem: NavigationBarCanBeFoundTestsViewConfiguration.BarButtonItem)
            -> UIBarButtonItem
        {
            let action: () -> ()
            
            switch barButtonItem.action {
            case .pop:
                action = { [weak self] in
                    self?.navigationController?.popViewController(animated: false)
                }
            case .none:
                action = {}
            }
            
            return UIBarButtonItem(
                title: barButtonItem.title,
                style: .plain,
                action: action
            )
        }
    }
}
