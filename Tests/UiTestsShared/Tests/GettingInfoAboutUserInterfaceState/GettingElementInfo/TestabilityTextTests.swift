import MixboxUiTestsFoundation
import XCTest

final class TestabilityTextTests: TestCase {
    private var screen: Screen {
        return pageObjects.screen
    }
    
    override func precondition() {
        super.precondition()
        
        openScreen(name: "TextTestsView")
    }
    
    func test_label() {
        screen.element("label_plain_textIsNil")
            .assertHasText("")
        
        screen.element("label_plain_textIsEmpty")
            .assertHasText("")
        
        screen.element("label_plain_text==Текст")
            .assertHasText("Текст")
        
        screen.element("label_attributed_textIsNil")
            .assertHasText("")
        
        screen.element("label_attributed_textIsEmpty")
            .assertHasText("")
        
        screen.element("label_attributed_text==Текст")
            .assertHasText("Текст")
    }
    
    func test_button_normal() {
        screen.element("button_normal_plain_textIsNil")
            .assertHasText("")
        
        screen.element("button_normal_plain_textIsEmpty")
            .assertHasText("")
        
        screen.element("button_normal_plain_text==Текст")
            .assertHasText("Текст")
        
        screen.element("button_normal_attributed_textIsNil")
            .assertHasText("")
        
        screen.element("button_normal_attributed_textIsEmpty")
            .assertHasText("")
        
        screen.element("button_normal_attributed_text==Текст")
            .assertHasText("Текст")
    }
    
    func test_button_disabled() {
        screen.element("button_disabled_plain_textIsNil")
            .assertHasText("Normal State Text")
        
        // Note: in XCUI accessibilityLabel will contain "Normal State Text",
        // which is wrong, it should be "", because text is not visible in this state.
        screen.element("button_disabled_plain_textIsEmpty")
            .assertHasText("")
        
        screen.element("button_disabled_plain_text==Текст")
            .assertHasText("Текст")
        
        screen.element("button_disabled_attributed_textIsNil")
            .assertHasText("Normal State Text")
        
        screen.element("button_disabled_attributed_textIsEmpty")
            .assertHasText("Normal State Text")
        
        screen.element("button_disabled_attributed_text==Текст")
            .assertHasText("Текст")
    }
    
    func test_button_selected() {
        screen.element("button_selected_plain_textIsNil")
            .assertHasText("Normal State Text")
        
        // Note: in XCUI accessibilityLabel will contain "Normal State Text",
        // which is wrong, it should be "", because text is not visible in this state.
        screen.element("button_selected_plain_textIsEmpty")
            .assertHasText("")
        
        screen.element("button_selected_plain_text==Текст")
            .assertHasText("Текст")
        
        screen.element("button_selected_attributed_textIsNil")
            .assertHasText("Normal State Text")
        
        screen.element("button_selected_attributed_textIsEmpty")
            .assertHasText("Normal State Text")
        
        screen.element("button_selected_attributed_text==Текст")
            .assertHasText("Текст")
    }
    
    // swiftlint:disable:next function_body_length
    func test_textFields() {
        screen.element("textField_text:plain_textIsNil_placeholder:plain_textIsNil")
            .assertHasText("")
        
        screen.element("textField_text:plain_textIsNil_placeholder:plain_textIsEmpty")
            .assertHasText("")
        
        screen.element("textField_text:plain_textIsNil_placeholder:plain_text==Плейсхолдер")
            .assertHasText("Плейсхолдер")
        
        screen.element("textField_text:plain_textIsNil_placeholder:attributed_textIsNil")
            .assertHasText("")
        
        screen.element("textField_text:plain_textIsNil_placeholder:attributed_textIsEmpty")
            .assertHasText("")
        
        screen.element("textField_text:plain_textIsNil_placeholder:attributed_text==Плейсхолдер")
            .assertHasText("Плейсхолдер")
        
        screen.element("textField_text:plain_textIsEmpty_placeholder:plain_textIsNil")
            .assertHasText("")
        
        screen.element("textField_text:plain_textIsEmpty_placeholder:plain_textIsEmpty")
            .assertHasText("")
        
        screen.element("textField_text:plain_textIsEmpty_placeholder:plain_text==Плейсхолдер")
            .assertHasText("Плейсхолдер")
        
        screen.element("textField_text:plain_textIsEmpty_placeholder:attributed_textIsNil")
            .assertHasText("")
        
        screen.element("textField_text:plain_textIsEmpty_placeholder:attributed_textIsEmpty")
            .assertHasText("")
        
        screen.element("textField_text:plain_textIsEmpty_placeholder:attributed_text==Плейсхолдер")
            .assertHasText("Плейсхолдер")
        
        screen.element("textField_text:plain_text==Текст_placeholder:plain_textIsNil")
            .assertHasText("Текст")
        
        screen.element("textField_text:plain_text==Текст_placeholder:plain_textIsEmpty")
            .assertHasText("Текст")
        
        screen.element("textField_text:plain_text==Текст_placeholder:plain_text==Плейсхолдер")
            .assertHasText("Текст")
        
        screen.element("textField_text:plain_text==Текст_placeholder:attributed_textIsNil")
            .assertHasText("Текст")
        
        screen.element("textField_text:plain_text==Текст_placeholder:attributed_textIsEmpty")
            .assertHasText("Текст")
        
        screen.element("textField_text:plain_text==Текст_placeholder:attributed_text==Плейсхолдер")
            .assertHasText("Текст")
        
        screen.element("textField_text:attributed_textIsNil_placeholder:plain_textIsNil")
            .assertHasText("")
        
        screen.element("textField_text:attributed_textIsNil_placeholder:plain_textIsEmpty")
            .assertHasText("")
        
        screen.element("textField_text:attributed_textIsNil_placeholder:plain_text==Плейсхолдер")
            .assertHasText("Плейсхолдер")
        
        screen.element("textField_text:attributed_textIsNil_placeholder:attributed_textIsNil")
            .assertHasText("")
        
        screen.element("textField_text:attributed_textIsNil_placeholder:attributed_textIsEmpty")
            .assertHasText("")
        
        screen.element("textField_text:attributed_textIsNil_placeholder:attributed_text==Плейсхолдер")
            .assertHasText("Плейсхолдер")
        
        screen.element("textField_text:attributed_textIsEmpty_placeholder:plain_textIsNil")
            .assertHasText("")
        
        screen.element("textField_text:attributed_textIsEmpty_placeholder:plain_textIsEmpty")
            .assertHasText("")
        
        screen.element("textField_text:attributed_textIsEmpty_placeholder:plain_text==Плейсхолдер")
            .assertHasText("Плейсхолдер")
        
        screen.element("textField_text:attributed_textIsEmpty_placeholder:attributed_textIsNil")
            .assertHasText("")
        
        screen.element("textField_text:attributed_textIsEmpty_placeholder:attributed_textIsEmpty")
            .assertHasText("")
        
        screen.element("textField_text:attributed_textIsEmpty_placeholder:attributed_text==Плейсхолдер")
            .assertHasText("Плейсхолдер")
        
        screen.element("textField_text:attributed_text==Текст_placeholder:plain_textIsNil")
            .assertHasText("Текст")
        
        screen.element("textField_text:attributed_text==Текст_placeholder:plain_textIsEmpty")
            .assertHasText("Текст")
        
        screen.element("textField_text:attributed_text==Текст_placeholder:plain_text==Плейсхолдер")
            .assertHasText("Текст")
        
        screen.element("textField_text:attributed_text==Текст_placeholder:attributed_textIsNil")
            .assertHasText("Текст")
        
        screen.element("textField_text:attributed_text==Текст_placeholder:attributed_textIsEmpty")
            .assertHasText("Текст")
        
        screen.element("textField_text:attributed_text==Текст_placeholder:attributed_text==Плейсхолдер")
            .assertHasText("Текст")
    }
    
    func test_textViews() {
        screen.element("textView_plain_textIsNil")
            .assertHasText("")
        
        screen.element("textView_plain_textIsEmpty")
            .assertHasText("")
        
        screen.element("textView_plain_text==Текст")
            .assertHasText("Текст")
        
        screen.element("textView_attributed_textIsNil")
            .assertHasText("")
        
        screen.element("textView_attributed_textIsEmpty")
            .assertHasText("")
        
        screen.element("textView_attributed_text==Текст")
            .assertHasText("Текст")
    }
}

private final class Screen: BasePageObjectWithDefaultInitializer {
    func element(_ id: String) -> LabelElement {
        return element("label \(id)") { element in element.id == id }
    }
}

private extension PageObjects {
    var screen: Screen {
        return pageObject()
    }
}
