import MixboxUiTestsFoundation
import MixboxTestsFoundation
import MixboxFoundation

// TODO: Replace XcuiMenuItemProvider with this implementation after Gray Box tests will be released and well tested.
public final class GrayMenuItemProvider: MenuItemProvider {
    private let elementMatcherBuilder: ElementMatcherBuilder
    private let elementFinder: ElementFinder
    private let elementSimpleGesturesProvider: ElementSimpleGesturesProvider
    private let runLoopSpinnerFactory: RunLoopSpinnerFactory
    
    public init(
        elementMatcherBuilder: ElementMatcherBuilder,
        elementFinder: ElementFinder,
        elementSimpleGesturesProvider: ElementSimpleGesturesProvider,
        runLoopSpinnerFactory: RunLoopSpinnerFactory)
    {
        self.elementMatcherBuilder = elementMatcherBuilder
        self.elementFinder = elementFinder
        self.elementSimpleGesturesProvider = elementSimpleGesturesProvider
        self.runLoopSpinnerFactory = runLoopSpinnerFactory
    }
    
    public func menuItem(possibleTitles: [String]) -> MenuItem {
        return GrayMenuItem(
            possibleTitles: possibleTitles,
            elementFinder: elementFinder,
            elementMatcherBuilder: elementMatcherBuilder,
            elementSimpleGesturesProvider: elementSimpleGesturesProvider,
            runLoopSpinnerFactory: runLoopSpinnerFactory
        )
    }
}
