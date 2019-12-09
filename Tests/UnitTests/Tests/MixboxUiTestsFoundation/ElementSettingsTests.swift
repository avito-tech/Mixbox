@testable import MixboxUiTestsFoundation
import XCTest

final class ElementSettingsTests: TestCase {
    let elementSettings = ElementSettings(
        elementName: "elementName",
        fileLine: .current(),
        function: "function",
        matcher: AlwaysTrueMatcher(),
        searchMode: .scrollUntilFound,
        interactionTimeout: 15,
        interactionMode: .useUniqueElement
    )
    
    func test___with_name___overrides_name() {
        let name = "otherName"
        XCTAssertNotEqual(elementSettings.elementName, name)
        XCTAssertEqual(elementSettings.with(name: name).elementName, name)
    }
    
    func test___with_matcher___overrides_matcher() {
        let matcher = AlwaysFalseMatcher<ElementSnapshot>()
        XCTAssert(type(of: elementSettings.elementName) != type(of: matcher))
        XCTAssert(type(of: elementSettings.with(matcher: matcher).matcher) == type(of: matcher))
    }
    
    func test___with_searchMode___overrides_searchMode() {
        let searchMode = SearchMode.scrollBlindly
        XCTAssertNotEqual(elementSettings.searchMode, searchMode)
        XCTAssertEqual(elementSettings.with(searchMode: searchMode).searchMode, searchMode)
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
