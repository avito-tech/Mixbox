import MixboxUiTestsFoundation
import MixboxTestsFoundation
import XCTest
import TestsIpc
import UIKit

final class CanTapKeyboardTests: TestCase {
    override func precondition() {
        super.precondition()
        
        open(screen: screen)
            .waitUntilViewIsLoaded()
    }
    
    // TODO: Ideally we want to check element directly.
    func test___keyboard_page_object_element___is_working_correctly___for_keyboard_returnKeyType_default() {
        checkKeyboardPageObject(
            returnKeyType: .default,
            whenKeyboardIsClosed: { screen in
                screen.keyboard.assertIsNotDisplayed()
            },
            whenKeyboardIsOpened: { screen in
                screen.keyboard.assertIsDisplayed()
            }
        )
    }
    
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
        returnKeyType: UIReturnKeyType,
        whenKeyboardIsClosed: (CanTapKeyboardTestsViewPageObject) -> (),
        whenKeyboardIsOpened: (CanTapKeyboardTestsViewPageObject) -> ()
    ) {
        let screen = screen.uikit
        
        resetUi(returnKeyType: returnKeyType)
        
        screen.statusLabel.assertHasText("Initial")
        
        whenKeyboardIsClosed(screen)
        
        screen.textField.tap()
        
        whenKeyboardIsOpened(screen)
        
        screen.returnKeyButton.tap()
        
        screen.statusLabel.assertHasText("Resigned")
        
        whenKeyboardIsClosed(screen)
    }
    
    private func resetUi(returnKeyType: UIReturnKeyType) {
        resetUi(
            argument: CanTapKeyboardTestsViewConfiguration(
                returnKeyType: returnKeyType
            )
        )
    }
    
    private var screen: MainAppScreen<CanTapKeyboardTestsViewPageObject> {
        return pageObjects.canTapKeyboardTestsView
    }
}
