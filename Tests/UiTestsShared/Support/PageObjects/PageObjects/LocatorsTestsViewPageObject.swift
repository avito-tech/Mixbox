import MixboxUiTestsFoundation
import TestsIpc

public final class LocatorsTestsViewPageObject: BasePageObjectWithDefaultInitializer, OpenableScreen {
    public let viewName = "LocatorsTestsView"
    
    public func element<T: ElementWithDefaultInitializer>(matcherBuilder: ElementMatcherBuilderClosure) -> T {
        return element("element-without-description", matcherBuilder: matcherBuilder)
    }
}
