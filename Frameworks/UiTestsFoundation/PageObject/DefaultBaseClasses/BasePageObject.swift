// You can use this class in your tests.
//
// Consider using your own base class if you want to customize dependencies of your page objects.
//
// Consider moving most of the logic to a base class to minimize amount of code in your page objects.
// For example, use `BasePageObjectWithDefaultInitializer` to not write initializer in your page objects.
// It is much easier to read your page objects code if it contains only declarations of elements.
//
// Example of customization & clean interface with only elements:
//
// public final class Keyboard: BasePageObjectWithDefaultInitializer {
//     public var doneButton: ButtonElement {
//         return mainApplication.element("Done button in keyboard") { element in
//             element.id == "doneButton"
//         }
//     }
//
//     public var accessoryViewDoneButton: ButtonElement {
//         return additionalApplication.element("Done button in accessory view of keyboard") { element in
//             element.id == "accessoryViewDoneButton"
//         }
//     }
// }
//
// In this example custom dependencies are used (`mainApplication`, `additionalApplication`).
// Note that you can defining separate `ElementFactory` for separate applications.
// Such customization is used in tests for Avito app.
//
// TODO: Add default base class called `BasePageObjects`?
// TODO: Actually this class can not be used in a real project if `elementFactory` is polymorphic. Invent a way for this case.
//
open class BasePageObject: PageObject, ElementFactory {
    private let elementFactory: ElementFactory
    
    public init(pageObjectDependenciesFactory: PageObjectDependenciesFactory) {
        self.elementFactory = ElementFactoryImpl(
            pageObjectElementDependenciesFactory: pageObjectDependenciesFactory.pageObjectElementDependenciesFactory(),
            elementSettingsDefaultsProvider: pageObjectDependenciesFactory.elementSettingsDefaultsProvider
        )
    }
    
    // MARK: - ElementFactory
    
    public func element<T>(
        name: String,
        factory: (PageObjectElementCore) -> T,
        functionDeclarationLocation: FunctionDeclarationLocation,
        matcherBuilder: ElementMatcherBuilderClosure)
        -> T
    {
        return elementFactory.element(
            name: name,
            factory: factory,
            functionDeclarationLocation: functionDeclarationLocation,
            matcherBuilder: matcherBuilder
        )
    }
    
    public func with(scrollMode: ScrollMode?) -> ElementFactory {
        return elementFactory.with(scrollMode: scrollMode)
    }
    
    public func with(interactionMode: InteractionMode?) -> ElementFactory {
        return elementFactory.with(interactionMode: interactionMode)
    }
    
    public func with(interactionTimeout: TimeInterval?) -> ElementFactory {
        return elementFactory.with(interactionTimeout: interactionTimeout)
    }
    
    public func with(percentageOfVisibleArea: CGFloat?) -> ElementFactory {
        return elementFactory.with(percentageOfVisibleArea: percentageOfVisibleArea)
    }
    
    public func with(pixelPerfectVisibilityCheck: Bool?) -> ElementFactory {
        return elementFactory.with(pixelPerfectVisibilityCheck: pixelPerfectVisibilityCheck)
    }
}
