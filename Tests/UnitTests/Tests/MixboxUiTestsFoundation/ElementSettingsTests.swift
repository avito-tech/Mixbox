@testable import MixboxUiTestsFoundation
import XCTest

final class ElementSettingsTests: TestCase {
    let elementSettings = ElementSettings(
        name: "elementName",
        functionDeclarationLocation: FunctionDeclarationLocation(
            fileLine: .current(),
            function: "function"
        ),
        matcher: AlwaysTrueMatcher(),
        scrollMode: .definite,
        interactionTimeout: 15,
        interactionMode: .useUniqueElement
    )
    
    func test___with_name___overrides_name() {
        let name = "otherName"
        XCTAssertNotEqual(elementSettings.name, name)
        XCTAssertEqual(elementSettings.with(name: name).name, name)
    }
    
    func test___with_matcher___overrides_matcher() {
        let matcher = AlwaysFalseMatcher<ElementSnapshot>()
        XCTAssert(type(of: elementSettings.name) != type(of: matcher))
        XCTAssert(type(of: elementSettings.with(matcher: matcher).matcher) == type(of: matcher))
    }
    
    func test___with_scrollMode___overrides_scrollMode() {
        let scrollMode = ScrollMode.blind
        XCTAssertNotEqual(elementSettings.scrollMode, scrollMode)
        XCTAssertEqual(elementSettings.with(scrollMode: scrollMode).scrollMode, scrollMode)
    }
    
    func test___with_interactionMode___overrides_interactionMode() {
        let interactionMode = InteractionMode.useElementAtIndexInHierarchy(42)
        XCTAssertNotEqual(elementSettings.interactionMode, interactionMode)
        XCTAssertEqual(elementSettings.with(interactionMode: interactionMode).interactionMode, interactionMode)
    }
    
    func test___with_interactionTimeout___overrides_interactionTimeout() {
        let interactionTimeout: TimeInterval = 42
        XCTAssertNotEqual(elementSettings.interactionTimeout, interactionTimeout)
        XCTAssertEqual(elementSettings.with(interactionTimeout: interactionTimeout).interactionTimeout, interactionTimeout)
    }
}
