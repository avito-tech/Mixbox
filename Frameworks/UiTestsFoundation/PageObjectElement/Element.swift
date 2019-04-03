import MixboxTestsFoundation

// Page Object Element
// TODO: Names are MESS!!!! I think we should separate different layers of abstractions to different modules.
// `Element` is page object element for tests.
// `PageObjectElement` is page object element for Mixbox internals.
public protocol Element: class {
    var implementation: PageObjectElement { get }
    
    func with(settings: ElementSettings) -> Self
}

extension Element {
    public var any: Self {
        return atIndex(0)
    }
    
    public var unique: Self {
        return with(interactionMode: .useUniqueElement)
    }
    
    // Возможное расширение:
    // var every: Self {
    //     return with(interactionMode: .useEveryElement)
    // }
    
    public func atIndex(_ index: Int) -> Self {
        return with(interactionMode: .useElementAtIndexInHierarchy(index))
    }
    
    public var currentlyVisible: Self {
        return with(searchMode: .useCurrentlyVisible)
    }
    
    public var withoutTimeout: Self {
        return with(searchTimeout: 0)
    }
    
    public func withTimeout(_ timeout: TimeInterval) -> Self {
        return with(searchTimeout: timeout)
    }
    
    // Возможное расширение.
    // var count: Int {
    //     ...
    // }
    
    public func matching(_ additional: ElementMatcher) -> Self {
        let old = implementation.settings.matcher
        return with(matcher: old && additional)
    }
    
    public func with(name: String) -> Self {
        return with(settings: implementation.settings.with(name: name))
    }
    
    public func with(matcher: ElementMatcher) -> Self {
        return with(settings: implementation.settings.with(matcher: matcher))
    }
    
    public func with(searchMode: SearchMode) -> Self {
        return with(settings: implementation.settings.with(searchMode: searchMode))
    }
    
    public func with(interactionMode: InteractionMode) -> Self {
        return with(settings: implementation.settings.with(interactionMode: interactionMode))
    }
    
    public func with(searchTimeout: TimeInterval?) -> Self {
        return with(settings: implementation.settings.with(searchTimeout: searchTimeout))
    }
}
