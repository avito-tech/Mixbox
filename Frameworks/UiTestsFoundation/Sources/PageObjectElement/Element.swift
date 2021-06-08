import MixboxTestsFoundation

public protocol Element: AnyObject {
    var core: PageObjectElementCore { get }
    
    func with(settings: ElementSettings) -> Self
}

extension Element {
    public var with: FieldBuilder<SubstructureFieldBuilderCallImplementation<Self, ElementSettings.CustomizedSettings>> {
        return FieldBuilder(
            callImplementation: SubstructureFieldBuilderCallImplementation(
                structure: self,
                getSubstructure: { $0.core.settings.customizedSettings },
                getResult: { structure, substructure in
                    structure.with(settings: structure.core.settings.with(customizedSettings: substructure))
                }
            )
        )
    }
    
    public var any: Self {
        return atIndex(0)
    }
    
    public var unique: Self {
        return with(interactionMode: .useUniqueElement)
    }
    
    // Possible extension:
    //
    // var every: Self {
    //     return with(interactionMode: .useEveryElement)
    // }
    //
    // var count: Int {
    //     ...
    // }
    
    public func atIndex(_ index: Int) -> Self {
        return with(interactionMode: .useElementAtIndexInHierarchy(index))
    }
    
    public var withoutScrolling: Self {
        return with(scrollMode: .none)
    }
    
    public var withoutTimeout: Self {
        return with(interactionTimeout: 0)
    }
    
    public func withTimeout(_ timeout: TimeInterval) -> Self {
        return with(interactionTimeout: timeout)
    }
    
    public func matching(_ additional: ElementMatcher) -> Self {
        let old = core.settings.matcher
        return with(matcher: old && additional)
    }
    
    // Backward compatibility:
    
    public func with(name: String) -> Self {
        return with.name(name)
    }
    
    public func with(matcher: ElementMatcher) -> Self {
        return with.matcher(matcher)
    }
    
    public func with(scrollMode: ScrollMode) -> Self {
        return with.scrollMode(.customized(scrollMode))
    }
    
    public func with(interactionMode: InteractionMode) -> Self {
        return with.interactionMode(.customized(interactionMode))
    }
    
    public func with(interactionTimeout: TimeInterval?) -> Self {
        return with.interactionTimeout(.from(optional: interactionTimeout))
    }
    
    public func with(percentageOfVisibleArea: CGFloat) -> Self {
        return with.percentageOfVisibleArea(.customized(percentageOfVisibleArea))
    }
    
    public func with(pixelPerfectVisibilityCheck: Bool) -> Self {
        return with.pixelPerfectVisibilityCheck(.customized(pixelPerfectVisibilityCheck))
    }
}
