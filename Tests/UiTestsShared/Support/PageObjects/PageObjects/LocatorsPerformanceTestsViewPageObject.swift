import MixboxUiTestsFoundation

public final class LocatorsPerformanceTestsViewPageObject: BasePageObjectWithDefaultInitializer, OpenableScreen {
    public let viewName = "LocatorsPerformanceTestsView"
    
    public func element(path: [Int]) -> LabelElement {
        return element("element with locator with a lot of isSubviewOf matchers") { elementMatcherBuilder in
            matcher(elementMatcherBuilder: elementMatcherBuilder, path: path)
        }
    }
    
    public func element(pathLength: Int, repeatingPathComponent: Int) -> LabelElement {
        return element(path: Array(repeating: repeatingPathComponent, count: pathLength))
    }
    
    private func matcher(elementMatcherBuilder: ElementMatcherBuilder, path: [Int]) -> ElementMatcher {
        guard let pathLast = path.last else {
            return AlwaysTrueMatcher()
        }
        
        let idMatcher = elementMatcherBuilder.id == "\(pathLast)"
        
        if path.count > 1 {
            return idMatcher && elementMatcherBuilder.isSubviewOf { _ in
                matcher(elementMatcherBuilder: elementMatcherBuilder, path: path.dropLast())
            }
        } else {
            return idMatcher
        }
    }
}
