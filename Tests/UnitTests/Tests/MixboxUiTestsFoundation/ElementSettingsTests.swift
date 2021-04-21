@testable import MixboxUiTestsFoundation
import MixboxTestsFoundation
import XCTest
import MixboxBuiltinDi

// Integrational test. Tests that `with` builders work and that
// their usage in making an interaction affects interaction settings correctly.
final class ElementSettingsTests: TestCase {
    // This test is long tests logic, while other tests
    // just ensure that the logic is applied properly to other fields
    // (other tests assumes that the logic is correct and is same for every customizable field)
    //
    // swiftlint:disable:next function_body_length
    func test___interactionTimeout() {
        // If nothing is overriden, use default.
        XCTAssertEqual(
            elementFactory
                .makeElement
                .interactionSettings.interactionTimeout,
            1337
        )
        
        // Usage element factory modifier
        XCTAssertEqual(
            elementFactory.with.interactionTimeout(1)
                .makeElement
                .interactionSettings.interactionTimeout,
            1
        )
        
        // Usage of element modifier
        XCTAssertEqual(
            elementFactory
                .makeElement.with.interactionTimeout(2)
                .interactionSettings.interactionTimeout,
            2
        )
        
        // Element modifiers have higher priority
        XCTAssertEqual(
            elementFactory.with.interactionTimeout(1)
                .makeElement.with.interactionTimeout(2)
                .interactionSettings.interactionTimeout,
            2
        )
        
        // Element factory modifiers can be overriden
        XCTAssertEqual(
            elementFactory.with.interactionTimeout(1).with.interactionTimeout(2)
                .makeElement
                .interactionSettings.interactionTimeout,
            2
        )
        
        // Element modifiers can be overriden
        XCTAssertEqual(
            elementFactory.with.interactionTimeout(1)
                .makeElement.with.interactionTimeout(2).with.interactionTimeout(3)
                .interactionSettings.interactionTimeout,
            3
        )
        
        // `.automatic` setting in element modifier will do nothing here
        XCTAssertEqual(
            elementFactory.with.interactionTimeout(1)
                .makeElement.with.interactionTimeout(.automatic)
                .interactionSettings.interactionTimeout,
            1
        )
        
        // `.automatic` setting in element modifier will override
        // previous element modifier and fall back to previous level of modifiers.
        XCTAssertEqual(
            elementFactory.with.interactionTimeout(1)
                .makeElement.with.interactionTimeout(2).with.interactionTimeout(.automatic)
                .interactionSettings.interactionTimeout,
            1
        )
        
        XCTAssertEqual(
            elementFactory.with.interactionTimeout(1).with.interactionTimeout(.automatic)
                .makeElement
                .interactionSettings.interactionTimeout,
            1337
        )
    }
    
    func test___interactionMode() {
        XCTAssertEqual(
            elementFactory.with.interactionMode(.useElementAtIndexInHierarchy(1))
                .makeElement.with.interactionMode(.useElementAtIndexInHierarchy(2))
                .interactionSettings.interactionMode,
            InteractionMode.useElementAtIndexInHierarchy(2)
        )
    }
    
    func test___percentageOfVisibleArea() {
        XCTAssertEqual(
            elementFactory.with.percentageOfVisibleArea(1)
                .makeElement.with.percentageOfVisibleArea(2)
                .interactionSettings.percentageOfVisibleArea,
            2
        )
    }
    
    func test___pixelPerfectVisibilityCheck() {
        XCTAssertEqual(
            elementFactory.with.pixelPerfectVisibilityCheck(true)
                .makeElement.with.pixelPerfectVisibilityCheck(false)
                .interactionSettings.pixelPerfectVisibilityCheck,
            false
        )
    }
    
    func test___scrollMode() {
        XCTAssertEqual(
            elementFactory.with.scrollMode(.blind)
                .makeElement.with.scrollMode(.definite)
                .interactionSettings.scrollMode,
            .definite
        )
    }
    
    // MARK: - Support
    
    let pageObjectDependenciesFactory = MockPageObjectDependenciesFactory()
    
    lazy var elementFactory = ElementFactoryImpl(
        pageObjectDependenciesFactory: pageObjectDependenciesFactory
    )
    
    override var reuseState: Bool {
        false
    }
    
    override func precondition() {
        super.precondition()
        
        let di = BuiltinDependencyInjection()
        
        di.register(type: InteractionSettingsDefaultsProvider.self) { _ in
            InteractionSettingsDefaultsProviderImpl()
        }
        di.register(type: PageObjectElementCoreFactory.self) { _ in
            PageObjectElementCoreFactoryImpl()
        }
        di.register(type: ElementMatcherBuilder.self) { [mocks] _ in
            ElementMatcherBuilder(
                screenshotTaker: mocks.register(MockScreenshotTaker()),
                snapshotsDifferenceAttachmentGenerator: mocks.register(MockSnapshotsDifferenceAttachmentGenerator()),
                snapshotsComparatorFactory: mocks.register(MockSnapshotsComparatorFactory())
            )
        }
        
        pageObjectDependenciesFactory.stub().di.get().thenReturn(
            MixboxDiTestFailingDependencyResolver(
                dependencyResolver: di
            )
        )
    }
}

private extension ElementFactory {
    var makeElement: ViewElement {
        return element("element", matcherBuilder: { _ in AlwaysTrueMatcher() })
    }
}

private extension BaseElement {
    var interactionSettings: InteractionSettings {
        return core.settings.interactionSettings(interaction: IsNotDisplayedCheck())
    }
}

private class InteractionSettingsDefaultsProviderImpl: InteractionSettingsDefaultsProvider {
    func interactionSettingsDefaults(interaction: ElementInteraction) -> InteractionSettingsDefaults {
        return InteractionSettingsDefaults(
            scrollMode: .none,
            interactionTimeout: 1337,
            interactionMode: .useElementAtIndexInHierarchy(1337),
            percentageOfVisibleArea: 0.1337,
            pixelPerfectVisibilityCheck: false
        )
    }
}

private class PageObjectElementCoreFactoryImpl: PageObjectElementCoreFactory {
    func pageObjectElementCore(settings: ElementSettings) -> PageObjectElementCore {
        PageObjectElementCoreImpl(
            settings: settings,
            interactionPerformer: PageObjectElementInteractionPerformerImpl()
        )
    }
}

private class PageObjectElementInteractionPerformerImpl: PageObjectElementInteractionPerformer {
    func perform(interaction: ElementInteraction, interactionPerformingSettings: InteractionPerformingSettings) -> InteractionResult {
        return .success
    }

    func with(settings: ElementSettings) -> PageObjectElementInteractionPerformer {
        return self
    }
}
