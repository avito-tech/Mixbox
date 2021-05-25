import TestsIpc
import XCTest
import MixboxUiTestsFoundation
import MixboxTestsFoundation
import MixboxGenerators

final class NavigationBarCanBeFoundTests: TestCase {
    private typealias ElementSelector = (NavigationBarCanBeFoundTestsViewPageObject) -> ViewElement
    
    override func precondition() {
        super.precondition()
        
        open(screen: pageObjects.navigationBarCanBeFoundTestsView)
            .waitUntilViewIsLoaded()
    }

    func test___navigation_bar_subview_can_be_found___defaultBackButton() {
        checkButtonIsTappable(
            testType: .defaultBackButton,
            element: { $0.defaultBackButton }
        )
    }
    
    func test___navigation_bar_subview_can_be_found___customBackButton() {
        checkButtonIsTappable(
            testType: .customBackButton(generator.generate()),
            element: { $0.defaultBackButton }
        )
    }
    
    func test___navigation_bar_subview_can_be_found___rightBarButtonItem() {
        let title = randomTitle()
        checkButtonIsTappable(
            testType: .rightBarButtonItem(button(title: title)),
            element: { $0.customBarButton(title: title) }
        )
    }
    
    func test___navigation_bar_subview_can_be_found___rightBarButtonItems() {
        let title = randomTitle()
        let element: ElementSelector = { $0.customBarButton(title: title) }
        
        checkButtonIsTappable(
            testType: .rightBarButtonItems([button(title: title)]),
            element: element
        )
        checkButtonIsTappable(
            testType: .rightBarButtonItems([button(title: title)] + dummyButtons(1)),
            element: element
        )
        checkButtonIsTappable(
            testType: .rightBarButtonItems([button(title: title)] + dummyButtons(5)),
            element: element
        )
        checkButtonIsTappable(
            testType: .rightBarButtonItems(dummyButtons(5) + [button(title: title)]),
            element: element
        )
    }
    
    private func checkButtonIsTappable(
        testType: NavigationBarCanBeFoundTestsViewConfiguration.TestType,
        element: ElementSelector)
    {
        // This should always lead to pushing view controller.
        resetUi(testType: testType)
        
        // To avoid false-positives later
        screen.nestedViewController.withoutTimeout.assertIsDisplayed()
        screen.rootViewController.withoutTimeout.assertIsNotDisplayed()
        
        // This should always lead to popping view controller.
        element(screen).withoutTimeout.tap()
        
        // Checks that previous screen is openend.
        screen.rootViewController.withoutTimeout.assertIsDisplayed()
        screen.nestedViewController.withoutTimeout.assertIsNotDisplayed()
    }
    
    private var screen: NavigationBarCanBeFoundTestsViewPageObject {
        return pageObjects.navigationBarCanBeFoundTestsView.uikit
    }
    
    private func resetUi(testType: NavigationBarCanBeFoundTestsViewConfiguration.TestType) {
        // The idea is to maximize deceleration path. To do this we place button outside of initially visible area
        // and have much space in scroll view to avoid bouncing.
        resetUi(
            argument: NavigationBarCanBeFoundTestsViewConfiguration(
                testType: testType
            )
        )
    }
    
    private func dummyButtons(_ count: Int) -> [NavigationBarCanBeFoundTestsViewConfiguration.BarButtonItem] {
        return generator.array(count: count) {
            $0.title = self.randomTitle()
            $0.action = .none
        }
    }
    
    private func button(title: String) -> NavigationBarCanBeFoundTestsViewConfiguration.BarButtonItem {
        return .init(
            title: title,
            action: .pop
        )
    }
    
    private func randomTitle() -> String {
        let generator = RandomStringGenerator(
            randomNumberProvider: dependencies.resolve(),
            lengthGenerator: ConstantGenerator(10)
        )
        
        return UnavoidableFailure.doOrFail {
            try generator.generate()
        }
    }
}
