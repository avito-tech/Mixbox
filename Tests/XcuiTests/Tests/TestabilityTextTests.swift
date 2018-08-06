import MixboxUiTestsFoundation
import XCTest

final class TestabilityTextTests: TestCase {
    private var screen: Screen {
        return pageObjects.screen
    }
    
    override func setUp() {
        super.setUp()
        
        openScreen(name: "TextTestsView")
    }
    
    func test_label() {
        screen.element("label_plain_textIsNil")
            .assert.hasText("")
        
        screen.element("label_plain_textIsEmpty")
            .assert.hasText("")
        
        screen.element("label_plain_text==Текст")
            .assert.hasText("Текст")
        
        screen.element("label_attributed_textIsNil")
            .assert.hasText("")
        
        screen.element("label_attributed_textIsEmpty")
            .assert.hasText("")
        
        screen.element("label_attributed_text==Текст")
            .assert.hasText("Текст")
    }
    
    func test_button_normal() {
        screen.element("button_normal_plain_textIsNil")
            .assert.hasText("")
        
        screen.element("button_normal_plain_textIsEmpty")
            .assert.hasText("")
        
        screen.element("button_normal_plain_text==Текст")
            .assert.hasText("Текст")
        
        screen.element("button_normal_attributed_textIsNil")
            .assert.hasText("")
        
        screen.element("button_normal_attributed_textIsEmpty")
            .assert.hasText("")
        
        screen.element("button_normal_attributed_text==Текст")
            .assert.hasText("Текст")
    }
    
    func test_button_disabled() {
        screen.element("button_disabled_plain_textIsNil")
            .assert.hasText("Normal State Text")
        
        // XCUI врет, в accessibilityLabel будет "Normal State Text",
        // хотя должно быть по логике "", и по факту текст не виден
        screen.element("button_disabled_plain_textIsEmpty")
            .assert.hasText("")
        
        screen.element("button_disabled_plain_text==Текст")
            .assert.hasText("Текст")
        
        screen.element("button_disabled_attributed_textIsNil")
            .assert.hasText("Normal State Text")
        
        screen.element("button_disabled_attributed_textIsEmpty")
            .assert.hasText("Normal State Text")
        
        screen.element("button_disabled_attributed_text==Текст")
            .assert.hasText("Текст")
    }
    
    func test_button_selected() {
        screen.element("button_selected_plain_textIsNil")
            .assert.hasText("Normal State Text")
        
        // XCUI врет, в accessibilityLabel будет "Normal State Text",
        // хотя должно быть по логике "", и по факту текст не виден
        screen.element("button_selected_plain_textIsEmpty")
            .assert.hasText("")
        
        screen.element("button_selected_plain_text==Текст")
            .assert.hasText("Текст")
        
        screen.element("button_selected_attributed_textIsNil")
            .assert.hasText("Normal State Text")
        
        screen.element("button_selected_attributed_textIsEmpty")
            .assert.hasText("Normal State Text")
        
        screen.element("button_selected_attributed_text==Текст")
            .assert.hasText("Текст")
    }
    
    func test_textFields() {
        screen.element("textField_text:plain_textIsNil_placeholder:plain_textIsNil")
            .assert.hasText("")
        
        screen.element("textField_text:plain_textIsNil_placeholder:plain_textIsEmpty")
            .assert.hasText("")
        
        screen.element("textField_text:plain_textIsNil_placeholder:plain_text==Плейсхолдер")
            .assert.hasText("Плейсхолдер")
        
        screen.element("textField_text:plain_textIsNil_placeholder:attributed_textIsNil")
            .assert.hasText("")
        
        screen.element("textField_text:plain_textIsNil_placeholder:attributed_textIsEmpty")
            .assert.hasText("")
        
        screen.element("textField_text:plain_textIsNil_placeholder:attributed_text==Плейсхолдер")
            .assert.hasText("Плейсхолдер")
        
        screen.element("textField_text:plain_textIsEmpty_placeholder:plain_textIsNil")
            .assert.hasText("")
        
        screen.element("textField_text:plain_textIsEmpty_placeholder:plain_textIsEmpty")
            .assert.hasText("")
        
        screen.element("textField_text:plain_textIsEmpty_placeholder:plain_text==Плейсхолдер")
            .assert.hasText("Плейсхолдер")
        
        screen.element("textField_text:plain_textIsEmpty_placeholder:attributed_textIsNil")
            .assert.hasText("")
        
        screen.element("textField_text:plain_textIsEmpty_placeholder:attributed_textIsEmpty")
            .assert.hasText("")
        
        screen.element("textField_text:plain_textIsEmpty_placeholder:attributed_text==Плейсхолдер")
            .assert.hasText("Плейсхолдер")
        
        screen.element("textField_text:plain_text==Текст_placeholder:plain_textIsNil")
            .assert.hasText("Текст")
        
        screen.element("textField_text:plain_text==Текст_placeholder:plain_textIsEmpty")
            .assert.hasText("Текст")
        
        screen.element("textField_text:plain_text==Текст_placeholder:plain_text==Плейсхолдер")
            .assert.hasText("Текст")
        
        screen.element("textField_text:plain_text==Текст_placeholder:attributed_textIsNil")
            .assert.hasText("Текст")
        
        screen.element("textField_text:plain_text==Текст_placeholder:attributed_textIsEmpty")
            .assert.hasText("Текст")
        
        screen.element("textField_text:plain_text==Текст_placeholder:attributed_text==Плейсхолдер")
            .assert.hasText("Текст")
        
        screen.element("textField_text:attributed_textIsNil_placeholder:plain_textIsNil")
            .assert.hasText("")
        
        screen.element("textField_text:attributed_textIsNil_placeholder:plain_textIsEmpty")
            .assert.hasText("")
        
        screen.element("textField_text:attributed_textIsNil_placeholder:plain_text==Плейсхолдер")
            .assert.hasText("Плейсхолдер")
        
        screen.element("textField_text:attributed_textIsNil_placeholder:attributed_textIsNil")
            .assert.hasText("")
        
        screen.element("textField_text:attributed_textIsNil_placeholder:attributed_textIsEmpty")
            .assert.hasText("")
        
        screen.element("textField_text:attributed_textIsNil_placeholder:attributed_text==Плейсхолдер")
            .assert.hasText("Плейсхолдер")
        
        screen.element("textField_text:attributed_textIsEmpty_placeholder:plain_textIsNil")
            .assert.hasText("")
        
        screen.element("textField_text:attributed_textIsEmpty_placeholder:plain_textIsEmpty")
            .assert.hasText("")
        
        screen.element("textField_text:attributed_textIsEmpty_placeholder:plain_text==Плейсхолдер")
            .assert.hasText("Плейсхолдер")
        
        screen.element("textField_text:attributed_textIsEmpty_placeholder:attributed_textIsNil")
            .assert.hasText("")
        
        screen.element("textField_text:attributed_textIsEmpty_placeholder:attributed_textIsEmpty")
            .assert.hasText("")
        
        screen.element("textField_text:attributed_textIsEmpty_placeholder:attributed_text==Плейсхолдер")
            .assert.hasText("Плейсхолдер")
        
        screen.element("textField_text:attributed_text==Текст_placeholder:plain_textIsNil")
            .assert.hasText("Текст")
        
        screen.element("textField_text:attributed_text==Текст_placeholder:plain_textIsEmpty")
            .assert.hasText("Текст")
        
        screen.element("textField_text:attributed_text==Текст_placeholder:plain_text==Плейсхолдер")
            .assert.hasText("Текст")
        
        screen.element("textField_text:attributed_text==Текст_placeholder:attributed_textIsNil")
            .assert.hasText("Текст")
        
        screen.element("textField_text:attributed_text==Текст_placeholder:attributed_textIsEmpty")
            .assert.hasText("Текст")
        
        screen.element("textField_text:attributed_text==Текст_placeholder:attributed_text==Плейсхолдер")
            .assert.hasText("Текст")
    }
    
    func test_textViews() {
        screen.element("textView_plain_textIsNil")
            .assert.hasText("")
        
        screen.element("textView_plain_textIsEmpty")
            .assert.hasText("")
        
        screen.element("textView_plain_text==Текст")
            .assert.hasText("Текст")
        
        screen.element("textView_attributed_textIsNil")
            .assert.hasText("")
        
        screen.element("textView_attributed_textIsEmpty")
            .assert.hasText("")
        
        screen.element("textView_attributed_text==Текст")
            .assert.hasText("Текст")
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
