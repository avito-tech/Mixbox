@testable import MixboxUiTestsFoundation
import MixboxTestsFoundation
import XCTest

final class ElementSettingsTests: TestCase {
    let elementSettings = ElementSettings(
        name: "elementName",
        functionDeclarationLocation: FunctionDeclarationLocation(
            fileLine: .current(),
            function: "function"
        ),
        matcher: AlwaysTrueMatcher(),
        elementSettingsDefaults: ElementSettingsDefaults(
            scrollMode: .none,
            interactionTimeout: 1337,
            interactionMode: .useElementAtIndexInHierarchy(1337),
            percentageOfVisibleArea: 0.1337,
            pixelPerfectVisibilityCheck: false
        ),
        scrollMode: .definite,
        interactionTimeout: 421337,
        interactionMode: .useElementAtIndexInHierarchy(421337),
        percentageOfVisibleArea: 0.421337,
        pixelPerfectVisibilityCheck: false
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
    
    func test___with_percentageOfVisibleArea___overrides_percentageOfVisibleArea() {
        let percentageOfVisibleArea: CGFloat = 0.43
        XCTAssertNotEqual(elementSettings.percentageOfVisibleArea, percentageOfVisibleArea)
        XCTAssertEqual(elementSettings.with(percentageOfVisibleArea: percentageOfVisibleArea).percentageOfVisibleArea, percentageOfVisibleArea)
    }
    
    func test___with_pixelPerfectVisibilityCheck___overrides_pixelPerfectVisibilityCheck() {
        let pixelPerfectVisibilityCheck: Bool = true
        XCTAssertNotEqual(elementSettings.pixelPerfectVisibilityCheck, pixelPerfectVisibilityCheck)
        XCTAssertEqual(elementSettings.with(pixelPerfectVisibilityCheck: pixelPerfectVisibilityCheck).pixelPerfectVisibilityCheck, pixelPerfectVisibilityCheck)
    }
}
