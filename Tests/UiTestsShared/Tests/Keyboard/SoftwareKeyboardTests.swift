import MixboxUiTestsFoundation
import MixboxTestsFoundation
import XCTest
import TestsIpc
import UIKit
import MixboxIpcCommon

final class SoftwareKeyboardTests: TestCase {
    override func precondition() {
        super.precondition()
        
        open(screen: screen)
            .waitUntilViewIsLoaded()
    }
    
    func disabled_test___views_are_properly_hidden_below_a_software_keyboard___when_overlapped_with_mostly_blurring_view() {
        checkKeyboardPageObject(
            // The keyboard is blurred, most of UI is visible below it, but blurred.
            // The bottom of keyboard (approx. 60 points in height) contains 2 very small views that are line drawings,
            // meaning that most of pixels of views below keyboard are very visible, but blurry.
            viewThatCanBeHiddenBelowKeyboard: .visibleWithHeight(60),
            whenKeyboardIsClosed: { screen in
                screen.viewThatCanBeHiddenBelowKeyboard.with(percentageOfVisibleArea: 1).assertIsDisplayed()
            },
            whenKeyboardIsOpened: { screen in
                // Check that no more than 10% of view is visible.
                // Currently keyboard is transparent and about 98% of view in thos case is calculated as visible.
                // This is because the view is blurry and visibility checker has almost zero tolerance of hidden pixels.
                // If anything below blurred keyboard affects the image of the screen, it is calculated as visible.
                // This is not good, because scrolling subsystem only tries to scroll if elements are hidden.
                // If Mixbox sees elements as visible, it, for example, taps on them, but since they are overlapped
                // by a keyboard, Mixbox taps on keyboard instead, so tests work incorrecly and fail.
                // TODO: Fix this scenario. It can either be improvement of visibility check or something else,
                // like checking if hit test returnes desired view.
                screen.viewThatCanBeHiddenBelowKeyboard.assertIsNotDisplayed()
            }
        )
    }
    
    func test___views_are_properly_hidden_below_a_software_keyboard___when_overlapped_with_whole_keyboard() {
        checkKeyboardPageObject(
            viewThatCanBeHiddenBelowKeyboard: .visibleWithHeightOfKeyboardIfKeyboardIsVisibleOrDefaultHeight(60),
            whenKeyboardIsClosed: { screen in
                screen.viewThatCanBeHiddenBelowKeyboard.with(percentageOfVisibleArea: 1).assertIsDisplayed()
            },
            whenKeyboardIsOpened: { screen in
                // TODO: Improve visibility check.
                // We want 100% of view to be calculated as not disblayed (0% as visible).
                // In a real case (example for iPhone 14 Pro Max, iOS 16.0) view's visible area is calculated at 63% even if we want that it should be calculated as 0%.
                screen.viewThatCanBeHiddenBelowKeyboard.assertIsNotDisplayed(
                    maximumAllowedPercentageOfVisibleArea: 0.7
                )
            }
        )
    }
    
    // TODO: Ideally we want to check element directly.
    func test___keyboard_page_object_element___is_working_correctly___for_keyboard_returnKeyType_default() {
        checkKeyboardPageObject(
            whenKeyboardIsClosed: { screen in
                screen.keyboard.assertIsNotDisplayed()
            },
            whenKeyboardIsOpened: { screen in
                screen.keyboard.assertIsDisplayed()
            }
        )
    }
    
    // TODO: Check if all cases of UIReturnKeyType are tested, i.e. check if TestCase class has all corresponding methods
    func test___keyboard_return_key_page_object_element___is_working_correctly___for_keyboard_returnKeyType_default() {
        check_keyboard_return_key_page_object_element___is_working_correctly(returnKeyType: .default)
    }
    
    func test___keyboard_return_key_page_object_element___is_working_correctly___for_keyboard_returnKeyType_go() {
        check_keyboard_return_key_page_object_element___is_working_correctly(returnKeyType: .go)
    }
    
    func test___keyboard_return_key_page_object_element___is_working_correctly___for_keyboard_returnKeyType_google() {
        check_keyboard_return_key_page_object_element___is_working_correctly(returnKeyType: .google)
    }
    
    func test___keyboard_return_key_page_object_element___is_working_correctly___for_keyboard_returnKeyType_join() {
        check_keyboard_return_key_page_object_element___is_working_correctly(returnKeyType: .join)
    }
    
    func test___keyboard_return_key_page_object_element___is_working_correctly___for_keyboard_returnKeyType_next() {
        check_keyboard_return_key_page_object_element___is_working_correctly(returnKeyType: .next)
    }
    
    func test___keyboard_return_key_page_object_element___is_working_correctly___for_keyboard_returnKeyType_route() {
        check_keyboard_return_key_page_object_element___is_working_correctly(returnKeyType: .route)
    }
    
    func test___keyboard_return_key_page_object_element___is_working_correctly___for_keyboard_returnKeyType_search() {
        check_keyboard_return_key_page_object_element___is_working_correctly(returnKeyType: .search)
    }
    
    func test___keyboard_return_key_page_object_element___is_working_correctly___for_keyboard_returnKeyType_send() {
        check_keyboard_return_key_page_object_element___is_working_correctly(returnKeyType: .send)
    }
    
    func test___keyboard_return_key_page_object_element___is_working_correctly___for_keyboard_returnKeyType_yahoo() {
        check_keyboard_return_key_page_object_element___is_working_correctly(returnKeyType: .yahoo)
    }
    
    func test___keyboard_return_key_page_object_element___is_working_correctly___for_keyboard_returnKeyType_done() {
        check_keyboard_return_key_page_object_element___is_working_correctly(returnKeyType: .done)
    }
    
    func test___keyboard_return_key_page_object_element___is_working_correctly___for_keyboard_returnKeyType_emergencyCall() {
        check_keyboard_return_key_page_object_element___is_working_correctly(returnKeyType: .emergencyCall)
    }
    
    func test___keyboard_return_key_page_object_element___is_working_correctly___for_keyboard_returnKeyType_continue() {
        check_keyboard_return_key_page_object_element___is_working_correctly(returnKeyType: .continue)
    }
    
    private func check_keyboard_return_key_page_object_element___is_working_correctly(
        returnKeyType: UIReturnKeyType
    ) {
        checkKeyboardPageObject(
            returnKeyType: returnKeyType,
            whenKeyboardIsClosed: { screen in
                screen.returnKeyButton.assertIsNotDisplayed()
            },
            whenKeyboardIsOpened: { screen in
                screen.returnKeyButton.assertIsDisplayed()
            }
        )
    }
    
    private func checkKeyboardPageObject(
        returnKeyType: UIReturnKeyType = .default,
        viewThatCanBeHiddenBelowKeyboard: SoftwareKeyboardTestsViewConfiguration.ViewThatCanBeHiddenBelowKeyboard = .hidden,
        whenKeyboardIsClosed: (SoftwareKeyboardTestsViewPageObject) -> (),
        whenKeyboardIsOpened: (SoftwareKeyboardTestsViewPageObject) -> ()
    ) {
        let screen = screen.uikit
        
        resetUi(
            returnKeyType: returnKeyType,
            viewThatCanBeHiddenBelowKeyboard: viewThatCanBeHiddenBelowKeyboard
        )
        
        screen.statusLabel.withoutTimeout.assertHasText("Initial")
        
        whenKeyboardIsClosed(screen)
        
        screen.textField.withoutTimeout.tap()
        
        whenKeyboardIsOpened(screen)
        
        screen.returnKeyButton.tap()
        
        screen.statusLabel.assertHasText("Resigned")
        
        whenKeyboardIsClosed(screen)
    }
    
    private func resetUi(
        returnKeyType: UIReturnKeyType,
        viewThatCanBeHiddenBelowKeyboard: SoftwareKeyboardTestsViewConfiguration.ViewThatCanBeHiddenBelowKeyboard
    ) {
        resetUi(
            argument: SoftwareKeyboardTestsViewConfiguration(
                returnKeyType: returnKeyType,
                viewThatCanBeHiddenBelowKeyboard: viewThatCanBeHiddenBelowKeyboard
            )
        )
    }
    
    private var screen: MainAppScreen<SoftwareKeyboardTestsViewPageObject> {
        return pageObjects.canTapKeyboardTestsView
    }
}
