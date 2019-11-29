import MixboxInAppServices
import MixboxUiTestsFoundation
import TestsIpc
import XCTest
import MixboxIpc
@testable import TestedApp

// This test checks if injected keyboard events actually results in some text in UITextView.
// I think there is no reason to test other input view types, other than UITextView.
final class KeyboardEventInjectorImplTests: TestCase {
    override func precondition() {
        super.precondition()
        
        openScreen(pageObjects.keyboardEventInjectorImplTestsView)
            .waitUntilViewIsLoaded()
    }
    
    private var textView: InputElement {
        return pageObjects.keyboardEventInjectorImplTestsView.default.textView
    }
    
    func test___inject___can_inject_keyboard_event() {
        resetUi()
        gainFocus()
        
        inject { press in
            press.a()
        }
        
        textView.assertHasText("a")
    }
    
    func test___inject___can_inject_keyboard_event_with_modifiers() {
        resetUi()
        gainFocus()
        
        let text = "pasted text"
        
        UIPasteboard.general.string = text
        
        inject { press in
            press.command(press.a()) + press.command(press.v())
        }
        
        textView.assertHasText(text)
    }
    
    private func gainFocus() {
        textView.tap()
        
        textView.assertMatches { element in
            element.customValues["isFocused"] == true
        }
    }
    
    private func inject(
        builder: (KeyboardEventBuilder) -> [KeyboardEventBuilder.Key])
    {
        // `keyboardEventInjector` is kind of a singleton here.
        // Because it contains swizzling, so it should be only instance in the app.
        
        guard let delegate = UIApplication.shared.delegate else {
            XCTFail("UIApplication.shared.delegate is nil. application: \(UIApplication.shared)")
            return
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            XCTFail("UIApplication.shared.delegate is not AppDelegate: \(delegate)")
            return
        }
        
        guard let keyboardEventInjector = appDelegate.keyboardEventInjector else {
            XCTFail("keyboardEventInjector in app delegate is nil. app delegate: \(appDelegate)")
            return
        }
        
        assertDoesntThrow {
            try keyboardEventInjector.inject(builder: builder)
        }
    }
    
    // TODO: This code is copypasted. Reuse it.
    private func resetUi() {
        do {
            try ipcClient.callOrFail(method: ResetUiIpcMethod<IpcVoid>()).getVoidReturnValue()
        } catch {
            XCTFail("Error calling ResetUiIpcMethod: \(error)")
        }
    }
}
